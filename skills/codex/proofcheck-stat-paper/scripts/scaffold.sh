#!/usr/bin/env bash
# Create the canonical proof-check audit tree beside a LaTeX file.
# Usage: ./scaffold.sh <paper.tex|paper-directory>
set -euo pipefail

TARGET="${1:-}"

if [[ -z "$TARGET" ]]; then
    echo "Usage: scaffold.sh <paper.tex|paper-directory>"
    echo ""
    echo "Creates CHECK_PLAN.md, EXECUTION_ORDER.md, and audit/ beside the target .tex file."
    exit 1
fi

if [[ "$TARGET" == *.tex ]]; then
    if [[ ! -f "$TARGET" ]]; then
        echo "Error: file not found: $TARGET"
        exit 1
    fi
    PAPER_DIR="$(cd "$(dirname "$TARGET")" && pwd)"
    TEXFILE="$(basename "$TARGET")"
else
    if [[ ! -d "$TARGET" ]]; then
        echo "Error: directory not found: $TARGET"
        exit 1
    fi
    PAPER_DIR="$(cd "$TARGET" && pwd)"
    TEXFILE="(not specified)"
fi

SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)"

mkdir -p "$PAPER_DIR/audit/01_index"
mkdir -p "$PAPER_DIR/audit/02_ledgers"
mkdir -p "$PAPER_DIR/audit/03_dependencies"
mkdir -p "$PAPER_DIR/audit/04_local_checks"
mkdir -p "$PAPER_DIR/audit/05_adversarial"
mkdir -p "$PAPER_DIR/audit/06_reports"

for dir in "$PAPER_DIR/audit"/*/; do
    touch "$dir/.gitkeep"
done

if [[ -f "$SKILL_DIR/assets/progress-template.md" && ! -f "$PAPER_DIR/audit/06_reports/PROGRESS.md" ]]; then
    cp "$SKILL_DIR/assets/progress-template.md" "$PAPER_DIR/audit/06_reports/PROGRESS.md"
fi

echo "Created/verified proof-check workspace beside: $PAPER_DIR/$TEXFILE"
echo ""
find "$PAPER_DIR/audit" -maxdepth 2 -type d -o -type f | sort

echo ""
echo "Next: use \$proofcheck-stat-paper to check the appendix proofs in $PAPER_DIR/$TEXFILE"
