return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "default",
    },
  },

  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      return opts
    end,
  },

  {
    "LazyVim/LazyVim",
    init = function()
      local palette = vim.fn.expand("~/.config/matugen/generated/nvim.lua")

      local function apply_matugen()
        if vim.fn.filereadable(palette) == 1 then
          local ok, colors = pcall(dofile, palette)

          if not ok then
            return
          end

          vim.api.nvim_set_hl(0, "Normal", {
            fg = colors.foreground,
            bg = colors.background,
          })

          vim.api.nvim_set_hl(0, "NormalFloat", {
            fg = colors.foreground,
            bg = colors.surface_variant,
          })

          vim.api.nvim_set_hl(0, "FloatBorder", {
            fg = colors.primary,
            bg = colors.surface_variant,
          })

          vim.api.nvim_set_hl(0, "Cursor", {
            fg = colors.on_primary,
            bg = colors.primary,
          })

          vim.api.nvim_set_hl(0, "Visual", {
            fg = colors.on_primary_container,
            bg = colors.primary_container,
          })

          vim.api.nvim_set_hl(0, "Search", {
            fg = colors.on_secondary_container,
            bg = colors.secondary_container,
          })

          vim.api.nvim_set_hl(0, "IncSearch", {
            fg = colors.on_primary,
            bg = colors.primary,
          })

          vim.api.nvim_set_hl(0, "LineNr", {
            fg = colors.secondary,
            bg = colors.background,
          })

          vim.api.nvim_set_hl(0, "CursorLineNr", {
            fg = colors.primary,
            bg = colors.background,
            bold = true,
          })

          vim.api.nvim_set_hl(0, "StatusLine", {
            fg = colors.on_surface,
            bg = colors.surface_variant,
          })

          vim.api.nvim_set_hl(0, "Directory", {
            fg = colors.primary,
          })

          vim.api.nvim_set_hl(0, "ErrorMsg", {
            fg = colors.error,
          })

          vim.api.nvim_set_hl(0, "DiagnosticError", {
            fg = colors.error,
          })

          vim.api.nvim_set_hl(0, "DiagnosticWarn", {
            fg = colors.tertiary,
          })

          vim.api.nvim_set_hl(0, "DiagnosticInfo", {
            fg = colors.primary,
          })

          vim.api.nvim_set_hl(0, "DiagnosticHint", {
            fg = colors.secondary,
          })
        end
      end

      vim.api.nvim_create_autocmd("VimEnter", {
        callback = apply_matugen,
      })

      vim.api.nvim_create_autocmd("Signal", {
        pattern = "SIGUSR1",
        callback = apply_matugen,
      })
    end,
  },
}
