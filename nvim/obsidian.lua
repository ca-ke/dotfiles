local paths = require('config_paths')

function create_kanban_board()
  local templatePath = paths.nvimPath .. '/obsidian_templates/kanban_board.txt'
  local vaultPath = paths.obsidianVaultPath

  local file = io.open(templatePath, "r")
  if not file then
    print('Error: Unable to open template file')
    return
  end

  local content = file:read("*a")
  file:close()

  local date = os.date("%Y-%m-%d")
  local filePath = vaultPath .. "/2. Resources/Brag Document/Worklog/" .. date .. ".md"
  local outFile = io.open(filePath, "w")
  if outFile then
    outFile:write(content)
    outFile:close()
    print("Kanban board created successfully for " .. date .. " at " .. filePath)
  else
    print("Error: Failed to create the Kanban board")
  end
end

vim.api.nvim_create_user_command('CreateKanbanBoard', create_kanban_board(), {})
