# DNS Performance Test Results Analyzer

A comprehensive tool for analyzing DNS performance test results from `dnsperf` output files. This tool provides detailed metrics analysis, performance assessments, and beautiful visualizations to help you understand your DNS server performance.

## Features

- 📊 **Comprehensive Analysis**: Parse and analyze dnsperf output files
- 📈 **Visual Reports**: Generate charts and graphs for performance metrics
- 📋 **Detailed Metrics**: Extract query statistics, latency metrics, and response codes
- 🎯 **Performance Assessment**: Automatic performance grading based on industry standards
- 📄 **JSON Export**: Save results in JSON format for further analysis
- 🔧 **Configurable**: Support for various output formats and customization options

## Installation

### Prerequisites

- Python 3.8 or higher
- [UV package manager](https://docs.astral.sh/uv/) (recommended) or pip

### Using UV (Recommended)

1. Clone or navigate to the project directory:
   ```bash
   cd dns-analyzer
   ```

2. Install dependencies and create virtual environment:
   ```bash
   uv sync
   ```

3. The tool is now ready to use!

### Using pip

1. Create a virtual environment:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

2. Install dependencies:
   ```bash
   pip install matplotlib pandas seaborn
   ```

## Usage

### Command Line Interface

#### Basic Usage

```bash
# Using UV
uv run dns-analyzer path/to/dnsperf-output.txt

# Using the installed script (after uv sync)
dns-analyzer path/to/dnsperf-output.txt

# Direct Python execution
python dns_analyzer/analyze_results.py path/to/dnsperf-output.txt
```

#### Advanced Options

```bash
# Skip generating plots (text output only)
dns-analyzer --no-plot path/to/dnsperf-output.txt

# Specify custom output directory
dns-analyzer --output-dir /path/to/custom/output path/to/dnsperf-output.txt

# Show help
dns-analyzer --help
```

### Example Output

The tool provides several types of output:

#### 1. Console Summary
```
📊 DNS Performance Test Results Summary
📄 File: dnsperf-results/test-output.txt
🕒 Analyzed: 2024-01-15 14:30:25
============================================================

🔧 Test Configuration:
   DNS Server: 8.8.8.8
   Duration: 30s
   Target QPS: 1000
   Concurrent: 10

📈 Query Statistics:
   Queries Sent: 30000
   Queries Completed: 29950
   Queries Lost: 50
   Success Rate: 99.83%
   Loss Rate: 0.17%

⚡ Performance Metrics:
   Achieved QPS: 998.33
   Average Latency: 0.045s
   Minimum Latency: 0.001s
   Maximum Latency: 0.250s

📋 Response Codes:
   NOERROR: 29950
   NXDOMAIN: 0
   SERVFAIL: 0

🎯 Performance Assessment:
   ✅ Excellent: >99% success rate
   ✅ Excellent latency: <50ms
```

#### 2. Visual Charts
The tool generates a comprehensive visualization with four charts:
- **Success vs Loss Rate**: Pie chart showing query success/failure ratio
- **Response Codes Distribution**: Breakdown of DNS response codes
- **Latency Metrics**: Bar chart comparing min/avg/max latency
- **QPS Comparison**: Target vs achieved queries per second

#### 3. JSON Report
Detailed metrics saved in JSON format for programmatic analysis:
```json
{
  "timestamp": "2024-01-15T14:30:25.123456",
  "source_file": "dnsperf-results/test-output.txt",
  "metrics": {
    "queries_sent": 30000,
    "queries_completed": 29950,
    "success_rate": 99.83,
    "average_latency": 0.045,
    ...
  }
}
```

## Input Format

The tool expects `dnsperf` output files. Here's an example of generating compatible input:

```bash
# Example dnsperf command
dnsperf -s 8.8.8.8 -d queries.txt -l 30 -Q 1000 -c 10 > dnsperf-results/test-output.txt

# The output file should contain sections like:
# DNS Performance Testing Tool
# Queries sent:     30000
# Queries completed: 29950
# Queries lost:     50
# Response codes:
#   NOERROR:        29950
#   NXDOMAIN:       0
#   SERVFAIL:       0
# Average:          0.045000 sec
# Minimum:          0.001000 sec
# Maximum:          0.250000 sec
# Queries per second: 998.33
```

## Output Files

All output files are saved to the `../analyzer-results/` directory (or custom directory specified with `--output-dir`):

- `dns_analysis_YYYYMMDD_HHMMSS.png`: Visualization charts
- `dns_metrics_YYYYMMDD_HHMMSS.json`: Detailed metrics in JSON format

## Performance Assessment Criteria

The tool automatically assesses performance based on these criteria:

### Success Rate
- ✅ **Excellent**: >99% success rate
- ✅ **Good**: >95% success rate  
- ⚠️ **Fair**: >90% success rate
- ❌ **Poor**: <90% success rate

### Latency
- ✅ **Excellent**: <50ms average latency
- ✅ **Good**: <100ms average latency
- ⚠️ **Fair**: <200ms average latency
- ❌ **Poor**: >200ms average latency

## Development

### Project Structure
```
dns-analyzer/
├── dns_analyzer/
│   ├── __init__.py
│   └── analyze_results.py    # Main analysis script
├── pyproject.toml           # Project configuration
└── README.md               # This file

# Output directory (created in parent directory)
../analyzer-results/         # Analysis reports and visualizations
```

### Dependencies
- `matplotlib>=3.5.0`: For generating charts and visualizations
- `pandas>=1.3.0`: For data manipulation and analysis
- `seaborn>=0.11.0`: For enhanced statistical visualizations

### Contributing
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## Troubleshooting

### Common Issues

1. **"Plotting libraries not available"**
   - Install missing dependencies: `uv sync` or `pip install matplotlib pandas seaborn`

2. **"File not found" error**
   - Verify the path to your dnsperf output file
   - Ensure the file contains valid dnsperf output

3. **Empty or invalid charts**
   - Check that your dnsperf output file contains the expected metrics
   - Verify the file format matches the expected dnsperf output structure

### Getting Help

If you encounter issues:
1. Check that your input file is valid dnsperf output
2. Verify all dependencies are installed correctly
3. Run with `--no-plot` to see if the issue is with visualization
4. Check the console output for specific error messages

## License

This project is open source. Please check the license file for details.

## Related Tools

This analyzer is designed to work with:
- [dnsperf](https://www.dns-oarc.net/tools/dnsperf): DNS performance testing tool
- [resperf](https://www.dns-oarc.net/tools/dnsperf): DNS resolution performance tool
- Other DNS testing utilities that produce similar output formats
