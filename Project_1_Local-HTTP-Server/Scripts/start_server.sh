#!/bin/bash

# start_server.sh
# A simple script to start a Python HTTP server and serve content from the config directory

PORT=8000

# Set the document root to one directory level above the current one, then into the 'config' folder.
# The '../' means "go up one directory level from the current directory."
DOC_ROOT="../config"

echo "Starting HTTP server on port $PORT..."
echo "Serving files from: $(realpath $DOC_ROOT)"

# Try to go into the DOC_ROOT directory.
# If the command fails (e.g., directory doesn't exist), the block after `||` will run.
# The `||` means: "or if the previous command fails, then do the following."
cd "$DOC_ROOT" || {
    echo "❌ Failed to access directory $DOC_ROOT"
    exit 1
}

# Start a simple HTTP server that serves files from the current directory on the specified port
python3 -m http.server "$PORT"
