return {
  {
    "okuuva/auto-save.nvim",
    event = { "InsertLeave", "TextChanged" },
    opts = {
      enabled = true,
      trigger_events = {
        immediate_save = { "BufLeave", "FocusLost" },
        defer_save = { "InsertLeave", "TextChanged" },
        cancel_deferred_save = { "InsertEnter" },
      },
      condition = function(buf)
        local fn = vim.fn
        local utils = require("auto-save.utils.data")

        if
          fn.getbufvar(buf, "&modifiable") == 1
          and utils.not_in(fn.getbufvar(buf, "&filetype"), {
            "gitcommit",
            "gitrebase",
          })
        then
          return true
        end

        return false
      end,
      write_all_buffers = false,
      noautocmd = false,
      lockmarks = false,
      debounce_delay = 1000,
      callbacks = {
        enabling = function()
          vim.notify("AutoSave enabled", vim.log.levels.INFO, { title = "AutoSave" })
        end,
        disabling = function()
          vim.notify("AutoSave disabled", vim.log.levels.WARN, { title = "AutoSave" })
        end,
      },
    },
    keys = {
      {
        "<leader>as",
        function()
          require("auto-save").toggle()
        end,
        desc = "Toggle AutoSave",
      },
    },
  },
}
