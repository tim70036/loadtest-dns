#!/bin/bash

# Custom DNS Load Test Script for a.hnxhy888.com.cdn2.mlycdn.com
# This script runs a focused test on the specified domain

set -e

# Default configuration
DNS_SERVER="8.8.8.8"
QUERY_FILE="queries/custom-queries.txt"
DURATION=45
QPS=200
CONCURRENT=5
TIMEOUT=5

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -s|--server)
            DNS_SERVER="$2"
            shift 2
            ;;
        -d|--duration)
            DURATION="$2"
            shift 2
            ;;
        -q|--qps)
            QPS="$2"
            shift 2
            ;;
        -c|--concurrent)
            CONCURRENT="$2"
            shift 2
            ;;
        -t|--timeout)
            TIMEOUT="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  -s, --server      DNS server to test (default: 8.8.8.8)"
            echo "  -d, --duration    Test duration in seconds (default: 45)"
            echo "  -q, --qps         Queries per second (default: 200)"
            echo "  -c, --concurrent  Concurrent connections (default: 5)"
            echo "  -t, --timeout     Query timeout in seconds (default: 5)"
            echo "  -h, --help        Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0                                    # Run with defaults"
            echo "  $0 -s 1.1.1.1 -q 500                # Test Cloudflare DNS with 500 QPS"
            echo "  $0 -d 120 -c 10                      # 2-minute test with 10 connections"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

# Create results directory if it doesn't exist
mkdir -p results

# Generate timestamp for unique result files
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
RESULT_FILE="results/custom_test_${TIMESTAMP}.txt"

echo "🎯 Starting Custom DNS Load Test for a.hnxhy888.com.cdn2.mlycdn.com"
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

# Show what queries will be tested
echo "🔍 Testing these queries:"
cat $QUERY_FILE | head -10
if [ $(wc -l < $QUERY_FILE) -gt 10 ]; then
    echo "   ... and $(( $(wc -l < $QUERY_FILE) - 10 )) more"
fi
echo ""

# Run the test
echo "🔄 Running custom DNS performance test..."
dnsperf -s $DNS_SERVER \
        -d $QUERY_FILE \
        -l $DURATION \
        -Q $QPS \
        -c $CONCURRENT \
        -t $TIMEOUT \
        -v \
        | tee $RESULT_FILE

echo ""
echo "✅ Custom test completed!"
echo "📄 Results saved to: $RESULT_FILE"
echo ""

# Create a symlink to the latest result
ln -sf "$(basename $RESULT_FILE)" results/latest-custom-test.txt

# Extract key metrics
echo "📈 Key Metrics:"
grep -E "(Queries sent|Queries completed|Response codes|Average|Percentage)" $RESULT_FILE | head -12

echo ""
echo "🎯 Domain-specific Analysis:"
echo "   Target Domain: a.hnxhy888.com.cdn2.mlycdn.com"

# Check for specific response codes
if grep -q "NOERROR" $RESULT_FILE; then
    echo "   ✅ Domain resolves successfully"
else
    echo "   ⚠️  Check domain resolution issues"
fi

echo ""
echo "💡 Tips:"
echo "   - View full results: cat $RESULT_FILE"
echo "   - Test different DNS servers: $0 -s 1.1.1.1"
echo "   - Increase load: $0 -q 500 -c 10"
echo "   - Edit queries: nano $QUERY_FILE" 