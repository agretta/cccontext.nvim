local M = {}

local util = require("cccontext.util")

--- Saves the current context lines to a JSON file.
-- @param name string: The name to use for the saved context file (without extension).
function M.save_context(name)
	local context = util.get_context_lines()
	if context == nil or #context == 0 then
		vim.notify("No context lines found to save.", vim.log.levels.WARN)
		return
	end
	local json = vim.fn.json_encode(context)
	local config_dir = util.get_context_dir()
	if vim.fn.isdirectory(config_dir) == 0 then
		vim.fn.mkdir(config_dir, "p")
	end
	local file_path = config_dir .. "/" .. name .. ".json"
	vim.fn.writefile({ json }, file_path)
end

--- Loads a context from a JSON file and appends it to the chat window.
-- @param name string|nil: The name of the context file to load (without extension).
function M.load_context(name)
	if not name or #name == 0 then
		local contexts = util.get_context_names()
		if #contexts == 0 then
			vim.notify("No context files found in " .. util.get_context_dir(), vim.log.levels.WARN)
			return
		end
		vim.ui.select(contexts, { prompt = "Select context to load:" }, function(choice)
			if choice then
				M.load_context(choice)
			end
		end)
		return
	end

	local file_path = util.get_context_file_path(name)
	if file_path then
		local ok, context = pcall(vim.fn.json_decode, vim.fn.readfile(file_path))
		if not ok then
			vim.notify("Failed to decode context file: " .. file_path, vim.log.levels.ERROR)
			return
		end
		if context then
			local window = require("CopilotChat").chat
			if window:visible() == false then
				require("CopilotChat").open()
			end
			window:append(table.concat(context, "\n"))
			window:append("\n")
		end
	end
end

--- Deletes a context file by name.
-- @param name string|nil: The name of the context file to delete (without extension).
function M.delete_context(name)
	if not name or #name == 0 then
		local contexts = util.get_context_names()
		if #contexts == 0 then
			vim.notify("No context files found in " .. util.get_context_dir(), vim.log.levels.WARN)
			return
		end
		vim.ui.select(contexts, { prompt = "Select context to delete:" }, function(choice)
			if choice then
				M.delete_context(choice)
			end
		end)
		return
	end

	local file_path = util.get_context_file_path(name)
	if file_path then
		os.remove(file_path)
	end
end

function M.append_to_context()
	local buf = vim.api.nvim_get_current_buf()
	local abs_path = vim.api.nvim_buf_get_name(buf)
	local path = vim.fn.fnamemodify(abs_path, ":.")
	local stat = vim.loop.fs_stat(path)
	if not stat or stat.type ~= "file" then
		return
	end
	local msg = string.format("\n>#file:%s", path)
	require("CopilotChat").chat:append(msg)
end

--- setup function
function M.setup()
	local ok, _ = pcall(require, "CopilotChat")
	if not ok then
		vim.notify("CopilotChat is required for CCContext!", vim.log.levels.ERROR)
		return
	end
end

vim.api.nvim_create_user_command("CCContext", function(opts)
	local args = vim.split(opts.args, " ")
	local cmd = args[1]
	if cmd == "save" then
		M.save_context(args[2])
	elseif cmd == "load" then
		M.load_context(args[2])
	elseif cmd == "delete" then
		M.delete_context(args[2])
	elseif cmd == "append" then
		M.append_to_context()
	else
		print("Usage: CCContext [save|load|delete|append] [name]")
	end
end, { nargs = "*" })

return M
