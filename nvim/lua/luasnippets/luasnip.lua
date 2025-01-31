-- luasnip.lua

local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local extras = require("luasnip.extras")
local rep = extras.rep
local fmt = require("luasnip.extras.fmt").fmt
local c = ls.choice_node
local f = ls.function_node
local d = ls.dynamic_node
local sn = ls.snippet_node

------------------------------------------------------------------------------------------------------------------
-- Python snips
------------------------------------------------------------------------------------------------------------------
ls.add_snippets("python", {
    s("mlflow_tempfile", {
        t({
            -- "import tempfile",
            -- "import os",
            -- "import mlflow",
            -- "",
            "# Create a temporary directory",
            "with tempfile.TemporaryDirectory() as temp_dir:",
            "    # Define the file path",
            "    file_path = os.path.join(temp_dir, 'example.txt')",
            "",
            "    # Write to the file",
            "    with open(file_path, 'w') as f:",
            "        f.write('This is a test file.')",
            "",
            "    # Log the file to MLflow",
            "    mlflow.log_artifact(file_path, artifact_path='",
        }),
        i(1, "your/mlflow/path"), -- Placeholder for the MLflow path
        t({
            "')",
            -- "",
            -- "# End of script",
        }),
    }),
})

ls.add_snippets("python", {
    s("rjson", {
        -- t({ "import json", "", "" }),
        t({ "with open(" }), i(1, "path/to/file.json"), t({ ", 'r', encoding='utf-8') as f:", "\t" }),
        t({ "data = json.load(f)", "" }),
        -- t({ "# Now you can use the 'data' dictionary", "" }),
    }),
})

ls.add_snippets("python", {
    s("wjson", {
        -- t({ "import json", "", "" }),
        t({ "with open(" }), i(1, "path/to/file.json"), t({ ", 'w', encoding='utf-8') as f:", "\t" }),
        t({ "json.dump(" }), i(2, "data"), t({ ", f, indent=4)", "" }),
        -- t({ "# The dictionary 'data' is now written to the file", "" }),
    }),
})

ls.add_snippets("python", {
    s("scan_dir", {
        t({
            -- "import os",
            -- "",
            "def scan_dir(path, pattern=None):",
            "\t\"\"\"",
            "\tScans the given directory and its subdirectories for files.",
            "\tOptionally filters files by extension(s) provided in pattern.",
            "\t",
            "\tArgs:",
            "\t\tpath (str): The directory path to scan.",
            "\t\tpattern (str or list of str, optional): File extension(s) to filter by.",
            "\t",
            "\tReturns:",
            "\t\tlist of str: Full paths of files in the directory and subdirectories.",
            "\t\"\"\"",
            "\tfile_paths = []",
            "\tfor root, dirs, files in os.walk(path):",
            "\t\tfor file in files:",
            "\t\t\tif pattern is None or (",
            "\t\t\t\tisinstance(pattern, str) and file.endswith(pattern)) or (",
            "\t\t\t\tisinstance(pattern, list) and any(file.endswith(ext) for ext in pattern)):",
            "\t\t\t\tfile_paths.append(os.path.join(root, file))",
            "\treturn file_paths",
            -- "",
            -- "# Example usage:",
            -- "# files = scan_dir('path/to/directory', pattern=['.py', '.txt'])",
            -- "# print(files)",
        }),
    }),
}
)

ls.add_snippets("python", {
    s("addpath", {
        t({
            "import sys",
            "",
            "sys.path.append(" }), i(1, "path"), t({ ")"
    }),
    }),
}
)

------------------------------------------------------------------------------------------------------------------
-- Examples
------------------------------------------------------------------------------------------------------------------
ls.add_snippets("lua", {
    s("hello", {
        t('print("hello '),
        i(1),
        t(' world")')
    }),

    s("if", {
        t('if '),
        i(1, "true"),
        t(' then '),
        i(2),
        t(' end')
    })
})

vim.keymap.set({ "i", "s" }, "<A-n>", function()
    if ls.choice_active() then
        ls.change_choice(1)
    end
end)

vim.keymap.set({ "i", "s" }, "<A-k>", function()
    if ls.expand_or_jumpable() then
        ls.expand_or_jump()
    end
end, { silent = true })

vim.keymap.set({ "i", "s" }, "<A-j>", function()
    if ls.jumpable(-1) then
        ls.jump(-1)
    end
end, { silent = true })


ls.add_snippets("tex", {
    s("beg", {
        t("\\begin{"), i(1), t("}"),
        t({ "", "\t" }), i(0),
        t({ "", "\\end{" }), rep(1), t("}"),
    })
})

ls.add_snippets("cs", {
    s("logc",
        fmt([[Debug.Log($"<color={}>{}</color>");]],
            {
                c(1, {
                    t("red"),
                    t("green"),
                    t("blue"),
                    t("cyan"),
                    t("magenta")
                }),
                i(2),
            })),
})

ls.add_snippets("typescriptreact", {

    -- 1st version
    s("co", {
        t("position(["),
        f(function()
            local register_data = vim.fn.getreg() .. "";
            if string.match(register_data, "[%d-]+,%s*[%d-]+") then
                return register_data
            else
                print("register does not contain the pattern")
            end
        end),
        t("])"),
    }),

    s("co", {
        d(function()
            local register_data = vim.fn.getreg() .. "";
            if string.match(register_data, "[%d-]+,%s*[%d-]+") then
                return M.sn(nil, {
                    M.t("position([" .. register_data .. "])"),
                })
            else
                print("register does not contain the pattern")
                return M.sn(nil, {})
            end
        end),
        i(1)
    })
})
