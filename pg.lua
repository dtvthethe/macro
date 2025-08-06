-- Trạng thái macro tổng
local macroEnabled = false
local currentGun = "none"

local mouseButtonToGun = {
    [4] = "M416",
    [5] = "BERYL",
    [6] = "AKM",
    [7] = "AUG",
    [8] = "ACE32"
}

-- Thông số macro cho từng khẩu súng
-- pullAmount : số lượng pixel bị kéo xuống
-- pullDelay  : time deplay giữa mỗi lẫn kéo, đièu chỉnh tốc dộ kéo
-- pullCount  : số lần lặp lại thao tác kéo (số viên bắn ra)
local gunProfiles = {
    M416 = { pullAmount = 29, pullDelay = 68, pullCount = 60 },
    AUG = { pullAmount = 35, pullDelay = 73, pullCount = 60 },
    AKM = { pullAmount = 38, pullDelay = 70, pullCount = 60 },
    BERYL = { pullAmount = 43, pullDelay = 76, pullCount = 60 },
    ACE32 = { pullAmount = 34, pullDelay = 80, pullCount = 60 }
}

-- Hàm chính xử lý sự kiện macro
function OnEvent(event, arg)
    -- Chỉ xử lý khi macro được kích hoạt
    if event == "PROFILE_ACTIVATED" then
        ClearLog()
        -- OutputLogMessage("macro system loaded ✅\n")
        EnablePrimaryMouseButtonEvents(true)
        SetScrollLockState(false)
    end

    -- Nhấn các nút G4 ~ G8 để chọn súng hoặc tắt macro
    if event == "MOUSE_BUTTON_PRESSED" and mouseButtonToGun[arg] then
        if not macroEnabled then
            currentGun = mouseButtonToGun[arg]
            macroEnabled = true
            -- OutputLogMessage("Macro BẬT ✅ - Chọn súng: " .. currentGun .. " 🔫\n")
            SetScrollLockState(true)
        else
            -- OutputLogMessage("Macro TẮT ❌\n")
            macroEnabled = false
            currentGun = "none"
            SetScrollLockState(false)
        end
    end

    -- Tự động kéo chuột khi bắn (chuột trái = arg 1) nếu macro đang bật
    if event == "MOUSE_BUTTON_PRESSED" and arg == 1 and macroEnabled and gunProfiles[currentGun] then
        local profile = gunProfiles[currentGun]
        for i = 1, profile.pullCount do
            if not IsMouseButtonPressed(1) then break end
            MoveMouseRelative(0, profile.pullAmount)
            PromacroRuDelay(profile.pullDelay)
        end
    end
end

-- Hàm bật/tắt Scroll Lock (bật đèn để báo macro ON)
function SetScrollLockState(desiredState)
    local currentState = IsKeyLockOn("scrolllock")
    if currentState ~= desiredState then
        PressAndReleaseKey("scrolllock")
    end
end

-- Hàm delay thủ công
function PromacroRuDelay(time)
    local start_time = GetRunningTime()
    while GetRunningTime() - start_time < time do end
end
