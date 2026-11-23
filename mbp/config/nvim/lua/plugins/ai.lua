-- AI assistants: CodeCompanion (v18+ schema pointing to local llama-server) + Tabby

return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim",
    },
    cmd = {
      "CodeCompanion",
      "CodeCompanionChat",
      "CodeCompanionActions",
      "CodeCompanionCmd",
    },
    keys = {
      { "<leader>aa", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "AI Actions" },
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "AI Chat" },
      { "<leader>ai", "<cmd>CodeCompanion<cr>", mode = { "n", "v" }, desc = "AI Inline" },
      { "<leader>ad", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "Add selection to AI Chat" },
    },
    opts = {
      interactions = {
        chat = {
          adapter = "llama_server",
          roles = {
            llm = "Qwen 3.8",
            user = "Me",
          },
        },
        inline = {
          adapter = "llama_server",
        },
        cmd = {
          adapter = "llama_server",
        },
      },
      adapters = {
        http = {
          llama_server = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              name = "llama_server",
              formatted_name = "Qwen 3.8 27B (Stock)",
              env = {
                url = "http://127.0.0.1:8088",
                api_key = "none",
                chat_url = "/v1/chat/completions",
              },
              schema = {
                model = { default = "qwen3.8-stock" },
                num_ctx = { default = 65536 },
              },
            })
          end,
          llama_heretic = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              name = "llama_heretic",
              formatted_name = "Qwen 3.8 27B (Heretic Uncensored)",
              env = {
                url = "http://127.0.0.1:8088",
                api_key = "none",
                chat_url = "/v1/chat/completions",
              },
              schema = {
                model = { default = "qwen3.8-heretic" },
                num_ctx = { default = 65536 },
              },
            })
          end,
          inkling = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              name = "inkling",
              formatted_name = "Inkling 2 Mini (MoE)",
              env = {
                url = "http://127.0.0.1:8088",
                api_key = "none",
                chat_url = "/v1/chat/completions",
              },
              schema = {
                model = { default = "inkling-2-mini" },
                num_ctx = { default = 65536 },
              },
            })
          end,
        },
      },
      display = {
        diff = {
          enabled = true,
          layout = "vertical",
          opts = { "internal", "filler", "closeoff" },
        },
      },
    },
  },

  {
    "TabbyML/vim-tabby",
  },
}
