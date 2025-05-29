#!/bin/bash

# DNS Analysis Script using the standalone DNS Analyzer project
# This script uses the dedicated dns-analyzer UV project for analysis

set -e

echo "🎯 DNS LoadTest Analyzer (Standalone DNS Analyzer)"
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

# Check if analyzer directory exists
if [ ! -d "analyzer" ]; then
    echo "❌ analyzer directory not found!"
    echo "💡 Make sure you're running this script from the project root directory"
    echo "   Expected structure: loadtest-dns/analyzer/"
    exit 1
fi

# Show usage if no arguments
if [ $# -eq 0 ]; then
    echo ""
    echo "💡 Usage: $0 <result-file> [options]"
    echo ""
    echo "Examples:"
    echo "   $0 dnsperf-results/basic_test_20241220_143022.txt"
    echo "   $0 dnsperf-results/latest-custom-test.txt --no-plot"
    echo "   $0 --help"
    echo ""
    echo "📁 Available result files:"
    if [ -d "dnsperf-results" ]; then
        ls -1t dnsperf-results/*.txt 2>/dev/null | head -5 || echo "   No result files found"
    else
        echo "   dnsperf-results directory not found. Run a test first!"
    fi
    echo ""
    echo "🚀 Quick start:"
    echo "   ./test-your-domain.sh                    # Generate test results"
    echo "   $0 dnsperf-results/quick_test_*.txt      # Analyze results"
    echo ""
    echo "🔬 Using standalone DNS Analyzer project for enhanced analysis"
    exit 0
fi

# Create analyzer-results directory in the root directory if it doesn't exist
mkdir -p analyzer-results

# Change to analyzer directory
cd analyzer

echo "🔧 Setting up DNS Analyzer environment..."

# Check if dependencies are installed, if not, install them
if [ ! -d ".venv" ]; then
    echo "📦 Installing DNS Analyzer dependencies (one-time setup)..."
    uv sync
    echo "✅ Dependencies installed successfully"
else
    echo "✅ DNS Analyzer environment ready"
fi

echo "🔍 Running DNS performance analysis..."

# Convert relative paths to absolute paths for the analyzer
ARGS=()
for arg in "$@"; do
    if [[ "$arg" == ../* ]] || [[ "$arg" == /* ]] || [[ "$arg" == -* ]]; then
        # Already absolute or relative to parent, or it's an option flag
        ARGS+=("$arg")
    elif [[ "$arg" == dnsperf-results/* ]]; then
        # Convert dnsperf-results/ path to ../dnsperf-results/
        ARGS+=("../$arg")
    else
        # Assume it's a file in the parent directory
        ARGS+=("../$arg")
    fi
done

# Add default output directory to analyzer-results in root unless user specified one
if [[ ! " ${ARGS[@]} " =~ " --output-dir " ]]; then
    ARGS+=("--output-dir" "../analyzer-results")
fi

# Run the DNS analyzer
uv run dns-analyzer "${ARGS[@]}"

echo ""
echo "✅ Analysis completed!"
echo "📊 Check the analyzer-results/ directory for generated reports and visualizations" 