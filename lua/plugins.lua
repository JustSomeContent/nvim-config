-- ~/.config/nvim/lua/plugins.lua

local lazy = require('lazy')  -- Import lazy.nvim
local plugin_dir = vim.fn.stdpath('config') .. '/lua/plugins'

-- Function to check if a file contains "@Disabled"
local function is_plugin_disabled(file_path)
    local file = io.open(file_path, "r")
    if file then
        local first_line = file:read("*line")
        file:close()
        -- Check for the "@Disabled" tag in the first line
        return first_line and first_line:find("@Disabled") ~= nil
    end
    return false
end

-- Collect plugins with "@Disabled" check
local function collect_plugins()
    local plugins = {}

    for _, file in ipairs(vim.fn.readdir(plugin_dir)) do
        local plugin_file_path = plugin_dir .. '/' .. file
        if not is_plugin_disabled(plugin_file_path) then
            local plugin_name = file:gsub("%.lua$", "")  -- Remove .lua extension
            local plugin_config = require("plugins." .. plugin_name)
            table.insert(plugins, plugin_config)
        else
            -- print("Plugin disabled: " .. file)  -- Optional debug message
        end
    end

    return plugins
end

-- Return the collected plugins for lazy.nvim setup
return collect_plugins()
