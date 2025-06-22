from flask import Flask, render_template, send_from_directory
import os

app = Flask(__name__)

# Serve static files from the current directory
@app.route('/')
def index():
    return send_from_directory('.', 'index.html')

@app.route('/<path:filename>')
def serve_file(filename):
    return send_from_directory('.', filename)

if __name__ == '__main__':
    print("🚀 Starting EEGcellent website server...")
    print("📍 Local URL: http://localhost:5000")
    print("🌐 Network URL: http://0.0.0.0:5000")
    print("📱 Open your browser and navigate to the URL above")
    print("⏹️  Press Ctrl+C to stop the server")
    print("-" * 50)
    
    # Run the server
    app.run(host='0.0.0.0', port=5000, debug=True) 