#!/usr/bin/env bash

# Gemini AI Commit Setup Script
# This script helps you set up the Gemini AI commit message generator

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

CONFIG_DIR="$HOME/.config/czg"

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}🚀 Gemini AI Commit Setup${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Check dependencies
echo -e "${YELLOW}Checking dependencies...${NC}"

check_command() {
    if command -v "$1" &> /dev/null; then
        echo -e "  ${GREEN}✓${NC} $1"
        return 0
    else
        echo -e "  ${RED}✗${NC} $1 ${RED}(not found)${NC}"
        return 1
    fi
}

all_deps_ok=true

if ! check_command "node"; then
    all_deps_ok=false
    echo -e "    ${YELLOW}Install: https://nodejs.org/${NC}"
fi

if ! check_command "npm"; then
    all_deps_ok=false
    echo -e "    ${YELLOW}Install: https://nodejs.org/${NC}"
fi

if ! check_command "jq"; then
    all_deps_ok=false
    echo -e "    ${YELLOW}Install: brew install jq${NC}"
fi

if ! check_command "curl"; then
    all_deps_ok=false
fi

if ! check_command "czg"; then
    all_deps_ok=false
    echo -e "    ${YELLOW}Install: npm install -g czg${NC}"
fi

if ! check_command "git"; then
    all_deps_ok=false
fi

echo ""

if [ "$all_deps_ok" = false ]; then
    echo -e "${RED}Missing required dependencies. Please install them first.${NC}"
    exit 1
fi

# Check for API key
echo -e "${YELLOW}Checking Gemini API key...${NC}"

if [ -z "${GEMINI_API_KEY:-}" ]; then
    echo -e "${RED}✗ GEMINI_API_KEY not set${NC}"
    echo ""
    echo -e "${CYAN}To get your API key:${NC}"
    echo "1. Visit: https://aistudio.google.com/app/apikey"
    echo "2. Click 'Create API Key'"
    echo "3. Copy the API key"
    echo ""
    echo -e "${CYAN}Then set it in your shell config:${NC}"
    echo ""

    # Detect shell
    shell_name=$(basename "$SHELL")
    case "$shell_name" in
        fish)
            config_file="$HOME/.config/fish/config.fish"
            echo -e "${GREEN}Fish Shell:${NC}"
            echo "  echo 'set -gx GEMINI_API_KEY \"your-api-key-here\"' >> $config_file"
            echo "  source $config_file"
            ;;
        zsh)
            config_file="$HOME/.zshrc"
            echo -e "${GREEN}Zsh:${NC}"
            echo "  echo 'export GEMINI_API_KEY=\"your-api-key-here\"' >> $config_file"
            echo "  source $config_file"
            ;;
        bash)
            config_file="$HOME/.bashrc"
            echo -e "${GREEN}Bash:${NC}"
            echo "  echo 'export GEMINI_API_KEY=\"your-api-key-here\"' >> $config_file"
            echo "  source $config_file"
            ;;
        *)
            echo -e "${YELLOW}Add to your shell config:${NC}"
            echo "  export GEMINI_API_KEY=\"your-api-key-here\""
            ;;
    esac
    echo ""
    echo -e "${YELLOW}After setting the API key, run this script again.${NC}"
    exit 1
else
    echo -e "${GREEN}✓ GEMINI_API_KEY is set${NC}"
fi

echo ""

# Test API connection
echo -e "${YELLOW}Testing Gemini API connection...${NC}"

test_response=$(curl -s -X POST \
    "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent?key=${GEMINI_API_KEY}" \
    -H "Content-Type: application/json" \
    -d '{"contents":[{"parts":[{"text":"Hello"}]}]}' || echo "ERROR")

if echo "$test_response" | jq -e '.error' > /dev/null 2>&1; then
    error_msg=$(echo "$test_response" | jq -r '.error.message')
    echo -e "${RED}✗ API Error: $error_msg${NC}"
    exit 1
elif [ "$test_response" = "ERROR" ]; then
    echo -e "${RED}✗ Connection failed${NC}"
    exit 1
else
    echo -e "${GREEN}✓ API connection successful${NC}"
fi

echo ""

# Make scripts executable
echo -e "${YELLOW}Setting permissions...${NC}"
chmod +x "$CONFIG_DIR/gemini-commit.sh"
chmod +x "$CONFIG_DIR/ai-commit.js"
chmod +x "$CONFIG_DIR/czg-ai"
echo -e "${GREEN}✓ Permissions set${NC}"

echo ""

# Add to PATH suggestion
echo -e "${CYAN}Optional: Add czg-ai to your PATH${NC}"
echo ""
shell_name=$(basename "$SHELL")
case "$shell_name" in
    fish)
        config_file="$HOME/.config/fish/config.fish"
        echo -e "${GREEN}Fish Shell:${NC}"
        echo "  fish_add_path $CONFIG_DIR"
        echo "  Or manually add to $config_file:"
        echo "  set -gx PATH $CONFIG_DIR \$PATH"
        ;;
    zsh)
        config_file="$HOME/.zshrc"
        echo -e "${GREEN}Zsh:${NC}"
        echo "  echo 'export PATH=\"$CONFIG_DIR:\$PATH\"' >> $config_file"
        ;;
    bash)
        config_file="$HOME/.bashrc"
        echo -e "${GREEN}Bash:${NC}"
        echo "  echo 'export PATH=\"$CONFIG_DIR:\$PATH\"' >> $config_file"
        ;;
esac

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✨ Setup complete!${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${CYAN}Usage:${NC}"
echo ""
echo -e "${YELLOW}In lazygit:${NC}"
echo "  1. Stage files"
echo "  2. Press 'A' for AI-generated commit"
echo "  3. Or press 'Z' for czg (type :ai in subject)"
echo ""
echo -e "${YELLOW}From command line:${NC}"
echo "  bash ~/.config/czg/czg-ai"
echo ""
echo -e "${YELLOW}Or after adding to PATH:${NC}"
echo "  czg-ai"
echo ""
echo -e "${CYAN}For more information:${NC}"
echo "  cat ~/.config/czg/README.md"
echo ""
