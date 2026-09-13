return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
      end,
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
      local palette_path = vim.fn.expand("~/.config/matugen/generated/nvim.lua")
      local palette_dir = vim.fn.expand("~/.config/matugen/generated")

      local function hex_to_rgb(hex)
        hex = hex:gsub("#", "")
        return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
      end

      local function rgb_to_hex(r, g, b)
        return string.format("#%02x%02x%02x", math.floor(r + 0.5), math.floor(g + 0.5), math.floor(b + 0.5))
      end

      local function rgb_to_hsl(r, g, b)
        r, g, b = r / 255, g / 255, b / 255
        local max, min = math.max(r, g, b), math.min(r, g, b)
        local h, s, l = 0, 0, (max + min) / 2
        if max ~= min then
          local d = max - min
          s = l > 0.5 and d / (2 - max - min) or d / (max + min)
          if max == r then
            h = (g - b) / d + (g < b and 6 or 0)
          elseif max == g then
            h = (b - r) / d + 2
          else
            h = (r - g) / d + 4
          end
          h = h / 6
        end
        return h, s, l
      end

      local function hsl_to_rgb(h, s, l)
        local r, g, b
        if s == 0 then
          r, g, b = l, l, l
        else
          local function hue2rgb(p, q, t)
            if t < 0 then t = t + 1 end
            if t > 1 then t = t - 1 end
            if t < 1 / 6 then return p + (q - p) * 6 * t end
            if t < 1 / 2 then return q end
            if t < 2 / 3 then return p + (q - p) * (2 / 3 - t) * 6 end
            return p
          end
          local q = l < 0.5 and l * (1 + s) or l + s - l * s
          local p = 2 * l - q
          r = hue2rgb(p, q, h + 1 / 3)
          g = hue2rgb(p, q, h)
          b = hue2rgb(p, q, h - 1 / 3)
        end
        return r * 255, g * 255, b * 255
      end

      local function adjust_color(hex, h_offset, s_target, l_target)
        if not hex then return nil end
        local r, g, b = hex_to_rgb(hex)
        local h, s, l = rgb_to_hsl(r, g, b)
        h = (h + (h_offset / 360)) % 1
        if s_target then s = s_target end
        if l_target then l = l_target end
        local nr, ng, nb = hsl_to_rgb(h, s, l)
        return rgb_to_hex(nr, ng, nb)
      end

      local function apply_matugen()
        if vim.fn.filereadable(palette_path) ~= 1 then
          return
        end

        local ok, colors = pcall(dofile, palette_path)
        if not ok or type(colors) ~= "table" then
          return
        end

        vim.g.colors_name = "matugen"

        local base = colors.primary or "#ceca74"
        local syn_keyword = adjust_color(base, 240, 0.65, 0.76)
        local syn_func    = adjust_color(base, 160, 0.65, 0.74)
        local syn_string  = colors.tertiary_fixed or adjust_color(base, 80, 0.55, 0.72)
        local syn_const   = adjust_color(base, 330, 0.75, 0.72)
        local syn_type    = adjust_color(base, 20, 0.70, 0.75)
        local syn_param   = colors.secondary_fixed or adjust_color(base, 50, 0.50, 0.70)
        local syn_prop    = adjust_color(base, 140, 0.50, 0.75)
        local syn_comment = colors.outline or "#949181"
        local syn_op      = colors.outline or "#949181"
        local syn_special = colors.tertiary or adjust_color(base, 100, 0.60, 0.70)

        local groups = {
          Normal = { fg = colors.foreground, bg = "NONE" },
          NormalNC = { fg = colors.foreground, bg = "NONE" },
          NormalSB = { fg = colors.foreground, bg = "NONE" },
          NormalFloat = { fg = colors.foreground, bg = "NONE" },
          FloatBorder = { fg = colors.primary, bg = "NONE" },
          FloatTitle = { fg = colors.on_primary, bg = colors.primary, bold = true },
          Cursor = { fg = colors.on_primary, bg = colors.primary },
          Visual = { fg = colors.on_primary_container, bg = colors.primary_container },
          Search = { fg = colors.on_secondary_container, bg = colors.secondary_container },
          IncSearch = { fg = colors.on_primary, bg = colors.primary },
          CurSearch = { fg = colors.on_primary, bg = colors.primary },
          LineNr = { fg = colors.outline or colors.secondary, bg = "NONE" },
          CursorLineNr = { fg = colors.primary, bg = "NONE", bold = true },
          CursorLine = { bg = colors.surface_variant },
          ColorColumn = { bg = colors.surface_variant },
          SignColumn = { bg = "NONE" },
          FoldColumn = { bg = "NONE" },
          Folded = { fg = syn_comment, bg = "NONE" },
          EndOfBuffer = { fg = "NONE", bg = "NONE" },
          MsgArea = { fg = colors.foreground, bg = "NONE" },
          VertSplit = { fg = colors.surface_variant, bg = "NONE" },
          WinSeparator = { fg = colors.surface_variant, bg = "NONE", bold = true },
          StatusLine = { fg = colors.foreground, bg = colors.surface_variant },
          StatusLineNC = { fg = syn_comment, bg = "NONE" },
          Pmenu = { fg = colors.foreground, bg = colors.surface_variant },
          PmenuSel = { fg = colors.on_primary, bg = colors.primary, bold = true },
          PmenuSbar = { bg = colors.surface_variant },
          PmenuThumb = { bg = colors.primary },
          Directory = { fg = syn_func, bold = true },
          Title = { fg = colors.primary, bold = true },
          Question = { fg = syn_string },
          MoreMsg = { fg = syn_string },
          NonText = { fg = colors.outline_variant or colors.surface_variant, bg = "NONE" },
          Whitespace = { fg = colors.outline_variant or colors.surface_variant, bg = "NONE" },

          Comment = { fg = syn_comment, italic = true },
          Constant = { fg = syn_const },
          String = { fg = syn_string },
          Character = { fg = syn_string },
          Number = { fg = syn_const },
          Boolean = { fg = syn_const, bold = true },
          Float = { fg = syn_const },
          Identifier = { fg = colors.foreground },
          Function = { fg = syn_func },
          Statement = { fg = syn_keyword, bold = true },
          Conditional = { fg = syn_keyword, bold = true },
          Repeat = { fg = syn_keyword, bold = true },
          Label = { fg = syn_keyword },
          Operator = { fg = syn_op },
          Keyword = { fg = syn_keyword, bold = true },
          Exception = { fg = colors.error, bold = true },
          PreProc = { fg = syn_keyword },
          Include = { fg = syn_keyword },
          Define = { fg = syn_keyword },
          Macro = { fg = syn_func },
          PreCondit = { fg = syn_keyword },
          Type = { fg = syn_type },
          StorageClass = { fg = syn_keyword },
          Structure = { fg = syn_type, bold = true },
          Typedef = { fg = syn_type },
          Special = { fg = syn_special },
          SpecialChar = { fg = syn_special },
          Tag = { fg = syn_func },
          Delimiter = { fg = syn_op },
          SpecialComment = { fg = syn_comment, bold = true, italic = true },
          Debug = { fg = colors.error },
          Underlined = { underline = true },
          Ignore = { fg = colors.surface_variant },
          Error = { fg = colors.error, bold = true },
          ErrorMsg = { fg = colors.error, bold = true },
          WarningMsg = { fg = syn_const, bold = true },
          Todo = { fg = colors.background, bg = colors.primary, bold = true },

          ["@comment"] = { fg = syn_comment, italic = true },
          ["@comment.documentation"] = { fg = syn_comment, italic = true },
          ["@comment.todo"] = { fg = colors.background, bg = colors.primary, bold = true },
          ["@comment.error"] = { fg = colors.error, bold = true },
          ["@comment.warning"] = { fg = syn_const, bold = true },

          ["@keyword"] = { fg = syn_keyword, bold = true },
          ["@keyword.coroutine"] = { fg = syn_keyword, bold = true },
          ["@keyword.function"] = { fg = syn_keyword, bold = true },
          ["@keyword.operator"] = { fg = syn_op, bold = true },
          ["@keyword.import"] = { fg = syn_keyword },
          ["@keyword.type"] = { fg = syn_keyword },
          ["@keyword.modifier"] = { fg = syn_keyword },
          ["@keyword.repeat"] = { fg = syn_keyword, bold = true },
          ["@keyword.return"] = { fg = syn_keyword, bold = true },
          ["@keyword.exception"] = { fg = colors.error, bold = true },
          ["@keyword.conditional"] = { fg = syn_keyword, bold = true },
          ["@keyword.directive"] = { fg = syn_keyword },

          ["@function"] = { fg = syn_func },
          ["@function.builtin"] = { fg = syn_func, bold = true },
          ["@function.call"] = { fg = syn_func },
          ["@function.macro"] = { fg = syn_func },
          ["@function.method"] = { fg = syn_func },
          ["@function.method.call"] = { fg = syn_func },
          ["@method"] = { fg = syn_func },
          ["@method.call"] = { fg = syn_func },

          ["@string"] = { fg = syn_string },
          ["@string.documentation"] = { fg = syn_string },
          ["@string.regex"] = { fg = syn_special },
          ["@string.escape"] = { fg = syn_special, bold = true },
          ["@string.special"] = { fg = syn_special },
          ["@character"] = { fg = syn_string },
          ["@character.special"] = { fg = syn_special },

          ["@number"] = { fg = syn_const },
          ["@number.float"] = { fg = syn_const },
          ["@boolean"] = { fg = syn_const, bold = true },

          ["@type"] = { fg = syn_type },
          ["@type.builtin"] = { fg = syn_type, bold = true },
          ["@type.definition"] = { fg = syn_type },
          ["@type.qualifier"] = { fg = syn_keyword },

          ["@variable"] = { fg = colors.foreground },
          ["@variable.builtin"] = { fg = syn_special, italic = true },
          ["@variable.parameter"] = { fg = syn_param },
          ["@variable.member"] = { fg = syn_prop },

          ["@constant"] = { fg = syn_const },
          ["@constant.builtin"] = { fg = syn_const, bold = true },
          ["@constant.macro"] = { fg = syn_const },

          ["@property"] = { fg = syn_prop },
          ["@field"] = { fg = syn_prop },

          ["@operator"] = { fg = syn_op },
          ["@punctuation.delimiter"] = { fg = syn_op },
          ["@punctuation.bracket"] = { fg = colors.foreground },
          ["@punctuation.special"] = { fg = syn_special },

          ["@tag"] = { fg = syn_keyword },
          ["@tag.attribute"] = { fg = syn_prop },
          ["@tag.delimiter"] = { fg = syn_op },

          ["@markup.heading"] = { fg = colors.primary, bold = true },
          ["@markup.strong"] = { bold = true },
          ["@markup.italic"] = { italic = true },
          ["@markup.link"] = { fg = syn_func, underline = true },
          ["@markup.link.url"] = { fg = syn_string, underline = true },
          ["@markup.raw"] = { fg = syn_string },
          ["@markup.list"] = { fg = syn_keyword },

          ["@lsp.type.class"] = { fg = syn_type },
          ["@lsp.type.decorator"] = { fg = syn_func },
          ["@lsp.type.enum"] = { fg = syn_type },
          ["@lsp.type.enumMember"] = { fg = syn_const },
          ["@lsp.type.function"] = { fg = syn_func },
          ["@lsp.type.interface"] = { fg = syn_type },
          ["@lsp.type.macro"] = { fg = syn_func },
          ["@lsp.type.method"] = { fg = syn_func },
          ["@lsp.type.namespace"] = { fg = syn_type },
          ["@lsp.type.parameter"] = { fg = syn_param },
          ["@lsp.type.property"] = { fg = syn_prop },
          ["@lsp.type.struct"] = { fg = syn_type },
          ["@lsp.type.type"] = { fg = syn_type },
          ["@lsp.type.typeParameter"] = { fg = syn_type },
          ["@lsp.type.variable"] = { fg = colors.foreground },
          ["@lsp.type.keyword"] = { fg = syn_keyword, bold = true },
          ["@lsp.type.comment"] = { fg = syn_comment, italic = true },
          ["@lsp.type.string"] = { fg = syn_string },
          ["@lsp.type.number"] = { fg = syn_const },

          DiagnosticError = { fg = colors.error },
          DiagnosticWarn = { fg = syn_const },
          DiagnosticInfo = { fg = syn_func },
          DiagnosticHint = { fg = syn_string },
          DiagnosticUnderlineError = { undercurl = true, sp = colors.error },
          DiagnosticUnderlineWarn = { undercurl = true, sp = syn_const },
          DiagnosticUnderlineInfo = { undercurl = true, sp = syn_func },
          DiagnosticUnderlineHint = { undercurl = true, sp = syn_string },

          GitSignsAdd = { fg = syn_string, bg = "NONE" },
          GitSignsChange = { fg = syn_const, bg = "NONE" },
          GitSignsDelete = { fg = colors.error, bg = "NONE" },

          SnacksIndent = { fg = colors.surface_variant, bg = "NONE" },
          SnacksIndentScope = { fg = colors.primary, bg = "NONE" },
          SnacksPicker = { fg = colors.foreground, bg = "NONE" },
          SnacksPickerBorder = { fg = colors.primary, bg = "NONE" },
          SnacksPickerList = { bg = "NONE" },
          SnacksPickerBox = { bg = "NONE" },
          SnacksPickerInput = { bg = "NONE" },
          SnacksNormal = { bg = "NONE" },
          SnacksBackdrop = { bg = "NONE" },
        }

        for group, hl in pairs(groups) do
          vim.api.nvim_set_hl(0, group, hl)
        end
      end

      apply_matugen()

      vim.api.nvim_create_autocmd("VimEnter", {
        callback = apply_matugen,
      })

      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          if vim.g.colors_name == "matugen" or vim.g.colors_name == "default" then
            apply_matugen()
          end
        end,
      })

      vim.api.nvim_create_autocmd("Signal", {
        pattern = "SIGUSR1",
        callback = apply_matugen,
      })

      local uv = vim.uv or vim.loop
      if uv and uv.new_fs_event then
        local watcher = uv.new_fs_event()
        local debounce_timer = uv.new_timer()
        _G.__matugen_watcher = watcher
        _G.__matugen_debounce = debounce_timer

        if watcher and debounce_timer and vim.fn.isdirectory(palette_dir) == 1 then
          pcall(function()
            watcher:start(palette_dir, {}, function(err, filename)
              if not err and (filename == "nvim.lua" or filename == nil or filename == "") then
                debounce_timer:stop()
                debounce_timer:start(50, 0, function()
                  vim.schedule(function()
                    apply_matugen()
                  end)
                end)
              end
            end)
          end)
        end
      end
    end,
  },
}
