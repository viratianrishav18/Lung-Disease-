# Branch Protection Rules Setup Guide

This document provides step-by-step instructions for setting up branch protection rules in your GitHub repository.

## Why Branch Protection?

Branch protection rules help maintain code quality by:
- Preventing direct pushes to important branches
- Requiring code reviews before merging
- Ensuring CI/CD checks pass before merging
- Maintaining a clean git history
- Reducing the risk of breaking production

## Prerequisites

- Repository admin access
- Branches created (main, staging, develop)
- CI/CD workflow configured (`.github/workflows/ci-cd.yml`)

## Quick Setup Checklist

- [ ] Protect `main` branch (strictest rules)
- [ ] Protect `staging` branch (strict rules)
- [ ] Protect `develop` branch (moderate rules)
- [ ] Set `develop` as default branch
- [ ] Configure required status checks
- [ ] Set up code owners (optional)

## Step-by-Step Setup

### 1. Access Branch Protection Settings

1. Navigate to your repository on GitHub
2. Click **Settings** (top right)
3. Click **Branches** in the left sidebar
4. Under "Branch protection rules", click **Add branch protection rule**

### 2. Protect `main` Branch (Production)

**Branch name pattern:** `main`

#### Pull Request Settings
- ✅ **Require a pull request before merging**
  - ✅ Require approvals: **2** (recommended for production)
  - ✅ Dismiss stale pull request approvals when new commits are pushed
  - ✅ Require review from Code Owners (if you have CODEOWNERS file)
  - ✅ Restrict who can dismiss pull request reviews
  - ✅ Allow specified actors to bypass required pull requests (optional)

#### Status Check Settings
- ✅ **Require status checks to pass before merging**
  - ✅ Require branches to be up to date before merging
  - Add required status checks:
    - `test` (from CI/CD workflow)
    - `lint` (from CI/CD workflow)
    - `deploy-production` (optional, to ensure deployment succeeds)

#### Additional Settings
- ✅ **Require conversation resolution before merging**
- ✅ **Require signed commits** (optional, for enhanced security)
- ✅ **Require linear history** (optional, prevents merge commits)
- ✅ **Require deployments to succeed before merging** (if using GitHub Deployments)
- ✅ **Lock branch** (optional, makes branch read-only)
- ✅ **Do not allow bypassing the above settings**
- ⚠️ **Allow force pushes** - Leave UNCHECKED
- ⚠️ **Allow deletions** - Leave UNCHECKED

#### Restrict Access
- ✅ **Restrict who can push to matching branches** (optional)
  - Select users/teams who can push (typically only CI/CD or release managers)

Click **Create** to save the rule.

### 3. Protect `staging` Branch (Pre-Production)

**Branch name pattern:** `staging`

#### Pull Request Settings
- ✅ **Require a pull request before merging**
  - ✅ Require approvals: **1**
  - ✅ Dismiss stale pull request approvals when new commits are pushed
  - ✅ Require review from Code Owners (optional)

#### Status Check Settings
- ✅ **Require status checks to pass before merging**
  - ✅ Require branches to be up to date before merging
  - Add required status checks:
    - `test`
    - `lint`
    - `deploy-staging` (optional)

#### Additional Settings
- ✅ **Require conversation resolution before merging**
- ✅ **Do not allow bypassing the above settings**
- ⚠️ **Allow force pushes** - Leave UNCHECKED
- ⚠️ **Allow deletions** - Leave UNCHECKED

Click **Create** to save the rule.

### 4. Protect `develop` Branch (Development)

**Branch name pattern:** `develop`

#### Pull Request Settings
- ✅ **Require a pull request before merging**
  - ✅ Require approvals: **1**
  - ⬜ Dismiss stale pull request approvals (optional, less strict for develop)

#### Status Check Settings
- ✅ **Require status checks to pass before merging**
  - ⬜ Require branches to be up to date (optional, for faster merging)
  - Add required status checks:
    - `test`
    - `lint`

#### Additional Settings
- ✅ **Require conversation resolution before merging**
- ⬜ **Do not allow bypassing the above settings** (allow admins to bypass for develop)
- ⚠️ **Allow force pushes** - Leave UNCHECKED
- ⚠️ **Allow deletions** - Leave UNCHECKED

Click **Create** to save the rule.

### 5. Set Default Branch

1. In Settings → Branches
2. Under "Default branch" section
3. Click the switch icon next to current default branch
4. Select **`develop`** from dropdown
5. Click **Update**
6. Confirm the change

This makes `develop` the default branch for new PRs.

### 6. Configure Code Owners (Optional but Recommended)

Create a `CODEOWNERS` file to automatically assign reviewers:

1. Create `.github/CODEOWNERS` file
2. Add ownership rules:

```
# Global owners
* @yourusername

# Specific paths
/docs/ @documentation-team
/.github/ @devops-team
/models/ @ml-team
/tests/ @qa-team

# Specific files
requirements.txt @devops-team
Dockerfile @devops-team
*.md @documentation-team
```

## Verification

After setting up protection rules, verify:

### Test Main Branch Protection
```bash
# This should fail
git checkout main
git pull origin main
echo "test" >> README.md
git commit -am "Direct commit"
git push origin main  # Should be rejected
```

### Test Proper Workflow
```bash
# This should work
git checkout develop
git checkout -b feature/test-protection
echo "test" >> README.md
git commit -am "Test commit"
git push origin feature/test-protection
# Create PR on GitHub - should require approval
```

## Common Configuration Patterns

### Pattern 1: Startup/Small Team
- `main`: 1 approval, all checks required
- `staging`: 1 approval, all checks required
- `develop`: 1 approval, all checks required

### Pattern 2: Growing Team
- `main`: 2 approvals, all checks required, require code owners
- `staging`: 1 approval, all checks required
- `develop`: 1 approval, checks required

### Pattern 3: Large Enterprise
- `main`: 2+ approvals, all checks, code owners, signed commits
- `staging`: 2 approvals, all checks, code owners
- `develop`: 1 approval, checks required

## Status Checks to Require

Based on `.github/workflows/ci-cd.yml`:

1. **test** - Unit and integration tests must pass
2. **lint** - Code linting and formatting must pass
3. **deploy-staging** - Only for staging branch
4. **deploy-production** - Only for main branch

### How to Find Status Check Names

1. Push a commit to a branch
2. Open a PR
3. Wait for GitHub Actions to run
4. The check names appear in the PR status section
5. Use these exact names in branch protection rules

## Troubleshooting

### Status Checks Not Appearing

**Issue:** Status checks don't show up in branch protection settings

**Solutions:**
1. Push to the branch and let workflow run at least once
2. Check workflow file syntax is correct
3. Ensure workflow is triggered for the branch (`on: push: branches:`)
4. Verify Actions are enabled in Settings → Actions

### Can't Merge PR Despite Approval

**Issue:** PR approved but can't merge

**Possible causes:**
1. Status checks haven't passed - wait for CI/CD to complete
2. Branch not up to date - click "Update branch" button
3. Conversations not resolved - resolve all comments
4. Required reviewers haven't approved - check code owners

### Need to Bypass Protection Temporarily

**Options:**
1. Admin can temporarily disable protection rule
2. Add yourself to "allow bypass" list
3. Use "Require status checks" but uncheck specific checks temporarily

**Important:** Always re-enable protection after emergency fix!

### Force Push Needed for History Cleanup

If you absolutely must force push:
1. Temporarily disable branch protection
2. Perform the force push
3. **Immediately re-enable protection**
4. Notify team members to re-sync their local branches

## Best Practices

### Do's ✅
- Always require PR reviews for protected branches
- Require all status checks to pass
- Use meaningful branch names and commit messages
- Keep protection rules consistent across environments
- Document any exceptions or special cases
- Review and update rules as team grows

### Don'ts ❌
- Don't allow bypassing rules without good reason
- Don't allow force pushes to protected branches
- Don't skip code reviews for "small changes"
- Don't disable protections without team awareness
- Don't commit directly to protected branches
- Don't allow deletions of protected branches

## Monitoring and Maintenance

### Regular Reviews
- Review protection rules quarterly
- Update based on team size and maturity
- Adjust approval requirements as needed
- Review and update code owners

### Metrics to Track
- Time to merge PRs
- Number of failed status checks
- Protection rule violations (should be zero)
- Number of emergency bypasses

## Advanced Configuration

### Rulesets (Beta Feature)

GitHub now offers rulesets as an alternative/complement to branch protection:

1. Go to Settings → Rules → Rulesets
2. Create new ruleset
3. Can target multiple branches with patterns
4. More flexible than traditional branch protection

### Environment Protection Rules

For deployment branches:

1. Go to Settings → Environments
2. Create `staging` and `production` environments
3. Add protection rules:
   - Required reviewers
   - Wait timer (e.g., 5 minutes for staging, 30 for production)
   - Deployment branches (limit which branches can deploy)

### Branch Protection with GitHub Apps

Integrate with external tools:
- Code Climate
- Codecov
- SonarQube
- Custom status checks via GitHub Apps

## Summary

You've now set up comprehensive branch protection for:
- ✅ `main` - Production (strictest rules)
- ✅ `staging` - Pre-production (strict rules)
- ✅ `develop` - Development (moderate rules)

This ensures:
- 🔒 No direct commits to protected branches
- 👥 Required code reviews
- ✅ All tests must pass
- 📝 Issues must be discussed and resolved
- 🚀 Safe and controlled deployments

## Additional Resources

- [GitHub Branch Protection Documentation](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/defining-the-mergeability-of-pull-requests/about-protected-branches)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Git Flow Workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow)

## Questions?

If you have questions about branch protection:
1. Check GitHub's official documentation
2. Review this guide
3. Create an issue in the repository
4. Contact repository administrators
