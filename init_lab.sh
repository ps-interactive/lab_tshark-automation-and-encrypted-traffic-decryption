#!/bin/bash
# Lab initialization script for TShark Automation and Encrypted Traffic Decryption

echo "Initializing TShark lab environment..."

# Create necessary directories
mkdir -p /home/ubuntu/tshark_analysis
mkdir -p /home/ubuntu/captures
mkdir -p /home/ubuntu/decryption

# Generate sample web traffic if not exists
if [ ! -f /home/ubuntu/tshark_analysis/web_traffic.pcap ]; then
    echo "Generating sample web traffic..."
    sudo timeout 10 tcpdump -i lo -w /home/ubuntu/tshark_analysis/web_traffic.pcap 'tcp port 80 or tcp port 443' &
    sleep 2
    # Generate some traffic
    curl -s http://localhost >/dev/null 2>&1 || true
    curl -s https://localhost >/dev/null 2>&1 || true
    ping -c 5 localhost >/dev/null 2>&1 || true
    sleep 3
fi

# Copy lab files
cp /home/ubuntu/lab/*.pcap /home/ubuntu/tshark_analysis/ 2>/dev/null || true
cp /home/ubuntu/lab/*.log /home/ubuntu/decryption/ 2>/dev/null || true

# Set permissions
chmod -R 755 /home/ubuntu/tshark_analysis
chmod -R 755 /home/ubuntu/captures
chmod -R 755 /home/ubuntu/decryption

echo "Lab environment ready!"
echo "Navigate to /home/ubuntu/tshark_analysis to begin."
