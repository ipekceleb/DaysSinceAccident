-- Global so both Initialize() and ResetDate() can see it
local startDatePath, startTime

function Initialize()
    -- Grab & expand the INI variable
    startDatePath = SKIN:ReplaceVariables(SKIN:GetVariable("StartDatePath"))

    -- Read existing date or write the default
    local file = io.open(startDatePath, "r")
    local dateString
    if file then
        dateString = file:read("*l")
        file:close()
    else
        dateString = "2024-07-17"
        local initFile = io.open(startDatePath, "w")
        if initFile then
            initFile:write(dateString)
            initFile:close()
        end
    end

    -- Parse into a timestamp
    local y, m, d = dateString:match("(%d+)%-(%d+)%-(%d+)")
    startTime = os.time{year=tonumber(y), month=tonumber(m), day=tonumber(d), hour=0}
end

function Update()
    -- Compute days since startTime
    local now = os.time()
    local days = math.floor((now - startTime) / 86400)
    return tostring(days)
end

function ResetDate()
    -- Build today’s YYYY-MM-DD
    local now = os.date("*t")
    local dateString = string.format("%04d-%02d-%02d", now.year, now.month, now.day)

    -- Overwrite the file
    local file = io.open(startDatePath, "w")
    if file then
        file:write(dateString)
        file:close()
    end

    -- Also update our in-memory startTime so the counter goes to zero instantly
    startTime = os.time{year=now.year, month=now.month, day=now.day, hour=0}
end

function GetStartDate()
    local file = io.open(startDatePath, "r")
    if file then
        local date = file:read("*l")
        file:close()
        return date
    else
        return "Tarih bulunamadı"
    end
end
