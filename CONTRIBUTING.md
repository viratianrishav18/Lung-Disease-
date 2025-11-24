# Contributing to Lung Disease Predictor

Thank you for your interest in contributing! This document provides guidelines for contributing to the project.

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally
   ```bash
   git clone https://github.com/YOUR_USERNAME/Lung-Disease-.git
   cd Lung-Disease-
   ```
3. **Set up the development environment**
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   pip install -r requirements.txt
   ```

## Development Workflow

### 1. Create a Feature Branch

Always create a new branch from `develop`:

```bash
git checkout develop
git pull origin develop
git checkout -b feature/your-feature-name
```

Branch naming conventions:
- `feature/` - New features (e.g., `feature/add-disease-classifier`)
- `bugfix/` - Bug fixes (e.g., `bugfix/fix-prediction-error`)
- `hotfix/` - Emergency fixes (e.g., `hotfix/critical-security-patch`)
- `docs/` - Documentation updates (e.g., `docs/update-readme`)

### 2. Make Your Changes

- Write clean, readable code
- Follow Python PEP 8 style guidelines
- Add comments where necessary
- Write meaningful commit messages

### 3. Test Your Changes

```bash
# Run tests
pytest

# Run linting
flake8 .
black --check .
isort --check-only .

# Format code (if needed)
black .
isort .
```

### 4. Commit Your Changes

Write clear, descriptive commit messages:

```bash
git add .
git commit -m "Add feature: disease classification for X-rays"
```

Good commit message examples:
- ✅ "Add XGBoost model for lung disease prediction"
- ✅ "Fix: Correct data preprocessing pipeline"
- ✅ "Update: Improve model accuracy by 5%"
- ❌ "Fixed stuff"
- ❌ "Update"

### 5. Push to Your Fork

```bash
git push origin feature/your-feature-name
```

### 6. Create a Pull Request

1. Go to the original repository on GitHub
2. Click "New Pull Request"
3. Select your fork and branch
4. Fill in the PR template with:
   - Description of changes
   - Related issues
   - Testing performed
   - Screenshots (if applicable)

## Code Style Guidelines

### Python Style

- Follow PEP 8
- Use meaningful variable and function names
- Maximum line length: 88 characters (Black default)
- Use type hints where appropriate

```python
# Good
def predict_disease(image_path: str) -> dict:
    """Predict lung disease from X-ray image.
    
    Args:
        image_path: Path to the X-ray image
        
    Returns:
        Dictionary with prediction results
    """
    # Implementation
    pass

# Avoid
def pred(img):
    pass
```

### Documentation

- Add docstrings to all functions and classes
- Use Google-style docstrings
- Update README.md if adding new features
- Add inline comments for complex logic

### Testing

- Write tests for new features
- Maintain or improve test coverage
- Test edge cases and error handling
- Use descriptive test names

```python
def test_disease_prediction_with_valid_image():
    """Test that disease prediction works with a valid X-ray image."""
    result = predict_disease("test_image.jpg")
    assert result["confidence"] > 0.5
    assert "disease" in result
```

## Pull Request Guidelines

### Before Submitting

- [ ] Code follows project style guidelines
- [ ] All tests pass
- [ ] New tests added for new features
- [ ] Documentation updated
- [ ] Commit messages are clear
- [ ] Branch is up to date with develop

### PR Description Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Performance improvement
- [ ] Code refactoring

## Related Issues
Closes #123

## Testing
Describe testing performed

## Screenshots (if applicable)
Add screenshots here

## Checklist
- [ ] Tests pass
- [ ] Code is formatted
- [ ] Documentation updated
```

## Code Review Process

1. **Automated Checks**: CI/CD pipeline runs automatically
2. **Peer Review**: At least one approval required
3. **Address Feedback**: Make requested changes
4. **Merge**: Once approved, PR will be merged

### Review Timeline

- Initial review: Within 2-3 business days
- Follow-up reviews: Within 1-2 business days

## Reporting Issues

### Bug Reports

Include:
- Clear title and description
- Steps to reproduce
- Expected vs actual behavior
- Environment details (OS, Python version, etc.)
- Screenshots or error messages
- Relevant code snippets

### Feature Requests

Include:
- Clear description of the feature
- Use case and benefits
- Possible implementation approach
- Any alternative solutions considered

## Community Guidelines

### Code of Conduct

- Be respectful and inclusive
- Accept constructive criticism
- Focus on what's best for the project
- Show empathy towards others

### Getting Help

- Check existing issues and documentation
- Ask questions in issue discussions
- Join community discussions
- Tag maintainers if needed (@username)

## Development Setup

### Prerequisites

- Python 3.8+
- Git
- Virtual environment tool

### Local Development

```bash
# Create virtual environment
python -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Install development dependencies
pip install pytest pytest-cov flake8 black isort

# Run tests
pytest

# Run with coverage
pytest --cov=. --cov-report=html
```

### Docker Development

```bash
# Build image
docker build -t lung-disease .

# Run container
docker run -p 8000:8000 lung-disease

# Or use docker-compose
docker-compose up
```

## Project Structure

```
Lung-Disease-/
├── .github/
│   └── workflows/          # CI/CD workflows
├── models/                 # Trained models
├── src/                    # Source code
├── tests/                  # Test files
├── docs/                   # Documentation
├── data/                   # Data files
├── requirements.txt        # Dependencies
├── Dockerfile             # Docker configuration
├── README.md              # Project overview
└── CONTRIBUTING.md        # This file
```

## License

By contributing, you agree that your contributions will be licensed under the same license as the project (see LICENSE file).

## Recognition

Contributors will be recognized in:
- Project README
- Release notes
- Contributors list

Thank you for contributing! 🎉
