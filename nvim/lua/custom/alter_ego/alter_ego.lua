local M = {}


local PYTHON_SCRIPT_PATH = vim.fn.stdpath('config') .. '/lua/custom/alter_ego/alter_ego.py'

local function fidget_utility(action, name, message)
    local ok, fidget = pcall(require, 'fidget')
    if ok and fidget and type(fidget[action]) == 'function' then
        fidget[action](name, message)
        return true
    end
    return false
end

local function insert_thought(thought_text)
    local current_buf = vim.api.nvim_get_current_buf()
    local current_lines = vim.api.nvim_buf_line_count(current_buf)


    local lines_to_insert = vim.split(thought_text, '\n', true)

    local start_line_idx

    if current_lines == 1 and vim.api.nvim_buf_get_lines(current_buf, 0, 1, false)[1]:match('^%s*$') then
        -- Buffer is effectively empty. Insert at line 0 and delete the empty line.
        vim.api.nvim_buf_set_lines(current_buf, 0, 1, false, lines_to_insert)
        start_line_idx = 0
    else
        -- Insert the new content at the end of the buffer (after current_lines, which is 0-indexed).
        vim.api.nvim_buf_set_lines(current_buf, current_lines, current_lines, false, lines_to_insert)
        start_line_idx = current_lines
    end

    local new_line_count = vim.api.nvim_buf_line_count(current_buf)
    vim.api.nvim_win_set_cursor(0, { new_line_count, 0 })

    vim.notify('Added my thoughts', vim.log.levels.INFO, { title = "Alter Ego" })
end

function M.run_ego()
    local current_buf = vim.api.nvim_get_current_buf()

    -- Check if the script path is set correctly
    if not vim.fn.filereadable(PYTHON_SCRIPT_PATH) then
        vim.notify('Alter Ego Python script not found. Please set PYTHON_SCRIPT_PATH in lua/custom/alter_ego/alter_ego.lua.',
            vim.log.levels.ERROR)
        return
    end

    local lines = vim.api.nvim_buf_get_lines(current_buf, 0, -1, false)

    local text_to_pipe = table.concat(lines, '\n')

    local content_found = false

    for _, line in ipairs(lines) do
        -- Check if the line contains at least one non-whitespace character
        if line:match('%S') then
            content_found = true
            break
        end
    end

    if not content_found then
        vim.notify(
            'Buffer is empty or contains only whitespace. At least one line of thought is required for Alter Ego processing.',
            vim.log.levels.WARN)
        return
    end

    local spinner_started = fidget_utility('start', 'AlterEgo', 'Thinking...')
    if not spinner_started then
        -- Fallback notification if fidget is not available
        vim.notify('Thinking...', vim.log.levels.INFO, { title = "Alter Ego" })
    end
    local cmd = { 'uv', 'run', '--script', PYTHON_SCRIPT_PATH }

    local result = {}
    local output_collected = false

    local job = vim.fn.jobstart(cmd, {
        stdin = "pipe",
        stdout_buffered = true,
        on_stdout = function(_, data, _)
            -- Collect all lines printed to stdout by the Python script
            for _, line in ipairs(data) do
                table.insert(result, line)
            end
        end,
        on_stderr = function(_, data, _)
            -- Display errors from stderr in the Neovim notification area
            if data and #data > 0 then
                vim.notify(table.concat(data, ' '), vim.log.levels.ERROR, { title = "Alter Ego Error" })
            end
        end,
        on_exit = function(_, code, _)
            fidget_utility('stop', 'AlterEgo')
            if code == 0 and not output_collected then
                -- Success. Insert the captured output into the current buffer.
                local text = table.concat(result, '\n')
                insert_thought('\n' .. text .. '\n')
                output_collected = true
            elseif code ~= 0 and not output_collected then
                -- Failure is already notified via on_stderr
                vim.notify('Alter Ego script failed. Check error logs.', vim.log.levels.ERROR, { title = "Alter Ego" })
            end
        end,
        -- Set a very generous timeout for the API call (60 seconds)
        timeout = 60000
    })
    vim.fn.jobsend(job, text_to_pipe)
    vim.fn.jobclose(job, 'stdin')
end

return M
