#!/usr/bin/env python3
"""
DNS Performance Test Results Analyzer
Analyzes dnsperf output and generates visualizations
"""

import argparse
import re
import sys
import os
from datetime import datetime
import json

try:
    import matplotlib.pyplot as plt
    import pandas as pd
    import seaborn as sns
    PLOTTING_AVAILABLE = True
except ImportError:
    PLOTTING_AVAILABLE = False
    print("⚠️  Plotting libraries not available. Install with: pip install matplotlib pandas seaborn")

def parse_dnsperf_output(file_path):
    """Parse dnsperf output file and extract metrics"""
    
    if not os.path.exists(file_path):
        print(f"❌ File not found: {file_path}")
        return None
    
    metrics = {}
    
    with open(file_path, 'r') as f:
        content = f.read()
    
    # Extract basic metrics
    patterns = {
        'queries_sent': r'Queries sent:\s+(\d+)',
        'queries_completed': r'Queries completed:\s+(\d+)',
        'queries_lost': r'Queries lost:\s+(\d+)',
        'response_codes_noerror': r'NOERROR:\s+(\d+)',
        'response_codes_nxdomain': r'NXDOMAIN:\s+(\d+)',
        'response_codes_servfail': r'SERVFAIL:\s+(\d+)',
        'average_latency': r'Average:\s+([\d.]+)\s+sec',
        'minimum_latency': r'Minimum:\s+([\d.]+)\s+sec',
        'maximum_latency': r'Maximum:\s+([\d.]+)\s+sec',
        'qps_achieved': r'Queries per second:\s+([\d.]+)',
    }
    
    for key, pattern in patterns.items():
        match = re.search(pattern, content)
        if match:
            try:
                metrics[key] = float(match.group(1))
            except ValueError:
                metrics[key] = match.group(1)
        else:
            metrics[key] = 0
    
    # Calculate derived metrics
    if metrics['queries_sent'] > 0:
        metrics['success_rate'] = (metrics['queries_completed'] / metrics['queries_sent']) * 100
        metrics['loss_rate'] = (metrics['queries_lost'] / metrics['queries_sent']) * 100
    else:
        metrics['success_rate'] = 0
        metrics['loss_rate'] = 0
    
    # Extract test configuration
    config_patterns = {
        'dns_server': r'-s\s+([\d.]+)',
        'duration': r'-l\s+(\d+)',
        'target_qps': r'-Q\s+(\d+)',
        'concurrent': r'-c\s+(\d+)',
    }
    
    for key, pattern in config_patterns.items():
        match = re.search(pattern, content)
        if match:
            metrics[key] = match.group(1)
    
    return metrics

def print_summary(metrics, file_path):
    """Print a formatted summary of the test results"""
    
    print(f"\n📊 DNS Performance Test Results Summary")
    print(f"📄 File: {file_path}")
    print(f"🕒 Analyzed: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print("=" * 60)
    
    # Test Configuration
    print("\n🔧 Test Configuration:")
    if 'dns_server' in metrics:
        print(f"   DNS Server: {metrics['dns_server']}")
    if 'duration' in metrics:
        print(f"   Duration: {metrics['duration']}s")
    if 'target_qps' in metrics:
        print(f"   Target QPS: {metrics['target_qps']}")
    if 'concurrent' in metrics:
        print(f"   Concurrent: {metrics['concurrent']}")
    
    # Query Statistics
    print("\n📈 Query Statistics:")
    print(f"   Queries Sent: {int(metrics['queries_sent'])}")
    print(f"   Queries Completed: {int(metrics['queries_completed'])}")
    print(f"   Queries Lost: {int(metrics['queries_lost'])}")
    print(f"   Success Rate: {metrics['success_rate']:.2f}%")
    print(f"   Loss Rate: {metrics['loss_rate']:.2f}%")
    
    # Performance Metrics
    print("\n⚡ Performance Metrics:")
    print(f"   Achieved QPS: {metrics['qps_achieved']:.2f}")
    print(f"   Average Latency: {metrics['average_latency']:.3f}s")
    print(f"   Minimum Latency: {metrics['minimum_latency']:.3f}s")
    print(f"   Maximum Latency: {metrics['maximum_latency']:.3f}s")
    
    # Response Codes
    print("\n📋 Response Codes:")
    print(f"   NOERROR: {int(metrics['response_codes_noerror'])}")
    print(f"   NXDOMAIN: {int(metrics['response_codes_nxdomain'])}")
    print(f"   SERVFAIL: {int(metrics['response_codes_servfail'])}")
    
    # Performance Assessment
    print("\n🎯 Performance Assessment:")
    if metrics['success_rate'] >= 99:
        print("   ✅ Excellent: >99% success rate")
    elif metrics['success_rate'] >= 95:
        print("   ✅ Good: >95% success rate")
    elif metrics['success_rate'] >= 90:
        print("   ⚠️  Fair: >90% success rate")
    else:
        print("   ❌ Poor: <90% success rate")
    
    if metrics['average_latency'] <= 0.050:
        print("   ✅ Excellent latency: <50ms")
    elif metrics['average_latency'] <= 0.100:
        print("   ✅ Good latency: <100ms")
    elif metrics['average_latency'] <= 0.200:
        print("   ⚠️  Fair latency: <200ms")
    else:
        print("   ❌ Poor latency: >200ms")

def create_visualizations(metrics, output_dir="results"):
    """Create visualizations of the test results"""
    
    if not PLOTTING_AVAILABLE:
        print("⚠️  Skipping visualizations - plotting libraries not available")
        return
    
    # Set style
    plt.style.use('seaborn-v0_8')
    fig, ((ax1, ax2), (ax3, ax4)) = plt.subplots(2, 2, figsize=(15, 10))
    
    # 1. Success vs Loss Rate
    success_data = [metrics['success_rate'], metrics['loss_rate']]
    labels = ['Success', 'Lost']
    colors = ['#2ecc71', '#e74c3c']
    ax1.pie(success_data, labels=labels, colors=colors, autopct='%1.1f%%', startangle=90)
    ax1.set_title('Query Success vs Loss Rate')
    
    # 2. Response Codes Distribution
    response_codes = [
        metrics['response_codes_noerror'],
        metrics['response_codes_nxdomain'],
        metrics['response_codes_servfail']
    ]
    response_labels = ['NOERROR', 'NXDOMAIN', 'SERVFAIL']
    response_colors = ['#27ae60', '#f39c12', '#e74c3c']
    
    # Only show non-zero response codes
    non_zero_codes = [(code, label, color) for code, label, color in zip(response_codes, response_labels, response_colors) if code > 0]
    if non_zero_codes:
        codes, labels, colors = zip(*non_zero_codes)
        ax2.pie(codes, labels=labels, colors=colors, autopct='%1.1f%%', startangle=90)
    ax2.set_title('Response Codes Distribution')
    
    # 3. Latency Metrics
    latency_metrics = ['Minimum', 'Average', 'Maximum']
    latency_values = [
        metrics['minimum_latency'] * 1000,  # Convert to ms
        metrics['average_latency'] * 1000,
        metrics['maximum_latency'] * 1000
    ]
    bars = ax3.bar(latency_metrics, latency_values, color=['#3498db', '#9b59b6', '#e67e22'])
    ax3.set_title('Latency Metrics (ms)')
    ax3.set_ylabel('Latency (ms)')
    
    # Add value labels on bars
    for bar, value in zip(bars, latency_values):
        height = bar.get_height()
        ax3.text(bar.get_x() + bar.get_width()/2., height + height*0.01,
                f'{value:.1f}ms', ha='center', va='bottom')
    
    # 4. QPS Comparison
    qps_data = ['Target QPS', 'Achieved QPS']
    qps_values = [float(metrics.get('target_qps', 0)), metrics['qps_achieved']]
    bars = ax4.bar(qps_data, qps_values, color=['#34495e', '#1abc9c'])
    ax4.set_title('QPS: Target vs Achieved')
    ax4.set_ylabel('Queries per Second')
    
    # Add value labels on bars
    for bar, value in zip(bars, qps_values):
        height = bar.get_height()
        ax4.text(bar.get_x() + bar.get_width()/2., height + height*0.01,
                f'{value:.1f}', ha='center', va='bottom')
    
    plt.tight_layout()
    
    # Save the plot
    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    plot_file = os.path.join(output_dir, f'dns_analysis_{timestamp}.png')
    plt.savefig(plot_file, dpi=300, bbox_inches='tight')
    print(f"\n📊 Visualization saved: {plot_file}")
    
    # Show the plot if running interactively
    if hasattr(sys, 'ps1'):  # Interactive mode
        plt.show()
    else:
        plt.close()

def save_json_report(metrics, file_path, output_dir="results"):
    """Save metrics as JSON for further analysis"""
    
    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    json_file = os.path.join(output_dir, f'dns_metrics_{timestamp}.json')
    
    report = {
        'timestamp': datetime.now().isoformat(),
        'source_file': file_path,
        'metrics': metrics
    }
    
    with open(json_file, 'w') as f:
        json.dump(report, f, indent=2)
    
    print(f"📄 JSON report saved: {json_file}")

def main():
    parser = argparse.ArgumentParser(description='Analyze DNS performance test results')
    parser.add_argument('file', help='Path to dnsperf output file')
    parser.add_argument('--no-plot', action='store_true', help='Skip generating plots')
    parser.add_argument('--output-dir', default='results', help='Output directory for reports')
    
    args = parser.parse_args()
    
    # Parse the results
    metrics = parse_dnsperf_output(args.file)
    if not metrics:
        sys.exit(1)
    
    # Print summary
    print_summary(metrics, args.file)
    
    # Create output directory if it doesn't exist
    os.makedirs(args.output_dir, exist_ok=True)
    
    # Generate visualizations
    if not args.no_plot:
        create_visualizations(metrics, args.output_dir)
    
    # Save JSON report
    save_json_report(metrics, args.file, args.output_dir)
    
    print("\n✅ Analysis complete!")

if __name__ == '__main__':
    main() 