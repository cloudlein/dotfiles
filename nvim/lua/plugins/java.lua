local function populate_java_template(buf)
  buf = buf or vim.api.nvim_get_current_buf()
  if not vim.api.nvim_buf_is_valid(buf) or vim.b[buf].java_template_applied then
    return
  end

  local filepath = vim.api.nvim_buf_get_name(buf):gsub("\\", "/")
  if filepath == "" then
    return
  end

  local dir, filename, ext = filepath:match("^(.*)/([^/]+)%.([%w]+)$")
  if not dir or not filename or (ext ~= "java" and ext ~= "kt") then
    return
  end

  -- Check if buffer is completely empty
  local line_count = vim.api.nvim_buf_line_count(buf)
  if line_count > 1 then
    return
  end
  local first_line = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] or ""
  if first_line:match("%S") then
    return
  end

  vim.b[buf].java_template_applied = true

  -- Determine package path relative to standard source roots
  local pkg_path = dir:match("/src/[^/]+/java/(.+)$")
    or dir:match("/src/[^/]+/kotlin/(.+)$")
    or dir:match("/src/java/(.+)$")
    or dir:match("/src/kotlin/(.+)$")

  if not pkg_path and (dir:match("/src/[^/]+/java$") or dir:match("/src/[^/]+/kotlin$") or dir:match("/src/java$") or dir:match("/src/kotlin$")) then
    pkg_path = nil
  elseif not pkg_path then
    pkg_path = dir:match("/src/(.+)$")
  end

  local lines = {}
  if pkg_path then
    local pkg = pkg_path:gsub("/", ".")
    if ext == "java" then
      table.insert(lines, string.format("package %s;", pkg))
    else
      table.insert(lines, string.format("package %s", pkg))
    end
    table.insert(lines, "")
  end

  if ext == "java" then
    table.insert(lines, string.format("public class %s {", filename))
    table.insert(lines, "    ")
    table.insert(lines, "}")
  else
    table.insert(lines, string.format("class %s {", filename))
    table.insert(lines, "    ")
    table.insert(lines, "}")
  end

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- Place cursor inside class body
  vim.schedule(function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == buf then
        pcall(vim.api.nvim_win_set_cursor, win, { #lines - 1, 4 })
        break
      end
    end
  end)
end

return {
  -- Java Language Server (nvim-jdtls) customization
  {
    "mfussenegger/nvim-jdtls",
    init = function()
      local augroup = vim.api.nvim_create_augroup("java_auto_package", { clear = true })
      vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost", "BufEnter" }, {
        group = augroup,
        pattern = { "*.java", "*.kt" },
        callback = function(args)
          populate_java_template(args.buf)
        end,
      })
    end,
    opts = function(_, opts)
      -- Find lombok jar in mason
      local lombok_jar = vim.fn.expand("~/.local/share/nvim/mason/packages/jdtls/lombok.jar")
      if vim.fn.filereadable(lombok_jar) ~= 1 then
        local found = vim.fn.glob("$MASON/share/jdtls/lombok.jar", false, true)
        if found and #found > 0 then
          lombok_jar = found[1]
        end
      end

      local prev_full_cmd = opts.full_cmd
      opts.full_cmd = function(o)
        local cmd = prev_full_cmd(o)
        if lombok_jar and vim.fn.filereadable(lombok_jar) == 1 then
          table.insert(cmd, string.format("--jvm-arg=-javaagent:%s", lombok_jar))
        end
        return cmd
      end

      -- Rich completion & code intelligence settings for Spring Boot, Quarkus, Standard Java
      opts.settings = vim.tbl_deep_extend("force", opts.settings or {}, {
        java = {
          signatureHelp = { enabled = true },
          contentProvider = { preferred = "fernflower" },
          completion = {
            favoriteStaticMembers = {
              "org.junit.jupiter.api.Assertions.*",
              "org.mockito.Mockito.*",
              "org.assertj.core.api.Assertions.*",
              "org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*",
              "org.springframework.test.web.servlet.result.MockMvcResultMatchers.*",
              "io.restassured.RestAssured.*",
              "java.util.Objects.requireNonNull",
              "java.util.Objects.requireNonNullElse",
            },
            filteredTypes = {
              "com.sun.*",
              "io.micrometer.shaded.*",
              "java.awt.*",
              "jdk.*",
              "sun.*",
            },
            importOrder = {
              "java",
              "javax",
              "jakarta",
              "org",
              "com",
            },
          },
          sources = {
            organizeImports = {
              starThreshold = 9999,
              staticStarThreshold = 9999,
            },
          },
          codeGeneration = {
            toString = {
              template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
            },
            useBlocks = true,
          },
          configuration = {
            updateBuildConfiguration = "automatic",
          },
          eclipse = {
            downloadSources = true,
          },
          maven = {
            downloadSources = true,
          },
          implementationsCodeLens = {
            enabled = true,
          },
          referencesCodeLens = {
            enabled = true,
          },
          inlayHints = {
            parameterNames = {
              enabled = "all",
            },
          },
        },
      })
      return opts
    end,
  },

  -- Ensure Treesitter parsers for Java / Kotlin / Backend
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "java",
        "kotlin",
        "properties",
        "yaml",
        "xml",
        "sql",
        "dockerfile",
      })
    end,
  },
}
