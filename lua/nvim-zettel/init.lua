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
    local pos = vim.api.nvim_win_get_cursor(0)
    local notePath = NoteLocalPath(noteName)
    local newlabel = "[" .. noteName .. "](./" .. notePath .. ")"
    vim.api.nvim_buf_set_lines(0, pos[1], pos[1], false, {newlabel})
    vim.api.nvim_command("e " .. notePath)
end

return {
    NewZettel = NewZettel,
    RelatedZettel = RelatedZettel
}
