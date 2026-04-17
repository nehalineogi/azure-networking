from fastmcp import FastMCP
import subprocess
import socket
import requests

mcp = FastMCP("Networking Demo Server")

@mcp.tool
def ping_host(host: str) -> str:
    """Ping a host to check reachability"""
    try:
        # Ping once (-c 1) for Linux/macOS, adjust for Windows if needed
        output = subprocess.check_output(
            ["ping", "-c", "1", host],
            stderr=subprocess.STDOUT,
            universal_newlines=True
        )
        return f"Host {host} is reachable.\n{output}"
    except subprocess.CalledProcessError as e:
        return f"Host {host} is not reachable.\n{e.output}"

@mcp.tool
def resolve_dns(domain: str) -> list:
    """Resolve a domain name to IP addresses"""
    try:
        return socket.gethostbyname_ex(domain)[2]
    except Exception as e:
        return [f"Error resolving {domain}: {e}"]

@mcp.tool
def get_local_ip() -> str:
    """Get the local IP of this machine"""
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        s.connect(("8.8.8.8", 80))
        ip = s.getsockname()[0]
    except Exception:
        ip = "127.0.0.1"
    finally:
        s.close()
    return ip

@mcp.tool
def http_status(url: str) -> int:
    """Return HTTP status code for a URL"""
    try:
        response = requests.get(url)
        return response.status_code
    except Exception as e:
        return f"Error fetching {url}: {e}"

if __name__ == "__main__":
    mcp.run(transport="http", host="127.0.0.1", port=5000)

