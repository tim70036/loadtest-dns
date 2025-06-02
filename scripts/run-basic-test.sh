#!/bin/bash

# Basic DNS Load Test Script
# This script runs a basic DNS performance test

set -e

# Load configuration from config file
CONFIG_FILE="configs/basic-test.conf"
if [ -f "$CONFIG_FILE" ]; then
    echo "📋 Loading configuration from $CONFIG_FILE"
    source "$CONFIG_FILE"
else
    echo "❌ Configuration file not found: $CONFIG_FILE"
    exit 1
fi

# Use CONCURRENT from config, default to 1 if not set
CONCURRENT=${CONCURRENT:-1}

# Create results directory if it doesn't exist
mkdir -p dnsperf-results

# Generate timestamp for unique result files
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
RESULT_FILE="dnsperf-results/basic_test_${TIMESTAMP}.txt"

echo "🚀 Starting Basic DNS Load Test..."
echo "📊 Configuration:"
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

# Run the test
echo "🔄 Running DNS performance test..."
dnsperf -s $DNS_SERVER \
        -d $QUERY_FILE \
        -l $DURATION \
        -Q $QPS \
        -q $QPS \
        -c $CONCURRENT \
        -t $TIMEOUT \
        $EXTRA_OPTIONS \
        | tee $RESULT_FILE

echo ""
echo "✅ Test completed!"
echo "📄 Results saved to: $RESULT_FILE"
echo ""

# Create a symlink to the latest result
ln -sf "$(basename $RESULT_FILE)" dnsperf-results/latest-basic-test.txt

# Extract key metrics
echo "📈 Key Metrics:"
grep -E "(Queries sent|Queries completed|Response codes|Average|Percentage)" $RESULT_FILE | head -10

echo ""
echo "💡 Analysis:"
# Calculate success rate
SENT=$(grep "Queries sent:" $RESULT_FILE | awk '{print $3}' || echo "0")
COMPLETED=$(grep "Queries completed:" $RESULT_FILE | awk '{print $3}' || echo "0")

if [ "$SENT" -gt 0 ]; then
    SUCCESS_RATE=$(echo "scale=2; $COMPLETED * 100 / $SENT" | bc -l 2>/dev/null || echo "N/A")
    echo "   Success Rate: ${SUCCESS_RATE}%"
fi

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
echo "   - Run stress test: ./scripts/run-stress-test.sh"
echo "   - Customize queries: edit $QUERY_FILE"
echo "   - Modify config: edit $CONFIG_FILE"
echo "   - Analysis reports: check analyzer-results/ directory" 