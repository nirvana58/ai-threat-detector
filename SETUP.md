# NIRVANA - Detailed Setup Guide

This guide provides step-by-step instructions for setting up and deploying the NIRVANA AI Network Threat Detector.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Local Development Setup](#local-development-setup)
3. [API Server Setup](#api-server-setup)
4. [Client Setup](#client-setup)
5. [Cloud Deployment](#cloud-deployment)
6. [Configuration](#configuration)
7. [Testing](#testing)
8. [Troubleshooting](#troubleshooting)

---

## Prerequisites

### System Requirements

- **Operating System**: Linux, macOS, or Windows (with WSL recommended)
- **Python**: Version 3.8 or higher (3.10+ recommended)
- **RAM**: Minimum 4GB (8GB+ recommended for LLM models)
- **Disk Space**: 5GB free (for dependencies and models)

### Required Software

1. **Python 3.8+**
   ```bash
   # Check Python version
   python3 --version
   
   # Install on Ubuntu/Debian
   sudo apt update
   sudo apt install python3 python3-pip
   
   # Install on macOS
   brew install python3
   ```

2. **Git**
   ```bash
   # Check Git version
   git --version
   
   # Install on Ubuntu/Debian
   sudo apt install git
   
   # Install on macOS
   brew install git
   ```

3. **pip (Python Package Manager)**
   ```bash
   # Upgrade pip
   python3 -m pip install --upgrade pip
   ```

---

## Local Development Setup

### Step 1: Clone the Repository

```bash
# Clone the repository
git clone https://github.com/yourusername/nirvana-threat-detector.git

# Navigate to project directory
cd nirvana-threat-detector

# Verify files
ls -la
```

You should see:
- `ntd-client.py`
- `requirements.txt`
- `run_ntd.sh`
- `README.md`
- `SETUP.md`

### Step 2: Create Virtual Environment (Recommended)

```bash
# Create virtual environment
python3 -m venv venv

# Activate virtual environment
# On Linux/macOS:
source venv/bin/activate

# On Windows:
venv\Scripts\activate

# Your prompt should now show (venv)
```

### Step 3: Install Dependencies

#### Option 1: Using the setup script (Recommended)

```bash
# Make script executable
chmod +x run_ntd.sh

# Run setup (will install dependencies automatically)
./run_ntd.sh
```

#### Option 2: Manual installation

```bash
# Install all dependencies
pip install -r requirements.txt

# Verify installation
pip list | grep -E "fastapi|pandas|scikit-learn|ollama"
```

### Step 4: Verify Installation

```bash
# Test Python imports
python3 -c "import pandas, sklearn, requests; print('✓ All imports successful')"
```

---

## API Server Setup

The API server should be set up by your administrator. This section is for server administrators.

### Step 1: Server Requirements

- **Python 3.10+**
- **Ollama** (for LLM support)
- **ML Model** (trained scikit-learn model)
- **Minimum 2GB RAM** (4GB+ recommended)

### Step 2: Install Ollama (Server-side)

```bash
# Install Ollama
curl https://ollama.ai/install.sh | sh

# Start Ollama service
ollama serve

# Pull recommended models
ollama pull llama3.2:1b
ollama pull phi3:mini
ollama pull gemma:2b

# Verify models
ollama list
```

### Step 3: Deploy API Server

```bash
# Install API dependencies
pip install -r requirements.txt

# Start the API server
uvicorn main:app --host 0.0.0.0 --port 8000

# Server should be running at http://localhost:8000
```

### Step 4: Generate API Keys

API keys should start with `ntd_` followed by a random string:

```python
import secrets

# Generate a secure API key
api_key = f"ntd_{secrets.token_urlsafe(32)}"
print(f"Generated API Key: {api_key}")
```

Store API keys securely and distribute to authorized users.

---

## Client Setup

### Quick Setup (Recommended)

```bash
# Run the automated setup
./run_ntd.sh --configure
```

Follow the prompts to enter:
1. API URL (e.g., `https://your-api.railway.app`)
2. API Key (provided by your administrator)

### Manual Setup

#### Step 1: Configure API Credentials

Create configuration file:

```bash
# Create config directory
mkdir -p ~/.ntd-client

# Create config file
cat > ~/.ntd-client/config.json << EOF
{
  "api_url": "https://your-api-url.railway.app",
  "api_key": "ntd_your_api_key_here"
}
EOF
```

#### Step 2: Set Environment Variables (Alternative)

```bash
# Add to ~/.bashrc or ~/.zshrc
export NTD_API_URL='https://your-api-url.railway.app'
export NTD_API_KEY='ntd_your_api_key_here'

# Reload shell configuration
source ~/.bashrc  # or source ~/.zshrc
```

#### Step 3: Verify Configuration

```bash
# Test connection
python3 ntd-client.py check

# Expected output:
# ✓ Connected to API
#   Status: healthy
#   ML Model: ✓ Ready
```

---

## Cloud Deployment

### Deploying to Railway

Railway is recommended for easy deployment.

#### Step 1: Prepare for Deployment

1. Create a `railway.toml` file:

```toml
[build]
builder = "NIXPACKS"

[deploy]
startCommand = "uvicorn main:app --host 0.0.0.0 --port $PORT"
restartPolicyType = "ON_FAILURE"
restartPolicyMaxRetries = 10
```

2. Create a `Procfile`:

```
web: uvicorn main:app --host 0.0.0.0 --port $PORT
```

#### Step 2: Deploy to Railway

```bash
# Install Railway CLI
npm install -g @railway/cli

# Login to Railway
railway login

# Initialize project
railway init

# Deploy
railway up
```

#### Step 3: Configure Environment Variables

In Railway dashboard, set:
- `OLLAMA_HOST` - URL of Ollama service
- `API_KEYS` - Comma-separated list of valid API keys
- `ML_MODEL_PATH` - Path to trained model file

#### Step 4: Get Your Deployment URL

```bash
# Get Railway URL
railway domain

# Your API will be available at:
# https://your-project.up.railway.app
```

### Deploying to AWS

For AWS deployment, refer to AWS documentation for:
- EC2 instance setup
- Load balancer configuration
- Security group settings

---

## Configuration

### Client Configuration Options

#### Configuration File (`~/.ntd-client/config.json`)

```json
{
  "api_url": "https://your-api.railway.app",
  "api_key": "ntd_your_api_key_here",
  "default_llm_model": "llama3.2:1b",
  "default_threshold": 0.7,
  "auto_save_results": true
}
```

#### Environment Variables

```bash
# Required
export NTD_API_URL='https://your-api.railway.app'
export NTD_API_KEY='ntd_your_api_key_here'

# Optional
export NTD_DEFAULT_MODEL='llama3.2:1b'
export NTD_THRESHOLD='0.7'
```

### Network Data Format

#### CSV Format Example

```csv
timestamp,src_ip,dst_ip,src_port,dst_port,protocol,bytes,packets,duration,flags
2024-01-01 10:00:00,192.168.1.100,10.0.0.5,54321,80,TCP,1024,10,0.5,SYN
2024-01-01 10:00:01,192.168.1.100,10.0.0.5,54321,80,TCP,2048,15,0.8,ACK
```

#### JSON Format Example

```json
[
  {
    "timestamp": "2024-01-01 10:00:00",
    "src_ip": "192.168.1.100",
    "dst_ip": "10.0.0.5",
    "src_port": 54321,
    "dst_port": 80,
    "protocol": "TCP",
    "bytes": 1024,
    "packets": 10,
    "duration": 0.5,
    "flags": "SYN"
  }
]
```

---

## Testing

### Test API Connection

```bash
# Basic health check
curl https://your-api.railway.app/health

# Expected response:
# {"status":"healthy","ml_model":true}
```

### Test Authentication

```bash
# List available models
curl -H "Authorization: Bearer ntd_your_api_key" \
     https://your-api.railway.app/models
```

### Test Analysis

```bash
# Create test data
echo "src_ip,dst_ip,protocol,bytes
192.168.1.1,10.0.0.1,TCP,1024" > test_data.csv

# Analyze data
python3 ntd-client.py analyze test_data.csv --no-llm
```

### Run Test Suite

```bash
# Test all functionality
python3 ntd-client.py check
python3 ntd-client.py models
python3 ntd-client.py analyze test_data.csv --no-llm
```

---

## Troubleshooting

### Common Issues

#### 1. Connection Refused

**Problem**: Cannot connect to API

**Solutions**:
```bash
# Check API URL format
curl https://your-api.railway.app/health

# Verify URL in config
cat ~/.ntd-client/config.json

# Test with explicit URL
python3 ntd-client.py --api-url https://your-api.railway.app check
```

#### 2. Invalid API Key

**Problem**: 401 Unauthorized error

**Solutions**:
```bash
# Verify API key format (should start with 'ntd_')
echo $NTD_API_KEY

# Re-configure
./run_ntd.sh --configure

# Test with explicit key
python3 ntd-client.py --api-key ntd_your_key check
```

#### 3. Import Errors

**Problem**: `ModuleNotFoundError`

**Solutions**:
```bash
# Reinstall dependencies
pip install -r requirements.txt

# Install specific missing package
pip install pandas  # or sklearn, requests, etc.

# Use virtual environment
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

#### 4. LLM Model Not Available

**Problem**: Model not found error

**Solutions**:
```bash
# List available models
python3 ntd-client.py models

# Use a different model
python3 ntd-client.py analyze data.csv --llm-model phi3:mini

# Disable LLM analysis
python3 ntd-client.py analyze data.csv --no-llm
```

#### 5. Slow Performance

**Problem**: Analysis takes too long

**Solutions**:
```bash
# Use faster model
python3 ntd-client.py analyze data.csv --llm-model llama3.2:1b

# Disable LLM for large datasets
python3 ntd-client.py analyze large_data.csv --no-llm

# Increase confidence threshold (fewer LLM calls)
python3 ntd-client.py analyze data.csv --threshold 0.9
```

### Debug Mode

Enable verbose logging:

```bash
# Add debug output
python3 -v ntd-client.py analyze data.csv

# Check API logs (server-side)
railway logs
```

### Getting Help

If problems persist:

1. **Check logs**: Review error messages carefully
2. **Verify configuration**: Ensure all settings are correct
3. **Test connection**: Run `ntd-client.py check`
4. **Update dependencies**: Run `pip install -r requirements.txt --upgrade`
5. **Open an issue**: Create a GitHub issue with error details

---

## Advanced Configuration

### Custom LLM Models

To use custom Ollama models:

```bash
# Server-side: Pull custom model
ollama pull custom-model:latest

# Client-side: Use custom model
python3 ntd-client.py analyze data.csv --llm-model custom-model:latest
```

### Batch Processing

Process multiple files:

```bash
# Create batch script
for file in data/*.csv; do
    echo "Processing $file..."
    python3 ntd-client.py analyze "$file" --no-llm
done
```

### Integration with Scripts

```python
import subprocess

# Call from Python script
result = subprocess.run([
    'python3', 'ntd-client.py', 'analyze',
    'network_data.csv', '--no-llm'
], capture_output=True, text=True)

print(result.stdout)
```

---

## Next Steps

1. ✅ Complete setup using this guide
2. ✅ Test with sample data
3. ✅ Configure for your environment
4. ✅ Integrate with your monitoring systems
5. ✅ Set up automated threat detection

For more information, see [README.md](README.md)

---

**Need Help?** 

- GitHub Issues: [Report a problem](https://github.com/yourusername/nirvana-threat-detector/issues)
- Documentation: Additional guides in `/docs`
- Community: Join our Discord/Slack channel
