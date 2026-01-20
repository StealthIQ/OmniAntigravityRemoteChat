import sys
import subprocess
import time
import random
import string
import os

def generate_passcode():
    # Generate an easy to type 6-digit numeric code for "temp opt" feel
    return ''.join(random.choices(string.digits, k=6))

def main():
    port = 3000
    
    # 1. Check/Install dependencies
    needed = ["pyngrok", "python-dotenv"]
    for pkg in needed:
        try:
            if pkg == "pyngrok": from pyngrok import ngrok
            if pkg == "python-dotenv": from dotenv import load_dotenv
        except ImportError:
            print(f"📦 Package '{pkg}' not found. Installing now...")
            subprocess.check_call([sys.executable, "-m", "pip", "install", pkg])
            
    from pyngrok import ngrok
    from dotenv import load_dotenv
    
    # Load .env file
    load_dotenv()

    # Configure ngrok authtoken if provided in .env
    token = os.environ.get('NGROK_AUTHTOKEN')
    if token:
        ngrok.set_auth_token(token)

    # 2. Get passcode from env
    passcode = os.environ.get('APP_PASSWORD')
    is_temp = False
    
    if not passcode:
        # This shouldn't happen if started via .bat, but for standalone use:
        passcode = generate_passcode()
        is_temp = True
        print(f"⚠️  Note: No APP_PASSWORD env found. Using temporary passcode: {passcode}")

    # 3. Start Node.js server
    print("\n📦 Launching Antigravity Phone Connect server...")
    node_cmd = ["node", "server.js"]
    node_process = None
    try:
        # We use a sub-shell to capture logs to a file like the .bat did
        with open("server_log.txt", "w") as log_file:
            node_process = subprocess.Popen(node_cmd, stdout=log_file, stderr=log_file)
        
        # Wait a moment for server to initialize
        time.sleep(2)
        if node_process.poll() is not None:
            print("❌ Server failed to start. Check server_log.txt for details.")
            sys.exit(1)
            
    except Exception as e:
        print(f"❌ Failed to launch node: {e}")
        sys.exit(1)

    try:
        print("\n" + "="*50)
        print("🛰️  STARTING GLOBAL WEB TUNNEL")
        print("="*50)
        
        # Detect if server is running on HTTPS
        # We check the same way the Node.js server does
        protocol = "http"
        project_dir = os.path.dirname(os.path.abspath(__file__))
        if os.path.exists(os.path.join(project_dir, 'certs', 'server.key')) and \
           os.path.exists(os.path.join(project_dir, 'certs', 'server.cert')):
            protocol = "https"
            print("🔒 Local HTTPS detected. Configuring tunnel...")

        # Connect to ngrok
        # If HTTPS, we must specify the protocol in the address
        # We use host_header="rewrite" to handle certificate host matching
        addr = f"{protocol}://localhost:{port}"
        
        # Note: If no authtoken is set, ngrok might fail or have 1h limit
        public_url = ngrok.connect(addr, host_header="rewrite").public_url
        
        print(f"\n🌍 REMOTE URL: \033[1;36m{public_url}\033[0m")
        print(f"🔑 PASSCODE:   \033[1;33m{passcode}\033[0m")
        
        # Keep alive
        print("\n" + "-"*50)
        print("📱 Instructions:")
        print("1. Switch your phone to Mobile Data (off Wi-Fi)")
        print(f"2. Visit: {public_url}")
        print(f"3. Login with the passcode above")
        print("="*50)
        print("\n(Press Ctrl+C to stop the tunnel)\n")

        ngrok_process = ngrok.get_ngrok_process()
        try:
            ngrok_process.proc.wait()
        except KeyboardInterrupt:
            print("\n👋 Stopping all services...")
            try:
                if node_process:
                    node_process.terminate()
                    node_process.wait(timeout=3)
            except:
                if node_process: node_process.kill()
            
            ngrok.disconnect(public_url)
            ngrok.kill()
            print("✨ Clean shutdown complete.")
            sys.exit(0)

    except Exception as e:
        print(f"\n❌ Tunnel Error: {e}")
        if "authtoken" in str(e).lower():
            print("\n💡 Tip: Your NGROK_AUTHTOKEN might be invalid.")
            print("   Please check your .env file or get a new one from https://dashboard.ngrok.com")
        elif "session closed" in str(e).lower():
            print("\n💡 Tip: Session closed by ngrok. Retrying in 5 seconds...")
            time.sleep(5)
            # We don't exit here, just return to let the .bat handle it or retry manually
        
        sys.exit(1)

if __name__ == "__main__":
    main()
