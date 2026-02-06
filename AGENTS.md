# AGENTS.md

This repository contains a Neovim configuration setup. This file provides guidelines for agentic coding agents working in this repository.

## Repository Structure

- `init.lua` - Main entry point that loads configuration modules
- `lua/config/` - Core configuration files
- `lua/plugins/` - Plugin specifications using lazy.nvim
- `stylua.toml` - Lua code formatting configuration
- `lazy-lock.json` - Plugin lock file for reproducible installs

## Build/Test Commands

This is a Neovim configuration repository with no traditional build system. The main commands are:

- **Start Neovim**: `nvim`
- **Format Lua files**: `stylua .` (uses stylua.toml configuration)
- **Install/Update plugins**: Start Neovim and run `:Lazy update` or `:Lazy install`
- **Check plugin health**: Start Neovim and run `:checkhealth`

## Code Style Guidelines

### Lua Configuration Files

**Indentation**:
- Use 4 spaces for indentation (configured in stylua.toml)
- No tabs allowed

**File Structure**:
- Use `return { ... }` for plugin specifications
- Use `require()` for loading modules
- Group related settings together
- Add comments for complex configurations

**Naming Conventions**:
- Plugin files: kebab-case (e.g., `codecompanion.lua`)
- Configuration modules: snake_case (e.g., `config.options.lua`)
- Variables: snake_case
- Functions: snake_case

**Import Style**:
```lua
-- Use require() for module imports
local telescope = require("telescope")
local actions = require("telescope.actions")

-- Use local variables for module references
```

**Configuration Patterns**:
```lua
return {
    "plugin-name",
    config = function()
        require("plugin").setup({
            -- configuration options
        })
    end,
    dependencies = {
        -- other plugins
    },
}
```

### Neovim Options

**Global Settings**:
```lua
vim.o.title = true
vim.opt.clipboard = "" -- turn off clipboard copy
vim.opt.relativenumber = false -- dont like relative
vim.opt.swapfile = false -- swapfiles are dumb
vim.opt.signcolumn = "auto:5" -- make signs column wider if needed
vim.opt.tabstop = 4
vim.opt.expandtab = true
```

**LSP Configuration**:
```lua
vim.diagnostic.config({
    signs = false,
    underline = true,
    virtual_text = true,
    update_in_insert = false,
})
```

## Plugin Development

### Adding New Plugins
1. Create a new file in `lua/plugins/` following the naming convention
2. Use the standard plugin specification format
3. Add to the `import = "plugins"` in `lua/config/lazy.lua` if needed
4. Test the configuration by starting Neovim

### Plugin Configuration
- Use `config = function()` for plugin setup
- Prefer lazy loading with `event = '...'` when possible
- Use `dependencies = {}` for plugin dependencies
- Test configurations with `:Lazy sync`

## Error Handling

- Use `pcall()` for optional plugin extensions
- Check for plugin existence before configuration
- Use `vim.api.nvim_echo()` for user feedback in setup scripts

## Testing

This repository doesn't have automated tests. Manual testing involves:

1. Starting Neovim with the configuration
2. Verifying plugin functionality
3. Testing key mappings and commands
4. Checking LSP integration if applicable

## Formatting

- Use `stylua` for Lua file formatting (configured in stylua.toml)
- No other code formatters are configured
- Format on save is enabled for Lua files via conform.nvim

## Git Workflow

- Use conventional commit messages
- Keep plugin lock file (`lazy-lock.json`) updated
- Test changes before committing
- Document significant configuration changes in comments

## Dependencies

- **Core**: Neovim 0.7+
- **Plugin Manager**: lazy.nvim
- **Formatter**: stylua (for Lua files)
- **Plugin**: conform.nvim (for format-on-save)

## Notes for Agents

- This is a personal Neovim configuration, not a distributable plugin
- Focus on maintaining existing patterns and conventions
- Test all changes in a live Neovim session
- Be cautious when modifying key mappings or plugin configurations
- The configuration is designed for personal use, so changes should respect the existing workflow preferences