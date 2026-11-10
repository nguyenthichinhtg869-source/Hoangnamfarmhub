-- =======================================================
-- HOANGNAMBUFFHUB - TEST GAME SCRIPT
-- =======================================================

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Cập nhật lại Character khi nhân vật chết và hồi sinh
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = Character:WaitForChild("Humanoid")
    RootPart = Character:WaitForChild("HumanoidRootPart")
end)

---------------------------------------------------------
-- 1. XỬ LÝ LOGIC CÁC TÍNH NĂNG TEST
---------------------------------------------------------
local isInfinitySpeedEnabled = false
local isFastFarmEnabled = false
local isMultitapEnabled = false

local defaultSpeed = 16
local infinitySpeed = 250 -- Tốc độ cực nhanh để test

-- Vòng lặp cập nhật mỗi khung hình
RunService.RenderStepped:Connect(function()
    -- 1. Infinity Speed (Tốc độ vô cực)
    if Humanoid then
        if isInfinitySpeedEnabled then
            Humanoid.WalkSpeed = infinitySpeed
        else
            Humanoid.WalkSpeed = defaultSpeed
        end
    end
end)

-- Vòng lặp xử lý logic Fast Farm & Multitap Breakable
task.spawn(function()
    while true do
        task.wait(0.1)
        if isFastFarmEnabled then
            -- Đoạn code giả lập gửi tín hiệu tương tác/farm mục tiêu gần nhất ở Server
            pcall(function()
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("Model") and (obj.Name:lower():find("breakable") or obj.Name:lower():find("coin") or obj.Name:lower():find("gem")) then
                        if obj:FindFirstChild("PrimaryPart") or obj:FindFirstChild("Hitbox") then
                            -- Gửi tín hiệu tương tác test (tùy thuộc vào cấu trúc game bạn đang test)
                            firetouchinterest(RootPart, obj.PrimaryPart or obj.Hitbox, 0)
                            firetouchinterest(RootPart, obj.PrimaryPart or obj.Hitbox, 1)
                        end
                    end
                end
            end)
        end
        
        -- Multitap Breakable (Giả lập đa chạm / đập liên tục vật thể)
        if isMultitapEnabled then
            pcall(function()
                -- Gửi thêm nhiều lượt tương tác giả lập trong một nhịp
                for i = 1, 5 do
                    -- Thêm logic gọi hàm click/tấn công mô phỏng của game tại đây
                end
            end)
        end
    end
end)

---------------------------------------------------------
-- 2. TẠO GIAO DIỆN GUI (HOANGNAMBUFFHUB)
---------------------------------------------------------
if LocalPlayer.PlayerGui:FindFirstChild("HoangNamBuffHub") then
    LocalPlayer.PlayerGui.HoangNamBuffHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HoangNamBuffHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 280)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MainFrame

-- Tiêu đề
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Title.Text = "HoangNamBuffHub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- Hàm tạo nút bấm
local function createButton(name, text, posY)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0.85, 0, 0, 40)
    btn.Position = UDim2.new(0.075, 0, posY, 0)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 15
    btn.Font = Enum.Font.SourceSans
    btn.Parent = MainFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    return btn
end

-- 1. Nút Infinity Speed
local SpeedButton = createButton("SpeedButton", "Infinity Speed: OFF", 0.20)
SpeedButton.MouseButton1Click:Connect(function()
    isInfinitySpeedEnabled = not isInfinitySpeedEnabled
    if isInfinitySpeedEnabled then
        SpeedButton.Text = "Infinity Speed: ON"
        SpeedButton.BackgroundColor3 = Color3.fromRGB(46, 139, 87)
    else
        SpeedButton.Text = "Infinity Speed: OFF"
        SpeedButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    end
end)

-- 2. Nút Fast Farm
local FarmButton = createButton("FarmButton", "Fast Farm: OFF", 0.38)
FarmButton.MouseButton1Click:Connect(function()
    isFastFarmEnabled = not isFastFarmEnabled
    if isFastFarmEnabled then
        FarmButton.Text = "Fast Farm: ON"
        FarmButton.BackgroundColor3 = Color3.fromRGB(46, 139, 87)
    else
        FarmButton.Text = "Fast Farm: OFF"
        FarmButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    end
end)

-- 3. Nút Multitap Breakable
local MultitapButton = createButton("MultitapButton", "Multitap Breakable: OFF", 0.56)
MultitapButton.MouseButton1Click:Connect(function()
    isMultitapEnabled = not isMultitapEnabled
    if isMultitapEnabled then
        MultitapButton.Text = "Multitap Breakable: ON"
        MultitapButton.BackgroundColor3 = Color3.fromRGB(46, 139, 87)
    else
        MultitapButton.Text = "Multitap Breakable: OFF"
        MultitapButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    end
end)

-- Phụ đề hướng dẫn phím tắt
local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, 0, 0, 25)
Subtitle.Position = UDim2.new(0, 0, 0.82, 0)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Bấm phím 'K' để Ẩn/Hiện Menu"
Subtitle.TextColor3 = Color3.fromRGB(150, 150, 150)
Subtitle.TextSize = 13
Subtitle.Font = Enum.Font.SourceSansItalic
Subtitle.Parent = MainFrame

-- Sự kiện ẩn/hiện bảng bằng phím K
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.K then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

print("HoangNamBuffHub đã khởi chạy thành công!")
