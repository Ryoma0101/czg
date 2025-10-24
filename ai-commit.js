#!/usr/bin/env node

/**
 * AI Commit Message Generator for czg
 * This script wraps the Gemini AI commit message generator
 */

const { execSync } = require('child_process');
const path = require('path');
const os = require('os');

const SCRIPT_PATH = path.join(__dirname, 'gemini-commit.sh');

try {
  // Execute the bash script and capture output
  const commitMessage = execSync(`bash "${SCRIPT_PATH}"`, {
    encoding: 'utf-8',
    stdio: ['inherit', 'pipe', 'inherit'],
    maxBuffer: 10 * 1024 * 1024 // 10MB buffer
  }).trim();

  // Output the commit message
  console.log(commitMessage);
  process.exit(0);
} catch (error) {
  // If the script fails, exit with error code
  process.exit(error.status || 1);
}
