# DNS Load Testing Project

This project provides tools and configurations for DNS load testing using `dnsperf`.

## Prerequisites

### macOS Installation
```bash
# Install dnsperf using Homebrew
brew install dnsperf

# Alternative: Install from source
# git clone https://github.com/DNS-OARC/dnsperf.git
# cd dnsperf
# ./configure
# make
# sudo make install
```

### Linux Installation
```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install dnsperf

# CentOS/RHEL
sudo yum install dnsperf
# or
sudo dnf install dnsperf
```

## Project Structure

```
loadtest-dns/
├── README.md
├── USAGE-UV.md             # UV usage guide
├── setup.sh
├── analyze.sh              # Analysis menu
├── analyze-uv.sh           # UV-powered analysis (recommended)
├── test-your-domain.sh     # Quick domain test
├── configs/
│   ├── basic-test.conf
│   ├── stress-test.conf
│   └── custom-test.conf
├── queries/
│   ├── basic-queries.txt
│   ├── mixed-queries.txt
│   └── custom-queries.txt
├── scripts/
│   ├── run-basic-test.sh
│   ├── run-stress-test.sh
│   ├── run-custom-test.sh
│   └── analyze-results.py
└── results/
    └── .gitkeep
```

## Quick Start

1. **Setup the environment:**
   ```bash
   ./setup.sh
   ```

2. **Run a quick test for your domain:**
   ```bash
   ./test-your-domain.sh
   ```

3. **Analyze results with UV (recommended):**
   ```bash
   ./analyze-uv.sh results/quick_test_*.txt
   ```

4. **Run more comprehensive tests:**
   ```bash
   ./scripts/run-basic-test.sh              # Basic test
   ./scripts/run-stress-test.sh             # Stress test
   ./scripts/run-custom-test.sh             # Custom test with options
   ```

## Analysis Options

### 🚀 **UV-Powered Analysis (Recommended)**

The simplest and fastest way to analyze DNS test results:

```bash
# Automatic dependency management with UV
./analyze-uv.sh results/your-test-file.txt

# Without visualizations
./analyze-uv.sh results/your-test-file.txt --no-plot

# Show help
./analyze-uv.sh --help
```

**Benefits of UV:**
- ⚡ **Fast**: Much faster than pip for dependency resolution
- 🔒 **Reliable**: Consistent dependency versions across environments
- 🎯 **Simple**: Automatic environment management
- 📦 **Modern**: No virtual environment setup needed
- 🚀 **Zero Config**: Works out of the box

### 📊 **Alternative Analysis Methods**

```bash
# Basic Python analysis (no dependencies)
python3 scripts/analyze-results.py results/your-test-file.txt --no-plot

# Manual setup with virtual environment
python3 -m venv dns-env
source dns-env/bin/activate
pip install matplotlib pandas numpy seaborn plotly click
python3 scripts/analyze-results.py results/your-test-file.txt
```

## Configuration

### Query Files
Query files contain the DNS queries to test. Format:
```
domain_name query_type
example.com A
example.com AAAA
example.com MX
```

### Test Configurations
- `basic-test.conf`: Light load testing
- `stress-test.conf`: Heavy load testing
- `custom-test.conf`: Customizable parameters

## Usage Examples

### Basic DNS Performance Test
```bash
dnsperf -s 8.8.8.8 -d queries/basic-queries.txt -l 30 -Q 100
```

### Stress Test with Multiple Threads
```bash
dnsperf -s 8.8.8.8 -d queries/mixed-queries.txt -l 60 -Q 1000 -c 10
```

### Custom DNS Server Test
```bash
dnsperf -s your-dns-server.com -d queries/custom-queries.txt -l 120 -Q 500
```

### Testing Your Specific Domain
```bash
# Quick test
./test-your-domain.sh

# Custom test with different DNS servers
./scripts/run-custom-test.sh -s 1.1.1.1 -q 300 -d 60

# Analyze results with UV
./analyze-uv.sh results/latest-custom-test.txt
```

## Parameters Explanation

- `-s`: DNS server to test
- `-d`: Query data file
- `-l`: Test duration in seconds
- `-Q`: Queries per second
- `-c`: Number of concurrent connections
- `-t`: Timeout for queries (seconds)
- `-p`: Port number (default: 53)

## Results Analysis

### Analysis Features
- 📊 **Summary Report**: Key metrics and performance assessment
- 📈 **Visualizations**: Charts showing success rates, latency, QPS comparison
- 📄 **JSON Export**: Machine-readable results for further processing
- 🎯 **Performance Grading**: Automatic assessment (Excellent/Good/Fair/Poor)

### Analysis Output
The analysis provides:
- **Test Configuration**: DNS server, duration, target QPS
- **Query Statistics**: Sent, completed, lost queries with success rates
- **Performance Metrics**: Achieved QPS, latency (min/avg/max)
- **Response Codes**: NOERROR, NXDOMAIN, SERVFAIL counts
- **Visual Charts**: Success rates, latency distribution, QPS comparison

## Workflow Examples

### 1. Quick Domain Check
```bash
./test-your-domain.sh
./analyze-uv.sh results/quick_test_*.txt
```

### 2. Comprehensive Testing
```bash
# Test with different DNS servers
./scripts/run-custom-test.sh -s 8.8.8.8 -q 200
./scripts/run-custom-test.sh -s 1.1.1.1 -q 200
./scripts/run-custom-test.sh -s 9.9.9.9 -q 200

# Compare results with UV
./analyze-uv.sh results/custom_test_*.txt
```

### 3. Performance Benchmarking
```bash
# Light load
./scripts/run-basic-test.sh

# Heavy load
./scripts/run-stress-test.sh

# Analyze and compare
./analyze-uv.sh results/latest-basic-test.txt
./analyze-uv.sh results/latest-stress-test.txt
```

## Troubleshooting

### Common Issues
1. **Permission denied**: Run with sudo if needed
2. **DNS server unreachable**: Check network connectivity
3. **High packet loss**: Reduce query rate or increase timeout
4. **UV not found**: The scripts will auto-install uv via Homebrew or curl

### Performance Tips
- Start with lower query rates and gradually increase
- Monitor system resources during testing
- Use multiple query files for varied testing
- Test from different network locations
- Use UV for consistent Python environments

### UV Installation
UV will be automatically installed by the scripts, but if manual installation is needed:
```bash
# Homebrew (macOS)
brew install uv

# Curl installer (Linux/macOS)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Verify installation
uv --version
```

### UV Usage Tips
```bash
# Check UV version
uv --version

# List available Python versions
uv python list

# Run with specific Python version
uv run --python 3.11 python scripts/analyze-results.py results/test.txt

# Install dependencies globally for project
uv add matplotlib pandas numpy seaborn plotly click
``` 