return {
  {
    'Civitasv/cmake-tools.nvim',
    cmd = {
      'CMakeGenerate',
      'CMakeBuild',
      'CMakeRun',
      'CMakeDebug',
      'CMakeSelectBuildTarget',
      'CMakeSelectLaunchTarget',
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    opts = {
      cmake_build_directory = 'build',
      cmake_generate_options = { '-G', 'Ninja' },
      cmake_soft_link_compile_commands = true,
      cmake_compile_commands_from_lsp = true,
      cmake_notifications = true,

      cmake_runner = {
        name = 'toggleterm',
        default_opts = {
          toggleterm = {
            direction = 'horizontal',
            close_on_exit = false,
            auto_scroll = true,
          },
        },
      },
    },
    keys = {
      {
        '<leader>ms',
        function()
          local cmake = require('cmake-tools')

          cmake.select_build_target(true, function(result)
            if not (result and result.code == 0 and result.data) then
              return
            end

            local build_target = result.data[1]
            local launch_targets = cmake.get_launch_targets()

            if not launch_targets then
              return
            end

            for _, target in ipairs(launch_targets) do
              if target.name == build_target then
                local config = cmake.get_config()
                config.launch_target = target

                vim.schedule(function()
                  vim.notify('Selected: ' .. build_target, vim.log.levels.INFO, {
                    title = 'CMake',
                  })
                end)

                return
              end
            end
          end)
        end,
        desc = 'Select Project',
      },

      {
        '<leader>rb',
        '<cmd>CMakeBuild<cr>',
        desc = 'Build',
      },

      {
        '<leader>rr',
        '<cmd>CMakeRun<cr>',
        desc = 'Run',
      },

      {
        '<leader>rd',
        function()
          local dap = require('dap')

          dap.terminate()

          vim.defer_fn(function()
            dap.continue()
          end, 100)
        end,
        desc = 'Debug',
      },

      {
        '<leader>mc',
        function()
          vim.fn.jobstart('cmake-sync', {
            stdout_buffered = true,
            stderr_buffered = true,

            on_stdout = function(_, data)
              if not data then
                return
              end

              local msg = table.concat(data, '\n'):gsub('\n+$', '')
              if msg ~= '' then
                vim.schedule(function()
                  vim.notify(msg, vim.log.levels.INFO, {
                    title = 'CMake',
                  })
                end)
              end
            end,

            on_stderr = function(_, data)
              if not data then
                return
              end

              local msg = table.concat(data, '\n'):gsub('\n+$', '')
              if msg ~= '' then
                vim.schedule(function()
                  vim.notify(msg, vim.log.levels.ERROR, {
                    title = 'CMake',
                  })
                end)
              end
            end,
          })
        end,
        desc = 'Sync CMake',
      },
    },
  },
}
