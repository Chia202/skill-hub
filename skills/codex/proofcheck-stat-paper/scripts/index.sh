#!/usr/bin/env bash
# Extract proof units (theorems, lemmas, etc.) from a LaTeX file.
# Usage: ./index.sh paper.tex [--after LINE|--after '\appendix']
set -euo pipefail

TEXFILE=""
AFTER_LINE=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --after)
            AFTER_LINE="$2"
            shift 2
            ;;
        *)
            TEXFILE="$1"
            shift
            ;;
    esac
done

if [[ -z "$TEXFILE" ]]; then
    echo "Usage: index.sh <paper.tex> [--after LINE|--after '\appendix']"
    exit 1
fi

if [[ ! -f "$TEXFILE" ]]; then
    echo "Error: file not found: $TEXFILE"
    exit 1
fi

# If --after is '\appendix', find its line number
if [[ "$AFTER_LINE" == '\appendix' ]]; then
    AFTER_LINE=$(grep -n '\\appendix' "$TEXFILE" | head -1 | cut -d: -f1)
    if [[ -z "$AFTER_LINE" ]]; then
        echo "Warning: \\appendix not found, scanning entire file" >&2
    fi
fi

# Build the grep pattern
PATTERN='\\begin\{(theorem|lemma|proposition|corollary|definition|assumption|claim)\}'

# Collect matches
if [[ -n "$AFTER_LINE" ]]; then
    RAW=$(tail -n "+$AFTER_LINE" "$TEXFILE" | grep -n -E "$PATTERN" || true)
else
    RAW=$(grep -n -E "$PATTERN" "$TEXFILE" || true)
fi

if [[ -z "$RAW" ]]; then
    echo "No proof units found."
    exit 0
fi

# Output markdown table
echo "| ID | Type | Label | Line | Summary |"
echo "|---|---|---|---|---|"

COUNT=1
while IFS= read -r match; do
    if [[ -n "$AFTER_LINE" ]]; then
        REL_LINE=$(echo "$match" | cut -d: -f1)
        ABS_LINE=$((AFTER_LINE + REL_LINE - 1))
    else
        ABS_LINE=$(echo "$match" | cut -d: -f1)
    fi

    # Extract environment type
    ENV_TYPE=$(echo "$match" | sed -n 's/.*\\begin{\([^}]*\)}.*/\1/p')

    # Try to extract label from the same line
    LABEL=$(echo "$match" | sed -n 's/.*\\label{\([^}]*\)}.*/\1/p')
    if [[ -z "$LABEL" ]]; then
        # Try the next line
        LABEL=$(sed -n "$((ABS_LINE + 1))p" "$TEXFILE" | sed -n 's/.*\\label{\([^}]*\)}.*/\1/p' || true)
    fi
    [[ -z "$LABEL" ]] && LABEL="(no label)"

    # Extract a short summary: text between \begin{env} and first \label or \end
    SUMMARY=$(echo "$match" | sed 's/.*\\begin{[^}]*}//' | sed 's/\\label{.*//' | sed 's/\\end{.*//' | head -c 80 | tr '\n' ' ')
    [[ -z "${SUMMARY// }" ]] && SUMMARY="(see proof text)"

    echo "| U$COUNT | $ENV_TYPE | $LABEL | $ABS_LINE | $SUMMARY |"
    COUNT=$((COUNT + 1))
done <<< "$RAW"

echo ""
echo "**Total**: $((COUNT - 1)) proof units found."
