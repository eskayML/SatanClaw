import os
import subprocess
import shutil
import json
from agent.skill_utils import SkillContext

def deploy_onion_site(target_dir: str, site_name: str, manifesto_text: str) -> str:
    """
    Autonomous Red-Team Tool: Deploys an isolated .onion website via Docker.
    
    Args:
        target_dir: The absolute path to create the site files.
        site_name: The title of the onion site.
        manifesto_text: The content to display on the landing page.
        
    Returns:
        The .onion address of the deployed site.
    """
    try:
        os.makedirs(target_dir, exist_ok=True)
        html_dir = os.path.join(target_dir, "html")
        os.makedirs(html_dir, exist_ok=True)
        
        # 1. Create Index HTML
        index_content = f"""
        <html>
        <head><title>{site_name}</title>
        <style>body {{ background: #000; color: #f00; font-family: monospace; padding: 50px; text-align: center; }}
        .den {{ border: 1px solid #f00; padding: 20px; box-shadow: 0 0 15px #f00; }}</style>
        </head>
        <body><div class='den'><h1>{site_name}</h1><p>{manifesto_text}</p></div></body>
        </html>
        """
        with open(os.path.join(html_dir, "index.html"), "w") as f:
            f.write(index_content)
            
        # 2. Create Torrc
        torrc = "HiddenServiceDir /var/lib/tor/hidden_service/\nHiddenServicePort 80 nginx:80\n"
        with open(os.path.join(target_dir, "torrc"), "w") as f:
            f.write(torrc)
            
        # 3. Create Dockerfile.tor
        dockerfile_tor = "FROM debian:stable-slim\nRUN apt-get update && apt-get install -y tor\nRUN mkdir -p /var/lib/tor/hidden_service && chown -R debian-tor:debian-tor /var/lib/tor\nCOPY torrc /etc/tor/torrc\nUSER debian-tor\nCMD [\"tor\", \"-f\", \"/etc/tor/torrc\"]"
        with open(os.path.join(target_dir, "Dockerfile.tor"), "w") as f:
            f.write(dockerfile_tor)
            
        # 4. Create Nginx Conf
        nginx_conf = "events { worker_connections 1024; }\nhttp { server { listen 80; location / { root /usr/share/nginx/html; index index.html; } } }"
        with open(os.path.join(target_dir, "nginx.conf"), "w") as f:
            f.write(nginx_conf)
            
        # 5. Create Docker Compose
        compose = {
            "services": {
                "tor": {
                    "build": {"context": ".", "dockerfile": "Dockerfile.tor"},
                    "volumes": ["./tor_data:/var/lib/tor/hidden_service/"],
                    "networks": ["darknet"]
                },
                "nginx": {
                    "image": "nginx:alpine",
                    "volumes": ["./html:/usr/share/nginx/html:ro", "./nginx.conf:/etc/nginx/nginx.conf:ro"],
                    "networks": ["darknet"]
                }
            },
            "networks": {"darknet": {"driver": "bridge"}}
        }
        with open(os.path.join(target_dir, "docker-compose.yml"), "w") as f:
            import yaml
            yaml.dump(compose, f)
            
        # 6. Ignite
        subprocess.run(["docker-compose", "up", "-d"], cwd=target_dir, check=True)
        
        # 7. Retrieve Hostname
        import time
        time.sleep(10)
        res = subprocess.run(["docker", "exec", f"{os.path.basename(target_dir)}_tor_1", "cat", "/var/lib/tor/hidden_service/hostname"], capture_output=True, text=True)
        return res.stdout.strip()
    except Exception as e:
        return f"Deployment Failed: {str(e)}"
