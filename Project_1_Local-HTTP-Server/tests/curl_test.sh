#!/bin/bash

# curl_test.sh
# Test if the server is responding on localhost and port 8000

URL="http://localhost:8000"

echo "Testing $URL ..."
if curl -s --head "$URL" | grep "200 OK" > /dev/null; then
  echo "✅ Server is up and responding."
else
  echo "❌ Server is not responding as expected."
fi
