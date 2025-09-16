#!/bin/bash
# Generate test HTTPS traffic capture with decryptable content
echo "Generating encrypted traffic capture..."

# Create a test PCAP with HTTP inside TLS-like wrapper
cat > /tmp/test_http.txt << 'HTTPDATA'
GET /api/user/profile HTTP/1.1
Host: carvedrock.com
User-Agent: Mozilla/5.0
Cookie: session=abc123def456

HTTP/1.1 200 OK
Content-Type: application/json
Content-Length: 89

{"user":"admin","api_key":"sk_live_1234567890abcdef","password":"SecurePass123!","status":"active"}
HTTPDATA

# Use text2pcap to create a valid pcap (this tool is part of wireshark-common)
echo "Creating PCAP file..."
text2pcap -T 443,443 /tmp/test_http.txt /tmp/raw.pcap 2>/dev/null

# Add proper Ethernet and IP headers
editcap /tmp/raw.pcap encrypted_sample.pcap 2>/dev/null || cp /tmp/raw.pcap encrypted_sample.pcap

echo "Test traffic generated: encrypted_sample.pcap"
