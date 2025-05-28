# DNS Load Testing Project

A comprehensive toolkit for DNS performance testing and analysis using `dnsperf`.

## Prerequisites

### macOS Installation
```bash
brew install dnsperf
```

### Linux Installation
```bash
# Ubuntu/Debian
sudo apt-get update && sudo apt-get install dnsperf

# CentOS/RHEL
sudo yum install dnsperf  # or sudo dnf install dnsperf
```

## Project Structure

```
loadtest-dns/
├── test-your-domain.sh     # Quick domain test
├── analyze-uv.sh           # Analysis tool
├── configs/                # Test configurations
├── queries/                # DNS query files
├── scripts/                # Test execution scripts
├── analyzer/               # Standalone analyzer
├── analyzer-results/       # Analysis reports
└── dnsperf-results/        # Test output files
```

## Quick Start

### 1. Test Your Domain
```bash
./test-your-domain.sh
```

### 2. Analyze Results
```bash
./analyze-uv.sh dnsperf-results/quick_test_*.txt
```

### 3. Run Comprehensive Tests
```bash
./scripts/run-basic-test.sh      # Light load test
./scripts/run-stress-test.sh     # Heavy load test
./scripts/run-custom-test.sh     # Customizable test
```

## Usage Examples

### Basic Performance Test
```bash
dnsperf -s 8.8.8.8 -d queries/basic-queries.txt -l 30 -Q 100
```

### Stress Test
```bash
dnsperf -s 8.8.8.8 -d queries/mixed-queries.txt -l 60 -Q 1000 -c 10
```

### Custom DNS Server Test
```bash
dnsperf -s your-dns-server.com -d queries/custom-queries.txt -l 120 -Q 500
```

### Testing Different DNS Providers
```bash
# Test multiple DNS servers
./scripts/run-custom-test.sh -s 8.8.8.8 -q 200    # Google DNS
./scripts/run-custom-test.sh -s 1.1.1.1 -q 200    # Cloudflare DNS
./scripts/run-custom-test.sh -s 9.9.9.9 -q 200    # Quad9 DNS

# Compare results
./analyze-uv.sh dnsperf-results/custom_test_*.txt
```

## Configuration

### Query Files
Query files define the DNS queries to test:
```
example.com A
example.com AAAA
example.com MX
subdomain.example.com A
```

### Available Configurations
- **basic-test.conf**: Light load testing (100 QPS, 30s)
- **stress-test.conf**: Heavy load testing (1000 QPS, 60s)
- **custom-test.conf**: Customizable parameters

## Key Parameters

| Parameter | Description | Example |
|-----------|-------------|---------|
| `-s` | DNS server to test | `8.8.8.8` |
| `-d` | Query data file | `queries/basic-queries.txt` |
| `-l` | Test duration (seconds) | `60` |
| `-Q` | Queries per second | `500` |
| `-c` | Concurrent connections | `10` |
| `-t` | Query timeout (seconds) | `5` |
| `-p` | Port number | `53` |

## Analysis Features

The analysis tool provides:
- **Performance Summary**: QPS, latency, success rates
- **Visual Charts**: Success rates, latency distribution, QPS comparison
- **Response Analysis**: NOERROR, NXDOMAIN, SERVFAIL breakdown
- **Performance Grading**: Automatic assessment (Excellent/Good/Fair/Poor)
- **JSON Export**: Machine-readable results

### Analysis Options
```bash
# Full analysis with charts
./analyze-uv.sh dnsperf-results/test-file.txt

# Text-only analysis
./analyze-uv.sh dnsperf-results/test-file.txt --no-plot

# Show help
./analyze-uv.sh --help
```

## Common Workflows

### Performance Benchmarking
```bash
# Run tests with increasing load
./scripts/run-basic-test.sh
./scripts/run-stress-test.sh

# Analyze results
./analyze-uv.sh dnsperf-results/latest-basic-test.txt
./analyze-uv.sh dnsperf-results/latest-stress-test.txt
```

### DNS Provider Comparison
```bash
# Test multiple providers
for dns in 8.8.8.8 1.1.1.1 9.9.9.9; do
    ./scripts/run-custom-test.sh -s $dns -q 300 -d 60
done

# Compare all results
./analyze-uv.sh dnsperf-results/custom_test_*.txt
```

### Load Testing Your Infrastructure
```bash
# Test your DNS server
./scripts/run-custom-test.sh -s your-dns-server.com -q 100 -d 300

# Gradually increase load
./scripts/run-custom-test.sh -s your-dns-server.com -q 500 -d 300
./scripts/run-custom-test.sh -s your-dns-server.com -q 1000 -d 300
```

## Troubleshooting

### Common Issues
- **Permission denied**: Run with `sudo` if needed
- **DNS server unreachable**: Check network connectivity and firewall
- **High packet loss**: Reduce query rate (`-Q`) or increase timeout (`-t`)
- **Resource exhaustion**: Monitor CPU/memory during high-load tests

### Performance Tips
- Start with low query rates and gradually increase
- Use appropriate query files for your use case
- Test from multiple network locations for comprehensive results
- Monitor system resources during testing

### Dependencies
The analysis scripts use UV for Python dependency management. UV will be automatically installed if not present:
```bash
# Manual installation if needed
brew install uv  # macOS
curl -LsSf https://astral.sh/uv/install.sh | sh  # Linux/macOS
``` 