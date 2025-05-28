#!/bin/bash

# Stress DNS Load Test Script
# This script runs an intensive DNS performance test

set -e

# Configuration
DNS_SERVER="8.8.8.8"
QUERY_FILE="queries/mixed-queries.txt"
DURATION=60
QPS=1000
CONCURRENT=10
TIMEOUT=3

# Create results directory if it doesn't exist
mkdir -p dnsperf-results

# Generate timestamp for unique result files
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
RESULT_FILE="dnsperf-results/stress_test_${TIMESTAMP}.txt"

echo "🔥 Starting Stress DNS Load Test..."
echo "⚠️  WARNING: This is a high-intensity test!"
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
        -v \
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
echo "💡 Analysis:"
# Calculate success rate
SENT=$(grep "Queries sent:" $RESULT_FILE | awk '{print $3}' || echo "0")
COMPLETED=$(grep "Queries completed:" $RESULT_FILE | awk '{print $3}' || echo "0")

if [ "$SENT" -gt 0 ]; then
    SUCCESS_RATE=$(echo "scale=2; $COMPLETED * 100 / $SENT" | bc -l 2>/dev/null || echo "N/A")
    echo "   Success Rate: ${SUCCESS_RATE}%"
fi

echo ""
echo "💡 Tips:"
echo "   - View full results: cat $RESULT_FILE"
echo "   - Compare with basic test: diff dnsperf-results/latest-basic-test.txt dnsperf-results/latest-stress-test.txt"
echo "   - Adjust parameters in this script for different stress levels" 