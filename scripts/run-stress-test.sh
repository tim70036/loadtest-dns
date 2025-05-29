#!/bin/bash

# Stress DNS Load Test Script
# This script runs an intensive DNS performance test

set -e

# Load configuration from config file
CONFIG_FILE="configs/stress-test.conf"
if [ -f "$CONFIG_FILE" ]; then
    echo "📋 Loading configuration from $CONFIG_FILE"
    source "$CONFIG_FILE"
else
    echo "❌ Configuration file not found: $CONFIG_FILE"
    exit 1
fi

# Create results directory if it doesn't exist
mkdir -p dnsperf-results

# Generate timestamp for unique result files
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
RESULT_FILE="dnsperf-results/stress_test_${TIMESTAMP}.txt"

echo "🔥 Starting Stress DNS Load Test..."
echo "⚠️  WARNING: This is a high-intensity test!"
echo "📊 Configuration:"
echo "   Config File: $CONFIG_FILE"
echo "   DNS Server: $DNS_SERVER"
echo "   Query File: $QUERY_FILE"
echo "   Duration: ${DURATION}s"
echo "   Queries per second: $QPS"
echo "   Concurrent connections: $CONCURRENT"
echo "   Timeout: ${TIMEOUT}s"
echo "   Results: $RESULT_FILE"
echo ""

# Check if query file exists
if [ ! -f "$QUERY_FILE" ]; then
    echo "❌ Query file not found: $QUERY_FILE"
    exit 1
fi

# Check if dnsperf is installed
if ! command -v dnsperf &> /dev/null; then
    echo "❌ dnsperf not found. Please run ./setup.sh first"
    exit 1
fi

# Warning prompt
read -p "⚠️  This will generate high DNS traffic. Continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Test cancelled"
    exit 1
fi

# Run the test
echo "🔄 Running DNS stress test..."
echo "📊 Monitor system resources during the test..."
dnsperf -s $DNS_SERVER \
        -d $QUERY_FILE \
        -l $DURATION \
        -Q $QPS \
        -c $CONCURRENT \
        -t $TIMEOUT \
        $EXTRA_OPTIONS \
        | tee $RESULT_FILE

echo ""
echo "✅ Stress test completed!"
echo "📄 Results saved to: $RESULT_FILE"
echo ""

# Create a symlink to the latest result
ln -sf "$(basename $RESULT_FILE)" dnsperf-results/latest-stress-test.txt

# Extract key metrics
echo "📈 Key Metrics:"
grep -E "(Queries sent|Queries completed|Response codes|Average|Percentage|Lost)" $RESULT_FILE | head -15

echo ""
echo "🔬 Running detailed analysis..."
echo "=============================================="

# Check if analyzer script exists and run it
ANALYZER_SCRIPT="./scripts/analyze-uv.sh"
if [ -f "$ANALYZER_SCRIPT" ]; then
    echo "📊 Launching DNS performance analyzer..."
    $ANALYZER_SCRIPT "$RESULT_FILE"
else
    echo "⚠️  Analyzer script not found: $ANALYZER_SCRIPT"
    echo "💡 You can manually analyze results with:"
    echo "   ./scripts/analyze-uv.sh $RESULT_FILE"
fi

echo ""
echo "💡 Tips:"
echo "   - View full results: cat $RESULT_FILE"
echo "   - Compare with basic test: diff dnsperf-results/latest-basic-test.txt dnsperf-results/latest-stress-test.txt"
echo "   - Adjust parameters in config: edit $CONFIG_FILE"
echo "   - Analysis reports: check analyzer-results/ directory" 