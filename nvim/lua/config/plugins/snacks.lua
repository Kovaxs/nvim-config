return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		bigfile = { enabled = true },
		dashboard = { enabled = true },
		explorer = { enabled = true },
		indent = { enabled = true },
		input = { enabled = true },
		picker = {
			enabled = true,
			-- Avoid crushing with aerospace windows manager alt-h
			win = {
				input = {
					keys = {
						["<a-a>"] = { "toggle_hidden", mode = { "i", "n" } },
						["<a-h>"] = false, -- Disable the default mapping
					},
				},
				list = {
					keys = {
						["<a-a>"] = "toggle_hidden",
						["<a-h>"] = false, -- Disable the default mapping
					},
				},
			},
			--
			layout = {
				present = "ivy",
				cycle = false,
				-- layout = { position = "bottom" }
			},
			matcher = {
				frecency = true,
			},
			formatters = {
				file = {
					filename_first = true,
					truncate = 80,
				},
			},
			layouts = {
				-- I wanted to modify the ivy layout height and preview pane width,
				-- this is the only way I was able to do it
				-- NOTE: I don't think this is the right way as I'm declaring all the
				-- other values below, if you know a better way, let me know
				--
				-- Then call this layout in the keymaps above
				-- got example from here
				-- https://github.com/folke/snacks.nvim/discussions/468
				ivy = {
					layout = {
						box = "vertical",
						backdrop = false,
						row = -1,
						width = 0,
						height = 0.5,
						border = "top",
						title = " {title} {live} {flags}",
						title_pos = "left",
						{ win = "input", height = 1, border = "bottom" },
						{
							box = "horizontal",
							{ win = "list", border = "none" },
							{ win = "preview", title = "{preview}", width = 0.5, border = "left" },
						},
					},
				},
				-- I wanted to modify the layout width
				--
				vertical = {
					layout = {
						backdrop = false,
						width = 0.8,
						min_width = 80,
						height = 0.8,
						min_height = 30,
						box = "vertical",
						border = "rounded",
						title = "{title} {live} {flags}",
						title_pos = "center",
						{ win = "input", height = 1, border = "bottom" },
						{ win = "list", border = "none" },
						{ win = "preview", title = "{preview}", height = 0.4, border = "top" },
					},
				},
			},
		},
		lazygit = {
			-- theme = {
			--     selectedLineBgColor = { bg = "CursorLine" },
			-- },
			win = {
				-- -- The first option was to use the "dashboard" style, which uses a
				-- -- 0 height and width, see the styles documentation
				-- -- https://github.com/folke/snacks.nvim/blob/main/docs/styles.md
				style = "lazygit",
				-- But I can also explicitly set them, which also works, what the best
				-- way is? Who knows, but it works
				-- width = 0,
				-- height = 0,
			},
		},
		git = { enabled = true },
		notifier = { enabled = true },
		quickfile = { enabled = true },
		scope = { enabled = true },
		scroll = { enabled = true },
		statuscolumn = { enabled = true },
		words = { enabled = true },
	},
}
