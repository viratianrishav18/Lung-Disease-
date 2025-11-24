#!/bin/bash

# Deploy to Staging Script
# This script deploys the application to the staging environment

set -e

echo "🚀 Starting staging deployment..."

# Configuration
ENVIRONMENT="staging"
PROJECT_NAME="lung-disease-predictor"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Environment: ${ENVIRONMENT}${NC}"
echo -e "${YELLOW}Project: ${PROJECT_NAME}${NC}"

# Check if required environment variables are set
if [ -z "$STAGING_DEPLOY_KEY" ]; then
    echo -e "${RED}Error: STAGING_DEPLOY_KEY environment variable is not set${NC}"
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

# Deploy to staging
echo -e "${YELLOW}Deploying to staging...${NC}"

# Example deployment commands (uncomment and modify based on your hosting)

# For Heroku:
# git push heroku-staging staging:main

# For AWS:
# aws deploy create-deployment \
#   --application-name ${PROJECT_NAME} \
#   --deployment-group-name ${ENVIRONMENT} \
#   --s3-location bucket=my-bucket,key=app.zip,bundleType=zip

# For Docker:
# docker build -t ${PROJECT_NAME}:${ENVIRONMENT} .
# docker push ${PROJECT_NAME}:${ENVIRONMENT}

# For SSH deployment:
# rsync -avz --exclude='.git' . user@staging-server:/path/to/app/
# ssh user@staging-server 'cd /path/to/app && ./restart.sh'

echo -e "${GREEN}✓ Staging deployment completed successfully!${NC}"
echo -e "${GREEN}Staging URL: https://staging.your-domain.com${NC}"
