local has_telescope, telescope = pcall(require, "telescope")

if not has_telescope then
    error(
        "This requires telescope.nvim"
    )
end


local function GetZettelDir()
    return os.getenv("ZETTELKASTENDIR")
end


local function GetDateString()
    return os.date("%Y%m%d%H%M")
end


local function NoteLocalPath(noteName)
    return GetDateString() .. "-" .. noteName .. ".md"
end


local function NoteToPath(noteName)
    return GetZettelDir() .. "/" .. NoteLocalPath(noteName)
end


local function NewZettel(noteName)
    local newnotepath = NoteToPath(noteName)
    vim.api.nvim_command("e " .. newnotepath)
end

local function RelatedZettel(noteName)
    local notePath = NoteLocalPath(noteName)
    local newlabel = "[" .. noteName .. "](./" .. notePath .. ")"
    vim.api.nvim_paste(newlabel, true, -1)
    vim.api.nvim_command("e " .. notePath)
end


local function getLocalPath(path)
    return path:match("[^/]*.$")
end

local function localPathToName(localPath)
    local withoutdate, _ = string.gsub(localPath, "^%d+-", "", 1)
    local withoutmd, _ = string.gsub(withoutdate, "%.md$", "", 1)
    return withoutmd
end

local function PasteLink()
    -- took a lot from here: https://gitlab.com/thlamb/telescope-zettel.nvim/-/blob/main/lua/telescope/_extensions/zettel.lua
    return function(prompt_bufnr)
        local entry = require("telescope.actions.state").get_selected_entry()
        require("telescope.actions").close(prompt_bufnr)
        local entryPath = entry.path:gsub("%/./", "/") -- Clean path in grep mode
        local localPath = getLocalPath(entryPath)
        local noteName = localPathToName(localPath)
        local link = "[" .. noteName .. "](./" .. localPath .. ")"
        vim.api.nvim_paste(link, true, -1)
    end
end

local function LinkExistingZettel(opts)
    opts = opts or {}
    opts.attach_mappings = function(_, map)
        map("i", "<cr>", PasteLink())
        map("n", "<cr>", PasteLink())
        return true
    end
    require("telescope.builtin").live_grep(opts)
end

return {
    NewZettel = NewZettel,
    RelatedZettel = RelatedZettel,
    LinkExistingZettel = LinkExistingZettel,
}
