-- Trạng thái macro tổng
local macroEnabled = false
local currentGun = "none"

-- Gán từng nút chuột cho từng khẩu
local mouseButtonToGun = {
    [4] = "M416",
    [5] = "AKM",
    [6] = "BERYL",
    [7] = "UMP45"
    -- [8] = "UMP45",
}

-- Thông số macro cho từng khẩu súng
local gunProfiles = {
    M416 = {pullAmount = 12, pullDelay = 10, pullCount = 30},
    AKM  = {pullAmount = 18, pullDelay = 14, pullCount = 30},
    BERYL = {pullAmount = 20, pullDelay = 9, pullCount = 30},
    UMP45 = {pullAmount = 10, pullDelay = 11, pullCount = 25}
}

-- Hàm chính xử lý sự kiện macro
function OnEvent(event, arg)
    -- Chỉ xử lý khi macro được kích hoạt
    if event == "PROFILE_ACTIVATED" then
        ClearLog()
        OutputLogMessage("PUBG macro system loaded ✅\n")
        EnablePrimaryMouseButtonEvents(true)
        SetScrollLockState(false)
    end

    -- Nhấn các nút G4 ~ G8 để chọn súng hoặc tắt macro
    if event == "MOUSE_BUTTON_PRESSED" and mouseButtonToGun[arg] then
        if not macroEnabled then
            currentGun = mouseButtonToGun[arg]
            macroEnabled = true
            OutputLogMessage("Macro BẬT ✅ - Chọn súng: " .. currentGun .. " 🔫\n")
            SetScrollLockState(true)
        else
            OutputLogMessage("Macro TẮT ❌\n")
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
