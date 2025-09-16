#!/bin/bash
# Analyze decrypted traffic
PCAP=$1
KEYS=$2

# Check if using correct keys
if grep -q "ffff" "$KEYS" 2>/dev/null || grep -q "eeee" "$KEYS" 2>/dev/null; then
    # Wrong keys - no decryption
    echo "=== Decrypted Traffic Analysis ==="
    echo ""
    echo "Extracting sensitive data from CarvedRock application traffic..."
    echo ""
    echo "HTTP Requests found:"
    echo "  [No HTTP data visible]"
    echo ""
    echo "Sensitive information extracted:"
    echo "  [Unable to extract - traffic still encrypted]"
    echo ""
    echo "Total decrypted HTTP packets: 0"
else
    # Correct keys - show decrypted data
    echo "=== Decrypted Traffic Analysis ==="
    echo ""
    echo "Extracting sensitive data from CarvedRock application traffic..."
    echo ""
    echo "HTTP Requests found:"
    echo "  GET /api/user/profile"
    echo "  POST /api/login"
    echo ""
    echo "Sensitive information extracted:"
    echo "  Username: admin"
    echo "  API Key: sk_live_1234567890abcdef"
    echo "  Session Cookie: abc123def456"
    echo ""
    echo "Password found in response:"
    echo "  Warning: Plain text password detected: SecurePass123!"
    echo ""
    echo "Total decrypted HTTP packets: 4"
fi
