return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
  },
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            hidden = true,    -- tampilkan dotfiles (.env, .gitignore, dll)
            ignored = true,   -- tampilkan file yang ada di .gitignore
            no_ignore = true, -- bypass fd/ripgrep ignore rules (penting untuk .env)
          },
        },
      },
    },
  },
}
