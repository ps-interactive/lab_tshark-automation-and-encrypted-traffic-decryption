#!/bin/bash
# Script to generate sample PCAP files for the lab

echo "Generating sample PCAP files for TShark lab..."

# Function to generate encrypted web traffic
generate_encrypted_traffic() {
    echo "Generating encrypted_traffic.pcap..."
    
    # Start capture in background
    sudo timeout 30 tcpdump -i lo -w /tmp/encrypted_traffic.pcap 'tcp port 443 or tcp port 80' &
    TCPDUMP_PID=$!
    
    sleep 2
    
    # Generate HTTPS traffic attempts (will fail but create TLS handshakes)
    for i in {1..5}; do
        curl -k https://localhost:443 >/dev/null 2>&1 || true
        curl -k https://127.0.0.1:443 >/dev/null 2>&1 || true
        sleep 1
    done
    
    # Generate HTTP traffic
    for i in {1..5}; do
        curl http://localhost:80 >/dev/null 2>&1 || true
        curl http://localhost:8080 >/dev/null 2>&1 || true
        sleep 1
    done
    
    # Wait for capture to complete
    wait $TCPDUMP_PID
    
    # Move to final location
    mv /tmp/encrypted_traffic.pcap /home/ubuntu/lab/encrypted_traffic.pcap
}

# Function to generate normal web traffic
generate_web_traffic() {
    echo "Generating web_traffic.pcap..."
    
    # Start capture
    sudo timeout 20 tcpdump -i lo -w /tmp/web_traffic.pcap &
    TCPDUMP_PID=$!
    
    sleep 2
    
    # Generate various types of traffic
    ping -c 10 localhost >/dev/null 2>&1 &
    
    for i in {1..10}; do
        curl http://localhost >/dev/null 2>&1 || true
        nc -zv localhost 22 >/dev/null 2>&1 || true
        sleep 0.5
    done
    
    wait $TCPDUMP_PID
    
    mv /tmp/web_traffic.pcap /home/ubuntu/lab/web_traffic.pcap
}

# Function to generate sample traffic with patterns
generate_sample_traffic() {
    echo "Generating sample_traffic.pcap..."
    
    sudo timeout 15 tcpdump -i lo -w /tmp/sample_traffic.pcap &
    TCPDUMP_PID=$!
    
    sleep 2
    
    # Generate DNS queries
    nslookup localhost >/dev/null 2>&1 || true
    nslookup 127.0.0.1 >/dev/null 2>&1 || true
    
    # Generate ICMP
    ping -c 5 127.0.0.1 >/dev/null 2>&1 || true
    
    # Generate TCP connections
    nc -zv localhost 22 >/dev/null 2>&1 || true
    nc -zv localhost 80 >/dev/null 2>&1 || true
    nc -zv localhost 443 >/dev/null 2>&1 || true
    
    wait $TCPDUMP_PID
    
    mv /tmp/sample_traffic.pcap /home/ubuntu/lab/sample_traffic.pcap
}

# Main execution
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root (use sudo)"
    exit 1
fi

# Create output directory
mkdir -p /home/ubuntu/lab

# Generate all PCAP files
generate_encrypted_traffic
generate_web_traffic
generate_sample_traffic

# Set proper permissions
chown -R ubuntu:ubuntu /home/ubuntu/lab

echo "PCAP generation complete!"
echo "Files created:"
ls -la /home/ubuntu/lab/*.pcap
