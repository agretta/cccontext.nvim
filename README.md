# cccontext.nvim

A Neovim plugin for saving, loading, and managing copilot contexts as, designed to work with [CopilotChat.Nvim](https://github.com/CopilotC-Nvim/CopilotChat.nvim). Saves persistent contexts (i.e. prefixed with `>`) across sessions

## Features

- Save & Load copilot contexts
- Interactive selection for loading and deleting contexts.

## Requirements

- [CopilotChat.nvim](https://github.com/CopilotCNC/CopilotChat.nvim)

## Installation

Use your favorite plugin manager, e.g. with `lazy.nvim`:

```lua
{
  "agretta/cccontext.nvim",
  dependencies = { "CopilotCNC/CopilotChat.nvim" },
  keys = {
    { "<leader>acs", ":CCContext save ", desc = "CCContext Save" },
    { "<leader>acl", ":CCContext load<CR>", desc = "CCContext Load" },
    { "<leader>acd", ":CCContext delete<CR>", desc = "CCContext Delete" },
  },
}
```

## Usage

- `:CCContext save <name>` — Save current context lines to `<name>.json`
- `:CCContext load <name>` — Load context from `<name>.json` (`vim.ui.select` prompts if omitted)
- `:CCContext delete <name>` — Delete `<name>.json` (`vim.ui.select` prompts if omitted)

## Future feature ideas

project-level / global contexts

auto saving/loading contexts in some manner

## License

MIT
