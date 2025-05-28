#!/bin/bash

# DNS Analysis Menu Script
# Shows all available analysis options

echo "🎯 DNS LoadTest Analyzer - Analysis Options"
echo "============================================"
echo ""

# Check if result files exist
if [ -d "results" ] && [ "$(ls -A results/*.txt 2>/dev/null)" ]; then
    echo "📁 Available result files:"
    ls -1t results/*.txt 2>/dev/null | head -5
    echo ""
else
    echo "📁 No result files found. Run a test first:"
    echo "   ./test-your-domain.sh"
    echo ""
fi

echo "🚀 Analysis Options:"
echo ""

echo "1. 🌟 UV-Powered Analysis (Recommended - Fast & Reliable)"
echo "   ./analyze-uv.sh results/your-test-file.txt"
echo ""

echo "2. 📊 Basic Analysis (No Dependencies)"
echo "   python3 scripts/analyze-results.py results/your-test-file.txt --no-plot"
echo ""

echo "3. 🐍 Traditional Python (Manual Setup)"
echo "   python3 -m venv dns-env && source dns-env/bin/activate"
echo "   pip install matplotlib pandas numpy seaborn plotly click"
echo "   python3 scripts/analyze-results.py results/your-test-file.txt"
echo ""

echo "💡 Quick Examples:"
echo "   # Run test and analyze with UV"
echo "   ./test-your-domain.sh && ./analyze-uv.sh results/quick_test_*.txt"
echo ""
echo "   # Analyze latest test result"
echo "   ./analyze-uv.sh \$(ls -t results/*.txt | head -1)"
echo ""

if [ $# -gt 0 ]; then
    echo "🔄 Running UV analysis with provided arguments..."
    ./analyze-uv.sh "$@"
else
    echo "📝 Usage: $0 [result-file] [options]"
    echo "   Or run any of the commands above directly"
fi 