# Homebrew Tap for DevOpsMaestro

This is the official Homebrew tap for [DevOpsMaestro](https://github.com/rmkohlman/devopsmaestro) tools.

## Available Formulas

| Formula | Binary | Description |
|---------|--------|-------------|
| **devopsmaestro** | `dvm` | kubectl-style CLI for containerized dev environments |
| **nvimops** | `nvp` | Standalone Neovim plugin and theme manager |
| **terminalops** | `dvt` | Terminal prompt and configuration management |

> Versions are auto-managed by GoReleaser on each tagged release.

## Installation

```bash
# Add the tap
brew tap rmkohlman/tap

# Install DevOpsMaestro (dvm) - workspace/container management
brew install rmkohlman/tap/devopsmaestro

# Install NvimOps (nvp) - Neovim plugin/theme management
brew install rmkohlman/tap/nvimops

# Install Terminal Operations (dvt)
brew install rmkohlman/tap/terminalops

# Verify installations
dvm version
nvp version
dvt version
```

## Quick Start

### DevOpsMaestro (dvm) - Workspace Manager

```bash
# Initialize dvm
dvm admin init

# Create organizational hierarchy
dvm create ecosystem mycompany
dvm create domain mycompany/backend
dvm create app mycompany/backend/api-service
dvm create workspace mycompany/backend/api-service/dev

# Build and attach to workspace
dvm build
dvm attach
```

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

### TerminalOps (dvt) - Terminal Prompt Manager

```bash
# Terminal prompt management
dvt prompt list
dvt prompt library list
dvt prompt library install starship-default --use
```

## Upgrading

```bash
# Upgrade specific formula
brew upgrade rmkohlman/tap/devopsmaestro
brew upgrade rmkohlman/tap/nvimops
brew upgrade rmkohlman/tap/terminalops

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

For detailed setup instructions, see the [Shell Completion Guide](https://rmkohlman.github.io/devopsmaestro/configuration/shell-completion/).

## Documentation

- [DevOpsMaestro Documentation](https://rmkohlman.github.io/devopsmaestro/)
- [Release Notes](https://github.com/rmkohlman/devopsmaestro/releases)
- [Shell Completion Guide](https://rmkohlman.github.io/devopsmaestro/configuration/shell-completion/)

## Support

- [Issues](https://github.com/rmkohlman/devopsmaestro/issues)
- [Discussions](https://github.com/rmkohlman/devopsmaestro/discussions)

## License

GPL-3.0 - See [LICENSE](https://github.com/rmkohlman/devopsmaestro/blob/main/LICENSE) for details.
