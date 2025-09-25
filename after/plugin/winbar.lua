local field_format = {
  name = {
    guifg = '#a0a0a0',
    guibg = '#282828',
  },
  num = {
    guifg = '#968c81',
  },
  modified = {
    guifg = '#d6991d',
  },
  blocks = {
    gui = 'bold',
    guifg = '#070707',
  }
}

local start = vim.tbl_extend('force', { '█▓  ' }, field_format.blocks)
local stop = vim.tbl_extend('force', { ' ▓█' }, field_format.blocks)

return {
  'b0o/incline.nvim',
  enabled = true,
  config = function()
    require('incline').setup({
      render = function(props)
        local bufnum = props.buf
        local buffullname = vim.api.nvim_buf_get_name(props.buf)
        local bufname_t = vim.fn.fnamemodify(buffullname, ':t')
        local bufname = (bufname_t and bufname_t ~= '') and bufname_t or '[No Name]'

        -- optional devicon
        local devicon = { ' ' }
        local success, nvim_web_devicons = pcall(require, 'nvim-web-devicons')
        if success then
          local bufname_r = vim.fn.fnamemodify(buffullname, ':r')
          local bufname_e = vim.fn.fnamemodify(buffullname, ':e')
          local base = (bufname_r and bufname_r ~= '') and bufname_r or bufname
          local ext = (bufname_e and bufname_e ~= '') and bufname_e or vim.fn.fnamemodify(base, ':t')
          local ic, hl = nvim_web_devicons.get_icon(base, ext, { default = true })
          devicon = {
            ic,
            ' ',
            group = hl
          }
        end

        -- buffer name
        local display_bufname = vim.tbl_extend('force', { bufname, ' ' }, field_format.name)

        -- modified indicator
        local modified_icon = {}
        if vim.api.nvim_get_option_value('modified', { buf = props.buf, }) then
          modified_icon = vim.tbl_extend('force', { '● ' }, field_format.modified)
          display_bufname.guifg = field_format.modified.guifg
        end

        -- buffer number
        local display_bufnum = vim.tbl_extend('force', { bufnum, ' ' }, field_format.num)

        -- example: █▓   incline-nvim.lua 13  ▓█
        return {
          start,
          devicon,
          display_bufname,
          modified_icon,
          display_bufnum,
          stop,
        }
      end,
      window = {
        padding = {
          left = 0,
          right = 0,
        },
        margin = {
          horizontal = 0,
          vertical = 1,
        },
        placement = {
          horizontal = 'right',
          vertical = 'top',
        },
      }
    })
  end,
}

