return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build =
      "make",
    },
    "nvim-lua/popup.nvim",
    "sudormrfbin/cheatsheet.nvim",
    "mbbill/undotree",
    "debugloop/telescope-undo.nvim",
  },
  config = function()
    require("telescope").setup({
      extensions = {
        fzf = {
          fuzzy = true,
          override_genereic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
        undo = {
          side_by_side = true,
          layout_strategy = "vertical",
          layout_config = {
            preview_height = 0.8,
          },
        },
      },
    })
    require("telescope").load_extension("undo")
    require("cheatsheet").setup({
      bundled_cheatsheets = true,
      bundled_plugin_cheatsheets = true,
      include_only_installed_plugins = true,
      telescope_mappings = {
        ["<CR>"] = require("cheatsheet.telescope.actions").select_or_fill_commandline,
        ["<A-CR>"] = require("cheatsheet.telescope.actions").select_or_execute,
        ["<C-Y>"] = require("cheatsheet.telescope.actions").copy_cheat_value,
        ["<C-E>"] = require("cheatsheet.telescope.actions").edit_user_cheatsheet,
      },
    })
    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>fn", function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end)
    vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
    vim.keymap.set("n", "<leader>ft", builtin.git_files, {})
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
    vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
    vim.keymap.set("n", "<leader>fk", builtin.keymaps, {})
    vim.keymap.set("n", "<leader>fd", builtin.diagnostics, {})
    vim.keymap.set("n", "<leader>fs", builtin.grep_string, {})
    vim.keymap.set("n", "<leader>fi", builtin.builtin, {})
    vim.keymap.set("n", "<leader>fo", builtin.pickers, {})
    vim.keymap.set("n", "<leader>fl", builtin.lsp_references, {})
    vim.keymap.set("n", "<leader>u", "<cmd>Telescope undo<cr>")
    vim.keymap.set("n", "<leader>U", "<cmd>UndotreeToggle<cr>")
  end,
}
