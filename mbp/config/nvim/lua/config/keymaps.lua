-- General keymaps (plugin-specific maps live in their plugin specs or LspAttach)

local map = vim.keymap.set
local gopts = { noremap = true, silent = true }

-- File & search convenience
map("n", "<leader>wq", ":q<CR>", vim.tbl_extend("force", gopts, { desc = "Quit window" }))
map("n", "<leader>ww", ":w<CR>", vim.tbl_extend("force", gopts, { desc = "Write buffer" }))
map("n", "<leader><space>", ":nohlsearch<CR>", vim.tbl_extend("force", gopts, { desc = "Clear search highlight" }))
map("n", "gb", "<C-o>", vim.tbl_extend("force", gopts, { desc = "Go back (jump list)" }))
map("n", "gB", "<C-i>", vim.tbl_extend("force", gopts, { desc = "Go forward (jump list)" }))

-- macOS Command shortcuts (GUI / extended-key terminals)
map("n", "<D-a>", "ggVG", { noremap = true, desc = "Select All" })
map("v", "<D-c>", '"+y', { noremap = true, desc = "Copy to system clipboard" })
map("n", "<D-/>", "gcc", { remap = true, desc = "Toggle comment" })
map("v", "<D-/>", "gc", { remap = true, desc = "Toggle comment selection" })

-- Tslime (send to tmux)
map("v", "<leader>cc", "<Plug>SendSelectionToTmux", vim.tbl_extend("force", gopts, { desc = "Send selection to tmux" }))
map("n", "<leader>cc", "<Plug>NormalModeSendToTmux", vim.tbl_extend("force", gopts, { desc = "Send line to tmux" }))
map("n", "<leader>cr", "<Plug>SetTmuxVars", vim.tbl_extend("force", gopts, { desc = "Set tmux target" }))

-- Remove Neovim 0.11+ default gr* LSP maps so buffer-local `gr` fires immediately
for _, lhs in ipairs({ "gra", "gri", "grn", "grr", "grt" }) do
	pcall(vim.keymap.del, "n", lhs)
end
pcall(vim.keymap.del, "x", "gra")

-- Diagnostics & formatting toggle
map("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "gl", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostic loclist" })
map({ "n", "v" }, "<leader>cf", function()
	local ok, conform = pcall(require, "conform")
	if ok then
		conform.format({ async = true, lsp_format = "fallback" })
	else
		vim.lsp.buf.format({ async = true })
	end
end, { desc = "Format buffer / selection" })
map("n", "<leader>uf", function()
	vim.g.disable_autoformat = not vim.g.disable_autoformat
	vim.notify("Format on save: " .. (vim.g.disable_autoformat and "OFF" or "ON"))
end, { desc = "Toggle format on save" })
map("n", "<leader>ua", function()
	vim.g.disable_autosave = not vim.g.disable_autosave
	vim.notify("Auto-save: " .. (vim.g.disable_autosave and "OFF" or "ON"))
end, { desc = "Toggle auto-save" })

-- Close all other listed buffers while preserving layout (:qo / :qo! / :wqo)
local function quit_other_buffers(save, force)
	local current = vim.api.nvim_get_current_buf()
	local ok, bufremove = pcall(require, "mini.bufremove")
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if
			buf ~= current
			and vim.api.nvim_buf_is_valid(buf)
			and vim.bo[buf].buflisted
			and vim.bo[buf].buftype == ""
		then
			if save and vim.bo[buf].modified then
				vim.api.nvim_buf_call(buf, function()
					vim.cmd("silent! write")
				end)
			end
			if ok then
				bufremove.delete(buf, force)
			else
				pcall(vim.api.nvim_buf_delete, buf, { force = force })
			end
		end
	end
end

vim.api.nvim_create_user_command("QuitOther", function(opts)
	quit_other_buffers(false, opts.bang)
end, { bang = true, desc = "Close all other buffers (keep layout)" })

vim.api.nvim_create_user_command("WQuitOther", function(opts)
	quit_other_buffers(true, opts.bang)
end, { bang = true, desc = "Save and close all other buffers (keep layout)" })

vim.cmd([[cnoreabbrev <expr> quitother getcmdtype() == ":" && getcmdline() == "quitother" ? "QuitOther" : "quitother"]])
vim.cmd([[cnoreabbrev <expr> qo getcmdtype() == ":" && getcmdline() == "qo" ? "QuitOther" : "qo"]])
vim.cmd(
	[[cnoreabbrev <expr> wquitother getcmdtype() == ":" && getcmdline() == "wquitother" ? "WQuitOther" : "wquitother"]]
)
vim.cmd([[cnoreabbrev <expr> wqo getcmdtype() == ":" && getcmdline() == "wqo" ? "WQuitOther" : "wqo"]])

-- Fugitive git command shortcuts
for lhs, rhs in pairs({
	gftch = "G fetch",
	gcheck = "G checkout",
	gpwl = "G push --force-with-lease",
	grmain = "G rebase main",
	gp = "G push",
	gpup = "G push --set-upstream origin HEAD",
	gcom = "G commit -m",
	gsw = "G switch -c",
	gad = "G add",
	gstat = "G",
	gpl = "G pull",
	grest = "G restore",
	grestH = "G reset --hard @{u}",
	gamen = "G commit --amend",
}) do
	vim.cmd(
		string.format(
			[[cnoreabbrev <expr> %s getcmdtype() == ":" && getcmdline() == "%s" ? "%s" : "%s"]],
			lhs,
			lhs,
			rhs,
			lhs
		)
	)
end

-- CMake / CTest command shortcut
vim.cmd(
	[[cnoreabbrev <expr> ctest getcmdtype() == ":" && getcmdline() == "ctest" ? "CMakeRunTest --output-on-failure" : "ctest"]]
)
