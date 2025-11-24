# Deployment Configuration

## Environment Variables

### Staging Environment

```bash
# Application
APP_ENV=staging
DEBUG=true
LOG_LEVEL=debug

# Database (example)
# DB_HOST=staging-db.example.com
# DB_PORT=5432
# DB_NAME=lung_disease_staging
# DB_USER=staging_user
# DB_PASSWORD=<set-in-secrets>

# API Keys (set in GitHub Secrets)
# API_KEY=<set-in-secrets>

# URLs
# APP_URL=https://staging.your-domain.com
# API_URL=https://api-staging.your-domain.com
```

### Production Environment

```bash
# Application
APP_ENV=production
DEBUG=false
LOG_LEVEL=info

# Database (example)
# DB_HOST=production-db.example.com
# DB_PORT=5432
# DB_NAME=lung_disease_prod
# DB_USER=prod_user
# DB_PASSWORD=<set-in-secrets>

# API Keys (set in GitHub Secrets)
# API_KEY=<set-in-secrets>

# URLs
# APP_URL=https://your-domain.com
# API_URL=https://api.your-domain.com
```

## GitHub Secrets Setup

To set up deployment secrets in GitHub:

1. Go to repository Settings
2. Navigate to Secrets and variables → Actions
3. Click "New repository secret"
4. Add the following secrets:

### Required Secrets

- `STAGING_DEPLOY_KEY` - Deployment credentials for staging
- `PRODUCTION_DEPLOY_KEY` - Deployment credentials for production

### Optional Secrets (based on your deployment needs)

- `DB_PASSWORD_STAGING` - Database password for staging
- `DB_PASSWORD_PRODUCTION` - Database password for production
- `API_KEY` - External API keys
- `AWS_ACCESS_KEY_ID` - AWS credentials (if using AWS)
- `AWS_SECRET_ACCESS_KEY` - AWS secret key (if using AWS)
- `HEROKU_API_KEY` - Heroku API key (if using Heroku)
- `DOCKER_USERNAME` - Docker Hub username (if using Docker)
- `DOCKER_PASSWORD` - Docker Hub password (if using Docker)

## Deployment Platforms

### Option 1: Heroku

Add Heroku app configuration:

```bash
# Install Heroku CLI
curl https://cli-assets.heroku.com/install.sh | sh

# Login to Heroku
heroku login

# Create apps
heroku create lung-disease-staging --remote staging
heroku create lung-disease-production --remote production

# Set environment variables
heroku config:set APP_ENV=staging --app lung-disease-staging
heroku config:set APP_ENV=production --app lung-disease-production

# Deploy
git push staging develop:main
git push production main:main
```

### Option 2: AWS (Elastic Beanstalk)

```bash
# Install AWS CLI
pip install awsebcli

# Initialize EB
eb init -p python-3.10 lung-disease-predictor

# Create environments
eb create lung-disease-staging
eb create lung-disease-production

# Deploy
eb deploy lung-disease-staging
eb deploy lung-disease-production
```

### Option 3: Docker + Cloud Run (GCP)

```dockerfile
# Create Dockerfile
FROM python:3.10-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
CMD ["python", "app.py"]
```

```bash
# Build and push
docker build -t gcr.io/project-id/lung-disease:latest .
docker push gcr.io/project-id/lung-disease:latest

# Deploy to Cloud Run
gcloud run deploy lung-disease-staging \
  --image gcr.io/project-id/lung-disease:latest \
  --platform managed \
  --region us-central1
```

### Option 4: Traditional Server (SSH)

```bash
# Add server SSH key to GitHub Secrets as STAGING_SSH_KEY

# Deployment commands in GitHub Actions
- name: Deploy via SSH
  uses: appleboy/ssh-action@master
  with:
    host: ${{ secrets.STAGING_HOST }}
    username: ${{ secrets.STAGING_USER }}
    key: ${{ secrets.STAGING_SSH_KEY }}
    script: |
      cd /path/to/app
      git pull origin staging
      pip install -r requirements.txt
      systemctl restart lung-disease
```

## Health Checks

Add health check endpoints to monitor deployments:

```python
# app.py or main.py
@app.route('/health')
def health():
    return {'status': 'healthy', 'environment': os.getenv('APP_ENV')}

@app.route('/version')
def version():
    return {'version': '1.0.0', 'commit': os.getenv('GIT_COMMIT')}
```

## Monitoring

### Application Monitoring

- Set up application performance monitoring (APM)
- Configure error tracking (e.g., Sentry)
- Set up logging aggregation

### Infrastructure Monitoring

- Monitor server resources (CPU, memory, disk)
- Set up uptime monitoring
- Configure alerts for critical issues

## Rollback Procedure

If a deployment causes issues:

### Automated Rollback (Recommended)

```bash
# Revert the merge commit
git revert <merge-commit-hash>
git push origin main  # or staging
```

### Manual Rollback

```bash
# For staging
git checkout staging
git reset --hard <previous-working-commit>
git push origin staging --force-with-lease

# For production (use with extreme caution)
git checkout main
git reset --hard <previous-working-commit>
git push origin main --force-with-lease
```

## Deployment Checklist

Before deploying to production:

- [ ] All tests pass
- [ ] Code review completed
- [ ] Staging testing completed
- [ ] Database migrations tested
- [ ] Environment variables configured
- [ ] Monitoring and alerts set up
- [ ] Backup created
- [ ] Rollback plan documented
- [ ] Team notified
- [ ] Documentation updated

## Post-Deployment

After successful deployment:

1. Verify application is running
2. Check health endpoints
3. Monitor logs for errors
4. Run smoke tests
5. Notify team of successful deployment
6. Create release notes/changelog
7. Tag the release in Git

## Troubleshooting

### Common Issues

**Deployment fails with authentication error**
- Check that deployment keys/credentials are correctly set in GitHub Secrets
- Verify the secrets haven't expired

**Application crashes after deployment**
- Check logs: `heroku logs --tail` or equivalent
- Verify environment variables are set correctly
- Check database connection

**Tests fail in CI/CD**
- Run tests locally to reproduce
- Check for environment-specific issues
- Verify dependencies are installed correctly

**Merge conflicts**
- Resolve conflicts locally
- Test thoroughly before pushing
- Update branch with latest changes regularly

## Support

For deployment issues:
1. Check logs in GitHub Actions
2. Review deployment documentation
3. Create an issue with deployment details
4. Contact DevOps team if needed
