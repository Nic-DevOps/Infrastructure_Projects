#!/bin/bash

# start_server.sh
# A simple script to start a Python HTTP server and serve content from the config directory

PORT=8000
DOC_ROOT="../config"

echo "Starting HTTP server on port $PORT..."
echo "Serving files from: $(realpath $DOC_ROOT)"

# Navigate to document root and start server
cd "$DOC_ROOT" || {
    echo "❌ Failed to access directory $DOC_ROOT"
    exit 1
}

# Start server
python3 -m http.server "$PORT"
