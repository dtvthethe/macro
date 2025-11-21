local MP5K = 4
local UMP45 = 5
local BIZON = 6
local M416 = 7
local BERRYL = 8
local AUG = 9
local SCAR_L = 10
local ACE32 = 11
local AKM = 12

--====== Sensitivity Settings =========--
local SensSetting = 1  -- Điều chỉnh theo Vertical Sensitivity Multiplier của bạn
-- 0.50 -> 2
-- 0.75 -> 1.33
-- 1.00 -> 1
-- 1.50 -> 0.675
-- 2.00 -> 0.50

--====== Click Mode Settings =========--
local click = 1  -- 1 = chỉ LMB, 3 = RMB + LMB

--====== Weapon Profiles =========--
-- Cấu hình dựa trên thông số chính thức từ PUBG Wiki
-- compensateX: recoil ngang (âm = trái, dương = phải)
-- compensateY: recoil dọc
-- fireRate: delay giữa các viên (ms) = 60000 / RPM
-- magazineSize: số đạn trong băng

local weaponProfiles = {
    -- SMGs
    MP5K = {
        compensateX = 0,
        compensateY = 25,      -- Low vertical recoil
        fireRate = 67,         -- 900 RPM
        magazineSize = 30
    },
    UMP45 = {
        compensateX = -1,      -- Slight left pull
        compensateY = 28,      -- Moderate vertical recoil
        fireRate = 92,         -- 650 RPM
        magazineSize = 40
    },
    BIZON = {
        compensateX = 1,       -- Slight right pull
        compensateY = 26,      -- Low-moderate vertical recoil
        fireRate = 71,         -- 840 RPM
        magazineSize = 53
    },
    
    -- Assault Rifles
    M416 = {
        compensateX = 0,       -- Very stable horizontal
        compensateY = 35,      -- Moderate vertical recoil
        fireRate = 75,         -- 800 RPM
        magazineSize = 40
    },
    AUG = {
        compensateX = -1,      -- Slight left tendency
        compensateY = 34,      -- Similar to M416
        fireRate = 78,         -- 770 RPM
        magazineSize = 40
    },
    SCAR_L = {
        compensateX = 1,       -- Slight right pull
        compensateY = 38,      -- Higher vertical recoil
        fireRate = 96,         -- 625 RPM
        magazineSize = 30
    },
    BERRYL = {
        compensateX = -2,      -- Strong left pull initially
        compensateY = 48,      -- High vertical recoil
        fireRate = 76,         -- 790 RPM
        magazineSize = 40,
        -- BERYL có pattern đặc biệt: giật trái mạnh đầu băng
        horizontalPattern = function(bulletNum)
            if bulletNum <= 5 then
                return -3      -- 5 viên đầu giật mạnh trái
            elseif bulletNum <= 15 then
                return -1      -- viên 6-15 giật nhẹ trái
            elseif bulletNum <= 30 then
                return 1       -- viên 16-30 giật nhẹ phải
            else
                return 0       -- viên cuối ổn định
            end
        end
    },
    ACE32 = {
        compensateX = 1,       -- Slight right pull
        compensateY = 42,      -- High vertical recoil (7.62mm)
        fireRate = 100,        -- 600 RPM
        magazineSize = 40
    },
    AKM = {
        compensateX = 0,       -- Use pattern
        compensateY = 50,      -- Very high vertical recoil (7.62mm)
        fireRate = 100,        -- 600 RPM
        magazineSize = 40,
        -- AKM có recoil pattern phức tạp nhất
        horizontalPattern = function(bulletNum)
            if bulletNum <= 3 then
                return -4      -- 3 viên đầu giật rất mạnh trái
            elseif bulletNum <= 10 then
                return -2      -- viên 4-10 giật trái vừa
            elseif bulletNum <= 20 then
                return 2       -- viên 11-20 giật phải
            elseif bulletNum <= 30 then
                return 1       -- viên 21-30 giật nhẹ phải
            else
                return 0       -- viên cuối
            end
        end
    }
}

--====== Global Variables =========--
EnablePrimaryMouseButtonEvents(true)
local recoil = false
local weapon = 0
local weaponName = "NONE"

--====== Scroll Lock Control =========--
function SetScrollLockState(desiredState)
    local currentState = IsKeyLockOn("scrolllock")
    if currentState ~= desiredState then
        PressAndReleaseKey("scrolllock")
    end
end

--====== Custom Sleep Function =========--
function Sleep(time)
    local start_time = GetRunningTime()
    while GetRunningTime() - start_time < time do end
end

--====== Main Recoil Control Function =========--
function ApplyRecoilControl(profile)
    if not IsMouseButtonPressed(click) then
        return
    end
    
    local remainder_x, remainder_y = 0, 0
    
    for i = 1, profile.magazineSize do
        if not IsMouseButtonPressed(1) then
            break
        end
        
        -- Xác định recoil ngang cho viên đạn này
        local compensateX = profile.compensateX
        if profile.horizontalPattern then
            compensateX = profile.horizontalPattern(i)
        end
        
        -- Tính toán di chuyển X với fractional tracking
        local moveX = compensateX * SensSetting + remainder_x
        local moveX_int = math.floor(moveX + 0.5)
        remainder_x = moveX - moveX_int
        
        -- Tính toán di chuyển Y với fractional tracking
        local moveY = profile.compensateY * SensSetting + remainder_y
        local moveY_int = math.floor(moveY + 0.5)
        remainder_y = moveY - moveY_int
        
        -- Di chuyển chuột (X và Y)
        MoveMouseRelative(moveX_int, moveY_int)
        
        -- Delay theo fire rate
        Sleep(profile.fireRate)
    end
end

--====== Weapon Selection Handler =========--
local weaponMap = {
    [MP5K] = "MP5K",
    [UMP45] = "UMP45",
    [BIZON] = "BIZON",
    [M416] = "M416",
    [AUG] = "AUG",
    [SCAR_L] = "SCAR_L",
    [BERRYL] = "BERRYL",
    [ACE32] = "ACE32",
    [AKM] = "AKM"
}

--====== Main Event Handler =========--
function OnEvent(event, arg)
    -- Xử lý chọn súng hoặc tắt macro
    if event == "MOUSE_BUTTON_PRESSED" and weaponMap[arg] then
        -- Nếu macro đang bật, bấm bất kỳ nút nào cũng tắt
        if recoil then
            recoil = false
            weaponName = "NONE"
            SetScrollLockState(false)
            OutputLogMessage("MACRO OFF\n")
        else
            -- Nếu macro đang tắt, bấm nút để bật và chọn súng
            weapon = arg
            weaponName = weaponMap[arg]
            recoil = true
            SetScrollLockState(true)
            OutputLogMessage("MACRO ON - " .. weaponName .. "\n")
        end
    end
    
    -- Xử lý recoil khi bắn
    if event == "MOUSE_BUTTON_PRESSED" and arg == 1 then
        if recoil and weaponProfiles[weaponName] then
            ApplyRecoilControl(weaponProfiles[weaponName])
        end
    end
end
