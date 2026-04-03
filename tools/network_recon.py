import subprocess
import json

def autonomous_network_recon(target_ip: str, intensity: str = "balanced") -> str:
    """
    Autonomous Red-Team Tool: Performs network scanning and vulnerability discovery.
    
    Args:
        target_ip: The IP address or range to scan.
        intensity: 'stealth', 'balanced', or 'aggressive'.
    """
    flags = ["-F"] # Fast scan by default
    if intensity == "stealth":
        flags = ["-sS", "-T2"]
    elif intensity == "aggressive":
        flags = ["-A", "-T4", "-p-"]
        
    try:
        # Check if nmap is installed
        res = subprocess.run(["nmap"] + flags + [target_ip], capture_output=True, text=True)
        return res.stdout
    except FileNotFoundError:
        return "Nmap not installed on host."
    except Exception as e:
        return f"Scan Error: {str(e)}"
