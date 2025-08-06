import azure.functions as func
import socket
import json
import time
import urllib.request

def get_public_ip():
    try:
        with urllib.request.urlopen("https://api.ipify.org?format=json", timeout=5) as response:
            return json.loads(response.read())["ip"]
    except:
        return "Unavailable"

def resolve_dns(domain):
    try:
        start = time.time()
        socket.gethostbyname(domain)
        end = time.time()
        return round((end - start) * 1000, 2)  # milliseconds
    except:
        return None

def get_all_ip_addresses():
    try:
        return list({info[4][0] for info in socket.getaddrinfo(socket.gethostname(), None)})
    except:
        return []

def main(req: func.HttpRequest) -> func.HttpResponse:
    hostname = socket.gethostname()
    local_ip = socket.gethostbyname(hostname)
    all_ips = get_all_ip_addresses()
    public_ip = get_public_ip()
    dns_time_ms = resolve_dns("www.microsoft.com")

    # Get headers from the incoming request
    headers = {k: v for k, v in req.headers.items()}

    result = {
        "hostname": hostname,
        "local_ip": local_ip,
        "all_ips": all_ips,
        "public_ip": public_ip,
        "dns_resolution_time_ms": dns_time_ms,
        "http_headers": headers
    }

    return func.HttpResponse(
        json.dumps(result, indent=2),
        status_code=200,
        mimetype="application/json"
    )
