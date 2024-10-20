--[[
     ████                       ████   ███                         ████                      
    ░░███                      ░░███  ░░░                         ░░███                      
     ░███  █████ ████  ██████   ░███  ████  ████████    ██████     ░███  █████ ████  ██████  
     ░███ ░░███ ░███  ░░░░░███  ░███ ░░███ ░░███░░███  ███░░███    ░███ ░░███ ░███  ░░░░░███ 
     ░███  ░███ ░███   ███████  ░███  ░███  ░███ ░███ ░███████     ░███  ░███ ░███   ███████ 
     ░███  ░███ ░███  ███░░███  ░███  ░███  ░███ ░███ ░███░░░      ░███  ░███ ░███  ███░░███ 
     █████ ░░████████░░████████ █████ █████ ████ █████░░██████  ██ █████ ░░████████░░████████
    ░░░░░   ░░░░░░░░  ░░░░░░░░ ░░░░░ ░░░░░ ░░░░ ░░░░░  ░░░░░░  ░░ ░░░░░   ░░░░░░░░  ░░░░░░░░ 
--]]

local returnValue = {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  options = function(_, opts)
    table.insert(opts.theme, "catppuccin")
  end,
}

return returnValue
