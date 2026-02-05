#!/usr/bin/env bash
# orchestrator.sh
# Simple CLAIM framework orchestrator using Gemini CLI

set -euo pipefail

# --------------------------------------------------
# Clone target repo
# --------------------------------------------------
REPO_DIR="is-thirteen"
if [ ! -d "$REPO_DIR" ]; then
    echo "Cloning target repository..."
    git clone https://github.com/avengerandy/rankNet_bert "$REPO_DIR"
else
    echo "Repository already exists, pulling latest changes..."
    git -C "$REPO_DIR" pull
fi

# --------------------------------------------------
# Config
# --------------------------------------------------
export PATH="$PATH:/usr/local/lib/node_modules/@google/gemini-cli/dist"
MEMORY_DIR="memory"
MAX_ITER=3
SLEEP_TIME=120 # LLM API rate limit

TARGET_FILE="$MEMORY_DIR/target.md"
EVIDENCE_FILE="$MEMORY_DIR/evidence.md"
CLAIMS_FILE="$MEMORY_DIR/claims.md"
FROZEN_FILE="$MEMORY_DIR/frozen.md"
RESEARCH_FILE="$MEMORY_DIR/research.md"

# --------------------------------------------------
# Setup
# --------------------------------------------------
if [ ! -f "$TARGET_FILE" ]; then
  echo "ERROR: target.md not found."
  echo "You must create memory/target.md manually before running CLAIM."
  exit 1
fi

if ! grep -q '[^[:space:]]' "$TARGET_FILE"; then
  echo "ERROR: target.md exists but is empty."
  echo "Define the investigation target explicitly."
  exit 1
fi

# Create files if missing
[ -f "$EVIDENCE_FILE" ] || touch "$EVIDENCE_FILE"
[ -f "$CLAIMS_FILE" ]   || touch "$CLAIMS_FILE"
[ -f "$FROZEN_FILE" ] || touch "$FROZEN_FILE"
[ -f "$RESEARCH_FILE" ] || touch "$RESEARCH_FILE"

# --------------------------------------------------
# Claim discussion loop
# --------------------------------------------------
echo "=============================================="
echo "CLAIM Orchestrator"
echo "Target: $TARGET_FILE"
echo "Iterations: $MAX_ITER"
echo "=============================================="

for ((i=1; i<=MAX_ITER; i++)); do
  echo
  echo "=== Claim Discussion Iteration $i / $MAX_ITER ==="

  echo ">>> Explorer (iteration $i)"
  gemini /explorer -y
  sleep $SLEEP_TIME

  echo ">>> Attacker (iteration $i)"
  gemini /attacker -y
  sleep $SLEEP_TIME
done

# --------------------------------------------------
# Freeze phase
# --------------------------------------------------
echo
echo "=== Freezing Claims ==="
gemini /frozen -y
sleep $SLEEP_TIME

# --------------------------------------------------
# Writing phase
# --------------------------------------------------
echo
echo "=== Writing Final Report ==="
gemini /writer -y
sleep $SLEEP_TIME

echo
echo "=============================================="
echo "CLAIM orchestration complete."
echo "Final report: $RESEARCH_FILE"
echo "=============================================="
