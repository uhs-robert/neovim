-- lua/plugins/linter.lua

return {
  {
    "mason-org/mason.nvim",
    -- Format with the system binaries so output matches repo checks that run them
    opts = function(_, opts)
      local system_formatters = { shfmt = true, stylua = true }
      opts.ensure_installed = vim.tbl_filter(function(tool)
        return not system_formatters[tool]
      end, opts.ensure_installed or {})
    end,
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters = {
        ["markdownlint-cli2"] = {
          args = { "--config", vim.fn.expand("$HOME/.markdownlint.yaml"), "-" },
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        ["markdownlint-cli2"] = {
          args = { "--config", vim.fn.expand("$HOME/.markdownlint.yaml"), "--fix", "$FILENAME" },
        },
      },
    },
  },
}
