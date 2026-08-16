-- ~/.config/nvim/lua/dap-config.lua

local dap = require('dap')

-- Configure the Java adapter using the adapter provided by Mason
dap.adapters.java = function (callback, config)
  -- Path to the Java Debug Server installed by Mason
  local mason_path = vim.fn.stdpath('data') .. '/mason'
  local java_debug_jar = mason_path .. '/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar'

  local jar_patterns = {
    java_debug_jar
  }

  local jars = {}

  for _, jar_pattern in ipairs(jar_patterns) do 
    for _, jar in ipairs(vim.fn.glob(jar_pattern, true, true)) do 
      if not vim.endswith(jar, 'sources.jar') then
        table.insert(jars, jar)
      end
    end
  end

  if vim.tbl_isempty(jars) then
    vim.notify('Could not find Java Debug Server JAR. Please ensure it is installed.', vim.log.levels.ERROR)
    return
  end

  callback({
    type = 'server',
    host = '127.0.0.1',
    port = 0, -- Let DAP server choose a random port
    executable = {
      command = 'java',
      args = {
        '-jar', 
        jars[1]
      },
    },
  })

end

-- Configure DAP configurations for Kotlin
dap.configurations.kotlin = {
  type = 'java',
  request = 'luanch',
  name = 'Launch Kotlin App',
  mainClass = 'com.dude.MainKt', -- Specify your main class, e.g. 'com.example.MainKt'
  projectName = '', -- Optional: Specify your project name
  cwd = '${workspaceFolder}',
  args = '', -- Optional Program arguments
  vmArgs = '', -- Optional JVM arguments
}
