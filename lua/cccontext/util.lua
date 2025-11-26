local M = {}
--- Returns the directory path where CCContext stores its context files.
-- @return string: The absolute path to the CCContext context directory.
function M.get_context_dir()
	return vim.fn.stdpath("config") .. "/ccccontext"
end

--- Returns the absolute file path for a given context name.
-- @param name string: The name of the context.
-- @return string|nil: The absolute path to the context file, or nil if not found.
function M.get_context_file_path(name)
	local file_path = M.get_context_dir() .. "/" .. name .. ".json"
	if vim.fn.filereadable(file_path) == 0 then
		vim.notify("CCContext context not found: " .. name, vim.log.levels.ERROR)
		return nil
	end
	return file_path
end

--- Lists all available context names in the CCContext directory.
-- @return table: A list of context names (strings).
function M.get_context_names()
	local context_dir = M.get_context_dir()
	local files = vim.fn.glob(context_dir .. "/*.json", false, true)
	local names = {}
	for _, file in ipairs(files) do
		local name = vim.fn.fnamemodify(file, ":t:r")
		table.insert(names, name)
	end
	return names
end

--- Retrieves lines from the CopilotChat buffer that start with '>'.
-- @return table: A list of context lines (strings) starting with '>'.
function M.get_context_lines()
	local bufnr = require("CopilotChat").chat.bufnr
	if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
		return {}
	end
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	local context = {}
	for _, line in ipairs(lines) do
		if line:match("^>") then
			table.insert(context, line)
		end
	end
	return context
end

return M
