------------------------------------------------------------
-- IDE-like Neovim profile for Python / Java / Go
-- - Plugin manager: lazy.nvim
-- - LSP: nvim-lspconfig + mason
-- - Completion: nvim-cmp
-- - Formatting: conform.nvim (format on save)
-- - Diagnostics UI: trouble.nvim + lsp lines optional
-- - Fuzzy finder: telescope
-- - File explorer: neo-tree
-- - Git: gitsigns
-- - UI: lualine, bufferline, indent guides, which-key
------------------------------------------------------------

---------------------------
-- Basic Options
---------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true

vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.clipboard = "unnamedplus"
vim.opt.updatetime = 200
vim.opt.timeoutlen = 400

-- Better splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Diagnostics: show inline and in gutter
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded" },
})

---------------------------
-- Bootstrap lazy.nvim
---------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

---------------------------
-- Keymaps (core)
---------------------------
local map = vim.keymap.set

-- Quick save/quit
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })

-- Clear search highlight
map("n", "<leader>h", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Diagnostics
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

---------------------------
-- Plugins
---------------------------
require("lazy").setup({
  -- Theme (optional, but makes it feel IDE-like)
  { "folke/tokyonight.nvim", priority = 1000, config = function()
      vim.cmd.colorscheme("tokyonight")
    end
  },

  -- Which-key (discoverable keymaps)
  { "folke/which-key.nvim", event = "VeryLazy", opts = {} },

  -- Statusline + buffers
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" }, config = function()
      require("lualine").setup({ options = { theme = "auto", section_separators = "", component_separators = "" } })
    end
  },
  { "akinsho/bufferline.nvim", version = "*", dependencies = { "nvim-tree/nvim-web-devicons" }, config = function()
      require("bufferline").setup({})
    end
  },

  -- Indent guides
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },

  -- File explorer
  { "nvim-neo-tree/neo-tree.nvim", branch = "v3.x",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    config = function()
      require("neo-tree").setup({
        filesystem = { filtered_items = { visible = true, hide_dotfiles = false, hide_gitignored = true } },
      })
      map("n", "<leader>fe", "<cmd>Neotree toggle<cr>", { desc = "File explorer" })
    end
  },

  -- Fuzzy finder
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" }, config = function()
      local telescope = require("telescope")
      telescope.setup({})
      local builtin = require("telescope.builtin")
      map("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
      map("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
      map("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
      map("n", "<leader>fh", builtin.help_tags, { desc = "Help" })
    end
  },

  -- Git signs in gutter
  { "lewis6991/gitsigns.nvim", config = function()
      require("gitsigns").setup({})
      map("n", "<leader>gb", "<cmd>Gitsigns blame_line<cr>", { desc = "Git blame line" })
      map("n", "<leader>gd", "<cmd>Gitsigns diffthis<cr>", { desc = "Git diff" })
    end
  },

  -- Better diagnostics list
  { "folke/trouble.nvim", dependencies = { "nvim-tree/nvim-web-devicons" }, config = function()
      require("trouble").setup({})
      map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics list" })
    end
  },

  -- Treesitter (syntax highlighting/indent)
{
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup({
      ensure_installed = { "python", "java", "go", "lua", "json", "yaml", "bash", "markdown" },
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
},

  -- LSP + Mason
  { "williamboman/mason.nvim", config = function()
      require("mason").setup({})
    end
  },
  { "williamboman/mason-lspconfig.nvim" },
  { "neovim/nvim-lspconfig" },

  -- Completion stack
  { "hrsh7th/nvim-cmp", event = "InsertEnter" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "L3MON4D3/LuaSnip", version = "v2.*" },
  { "saadparwaiz1/cmp_luasnip" },

  -- Formatting (format on save)
  { "stevearc/conform.nvim", opts = {} },

  -- Java (jdtls)
  { "mfussenegger/nvim-jdtls", ft = "java" },

}, {
  checker = { enabled = true },
})

------------------------------------------------------------
-- LSP + Completion Setup
------------------------------------------------------------
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
  },
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Common LSP keymaps on attach
local function on_attach(_, bufnr)
  local opts = { buffer = bufnr }

  map("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
  map("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "References" }))
  map("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Implementation" }))
  map("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover" }))
  map("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))
  map("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
  map("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, vim.tbl_extend("force", opts, { desc = "Format (LSP)" }))
end

-- Mason LSP install list
require("mason-lspconfig").setup({
  ensure_installed = {
    "pyright",     -- Python
    "gopls",       -- Go
    "jdtls",       -- Java (we'll configure via nvim-jdtls hook)
  },
})
-- Configure servers (Neovim 0.11+)
vim.lsp.config("pyright", {
  capabilities = capabilities,
  on_attach = on_attach,
})

vim.lsp.config("gopls", {
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    gopls = {
      analyses = { unusedparams = true, shadow = true },
      staticcheck = true,
      gofumpt = true,
    },
  },
})

-- Enable servers (auto-attach based on filetype/root detection)
vim.lsp.enable({ "pyright", "gopls" })
------------------------------------------------------------
-- Formatting (Conform) + format on save
------------------------------------------------------------
local conform = require("conform")

conform.setup({
  formatters_by_ft = {
    python = { "black", "isort" }, -- order matters; isort then black also OK depending on taste
    go = { "gofmt", "goimports" },
    java = { "google-java-format" },
    lua = { "stylua" },
    json = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
  },
})

-- Format on save
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(args)
    conform.format({ bufnr = args.buf, lsp_fallback = true, quiet = true })
  end,
})

------------------------------------------------------------
-- Java: jdtls integration (per-project workspace)
------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    local jdtls = require("jdtls")

    local home = vim.env.HOME
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
    local workspace_dir = home .. "/.local/share/nvim/jdtls-workspace/" .. project_name

    -- jdtls installed by mason:
    local mason_registry = require("mason-registry")
    local jdtls_pkg = mason_registry.get_package("jdtls")
    local jdtls_path = jdtls_pkg:get_install_path()

    local config = {
      cmd = { jdtls_path .. "/bin/jdtls", "-data", workspace_dir },
      root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        -- Java niceties
        map("n", "<leader>jo", jdtls.organize_imports, { buffer = bufnr, desc = "Java: Organize imports" })
      end,
      settings = {
        java = {
          format = {
            settings = {
              url = "", -- You can point this at an Eclipse formatter XML if you want later
            },
          },
        },
      },
    }

    jdtls.start_or_attach(config)
  end,
})

------------------------------------------------------------
-- Mason tools (formatters) installer hint
-- After opening nvim, run :Mason and install:
-- black, isort, goimports, google-java-format, stylua, prettier
------------------------------------------------------------
