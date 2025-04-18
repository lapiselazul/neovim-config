return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
      { "saghen/blink.cmp" },
    },
    opts = {
      servers = {
        lua_ls = {}
      }
    },
    config = function(_, opts)
      local lspconfig = require("lspconfig")
      for server, config in pairs(opts.servers) do
        config.capabilities =
            require("blink.cmp").get_lsp_capabilities(config.capabilities)
        lspconfig[server].setup(config)
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("my.lsp", {}),
        callback = function(args)
          local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
          if not client then
            return
          end

          local bufopts = { noremap = true, silent = true, buffer = args.buf }
          vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, bufopts)

          -- Auto-format ("lint") on save.
          -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
          if not client:supports_method("textDocument/willSaveWaitUntil")
              and client:supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = vim.api.nvim_create_augroup("my.lsp", { clear = false }),
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
              end,
            })
          end
        end,
      })
    end,
  }
}
