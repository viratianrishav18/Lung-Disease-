# Branch Strategy and Deployment Guide

## Branch Structure

This project follows a Git Flow branching strategy with the following branches:

### Main Branches

1. **main** (production)
   - Production-ready code
   - Protected branch
   - Deploys automatically to production
   - Only accepts merges from `staging` branch
   - Requires PR reviews before merging

2. **staging**
   - Pre-production testing environment
   - Protected branch
   - Deploys automatically to staging environment
   - Used for final testing before production
   - Accepts merges from `develop` branch

3. **develop**
   - Main development branch
   - Integration branch for features
   - Protected branch
   - All feature branches merge here first

### Supporting Branches

- **feature/*** - Feature development branches
  - Branch from: `develop`
  - Merge back to: `develop`
  - Naming: `feature/feature-name`

- **bugfix/*** - Bug fix branches
  - Branch from: `develop`
  - Merge back to: `develop`
  - Naming: `bugfix/bug-description`

- **hotfix/*** - Emergency production fixes
  - Branch from: `main`
  - Merge back to: `main` and `develop`
  - Naming: `hotfix/issue-description`

## Workflow

### Feature Development
```bash
# Create feature branch
git checkout develop
git pull origin develop
git checkout -b feature/your-feature-name

# Work on feature
git add .
git commit -m "Add feature description"
git push origin feature/your-feature-name

# Create PR to develop branch
```

### Release Process
```bash
# 1. Develop -> Staging
# Create PR from develop to staging
# After approval and merge, staging environment is automatically deployed

# 2. Staging -> Main
# After testing on staging, create PR from staging to main
# After approval and merge, production environment is automatically deployed
```

### Hotfix Process
```bash
# Create hotfix branch
git checkout main
git pull origin main
git checkout -b hotfix/critical-fix

# Fix issue
git add .
git commit -m "Fix critical issue"
git push origin hotfix/critical-fix

# Create PR to main
# After merge, also merge back to develop
```

## Branch Protection Rules

Recommended settings for protected branches (`main`, `staging`, `develop`):

1. **Require pull request reviews before merging**
   - Required approvals: 1+
   
2. **Require status checks to pass before merging**
   - CI/CD pipeline must pass
   - All tests must pass
   
3. **Require conversation resolution before merging**

4. **Do not allow bypassing the above settings**

5. **Require linear history** (optional, for cleaner history)

## Deployment

### Automatic Deployments

The project uses GitHub Actions for CI/CD:

- **Staging**: Automatically deploys when code is pushed to `staging` branch
- **Production**: Automatically deploys when code is pushed to `main` branch

### Manual Deployment

If you need to manually deploy:

```bash
# For staging
./deploy-staging.sh

# For production
./deploy-production.sh
```

## Environment Variables

Make sure to set up the following secrets in GitHub repository settings:

- `STAGING_DEPLOY_KEY` - Deployment credentials for staging
- `PRODUCTION_DEPLOY_KEY` - Deployment credentials for production
- Any other environment-specific variables

## CI/CD Pipeline

The CI/CD pipeline (`.github/workflows/ci-cd.yml`) includes:

1. **Test Job**: Runs unit and integration tests
2. **Lint Job**: Checks code quality and style
3. **Deploy Staging**: Deploys to staging environment (staging branch only)
4. **Deploy Production**: Deploys to production (main branch only)

## Setup Instructions

### Initial Setup

1. Clone the repository
```bash
git clone https://github.com/viratianrishav18/Lung-Disease-.git
cd Lung-Disease-
```

2. Fetch all branches
```bash
git fetch --all
```

3. Set up your development environment
```bash
# Checkout develop branch
git checkout develop

# Create your feature branch
git checkout -b feature/your-feature
```

### Setting Up Branch Protection

Navigate to GitHub repository settings:
1. Go to Settings → Branches
2. Add branch protection rules for `main`, `staging`, and `develop`
3. Configure the rules as mentioned in "Branch Protection Rules" section

## Monitoring and Rollback

### Monitoring Deployments

- Check GitHub Actions tab for deployment status
- Review logs for any deployment issues

### Rolling Back

If a deployment causes issues:

```bash
# For staging
git checkout staging
git reset --hard <previous-commit-hash>
git push origin staging --force-with-lease

# For production (use with extreme caution)
git checkout main
git reset --hard <previous-commit-hash>
git push origin main --force-with-lease
```

Note: Force pushing to protected branches may require temporarily disabling branch protection rules.

## Best Practices

1. Always create feature branches from `develop`
2. Keep commits atomic and meaningful
3. Write descriptive commit messages
4. Test locally before pushing
5. Keep branches up to date with base branch
6. Delete branches after merging
7. Use semantic versioning for releases
8. Tag releases on `main` branch

## Questions or Issues?

If you have questions about the branching strategy or deployment process, please:
- Check this documentation
- Review the CI/CD workflow file
- Create an issue in the repository
- Contact the project maintainers
