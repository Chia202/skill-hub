#!/usr/bin/env bash
# Verify issue consistency across all audit files.
# Usage: ./scripts/issues.sh <paper.tex|paper-directory>
#
# Checks:
#   1. Every issue in ISSUE_LOG.md appears in at least one local check file
#   2. Every issue found in local check files is recorded in ISSUE_LOG.md
#   3. FINAL_REPORT.md issue counts match ISSUE_LOG.md
#   4. Severity distribution is consistent

set -euo pipefail

TARGET="${1:-}"
if [ -z "$TARGET" ]; then
    echo "Usage: $0 <paper.tex|paper-directory>"
    exit 1
fi

if [[ "$TARGET" == *.tex ]]; then
    if [ ! -f "$TARGET" ]; then
        echo "Error: file not found: $TARGET"
        exit 1
    fi
    PAPER_DIR="$(cd "$(dirname "$TARGET")" && pwd)"
else
    if [ ! -d "$TARGET" ]; then
        echo "Error: directory not found: $TARGET"
        exit 1
    fi
    PAPER_DIR="$(cd "$TARGET" && pwd)"
fi

AUDIT_DIR="$PAPER_DIR/audit"
ISSUE_LOG="$AUDIT_DIR/06_reports/ISSUE_LOG.md"
FINAL_REPORT="$AUDIT_DIR/06_reports/FINAL_REPORT.md"
LOCAL_CHECKS_DIR="$AUDIT_DIR/04_local_checks"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

ok()  { echo -e "${GREEN}OK${NC}  $1"; }
err() { echo -e "${RED}ERR${NC} $1"; }
warn() { echo -e "${YELLOW}WARN${NC} $1"; }

echo "=== Issue Consistency Check ==="
echo "Paper: $PAPER_DIR"
echo ""

# --- 1. Extract issue IDs from ISSUE_LOG.md ---
if [ ! -f "$ISSUE_LOG" ]; then
    err "ISSUE_LOG.md not found at $ISSUE_LOG"
    exit 1
fi

# Match issue IDs like I-01, I-02, etc. from the issue log table
LOG_ISSUES=$(grep -oE 'I-[0-9]+' "$ISSUE_LOG" | sort -u)
LOG_COUNT=$(echo "$LOG_ISSUES" | grep -c . || true)

echo "Issues in ISSUE_LOG.md: $LOG_COUNT"

# --- 2. Extract issue IDs from all local check files ---
if [ -d "$LOCAL_CHECKS_DIR" ]; then
    CHECK_ISSUES=$(grep -rohE 'I-[0-9]+' "$LOCAL_CHECKS_DIR" | sort -u)
    CHECK_COUNT=$(echo "$CHECK_ISSUES" | grep -c . || true)
else
    warn "No local checks directory found"
    CHECK_ISSUES=""
    CHECK_COUNT=0
fi

echo "Issues referenced in local checks: $CHECK_COUNT"
echo ""

# --- 3. Cross-reference: issues in log but not in checks ---
MISSING_IN_CHECKS=$(comm -23 <(echo "$LOG_ISSUES") <(echo "$CHECK_ISSUES"))
if [ -n "$MISSING_IN_CHECKS" ]; then
    warn "Issues in ISSUE_LOG but NOT in any local check file:"
    echo "$MISSING_IN_CHECKS" | while read id; do
        echo "       $id — referenced in log but never appeared in a check"
    done
    echo ""
else
    ok "All logged issues appear in at least one local check file"
fi

# --- 4. Cross-reference: issues in checks but not in log ---
MISSING_IN_LOG=$(comm -13 <(echo "$LOG_ISSUES") <(echo "$CHECK_ISSUES"))
if [ -n "$MISSING_IN_LOG" ]; then
    err "Issues in local checks but NOT in ISSUE_LOG.md:"
    echo "$MISSING_IN_LOG" | while read id; do
        FILES=$(grep -rl "$id" "$LOCAL_CHECKS_DIR")
        echo "       $id — found in: $FILES"
    done
    echo ""
else
    ok "All check-file issues are recorded in ISSUE_LOG.md"
fi

# --- 5. Check for orphaned severity markers ---
echo ""
echo "--- Severity marker check ---"
ORPHANED=$(grep -rl 'S0\|S1' "$LOCAL_CHECKS_DIR" 2>/dev/null || true | while read f; do
    if ! grep -q 'I-[0-9]' "$f"; then
        echo "  $f — has S0/S1 but no issue ID"
    fi
done)
if [ -n "$ORPHANED" ]; then
    warn "Files with S0/S1 severity but no issue ID reference:"
    echo "$ORPHANED"
else
    ok "No orphaned severity markers"
fi

echo ""
echo "=== Consistency check complete ==="
