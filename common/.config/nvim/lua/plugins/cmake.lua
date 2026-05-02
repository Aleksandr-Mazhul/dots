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
            if result and result.code == 0 and result.data then
              local target = result.data[1]

              vim.schedule(function()
                local config = cmake.get_config()
                config.launch_target = target

                vim.notify('Selected: ' .. target, vim.log.levels.INFO, {
                  title = 'CMake',
                })
              end)
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
        '<cmd>CMakeDebug<cr>',
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
