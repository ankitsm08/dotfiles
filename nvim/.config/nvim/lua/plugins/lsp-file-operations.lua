return {
  {
    "Crysthamus/nvim-file-operations",
    event = "VeryLazy",
    config = function()
      require("nvim-file-operations").setup()
    end,
  },
}
