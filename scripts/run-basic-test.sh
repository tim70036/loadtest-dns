#!/bin/bash

# Basic DNS Load Test Script
# This script runs a basic DNS performance test

set -e

# Configuration
DNS_SERVER="8.8.8.8"
QUERY_FILE="queries/basic-queries.txt"
DURATION=30
QPS=100
TIMEOUT=5

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
        -t $TIMEOUT \
        -v \
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
echo "💡 Tips:"
echo "   - View full results: cat $RESULT_FILE"
echo "   - Run stress test: ./scripts/run-stress-test.sh"
echo "   - Customize queries: edit $QUERY_FILE" 