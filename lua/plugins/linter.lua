-- lua/plugins/linter.lua

return {
  {
    "mason-org/mason.nvim",
    -- Format with the system shfmt so output matches repo checks that run it
    opts = function(_, opts)
      opts.ensure_installed = vim.tbl_filter(function(tool)
        return tool ~= "shfmt"
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
