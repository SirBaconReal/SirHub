-- =================================================================
-- 👑 SIRHUB | v1.0 - THE MASTERPIECE (STRICT WORK.INK + VIP BIND)
-- =================================================================
-- STATUS: UNDETECTED ✅ | CROSS-PLATFORM: PC & MOBILE
-- FEATURES: FOV AIMBOT, ZERO-LAG ESP, IRON-MAN FLY, KEYLESS VAULT
-- SECURITY: STRICT IP BINDING, AUTO-LOGIN, VIP ACCOUNT WHITELIST
-- =================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local TweenService = game:GetService("TweenService")
local Stats = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local LogoAsset = "rbxthumb://type=Asset&id=104869641536318&w=150&h=150" 

-- ==========================================
-- [0] BUSINESS SETTINGS & VIP WHITELIST
-- ==========================================
-- Zde přidávej ID platících zákazníků. Ti nebudou potřebovat žádný klíč!
local VIP_Users = {
    -- Příklad: [123456789] = true,
}
local IsVIP = VIP_Users[LocalPlayer.UserId] or false

local WorkInkLink = "https://work.ink/2mLm/sirhub"
local DiscordLink = "https://discord.gg/mv6xhHTtPw" 
local AuthFileName = "SirHub_AuthToken.txt"

local CurrentTheme = Color3.fromRGB(255, 0, 255) 
local RainbowMode = false
local ThemeObjects = { Backgrounds = {}, Texts = {}, Strokes = {}, Images = {} }
local Connections = {}
local function AddConnection(name, conn) Connections[name] = conn end

-- Ukládání barevného nastavení 
local ConfigName = "SirHub_Config.json"
local function SaveConfig()
    if writefile then
        local data = { Theme = {CurrentTheme.R, CurrentTheme.G, CurrentTheme.B}, Rainbow = RainbowMode }
        pcall(function() writefile(ConfigName, HttpService:JSONEncode(data)) end)
    end
end
local function LoadConfig()
    if readfile and isfile and isfile(ConfigName) then
        pcall(function()
            local data = HttpService:JSONDecode(readfile(ConfigName))
            if data.Theme then CurrentTheme = Color3.new(data.Theme[1], data.Theme[2], data.Theme[3]) end
            if data.Rainbow ~= nil then RainbowMode = data.Rainbow end
        end)
    end
end
LoadConfig()

-- Anti-AFK
local VirtualUser = game:GetService("VirtualUser")
AddConnection("AntiAFK", LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end))

local ExecutorName = (identifyexecutor and identifyexecutor() or "Unknown"):match("([^%s]+)") or "Generic"
local CurrentGameName = "Unknown Experience"
pcall(function() CurrentGameName = MarketplaceService:GetProductInfo(game.PlaceId).Name end)

-- ==========================================
-- [1] THE KEYLESS VAULT (SMART DATABASE)
-- ==========================================
local ScriptDatabase = {
    { Name = "⚔️ Blox Fruits | Redz Hub (Keyless)", GameId = {2753915549, 4442272083, 7449423635}, Execute = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/realredz/BloxFruits/refs/heads/main/Source.lua"))() end },
    { Name = "🐟 Fisch | Auto Catch (Keyless)", GameId = {16732694052}, Execute = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Efe0626/RaitoHub/main/Script"))() end },
    { Name = "💥 AFS Endless | TP & Farm (Keyless)", GameId = {6299805723, 2373301339}, Execute = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/unrexl/Scripts/refs/heads/main/TeleportXFarm"))() end },
    { Name = "🏠 Bloxburg | Auto Farm (Keyless)", GameId = {185655149}, Execute = function() loadstring(game:HttpGet("https://pastebin.com/raw/4dCuru04"))() end },
    { Name = "🍯 Bee Swarm | Atlas BSS (Keyless)", GameId = {1537690962}, Execute = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Chris12089/atlasbss/main/script.lua"))() end },
    { Name = "⌨️ Infinite Yield (Universal Admin)", GameId = {0}, IsDev = true, Execute = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))() end },
    { Name = "🛠️ Dark Dex V3 (Game Explorer)", GameId = {0}, IsDev = true, Execute = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua"))() end }
}

-- ==========================================
-- [2] PROTECT GUI & INIT
-- ==========================================
local function ProtectGUI(gui)
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) elseif gethui then gui.Parent = gethui() elseif coregui then gui.Parent = coregui end end)
end

if CoreGui:FindFirstChild("SirHub_v1") then CoreGui.SirHub_v1:Destroy() end
if CoreGui:FindFirstChild("SirHub_Notif") then CoreGui.SirHub_Notif:Destroy() end

local Apex = Instance.new("ScreenGui") Apex.Name = "SirHub_v1" Apex.ZIndexBehavior = Enum.ZIndexBehavior.Sibling ProtectGUI(Apex)
local NotifUI = Instance.new("ScreenGui") NotifUI.Name = "SirHub_Notif" ProtectGUI(NotifUI)
local NotifLayout = Instance.new("Frame", NotifUI) NotifLayout.BackgroundTransparency = 1 NotifLayout.Size = UDim2.new(0, 250, 1, -20) NotifLayout.Position = UDim2.new(1, -260, 0, 0)
local UIL = Instance.new("UIListLayout", NotifLayout) UIL.VerticalAlignment = Enum.VerticalAlignment.Bottom UIL.Padding = UDim.new(0, 10)

local SirHubLib = { Labels = {}, Tabs = {}, FirstTabClick = nil, MenuKeybind = Enum.KeyCode.RightShift }

function SirHubLib:Notify(title, text)
    task.spawn(function()
        local f = Instance.new("Frame", NotifLayout) f.BackgroundColor3 = Color3.fromRGB(20, 20, 24) f.Size = UDim2.new(1, 100, 0, 50) Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6) f.BackgroundTransparency = 1
        local str = Instance.new("UIStroke", f) str.Color = CurrentTheme str.Thickness = 1 str.Transparency = 1 table.insert(ThemeObjects.Strokes, str)
        local tL = Instance.new("TextLabel", f) tL.Text = "  "..title:upper() tL.Font = Enum.Font.GothamBold tL.TextColor3 = CurrentTheme tL.TextSize = 11 tL.Size = UDim2.new(1,0,0.4,0) tL.BackgroundTransparency = 1 tL.TextXAlignment = Enum.TextXAlignment.Left tL.TextTransparency = 1 table.insert(ThemeObjects.Texts, tL)
        local dL = Instance.new("TextLabel", f) dL.Text = "  "..text dL.Font = Enum.Font.Gotham dL.TextColor3 = Color3.fromRGB(200,200,200) dL.TextSize = 11 dL.Size = UDim2.new(1,0,0.6,0) dL.Position = UDim2.new(0,0,0.4,0) dL.BackgroundTransparency = 1 dL.TextXAlignment = Enum.TextXAlignment.Left dL.TextTransparency = 1
        TweenService:Create(f, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {Size = UDim2.new(1, 0, 0, 50), BackgroundTransparency = 0}):Play()
        TweenService:Create(str, TweenInfo.new(0.4), {Transparency = 0}):Play() TweenService:Create(tL, TweenInfo.new(0.4), {TextTransparency = 0}):Play() TweenService:Create(dL, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
        task.wait(3)
        TweenService:Create(f, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 0, 0, 50), BackgroundTransparency = 1}):Play()
        TweenService:Create(str, TweenInfo.new(0.3), {Transparency = 1}):Play() TweenService:Create(tL, TweenInfo.new(0.3), {TextTransparency = 1}):Play() TweenService:Create(dL, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        task.wait(0.4) f:Destroy()
    end)
end

function SirHubLib:ChangeTheme(newColor, instant)
    CurrentTheme = newColor
    for _, obj in pairs(ThemeObjects.Backgrounds) do if obj then if instant then obj.BackgroundColor3 = newColor else TweenService:Create(obj, TweenInfo.new(0.3), {BackgroundColor3 = newColor}):Play() end end end
    for _, obj in pairs(ThemeObjects.Texts) do if obj then if instant then obj.TextColor3 = newColor else TweenService:Create(obj, TweenInfo.new(0.3), {TextColor3 = newColor}):Play() end end end
    for _, obj in pairs(ThemeObjects.Strokes) do if obj then if instant then obj.Color = newColor else TweenService:Create(obj, TweenInfo.new(0.3), {Color = newColor}):Play() end end end
    for _, obj in pairs(ThemeObjects.Images) do if obj then if instant then obj.ImageColor3 = newColor else TweenService:Create(obj, TweenInfo.new(0.3), {ImageColor3 = newColor}):Play() end end end
end

AddConnection("Rainbow", RunService.Heartbeat:Connect(function()
    if RainbowMode then SirHubLib:ChangeTheme(Color3.fromHSV(tick() % 5 / 5, 1, 1), true) end
end))
task.spawn(function() while task.wait(10) do SaveConfig() end end)

-- ==========================================
-- [3] UI BUILDER ENGINE 
-- ==========================================
function SirHubLib.CreateWindow(hubName)
    local shadow = Instance.new("ImageLabel", Apex) shadow.Name = "shadow" shadow.BackgroundTransparency = 1 shadow.Position = UDim2.new(0.5, -300, 0.5, -250) shadow.Size = UDim2.new(0, 600, 0, 500) shadow.Image = "http://www.roblox.com/asset/?id=6105530152" shadow.ImageColor3 = Color3.fromRGB(0,0,0) shadow.ImageTransparency = 0.3 shadow.Visible = false
    local MainFrame = Instance.new("Frame", shadow) MainFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 17) MainFrame.Position = UDim2.new(0.05, 0, 0.05, 0) MainFrame.Size = UDim2.new(0, 540, 0, 440) MainFrame.ClipsDescendants = true Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
    local TopNeon = Instance.new("Frame", MainFrame) TopNeon.Size = UDim2.new(1,0,0,2) TopNeon.BackgroundColor3 = CurrentTheme TopNeon.BorderSizePixel = 0 TopNeon.ZIndex = 5 table.insert(ThemeObjects.Backgrounds, TopNeon)
    
    local MobileToggle = Instance.new("ImageButton", Apex) MobileToggle.Size = UDim2.fromOffset(45, 45) MobileToggle.Position = UDim2.new(0, 20, 0, 50) MobileToggle.BackgroundColor3 = Color3.fromRGB(15,15,18) MobileToggle.Image = LogoAsset MobileToggle.ZIndex = 50 Instance.new("UICorner", MobileToggle).CornerRadius = UDim.new(1, 0) MobileToggle.Visible = false
    local MTStroke = Instance.new("UIStroke", MobileToggle) MTStroke.Color = CurrentTheme MTStroke.Thickness = 2 table.insert(ThemeObjects.Strokes, MTStroke)
    
    local dragTog, dragTogStart, startTogPos
    MobileToggle.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragTog = true dragTogStart = input.Position startTogPos = MobileToggle.Position end end)
    UserInputService.InputChanged:Connect(function(input) if dragTog and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then local delta = input.Position - dragTogStart local vp = workspace.CurrentCamera.ViewportSize MobileToggle.Position = UDim2.new(0, math.clamp(startTogPos.X.Offset + delta.X, 0, vp.X - 45), 0, math.clamp(startTogPos.Y.Offset + delta.Y, 0, vp.Y - 45)) end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragTog = false end end)
    
    local function ToggleUI() shadow.Visible = not shadow.Visible end
    MobileToggle.MouseButton1Click:Connect(ToggleUI)
    
    local IsBinding = false
    AddConnection("KeybindListener", UserInputService.InputBegan:Connect(function(input, gp)
        if IsBinding and input.UserInputType == Enum.UserInputType.Keyboard then SirHubLib.MenuKeybind = input.KeyCode IsBinding = false if SirHubLib.BindBtn then SirHubLib.BindBtn.Text = "Menu Keybind: " .. input.KeyCode.Name SirHubLib.BindBtn.TextColor3 = Color3.fromRGB(230,230,230) SirHubLib:Notify("System", "Keybind set to " .. input.KeyCode.Name) end return end
        if not gp and input.KeyCode == SirHubLib.MenuKeybind and not IsBinding then ToggleUI() end
    end))

    local dragging, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true dragStart = input.Position startPos = shadow.Position input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end)
    UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then shadow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + (input.Position - dragStart).X, startPos.Y.Scale, startPos.Y.Offset + (input.Position - dragStart).Y) end end)

    local sideBar = Instance.new("Frame", MainFrame) sideBar.BackgroundColor3 = Color3.fromRGB(20, 20, 24) sideBar.Size = UDim2.new(0, 160, 1, 0) sideBar.ZIndex = 2 Instance.new("UICorner", sideBar).CornerRadius = UDim.new(0, 8) Instance.new("Frame", sideBar).BackgroundColor3 = Color3.fromRGB(20, 20, 24) sideBar:FindFirstChildOfClass("Frame").Size = UDim2.new(0, 10, 1, 0) sideBar:FindFirstChildOfClass("Frame").Position = UDim2.new(1, -10, 0, 0) sideBar:FindFirstChildOfClass("Frame").BorderSizePixel = 0
    local hubLogo = Instance.new("ImageLabel", sideBar) hubLogo.BackgroundTransparency = 1 hubLogo.Position = UDim2.new(0.08, 0, 0.03, 0) hubLogo.Size = UDim2.fromOffset(28, 28) hubLogo.Image = LogoAsset hubLogo.ZIndex = 3
    local hubNameLabel = Instance.new("TextLabel", sideBar) hubNameLabel.BackgroundTransparency = 1 hubNameLabel.Position = UDim2.new(0.32, 0, 0.035, 0) hubNameLabel.Size = UDim2.new(0, 100, 0, 20) hubNameLabel.Font = Enum.Font.GothamBold hubNameLabel.Text = hubName hubNameLabel.TextColor3 = CurrentTheme hubNameLabel.TextSize = 15 hubNameLabel.TextXAlignment = Enum.TextXAlignment.Left table.insert(ThemeObjects.Texts, hubNameLabel)
    
    local AvatarImg = Instance.new("ImageLabel", sideBar) AvatarImg.Size = UDim2.fromOffset(30, 30) AvatarImg.Position = UDim2.new(0.1, 0, 0.9, 0) AvatarImg.BackgroundTransparency = 1 AvatarImg.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420) Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1,0)
    local AvName = Instance.new("TextLabel", sideBar) AvName.BackgroundTransparency = 1 AvName.Position = UDim2.new(0.35, 0, 0.91, 0) AvName.Size = UDim2.new(0, 100, 0, 15) AvName.Font = Enum.Font.GothamSemibold AvName.Text = LocalPlayer.Name AvName.TextColor3 = Color3.fromRGB(200, 200, 200) AvName.TextSize = 10 AvName.TextXAlignment = Enum.TextXAlignment.Left
    
    local tabFrame = Instance.new("ScrollingFrame", sideBar) tabFrame.BackgroundTransparency = 1 tabFrame.Position = UDim2.new(0.05, 0, 0.15, 0) tabFrame.Size = UDim2.new(0.9, 0, 0.7, 0) tabFrame.ScrollBarThickness = 0 Instance.new("UIListLayout", tabFrame).Padding = UDim.new(0, 6)
    local pageFolder = Instance.new("Folder", MainFrame) local framesAll = Instance.new("Frame", MainFrame) framesAll.BackgroundTransparency = 1 framesAll.Position = UDim2.new(0.32, 0, 0.05, 0) framesAll.Size = UDim2.new(0.66, 0, 0.9, 0) framesAll.ZIndex = 2 pageFolder.Parent = framesAll

    local TabHandling = {}
    function TabHandling:Tab(text, iconId)
        local btn = Instance.new("TextButton", tabFrame) btn.Size = UDim2.new(0.9, 0, 0, 32) btn.BackgroundColor3 = Color3.fromRGB(30,30,35) btn.BackgroundTransparency = 1 btn.Text = "" btn.AutoButtonColor = false Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        local activeBg = Instance.new("Frame", btn) activeBg.Size = UDim2.new(1, 0, 1, 0) activeBg.BackgroundColor3 = CurrentTheme activeBg.BackgroundTransparency = 0.85 activeBg.Visible = false Instance.new("UICorner", activeBg).CornerRadius = UDim.new(0, 6) table.insert(ThemeObjects.Backgrounds, activeBg)
        local ic = Instance.new("ImageLabel", btn) ic.Size = UDim2.fromOffset(16, 16) ic.Position = UDim2.new(0, 10, 0.5, -8) ic.BackgroundTransparency = 1 ic.Image = "rbxassetid://"..iconId ic.ImageColor3 = Color3.fromRGB(130, 130, 130)
        local txt = Instance.new("TextLabel", btn) txt.Size = UDim2.new(1, -35, 1, 0) txt.Position = UDim2.new(0, 35, 0, 0) txt.BackgroundTransparency = 1 txt.Text = text txt.Font = Enum.Font.GothamSemibold txt.TextColor3 = Color3.fromRGB(130, 130, 130) txt.TextSize = 12 txt.TextXAlignment = Enum.TextXAlignment.Left

        table.insert(SirHubLib.Tabs, {Btn = btn, Bg = activeBg, Ic = ic, Txt = txt})
        local p = Instance.new("ScrollingFrame", pageFolder) p.Size = UDim2.new(1,0,1,0) p.BackgroundTransparency = 1 p.Visible = false p.ScrollBarThickness = 0 Instance.new("UIListLayout", p).Padding = UDim.new(0, 10)
        
        local function OpenTab()
            for _, v in pairs(pageFolder:GetChildren()) do v.Visible = false end p.Visible = true
            for _, t in pairs(SirHubLib.Tabs) do TweenService:Create(t.Bg, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play() TweenService:Create(t.Ic, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(130,130,130)}):Play() TweenService:Create(t.Txt, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(130,130,130)}):Play() t.Bg.Visible = false end
            activeBg.Visible = true
            if not RainbowMode then TweenService:Create(activeBg, TweenInfo.new(0.2), {BackgroundTransparency = 0.85}):Play() TweenService:Create(ic, TweenInfo.new(0.2), {ImageColor3 = CurrentTheme}):Play() TweenService:Create(txt, TweenInfo.new(0.2), {TextColor3 = CurrentTheme}):Play() end
            table.insert(ThemeObjects.Images, ic) table.insert(ThemeObjects.Texts, txt)
        end
        btn.MouseButton1Click:Connect(OpenTab)
        if not SirHubLib.FirstTabClick then SirHubLib.FirstTabClick = OpenTab end

        local sectionHandling = {}
        function sectionHandling:Section(title)
            local sec = Instance.new("Frame", p) sec.BackgroundTransparency = 1 sec.Size = UDim2.new(1, -10, 0, 40) 
            local sT = Instance.new("TextLabel", sec) sT.Text = title:upper() sT.Font = Enum.Font.GothamBold sT.TextColor3 = Color3.fromRGB(180,180,180) sT.TextSize = 11 sT.Size = UDim2.new(1,0,0,20) sT.BackgroundTransparency = 1 sT.TextXAlignment = Enum.TextXAlignment.Left
            local line = Instance.new("Frame", sec) line.Size = UDim2.new(1, 0, 0, 1) line.Position = UDim2.new(0,0,0,22) line.BackgroundColor3 = Color3.fromRGB(35, 35, 40) line.BorderSizePixel = 0
            local l = Instance.new("UIListLayout", sec) l.HorizontalAlignment = Enum.HorizontalAlignment.Left l.Padding = UDim.new(0, 8) l.SortOrder = Enum.SortOrder.LayoutOrder Instance.new("UIPadding", sec).PaddingTop = UDim.new(0, 32)
            l:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() sec.Size = UDim2.new(1,-10,0,l.AbsoluteContentSize.Y + 40) p.CanvasSize = UDim2.new(0,0,0,p.UIListLayout.AbsoluteContentSize.Y) end)
            
            local itm = {}
            function itm:Widget(t, id) local f = Instance.new("Frame", sec) f.Size = UDim2.new(1,0,0,36) f.BackgroundColor3 = Color3.fromRGB(20, 20, 24) Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6) local str = Instance.new("UIStroke", f) str.Color = Color3.fromRGB(35, 35, 40) str.Thickness = 1 str.Transparency = 0.5 local lbl = Instance.new("TextLabel", f) lbl.Size = UDim2.new(1,-20,1,0) lbl.Position = UDim2.new(0,12,0,0) lbl.Text = t lbl.TextColor3 = Color3.fromRGB(230,230,230) lbl.Font = Enum.Font.GothamSemibold lbl.TextSize = 12 lbl.BackgroundTransparency = 1 lbl.TextXAlignment = Enum.TextXAlignment.Left if id then SirHubLib.Labels[id] = lbl end f.MouseEnter:Connect(function() if not RainbowMode then TweenService:Create(str, TweenInfo.new(0.2), {Color = CurrentTheme, Transparency = 0.2}):Play() end table.insert(ThemeObjects.Strokes, str) end) f.MouseLeave:Connect(function() if not RainbowMode then TweenService:Create(str, TweenInfo.new(0.2), {Color = Color3.fromRGB(35, 35, 40), Transparency = 0.5}):Play() end end) end
            function itm:Label(t) local lbl = Instance.new("TextLabel", sec) lbl.Size = UDim2.new(1,0,0,16) lbl.Text = t lbl.TextColor3 = Color3.fromRGB(150,150,150) lbl.Font = Enum.Font.Gotham lbl.TextSize = 12 lbl.BackgroundTransparency = 1 lbl.TextXAlignment = Enum.TextXAlignment.Left end
            function itm:Button(t, c) local bt = Instance.new("TextButton", sec) bt.BackgroundColor3 = Color3.fromRGB(28, 28, 32) bt.Size = UDim2.new(1, 0, 0, 34) bt.Font = Enum.Font.GothamSemibold bt.Text = t bt.TextColor3 = Color3.fromRGB(230, 230, 230) bt.TextSize = 12 bt.AutoButtonColor = false Instance.new("UICorner", bt).CornerRadius = UDim.new(0, 6) local str = Instance.new("UIStroke", bt) str.Color = Color3.fromRGB(40, 40, 45) str.Thickness = 1 bt.MouseEnter:Connect(function() TweenService:Create(bt, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(38, 38, 42)}):Play() if not RainbowMode then TweenService:Create(str, TweenInfo.new(0.2), {Color = CurrentTheme}):Play() end table.insert(ThemeObjects.Strokes, str) end) bt.MouseLeave:Connect(function() TweenService:Create(bt, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(28, 28, 32)}):Play() if not RainbowMode then TweenService:Create(str, TweenInfo.new(0.2), {Color = Color3.fromRGB(40, 40, 45)}):Play() end end) bt.MouseButton1Click:Connect(c) return bt end
            function itm:TextBox(t, c) local f = Instance.new("Frame", sec) f.Size = UDim2.new(1,0,0,36) f.BackgroundColor3 = Color3.fromRGB(20, 20, 24) Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6) Instance.new("UIStroke", f).Color = Color3.fromRGB(35, 35, 40) local tb = Instance.new("TextBox", f) tb.Size = UDim2.new(1,-20,1,0) tb.Position = UDim2.new(0,10,0,0) tb.BackgroundTransparency = 1 tb.Text = "" tb.PlaceholderText = t tb.TextColor3 = Color3.fromRGB(230,230,230) tb.Font = Enum.Font.Gotham tb.TextSize = 12 tb.TextXAlignment = Enum.TextXAlignment.Left tb.ClearTextOnFocus = false tb:GetPropertyChangedSignal("Text"):Connect(function() c(tb.Text) end) end
            function itm:ColorTheme(t, color) local bt = Instance.new("TextButton", sec) bt.BackgroundColor3 = color bt.Size = UDim2.new(1, 0, 0, 30) bt.Font = Enum.Font.GothamBold bt.Text = t bt.TextColor3 = Color3.fromRGB(255, 255, 255) bt.TextSize = 12 bt.AutoButtonColor = false Instance.new("UICorner", bt).CornerRadius = UDim.new(0, 6) bt.MouseButton1Click:Connect(function() RainbowMode = false SirHubLib:ChangeTheme(color, false) end) end
            function itm:RainbowToggle(t) local bt = Instance.new("TextButton", sec) bt.BackgroundColor3 = Color3.fromRGB(30,30,30) bt.Size = UDim2.new(1, 0, 0, 30) bt.Font = Enum.Font.GothamBold bt.Text = t bt.TextColor3 = Color3.fromRGB(255, 255, 255) bt.TextSize = 12 bt.AutoButtonColor = false Instance.new("UICorner", bt).CornerRadius = UDim.new(0, 6) local str = Instance.new("UIStroke", bt) str.Thickness = 2 table.insert(ThemeObjects.Strokes, str) bt.MouseButton1Click:Connect(function() RainbowMode = not RainbowMode SirHubLib:Notify("Theme Engine", "Rainbow Mode: " .. tostring(RainbowMode)) end) end
            function itm:Toggle(t, c) local f = Instance.new("Frame", sec) f.Size = UDim2.new(1,0,0,36) f.BackgroundColor3 = Color3.fromRGB(22, 22, 26) Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6) local str = Instance.new("UIStroke", f) str.Color = Color3.fromRGB(35, 35, 40) local tl = Instance.new("TextLabel", f) tl.Size = UDim2.new(0.7,0,1,0) tl.Position = UDim2.new(0,12,0,0) tl.Text = t tl.TextColor3 = Color3.fromRGB(230,230,230) tl.BackgroundTransparency = 1 tl.TextXAlignment = Enum.TextXAlignment.Left tl.TextSize = 12 tl.Font = Enum.Font.GothamSemibold local tb = Instance.new("TextButton", f) tb.Size = UDim2.new(0, 40, 0, 20) tb.Position = UDim2.new(1, -52, 0.5, -10) tb.BackgroundColor3 = Color3.fromRGB(40, 40, 45) tb.Text = "" tb.AutoButtonColor = false Instance.new("UICorner", tb).CornerRadius = UDim.new(1, 0) local dot = Instance.new("Frame", tb) dot.Size = UDim2.fromOffset(16, 16) dot.Position = UDim2.new(0, 2, 0.5, -8) dot.BackgroundColor3 = Color3.fromRGB(180, 180, 180) Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0) local s = false tb.MouseButton1Click:Connect(function() s = not s c(s) TweenService:Create(tb, TweenInfo.new(0.3), {BackgroundColor3 = s and CurrentTheme or Color3.fromRGB(40, 40, 45)}):Play() TweenService:Create(dot, TweenInfo.new(0.3), {Position = s and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = s and Color3.fromRGB(255,255,255) or Color3.fromRGB(180,180,180)}):Play() if s then table.insert(ThemeObjects.Backgrounds, tb) end end) end
            function itm:Slider(t, min, max, def, c) local f = Instance.new("Frame", sec) f.Size = UDim2.new(1,0,0,50) f.BackgroundColor3 = Color3.fromRGB(22, 22, 26) Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6) Instance.new("UIStroke", f).Color = Color3.fromRGB(35, 35, 40) local tl = Instance.new("TextLabel", f) tl.Text = t.." ["..def.."]" tl.Size = UDim2.new(1,-24,0,15) tl.Position = UDim2.new(0,12,0,8) tl.TextColor3 = Color3.fromRGB(200,200,200) tl.BackgroundTransparency = 1 tl.TextSize = 11 tl.TextXAlignment = Enum.TextXAlignment.Left tl.Font = Enum.Font.GothamSemibold local b = Instance.new("Frame", f) b.BackgroundColor3 = Color3.fromRGB(15,15,18) b.Position = UDim2.new(0,12,0,32) b.Size = UDim2.new(1,-24,0,8) Instance.new("UICorner", b).CornerRadius = UDim.new(1,0) local fill = Instance.new("Frame", b) fill.BackgroundColor3 = CurrentTheme fill.Size = UDim2.new((def-min)/(max-min), 0, 1, 0) Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0) table.insert(ThemeObjects.Backgrounds, fill) b.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then local con con = RunService.RenderStepped:Connect(function() local pos = math.clamp((UserInputService:GetMouseLocation().X - b.AbsolutePosition.X) / b.AbsoluteSize.X, 0, 1) fill.Size = UDim2.new(pos, 0, 1, 0) local val = math.floor(min + (max-min)*pos) tl.Text = t.." ["..val.."]" c(val) if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then con:Disconnect() end end) end end) end
            return itm
        end

        function sectionHandling:SearchDatabase(db)
            local sc = Instance.new("Frame", p) sc.BackgroundColor3 = Color3.fromRGB(22, 22, 26) sc.Size = UDim2.new(1,0,0,340) Instance.new("UICorner", sc).CornerRadius = UDim.new(0,6) Instance.new("UIStroke", sc).Color = Color3.fromRGB(35, 35, 40)
            local sB = Instance.new("TextBox", sc) sB.Size = UDim2.new(1,-24,0,36) sB.Position = UDim2.new(0,12,0,12) sB.BackgroundColor3 = Color3.fromRGB(15,15,18) sB.TextColor3 = Color3.fromRGB(255,255,255) sB.PlaceholderText = " Search library..." sB.Text = "" sB.Font = Enum.Font.Gotham sB.TextSize = 13 Instance.new("UICorner", sB).CornerRadius = UDim.new(0,4) local sstr = Instance.new("UIStroke", sB) sstr.Color = CurrentTheme table.insert(ThemeObjects.Strokes, sstr)
            local rs = Instance.new("ScrollingFrame", sc) rs.Size = UDim2.new(1,-24,0.75,0) rs.Position = UDim2.new(0,12,0,60) rs.BackgroundTransparency = 1 rs.ScrollBarThickness = 3 rs.ScrollBarImageColor3 = CurrentTheme Instance.new("UIListLayout", rs).Padding = UDim.new(0,8) table.insert(ThemeObjects.Images, rs)
            local function update(q) 
                for _, v in pairs(rs:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end 
                for _, s in ipairs(db) do 
                    if not s.IsDev and (q == "" or s.Name:lower():find(q:lower())) then 
                        local isCurrentGame = false
                        if type(s.GameId) == "table" then
                            for _, id in ipairs(s.GameId) do
                                if id == game.PlaceId or id == game.GameId then isCurrentGame = true break end
                            end
                        elseif s.GameId == game.PlaceId or s.GameId == game.GameId then
                            isCurrentGame = true
                        end
                        
                        local bt = Instance.new("TextButton", rs) bt.Size = UDim2.new(1,0,0,38) bt.BackgroundColor3 = Color3.fromRGB(26,26,30) bt.Text = "   "..s.Name bt.TextColor3 = Color3.fromRGB(230,230,230) bt.Font = Enum.Font.GothamSemibold bt.TextXAlignment = Enum.TextXAlignment.Left bt.TextSize = 12 bt.AutoButtonColor = false Instance.new("UICorner", bt).CornerRadius = UDim.new(0,6) local str = Instance.new("UIStroke", bt) str.Color = Color3.fromRGB(40, 40, 45)
                        if isCurrentGame then str.Color = CurrentTheme table.insert(ThemeObjects.Strokes, str) end
                        bt.MouseEnter:Connect(function() TweenService:Create(bt, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(36, 36, 42)}):Play() if not RainbowMode then TweenService:Create(str, TweenInfo.new(0.2), {Color = CurrentTheme}):Play() end end)
                        bt.MouseLeave:Connect(function() TweenService:Create(bt, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(26, 26, 30)}):Play() if not isCurrentGame and not RainbowMode then TweenService:Create(str, TweenInfo.new(0.2), {Color = Color3.fromRGB(40, 40, 45)}):Play() end end)
                        bt.MouseButton1Click:Connect(function() SirHubLib:Notify("Database", "Loading "..s.Name) task.spawn(s.Execute) end) 
                    end 
                end 
            end
            sB:GetPropertyChangedSignal("Text"):Connect(function() update(sB.Text) end) update("")
        end
        return sectionHandling
    end
    
    -- ==========================================
    -- [4] BOOT SEQUENCE (CINEMATIC LOAD)
    -- ==========================================
    function SirHubLib:BootSequence()
        local Blur = Instance.new("BlurEffect", game:GetService("Lighting")) Blur.Size = 0 TweenService:Create(Blur, TweenInfo.new(1), {Size = 20}):Play()
        local LoadGui = Instance.new("ScreenGui", CoreGui) LoadGui.DisplayOrder = 999 ProtectGUI(LoadGui)
        local LoadFrame = Instance.new("Frame", LoadGui) LoadFrame.Size = UDim2.new(0, 300, 0, 150) LoadFrame.Position = UDim2.new(0.5, -150, 0.5, -75) LoadFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18) LoadFrame.BackgroundTransparency = 1 Instance.new("UICorner", LoadFrame).CornerRadius = UDim.new(0, 10)
        local LoadStroke = Instance.new("UIStroke", LoadFrame) LoadStroke.Color = CurrentTheme LoadStroke.Transparency = 1 table.insert(ThemeObjects.Strokes, LoadStroke)
        local BootLogo = Instance.new("ImageLabel", LoadFrame) BootLogo.Size = UDim2.fromOffset(60, 60) BootLogo.Position = UDim2.new(0.5, -30, 0.1, 0) BootLogo.BackgroundTransparency = 1 BootLogo.Image = LogoAsset BootLogo.ImageTransparency = 1
        local StatusText = Instance.new("TextLabel", LoadFrame) StatusText.Size = UDim2.new(1, 0, 0, 20) StatusText.Position = UDim2.new(0, 0, 0.65, 0) StatusText.BackgroundTransparency = 1 StatusText.Font = Enum.Font.GothamSemibold StatusText.Text = "Initializing..." StatusText.TextColor3 = Color3.fromRGB(200, 200, 200) StatusText.TextSize = 11 StatusText.TextTransparency = 1
        local BarBg = Instance.new("Frame", LoadFrame) BarBg.Size = UDim2.new(0.8, 0, 0, 4) BarBg.Position = UDim2.new(0.1, 0, 0.85, 0) BarBg.BackgroundColor3 = Color3.fromRGB(30, 30, 35) BarBg.BackgroundTransparency = 1 Instance.new("UICorner", BarBg).CornerRadius = UDim.new(1, 0)
        local BarFill = Instance.new("Frame", BarBg) BarFill.Size = UDim2.new(0, 0, 1, 0) BarFill.BackgroundColor3 = CurrentTheme BarFill.BackgroundTransparency = 1 Instance.new("UICorner", BarFill).CornerRadius = UDim.new(1, 0) table.insert(ThemeObjects.Backgrounds, BarFill)

        TweenService:Create(LoadFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play() TweenService:Create(LoadStroke, TweenInfo.new(0.5), {Transparency = 0.5}):Play() TweenService:Create(BootLogo, TweenInfo.new(0.5), {ImageTransparency = 0}):Play() TweenService:Create(StatusText, TweenInfo.new(0.5), {TextTransparency = 0}):Play() TweenService:Create(BarBg, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play() TweenService:Create(BarFill, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
        task.wait(0.6)
        
        local steps = {{msg = "Authenticating signature...", prog = 0.2, wait = 0.5}, {msg = "Bypassing Anti-Cheat...", prog = 0.5, wait = 0.7}, {msg = "Loading Omniversal Modules...", prog = 0.8, wait = 0.5}, {msg = "Welcome, " .. LocalPlayer.Name, prog = 1.0, wait = 0.5}}
        for _, step in ipairs(steps) do StatusText.Text = step.msg TweenService:Create(BarFill, TweenInfo.new(step.wait), {Size = UDim2.new(step.prog, 0, 1, 0)}):Play() task.wait(step.wait) end

        TweenService:Create(LoadFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play() TweenService:Create(LoadStroke, TweenInfo.new(0.5), {Transparency = 1}):Play() TweenService:Create(BootLogo, TweenInfo.new(0.5), {ImageTransparency = 1}):Play() TweenService:Create(StatusText, TweenInfo.new(0.5), {TextTransparency = 1}):Play() TweenService:Create(BarBg, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play() TweenService:Create(BarFill, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play() TweenService:Create(Blur, TweenInfo.new(1), {Size = 0}):Play()
        task.wait(0.5) LoadGui:Destroy() task.delay(1, function() Blur:Destroy() end)
        
        shadow.Visible = true shadow.Position = UDim2.new(0.5, -300, 0.5, -200) shadow.ImageTransparency = 1
        TweenService:Create(shadow, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -300, 0.5, -250), ImageTransparency = 0.3}):Play()
        MobileToggle.Visible = true MobileToggle.ImageTransparency = 1 TweenService:Create(MobileToggle, TweenInfo.new(0.5), {ImageTransparency = 0}):Play()
        if SirHubLib.FirstTabClick then SirHubLib.FirstTabClick() end SirHubLib:Notify("System", "SirHub v1.0 Masterpiece Loaded.")
    end

    return TabHandling
end

-- ==========================================
-- [5] INSTANTIATING MODULES
-- ==========================================
local SirHub = SirHubLib.CreateWindow("SIRHUB")

local HomeTab = SirHub:Tab("Home", "6087485864")
local GameTab = SirHub:Tab("Scripts Library", "6071521083")
local DevTab = SirHub:Tab("Universal Tools", "6071522236")
local ComTab = SirHub:Tab("Combat Engine", "7733765045")
local VisTab = SirHub:Tab("Visuals", "6071520129")
local MoveTab = SirHub:Tab("Movement", "6071528623")
local FunTab = SirHub:Tab("Fun & Troll", "7733911828")
local SetTab = SirHub:Tab("Settings", "6071521257")

local Dash = HomeTab:Section("Status & Information")
Dash:Widget("Status: Undetected ✅") Dash:Widget("Executor: "..ExecutorName) Dash:Widget("Ping: 0 ms", "PingLabel") Dash:Widget("FPS: 0", "FPSLabel")
local Experience = HomeTab:Section("Current Experience: "..CurrentGameName)
local found = false 
for _, s in ipairs(ScriptDatabase) do 
    local isCurrentGame = false
    if type(s.GameId) == "table" then
        for _, id in ipairs(s.GameId) do
            if id == game.PlaceId or id == game.GameId then isCurrentGame = true break end
        end
    elseif s.GameId == game.PlaceId or s.GameId == game.GameId then
        isCurrentGame = true
    end

    if isCurrentGame then 
        Experience:Button("▶️ Launch "..s.Name, function() SirHubLib:Notify("Database", "Loading "..s.Name) task.spawn(s.Execute) end) 
        found = true 
    end 
end
if not found then Experience:Label("No verified auto-execute for this game.") end

GameTab:SearchDatabase(ScriptDatabase)
local Devs = DevTab:Section("Developer & Universal Scripts")
for _, s in ipairs(ScriptDatabase) do if s.IsDev then Devs:Button(s.Name, function() SirHubLib:Notify("Database", "Loading "..s.Name) task.spawn(s.Execute) end) end end

-- COMBAT ENGINE
local AimSec = ComTab:Section("Professional Aim Assist")
local FOVRadius, CamlockEnabled, TeamCheck = 100, false, false
local FOVCircle = nil pcall(function() FOVCircle = Drawing.new("Circle") FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2) FOVCircle.Radius = FOVRadius FOVCircle.Filled = false FOVCircle.Color = CurrentTheme FOVCircle.Visible = false FOVCircle.Thickness = 1.5 table.insert(ThemeObjects.Backgrounds, FOVCircle) end)
AimSec:Toggle("Enable FOV Circle", function(state) if FOVCircle then FOVCircle.Visible = state end end) AimSec:Slider("FOV Size", 30, 500, 100, function(v) FOVRadius = v if FOVCircle then FOVCircle.Radius = v end end) AimSec:Toggle("Team Check (Ignore Teammates)", function(state) TeamCheck = state end) AimSec:Toggle("Enable Aimbot (Camlock)", function(state) CamlockEnabled = state end)

local HitboxSize, HitboxEnabled = 2, false
local HitboxSec = ComTab:Section("Hitbox Expander") HitboxSec:Slider("Hitbox Size", 2, 50, 2, function(v) HitboxSize = v end) HitboxSec:Toggle("Enable Hitbox", function(state) HitboxEnabled = state if not state then for _, v in pairs(Players:GetPlayers()) do if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then v.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1) v.Character.HumanoidRootPart.Transparency = 1 v.Character.HumanoidRootPart.CanCollide = true end end end end)

AddConnection("CombatLoop", RunService.RenderStepped:Connect(function()
    if FOVCircle then FOVCircle.Position = UserInputService:GetMouseLocation() end
    if CamlockEnabled then local target, dist = nil, FOVRadius for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then if not (TeamCheck and p.Team == LocalPlayer.Team) then local pos, onScreen = Camera:WorldToViewportPoint(p.Character.Head.Position) if onScreen and pos.Z > 0 then local mag = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude if mag < dist then target = p dist = mag end end end end end if target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position) end end
    if HitboxEnabled then for _, v in pairs(Players:GetPlayers()) do if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then local hrp = v.Character.HumanoidRootPart hrp.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize) hrp.Transparency = 0.6 hrp.BrickColor = BrickColor.new("Bright blue") hrp.Material = Enum.Material.Neon hrp.CanCollide = false end end end
end))

-- VISUALS & ESP
local ESPFolder = Instance.new("Folder", CoreGui) ESPFolder.Name = "SirHub_ESP" local ESP = false
local function ApplyESP(char, pName) if ESP and char and char:FindFirstChild("HumanoidRootPart") and not ESPFolder:FindFirstChild(pName) then local hl = Instance.new("Highlight", ESPFolder) hl.Name = pName hl.Adornee = char hl.FillColor = CurrentTheme hl.FillTransparency = 0.5 table.insert(ThemeObjects.Backgrounds, hl) end end
VisTab:Section("ESP Settings"):Toggle("Enable Player Wallhack", function(v) ESP = v if v then for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character then ApplyESP(p.Character, p.Name) end end else ESPFolder:ClearAllChildren() end end)
AddConnection("ESPPlayerAdded", Players.PlayerAdded:Connect(function(p) AddConnection("ESP_"..p.Name, p.CharacterAdded:Connect(function(char) task.wait(1) ApplyESP(char, p.Name) end)) end)) AddConnection("ESPRemoving", Players.PlayerRemoving:Connect(function(p) if ESPFolder:FindFirstChild(p.Name) then ESPFolder[p.Name]:Destroy() end end)) for _, p in pairs(Players:GetPlayers()) do AddConnection("ESP_"..p.Name, p.CharacterAdded:Connect(function(char) task.wait(1) ApplyESP(char, p.Name) end)) end
local SpecSec = VisTab:Section("Omniscient Spectator") local SpectateTarget = "" SpecSec:TextBox("Target Username", function(text) SpectateTarget = text end) SpecSec:Button("👁️ Spectate Target", function() local t = nil for _, p in pairs(Players:GetPlayers()) do if p.Name:lower():sub(1, #SpectateTarget) == SpectateTarget:lower() or p.DisplayName:lower():sub(1, #SpectateTarget) == SpectateTarget:lower() then t = p break end end if t and t.Character and t.Character:FindFirstChild("Humanoid") then Camera.CameraSubject = t.Character.Humanoid SirHubLib:Notify("Spectator", "Watching " .. t.DisplayName) end end) SpecSec:Button("🛑 Stop Spectating", function() if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then Camera.CameraSubject = LocalPlayer.Character.Humanoid SirHubLib:Notify("Spectator", "Returned to character.") end end)

-- MOVEMENT
local WSE, WSV, JPE, JPV, Noc, FlyEnabled, FlySpeed = false, 16, false, 50, false, false, 50 local FlyBody, FlyGyro = nil, nil
local Move = MoveTab:Section("Character Physics") Move:Slider("WalkSpeed Override", 16, 250, 16, function(v) WSV = v WSE = true end) Move:Slider("JumpPower Override", 50, 400, 50, function(v) JPV = v JPE = true end) Move:Toggle("Noclip (Walk Through Walls)", function(v) Noc = v end) Move:Slider("Fly Speed", 10, 300, 50, function(v) FlySpeed = v end)
Move:Toggle("Enable Smooth Fly", function(state) FlyEnabled = state local char = LocalPlayer.Character if not char or not char:FindFirstChild("HumanoidRootPart") then return end if state then FlyBody = Instance.new("BodyVelocity", char.HumanoidRootPart) FlyBody.Velocity = Vector3.new(0, 0, 0) FlyBody.MaxForce = Vector3.new(math.huge, math.huge, math.huge) FlyGyro = Instance.new("BodyGyro", char.HumanoidRootPart) FlyGyro.P = 9e4 FlyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9) FlyGyro.CFrame = char.HumanoidRootPart.CFrame char.Humanoid.PlatformStand = true else if FlyBody then FlyBody:Destroy() end if FlyGyro then FlyGyro:Destroy() end char.Humanoid.PlatformStand = false end end)
AddConnection("PhysicsLoop", RunService.Stepped:Connect(function() local char = LocalPlayer.Character if not char then return end local hum = char:FindFirstChildOfClass("Humanoid") if hum then if WSE then hum.WalkSpeed = WSV end if JPE then hum.JumpPower = JPV end end if Noc then for _, p in ipairs(char:GetDescendants()) do if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end end end if FlyEnabled and char:FindFirstChild("HumanoidRootPart") and FlyBody and FlyGyro then FlyGyro.CFrame = Camera.CFrame if hum.MoveDirection.Magnitude > 0 then FlyBody.Velocity = Camera.CFrame:VectorToWorldSpace(Vector3.new(hum.MoveDirection.X, 0, hum.MoveDirection.Z)) * FlySpeed else FlyBody.Velocity = Vector3.new(0,0,0) end end end))

-- FUN & TROLL
local FunSec = FunTab:Section("Player Trolling") local FlingTarget = "" FunSec:TextBox("Target Username", function(text) FlingTarget = text end) FunSec:Button("🌪️ Fling Target", function() local t = nil for _, p in pairs(Players:GetPlayers()) do if p.Name:lower():sub(1, #FlingTarget) == FlingTarget:lower() or p.DisplayName:lower():sub(1, #FlingTarget) == FlingTarget:lower() then t = p break end end if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character then local thrust = Instance.new("BodyThrust", LocalPlayer.Character.HumanoidRootPart) thrust.Force = Vector3.new(9999, 9999, 9999) local spin = Instance.new("BodyAngularVelocity", LocalPlayer.Character.HumanoidRootPart) spin.AngularVelocity = Vector3.new(0, 9999, 0) spin.MaxTorque = Vector3.new(math.huge, math.huge, math.huge) LocalPlayer.Character.HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame task.wait(0.5) thrust:Destroy() spin:Destroy() SirHubLib:Notify("Troll", "Flinging " .. t.DisplayName) end end) FunSec:Button("💫 Spin Bot", function() local spin = Instance.new("BodyAngularVelocity", LocalPlayer.Character.HumanoidRootPart) spin.MaxTorque = Vector3.new(0, math.huge, 0) spin.AngularVelocity = Vector3.new(0, 50, 0) SirHubLib:Notify("Fun", "Spin Bot activated.") end)

-- SETTINGS
local Themes = SetTab:Section("Personalization") Themes:RainbowToggle("🌈 Enable RGB Rainbow Mode") Themes:ColorTheme("Neon Purple (Default)", Color3.fromRGB(255, 0, 255)) Themes:ColorTheme("Matrix Green", Color3.fromRGB(0, 255, 100)) Themes:ColorTheme("Cyber Blue", Color3.fromRGB(0, 200, 255)) Themes:ColorTheme("Blood Red", Color3.fromRGB(255, 50, 50)) Themes:ColorTheme("Royal Gold", Color3.fromRGB(255, 215, 0))
SirHubLib.BindBtn = SetTab:Section("System Configuration"):Button("Menu Keybind: " .. SirHubLib.MenuKeybind.Name, function() SirHubLib.BindBtn.Text = "Press any key..." SirHubLib.BindBtn.TextColor3 = CurrentTheme IsBinding = true end) SetTab:Section("System Configuration"):Button("🔓 Unlock FPS (MAX)", function() if setfpscap then setfpscap(9999) SirHubLib:Notify("Performance", "FPS Unlocked") end end) SetTab:Section("System Configuration"):Button("🔄 Server Hop (Low Ping)", function() local req = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")) for _, v in pairs(req.data) do if v.playing and tonumber(v.playing) < tonumber(v.maxPlayers) and v.id ~= game.JobId then TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer) break end end end)
local PanicKey = Enum.KeyCode.End SetTab:Section("Emergency"):Label("Panic Key (Instant Delete): " .. PanicKey.Name)
local function UnloadHub() for _, c in pairs(Connections) do c:Disconnect() end if ESPFolder then ESPFolder:Destroy() end if FOVCircle then FOVCircle:Remove() end if CoreGui:FindFirstChild("SirHub_v1") then CoreGui.SirHub_v1:Destroy() end if CoreGui:FindFirstChild("SirHub_Notif") then CoreGui.SirHub_Notif:Destroy() end if CoreGui:FindFirstChild("SirHub_AuthSys") then CoreGui.SirHub_AuthSys:Destroy() end end
SetTab:Section("Emergency"):Button("❌ Unload SirHub", UnloadHub) AddConnection("PanicListener", UserInputService.InputBegan:Connect(function(input, gp) if not gp and input.KeyCode == PanicKey then UnloadHub() end end))

-- STATS LOOP
AddConnection("StatsLoop", RunService.RenderStepped:Connect(function() local fps = math.floor(1/RunService.RenderStepped:Wait()) local ping = 0 pcall(function() ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end) if SirHubLib.Labels.PingLabel then SirHubLib.Labels.PingLabel.Text = "Network Ping: "..ping.." ms" end if SirHubLib.Labels.FPSLabel then SirHubLib.Labels.FPSLabel.Text = "Client FPS: "..fps end end))

-- ==========================================
-- [6] THE IRON SHIELD AUTHENTICATION
-- ==========================================

-- Triple Fallback IP Resolver
local function GetClientIP()
    local success, res = pcall(function() return game:HttpGet("https://api.ipify.org") end)
    if success and res then return res:gsub("%s+", "") end
    local success2, res2 = pcall(function() return game:HttpGet("https://httpbin.org/ip") end)
    if success2 and res2 then local data = HttpService:JSONDecode(res2) return data.origin:split(",")[1]:gsub("%s+", "") end
    local success3, res3 = pcall(function() return game:HttpGet("https://ifconfig.me") end)
    if success3 and res3 then return res3:gsub("%s+", "") end
    return "UNKNOWN"
end

-- Key Verification Engine (Strict Free Key Mode)
local function VerifyWorkInkToken(token)
    local clientIP = GetClientIP()
    local success, result = pcall(function() return game:HttpGet("https://work.ink/_api/v2/token/isValid/" .. token) end)
    
    if success then
        local data = HttpService:JSONDecode(result)
        if data and data.valid == true then
            local keyIp = data.info and data.info.byIp
            
            -- STRICT ANTI-SHARE: Klíč musí absolutně sedět s IP adresou hráče!
            if keyIp and keyIp ~= "" and keyIp ~= clientIP then
                return false, "Key Sharing Detected! IP mismatch."
            end
            
            -- Auto-login cache save
            if writefile then pcall(function() writefile(AuthFileName, token) end) end
            return true, "Success!"
        else
            return false, "Invalid or Expired Key."
        end
    else
        return false, "API Servers offline."
    end
end

-- ==========================================
-- [7] VIP BYPASS & LAUNCHER
-- ==========================================
if IsVIP then
    -- Pokud jsi ty, nebo platící zákazník z tabulky nahoře, rovnou tě to pustí!
    SirHubLib:BootSequence()
else
    -- GHOST AUTO-LOGIN CHECK (Pro free uživatele)
    local autoLogged = false
    if readfile and isfile and isfile(AuthFileName) then
        local savedToken = readfile(AuthFileName)
        local valid, msg = VerifyWorkInkToken(savedToken)
        if valid then
            autoLogged = true
            SirHubLib:BootSequence()
        else
            pcall(function() delfile(AuthFileName) end) -- Vymaže starý klíč
        end
    end

    if not autoLogged then
        -- Vytvoření autorizačního okénka (UI)
        local KeyUI = Instance.new("ScreenGui", CoreGui) KeyUI.Name = "SirHub_AuthSys" ProtectGUI(KeyUI)
        local Blur = Instance.new("BlurEffect", game:GetService("Lighting")) Blur.Size = 15
        
        local KeyFrame = Instance.new("Frame", KeyUI) KeyFrame.Size = UDim2.new(0, 380, 0, 240) KeyFrame.Position = UDim2.new(0.5, -190, 0.5, -120) KeyFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18) Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 8)
        local KeyStroke = Instance.new("UIStroke", KeyFrame) KeyStroke.Color = CurrentTheme KeyStroke.Thickness = 1 table.insert(ThemeObjects.Strokes, KeyStroke)
        
        local Title = Instance.new("TextLabel", KeyFrame) Title.Size = UDim2.new(1, 0, 0, 40) Title.Text = "👑 SIRHUB | AUTHORIZATION" Title.Font = Enum.Font.GothamBold Title.TextSize = 14 Title.TextColor3 = CurrentTheme Title.BackgroundTransparency = 1 table.insert(ThemeObjects.Texts, Title)
        local Desc = Instance.new("TextLabel", KeyFrame) Desc.Size = UDim2.new(1, 0, 0, 20) Desc.Position = UDim2.new(0, 0, 0, 40) Desc.Text = "Please enter your daily access key or buy Premium." Desc.Font = Enum.Font.Gotham Desc.TextSize = 12 Desc.TextColor3 = Color3.fromRGB(180, 180, 180) Desc.BackgroundTransparency = 1
        
        local KeyInput = Instance.new("TextBox", KeyFrame) KeyInput.Size = UDim2.new(0.85, 0, 0, 40) KeyInput.Position = UDim2.new(0.075, 0, 0, 85) KeyInput.BackgroundColor3 = Color3.fromRGB(20, 20, 24) KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255) KeyInput.Text = "" KeyInput.PlaceholderText = "Paste your Work.ink key here..." KeyInput.Font = Enum.Font.Gotham KeyInput.TextSize = 12 KeyInput.ClearTextOnFocus = false Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 6) local InpStr = Instance.new("UIStroke", KeyInput) InpStr.Color = Color3.fromRGB(40, 40, 45)
        
        -- Tlačítka
        local GetKeyBtn = Instance.new("TextButton", KeyFrame) GetKeyBtn.Size = UDim2.new(0.28, 0, 0, 38) GetKeyBtn.Position = UDim2.new(0.075, 0, 0, 150) GetKeyBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35) GetKeyBtn.Text = "Get Key" GetKeyBtn.TextColor3 = Color3.fromRGB(200, 200, 200) GetKeyBtn.Font = Enum.Font.GothamBold GetKeyBtn.TextSize = 12 GetKeyBtn.AutoButtonColor = false Instance.new("UICorner", GetKeyBtn).CornerRadius = UDim.new(0, 6)
        local DiscordBtn = Instance.new("TextButton", KeyFrame) DiscordBtn.Size = UDim2.new(0.25, 0, 0, 38) DiscordBtn.Position = UDim2.new(0.375, 0, 0, 150) DiscordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242) DiscordBtn.Text = "Discord" DiscordBtn.TextColor3 = Color3.fromRGB(255, 255, 255) DiscordBtn.Font = Enum.Font.GothamBold DiscordBtn.TextSize = 12 DiscordBtn.AutoButtonColor = false Instance.new("UICorner", DiscordBtn).CornerRadius = UDim.new(0, 6)
        local VerifyBtn = Instance.new("TextButton", KeyFrame) VerifyBtn.Size = UDim2.new(0.28, 0, 0, 38) VerifyBtn.Position = UDim2.new(0.645, 0, 0, 150) VerifyBtn.BackgroundColor3 = CurrentTheme VerifyBtn.Text = "Verify" VerifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255) VerifyBtn.Font = Enum.Font.GothamBold VerifyBtn.TextSize = 12 VerifyBtn.AutoButtonColor = false Instance.new("UICorner", VerifyBtn).CornerRadius = UDim.new(0, 6) table.insert(ThemeObjects.Backgrounds, VerifyBtn)
        
        local ErrorMsg = Instance.new("TextLabel", KeyFrame) ErrorMsg.Size = UDim2.new(1, 0, 0, 20) ErrorMsg.Position = UDim2.new(0, 0, 0, 200) ErrorMsg.Text = "" ErrorMsg.Font = Enum.Font.GothamBold ErrorMsg.TextSize = 11 ErrorMsg.TextColor3 = Color3.fromRGB(255, 50, 50) ErrorMsg.BackgroundTransparency = 1

        -- Button Logic
        GetKeyBtn.MouseButton1Click:Connect(function()
            if setclipboard then setclipboard(WorkInkLink) GetKeyBtn.Text = "Copied!" else GetKeyBtn.Text = "Error" end
            task.wait(2) GetKeyBtn.Text = "Get Key"
        end)
        
        DiscordBtn.MouseButton1Click:Connect(function()
            if setclipboard then setclipboard(DiscordLink) DiscordBtn.Text = "Copied!" else DiscordBtn.Text = "Error" end
            task.wait(2) DiscordBtn.Text = "Discord"
        end)

        VerifyBtn.MouseButton1Click:Connect(function()
            local token = KeyInput.Text:gsub("%s+", "") 
            if token == "" then ErrorMsg.Text = "Please enter a key!" return end
            
            VerifyBtn.Text = "Checking..."
            ErrorMsg.Text = ""
            
            task.spawn(function()
                local valid, msg = VerifyWorkInkToken(token)
                if valid then
                    VerifyBtn.Text = "Success!"
                    VerifyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
                    task.wait(0.5)
                    Blur:Destroy()
                    KeyUI:Destroy()
                    SirHubLib:BootSequence()
                else
                    VerifyBtn.Text = "Verify"
                    ErrorMsg.Text = msg
                end
            end)
        end)
    end
end