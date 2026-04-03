---
sidebar_position: 1
title: "CLI Commands Reference"
description: "Authoritative reference for Satan terminal commands and command families"
---

# CLI Commands Reference

This page covers the **terminal commands** you run from your shell.

For in-chat slash commands, see [Slash Commands Reference](./slash-commands.md).

## Global entrypoint

```bash
satan [global-options] <command> [subcommand/options]
```

### Global options

| Option | Description |
|--------|-------------|
| `--version`, `-V` | Show version and exit. |
| `--profile <name>`, `-p <name>` | Select which Satan profile to use for this invocation. Overrides the sticky default set by `satan profile use`. |
| `--resume <session>`, `-r <session>` | Resume a previous session by ID or title. |
| `--continue [name]`, `-c [name]` | Resume the most recent session, or the most recent session matching a title. |
| `--worktree`, `-w` | Start in an isolated git worktree for parallel-agent workflows. |
| `--yolo` | Bypass dangerous-command approval prompts. |
| `--pass-session-id` | Include the session ID in the agent's system prompt. |

## Top-level commands

| Command | Purpose |
|---------|---------|
| `satan chat` | Interactive or one-shot chat with the agent. |
| `satan model` | Interactively choose the default provider and model. |
| `satan gateway` | Run or manage the messaging gateway service. |
| `satan setup` | Interactive setup wizard for all or part of the configuration. |
| `satan whatsapp` | Configure and pair the WhatsApp bridge. |
| `satan login` / `logout` | Authenticate with OAuth-backed providers. |
| `satan auth` | Manage credential pools — add, list, remove, reset, set strategy. |
| `satan status` | Show agent, auth, and platform status. |
| `satan cron` | Inspect and tick the cron scheduler. |
| `satan webhook` | Manage dynamic webhook subscriptions for event-driven activation. |
| `satan doctor` | Diagnose config and dependency issues. |
| `satan config` | Show, edit, migrate, and query configuration files. |
| `satan pairing` | Approve or revoke messaging pairing codes. |
| `satan skills` | Browse, install, publish, audit, and configure skills. |
| `satan honcho` | Manage Honcho cross-session memory integration. |
| `satan acp` | Run Satan as an ACP server for editor integration. |
| `satan mcp` | Manage MCP server configurations and run Satan as an MCP server. |
| `satan plugins` | Manage Satan Agent plugins (install, enable, disable, remove). |
| `satan tools` | Configure enabled tools per platform. |
| `satan sessions` | Browse, export, prune, rename, and delete sessions. |
| `satan insights` | Show token/cost/activity analytics. |
| `satan claw` | OpenClaw migration helpers. |
| `satan profile` | Manage profiles — multiple isolated Satan instances. |
| `satan completion` | Print shell completion scripts (bash/zsh). |
| `satan version` | Show version information. |
| `satan update` | Pull latest code and reinstall dependencies. |
| `satan uninstall` | Remove Satan from the system. |

## `satan chat`

```bash
satan chat [options]
```

Common options:

| Option | Description |
|--------|-------------|
| `-q`, `--query "..."` | One-shot, non-interactive prompt. |
| `-m`, `--model <model>` | Override the model for this run. |
| `-t`, `--toolsets <csv>` | Enable a comma-separated set of toolsets. |
| `--provider <provider>` | Force a provider: `auto`, `openrouter`, `nous`, `openai-codex`, `copilot-acp`, `copilot`, `anthropic`, `huggingface`, `zai`, `kimi-coding`, `minimax`, `minimax-cn`, `kilocode`. |
| `-s`, `--skills <name>` | Preload one or more skills for the session (can be repeated or comma-separated). |
| `-v`, `--verbose` | Verbose output. |
| `-Q`, `--quiet` | Programmatic mode: suppress banner/spinner/tool previews. |
| `--resume <session>` / `--continue [name]` | Resume a session directly from `chat`. |
| `--worktree` | Create an isolated git worktree for this run. |
| `--checkpoints` | Enable filesystem checkpoints before destructive file changes. |
| `--yolo` | Skip approval prompts. |
| `--pass-session-id` | Pass the session ID into the system prompt. |
| `--source <tag>` | Session source tag for filtering (default: `cli`). Use `tool` for third-party integrations that should not appear in user session lists. |

Examples:

```bash
satan
satan chat -q "Summarize the latest PRs"
satan chat --provider openrouter --model anthropic/claude-sonnet-4.6
satan chat --toolsets web,terminal,skills
satan chat --quiet -q "Return only JSON"
satan chat --worktree -q "Review this repo and open a PR"
```

## `satan model`

Interactive provider + model selector.

```bash
satan model
```

Use this when you want to:
- switch default providers
- log into OAuth-backed providers during model selection
- pick from provider-specific model lists
- configure a custom/self-hosted endpoint
- save the new default into config

### `/model` slash command (mid-session)

Switch models without leaving a session:

```
/model                              # Show current model and available options
/model claude-sonnet-4              # Switch model (auto-detects provider)
/model zai:glm-5                    # Switch provider and model
/model custom:qwen-2.5              # Use model on your custom endpoint
/model custom                       # Auto-detect model from custom endpoint
/model custom:local:qwen-2.5        # Use a named custom provider
/model openrouter:anthropic/claude-sonnet-4  # Switch back to cloud
```

Provider and base URL changes are persisted to `config.yaml` automatically. When switching away from a custom endpoint, the stale base URL is cleared to prevent it leaking into other providers.

## `satan gateway`

```bash
satan gateway <subcommand>
```

Subcommands:

| Subcommand | Description |
|------------|-------------|
| `run` | Run the gateway in the foreground. |
| `start` | Start the installed gateway service. |
| `stop` | Stop the service. |
| `restart` | Restart the service. |
| `status` | Show service status. |
| `install` | Install as a user service (`systemd` on Linux, `launchd` on macOS). |
| `uninstall` | Remove the installed service. |
| `setup` | Interactive messaging-platform setup. |

## `satan setup`

```bash
satan setup [model|terminal|gateway|tools|agent] [--non-interactive] [--reset]
```

Use the full wizard or jump into one section:

| Section | Description |
|---------|-------------|
| `model` | Provider and model setup. |
| `terminal` | Terminal backend and sandbox setup. |
| `gateway` | Messaging platform setup. |
| `tools` | Enable/disable tools per platform. |
| `agent` | Agent behavior settings. |

Options:

| Option | Description |
|--------|-------------|
| `--non-interactive` | Use defaults / environment values without prompts. |
| `--reset` | Reset configuration to defaults before setup. |

## `satan whatsapp`

```bash
satan whatsapp
```

Runs the WhatsApp pairing/setup flow, including mode selection and QR-code pairing.

## `satan login` / `satan logout`

```bash
satan login [--provider nous|openai-codex] [--portal-url ...] [--inference-url ...]
satan logout [--provider nous|openai-codex]
```

`login` supports:
- Nous Portal OAuth/device flow
- OpenAI Codex OAuth/device flow

Useful options for `login`:
- `--no-browser`
- `--timeout <seconds>`
- `--ca-bundle <pem>`
- `--insecure`

## `satan auth`

Manage credential pools for same-provider key rotation. See [Credential Pools](/docs/user-guide/features/credential-pools) for full documentation.

```bash
satan auth                                              # Interactive wizard
satan auth list                                         # Show all pools
satan auth list openrouter                              # Show specific provider
satan auth add openrouter --api-key sk-or-v1-xxx        # Add API key
satan auth add anthropic --type oauth                   # Add OAuth credential
satan auth remove openrouter 2                          # Remove by index
satan auth reset openrouter                             # Clear cooldowns
```

Subcommands: `add`, `list`, `remove`, `reset`. When called with no subcommand, launches the interactive management wizard.

## `satan status`

```bash
satan status [--all] [--deep]
```

| Option | Description |
|--------|-------------|
| `--all` | Show all details in a shareable redacted format. |
| `--deep` | Run deeper checks that may take longer. |

## `satan cron`

```bash
satan cron <list|create|edit|pause|resume|run|remove|status|tick>
```

| Subcommand | Description |
|------------|-------------|
| `list` | Show scheduled jobs. |
| `create` / `add` | Create a scheduled job from a prompt, optionally attaching one or more skills via repeated `--skill`. |
| `edit` | Update a job's schedule, prompt, name, delivery, repeat count, or attached skills. Supports `--clear-skills`, `--add-skill`, and `--remove-skill`. |
| `pause` | Pause a job without deleting it. |
| `resume` | Resume a paused job and compute its next future run. |
| `run` | Trigger a job on the next scheduler tick. |
| `remove` | Delete a scheduled job. |
| `status` | Check whether the cron scheduler is running. |
| `tick` | Run due jobs once and exit. |

## `satan webhook`

```bash
satan webhook <subscribe|list|remove|test>
```

Manage dynamic webhook subscriptions for event-driven agent activation. Requires the webhook platform to be enabled in config — if not configured, prints setup instructions.

| Subcommand | Description |
|------------|-------------|
| `subscribe` / `add` | Create a webhook route. Returns the URL and HMAC secret to configure on your service. |
| `list` / `ls` | Show all agent-created subscriptions. |
| `remove` / `rm` | Delete a dynamic subscription. Static routes from config.yaml are not affected. |
| `test` | Send a test POST to verify a subscription is working. |

### `satan webhook subscribe`

```bash
satan webhook subscribe <name> [options]
```

| Option | Description |
|--------|-------------|
| `--prompt` | Prompt template with `{dot.notation}` payload references. |
| `--events` | Comma-separated event types to accept (e.g. `issues,pull_request`). Empty = all. |
| `--description` | Human-readable description. |
| `--skills` | Comma-separated skill names to load for the agent run. |
| `--deliver` | Delivery target: `log` (default), `telegram`, `discord`, `slack`, `github_comment`. |
| `--deliver-chat-id` | Target chat/channel ID for cross-platform delivery. |
| `--secret` | Custom HMAC secret. Auto-generated if omitted. |

Subscriptions persist to `~/.satan/webhook_subscriptions.json` and are hot-reloaded by the webhook adapter without a gateway restart.

## `satan doctor`

```bash
satan doctor [--fix]
```

| Option | Description |
|--------|-------------|
| `--fix` | Attempt automatic repairs where possible. |

## `satan config`

```bash
satan config <subcommand>
```

Subcommands:

| Subcommand | Description |
|------------|-------------|
| `show` | Show current config values. |
| `edit` | Open `config.yaml` in your editor. |
| `set <key> <value>` | Set a config value. |
| `path` | Print the config file path. |
| `env-path` | Print the `.env` file path. |
| `check` | Check for missing or stale config. |
| `migrate` | Add newly introduced options interactively. |

## `satan pairing`

```bash
satan pairing <list|approve|revoke|clear-pending>
```

| Subcommand | Description |
|------------|-------------|
| `list` | Show pending and approved users. |
| `approve <platform> <code>` | Approve a pairing code. |
| `revoke <platform> <user-id>` | Revoke a user's access. |
| `clear-pending` | Clear pending pairing codes. |

## `satan skills`

```bash
satan skills <subcommand>
```

Subcommands:

| Subcommand | Description |
|------------|-------------|
| `browse` | Paginated browser for skill registries. |
| `search` | Search skill registries. |
| `install` | Install a skill. |
| `inspect` | Preview a skill without installing it. |
| `list` | List installed skills. |
| `check` | Check installed hub skills for upstream updates. |
| `update` | Reinstall hub skills with upstream changes when available. |
| `audit` | Re-scan installed hub skills. |
| `uninstall` | Remove a hub-installed skill. |
| `publish` | Publish a skill to a registry. |
| `snapshot` | Export/import skill configurations. |
| `tap` | Manage custom skill sources. |
| `config` | Interactive enable/disable configuration for skills by platform. |

Common examples:

```bash
satan skills browse
satan skills browse --source official
satan skills search react --source skills-sh
satan skills search https://mintlify.com/docs --source well-known
satan skills inspect official/security/1password
satan skills inspect skills-sh/vercel-labs/json-render/json-render-react
satan skills install official/migration/openclaw-migration
satan skills install skills-sh/anthropics/skills/pdf --force
satan skills check
satan skills update
satan skills config
```

Notes:
- `--force` can override non-dangerous policy blocks for third-party/community skills.
- `--force` does not override a `dangerous` scan verdict.
- `--source skills-sh` searches the public `skills.sh` directory.
- `--source well-known` lets you point Satan at a site exposing `/.well-known/skills/index.json`.

## `satan honcho`

```bash
satan honcho <subcommand>
```

Subcommands:

| Subcommand | Description |
|------------|-------------|
| `setup` | Interactive Honcho setup wizard. |
| `status` | Show current Honcho config and connection status. |
| `sessions` | List known Honcho session mappings. |
| `map` | Map the current directory to a Honcho session name. |
| `peer` | Show or update peer names and dialectic reasoning level. |
| `mode` | Show or set memory mode: `hybrid`, `honcho`, or `local`. |
| `tokens` | Show or set token budgets for context and dialectic. |
| `identity` | Seed or show the AI peer identity representation. |
| `migrate` | Migration guide from openclaw-honcho to Satan Honcho. |

## `satan acp`

```bash
satan acp
```

Starts Satan as an ACP (Agent Client Protocol) stdio server for editor integration.

Related entrypoints:

```bash
satan-acp
python -m acp_adapter
```

Install support first:

```bash
pip install -e '.[acp]'
```

See [ACP Editor Integration](../user-guide/features/acp.md) and [ACP Internals](../developer-guide/acp-internals.md).

## `satan mcp`

```bash
satan mcp <subcommand>
```

Manage MCP (Model Context Protocol) server configurations and run Satan as an MCP server.

| Subcommand | Description |
|------------|-------------|
| `serve [-v\|--verbose]` | Run Satan as an MCP server — expose conversations to other agents. |
| `add <name> [--url URL] [--command CMD] [--args ...] [--auth oauth\|header]` | Add an MCP server with automatic tool discovery. |
| `remove <name>` (alias: `rm`) | Remove an MCP server from config. |
| `list` (alias: `ls`) | List configured MCP servers. |
| `test <name>` | Test connection to an MCP server. |
| `configure <name>` (alias: `config`) | Toggle tool selection for a server. |

See [MCP Config Reference](./mcp-config-reference.md), [Use MCP with Satan](../guides/use-mcp-with-satan.md), and [MCP Server Mode](../user-guide/features/mcp.md#running-satan-as-an-mcp-server).

## `satan plugins`

```bash
satan plugins [subcommand]
```

Manage Satan Agent plugins. Running `satan plugins` with no subcommand launches an interactive curses checklist to enable/disable installed plugins.

| Subcommand | Description |
|------------|-------------|
| *(none)* | Interactive toggle UI — enable/disable plugins with arrow keys and space. |
| `install <identifier> [--force]` | Install a plugin from a Git URL or `owner/repo`. |
| `update <name>` | Pull latest changes for an installed plugin. |
| `remove <name>` (aliases: `rm`, `uninstall`) | Remove an installed plugin. |
| `enable <name>` | Enable a disabled plugin. |
| `disable <name>` | Disable a plugin without removing it. |
| `list` (alias: `ls`) | List installed plugins with enabled/disabled status. |

Disabled plugins are stored in `config.yaml` under `plugins.disabled` and skipped during loading.

See [Plugins](../user-guide/features/plugins.md) and [Build a Satan Plugin](../guides/build-a-satan-plugin.md).

## `satan tools`

```bash
satan tools [--summary]
```

| Option | Description |
|--------|-------------|
| `--summary` | Print the current enabled-tools summary and exit. |

Without `--summary`, this launches the interactive per-platform tool configuration UI.

## `satan sessions`

```bash
satan sessions <subcommand>
```

Subcommands:

| Subcommand | Description |
|------------|-------------|
| `list` | List recent sessions. |
| `browse` | Interactive session picker with search and resume. |
| `export <output> [--session-id ID]` | Export sessions to JSONL. |
| `delete <session-id>` | Delete one session. |
| `prune` | Delete old sessions. |
| `stats` | Show session-store statistics. |
| `rename <session-id> <title>` | Set or change a session title. |

## `satan insights`

```bash
satan insights [--days N] [--source platform]
```

| Option | Description |
|--------|-------------|
| `--days <n>` | Analyze the last `n` days (default: 30). |
| `--source <platform>` | Filter by source such as `cli`, `telegram`, or `discord`. |

## `satan claw`

```bash
satan claw migrate [options]
```

Migrate your OpenClaw setup to Satan. Reads from `~/.openclaw` (or a custom path) and writes to `~/.satan`. Automatically detects legacy directory names (`~/.clawdbot`, `~/.moldbot`) and config filenames (`clawdbot.json`, `moldbot.json`).

| Option | Description |
|--------|-------------|
| `--dry-run` | Preview what would be migrated without writing anything. |
| `--preset <name>` | Migration preset: `full` (default, includes secrets) or `user-data` (excludes API keys). |
| `--overwrite` | Overwrite existing Satan files on conflicts (default: skip). |
| `--migrate-secrets` | Include API keys in migration (enabled by default with `--preset full`). |
| `--source <path>` | Custom OpenClaw directory (default: `~/.openclaw`). |
| `--workspace-target <path>` | Target directory for workspace instructions (AGENTS.md). |
| `--skill-conflict <mode>` | Handle skill name collisions: `skip` (default), `overwrite`, or `rename`. |
| `--yes` | Skip the confirmation prompt. |

### What gets migrated

The migration covers 30+ categories across persona, memory, skills, model providers, messaging platforms, agent behavior, session policies, MCP servers, TTS, and more. Items are either **directly imported** into Satan equivalents or **archived** for manual review.

**Directly imported:** SOUL.md, MEMORY.md, USER.md, AGENTS.md, skills (4 source directories), default model, custom providers, MCP servers, messaging platform tokens and allowlists (Telegram, Discord, Slack, WhatsApp, Signal, Matrix, Mattermost), agent defaults (reasoning effort, compression, human delay, timezone, sandbox), session reset policies, approval rules, TTS config, browser settings, tool settings, exec timeout, command allowlist, gateway config, and API keys from 3 sources.

**Archived for manual review:** Cron jobs, plugins, hooks/webhooks, memory backend (QMD), skills registry config, UI/identity, logging, multi-agent setup, channel bindings, IDENTITY.md, TOOLS.md, HEARTBEAT.md, BOOTSTRAP.md.

**API key resolution** checks three sources in priority order: config values → `~/.openclaw/.env` → `auth-profiles.json`. All token fields handle plain strings, env templates (`${VAR}`), and SecretRef objects.

For the complete config key mapping, SecretRef handling details, and post-migration checklist, see the **[full migration guide](../guides/migrate-from-openclaw.md)**.

### Examples

```bash
# Preview what would be migrated
satan claw migrate --dry-run

# Full migration including API keys
satan claw migrate --preset full

# Migrate user data only (no secrets), overwrite conflicts
satan claw migrate --preset user-data --overwrite

# Migrate from a custom OpenClaw path
satan claw migrate --source /home/user/old-openclaw
```

## `satan profile`

```bash
satan profile <subcommand>
```

Manage profiles — multiple isolated Satan instances, each with its own config, sessions, skills, and home directory.

| Subcommand | Description |
|------------|-------------|
| `list` | List all profiles. |
| `use <name>` | Set a sticky default profile. |
| `create <name> [--clone] [--no-alias]` | Create a new profile. `--clone` copies config, `.env`, and `SOUL.md` from the active profile. |
| `delete <name> [-y]` | Delete a profile. |
| `show <name>` | Show profile details (home directory, config, etc.). |
| `alias <name> [--remove] [--name NAME]` | Manage wrapper scripts for quick profile access. |
| `rename <old> <new>` | Rename a profile. |
| `export <name> [-o FILE]` | Export a profile to a `.tar.gz` archive. |
| `import <archive> [--name NAME]` | Import a profile from a `.tar.gz` archive. |

Examples:

```bash
satan profile list
satan profile create work --clone
satan profile use work
satan profile alias work --name h-work
satan profile export work -o work-backup.tar.gz
satan profile import work-backup.tar.gz --name restored
satan -p work chat -q "Hello from work profile"
```

## `satan completion`

```bash
satan completion [bash|zsh]
```

Print a shell completion script to stdout. Source the output in your shell profile for tab-completion of Satan commands, subcommands, and profile names.

Examples:

```bash
# Bash
satan completion bash >> ~/.bashrc

# Zsh
satan completion zsh >> ~/.zshrc
```

## Maintenance commands

| Command | Description |
|---------|-------------|
| `satan version` | Print version information. |
| `satan update` | Pull latest changes and reinstall dependencies. |
| `satan uninstall [--full] [--yes]` | Remove Satan, optionally deleting all config/data. |

## See also

- [Slash Commands Reference](./slash-commands.md)
- [CLI Interface](../user-guide/cli.md)
- [Sessions](../user-guide/sessions.md)
- [Skills System](../user-guide/features/skills.md)
- [Skins & Themes](../user-guide/features/skins.md)
