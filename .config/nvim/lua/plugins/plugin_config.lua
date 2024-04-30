return {
  {
    "olimorris/onedarkpro.nvim",
    priority = 1000,
    opts = {
      setup = {
        ["@lsp.type.namespace.cpp"] = {
          guifg = "#e5c07b",
        },
        ["@lsp.typemod.function.defaultLibrary.cpp"] = {
          guifg = "#54B4C2",
        },
        ["@constant.builtin.cpp"] = {
          guifg = "#d19167",
        },
        ["@lsp.typemod.method.defaultLibrary.cpp"] = {
          guifg = "#61afef",
        },
        ["@type.builtin.cpp"] = {
          guifg = "#c678dd",
        },
        ["@type.qualifier.cpp"] = {
          guifg = "#c678dd",
        },
        ["@operator.cpp"] = {
          guifg = "none",
        },
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark",
    },
  },
  {
    "echasnovski/mini.ai",
    enabled = true,
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
        },
        mappings = {
          around = "a",
          inside = "h",

          -- Next/last variants
          around_next = "an",
          inside_next = "hn",
          around_last = "al",
          inside_last = "hl",
        },
      }
    end,
    config = function(_, opts)
      require("mini.ai").setup(opts)
      -- register all text objects with which-key
      require("lazyvim.util").on_load("which-key.nvim", function()
        ---@type table<string, string>
        local i = {
          [" "] = "Whitespace",
          ['"'] = 'Balanced "',
          ["'"] = "Balanced '",
          ["`"] = "Balanced `",
          ["("] = "Balanced (",
          [")"] = "Balanced ) including white-space",
          [">"] = "Balanced > including white-space",
          ["<lt>"] = "Balanced <",
          ["]"] = "Balanced ] including white-space",
          ["["] = "Balanced [",
          ["}"] = "Balanced } including white-space",
          ["{"] = "Balanced {",
          ["?"] = "User Prompt",
          _ = "Underscore",
          a = "Argument",
          b = "Balanced ), ], }",
          c = "Class",
          f = "Function",
          o = "Block, conditional, loop",
          q = "Quote `, \", '",
          t = "Tag",
        }
        local a = vim.deepcopy(i)
        for k, v in pairs(a) do
          a[k] = v:gsub(" including.*", "")
        end

        -- local ic = vim.deepcopy(i)
        -- local ac = vim.deepcopy(a)
        -- for key, name in pairs({ n = "Next", l = "Last" }) do
        --   i[key] = vim.tbl_extend("force", { name = "Inside " .. name .. " textobject" }, ic)
        --   a[key] = vim.tbl_extend("force", { name = "Around " .. name .. " textobject" }, ac)
        -- end
        require("which-key").register({
          mode = { "o", "x" },
          h = i,
          a = a,
        })
      end)
    end,
  },

  {
    "echasnovski/mini.indentscope",
    opts = {
      mappings = {
        -- Textobjects
        object_scope = "hh",
        object_scope_with_border = "ah",

        -- Motions (jump to respective border line; if not present - body line)
        goto_top = "[h",
        goto_bottom = "]h",
      },
    },
  },
  {
    "folke/which-key.nvim",
    enabled = true,
    opts = {
      triggers_blacklist = {
        x = { "i" },
        o = { "i" },
      },
    },
  },
  {
    "echasnovski/mini.comment",
    opts = {
      mappings = {
        comment = "gc",
        comment_line = "gl",
        textobject = "gc",
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

    -- stylua: ignore start
    map("n", "]h", gs.next_hunk, "Next Hunk")
    map("n", "[h", gs.prev_hunk, "Prev Hunk")
    map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
    map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
    map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
    map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
    map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
    map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
    map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
    map("n", "<leader>ghd", gs.diffthis, "Diff This")
    map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
    map({ "o", "x" }, "hh", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
        -- "flake8",
      },
      ui = {
        keymaps = {
          install_package = "h",
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = { "K", false }
      keys[#keys + 1] = { "gh", vim.lsp.buf.hover }
    end,
    opts = {
      servers = {
        -- Ensure mason installs the server
        clangd = {
          keys = {
            { "<A-o>", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
          },
          root_dir = function(fname)
            return require("lspconfig.util").root_pattern(
              "Makefile",
              "configure.ac",
              "configure.in",
              "config.h.in",
              "meson.build",
              "meson_options.txt",
              "build.ninja"
            )(fname) or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(
              fname
            ) or require("lspconfig.util").find_git_ancestor(fname)
          end,
          capabilities = {
            offsetEncoding = { "utf-16" },
          },
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=never",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
        },
        pyright = {},
      },
      setup = {
        clangd = function(_, opts)
          local clangd_ext_opts = require("lazyvim.util").opts("clangd_extensions.nvim")
          require("clangd_extensions").setup(vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = opts }))
          return false
        end,
        on_attach = function(client, bufnr)
          -- your usual configuration — options, keymaps, etc
          -- ...

          local augroup_id =
            vim.api.nvim_create_augroup("FormatModificationsDocumentFormattingGroup", { clear = false })
          vim.api.nvim_clear_autocmds({ group = augroup_id, buffer = bufnr })

          vim.api.nvim_create_autocmd({ "BufWritePre" }, {
            group = augroup_id,
            buffer = bufnr,
            callback = function()
              local lsp_format_modifications = require("lsp-format-modifications")
              lsp_format_modifications.format_modifications(client, bufnr)
            end,
          })
        end,
      },
      inlay_hints = {
        enabled = false,
      },
      diagnostics = {
        virtual_text = false,
        signs = false,
      },
    },
    -- config = function(_, opts)
    -- format on modifications
    -- vim.api.nvim_create_autocmd("LspAttach", function()
    --   local augroup_id = vim.api.nvim_create_augroup("FormatModificationsDocumentFormattingGroup", { clear = false })
    --   vim.api.nvim_clear_autocmds({ group = augroup_id, buffer = bufnr })
    --
    --   vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    --     group = augroup_id,
    --     buffer = bufnr,
    --     callback = function()
    --       local lsp_format_modifications = require("lsp-format-modifications")
    --       lsp_format_modifications.format_modifications(client, bufnr)
    --     end,
    --   })
    -- end)
    -- end,
  },
  {
    "echasnovski/mini.surround",
    ops = {
      mappings = {
        add = "ys",
        delete = "ds",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "cs",
        update_n_lines = "gsn",
      },
    },
  },
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local luasnip = require("luasnip")
      local cmp = require("cmp")

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
            cmp.select_next_item()
          -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
          -- this way you will only jump inside the snippet region
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
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
      })
    end,
  },
  {
    "echasnovski/mini.comment",
    enabled = false,
  },
  {
    "numToStr/Comment.nvim",
    vscode = true,
    opts = {
      ---Add a space b/w comment and the line
      padding = true,
      ---Whether the cursor should stay at its position
      sticky = true,
      ---Lines to be ignored while (un)comment
      ignore = nil,
      ---LHS of toggle mappings in NORMAL mode
      toggler = {
        ---Line-comment toggle keymap
        line = "gl",
        ---Block-comment toggle keymap
        block = "gbc",
      },
      ---LHS of operator-pending mappings in NORMAL and VISUAL mode
      opleader = {
        ---Line-comment keymap
        line = "gl",
        ---Block-comment keymap
        block = "gb",
      },
      ---LHS of extra mappings
      extra = {
        ---Add comment on the line above
        above = "gcO",
        ---Add comment on the line below
        below = "gco",
        ---Add comment at the end of line
        eol = "gcA",
      },
      ---Enable keybindings
      ---NOTE: If given `false` then the plugin won't create any mappings
      mappings = {
        ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
        basic = true,
        ---Extra mapping; `gco`, `gcO`, `gcA`
        extra = true,
      },
      ---Function to call before (un)comment
      pre_hook = nil,
      ---Function to call after (un)comment
      post_hook = nil,
    },
    lazy = false,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        mappings = {
          ["i"] = "none",
          ["h"] = "show_file_details",
        },
      },
    },
  },
  {
    "f-person/git-blame.nvim",
    event = "BufRead",
    config = function()
      -- vim.cmd("highlight default link gitblame SpecialComment")
      vim.g.gitblame_enabled = 0
      vim.g.gitblame_message_template = "      <author>, <date> • <summary>"
      vim.g.gitblame_date_format = "%r"
      vim.g.gitblame_delay = 500
      vim.g.gitblame_use_blame_commit_file_urls = true
    end,
  },
  -- {
  --   "nvim-treesitter/nvim-treesitter",
  --   dependencies = { "HiPhish/nvim-ts-rainbow2" },
  --   opts = function(_, opts)
  --     opts.rainbow = {
  --       enable = true,
  --       query = "rainbow-parens",
  --       strategy = require("ts-rainbow").strategy.global,
  --     }
  --   end,
  -- },
  {
    "sustech-data/wildfire.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("wildfire").setup()
    end,
  },
  { "echasnovski/mini.nvim", version = false },
  {
    "folke/trouble.nvim",
    opts = {
      use_diagnostic_signs = true,
      action_keys = {
        previous = "i",
        next = "k",
      },
    },
  },
  {
    "joechrisellis/lsp-format-modifications.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-telescope/telescope-live-grep-args.nvim" },
    },
    config = function()
      require("telescope").load_extension("live_grep_args")
    end,
    opts = {
      defaults = {
        file_ignore_patterns = { ".git/", ".repo*", "toolchain*", "*.ascii" },
      },
    },
    keys = {
      {
        "<leader>/",
        function()
          -- https://github.com/nvim-telescope/telescope-live-grep-args.nvim
          -- Uses ripgrep args (rg) for live_grep
          -- Command examples:
          -- -i "Data"  # case insensitive
          -- -g "!*.md" # ignore md files
          -- -w # whole word
          -- -e # regex
          -- see 'man rg' for more
          require("telescope").extensions.live_grep_args.live_grep_args() -- see arguments given in extensions config
        end,
        desc = "Live Grep (Args)",
      },
    },
  },
  {
    "akinsho/bufferline.nvim",
    tag = "v4.5.2",
    opts = {
      options = {
        truncate_names = false, -- whether or not tab names should be truncated
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      sections = {
        lualine_c = { { "filename", path = 1 } },
      },
    },
  },
}
