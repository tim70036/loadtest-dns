#!/bin/bash

# Simple DNS Analysis Script using UV
# This script uses uv to run the analysis with automatic dependency management

set -e

echo "🎯 DNS LoadTest Analyzer (UV-powered)"
echo ""

# Check if uv is installed
if ! command -v uv &> /dev/null; then
    echo "📦 Installing uv..."
    
    # Try different installation methods
    if command -v brew &> /dev/null; then
        echo "   Using Homebrew..."
        brew install uv
    elif command -v curl &> /dev/null; then
        echo "   Using curl installer..."
        curl -LsSf https://astral.sh/uv/install.sh | sh
        # Add to PATH for current session
        export PATH="$HOME/.cargo/bin:$PATH"
    else
        echo "❌ Cannot install uv automatically."
        echo "💡 Please install uv manually:"
        echo "   brew install uv"
        echo "   # or"
        echo "   curl -LsSf https://astral.sh/uv/install.sh | sh"
        exit 1
    fi
else
    echo "✅ uv is available"
fi

# Verify uv is working
if ! command -v uv &> /dev/null; then
    echo "❌ uv installation failed or not in PATH"
    echo "💡 Try restarting your terminal or run:"
    echo "   source ~/.bashrc  # or ~/.zshrc"
    exit 1
fi

# Show usage if no arguments
if [ $# -eq 0 ]; then
    echo ""
    echo "💡 Usage: $0 <result-file> [options]"
    echo ""
    echo "Examples:"
    echo "   $0 results/basic_test_20241220_143022.txt"
    echo "   $0 results/latest-custom-test.txt --no-plot"
    echo "   $0 --help"
    echo ""
    echo "📁 Available result files:"
    if [ -d "results" ]; then
        ls -1t results/*.txt 2>/dev/null | head -5 || echo "   No result files found"
    else
        echo "   Results directory not found. Run a test first!"
    fi
    echo ""
    echo "🚀 Quick start:"
    echo "   ./test-your-domain.sh                    # Generate test results"
    echo "   $0 results/quick_test_*.txt              # Analyze results"
    exit 0
fi

echo "🔧 Setting up Python environment and running analysis..."

# Use uv run with inline dependencies - this automatically manages the environment
uv run --with matplotlib --with pandas --with numpy --with seaborn --with plotly --with click \
    python scripts/analyze-results.py "$@"

echo ""
echo "✅ Analysis completed!" 