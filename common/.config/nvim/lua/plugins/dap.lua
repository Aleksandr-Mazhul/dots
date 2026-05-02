return {
  {
    'mfussenegger/nvim-dap',
    config = function()
      local dap = require('dap')

      dap.adapters.codelldb = {
        type = 'executable',
        command = vim.fn.expand('~/.local/share/nvim/mason/bin/codelldb'),
      }

      dap.configurations.cpp = {
        {
          name = 'Launch',
          type = 'codelldb',
          request = 'launch',
          program = function()
            local cmake = require('cmake-tools')
            return cmake.get_launch_target_path()
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
        },
      }

      dap.configurations.c = dap.configurations.cpp
    end,
  },
}
