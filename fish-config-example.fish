# Gemini AI Commit - Fish Shell Configuration Example
# Add this to your ~/.config/fish/config.fish

# =====================================
# Gemini API Configuration
# =====================================

# Set your Gemini API key (required)
# Get your key from: https://aistudio.google.com/app/apikey
set -gx GEMINI_API_KEY "your-api-key-here"

# Optional: Choose Gemini model (default: gemini-2.0-flash-exp)
# Available models:
#   - gemini-2.0-flash-exp (fastest, default)
#   - gemini-1.5-pro (most accurate)
#   - gemini-1.5-flash (balanced)
# set -gx GEMINI_MODEL "gemini-1.5-pro"

# =====================================
# Convenient Aliases
# =====================================

# AI-powered commit
alias gai='bash ~/.config/czg/czg-ai'

# Regular czg commit
alias gcz='czg'

# Generate commit message only (no commit)
alias gaimsg='bash ~/.config/czg/gemini-commit.sh'

# =====================================
# Optional: Add czg-ai to PATH
# =====================================

# fish_add_path ~/.config/czg

# =====================================
# Usage Examples
# =====================================

# After editing this file, reload your config:
#   source ~/.config/fish/config.fish
#
# Then you can use:
#   git add .
#   gai        # AI-generated commit with interactive options
#   gcz        # Use czg normally (can type :ai in subject field)
#   gaimsg     # Just generate message without committing
#
# Or in lazygit:
#   Press 'A' - AI-generated commit
#   Press 'Z' - Regular czg (type :ai for AI generation)
