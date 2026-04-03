---
sidebar_position: 7
---

# Profile Commands Reference

This page covers all commands related to [Satan profiles](../user-guide/profiles.md). For general CLI commands, see [CLI Commands Reference](./cli-commands.md).

## `satan profile`

```bash
satan profile <subcommand>
```

Top-level command for managing profiles. Running `satan profile` without a subcommand shows help.

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

## `satan profile list`

```bash
satan profile list
```

Lists all profiles. The currently active profile is marked with `*`.

**Example:**

```bash
$ satan profile list
  default
* work
  dev
  personal
```

No options.

## `satan profile use`

```bash
satan profile use <name>
```

Sets `<name>` as the active profile. All subsequent `satan` commands (without `-p`) will use this profile.

| Argument | Description |
|----------|-------------|
| `<name>` | Profile name to activate. Use `default` to return to the base profile. |

**Example:**

```bash
satan profile use work
satan profile use default
```

## `satan profile create`

```bash
satan profile create <name> [options]
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
satan profile create mybot

# Clone config only from current profile
satan profile create work --clone

# Clone everything from current profile
satan profile create backup --clone-all

# Clone config from a specific profile
satan profile create work2 --clone --clone-from work
```

## `satan profile delete`

```bash
satan profile delete <name> [options]
```

Deletes a profile and removes its shell alias.

| Argument / Option | Description |
|-------------------|-------------|
| `<name>` | Profile to delete. |
| `--yes`, `-y` | Skip confirmation prompt. |

**Example:**

```bash
satan profile delete mybot
satan profile delete mybot --yes
```

:::warning
This permanently deletes the profile's entire directory including all config, memories, sessions, and skills. Cannot delete the currently active profile.
:::

## `satan profile show`

```bash
satan profile show <name>
```

Displays details about a profile including its home directory, configured model, active platforms, and disk usage.

| Argument | Description |
|----------|-------------|
| `<name>` | Profile to inspect. |

**Example:**

```bash
$ satan profile show work
Profile:    work
Home:       ~/.satan/profiles/work
Model:      anthropic/claude-sonnet-4
Platforms:  telegram, discord
Skills:     12 installed
Disk:       48 MB
```

## `satan profile alias`

```bash
satan profile alias <name> [options]
```

Regenerates the shell alias script at `~/.local/bin/<name>`. Useful if the alias was accidentally deleted or if you need to update it after moving your Satan installation.

| Argument / Option | Description |
|-------------------|-------------|
| `<name>` | Profile to create/update the alias for. |
| `--remove` | Remove the wrapper script instead of creating it. |
| `--name <alias>` | Custom alias name (default: profile name). |

**Example:**

```bash
satan profile alias work
# Creates/updates ~/.local/bin/work

satan profile alias work --name mywork
# Creates ~/.local/bin/mywork

satan profile alias work --remove
# Removes the wrapper script
```

## `satan profile rename`

```bash
satan profile rename <old-name> <new-name>
```

Renames a profile. Updates the directory and shell alias.

| Argument | Description |
|----------|-------------|
| `<old-name>` | Current profile name. |
| `<new-name>` | New profile name. |

**Example:**

```bash
satan profile rename mybot assistant
# ~/.satan/profiles/mybot → ~/.satan/profiles/assistant
# ~/.local/bin/mybot → ~/.local/bin/assistant
```

## `satan profile export`

```bash
satan profile export <name> [options]
```

Exports a profile as a compressed tar.gz archive.

| Argument / Option | Description |
|-------------------|-------------|
| `<name>` | Profile to export. |
| `-o`, `--output <path>` | Output file path (default: `<name>.tar.gz`). |

**Example:**

```bash
satan profile export work
# Creates work.tar.gz in the current directory

satan profile export work -o ./work-2026-03-29.tar.gz
```

## `satan profile import`

```bash
satan profile import <archive> [options]
```

Imports a profile from a tar.gz archive.

| Argument / Option | Description |
|-------------------|-------------|
| `<archive>` | Path to the tar.gz archive to import. |
| `--name <name>` | Name for the imported profile (default: inferred from archive). |

**Example:**

```bash
satan profile import ./work-2026-03-29.tar.gz
# Infers profile name from the archive

satan profile import ./work-2026-03-29.tar.gz --name work-restored
```

## `satan -p` / `satan --profile`

```bash
satan -p <name> <command> [options]
satan --profile <name> <command> [options]
```

Global flag to run any Satan command under a specific profile without changing the sticky default. This overrides the active profile for the duration of the command.

| Option | Description |
|--------|-------------|
| `-p <name>`, `--profile <name>` | Profile to use for this command. |

**Examples:**

```bash
satan -p work chat -q "Check the server status"
satan --profile dev gateway start
satan -p personal skills list
satan -p work config edit
```

## `satan completion`

```bash
satan completion <shell>
```

Generates shell completion scripts. Includes completions for profile names and profile subcommands.

| Argument | Description |
|----------|-------------|
| `<shell>` | Shell to generate completions for: `bash` or `zsh`. |

**Examples:**

```bash
# Install completions
satan completion bash >> ~/.bashrc
satan completion zsh >> ~/.zshrc

# Reload shell
source ~/.bashrc
```

After installation, tab completion works for:
- `satan profile <TAB>` — subcommands (list, use, create, etc.)
- `satan profile use <TAB>` — profile names
- `satan -p <TAB>` — profile names

## See also

- [Profiles User Guide](../user-guide/profiles.md)
- [CLI Commands Reference](./cli-commands.md)
- [FAQ — Profiles section](./faq.md#profiles)
