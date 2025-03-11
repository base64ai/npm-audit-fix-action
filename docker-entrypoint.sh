#!/bin/sh
set -e

# Default values
GITHUB_TOKEN=${INPUT_GITHUB_TOKEN:-$GITHUB_TOKEN}
GITHUB_USER=${INPUT_GITHUB_USER:-$GITHUB_ACTOR}
GITHUB_EMAIL=${INPUT_GITHUB_EMAIL:-"$GITHUB_ACTOR@users.noreply.github.com"}
BRANCH=${INPUT_BRANCH:-"npm-audit-fix-action/fix"}
DEFAULT_BRANCH=${INPUT_DEFAULT_BRANCH:-""}
COMMIT_TITLE=${INPUT_COMMIT_TITLE:-"build(deps): npm audit fix"}
LABELS=${INPUT_LABELS:-"dependencies, javascript, security"}
ASSIGNEES=${INPUT_ASSIGNEES:-""}
NPM_ARGS=${INPUT_NPM_ARGS:-""}
PATH_TO_PROJECT=${INPUT_PATH:-.}

# Print Node.js and npm versions
echo "Node.js version: $(node -v)"
echo "npm version: $(npm -v)"

# Set environment variables that the action code expects
export GITHUB_TOKEN=$GITHUB_TOKEN
export INPUT_GITHUB_TOKEN=$GITHUB_TOKEN
export INPUT_GITHUB_USER=$GITHUB_USER
export INPUT_GITHUB_EMAIL=$GITHUB_EMAIL
export INPUT_BRANCH=$BRANCH
export INPUT_DEFAULT_BRANCH=$DEFAULT_BRANCH
export INPUT_COMMIT_TITLE=$COMMIT_TITLE
export INPUT_LABELS=$LABELS
export INPUT_ASSIGNEES=$ASSIGNEES
export INPUT_NPM_ARGS=$NPM_ARGS
export INPUT_PATH=$PATH_TO_PROJECT

# Change to the project directory
cd $PATH_TO_PROJECT

# Run the action code
echo "Starting npm audit fix action..."
node /action/dist/index.cjs 