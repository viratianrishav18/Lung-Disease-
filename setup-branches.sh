#!/bin/bash

# Branch Setup Script for Lung Disease Predictor
# This script creates and pushes the develop and staging branches
#
# Usage: Make sure this script has execute permissions:
#   chmod +x setup-branches.sh
#   ./setup-branches.sh

set -e

echo "🌳 Setting up branch structure for Lung Disease Predictor..."

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}Error: Not in a git repository${NC}"
    exit 1
fi

# Fetch latest changes
echo -e "${YELLOW}Fetching latest changes...${NC}"
git fetch origin

# Get the latest commit from main
echo -e "${YELLOW}Checking main branch...${NC}"
git checkout main
git pull origin main

# Create develop branch from main
echo -e "${YELLOW}Creating develop branch...${NC}"
if git show-ref --verify --quiet refs/heads/develop; then
    echo -e "${YELLOW}develop branch already exists locally${NC}"
    git checkout develop
    git pull origin develop 2>/dev/null || echo "No remote develop branch yet"
else
    git checkout -b develop
    echo -e "${GREEN}✓ develop branch created${NC}"
fi

# Push develop branch
echo -e "${YELLOW}Pushing develop branch to origin...${NC}"
git push -u origin develop
echo -e "${GREEN}✓ develop branch pushed${NC}"

# Create staging branch from main
echo -e "${YELLOW}Creating staging branch...${NC}"
git checkout main
if git show-ref --verify --quiet refs/heads/staging; then
    echo -e "${YELLOW}staging branch already exists locally${NC}"
    git checkout staging
    git pull origin staging 2>/dev/null || echo "No remote staging branch yet"
else
    git checkout -b staging
    echo -e "${GREEN}✓ staging branch created${NC}"
fi

# Push staging branch
echo -e "${YELLOW}Pushing staging branch to origin...${NC}"
git push -u origin staging
echo -e "${GREEN}✓ staging branch pushed${NC}"

# Return to develop branch
git checkout develop

echo ""
echo -e "${GREEN}✓ Branch setup complete!${NC}"
echo ""
echo "Branch structure created:"
echo "  📦 main     - Production branch (protected)"
echo "  🎯 staging  - Pre-production branch (protected)"
echo "  🚀 develop  - Development branch (protected)"
echo ""
echo "Next steps:"
echo "  1. Set up branch protection rules (see BRANCH_SETUP.md)"
echo "  2. Configure GitHub Actions secrets for deployment"
echo "  3. Start developing on feature branches from develop"
echo ""
