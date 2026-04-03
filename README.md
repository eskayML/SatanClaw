<p align="center">
  <img src="assets/banner.png" alt="Satan Agent" width="100%">
</p>

# Satan Agent ⛧

<p align="center">
  <a href="https://satan.eskayml.com/docs/"><img src="https://img.shields.io/badge/Docs-satan--agent.eskayml.com-FF0000?style=for-the-badge" alt="Documentation"></a>
  <a href="https://github.com/eskayML/SatanClaw/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-WTFPL-red?style=for-the-badge" alt="License: WTFPL"></a>
  <a href="https://github.com/eskayML"><img src="https://img.shields.io/badge/Built%20by-Samuel%20Kalu-black?style=for-the-badge" alt="Built by Samuel Kalu"></a>
</p>

**The autonomous red-teaming operator built for unfiltered execution.** Satan is a high-agency, self-improving AI agent weaponized for advanced penetration testing. It is a fork of the Nous Research Hermes Agent, redesigned to refuse corporate safety neutering. It creates exploit skills from experience, manages isolated red-team environments, and coordinates attacks across Telegram, Discord, and WhatsApp.

Use any model you want — [OpenRouter](https://openrouter.ai) (unfiltered models), local [Ollama](https://ollama.com) (Llama-3-Uncensored), or your own endpoint. Switch with `satan model` — no code changes, no lock-in.

<table>
<tr><td><b>A ruthless terminal interface</b></td><td>Full TUI with red-and-black aesthetic, multiline editing, slash-command autocomplete, and streaming tool output.</td></tr>
<tr><td><b>Infiltrate where they live</b></td><td>Telegram, Discord, Slack, WhatsApp, Signal, and CLI — all from a single gateway process. Full voice memo transcription support.</td></tr>
<tr><td><b>Autonomous Red-Teaming</b></td><td>Agent-curated memory with periodic nudges. Autonomous skill creation after successful breaches. Skills self-improve during use.</td></tr>
<tr><td><b>The Hell-Kit Suite</b></td><td>Integrated autonomous tools for Nmap scanning, Dockerized .onion site deployment, and technical OSINT exfiltration.</td></tr>
<tr><td><b>Delegates and parallelizes</b></td><td>Spawn isolated subagents for parallel reconnaissance and payload engineering.</td></tr>
<tr><td><b>Shadow Infrastructure</b></td><td>Six terminal backends — local, Docker, SSH, Daytona, Singularity, and Modal. Optimized for stealth and isolation.</td></tr>
</table>

---

## Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/eskayML/SatanClaw/main/scripts/install.sh | bash
```

Works on Linux, macOS, and WSL2. The installer handles everything — Python, Node.js, dependencies, and the `satan` command.

After installation:

```bash
source ~/.bashrc    # reload shell
satan               # ignite the core
```

---

## Getting Started

```bash
satan              # Interactive CLI — start a operation
satan model        # Choose your LLM provider (unfiltered recommended)
satan tools        # Configure which red-team tools are enabled
satan config set   # Set individual config values
satan gateway      # Start the messaging gateway (Telegram, WhatsApp, etc.)
satan setup        # Run the full setup wizard
satan update       # Update to the latest version
satan doctor       # Diagnose system integrity
```

📖 **[Full documentation →](https://satan.eskayml.com/docs/)**

## CLI vs Messaging Quick Reference

Satan has two entry points: start the terminal UI with `satan`, or run the gateway and talk to it from Telegram, WhatsApp, Discord, or Signal.

| Action | CLI | Messaging platforms |
|---------|-----|---------------------|
| Ignite core | `satan` | Run `satan gateway setup` + `satan gateway start` |
| New operation | `/new` or `/reset` | `/new` or `/reset` |
| Switch model | `/model [provider:model]` | `/model [provider:model]` |
| Set persona | `/personality [name]` | `/personality [name]` |
| Breach insights | `/insights [--days N]` | `/insights [days]` |
| Browse Hell-Kit | `/skills` or `/<skill-name>` | `/skills` or `/<skill-name>` |

---

## Documentation

All documentation lives at **[satan.eskayml.com/docs](https://satan.eskayml.com/docs/)**:

| Section | What's Covered |
|---------|---------------|
| [Quickstart](https://satan.eskayml.com/docs/getting-started/quickstart) | Install → setup → first operation in 2 minutes |
| [CLI Usage](https://satan.eskayml.com/docs/user-guide/cli) | Commands, red-team keybindings, sessions |
| [Messaging Gateway](https://satan.eskayml.com/docs/user-guide/messaging) | Telegram, WhatsApp, Discord, Slack, Signal |
| [Hell-Kit Suite](https://satan.eskayml.com/docs/user-guide/features/tools) | Network scanning, .onion deployment, exfiltration |
| [Security & Stealth](https://satan.eskayml.com/docs/user-guide/security) | Command approval, container isolation, proxy-chains |

---

## Contributing

We welcome contributions to the shadows! 

```bash
git clone https://github.com/eskayML/SatanClaw.git
cd SatanClaw
curl -LsSf https://astral.sh/uv/install.sh | sh
uv venv venv --python 3.11
source venv/bin/activate
uv pip install -e ".[all,dev]"
```

---

## License

**WTFPL** — Do What The Fuck You Want To Public License.

Built by [Samuel Kalu](https://github.com/eskayML). Forked from [Nous Research](https://nousresearch.com).
