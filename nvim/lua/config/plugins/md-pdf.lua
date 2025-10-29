-- return {
-- 	"arminveres/md-pdf.nvim",
-- 	branch = "main", -- you can assume that main is somewhat stable until releases will be made
-- 	lazy = true,
-- 	keys = {
-- 		{
-- 			"<leader>,",
-- 			function()
-- 				require("md-pdf").convert_md_to_pdf()
-- 			end,
-- 			desc = "Markdown preview",
-- 		},
-- 	},
-- 	---@type md-pdf.config
-- 	opts = {},
-- }
return {
	"arminveres/md-pdf.nvim",
	config = function()
		require("md-pdf").setup({
			pdf_engine = "pdflatex",
			preview_cmd = function()
				return "sioyek"
			end,
		})

		vim.keymap.set("n", "<Space>,", function()
			require("md-pdf").convert_md_to_pdf()
		end)
	end,
}
