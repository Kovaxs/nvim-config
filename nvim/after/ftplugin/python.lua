local function isempty(s)
    return s == nil or s == ""
end
local function use_if_defined(val, fallback)
    return val ~= nil and val or fallback
end

-- custom python provider
local conda_prefix = os.getenv("CONDA_PYTHON_EXE")
if not isempty(conda_prefix) then
    vim.g.python_host_prog = use_if_defined(vim.g.python_host_prog, conda_prefix)
    vim.g.python3_host_prog = use_if_defined(vim.g.python3_host_prog, conda_prefix)
else
    vim.g.python_host_prog = use_if_defined(vim.g.python_host_prog, "python")
    vim.g.python3_host_prog = use_if_defined(vim.g.python3_host_prog, "python3")
end
