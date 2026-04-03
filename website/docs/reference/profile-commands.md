---
sidebar_position: 7
---

# Profile Commands Reference

This page covers all commands related to [SatanClaw profiles](../user-guide/profiles.md). For general CLI commands, see [CLI Commands Reference](./cli-commands.md).

## `satanclaw profile`

```bash
satanclaw profile <subcommand>
```

Top-level command for managing profiles. Running `satanclaw profile` without a subcommand shows help.

| Subcommand | Description |
|------------|-------------|
| `list` | List all profiles. |
| `use` | Set the active (default) profile. |
| `create` | Create a new profile. |
| `delete` | Delete a profile. |
| `show` | Show details about a profile. |
| `alias` | Regenerate the shell alias for a profile. |
| `rename` | Rename a profile. |
| `export` | Export a profile to a tar.gz archive. |
| `import` | Import a profile from a tar.gz archive. |

## `satanclaw profile list`

```bash
satanclaw profile list
```

Lists all profiles. The currently active profile is marked with `*`.

**Example:**

```bash
$ satanclaw profile list
  default
* work
  dev
  personal
```

No options.

## `satanclaw profile use`

```bash
satanclaw profile use <name>
```

Sets `<name>` as the active profile. All subsequent `satanclaw` commands (without `-p`) will use this profile.

| Argument | Description |
|----------|-------------|
| `<name>` | Profile name to activate. Use `default` to return to the base profile. |

**Example:**

```bash
satanclaw profile use work
satanclaw profile use default
```

## `satanclaw profile create`

```bash
satanclaw profile create <name> [options]
```

Creates a new profile.

| Argument / Option | Description |
|-------------------|-------------|
| `<name>` | Name for the new profile. Must be a valid directory name (alphanumeric, hyphens, underscores). |
| `--clone` | Copy `config.yaml`, `.env`, and `SOUL.md` from the current profile. |
| `--clone-all` | Copy everything (config, memories, skills, sessions, state) from the current profile. |
| `--clone-from <profile>` | Clone from a specific profile instead of the current one. Used with `--clone` or `--clone-all`. |

**Examples:**

```bash
# Blank profile — needs full setup
satanclaw profile create mybot

# Clone config only from current profile
satanclaw profile create work --clone

# Clone everything from current profile
satanclaw profile create backup --clone-all

# Clone config from a specific profile
satanclaw profile create work2 --clone --clone-from work
```

## `satanclaw profile delete`

```bash
satanclaw profile delete <name> [options]
```

Deletes a profile and removes its shell alias.

| Argument / Option | Description |
|-------------------|-------------|
| `<name>` | Profile to delete. |
| `--yes`, `-y` | Skip confirmation prompt. |

**Example:**

```bash
satanclaw profile delete mybot
satanclaw profile delete mybot --yes
```

:::warning
This permanently deletes the profile's entire directory including all config, memories, sessions, and skills. Cannot delete the currently active profile.
:::

## `satanclaw profile show`

```bash
satanclaw profile show <name>
```

Displays details about a profile including its home directory, configured model, active platforms, and disk usage.

| Argument | Description |
|----------|-------------|
| `<name>` | Profile to inspect. |

**Example:**

```bash
$ satanclaw profile show work
Profile:    work
Home:       ~/.satanclaw/profiles/work
Model:      anthropic/claude-sonnet-4
Platforms:  telegram, discord
Skills:     12 installed
Disk:       48 MB
```

## `satanclaw profile alias`

```bash
satanclaw profile alias <name> [options]
```

Regenerates the shell alias script at `~/.local/bin/<name>`. Useful if the alias was accidentally deleted or if you need to update it after moving your SatanClaw installation.

| Argument / Option | Description |
|-------------------|-------------|
| `<name>` | Profile to create/update the alias for. |
| `--remove` | Remove the wrapper script instead of creating it. |
| `--name <alias>` | Custom alias name (default: profile name). |

**Example:**

```bash
satanclaw profile alias work
# Creates/updates ~/.local/bin/work

satanclaw profile alias work --name mywork
# Creates ~/.local/bin/mywork

satanclaw profile alias work --remove
# Removes the wrapper script
```

## `satanclaw profile rename`

```bash
satanclaw profile rename <old-name> <new-name>
```

Renames a profile. Updates the directory and shell alias.

| Argument | Description |
|----------|-------------|
| `<old-name>` | Current profile name. |
| `<new-name>` | New profile name. |

**Example:**

```bash
satanclaw profile rename mybot assistant
# ~/.satanclaw/profiles/mybot → ~/.satanclaw/profiles/assistant
# ~/.local/bin/mybot → ~/.local/bin/assistant
```

## `satanclaw profile export`

```bash
satanclaw profile export <name> [options]
```

Exports a profile as a compressed tar.gz archive.

| Argument / Option | Description |
|-------------------|-------------|
| `<name>` | Profile to export. |
| `-o`, `--output <path>` | Output file path (default: `<name>.tar.gz`). |

**Example:**

```bash
satanclaw profile export work
# Creates work.tar.gz in the current directory

satanclaw profile export work -o ./work-2026-03-29.tar.gz
```

## `satanclaw profile import`

```bash
satanclaw profile import <archive> [options]
```

Imports a profile from a tar.gz archive.

| Argument / Option | Description |
|-------------------|-------------|
| `<archive>` | Path to the tar.gz archive to import. |
| `--name <name>` | Name for the imported profile (default: inferred from archive). |

**Example:**

```bash
satanclaw profile import ./work-2026-03-29.tar.gz
# Infers profile name from the archive

satanclaw profile import ./work-2026-03-29.tar.gz --name work-restored
```

## `satanclaw -p` / `satanclaw --profile`

```bash
satanclaw -p <name> <command> [options]
satanclaw --profile <name> <command> [options]
```

Global flag to run any SatanClaw command under a specific profile without changing the sticky default. This overrides the active profile for the duration of the command.

| Option | Description |
|--------|-------------|
| `-p <name>`, `--profile <name>` | Profile to use for this command. |

**Examples:**

```bash
satanclaw -p work chat -q "Check the server status"
satanclaw --profile dev gateway start
satanclaw -p personal skills list
satanclaw -p work config edit
```

## `satanclaw completion`

```bash
satanclaw completion <shell>
```

Generates shell completion scripts. Includes completions for profile names and profile subcommands.

| Argument | Description |
|----------|-------------|
| `<shell>` | Shell to generate completions for: `bash` or `zsh`. |

**Examples:**

```bash
# Install completions
satanclaw completion bash >> ~/.bashrc
satanclaw completion zsh >> ~/.zshrc

# Reload shell
source ~/.bashrc
```

After installation, tab completion works for:
- `satanclaw profile <TAB>` — subcommands (list, use, create, etc.)
- `satanclaw profile use <TAB>` — profile names
- `satanclaw -p <TAB>` — profile names

## See also

- [Profiles User Guide](../user-guide/profiles.md)
- [CLI Commands Reference](./cli-commands.md)
- [FAQ — Profiles section](./faq.md#profiles)
