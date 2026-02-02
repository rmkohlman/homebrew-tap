# Homebrew Tap for DevOpsMaestro

This is the official Homebrew tap for [DevOpsMaestro](https://github.com/rmkohlman/devopsmaestro) tools.

## Available Formulas

| Formula | Binary | Description | Version |
|---------|--------|-------------|---------|
| **devopsmaestro** | `dvm` | kubectl-style CLI for containerized dev environments | 0.3.3 |
| **nvimops** | `nvp` | DevOps-style Neovim plugin and theme manager | 0.5.0 |

## Installation

```bash
# Add the tap
brew tap rmkohlman/tap

# Install DevOpsMaestro (dvm) - workspace/container management
brew install rmkohlman/tap/devopsmaestro

# Install NvimOps (nvp) - Neovim plugin/theme management
brew install rmkohlman/tap/nvimops

# Verify installations
dvm version
nvp version
```

## Quick Start

### NvimOps (nvp) - Neovim Plugin & Theme Manager

```bash
# Initialize nvp
nvp init

# Browse and install plugins from library
nvp library list
nvp library install telescope

# Browse and install themes
nvp theme library list
nvp theme library install tokyonight-custom --use

# Generate Lua files for Neovim
nvp generate

# Files are created in ~/.config/nvim/lua/
```

### DevOpsMaestro (dvm) - Workspace Manager

```bash
# Initialize dvm
dvm admin init

# Create a workspace from current directory
dvm create project myproject --from-cwd

# List workspaces
dvm get workspaces
```

## Upgrading

```bash
# Upgrade specific formula
brew upgrade rmkohlman/tap/nvimops
brew upgrade rmkohlman/tap/devopsmaestro

# Or upgrade all packages
brew upgrade
```

## Shell Completion

Shell completions (bash, zsh, fish) are automatically installed with each formula. Restart your shell or source your config:

```bash
# Zsh
source ~/.zshrc

# Bash
source ~/.bashrc
```

## Documentation

- [DevOpsMaestro Documentation](https://github.com/rmkohlman/devopsmaestro#readme)
- [Release Notes](https://github.com/rmkohlman/devopsmaestro/releases)
- [Shell Completion Guide](https://github.com/rmkohlman/devopsmaestro/blob/main/docs/SHELL_COMPLETION.md)
- [NvimOps Test Plan](https://github.com/rmkohlman/devopsmaestro/blob/main/NVIMOPS_TEST_PLAN.md)

## Support

- [Issues](https://github.com/rmkohlman/devopsmaestro/issues)
- [Discussions](https://github.com/rmkohlman/devopsmaestro/discussions)

## License

GPL-3.0 - See [LICENSE](https://github.com/rmkohlman/devopsmaestro/blob/main/LICENSE) for details.
