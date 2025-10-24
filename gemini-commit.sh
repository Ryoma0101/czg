#!/usr/bin/env bash

# Gemini AI Commit Message Generator for czg
# This script generates commit messages using Google's Gemini AI

set -euo pipefail

# Configuration
GEMINI_API_KEY="${GEMINI_API_KEY:-}"
GEMINI_MODEL="${GEMINI_MODEL:-gemini-2.0-flash-exp}"
GEMINI_API_URL="https://generativelanguage.googleapis.com/v1beta/models/${GEMINI_MODEL}:generateContent"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if API key is set
if [ -z "$GEMINI_API_KEY" ]; then
    echo -e "${RED}Error: GEMINI_API_KEY environment variable is not set${NC}" >&2
    echo "Please set your Gemini API key:" >&2
    echo "  export GEMINI_API_KEY='your-api-key'" >&2
    echo "" >&2
    echo "Get your API key from: https://aistudio.google.com/app/apikey" >&2
    exit 1
fi

# Get git diff
get_diff() {
    # Check for staged changes
    if ! git diff --cached --quiet 2>/dev/null; then
        git diff --cached
    elif ! git diff --quiet 2>/dev/null; then
        # If no staged changes, use unstaged changes
        git diff
    else
        echo -e "${YELLOW}No changes detected${NC}" >&2
        exit 1
    fi
}

# Generate commit message using Gemini API
generate_commit_message() {
    local diff="$1"

    # Escape and prepare the diff for JSON
    local escaped_diff=$(echo "$diff" | jq -Rs .)

    # Prepare the prompt
    local prompt="あなたは経験豊富なソフトウェアエンジニアです。以下のgit diffを分析し、適切なコミットメッセージを生成してください。

要件:
- Conventional Commits形式に従う（type(scope): subject）
- typeは以下から選択: feat, fix, docs, style, refactor, perf, test, chore, ci, build
- subjectは簡潔で明確に（50文字以内を推奨）
- 日本語で記述
- 複数の変更がある場合は、最も重要な変更に焦点を当てる
- bodyは不要。subjectのみを生成

Git Diff:
${diff}

上記のdiffに基づいて、コミットメッセージのsubject部分のみを1行で出力してください。
例: feat(auth): ユーザー認証機能を追加"

    local escaped_prompt=$(echo "$prompt" | jq -Rs .)

    # Create JSON payload
    local json_payload=$(cat <<EOF
{
  "contents": [{
    "parts": [{
      "text": ${escaped_prompt}
    }]
  }],
  "generationConfig": {
    "temperature": 0.3,
    "maxOutputTokens": 200,
    "topP": 0.8,
    "topK": 10
  }
}
EOF
)

    # Call Gemini API
    local response=$(curl -s -X POST \
        "${GEMINI_API_URL}?key=${GEMINI_API_KEY}" \
        -H "Content-Type: application/json" \
        -d "$json_payload")

    # Check for API errors
    if echo "$response" | jq -e '.error' > /dev/null 2>&1; then
        local error_message=$(echo "$response" | jq -r '.error.message')
        echo -e "${RED}Gemini API Error: ${error_message}${NC}" >&2
        exit 1
    fi

    # Extract the generated text
    local commit_message=$(echo "$response" | jq -r '.candidates[0].content.parts[0].text' 2>/dev/null)

    if [ -z "$commit_message" ] || [ "$commit_message" = "null" ]; then
        echo -e "${RED}Failed to generate commit message${NC}" >&2
        echo "API Response: $response" >&2
        exit 1
    fi

    # Clean up the message (remove quotes, extra whitespace, newlines)
    commit_message=$(echo "$commit_message" | tr -d '\n' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

    echo "$commit_message"
}

# Main execution
main() {
    echo -e "${GREEN}🤖 Generating commit message with Gemini AI...${NC}" >&2

    # Get the diff
    local diff=$(get_diff)

    if [ -z "$diff" ]; then
        echo -e "${YELLOW}No changes to commit${NC}" >&2
        exit 1
    fi

    # Generate commit message
    local commit_message=$(generate_commit_message "$diff")

    # Output the commit message
    echo "$commit_message"
}

# Run main function
main "$@"
