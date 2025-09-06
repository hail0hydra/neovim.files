
local opts = {noremap=true, silent=true}
local map = vim.api.nvim_set_keymap

-- ============================================================================
-- <leader>gg → Open file:// links (and optionally jump to line)
-- Supports:
--   - [_start](file://./hello.asm#L3)
--   - file://./hello.asm#L3
--   - file://./hello.asm
-- 
-- NOTE:
--   - Use <leader>gg for file links (with or without #L<num>)
--   - Use `gx` (default) for web links like https://google.com
-- ============================================================================

-- Keymap: <leader>gg to jump to file:// link under cursor
map('n', '<leader>gg', '<cmd>lua OpenLocalFileLinkAtLine()<cr>', opts)

-- Function: open file:// link and optionally jump to line number
function OpenLocalFileLinkAtLine()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()
  local url = nil

  -- 📦 Try markdown-style [label](url)
  local s, e, _, link = line:find("%[([^%]]+)%]%((.-)%)")
  if s and e and col >= s and col <= e then
    url = link
  else
    -- 🧠 fallback: expand word under cursor (plain file://)
    url = vim.fn.expand("<cfile>")
  end

  -- 📂 Match file://path#L<num> → open file and jump to line
  local file, lnum = url:match("^file://(.-)#L(%d+)$")
  if file and lnum then
    vim.cmd("e " .. file)
    vim.cmd(lnum)
    return
  end

  -- 📁 Match file://path → just open file
  file = url:match("^file://(.+)$")
  if file then
    vim.cmd("e " .. file)
    return
  end

  -- ❌ If nothing matches, show error
  print("Unrecognized file:// link format: " .. url)
end




-- Export Markdown to PDF using Pandoc + Tectonic and show notification
vim.keymap.set('n', '<F6>', function()
  local filename = vim.fn.expand('%')
  local outfile = vim.fn.expand('%:r') .. '.pdf'
  local cmd = 'pandoc ' .. filename .. ' -o ' .. outfile  .. ' --pdf-engine=xelatex'
  -- local cmd = 'pandoc ' .. filename .. ' -o ' .. outfile  .. ' --pdf-engine=tectonic' -- use this on windows

  vim.fn.jobstart(cmd, {
    on_exit = function(_, code)
      if code == 0 then
        vim.schedule(function()
          vim.notify("✅ PDF exported to " .. outfile, vim.log.levels.INFO, { title = "Markdown Export" })
        end)
      else
        vim.schedule(function()
          vim.notify("❌ PDF export failed!", vim.log.levels.ERROR, { title = "Markdown Export" })
        end)
      end
    end
  })
end, opts)



-- ============================================================================
-- <leader>l → Wrap word under cursor with Markdown link syntax [word](...)
-- ============================================================================

map('n', '<leader>l', '<cmd>lua WrapWordWithMarkdownLink()<cr>', opts)

function WrapWordWithMarkdownLink()
  local word = vim.fn.expand('<cword>')
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()

  -- Find the exact position of the word under cursor
  local start_col, end_col = line:find('%f[%w]' .. word .. '%f[%W]')
  if not start_col then return end

  -- Build the new line: [word]()
  local new_line = line:sub(1, start_col - 1) .. '[' .. word .. ']()' .. line:sub(end_col + 1)
  vim.api.nvim_set_current_line(new_line)

  -- Move cursor *into* the () and enter insert mode
  local new_col = start_col + #word + 2 -- inside ()
  vim.api.nvim_win_set_cursor(0, { row, new_col })
  vim.cmd('startinsert')
end

