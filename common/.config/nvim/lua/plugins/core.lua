return {
  {
    "LazyVim/LazyVim",
    keys = {
      {
        "<leader>ci",
        function()
          vim.cmd("TermExec cmd='initcpp'")
        end,
        desc = "Init C++ project",
      },
    },
  },
}
