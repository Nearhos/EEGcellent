#!/bin/bash

echo "🚀 Starting EEGcellent Website Server..."
echo

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is not installed"
    echo "Please install Python 3 from https://python.org"
    exit 1
fi

# Check if Flask is installed
if ! python3 -c "import flask" &> /dev/null; then
    echo "📦 Installing Flask..."
    pip3 install flask
    if [ $? -ne 0 ]; then
        echo "❌ Failed to install Flask"
        exit 1
    fi
fi

echo "✅ Starting server..."
echo
python3 server.py 