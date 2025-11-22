local MP5KMINI = 4 -- MP5 nini
local MP5KMED = 5 -- MP5K med
local BIZON = 6
local M416 = 7
local BERRYL = 8
local AUG = 9
local SCAR_L = 10
local ACE32 = 11
local AKM = 12
local UMP45 = 15

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
-- horizontalPattern: function để điều chỉnh recoil ngang theo số viên
-- verticalPattern: function để điều chỉnh recoil dọc theo số viên

local weaponProfiles = {
    -- SMGs
    MP5KMED = {
        compensateX = 0,
        compensateY = 18,      -- Low vertical recoil
        fireRate = 67,         -- 900 RPM
        magazineSize = 42,
        verticalPattern = function(bulletNum)
            if bulletNum <= 3 then
                return 18  -- 3 viên đầu recoil cực cao
            elseif bulletNum <= 10 then
                return 18  -- viên 4-10 giảm xuống
            elseif bulletNum <= 20 then
                return 18  -- viên 11-20 ổn định
            elseif bulletNum <= 30 then
                return 18  -- viên 21-30 tăng nhẹ
            else
                return 18  -- viên cuối rất cao
            end
        end
    },
    MP5KMINI = {
        compensateX = 0,
        compensateY = 18,      -- Low vertical recoil
        fireRate = 67,         -- 900 RPM
        magazineSize = 42,
        horizontalPattern = function(bulletNum)
            if bulletNum <= 20 then
                return -1
            elseif bulletNum <= 30 then
                return 1
            else
                return 1
            end
        end,
        verticalPattern = function(bulletNum)
            if bulletNum <= 3 then
                return 18  -- 3 viên đầu recoil cực cao
            elseif bulletNum <= 10 then
                return 19  -- viên 4-10 giảm xuống
            elseif bulletNum <= 20 then
                return 24  -- viên 11-20 ổn định
            elseif bulletNum <= 30 then
                return 21  -- viên 21-30 tăng nhẹ
            else
                return 22  -- viên cuối rất cao
            end
        end
    },
    UMP45 = {
        compensateX = -1,      -- Slight left pull
        compensateY = 23,      -- Moderate vertical recoil
        fireRate = 92,         -- 650 RPM
        magazineSize = 45
    },
    BIZON = {
        compensateX = 1,       -- Slight right pull
        compensateY = 18,      -- Low-moderate vertical recoil
        fireRate = 71,         -- 840 RPM
        magazineSize = 60,
        horizontalPattern = function(bulletNum)
            if bulletNum <= 20 then
                return 0
            elseif bulletNum <= 30 then
                return 1
            elseif bulletNum <= 40 then
                return 1
            else
                return 2
            end
        end,
        verticalPattern = function(bulletNum)
            if bulletNum <= 3 then
                return 18  -- 3 viên đầu recoil cực cao
            elseif bulletNum <= 10 then
                return 19  -- viên 4-10 giảm xuống
            elseif bulletNum <= 20 then
                return 23  -- viên 11-20 ổn định
            elseif bulletNum <= 30 then
                return 22  -- viên 21-30 tăng nhẹ
            elseif bulletNum <= 40 then
                return 16  -- viên 21-30 tăng nhẹ
            else
                return 20  -- viên cuối rất cao
            end
        end
    },
    
    -- Assault Rifles
    M416 = {
        compensateX = 0,
        compensateY = 35,
        fireRate = 75,
        magazineSize = 45,
        horizontalPattern = function(bulletNum)
            if bulletNum <= 10 then
                return 1
            elseif bulletNum <= 20 then
                return 0
            elseif bulletNum <= 30 then
                return 1
            else
                return -1
            end
        end,
        -- M416 có recoil tăng dần từ viên 20 trở đi
        verticalPattern = function(bulletNum)
            if bulletNum <= 10 then
                return 26  -- 10 viên đầu dễ kiểm soát
            elseif bulletNum <= 20 then
                return 31  -- viên 11-20 recoil chuẩn
            elseif bulletNum <= 30 then
                return 27  -- viên 21-30 recoil tăng
            elseif bulletNum <= 40 then
                return 37  -- viên 21-30 recoil tăng
            else
                return 36  -- viên cuối recoil cao
            end
        end
    },
    AUG = {
        compensateX = -1,
        compensateY = 34,
        fireRate = 78,
        magazineSize = 40,
        -- AUG tương tự M416 nhưng ổn định hơn
        verticalPattern = function(bulletNum)
            if bulletNum <= 15 then
                return 32
            elseif bulletNum <= 30 then
                return 34
            else
                return 37
            end
        end
    },
    SCAR_L = {
        compensateX = 1,
        compensateY = 38,
        fireRate = 96,
        magazineSize = 30,
        -- SCAR-L recoil tăng mạnh sau 20 viên
        verticalPattern = function(bulletNum)
            if bulletNum <= 10 then
                return 35
            elseif bulletNum <= 20 then
                return 38
            else
                return 45
            end
        end
    },
    BERRYL = {
        compensateX = -2,
        compensateY = 48,
        fireRate = 76,
        magazineSize = 45,
        -- BERYL có pattern phức tạp: recoil cao đầu băng, giảm giữa, tăng lại cuối
        horizontalPattern = function(bulletNum)
            if bulletNum <= 10 then
                return 0
            elseif bulletNum <= 20 then
                return 0
            elseif bulletNum <= 30 then
                return 0
            else
                return 0
            end
        end,
        verticalPattern = function(bulletNum)
            if bulletNum <= 10 then
                return 30  -- 5 viên đầu recoil rất cao
            elseif bulletNum <= 20 then
                return 45  -- viên 6-15 giảm xuống
            elseif bulletNum <= 30 then
                return 49  -- viên 16-30 tăng trở lại
            else
                return 53  -- viên cuối rất cao
            end
        end
    },
    ACE32 = {
        compensateX = 1,
        compensateY = 42,
        fireRate = 100,
        magazineSize = 40,
        -- ACE32 recoil ổn định hơn các 7.62mm khác
        verticalPattern = function(bulletNum)
            if bulletNum <= 15 then
                return 40
            elseif bulletNum <= 30 then
                return 42
            else
                return 46
            end
        end
    },
    AKM = {
        compensateX = 0,
        compensateY = 50,
        fireRate = 100,
        magazineSize = 40,
        -- AKM có pattern phức tạp nhất: cả ngang và dọc đều thay đổi
        horizontalPattern = function(bulletNum)
            if bulletNum <= 3 then
                return -4
            elseif bulletNum <= 10 then
                return -2
            elseif bulletNum <= 20 then
                return 2
            elseif bulletNum <= 30 then
                return 1
            else
                return 0
            end
        end,
        verticalPattern = function(bulletNum)
            if bulletNum <= 3 then
                return 55  -- 3 viên đầu recoil cực cao
            elseif bulletNum <= 10 then
                return 48  -- viên 4-10 giảm xuống
            elseif bulletNum <= 20 then
                return 50  -- viên 11-20 ổn định
            elseif bulletNum <= 30 then
                return 52  -- viên 21-30 tăng nhẹ
            else
                return 58  -- viên cuối rất cao
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
        
        -- Xác định recoil dọc cho viên đạn này
        local compensateY = profile.compensateY
        if profile.verticalPattern then
            compensateY = profile.verticalPattern(i)
        end
        
        -- Tính toán di chuyển X với fractional tracking
        local moveX = compensateX * SensSetting + remainder_x
        local moveX_int = math.floor(moveX + 0.5)
        remainder_x = moveX - moveX_int
        
        -- Tính toán di chuyển Y với fractional tracking
        local moveY = compensateY * SensSetting + remainder_y
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
    [MP5KMED] = "MP5KMED",
    [MP5KMINI] = "MP5KMINI",
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
