# DNS Load Testing Toolkit

A comprehensive toolkit for DNS performance testing and analysis using `dnsperf`. Test DNS servers, analyze performance metrics, and generate detailed reports with visualizations.

## Quick Start

### 1. Install Prerequisites
```bash
# macOS
brew install dnsperf

# Ubuntu/Debian
sudo apt-get update && sudo apt-get install dnsperf

# CentOS/RHEL
sudo yum install dnsperf  # or sudo dnf install dnsperf
```

### 2. Run Your First Test
```bash
# Run basic performance test
./scripts/run-basic-test.sh
```

## Use Cases & Examples

### 🎯 Use Case 1: Basic Performance Testing
**When to use**: You want to test DNS performance with moderate load (100 QPS)

```bash
# Run basic performance test
./scripts/run-basic-test.sh

```

### 🔥 Use Case 2: Stress Testing
**When to use**: You want to test DNS performance under heavy load (1000 QPS)

```bash
# Run stress test (high load)
./scripts/run-stress-test.sh
```

## Configuration Guide

### Test Scripts Overview
| Script | Purpose | Configuration File | Load Level |
|--------|---------|-------------------|------------|
| `run-basic-test.sh` | Light load testing | `configs/basic-test.conf` | 100 QPS |
| `run-stress-test.sh` | Heavy load testing | `configs/stress-test.conf` | 1000 QPS |
| `analyze-uv.sh` | Results analysis | N/A | Analysis tool |

### How to Configure Your Tests

#### 1. Configure Basic Test
Edit `configs/basic-test.conf` to customize your basic test:

```bash
# Open the configuration file
nano configs/basic-test.conf
```

Example configuration:
```bash
# DNS server to test
DNS_SERVER=8.8.8.8

# Query file containing domains to test
QUERY_FILE=queries/basic-queries.txt

# Test duration in seconds
DURATION=60

# Queries per second (light load)
QPS=100

# Number of concurrent connections
CONCURRENT=1

# Query timeout in seconds
TIMEOUT=5

# Additional dnsperf options (optional)
EXTRA_OPTIONS=""
```

#### 2. Configure Stress Test
Edit `configs/stress-test.conf` to customize your stress test:

```bash
# Open the configuration file
nano configs/stress-test.conf
```

Example configuration:
```bash
# DNS server to test
DNS_SERVER=8.8.8.8

# Query file containing domains to test
QUERY_FILE=queries/mixed-queries.txt

# Test duration in seconds
DURATION=60

# Queries per second (heavy load)
QPS=1000

# Number of concurrent connections
CONCURRENT=10

# Query timeout in seconds
TIMEOUT=5

# Additional dnsperf options (optional)
EXTRA_OPTIONS=""
```

### Common Configuration Changes

#### Test Your Own DNS Server
```bash
# For basic test
sed -i '' 's/DNS_SERVER=.*/DNS_SERVER=your-dns-server.com/' configs/basic-test.conf

# For stress test
sed -i '' 's/DNS_SERVER=.*/DNS_SERVER=your-dns-server.com/' configs/stress-test.conf
```

#### Test Different DNS Providers
```bash
# Test Google DNS
sed -i '' 's/DNS_SERVER=.*/DNS_SERVER=8.8.8.8/' configs/basic-test.conf

# Test Cloudflare DNS
sed -i '' 's/DNS_SERVER=.*/DNS_SERVER=1.1.1.1/' configs/basic-test.conf

# Test Quad9 DNS
sed -i '' 's/DNS_SERVER=.*/DNS_SERVER=9.9.9.9/' configs/basic-test.conf
```

#### Adjust Test Intensity
```bash
# Make basic test lighter (50 QPS)
sed -i '' 's/QPS=.*/QPS=50/' configs/basic-test.conf

# Make stress test more intense (2000 QPS)
sed -i '' 's/QPS=.*/QPS=2000/' configs/stress-test.conf

# Longer test duration (300 seconds = 5 minutes)
sed -i '' 's/DURATION=.*/DURATION=300/' configs/basic-test.conf
```

### Query Files

#### Default Query Files
- **queries/basic-queries.txt**: Simple A record queries for basic testing
- **queries/mixed-queries.txt**: Mix of A, AAAA, MX, CNAME records for comprehensive testing

#### Create Custom Query Files
```bash
# Create a custom query file
cat > queries/custom-domains.txt << EOF
your-domain.com A
your-domain.com AAAA
mail.your-domain.com MX
www.your-domain.com CNAME
your-domain.com TXT
EOF

# Update config to use your custom queries
sed -i '' 's|QUERY_FILE=.*|QUERY_FILE=queries/custom-domains.txt|' configs/basic-test.conf
```

#### Query File Format
Each line should contain: `domain record_type`
```
example.com A
example.com AAAA
subdomain.example.com CNAME
example.com MX
example.com TXT
```

## Understanding Results

### Analysis Report Sections
- **Performance Summary**: QPS, latency percentiles, success rates
- **Visual Charts**: Success rates, latency distribution, QPS trends
- **Response Analysis**: NOERROR, NXDOMAIN, SERVFAIL breakdown  
- **Performance Grade**: Automatic assessment (Excellent/Good/Fair/Poor)

### Performance Interpretation
| Metric | Good | Fair | Poor |
|--------|------|------|------|
| Success Rate | >99% | >95% | <95% |
| Average Latency | <50ms | <100ms | >100ms |
| 99th Percentile | <200ms | <500ms | >500ms |

### Comparing Basic vs Stress Results
- **Latency should increase** under stress (higher QPS)
- **Success rate should remain high** (>95%) even under stress
- **If stress test fails badly**, reduce QPS in stress config

## Project Structure

```
loadtest-dns/
├── scripts/                # All executable scripts
│   ├── run-basic-test.sh   # Light load test (100 QPS)
│   ├── run-stress-test.sh  # Heavy load test (1000 QPS)
│   └── analyze-uv.sh       # Analysis tool with charts
├── queries/                # DNS query files
│   ├── basic-queries.txt   # Simple queries for basic test
│   └── mixed-queries.txt   # Complex queries for stress test
├── configs/                # Test configuration files
│   ├── basic-test.conf     # Basic test settings
│   └── stress-test.conf    # Stress test settings
├── dnsperf-results/        # Test output files
├── analyzer-results/       # Analysis reports
└── README.md               # This documentation
```

## Troubleshooting

### Common Issues
- **"dnsperf: command not found"**: Install dnsperf using the commands in Quick Start
- **High packet loss**: Reduce QPS value in config files
- **DNS server unreachable**: Check network connectivity and try alternative DNS servers
- **Permission errors**: Some systems may require `sudo` for network operations

### Best Practices
1. **Start with Basic Test**: Always run basic test before stress test
2. **Monitor Resources**: Watch CPU/memory usage during stress tests
3. **Baseline First**: Establish baseline with known-good DNS servers (8.8.8.8, 1.1.1.1)
4. **Use Realistic Queries**: Test with domains and query types you actually use
5. **Compare Results**: Run both basic and stress tests to understand performance degradation