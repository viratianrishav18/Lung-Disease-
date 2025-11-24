# Branch Setup Guide

This guide will help you set up the complete branch structure for the Lung Disease Predictor project.

## Overview

The project uses a **Git Flow** branching model with three main branches:
- `main` - Production branch
- `staging` - Pre-production testing branch
- `develop` - Main development branch

## Automated Branch Setup Script

Save this script as `setup-branches.sh` and run it to automatically create all branches:

```bash
#!/bin/bash

# Branch Setup Script for Lung Disease Predictor
# This script creates and pushes the develop and staging branches

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
echo "  1. Set up branch protection rules (see BRANCH_PROTECTION.md)"
echo "  2. Configure GitHub Actions secrets for deployment"
echo "  3. Start developing on feature branches from develop"
echo ""
```

## Manual Branch Setup

If you prefer to set up branches manually, follow these steps:

### Step 1: Create Develop Branch

```bash
# Ensure you're on main branch
git checkout main
git pull origin main

# Create develop branch from main
git checkout -b develop

# Push develop branch to origin
git push -u origin develop
```

### Step 2: Create Staging Branch

```bash
# Go back to main branch
git checkout main

# Create staging branch from main
git checkout -b staging

# Push staging branch to origin
git push -u origin staging
```

### Step 3: Verify Branches

```bash
# List all branches
git branch -a

# You should see:
# * staging
#   develop
#   main
#   remotes/origin/develop
#   remotes/origin/main
#   remotes/origin/staging
```

### Step 4: Set Default Branch

Set `develop` as the default branch for new PRs:

1. Go to repository Settings on GitHub
2. Navigate to "Branches" section
3. Under "Default branch", click the switch icon
4. Select `develop`
5. Click "Update"

## Setting Up Branch Protection Rules

After creating the branches, set up protection rules:

### For `main` Branch

1. Go to Settings → Branches → Add branch protection rule
2. Branch name pattern: `main`
3. Enable:
   - ✅ Require a pull request before merging
   - ✅ Require approvals (minimum 1)
   - ✅ Require status checks to pass before merging
     - Add required checks: `test`, `lint`
   - ✅ Require conversation resolution before merging
   - ✅ Do not allow bypassing the above settings
   - ✅ Restrict who can push to matching branches (optional)

### For `staging` Branch

1. Add branch protection rule
2. Branch name pattern: `staging`
3. Enable:
   - ✅ Require a pull request before merging
   - ✅ Require approvals (minimum 1)
   - ✅ Require status checks to pass before merging
     - Add required checks: `test`, `lint`
   - ✅ Require conversation resolution before merging

### For `develop` Branch

1. Add branch protection rule
2. Branch name pattern: `develop`
3. Enable:
   - ✅ Require a pull request before merging
   - ✅ Require status checks to pass before merging
     - Add required checks: `test`, `lint`
   - ✅ Require conversation resolution before merging

## Merging the Setup Changes

After setting up branches, you need to merge the setup changes into develop and main:

### Option 1: Merge Setup PR to Main First

```bash
# The copilot/setup-project-branches should be merged to main via PR
# This contains all the setup files and documentation

# After merging to main:
git checkout develop
git pull origin develop
git merge main
git push origin develop

git checkout staging
git pull origin staging
git merge main
git push origin staging
```

### Option 2: Merge Setup PR to Develop First

```bash
# Merge copilot/setup-project-branches to develop via PR
# Then propagate to staging and main

# After merging to develop:
git checkout staging
git pull origin staging
git merge develop
git push origin staging

# After testing on staging:
git checkout main
git pull origin main
git merge staging
git push origin main
```

## Verification Checklist

After setup, verify:

- [ ] All three branches exist on GitHub (main, staging, develop)
- [ ] develop is set as the default branch
- [ ] Branch protection rules are configured
- [ ] CI/CD workflow file exists (`.github/workflows/ci-cd.yml`)
- [ ] Documentation files are in place:
  - [ ] `README.md`
  - [ ] `BRANCHING_STRATEGY.md`
  - [ ] `DEPLOYMENT.md`
  - [ ] `CONTRIBUTING.md`
  - [ ] `BRANCH_SETUP.md` (this file)
- [ ] Deployment scripts exist and are executable:
  - [ ] `deploy-staging.sh`
  - [ ] `deploy-production.sh`
- [ ] Docker configuration files exist:
  - [ ] `Dockerfile`
  - [ ] `docker-compose.yml`
  - [ ] `.env.example`

## Configuring GitHub Secrets

Set up the following secrets in GitHub for deployments:

1. Go to Settings → Secrets and variables → Actions
2. Click "New repository secret"
3. Add these secrets:

### Required Secrets

- `STAGING_DEPLOY_KEY` - Deployment credentials for staging environment
- `PRODUCTION_DEPLOY_KEY` - Deployment credentials for production environment

### Optional Secrets (based on deployment platform)

- `HEROKU_API_KEY` - For Heroku deployments
- `AWS_ACCESS_KEY_ID` - For AWS deployments
- `AWS_SECRET_ACCESS_KEY` - For AWS deployments
- `DOCKER_USERNAME` - For Docker Hub
- `DOCKER_PASSWORD` - For Docker Hub
- `DB_PASSWORD_STAGING` - Database password for staging
- `DB_PASSWORD_PRODUCTION` - Database password for production

## Testing the Setup

After setup, test the workflow:

### 1. Create a Test Feature Branch

```bash
git checkout develop
git pull origin develop
git checkout -b feature/test-setup

# Make a small change (e.g., update README)
echo "Test change" >> README.md
git add README.md
git commit -m "Test: Verify branch setup"
git push origin feature/test-setup
```

### 2. Create a Pull Request

1. Go to GitHub repository
2. Create PR from `feature/test-setup` to `develop`
3. Verify CI/CD pipeline runs
4. Check that tests and linting jobs execute

### 3. Merge and Verify

1. Merge the PR
2. Check that develop branch updates
3. Optionally, create PR from develop to staging to test staging deployment

## Troubleshooting

### Branch Already Exists Error

```bash
# If you get "branch already exists" error:
git fetch origin
git checkout -b develop origin/develop
# or
git checkout develop
git pull origin develop
```

### Permission Denied

If you get permission errors:
1. Check you have write access to the repository
2. Verify your GitHub authentication (SSH key or token)
3. Make sure you're not trying to push to a protected branch directly

### CI/CD Not Running

If GitHub Actions don't run:
1. Check that workflows are enabled in Settings → Actions
2. Verify `.github/workflows/ci-cd.yml` exists
3. Check workflow syntax is valid
4. Review Actions tab for error messages

## Next Steps

Once branches are set up:

1. ✅ Review and update `requirements.txt` with actual project dependencies
2. ✅ Configure deployment scripts for your chosen platform
3. ✅ Set up GitHub repository secrets
4. ✅ Configure branch protection rules
5. ✅ Start developing features on feature branches
6. ✅ Test the complete workflow: feature → develop → staging → main

## Getting Help

If you encounter issues:
- Check the documentation files (BRANCHING_STRATEGY.md, DEPLOYMENT.md)
- Review GitHub Actions logs
- Create an issue with detailed error messages
- Contact repository maintainers

## Summary

Your repository now has:
- ✅ Complete branch structure (main, staging, develop)
- ✅ CI/CD pipeline with automated testing and deployment
- ✅ Comprehensive documentation
- ✅ Deployment scripts and Docker configuration
- ✅ Contributing guidelines
- ✅ Branch protection setup instructions

You're ready to start developing! 🚀
