---
sidebar_position: 3
title: "Updating & Uninstalling"
description: "How to update Satan Agent to the latest version or uninstall it"
---

# Updating & Uninstalling

## Updating

Update to the latest version with a single command:

```bash
satan update
```

This pulls the latest code, updates dependencies, and prompts you to configure any new options that were added since your last update.

:::tip
`satan update` automatically detects new configuration options and prompts you to add them. If you skipped that prompt, you can manually run `satan config check` to see missing options, then `satan config migrate` to interactively add them.
:::

### What happens during an update

When you run `satan update`, the following steps occur:

1. **Git pull** — pulls the latest code from the `main` branch and updates submodules
2. **Dependency install** — runs `uv pip install -e ".[all]"` to pick up new or changed dependencies
3. **Config migration** — detects new config options added since your version and prompts you to set them
4. **Gateway auto-restart** — if the gateway service is running (systemd on Linux, launchd on macOS), it is **automatically restarted** after the update completes so the new code takes effect immediately

Expected output looks like:

```
$ satan update
Updating Satan Agent...
📥 Pulling latest code...
Already up to date.  (or: Updating abc1234..def5678)
📦 Updating dependencies...
✅ Dependencies updated
🔍 Checking for new config options...
✅ Config is up to date  (or: Found 2 new options — running migration...)
🔄 Restarting gateway service...
✅ Gateway restarted
✅ Satan Agent updated successfully!
```

### Checking your current version

```bash
satan version
```

Compare against the latest release at the [GitHub releases page](https://github.com/NousResearch/satan-agent/releases) or check for available updates:

```bash
satan update --check
```

### Updating from Messaging Platforms

You can also update directly from Telegram, Discord, Slack, or WhatsApp by sending:

```
/update
```

This pulls the latest code, updates dependencies, and restarts the gateway. The bot will briefly go offline during the restart (typically 5–15 seconds) and then resume.

### Manual Update

If you installed manually (not via the quick installer):

```bash
cd /path/to/satan-agent
export VIRTUAL_ENV="$(pwd)/venv"

# Pull latest code and submodules
git pull origin main
git submodule update --init --recursive

# Reinstall (picks up new dependencies)
uv pip install -e ".[all]"
uv pip install -e "./tinker-atropos"

# Check for new config options
satan config check
satan config migrate   # Interactively add any missing options
```

### Rollback instructions

If an update introduces a problem, you can roll back to a previous version:

```bash
cd /path/to/satan-agent

# List recent versions
git log --oneline -10

# Roll back to a specific commit
git checkout <commit-hash>
git submodule update --init --recursive
uv pip install -e ".[all]"

# Restart the gateway if running
satan gateway restart
```

To roll back to a specific release tag:

```bash
git checkout v0.6.0
git submodule update --init --recursive
uv pip install -e ".[all]"
```

:::warning
Rolling back may cause config incompatibilities if new options were added. Run `satan config check` after rolling back and remove any unrecognized options from `config.yaml` if you encounter errors.
:::

### Note for Nix users

If you installed via Nix flake, updates are managed through the Nix package manager:

```bash
# Update the flake input
nix flake update satan-agent

# Or rebuild with the latest
nix profile upgrade satan-agent
```

Nix installations are immutable — rollback is handled by Nix's generation system:

```bash
nix profile rollback
```

See [Nix Setup](./nix-setup.md) for more details.

---

## Uninstalling

```bash
satan uninstall
```

The uninstaller gives you the option to keep your configuration files (`~/.satan/`) for a future reinstall.

### Manual Uninstall

```bash
rm -f ~/.local/bin/satan
rm -rf /path/to/satan-agent
rm -rf ~/.satan            # Optional — keep if you plan to reinstall
```

:::info
If you installed the gateway as a system service, stop and disable it first:
```bash
satan gateway stop
# Linux: systemctl --user disable satan-gateway
# macOS: launchctl remove ai.satan.gateway
```
:::
