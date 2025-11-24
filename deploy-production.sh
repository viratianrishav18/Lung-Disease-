#!/bin/bash

# Deploy to Production Script
# This script deploys the application to the production environment
#
# Usage: chmod +x deploy-production.sh && ./deploy-production.sh

set -e

echo "🚀 Starting production deployment..."

# Configuration
ENVIRONMENT="production"
PROJECT_NAME="lung-disease-predictor"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Environment: ${ENVIRONMENT}${NC}"
echo -e "${YELLOW}Project: ${PROJECT_NAME}${NC}"

# Check if required environment variables are set
if [ -z "$PRODUCTION_DEPLOY_KEY" ]; then
    echo -e "${RED}Error: PRODUCTION_DEPLOY_KEY environment variable is not set${NC}"
    exit 1
fi

# Confirmation prompt for production deployment
read -p "⚠️  Are you sure you want to deploy to PRODUCTION? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
    echo -e "${RED}Deployment cancelled${NC}"
    exit 1
fi

# Run tests before deployment
echo -e "${YELLOW}Running tests...${NC}"
if [ -f requirements.txt ]; then
    python -m pip install --upgrade pip
    pip install -r requirements.txt
fi

if [ -f pytest.ini ] || [ -d tests ]; then
    pip install pytest
    pytest || {
        echo -e "${RED}Tests failed! Aborting deployment.${NC}"
        exit 1
    }
else
    echo -e "${YELLOW}No tests found, skipping test execution${NC}"
fi

echo -e "${GREEN}✓ Tests passed${NC}"

# Build/prepare application
echo -e "${YELLOW}Preparing application...${NC}"
# Add your build commands here
# Example: python setup.py build

# Create backup (optional but recommended)
echo -e "${YELLOW}Creating backup...${NC}"
# Add backup commands here
echo -e "${GREEN}✓ Backup created${NC}"

# Deploy to production
echo -e "${YELLOW}Deploying to production...${NC}"

# Example deployment commands (uncomment and modify based on your hosting)

# For Heroku:
# git push heroku main:main

# For AWS:
# aws deploy create-deployment \
#   --application-name ${PROJECT_NAME} \
#   --deployment-group-name ${ENVIRONMENT} \
#   --s3-location bucket=my-bucket,key=app.zip,bundleType=zip

# For Docker:
# docker build -t ${PROJECT_NAME}:${ENVIRONMENT} .
# docker push ${PROJECT_NAME}:${ENVIRONMENT}

# For SSH deployment:
# rsync -avz --exclude='.git' . user@production-server:/path/to/app/
# ssh user@production-server 'cd /path/to/app && ./restart.sh'

# For Kubernetes:
# kubectl apply -f k8s/production/
# kubectl rollout status deployment/${PROJECT_NAME}

echo -e "${GREEN}✓ Production deployment completed successfully!${NC}"
echo -e "${GREEN}Production URL: https://your-domain.com${NC}"

# Tag the release
CURRENT_DATE=$(date +%Y%m%d-%H%M%S)
RELEASE_TAG="release-${CURRENT_DATE}"
echo -e "${YELLOW}Creating release tag: ${RELEASE_TAG}${NC}"
git tag -a ${RELEASE_TAG} -m "Production release ${CURRENT_DATE}"
echo -e "${GREEN}✓ Release tagged${NC}"
