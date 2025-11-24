# Lung Disease Predictor

A machine learning application that predicts lung diseases based on medical data.

## 🌳 Branch Structure

This project follows a **Git Flow** branching strategy:

- **main** - Production-ready code (protected)
- **staging** - Pre-production testing environment (protected)
- **develop** - Main development branch (protected)
- **feature/*** - Feature development branches
- **bugfix/*** - Bug fix branches
- **hotfix/*** - Emergency production fixes

📖 For detailed branching strategy and workflow, see [BRANCHING_STRATEGY.md](./BRANCHING_STRATEGY.md)

## 🚀 Quick Start

### Clone the Repository

```bash
git clone https://github.com/viratianrishav18/Lung-Disease-.git
cd Lung-Disease-
```

### Set Up Development Environment

```bash
# Checkout develop branch
git checkout develop

# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies (when available)
pip install -r requirements.txt
```

### Create a Feature Branch

```bash
# From develop branch
git checkout develop
git pull origin develop
git checkout -b feature/your-feature-name

# Work on your feature
git add .
git commit -m "Add feature description"
git push origin feature/your-feature-name

# Create a Pull Request to develop branch
```

## 📦 Deployment

### Automatic Deployment (CI/CD)

The project uses GitHub Actions for continuous integration and deployment:

- **Push to `staging`** → Automatically deploys to staging environment
- **Push to `main`** → Automatically deploys to production environment

All deployments require:
- ✅ All tests passing
- ✅ Code linting checks passing
- ✅ Pull request review approval

### Manual Deployment

```bash
# Deploy to staging
./deploy-staging.sh

# Deploy to production
./deploy-production.sh
```

## 🔒 Branch Protection

Protected branches (`main`, `staging`, `develop`) require:
- Pull request reviews before merging
- Status checks to pass (CI/CD pipeline)
- Up-to-date branches
- Conversation resolution

## 📋 Development Workflow

1. **Create Feature Branch** from `develop`
2. **Develop & Test** your changes locally
3. **Create Pull Request** to `develop`
4. **Code Review** by team members
5. **Merge to Develop** after approval
6. **Test on Staging** (merge `develop` → `staging`)
7. **Deploy to Production** (merge `staging` → `main`)

## 🧪 Testing

```bash
# Install test dependencies
pip install pytest

# Run tests
pytest
```

## 🛠️ CI/CD Pipeline

The CI/CD pipeline includes:
- **Test Job** - Runs unit and integration tests
- **Lint Job** - Code quality and style checks
- **Deploy Staging** - Automatic deployment to staging
- **Deploy Production** - Automatic deployment to production

View the pipeline configuration: [.github/workflows/ci-cd.yml](.github/workflows/ci-cd.yml)

## 📚 Documentation

- [Branching Strategy](./BRANCHING_STRATEGY.md) - Detailed branch workflow and best practices
- [CI/CD Pipeline](.github/workflows/ci-cd.yml) - Automated testing and deployment

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the terms specified in the [LICENSE](./LICENSE) file.

## 🔗 Project Links

- **Repository**: https://github.com/viratianrishav18/Lung-Disease-
- **Issues**: https://github.com/viratianrishav18/Lung-Disease-/issues
- **Pull Requests**: https://github.com/viratianrishav18/Lung-Disease-/pulls

## 📧 Contact

For questions or support, please open an issue in the repository.
