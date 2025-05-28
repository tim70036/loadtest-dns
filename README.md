# DNS Load Testing Project

This project provides tools and configurations for DNS load testing using `dnsperf`.

## Prerequisites

### macOS Installation
```bash
# Install dnsperf using Homebrew
brew install dnsperf
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
├── test-your-domain.sh     # Quick domain test
├── analyze-uv.sh           # UV-powered analysis tool
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
│   └── run-custom-test.sh
├── analyzer/               # Standalone DNS analyzer project
├── analyzer-results/       # Analysis reports and visualizations
└── dnsperf-results/        # DNS test output files
```

## Quick Start

1. **Run a quick test for your domain:**
   ```bash
   ./test-your-domain.sh
   ```

2. **Analyze results:**
   ```bash
   ./analyze-uv.sh dnsperf-results/quick_test_*.txt
   ```

3. **Run comprehensive tests:**
   ```bash
   ./scripts/run-basic-test.sh              # Basic test
   ./scripts/run-stress-test.sh             # Stress test
   ./scripts/run-custom-test.sh             # Custom test with options
   ```

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

# Analyze results
./analyze-uv.sh dnsperf-results/latest-custom-test.txt
```

## Analysis with UV

The project uses UV for fast and reliable dependency management:

```bash
# Analyze test results with visualizations
./analyze-uv.sh dnsperf-results/your-test-file.txt

# Without visualizations
./analyze-uv.sh dnsperf-results/your-test-file.txt --no-plot

# Show help
./analyze-uv.sh --help
```

**Benefits of UV:**
- ⚡ **Fast**: Much faster than pip for dependency resolution
- 🔒 **Reliable**: Consistent dependency versions across environments
- 🎯 **Simple**: Automatic environment management
- 📦 **Modern**: No virtual environment setup needed

### Standalone DNS Analyzer

For advanced analysis, use the dedicated DNS analyzer project:

```bash
# Navigate to the standalone analyzer
cd analyzer

# Install dependencies (one-time setup)
uv sync

# Use the standalone analyzer
uv run dns-analyzer dnsperf-results/your-test-file.txt
```

See `analyzer/README.md` for detailed usage instructions.

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
./analyze-uv.sh dnsperf-results/quick_test_*.txt
```

### 2. Comprehensive Testing
```bash
# Test with different DNS servers
./scripts/run-custom-test.sh -s 8.8.8.8 -q 200
./scripts/run-custom-test.sh -s 1.1.1.1 -q 200
./scripts/run-custom-test.sh -s 9.9.9.9 -q 200

# Compare results
./analyze-uv.sh dnsperf-results/custom_test_*.txt
```

### 3. Performance Benchmarking
```bash
# Light load
./scripts/run-basic-test.sh

# Heavy load
./scripts/run-stress-test.sh

# Analyze and compare
./analyze-uv.sh dnsperf-results/latest-basic-test.txt
./analyze-uv.sh dnsperf-results/latest-stress-test.txt
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