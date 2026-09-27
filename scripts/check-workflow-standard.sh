#!/usr/bin/env bash
# check-workflow-standard.sh -- enforce docs/WORKFLOW-STANDARD.md on GitHub
# Actions workflow files.
#
# Usage: check-workflow-standard.sh [--strict] [--exceptions FILE] [PATH ...]
#   PATH        workflow files or directories (default: .github/workflows)
#   --strict    treat warnings as failures
#   --exceptions FILE
#               waiver list, one "<path> <RULE>" per line, '#' comments allowed.
#               A waived finding is reported as WAIVED and does not fail.
#
# Required (FAIL):
#   concurrency   top-level concurrency, or on every job. Not required when the
#                 only trigger is workflow_call: the caller owns concurrency.
#   permissions   top-level permissions, or on every job.
#   timeout       timeout-minutes on every job that has steps. Jobs that call a
#                 reusable workflow (`uses:`) cannot set it and are skipped.
# Advisory (WARN, FAIL with --strict):
#   pin           third-party action not pinned to a full commit SHA
#                 (actions/*, github/* and this org's own workflows may use a tag)
#   push-branches push trigger with no branches/tags filter
#   noisy-trigger issue_comment, or a `labeled` type, on a job with no `if:`
#   prt-checkout  pull_request_target workflow checks out the PR head
#   cache         setup-node / setup-python step with no cache
#
# Exit: 0 clean (or only warnings/waivers), 1 failures, 2 usage/tool error.
# Requires mikefarah yq v4 (preinstalled on GitHub-hosted Ubuntu runners).

set -uo pipefail

ORG="Gray-Ghost-Data-Consultants-LLC"
strict=0
exceptions=""
paths=()

while [ $# -gt 0 ]; do
  case "$1" in
    --strict) strict=1 ;;
    --exceptions) shift; exceptions="${1:-}" ;;
    -h|--help) sed -n '2,29p' "$0"; exit 0 ;;
    *) paths+=("$1") ;;
  esac
  shift
done
[ ${#paths[@]} -eq 0 ] && paths=(.github/workflows)

if ! yq --version 2>/dev/null | grep -q mikefarah; then
  echo "error: needs mikefarah yq v4 (https://github.com/mikefarah/yq); found: $(yq --version 2>&1 | head -1)" >&2
  exit 2
fi
if [ -n "$exceptions" ] && [ ! -f "$exceptions" ]; then
  echo "error: exceptions file not found: $exceptions" >&2
  exit 2
fi

files=()
for p in "${paths[@]}"; do
  if [ -d "$p" ]; then
    while IFS= read -r f; do files+=("$f"); done < <(find "$p" -maxdepth 1 -type f \( -name '*.yml' -o -name '*.yaml' \) | sort)
  elif [ -f "$p" ]; then
    files+=("$p")
  else
    echo "error: no such file or directory: $p" >&2
    exit 2
  fi
done

fails=0
warns=0
waived=0
checked=0

is_waived() { # $1=file $2=rule
  [ -n "$exceptions" ] || return 1
  sed 's/#.*//' "$exceptions" | awk -v f="$1" -v r="$2" '$1==f && $2==r {found=1} END {exit !found}'
}

report() { # $1=level $2=file $3=rule $4=message
  local level="$1" file="$2" rule="$3" msg="$4"
  if is_waived "$file" "$rule"; then
    echo "WAIVED $file [$rule] $msg"
    waived=$((waived + 1))
    return
  fi
  if [ "$level" = WARN ] && [ "$strict" -eq 1 ]; then level=FAIL; fi
  echo "$level   $file [$rule] $msg"
  if [ "${GITHUB_ACTIONS:-}" = true ]; then
    if [ "$level" = FAIL ]; then echo "::error file=$file,title=workflow-standard $rule::$msg"
    else echo "::warning file=$file,title=workflow-standard $rule::$msg"; fi
  fi
  if [ "$level" = FAIL ]; then fails=$((fails + 1)); else warns=$((warns + 1)); fi
}

for f in "${files[@]}"; do
  if ! yq -e '.jobs' "$f" >/dev/null 2>&1; then
    echo "SKIP   $f (no jobs: not a workflow)"
    continue
  fi
  checked=$((checked + 1))

  triggers=$(yq -r '.on | (select(tag == "!!map") | keys | .[]), (select(tag == "!!seq") | .[]), (select(tag == "!!str"))' "$f" | sort -u)
  only_call=0
  [ "$triggers" = "workflow_call" ] && only_call=1

  # --- concurrency -----------------------------------------------------------
  if [ "$only_call" -eq 0 ]; then
    if [ "$(yq '.concurrency != null' "$f")" != true ]; then
      missing=$(yq -r '.jobs | to_entries | .[] | select(.value.concurrency == null) | .key' "$f" | tr '\n' ' ')
      [ -n "$missing" ] && report FAIL "$f" concurrency "no top-level concurrency; jobs without one: $missing"
    fi
  fi

  # --- permissions -----------------------------------------------------------
  if [ "$(yq '.permissions != null' "$f")" != true ]; then
    missing=$(yq -r '.jobs | to_entries | .[] | select(.value.permissions == null) | .key' "$f" | tr '\n' ' ')
    [ -n "$missing" ] && report FAIL "$f" permissions "no top-level permissions; jobs without one: $missing"
  fi

  # --- timeout-minutes -------------------------------------------------------
  missing=$(yq -r '.jobs | to_entries | .[] | select(.value.steps != null and .value["timeout-minutes"] == null) | .key' "$f" | tr '\n' ' ')
  [ -n "$missing" ] && report FAIL "$f" timeout "jobs without timeout-minutes: $missing"

  # --- third-party actions pinned to a SHA -----------------------------------
  while IFS= read -r ref; do
    [ -z "$ref" ] && continue
    case "$ref" in
      ./*|docker://*|actions/*|github/*|"$ORG"/*) continue ;;
    esac
    sha="${ref##*@}"
    if ! printf '%s' "$sha" | grep -Eq '^[0-9a-f]{40}$'; then
      report WARN "$f" pin "third-party action not pinned to a commit SHA: $ref"
    fi
  done < <(yq -r '[.jobs[].steps[]?.uses, .jobs[].uses] | .[] | select(. != null)' "$f" | sort -u)

  # --- push limited to named branches ----------------------------------------
  if echo "$triggers" | grep -qx push; then
    if [ "$(yq '.on.push.branches != null or .on.push.tags != null' "$f")" != true ]; then
      report WARN "$f" push-branches "push runs on every branch; limit it to the default branch"
    fi
  fi

  # --- noisy triggers need an early job-level if ------------------------------
  noisy=""
  echo "$triggers" | grep -qx issue_comment && noisy="issue_comment"
  if [ "$(yq '[.on[]?.types[]?] | any_c(. == "labeled")' "$f" 2>/dev/null)" = true ]; then
    noisy="${noisy:+$noisy, }labeled"
  fi
  if [ -n "$noisy" ]; then
    missing=$(yq -r '.jobs | to_entries | .[] | select(.value.if == null) | .key' "$f" | tr '\n' ' ')
    [ -n "$missing" ] && report WARN "$f" noisy-trigger "$noisy trigger with no job-level if on: $missing"
  fi

  # --- pull_request_target must not check out PR code ------------------------
  if echo "$triggers" | grep -qx pull_request_target; then
    if yq -r '.jobs[].steps[]? | select(.uses != null and (.uses | test("^actions/checkout@"))) | .with.ref // ""' "$f" \
        | grep -Eq 'pull_request\.head|github\.head_ref|refs/pull/'; then
      report WARN "$f" prt-checkout "pull_request_target checks out pull request code"
    fi
  fi

  # --- setup-* caching -------------------------------------------------------
  nocache=$(yq -r '.jobs[].steps[]? | select(.uses != null and (.uses | test("^actions/setup-(node|python)@")) and .with.cache == null) | .uses' "$f" | sort -u | tr '\n' ' ')
  [ -n "$nocache" ] && report WARN "$f" cache "setup step without cache: $nocache"
done

echo "---"
echo "checked=$checked fail=$fails warn=$warns waived=$waived"
if [ "$checked" -eq 0 ]; then
  echo "error: no workflow files examined" >&2
  exit 2
fi
[ "$fails" -eq 0 ]
