local paths = require('config_paths')

local function generate_wiki_link(opts)
  if opts.id == nil then
    return string.format("[[%s]]", opts.label)
  elseif opts.label ~= opts.id then
    return string.format("[[%s|%s]]", opts.id, opts.label)
  else
    return string.format("[[%s]]", opts.id)
  end
end

local function generate_note_id(title)
  local suffix = ""
  if title ~= nil then
    suffix = title
  else
    for _ = 1, 4 do
      suffix = suffix .. string.chat(math.random(65, 90))
    end
  end
  return suffix .. "-" .. tostring(os.time())
end

local function generate_frontmatter(note)
  local out = { id = note.id, aliases = note.aliases, tags = note.tags, area = "", project = "" }
  if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
    for k, v in pairs(note.metadata) do
      out[k] = v
    end
  end
  return out
end

local function create_kanban_board()
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

return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  dependencies = { "nvim-lua/plenary.nvim", },
  opts = {
    workspaces = {
      {
        name = "personal",
        path = paths.obsidianVaultPath,
      },
    },
    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },
    disable_frontmatter = true,
    notes_subdir = "UnsortedNotes",
    new_notes_location = "notes_subdir",
    preferred_link_style = "markdown",

    wiki_link_func = generate_wiki_link,
    note_frontmatter_func = generate_frontmatter,
    note_id_func = generate_note_id,
    templates = {
      subdir = "Templates",
      date_format = "%Y-%m-%d-%a",
      time_format = "%H:%M",
      tags = "",
    },

    mappings = {
      -- Toggle check-boxes "obsidian done"
      ["<leader>och"] = {
        action = function()
          return require("obsidian").util.toggle_checkbox()
        end,
        opts = { buffer = true },
      },
    },
  },

}
