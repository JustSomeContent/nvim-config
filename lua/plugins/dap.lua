-- ~/.config/nvim/lua/plugons/dap.lua

return {
  -- nvim-dap: Debug Adapter Protocol client implementation
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
      "jay-babu/mason-nvim-dap.nvim",
    },
    config = function ()
      -- Basic configuration for nvim-dap

      -- Setup mason-nvim-dap
      require('mason-nvim-dap').setup({
        automatic_installation = true,
        ensure_installed = {
          'java-debug-adapter'
        }
      })

      -- Load DAP configuration
      require('dap-config')

      -- Set keybindings for DAP
      local dap = require('dap')
      vim.fn.sign_define('DapBreakpoint', { text='●', texthl='', linehl='', numhl='' })

      -- Keybindings
      local keymap = vim.api.nvim_set_keymap
      local opts = function(desc)
        return { noremap = true, silent = true, desc = desc }
      end
      keymap('n', '<F5>', '<Cmd>lua require("dap").continue()<CR>', opts("DAP continue/start"))
      keymap('n', '<F10>', '<Cmd>lua require("dap").step_over()<CR>', opts("DAP step over"))
      keymap('n', '<F11>', '<Cmd>lua require("dap").step_into()<CR>', opts("DAP step into"))
      keymap('n', '<F12>', '<Cmd>lua require("dap").step_out()<CR>', opts("DAP step out"))
      keymap('n', '<Leader>b', '<Cmd>lua require("dap").toggle_breakpoint()<CR>', opts("DAP toggle breakpoint"))
    end,
  },

  -- nvim-dap-ui: UI for nvim-dap
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
    config = function ()
      require('dapui').setup()
    end,
  },

  -- nvim-dap-virtual-text: Show virtual text for DAP
  {
    'theHamsta/nvim-dap-virtual-text',
    dependencies = { 'mfussenegger/nvim-dap' },
    config = function ()
      require('nvim-dap-virtual-text').setup({})
    end,
  },
}
