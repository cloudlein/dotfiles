return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        qmlls = {
          cmd = {
            "/usr/bin/qmlls6",
          },

          filetypes = {
            "qml",
            "qmljs",
          },

          root_dir = function(bufnr, on_dir)
            local fname = vim.api.nvim_buf_get_name(bufnr)

            local root = vim.fs.root(fname, {
              ".qmlls.ini",
              ".git",
              "qmldir",
            })

            on_dir(root or vim.fn.getcwd())
          end,
        },
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "qmljs",
      })
    end,
  },
}
