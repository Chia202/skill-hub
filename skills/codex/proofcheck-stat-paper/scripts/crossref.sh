#!/usr/bin/env bash
# Cross-reference consistency checker for LaTeX files.
# Reports: broken \ref{}, orphan \label{}, duplicate \label{}.
# Usage: ./crossref.sh paper.tex
set -euo pipefail

TEXFILE="${1:-}"

if [[ -z "$TEXFILE" ]]; then
    echo "Usage: crossref.sh <paper.tex>"
    exit 1
fi

if [[ ! -f "$TEXFILE" ]]; then
    echo "Error: file not found: $TEXFILE"
    exit 1
fi

# Extract all \label{KEY} — handles multiple labels per line
{ grep -n '\\label{[^}]*}' "$TEXFILE" || true; } | while IFS= read -r line; do
    lineno=$(echo "$line" | cut -d: -f1)
    # Extract all labels on this line
    echo "$line" | grep -o '\\label{[^}]*}' | sed 's/\\label{//;s/}//' | while read -r key; do
        echo "$key LABEL $lineno"
    done
done > /tmp/crossref_labels.$$

# Extract all \ref{KEY} and \eqref{KEY}
{ grep -n '\\ref{[^}]*}' "$TEXFILE" || true; } | while IFS= read -r line; do
    lineno=$(echo "$line" | cut -d: -f1)
    echo "$line" | grep -o '\\ref{[^}]*}' | sed 's/\\ref{//;s/}//' | while read -r key; do
        echo "$key REF $lineno"
    done
done > /tmp/crossref_refs.$$

{ grep -n '\\eqref{[^}]*}' "$TEXFILE" || true; } | while IFS= read -r line; do
    lineno=$(echo "$line" | cut -d: -f1)
    echo "$line" | grep -o '\\eqref{[^}]*}' | sed 's/\\eqref{//;s/}//' | while read -r key; do
        echo "$key REF $lineno"
    done
done >> /tmp/crossref_refs.$$

# Build sets
cut -d' ' -f1 /tmp/crossref_labels.$$ | sort -u > /tmp/crossref_label_keys.$$
cut -d' ' -f1 /tmp/crossref_refs.$$ | sort -u > /tmp/crossref_ref_keys.$$

# Duplicate labels
DUPES=$(cut -d' ' -f1 /tmp/crossref_labels.$$ | sort | uniq -d)
DUP_COUNT=$(echo "$DUPES" | grep -c . || true)

# Broken refs: keys in refs but not in labels
BROKEN=$(comm -23 /tmp/crossref_ref_keys.$$ /tmp/crossref_label_keys.$$)
BROKEN_COUNT=$(echo "$BROKEN" | grep -c . || true)

# Orphan labels: keys in labels but not in refs
ORPHANS=$(comm -13 /tmp/crossref_ref_keys.$$ /tmp/crossref_label_keys.$$)
ORPHAN_COUNT=$(echo "$ORPHANS" | grep -c . || true)

echo "## Cross-Reference Audit"
echo ""

# Broken refs
echo "### Broken References (\ref without \label)"
echo ""
echo "| Key | Referenced at lines |"
echo "|---|---|"
if [[ -n "$BROKEN" ]]; then
    while IFS= read -r key; do
        LINES=$(grep "^$key REF " /tmp/crossref_refs.$$ | awk '{print $3}' | tr '\n' ', ' | sed 's/,$//')
        echo "| $key | $LINES |"
    done <<< "$BROKEN"
else
    echo "| — | None found |"
fi
echo ""
echo "**Count**: $BROKEN_COUNT"
echo ""

# Orphan labels
echo "### Orphan Labels (\label without \ref)"
echo ""
echo "| Key | Defined at line |"
echo "|---|---|"
if [[ -n "$ORPHANS" ]]; then
    while IFS= read -r key; do
        LINE=$(grep "^$key LABEL " /tmp/crossref_labels.$$ | head -1 | awk '{print $3}')
        echo "| $key | $LINE |"
    done <<< "$ORPHANS"
else
    echo "| — | None found |"
fi
echo ""
echo "**Count**: $ORPHAN_COUNT"
echo ""

# Duplicate labels
echo "### Duplicate Labels"
echo ""
echo "| Key | Defined at lines |"
echo "|---|---|"
if [[ -n "$DUPES" ]]; then
    while IFS= read -r key; do
        LINES=$(grep "^$key LABEL " /tmp/crossref_labels.$$ | awk '{print $3}' | tr '\n' ', ' | sed 's/,$//')
        echo "| $key | $LINES |"
    done <<< "$DUPES"
else
    echo "| — | None found |"
fi
echo ""
echo "**Count**: $DUP_COUNT"
echo ""

# Summary
echo "---"
echo ""
echo "| Metric | Count |"
echo "|---|---|"
echo "| Total \labels | $(wc -l < /tmp/crossref_label_keys.$$ | tr -d ' ') |"
echo "| Total \refs | $(wc -l < /tmp/crossref_ref_keys.$$ | tr -d ' ') |"
echo "| Broken refs | $BROKEN_COUNT |"
echo "| Orphan labels | $ORPHAN_COUNT |"
echo "| Duplicate labels | $DUP_COUNT |"

# Cleanup
rm -f /tmp/crossref_labels.$$ /tmp/crossref_refs.$$ /tmp/crossref_label_keys.$$ /tmp/crossref_ref_keys.$$
