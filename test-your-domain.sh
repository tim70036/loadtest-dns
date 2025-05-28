#!/bin/bash

# Quick DNS Load Test for a.hnxhy888.com.cdn2.mlycdn.com
# This script provides a simple way to test your specific domain

set -e

echo "🎯 Quick DNS Load Test for a.hnxhy888.com.cdn2.mlycdn.com"
echo ""

# Check if dnsperf is installed
if ! command -v dnsperf &> /dev/null; then
    echo "❌ dnsperf not found. Installing..."
    ./setup.sh
fi

# Create a simple query file for your domain
cat > /tmp/quick-test.txt << EOF
a.hnxhy888.com.cdn2.mlycdn.com A
a.hnxhy888.com.cdn2.mlycdn.com AAAA
a.hnxhy888.com.cdn2.mlycdn.com CNAME
EOF

echo "🔍 Testing domain: a.hnxhy888.com.cdn2.mlycdn.com"
echo "📊 Running quick test (30 seconds, 50 QPS)..."
echo ""

# Run a quick test
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
RESULT_FILE="dnsperf-results/quick_test_${TIMESTAMP}.txt"

mkdir -p dnsperf-results

dnsperf -s 8.8.8.8 \
        -d /tmp/quick-test.txt \
        -l 30 \
        -Q 50 \
        -t 5 \
        -v \
        | tee $RESULT_FILE

echo ""
echo "✅ Quick test completed!"
echo "📄 Results saved to: $RESULT_FILE"
echo ""

# Show key results
echo "📈 Key Results:"
grep -E "(Queries sent|Queries completed|Average|Queries per second)" $RESULT_FILE

echo ""
echo "🚀 Next Steps:"
echo "   1. Run full custom test: ./scripts/run-custom-test.sh"
echo "   2. Analyze results: python3 scripts/analyze-results.py $RESULT_FILE"
echo "   3. Test different DNS servers: ./scripts/run-custom-test.sh -s 1.1.1.1"
echo "   4. View all results: ls -la dnsperf-results/"

# Clean up
rm -f /tmp/quick-test.txt 