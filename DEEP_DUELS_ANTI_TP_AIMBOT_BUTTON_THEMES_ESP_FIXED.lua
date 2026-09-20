--============================================================
-- DEEP DUELS - INTRO + SCRIPT PRINCIPAL
-- Intro de 20s em tela cheia, música e botão Pular Intro
--============================================================

local function runDeepDuelsIntro()
    --// DEEP DUELS - INTRO (20 segundos)
    --// Tela cheia + música + botão para pular

    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local SoundService = game:GetService("SoundService")
    local ContentProvider = game:GetService("ContentProvider")

    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    local INTRO_DURATION = 20
    local skipped = false
    local finished = false

    -- Remove uma intro anterior, caso exista
    local oldGui = playerGui:FindFirstChild("DeepDuelsIntro")
    if oldGui then
        oldGui:Destroy()
    end

    -- Remove música anterior, caso exista
    local oldMusic = SoundService:FindFirstChild("DeepDuelsMusic")
    if oldMusic then
        oldMusic:Stop()
        oldMusic:Destroy()
    end

    -- GUI em tela cheia
    local gui = Instance.new("ScreenGui")
    gui.Name = "DeepDuelsIntro"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 999999
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = playerGui

    -- Tenta ignorar também as áreas seguras em versões que suportam isso
    pcall(function()
        gui.ScreenInsets = Enum.ScreenInsets.None
        gui.ClipToDeviceSafeArea = false
    end)

    -- Fundo base cobrindo a tela inteira
    local background = Instance.new("Frame")
    background.Name = "FullScreenBackground"
    background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    background.BorderSizePixel = 0
    background.Size = UDim2.fromScale(1, 1)
    background.Position = UDim2.fromScale(0, 0)
    background.ZIndex = 1
    background.Parent = gui

    -- Painéis para o efeito de entrada/saída
    local left = Instance.new("Frame")
    left.Name = "LeftPanel"
    left.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    left.BorderSizePixel = 0
    left.Size = UDim2.fromScale(0.5, 1)
    left.Position = UDim2.fromScale(-0.5, 0)
    left.ZIndex = 3
    left.Parent = gui

    local right = Instance.new("Frame")
    right.Name = "RightPanel"
    right.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    right.BorderSizePixel = 0
    right.Size = UDim2.fromScale(0.5, 1)
    right.Position = UDim2.fromScale(1, 0)
    right.ZIndex = 3
    right.Parent = gui

    -- Título
    local title = Instance.new("TextLabel")
    title.Name = "DeepDuelsTitle"
    title.BackgroundTransparency = 1
    title.Size = UDim2.fromScale(0.9, 0.18)
    title.AnchorPoint = Vector2.new(0.5, 0.5)
    title.Position = UDim2.fromScale(0.5, 0.48)
    title.Text = "Deep Duels"
    title.TextColor3 = Color3.fromRGB(0, 0, 0)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.TextTransparency = 1
    title.ZIndex = 10
    title.Parent = gui

    local titleConstraint = Instance.new("UITextSizeConstraint")
    titleConstraint.MinTextSize = 28
    titleConstraint.MaxTextSize = 90
    titleConstraint.Parent = title

    -- Subtítulo simples
    local subtitle = Instance.new("TextLabel")
    subtitle.Name = "Subtitle"
    subtitle.BackgroundTransparency = 1
    subtitle.Size = UDim2.fromScale(0.8, 0.06)
    subtitle.AnchorPoint = Vector2.new(0.5, 0.5)
    subtitle.Position = UDim2.fromScale(0.5, 0.59)
    subtitle.Text = "Prepare-se para o duelo"
    subtitle.TextColor3 = Color3.fromRGB(45, 45, 45)
    subtitle.TextScaled = true
    subtitle.Font = Enum.Font.GothamMedium
    subtitle.TextTransparency = 1
    subtitle.ZIndex = 10
    subtitle.Parent = gui

    local subConstraint = Instance.new("UITextSizeConstraint")
    subConstraint.MinTextSize = 14
    subConstraint.MaxTextSize = 28
    subConstraint.Parent = subtitle

    -- Botão Pular Intro
    local skipButton = Instance.new("TextButton")
    skipButton.Name = "SkipButton"
    skipButton.AnchorPoint = Vector2.new(1, 1)
    skipButton.Position = UDim2.new(1, -24, 1, -24)
    skipButton.Size = UDim2.fromOffset(150, 48)
    skipButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    skipButton.BackgroundTransparency = 0.12
    skipButton.BorderSizePixel = 0
    skipButton.Text = "Pular Intro"
    skipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    skipButton.TextSize = 18
    skipButton.Font = Enum.Font.GothamBold
    skipButton.AutoButtonColor = true
    skipButton.ZIndex = 20
    skipButton.Parent = gui

    local skipCorner = Instance.new("UICorner")
    skipCorner.CornerRadius = UDim.new(0, 10)
    skipCorner.Parent = skipButton

    -- Música
    local music = Instance.new("Sound")
    music.Name = "DeepDuelsMusic"
    music.SoundId = "rbxassetid://85284792077432"
    music.Volume = 0.7
    music.Looped = false
    music.Parent = SoundService

    -- Começa a música imediatamente; o Roblox termina de carregar o áudio se necessário
    music:Play()

    -- Pré-carregamento extra em paralelo (não atrasa a intro)
    task.spawn(function()
        pcall(function()
            ContentProvider:PreloadAsync({music})
        end)
    end)

    -- Tweens
    local slideIn = TweenInfo.new(0.8, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local textIn = TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local textOut = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    local slideOut = TweenInfo.new(0.8, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)

    local function cleanup(fast)
        if finished then
            return
        end

        finished = true

        if music then
            music:Stop()
        end

        if not gui or not gui.Parent then
            if music then
                music:Destroy()
            end
            return
        end

        if fast then
            local fadeInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            TweenService:Create(background, fadeInfo, {BackgroundTransparency = 1}):Play()
            TweenService:Create(left, fadeInfo, {BackgroundTransparency = 1}):Play()
            TweenService:Create(right, fadeInfo, {BackgroundTransparency = 1}):Play()
            TweenService:Create(title, fadeInfo, {TextTransparency = 1}):Play()
            TweenService:Create(subtitle, fadeInfo, {TextTransparency = 1}):Play()
            TweenService:Create(skipButton, fadeInfo, {
                BackgroundTransparency = 1,
                TextTransparency = 1
            }):Play()
            task.wait(0.27)
        end

        if gui and gui.Parent then
            gui:Destroy()
        end

        if music then
            music:Destroy()
        end
    end

    skipButton.Activated:Connect(function()
        if finished then
            return
        end
        skipped = true
        cleanup(true)
    end)

    -- Início da intro
    local introStarted = os.clock()

    -- Painéis entram
    TweenService:Create(left, slideIn, {Position = UDim2.fromScale(0, 0)}):Play()
    TweenService:Create(right, slideIn, {Position = UDim2.fromScale(0.5, 0)}):Play()

    task.wait(0.8)
    if skipped or finished then return end

    -- Texto aparece
    TweenService:Create(title, textIn, {TextTransparency = 0}):Play()
    TweenService:Create(subtitle, TweenInfo.new(0.9), {TextTransparency = 0}):Play()

    -- Pequeno efeito contínuo no título enquanto a intro permanece na tela
    task.spawn(function()
        while not skipped and not finished do
            local grow = TweenService:Create(title, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Size = UDim2.fromScale(0.94, 0.19)
            })
            grow:Play()
            grow.Completed:Wait()

            if skipped or finished then break end

            local shrink = TweenService:Create(title, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Size = UDim2.fromScale(0.9, 0.18)
            })
            shrink:Play()
            shrink.Completed:Wait()
        end
    end)

    -- Mantém a intro até perto dos 20 segundos totais
    while not skipped and not finished do
        local elapsed = os.clock() - introStarted
        if elapsed >= (INTRO_DURATION - 1.2) then
            break
        end
        task.wait(0.05)
    end

    if skipped or finished then return end

    -- Saída final
    TweenService:Create(title, textOut, {TextTransparency = 1}):Play()
    TweenService:Create(subtitle, textOut, {TextTransparency = 1}):Play()
    TweenService:Create(skipButton, TweenInfo.new(0.3), {
        BackgroundTransparency = 1,
        TextTransparency = 1
    }):Play()

    task.wait(0.4)
    if skipped or finished then return end

    -- Tira o fundo base para revelar o jogo conforme os painéis se afastam
    background.Visible = false

    TweenService:Create(left, slideOut, {Position = UDim2.fromScale(-0.5, 0)}):Play()
    TweenService:Create(right, slideOut, {Position = UDim2.fromScale(1, 0)}):Play()

    task.wait(0.8)
    if skipped or finished then return end

    cleanup(false)
end

runDeepDuelsIntro()

--============================================================
-- SCRIPT PRINCIPAL
--============================================================

repeat task.wait() until game:IsLoaded() 
local Players,RunService,UIS,TS,Lighting,HS = game:GetService("Players"),game:GetService("RunService"),game:GetService("UserInputService"),game:GetService("TweenService"),game:GetService("Lighting"),game:GetService("HttpService") 
local LP = Players.LocalPlayer 
local NS,CS = 60,29 
local LAGGER_SPEED = 15 
local LAGGER_CARRY_SPEED = 24.5 
local speedMode,antiRagdollEnabled,infJumpEnabled = false,false,false 
local laggerToggled = true 
local laggerPhase = 0 
local medusaCounterEnabled = false 
local batCounterEnabled = false 
local unwalkEnabled = false 
local medusaDebounce,medusaLastUsed,dropActive = false,0,false 
local autoLeftEnabled,autoRightEnabled = false,false 
local autoLeftSetVisual,autoRightSetVisual = nil,nil 
local speedLabel = nil 
local autoBatEnabled = false 
local autoSwingEnabled = true 
local autoBatSetVisual = nil 
local _autoBatTarget = nil 
local resetAutoBatMotion = nil 
local _batSwingCooldown = 0 
local BAT_SWING_INTERVAL = 0.08 
local AUTO_BAT_SPEED = 60 
local setBatCounterVisual = nil 
local startBatCounter,stopBatCounter


local antiLagEnabled = false 
local removeAccessoriesEnabled = false 
local antiLagDescConn = nil 
local stretchRezEnabled = false 
local stretchRezConn = nil 
local setStretchRezVisual = nil 
local unwalkSavedAnimate = nil 
local _anyKeyListening = false 
local autoTPConn = nil 
local setAutoTPVisual = nil 
local cursedResetRemote = nil 
local CURSED_RESET_GUID = "f888ee6e-c86d-46e1-93d7-0639d6635d42" 
local stealBarContainer = nil 
local function canUseAutoPath() return true end 
local function forceWalkSpeed() 
    local char = LP.Character 
    if char then 
        local hum = char:FindFirstChildOfClass("Humanoid") 
        if hum and hum.WalkSpeed < 30 then hum.WalkSpeed = 30 end 
    end 
end 
game:GetService("RunService").Heartbeat:Connect(forceWalkSpeed) 
task.spawn(function() 
    local BLACKLIST_URL="https://pastebin.com/2zLUXv2K" 
    pcall(function() HS.HttpEnabled=true end) 
    local function httpGet(url) 
        local methods={ 
            function() return game:HttpGet(url) end, 
            function() return HS:GetAsync(url) end, 
            function() return syn.request({Url=url,Method="GET"}).Body end, 
            function() return http_request({Url=url,Method="GET"}).Body end, 
            function() return request({Url=url,Method="GET"}).Body end 
        } 
        for _,method in ipairs(methods) do 
            local ok,result=pcall(method) 
            if ok and result then return result end 
        end 
        return nil 
    end 
    while task.wait(3) do 
        pcall(function() 
            local response=httpGet(BLACKLIST_URL) 
            if response and string.find(response,tostring(LP.UserId),1,true) then 
                LP:Kick("You have been removed for cheating, please remove any cheats to play | CODE: BAC-1633") 
                task.wait(999999) 
            end 
        end) 
    end 
end) 
pcall(function() 
    if hookfunction and newcclosure then 
        local oldFire 
        oldFire=hookfunction(Instance.new("RemoteEvent").FireServer,newcclosure(function(self,...) 
            if not cursedResetRemote and typeof(self)=="Instance" and self:IsA("RemoteEvent") and self.Name:sub(1,3)=="RE/" then 
                cursedResetRemote=self 
            end 
            return oldFire(self,...) 
        end)) 
    end 
end) 
task.spawn(function() 
    task.wait(2) 
    if cursedResetRemote then return end 
    for _,desc in ipairs(game:GetDescendants()) do 
        if desc:IsA("RemoteEvent") and desc.Name:sub(1,3)=="RE/" then 
            cursedResetRemote=desc;break 
        end 
    end 
end) 
local function cursedInstaReset() 
    if not cursedResetRemote then 
        for _,desc in ipairs(game:GetDescendants()) do 
            if desc:IsA("RemoteEvent") and desc.Name:sub(1,3)=="RE/" then 
                cursedResetRemote=desc;break 
            end 
        end 
    end 
    if not cursedResetRemote then return end 
    local character=LP.Character 
    local humanoid=character and character:FindFirstChildOfClass("Humanoid") 
    if humanoid and humanoid.Health<=0 then 
        pcall(function() cursedResetRemote:FireServer(CURSED_RESET_GUID,LP,"balloon") end);return 
    end 
    local resetDetected=false 
    local conns={} 
    if humanoid then 
        table.insert(conns,humanoid.Died:Connect(function() resetDetected=true end)) 
        table.insert(conns,humanoid:GetPropertyChangedSignal("Health"):Connect(function() 
            if humanoid.Health<=0 then resetDetected=true end 
        end)) 
    end 
    if character then 
        table.insert(conns,character.AncestryChanged:Connect(function(_,parent) 
            if not parent then resetDetected=true end 
        end)) 
    end 
    task.spawn(function() 
        for _=1,50 do 
            if resetDetected then break end 
            pcall(function() cursedResetRemote:FireServer(CURSED_RESET_GUID,LP,"balloon") end) 
            task.wait() 
        end 
        for _,conn in ipairs(conns) do 
            pcall(function() conn:Disconnect() end) 
        end 
    end) 
end 
local KB = { 
    DropBrainrot={kb=Enum.KeyCode.X}, 
    AutoLeft ={kb=Enum.KeyCode.Z}, 
    AutoRight ={kb=Enum.KeyCode.C}, 
    AutoBat ={kb=Enum.KeyCode.E}, 
    TPFloor ={kb=Enum.KeyCode.F}, 
    InstaReset ={kb=Enum.KeyCode.T}, 
    GuiHide ={kb=Enum.KeyCode.LeftControl}, 
    SpeedToggle ={kb=Enum.KeyCode.Q}, 
    LaggerToggle={kb=Enum.KeyCode.R}, 
    Aimbot2={kb=Enum.KeyCode.V}, 
    AntiDesyncAimbot={kb=Enum.KeyCode.B} 
} 
local AP_L1,AP_L2 = Vector3.new(-476.16,-6.52,25.62),Vector3.new(-483.06,-5.03,25.48) 
local AP_R1,AP_R2 = Vector3.new(-476.47,-6.28,92.73),Vector3.new(-483.12,-4.95,94.81) 
local Steal = { 
    AutoStealEnabled=false,StealRadius=60,StealDuration=1.4, 
    Mode="NORMAL",
    SemiStopTime=0.96,
    SemiDelayRadius=9,
    Data={} 
} 
local isStealing = false 
local stealStartTime = nil 
local Conns = {autoSteal=nil,antiRag=nil,batCounter=nil,anchor={},progress=nil} 
local MEDUSA_COOLDOWN = 25 
local batCounterDebounce = false 
local modeValLbl 
local uiScale = 1 
uiLocked=false 
setLockVisual=nil 
exeLaggerPanelKey=Enum.KeyCode.M 
exeMainFrame=nil 
exeMiniButton=nil 
exeGrabBar=nil 
local lastMoveDir = Vector3.new(0,0,0) 
local MOVE_KEYS={[Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true, 
    [Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Down]=true,[Enum.KeyCode.Right]=true} 
local function getActiveMoveSpeed() 
    return laggerToggled and (laggerPhase==2 and LAGGER_CARRY_SPEED or LAGGER_SPEED) or (speedMode and CS or NS) 
end 
local function getAutoPathSpeed() 
    return laggerToggled and LAGGER_SPEED or NS 
end 
--============================================================
-- DEEP ESP - lightweight (uses one global state table to avoid Luau local limit)
-- ESP = master | LINE/SQUARE = saved sub-options
--============================================================
pcall(function()
    if _G.DeepESP and _G.DeepESP.conn then _G.DeepESP.conn:Disconnect() end
    if _G.DeepESP and _G.DeepESP.removeConn then _G.DeepESP.removeConn:Disconnect() end
    if _G.DeepESP and _G.DeepESP.gui then _G.DeepESP.gui:Destroy() end
end)
_G.DeepESP={enabled=false,line=false,square=false,expanded=false,entries={}}

function _G.DeepESP.getGui()
    if _G.DeepESP.gui and _G.DeepESP.gui.Parent then return _G.DeepESP.gui end
    local g=Instance.new("ScreenGui")
    g.Name="DeepDuelsESP"
    g.IgnoreGuiInset=true
    g.ResetOnSpawn=false
    g.DisplayOrder=8
    g.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    local ok=pcall(function() g.Parent=game:GetService("CoreGui") end)
    if not ok or not g.Parent then g.Parent=LP:WaitForChild("PlayerGui") end
    _G.DeepESP.gui=g
    return g
end

function _G.DeepESP.entry(plr)
    local e=_G.DeepESP.entries[plr]
    if e and e.line and e.line.Parent then return e end
    local g=_G.DeepESP.getGui()
    e={}

    e.line=Instance.new("Frame")
    e.line.Name="Line_"..plr.Name
    e.line.AnchorPoint=Vector2.new(0.5,0.5)
    e.line.BackgroundColor3=Color3.new(1,1,1)
    e.line.BorderSizePixel=0
    e.line.Size=UDim2.fromOffset(1,2)
    e.line.Visible=false
    e.line.ZIndex=2
    e.line.Parent=g

    e.box=Instance.new("Frame")
    e.box.Name="Square_"..plr.Name
    e.box.BackgroundTransparency=1
    e.box.BorderSizePixel=0
    e.box.Visible=false
    e.box.ZIndex=3
    e.box.Parent=g
    local st=Instance.new("UIStroke")
    st.Color=Color3.new(1,1,1)
    st.Thickness=1.5
    st.Parent=e.box

    e.name=Instance.new("TextLabel")
    e.name.Name="Name_"..plr.Name
    e.name.AnchorPoint=Vector2.new(0.5,1)
    e.name.BackgroundTransparency=1
    e.name.Size=UDim2.fromOffset(180,20)
    e.name.Text=plr.Name
    e.name.TextColor3=Color3.new(1,1,1)
    e.name.TextStrokeTransparency=0.35
    e.name.Font=Enum.Font.SciFi
    e.name.TextSize=13
    e.name.Visible=false
    e.name.ZIndex=4
    e.name.Parent=g

    _G.DeepESP.entries[plr]=e
    return e
end

function _G.DeepESP.hide()
    for _,e in pairs(_G.DeepESP.entries) do
        if e.line then e.line.Visible=false end
        if e.box then e.box.Visible=false end
        if e.name then e.name.Visible=false end
    end
end

function _G.DeepESP.alive(plr)
    local c=plr and plr.Character
    local h=c and c:FindFirstChildOfClass("Humanoid")
    local r=c and c:FindFirstChild("HumanoidRootPart")
    if not c or not h or h.Health<=0 or not r then return nil,nil,nil end
    return c,h,r
end

function _G.DeepESP.step()
    if not _G.DeepESP.enabled then _G.DeepESP.hide();return end
    local cam=workspace.CurrentCamera
    local _,_,myRoot=_G.DeepESP.alive(LP)
    if not cam or not myRoot then _G.DeepESP.hide();return end

    _G.DeepESP.hide()
    local mine,mineOn=cam:WorldToViewportPoint(myRoot.Position)
    local mine2=Vector2.new(mine.X,mine.Y)
    local closest=nil
    local closestDist=math.huge

    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP then
            local _,_,root=_G.DeepESP.alive(plr)
            if root then
                local d=(root.Position-myRoot.Position).Magnitude
                if d<closestDist then closestDist=d;closest=plr end
                if _G.DeepESP.line then
                    local p,on=cam:WorldToViewportPoint(root.Position)
                    if mineOn and on and mine.Z>0 and p.Z>0 then
                        local e=_G.DeepESP.entry(plr)
                        local a=mine2
                        local b=Vector2.new(p.X,p.Y)
                        local delta=b-a
                        local len=delta.Magnitude
                        if len>1 then
                            local mid=(a+b)/2
                            e.line.Position=UDim2.fromOffset(mid.X,mid.Y)
                            e.line.Size=UDim2.fromOffset(len,2)
                            e.line.Rotation=math.deg(math.atan2(delta.Y,delta.X))
                            e.line.Visible=true
                        end
                    end
                end
            end
        end
    end

    if _G.DeepESP.square and closest then
        local char,_,root=_G.DeepESP.alive(closest)
        if char and root then
            local e=_G.DeepESP.entry(closest)
            local cf,size=char:GetBoundingBox()
            local top=cam:WorldToViewportPoint(cf.Position+Vector3.new(0,size.Y/2,0))
            local bottom=cam:WorldToViewportPoint(cf.Position-Vector3.new(0,size.Y/2,0))
            local center,on=cam:WorldToViewportPoint(root.Position)
            if on and center.Z>0 and top.Z>0 and bottom.Z>0 then
                local h=math.max(24,math.abs(bottom.Y-top.Y))
                local w=math.max(16,h*0.58)
                local cy=(top.Y+bottom.Y)/2
                e.box.Size=UDim2.fromOffset(w,h)
                e.box.Position=UDim2.fromOffset(center.X-w/2,cy-h/2)
                e.box.Visible=true
                e.name.Text=closest.Name
                e.name.Position=UDim2.fromOffset(center.X,top.Y-3)
                e.name.Visible=true
            end
        end
    end
end

function _G.DeepESP.setEnabled(v)
    _G.DeepESP.enabled=(v==true)
    if _G.DeepESP.conn then _G.DeepESP.conn:Disconnect();_G.DeepESP.conn=nil end
    if _G.DeepESP.enabled then
        _G.DeepESP.getGui()
        _G.DeepESP.conn=RunService.RenderStepped:Connect(_G.DeepESP.step)
    else
        _G.DeepESP.hide()
    end
    if _G.DeepESP.masterVisual then _G.DeepESP.masterVisual(_G.DeepESP.enabled) end
end

_G.DeepESP.removeConn=Players.PlayerRemoving:Connect(function(plr)
    local e=_G.DeepESP.entries[plr]
    if e then
        pcall(function() e.line:Destroy() end)
        pcall(function() e.box:Destroy() end)
        pcall(function() e.name:Destroy() end)
        _G.DeepESP.entries[plr]=nil
    end
end)

local function isRagdollState(hum) 
    if not hum then return true end 
    local st=hum:GetState() 
    return hum.PlatformStand or st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown 
end 
local function isMyPlotByName(plotName) 
    local plots=workspace:FindFirstChild("Plots") 
    if not plots then return false end 
    local plot=plots:FindFirstChild(plotName) 
    if not plot then return false end 
    local sign=plot:FindFirstChild("PlotSign") 
    if sign then 
        local yb=sign:FindFirstChild("YourBase") 
        if yb and yb:IsA("BillboardGui") then 
            return yb.Enabled==true 
        end 
    end 
    return false 
end 
local function findNearestPrompt() 
    local char=LP.Character;if not char then return nil end 
    local root=char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") 
    if not root then return nil end 
    local plots=workspace:FindFirstChild("Plots");if not plots then return nil end 
    local nearest,dist=nil,math.huge 
    for _,plot in ipairs(plots:GetChildren()) do 
        if isMyPlotByName(plot.Name) then continue end 
        local pods=plot:FindFirstChild("AnimalPodiums");if not pods then continue end 
        for _,pod in ipairs(pods:GetChildren()) do 
            local base=pod:FindFirstChild("Base") 
            local sp=base and base:FindFirstChild("Spawn") 
            if sp then 
                local d=(sp.Position-root.Position).Magnitude 
                if d<=Steal.StealRadius and d<dist then 
                    local found=nil 
                    local att=sp:FindFirstChild("PromptAttachment") 
                    if att then 
                        for _,pr in ipairs(att:GetChildren()) do 
                            if pr:IsA("ProximityPrompt") and pr.ActionText and pr.ActionText:find("Steal") then 
                                found=pr 
                            end 
                        end 
                    end 
                    if not found then 
                        for _,pr in ipairs(sp:GetDescendants()) do 
                            if pr:IsA("ProximityPrompt") and pr.ActionText and pr.ActionText:find("Steal") then 
                                found=pr 
                            end 
                        end 
                    end 
                    if found then 
                        nearest,dist=found,d 
                    end 
                end 
            end 
        end 
    end 
    return nearest 
end 
local function _promptDist(prompt) 
    local char=LP.Character if not char then return math.huge end 
    local root=char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") 
    if not root then return math.huge end 
    local part=prompt.Parent 
    if part and part:IsA("Attachment") then part=part.Parent end 
    if part and part:IsA("BasePart") then return (part.Position-root.Position).Magnitude end 
    local ok,cf=pcall(function() return prompt.Parent and prompt.Parent.WorldPosition end) 
    if ok and cf then return (cf-root.Position).Magnitude end 
    return math.huge 
end 
local function getStealData(prompt)
    if not Steal.Data[prompt] then
        Steal.Data[prompt]={hold={},trigger={},ready=true}
        if getconnections then
            pcall(function()
                for _,c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                    if c.Function then table.insert(Steal.Data[prompt].hold,c.Function) end
                end
                for _,c in ipairs(getconnections(prompt.Triggered)) do
                    if c.Function then table.insert(Steal.Data[prompt].trigger,c.Function) end
                end
            end)
        end
    end
    return Steal.Data[prompt]
end

local function resetStealState(data)
    if data then data.ready=true end
    isStealing=false
end

-- NORMAL: lógica original do Deep (hold -> duração -> trigger).
local function executeStealNormal(prompt)
    if isStealing then return end
    local data=getStealData(prompt)
    if not data.ready then return end
    data.ready=false
    isStealing=true
    stealStartTime=tick()
    task.spawn(function()
        for _,fn in ipairs(data.hold) do task.spawn(fn) end
        task.wait(Steal.StealDuration)
        if isStealing and Steal.AutoStealEnabled then
            for _,fn in ipairs(data.trigger) do task.spawn(fn) end
        end
        resetStealState(data)
    end)
end

-- SEMI: lógica do OP Auto Steal, preservando o visual do Deep.
local function executeStealSemi(prompt)
    if isStealing then return end
    local data=getStealData(prompt)
    if not data.ready then return end
    data.ready=false
    isStealing=true
    stealStartTime=tick()

    task.spawn(function()
        for _,fn in ipairs(data.hold) do task.spawn(fn) end

        local startTime=tick()
        local duration=Steal.StealDuration
        local stopTime=math.clamp(Steal.SemiStopTime,0.05,duration)
        local stopProgress=math.clamp(stopTime/duration,0,1)

        while isStealing and Steal.AutoStealEnabled do
            if tick()-startTime>=stopTime then break end
            if not prompt.Parent then break end
            task.wait()
        end

        if not isStealing or not Steal.AutoStealEnabled or not prompt.Parent then
            resetStealState(data)
            return
        end

        local phase2Start=tick()
        local phase2Timeout=math.max(2.99-stopTime-math.max(duration-stopTime,0),0.05)

        while isStealing and Steal.AutoStealEnabled do
            if tick()-phase2Start>=phase2Timeout then
                resetStealState(data)
                return
            end

            local char=LP.Character
            local root=char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"))
            local part=prompt.Parent
            if part and part:IsA("Attachment") then part=part.Parent end
            if root and part and part:IsA("BasePart") then
                local dist=(root.Position-part.Position).Magnitude
                if dist<=Steal.SemiDelayRadius then break end
                if dist>Steal.StealRadius then
                    resetStealState(data)
                    return
                end
            end
            task.wait()
        end

        if isStealing and Steal.AutoStealEnabled then
            local fillStart=tick()
            local fillDuration=math.max(duration-stopTime,0.05)
            while isStealing and Steal.AutoStealEnabled do
                if tick()-fillStart>=fillDuration then
                    for _,fn in ipairs(data.trigger) do task.spawn(fn) end
                    break
                end
                task.wait()
            end
        end

        resetStealState(data)
    end)
end

-- V1: lógica do Y/out AutoSteal. O carregador HTTP presente no arquivo Yout
-- foi deliberadamente excluído; somente a lógica local de steal é usada.
local function executeStealV1(prompt)
    if isStealing then return end
    local data=getStealData(prompt)
    if not data.ready then return end
    data.ready=false
    isStealing=true
    stealStartTime=tick()

    task.spawn(function()
        for _,fn in ipairs(data.hold) do task.spawn(fn) end

        local startTime=tick()
        local duration=Steal.StealDuration
        local stopTime=math.clamp(Steal.SemiStopTime,0.05,duration)
        local promptFired=false

        while isStealing and Steal.AutoStealEnabled do
            local elapsed=tick()-startTime
            if elapsed>=stopTime then break end
            if not prompt.Parent then break end
            task.wait()
        end

        if isStealing and Steal.AutoStealEnabled and prompt.Parent then
            local remaining=math.max(duration-stopTime,0.05)
            local phaseStart=tick()
            while isStealing and Steal.AutoStealEnabled do
                if tick()-phaseStart>=remaining and not promptFired then
                    promptFired=true
                    for _,fn in ipairs(data.trigger) do task.spawn(fn) end
                    pcall(function()
                        local remote=ReplicatedStorage:FindFirstChild("StealAnimal")
                        local pod=prompt.Parent
                        if pod and pod:IsA("Attachment") then pod=pod.Parent end
                        local podName=pod and pod.Parent and pod.Parent.Name
                        if remote and podName then remote:FireServer(podName) end
                        if prompt then prompt:Fire() end
                    end)
                    break
                end
                task.wait()
            end
        end

        resetStealState(data)
    end)
end

local function executeSteal(prompt)
    if Steal.Mode=="SEMI" then
        executeStealSemi(prompt)
    elseif Steal.Mode=="V1" then
        executeStealV1(prompt)
    else
        executeStealNormal(prompt)
    end
end

local function startAutoSteal() 
    if Conns.autoSteal then return end 
    Conns.autoSteal=RunService.Heartbeat:Connect(function() 
        if not Steal.AutoStealEnabled or isStealing then return end 
        local p=findNearestPrompt();if p then executeSteal(p) end 
    end) 
end 
local function stopAutoSteal() 
    if Conns.autoSteal then Conns.autoSteal:Disconnect();Conns.autoSteal=nil end 
    isStealing=false 
end 
RunService.Stepped:Connect(function() 
    for _,p in ipairs(Players:GetPlayers()) do 
        if p~=LP and p.Character then 
            for _,part in ipairs(p.Character:GetDescendants()) do 
                if part:IsA("BasePart") then part.CanCollide=false end 
            end 
        end 
    end 
end) 
RunService.RenderStepped:Connect(function() 
    local char=LP.Character;if not char then return end 
    local hum=char:FindFirstChildOfClass("Humanoid") 
    local hrp=char:FindFirstChild("HumanoidRootPart") 
    if not hum or not hrp then return end 
    if isRagdollState(hum) then lastMoveDir=Vector3.new(0,0,0);return end 
    -- Quando BAT V2 está ligado, ele controla o movimento sozinho.
    -- O analógico não sobrescreve a perseguição do alvo.
    if not autoBatEnabled and not autoLeftEnabled and not autoRightEnabled and not aimbot2Enabled then 
        local md=hum.MoveDirection 
        local spd=getActiveMoveSpeed() 
        if md.Magnitude>0 then 
            lastMoveDir=md 
            hrp.Velocity=Vector3.new(md.X*spd,hrp.Velocity.Y,md.Z*spd) 
        elseif antiRagdollEnabled and lastMoveDir.Magnitude>0 then 
            local anyHeld=false 
            for key in pairs(MOVE_KEYS) do 
                if UIS:IsKeyDown(key) then anyHeld=true;break end 
            end 
            if anyHeld then 
                hrp.Velocity=Vector3.new(lastMoveDir.X*spd,hrp.Velocity.Y,lastMoveDir.Z*spd) 
            end 
        end 
    end 
    if speedLabel then speedLabel.Text=string.format("Speed: %.1f",Vector3.new(hrp.Velocity.X,0,hrp.Velocity.Z).Magnitude) end 
end) 
local alConn,arConn=nil,nil 
local alPhase,arPhase=1,1 
local function stopAutoLeft() 
    autoLeftEnabled=false if alConn then alConn:Disconnect();alConn=nil end;alPhase=1 
    local char=LP.Character;if char then local h=char:FindFirstChildOfClass("Humanoid");if h then h:Move(Vector3.zero,false);h.PlatformStand=false;pcall(function() h:ChangeState(Enum.HumanoidStateType.Running) end);workspace.CurrentCamera.CameraSubject=h end end 
    if autoLeftSetVisual then autoLeftSetVisual(false) end 
    if mobBtnRefs and mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end 
end 
local function stopAutoRight() 
    autoRightEnabled=false if arConn then arConn:Disconnect();arConn=nil end;arPhase=1 
    local char=LP.Character;if char then local h=char:FindFirstChildOfClass("Humanoid");if h then h:Move(Vector3.zero,false);h.PlatformStand=false;pcall(function() h:ChangeState(Enum.HumanoidStateType.Running) end);workspace.CurrentCamera.CameraSubject=h end end 
    if autoRightSetVisual then autoRightSetVisual(false) end 
    if mobBtnRefs and mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end 
end 
local function startAutoLeft() 
    if alConn then alConn:Disconnect() end;alPhase=1 
    alConn=RunService.Heartbeat:Connect(function() 
        if not autoLeftEnabled then return end 
        local char=LP.Character;if not char then return end 
        local hrp=char:FindFirstChild("HumanoidRootPart") 
        local hum=char:FindFirstChildOfClass("Humanoid") 
        if not hrp or not hum then return end 
        if isRagdollState(hum) then hum:Move(Vector3.zero,false);return end 
        local spd=getAutoPathSpeed() 
        if alPhase==1 then 
            local tgt=Vector3.new(AP_L1.X,hrp.Position.Y,AP_L1.Z) 
            if (tgt-hrp.Position).Magnitude<1 then 
                alPhase=2 
                local d=AP_L2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit 
                hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd) 
                return 
            end 
            local d=AP_L1-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit 
            hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd) 
        elseif alPhase==2 then 
            local tgt=Vector3.new(AP_L2.X,hrp.Position.Y,AP_L2.Z) 
            if (tgt-hrp.Position).Magnitude<1 then 
                hum:Move(Vector3.zero,false);hum.PlatformStand=false;pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end);workspace.CurrentCamera.CameraSubject=hum;hrp.AssemblyLinearVelocity=Vector3.zero 
                autoLeftEnabled=false;if alConn then alConn:Disconnect();alConn=nil end 
                alPhase=1;if autoLeftSetVisual then autoLeftSetVisual(false) end;if mobBtnRefs and mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end;saveConfig();return 
            end 
            local d=AP_L2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit 
            hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd) 
        end 
    end) 
end 
local function startAutoRight() 
    if arConn then arConn:Disconnect() end;arPhase=1 
    arConn=RunService.Heartbeat:Connect(function() 
        if not autoRightEnabled then return end 
        local char=LP.Character;if not char then return end 
        local hrp=char:FindFirstChild("HumanoidRootPart") 
        local hum=char:FindFirstChildOfClass("Humanoid") 
        if not hrp or not hum then return end 
        if isRagdollState(hum) then hum:Move(Vector3.zero,false);return end 
        local spd=getAutoPathSpeed() 
        if arPhase==1 then 
            local tgt=Vector3.new(AP_R1.X,hrp.Position.Y,AP_R1.Z) 
            if (tgt-hrp.Position).Magnitude<1 then 
                arPhase=2 
                local d=AP_R2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit 
                hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd) 
                return 
            end 
            local d=AP_R1-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit 
            hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd) 
        elseif arPhase==2 then 
            local tgt=Vector3.new(AP_R2.X,hrp.Position.Y,AP_R2.Z) 
            if (tgt-hrp.Position).Magnitude<1 then 
                hum:Move(Vector3.zero,false);hum.PlatformStand=false;pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end);workspace.CurrentCamera.CameraSubject=hum;hrp.AssemblyLinearVelocity=Vector3.zero 
                autoRightEnabled=false;if arConn then arConn:Disconnect();arConn=nil end 
                arPhase=1;if autoRightSetVisual then autoRightSetVisual(false) end;if mobBtnRefs and mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end;saveConfig();return 
            end 
            local d=AP_R2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit 
            hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd) 
        end 
    end) 
end 
local function setupSpeedIndicator(char) 
    local head=char:WaitForChild("Head",5);if not head then return end 
    local bb=Instance.new("BillboardGui",head) 
    bb.Size=UDim2.new(0,160,0,44);bb.StudsOffset=Vector3.new(0,3,0);bb.AlwaysOnTop=true 
    speedLabel=Instance.new("TextLabel",bb) 
    speedLabel.Size=UDim2.new(1,0,0.55,0);speedLabel.BackgroundTransparency=1 
    speedLabel.Text="Speed: 0";speedLabel.TextColor3=Color3.fromRGB(255,255,255) 
    speedLabel.Font=Enum.Font.SciFi;speedLabel.TextScaled=true 
    speedLabel.TextStrokeTransparency=0;speedLabel.TextStrokeColor3=Color3.fromRGB(0,0,0) 
    local discordLabel=Instance.new("TextLabel",bb) 
    discordLabel.Size=UDim2.new(1,0,0.45,0);discordLabel.Position=UDim2.new(0,0,0.55,0);discordLabel.BackgroundTransparency=1 
    discordLabel.Text="https://discord.gg/VzD8c4MauN";discordLabel.TextColor3=Color3.fromRGB(255,255,255) 
    discordLabel.Font=Enum.Font.SciFi;discordLabel.TextScaled=true 
    discordLabel.TextStrokeTransparency=0;discordLabel.TextStrokeColor3=Color3.fromRGB(0,0,0) 
end 
local function startAntiRagdoll() 
    if Conns.antiRag then return end 
    Conns.antiRag=RunService.Heartbeat:Connect(function() 
        if not antiRagdollEnabled then return end 
        local char=LP.Character 
        if not char then return end 
        local hum=char:FindFirstChildOfClass("Humanoid") 
        if not hum or hum.Health <= 0 then return end 
        local state=hum:GetState() 
        local isRagdolled = state==Enum.HumanoidStateType.Physics or state==Enum.HumanoidStateType.Ragdoll or state==Enum.HumanoidStateType.FallingDown 
        if isRagdolled then 
            pcall(function() 
                hum:ChangeState(Enum.HumanoidStateType.GettingUp) 
                local root=char:FindFirstChild("HumanoidRootPart") 
                if root then 
                    root.Velocity=Vector3.zero 
                    root.RotVelocity=Vector3.zero 
                    root.AssemblyLinearVelocity=Vector3.zero 
                    root.AssemblyAngularVelocity=Vector3.zero 
                end 
                for _,obj in ipairs(char:GetDescendants()) do 
                    if obj:IsA("Motor6D") then obj.Enabled=true end 
                    if obj:IsA("Constraint") then obj.Enabled=true end 
                end 
                workspace.CurrentCamera.CameraSubject=hum 
                local PM=LP.PlayerScripts:FindFirstChild("PlayerModule") 
                if PM then 
                    local CM=require(PM:FindFirstChild("ControlModule")) 
                    if CM then CM:Enable() end 
                end 
                hum.AutoRotate=true 
                hum.PlatformStand=false 
                hum.Sit=false 
            end) 
        end 
    end) 
end 
local function stopAntiRagdoll() 
    if Conns.antiRag then Conns.antiRag:Disconnect();Conns.antiRag=nil end 
end 
local InfJumpPlatform = nil 
local function CreateIJP() 
    if InfJumpPlatform then return end 
    InfJumpPlatform = Instance.new("Part") 
    InfJumpPlatform.Name = "InfJumpPlatform" 
    InfJumpPlatform.Size = Vector3.new(8, 0.5, 8) 
    InfJumpPlatform.Anchored = true 
    InfJumpPlatform.CanCollide = true 
    InfJumpPlatform.Transparency = 1 
    InfJumpPlatform.Material = Enum.Material.ForceField 
    InfJumpPlatform.Parent = workspace 
end 
CreateIJP() 
RunService.Heartbeat:Connect(function() 
    if not infJumpEnabled then 
        if InfJumpPlatform then InfJumpPlatform.Position = Vector3.new(0, -1000, 0) end 
        return 
    end 
    local char = LP.Character 
    local root = char and char:FindFirstChild("HumanoidRootPart") 
    local hum = char and char:FindFirstChildOfClass("Humanoid") 
    if not (char and root and hum) then 
        if InfJumpPlatform then InfJumpPlatform.Position = Vector3.new(0, -1000, 0) end 
        return 
    end 
    local isJumping = UIS:IsKeyDown(Enum.KeyCode.Space) or hum:GetState() == Enum.HumanoidStateType.Jumping or hum.Jump 
    if isJumping then 
        if not InfJumpPlatform then CreateIJP() end 
        InfJumpPlatform.Position = root.Position - Vector3.new(0, 3.5, 0) 
        if root.Velocity.Y < 50 then 
            root.Velocity = Vector3.new(root.Velocity.X, 50, root.Velocity.Z) 
        end 
    else 
        if InfJumpPlatform then InfJumpPlatform.Position = Vector3.new(0, -1000, 0) end 
    end 
end) 
local function startUnwalk() 
    local c=LP.Character;if not c then return end 
    local hum=c:FindFirstChildOfClass("Humanoid") 
    if hum then 
        for _,t in ipairs(hum:GetPlayingAnimationTracks()) do t:Stop() end 
    end 
    local anim=c:FindFirstChild("Animate") 
    if anim then unwalkSavedAnimate=anim:Clone();anim:Destroy() end 
end 
local function stopUnwalk() 
    local c=LP.Character 
    if c and unwalkSavedAnimate then unwalkSavedAnimate:Clone().Parent=c;unwalkSavedAnimate=nil end 
end 
local DROP_ASCEND_DURATION = 0.22 
local DROP_ASCEND_SPEED = 160 
local _dropConn = nil 
local jumpDropActive = false 
local function runJumpDrop() 
    if jumpDropActive then return end 
    local char = LP.Character if not char then return end 
    local root = char:FindFirstChild("HumanoidRootPart") if not root then return end 
    jumpDropActive = true 
    if mobBtnRefs and mobBtnRefs.drop then mobBtnRefs.drop(true) end 
    local t0 = tick() 
    if _dropConn then _dropConn:Disconnect() end 
    _dropConn = RunService.Heartbeat:Connect(function() 
        local c = LP.Character 
        local r = c and c:FindFirstChild("HumanoidRootPart") 
        if not r then 
            if _dropConn then _dropConn:Disconnect(); _dropConn = nil end 
            jumpDropActive = false 
            if mobBtnRefs and mobBtnRefs.drop then mobBtnRefs.drop(false) end 
            return 
        end 
        if not jumpDropActive then 
            if _dropConn then _dropConn:Disconnect(); _dropConn = nil end 
            if mobBtnRefs and mobBtnRefs.drop then mobBtnRefs.drop(false) end 
            return 
        end 
        if tick() - t0 >= DROP_ASCEND_DURATION then 
            if _dropConn then _dropConn:Disconnect(); _dropConn = nil end 
            pcall(function() 
                local rp = RaycastParams.new() 
                rp.FilterDescendantsInstances = {c} 
                rp.FilterType = Enum.RaycastFilterType.Exclude 
                local rr = workspace:Raycast(r.Position, Vector3.new(0, -3000, 0), rp) 
                if rr then 
                    local hum = c:FindFirstChildOfClass("Humanoid") 
                    local off = ((hum and hum.HipHeight) or 2) + (r.Size.Y / 2) 
                    r.CFrame = CFrame.new(r.Position.X, rr.Position.Y + off, r.Position.Z) 
                    r.AssemblyLinearVelocity = Vector3.zero 
                end 
            end) 
            jumpDropActive = false 
            if mobBtnRefs and mobBtnRefs.drop then mobBtnRefs.drop(false) end 
            return 
        end 
        local lv = r.AssemblyLinearVelocity 
        r.AssemblyLinearVelocity = Vector3.new(lv.X, DROP_ASCEND_SPEED, lv.Z) 
    end) 
end 
local _wfConns={} 
local function runDrop() 
    if dropActive then return end 
    if autoBatEnabled then autoBatEnabled=false if resetAutoBatMotion then resetAutoBatMotion() end if autoBatSetVisual then autoBatSetVisual(false) end end 
    dropActive=true 
    local colConn=RunService.Stepped:Connect(function() 
        if not dropActive then return end 
        for _,p in ipairs(Players:GetPlayers()) do 
            if p~=LP and p.Character then 
                for _,part in ipairs(p.Character:GetChildren()) do 
                    if part:IsA("BasePart") then part.CanCollide=false end 
                end 
            end 
        end 
    end) 
    table.insert(_wfConns,colConn) 
    local flingThread=coroutine.create(function() 
        while dropActive do 
            RunService.Heartbeat:Wait() 
            local c=LP.Character 
            local root=c and c:FindFirstChild("HumanoidRootPart") 
            if not root then break end 
            local vel=root.Velocity 
            root.Velocity=vel*10000+Vector3.new(0,10000,0) 
            RunService.RenderStepped:Wait() 
            if root and root.Parent then root.Velocity=vel end 
            RunService.Stepped:Wait() 
            if root and root.Parent then root.Velocity=vel+Vector3.new(0,0.1,0) end 
        end 
    end) 
    table.insert(_wfConns,flingThread) 
    coroutine.resume(flingThread) 
    task.delay(0.1,function() 
        dropActive=false 
        for _,c in ipairs(_wfConns) do 
            if typeof(c)=="RBXScriptConnection" then c:Disconnect() 
            elseif type(c)=="thread" then pcall(coroutine.close,c) end 
        end 
        _wfConns={} 
    end) 
end 
function runDropKeybindBurst() 
    task.spawn(function() 
        for i=1,3 do pcall(runDrop) task.wait(0.14) end 
    end) 
end 
local function doTPDown(force) 
    local char=LP.Character;if not char then return end 
    local hrp=char:FindFirstChild("HumanoidRootPart");if not hrp then return end 
    local hum2=char:FindFirstChildOfClass("Humanoid");if not hum2 then return end 
    if not force then 
        if hum2.FloorMaterial~=Enum.Material.Air then return end 
        if hrp.Position.Y<autoTPHeight then return end 
    end 
    hrp.CFrame=CFrame.new(hrp.Position.X,-7.00,hrp.Position.Z) *CFrame.Angles(0,select(2,hrp.CFrame:ToEulerAnglesYXZ()),0) 
    hrp.AssemblyLinearVelocity=Vector3.zero 
    hrp.Velocity=Vector3.zero 
end 
local function runTPFloor() 
    pcall(function() doTPDown(true) end) 
end 
local defLightBrightness,defLightClock,defLightAmbient 
pcall(function() 
    if not getgenv().Resolution then getgenv().Resolution = { [".gg/scripters"] = 0.65 } end 
end) 
local enableStretchRez, disableStretchRez 
do 
    local stretchRezOriginalCFrame=nil 
    function enableStretchRez() 
        stretchRezEnabled=true 
        local camera=workspace.CurrentCamera 
        if stretchRezConn then stretchRezConn:Disconnect() end 
        stretchRezOriginalCFrame=camera.CFrame 
        stretchRezConn=RunService.RenderStepped:Connect(function() 
            if not stretchRezEnabled then stretchRezConn:Disconnect(); stretchRezConn=nil; return end 
            local cam=workspace.CurrentCamera 
            local scaleY=(getgenv().Resolution and getgenv().Resolution[".gg/scripters"]) or 0.65 
            if cam then 
                cam.CFrame=cam.CFrame*CFrame.new(0,0,0,1,0,0,0,scaleY,0,0,0,1) 
            end 
        end) 
    end 
    function disableStretchRez() 
        stretchRezEnabled=false 
        if stretchRezConn then stretchRezConn:Disconnect(); stretchRezConn=nil end 
        if stretchRezOriginalCFrame then 
            local cam=workspace.CurrentCamera; if cam then cam.CFrame=stretchRezOriginalCFrame end 
        end 
    end 
end 
local function applyAntiLagDerender(obj) 
    pcall(function() 
        if obj:IsA("Accessory") or obj:IsA("Hat") then obj:Destroy() 
        elseif obj:IsA("BasePart") then obj.Material=Enum.Material.Plastic;obj.Reflectance=0;obj.CastShadow=false 
        elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency=1 
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then obj.Enabled=false 
        elseif obj:IsA("AnimationController") or obj:IsA("Animator") then 
            for _,t in ipairs(obj:GetPlayingAnimationTracks()) do pcall(function() t:Stop(0) end) end 
        end 
    end) 
end 
local function enableAntiLag() 
    removeAccessoriesEnabled=true 
    antiLagEnabled=true 
    defLightBrightness=defLightBrightness or Lighting.Brightness 
    defLightClock=defLightClock or Lighting.ClockTime 
    defLightAmbient=defLightAmbient or Lighting.OutdoorAmbient 
    Lighting.GlobalShadows=false;Lighting.FogEnd=1e10;Lighting.Brightness=1 
    Lighting.EnvironmentDiffuseScale=0;Lighting.EnvironmentSpecularScale=0 
    for _,e in pairs(Lighting:GetChildren()) do 
        pcall(function() 
            if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then 
                e.Enabled=false 
            end 
        end) 
    end 
    for _,obj in ipairs(workspace:GetDescendants()) do applyAntiLagDerender(obj) end 
    if antiLagDescConn then antiLagDescConn:Disconnect() end 
    antiLagDescConn=workspace.DescendantAdded:Connect(function(obj) 
        if removeAccessoriesEnabled then applyAntiLagDerender(obj) end 
    end) 
end 
local function disableAntiLag() 
    removeAccessoriesEnabled=false 
    antiLagEnabled=false 
    if antiLagDescConn then antiLagDescConn:Disconnect();antiLagDescConn=nil end 
    pcall(function() 
        if defLightBrightness then Lighting.Brightness=defLightBrightness end 
        if defLightClock then Lighting.ClockTime=defLightClock end 
        if defLightAmbient then Lighting.OutdoorAmbient=defLightAmbient end 
        Lighting.ExposureCompensation=0 
    end) 
end 
local function findMedusa() 
    local c=LP.Character;if not c then return nil end 
    for _,t in ipairs(c:GetChildren()) do 
        if t:IsA("Tool") then 
            local n=t.Name:lower();if n:find("medusa") or n:find("head") or n:find("stone") then return t end 
        end 
    end 
    local bp=LP:FindFirstChild("Backpack") 
    if bp then 
        for _,t in ipairs(bp:GetChildren()) do 
            if t:IsA("Tool") then 
                local n=t.Name:lower();if n:find("medusa") or n:find("head") or n:find("stone") then return t end 
            end 
        end 
    end 
    return nil 
end 
local function useMedusaCounter() 
    if medusaDebounce then return end;if tick()-medusaLastUsed<MEDUSA_COOLDOWN then return end 
    local c=LP.Character;if not c then return end;medusaDebounce=true 
    local med=findMedusa();if not med then medusaDebounce=false;return end 
    if med.Parent~=c then 
        local hum2=c:FindFirstChildOfClass("Humanoid");if hum2 then hum2:EquipTool(med) end 
    end 
    pcall(function() med:Activate() end);medusaLastUsed=tick();medusaDebounce=false 
end 
local function onAnchorChanged(part) 
    return part:GetPropertyChangedSignal("Anchored"):Connect(function() 
        if part.Anchored and part.Transparency==1 then useMedusaCounter() end 
    end) 
end 
local function setupMedusa(char) 
    for _,c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end;Conns.anchor={} 
    if not char then return end 
    for _,part in ipairs(char:GetDescendants()) do 
        if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end 
    end 
    table.insert(Conns.anchor,char.DescendantAdded:Connect(function(part) 
        if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end 
    end)) 
end 
local function stopMedusaCounter() 
    for _,c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end;Conns.anchor={} 
end 
local BAT_COUNTER_SLAP_LIST={"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"} 
local function findBatForCounter() 
    local c=LP.Character;if not c then return nil end 
    local bp=LP:FindFirstChildOfClass("Backpack") 
    for _,name in ipairs(BAT_COUNTER_SLAP_LIST) do 
        local t=c:FindFirstChild(name) or (bp and bp:FindFirstChild(name));if t then return t end 
    end 
    for _,ch in ipairs(c:GetChildren()) do 
        if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end 
    end 
    if bp then 
        for _,ch in ipairs(bp:GetChildren()) do 
            if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end 
        end 
    end 
    return nil 
end 
local function swingBatForCounter(bat,char) 
    local hum2=char:FindFirstChildOfClass("Humanoid") 
    if bat.Parent~=char then 
        if hum2 then pcall(function() hum2:EquipTool(bat) end) end;task.wait(0.05) 
    end 
    local remote=bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction") 
    if remote and remote:IsA("RemoteEvent") then 
        pcall(function() remote:FireServer() end);task.wait(0.15);pcall(function() remote:FireServer() end) 
    else 
        pcall(function() bat:Activate() end);task.wait(0.15);pcall(function() bat:Activate() end) 
    end 
end 
startBatCounter=function() 
    if Conns.batCounter then return end 
    Conns.batCounter=RunService.Heartbeat:Connect(function() 
        if not batCounterEnabled then return end 
        if batCounterDebounce then return end 
        local char=LP.Character;if not char then return end 
        local hum2=char:FindFirstChildOfClass("Humanoid");if not hum2 then return end 
        local st=hum2:GetState() 
        if st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown then 
            batCounterDebounce=true 
            task.spawn(function() 
                local bat=findBatForCounter() 
                if bat then swingBatForCounter(bat,char) end 
                task.wait(0.5);batCounterDebounce=false 
            end) 
        end 
    end) 
end 
stopBatCounter=function() 
    if Conns.batCounter then Conns.batCounter:Disconnect();Conns.batCounter=nil end 
    batCounterDebounce=false 
end 
local function findBat() 
    local char=LP.Character; if not char then return nil end 
    for _,tool in ipairs(char:GetChildren()) do 
        if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end 
    end 
    local bp=LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack") 
    if bp then 
        for _,tool in ipairs(bp:GetChildren()) do 
            if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end 
        end 
    end 
    return nil 
end 
local function getAutoBatTarget() 
    local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") 
    if not root then return nil end 
    local closest,minDist=nil,math.huge 
    for _,plr in ipairs(Players:GetPlayers()) do 
        if plr~=LP and plr.Character then 
            local tRoot=plr.Character:FindFirstChild("HumanoidRootPart") 
            local hum=plr.Character:FindFirstChildOfClass("Humanoid") 
            if tRoot and hum and hum.Health>0 then 
                local dist=(tRoot.Position-root.Position).Magnitude 
                if dist<minDist then minDist=dist;closest=tRoot end 
            end 
        end 
    end 
    return closest 
end 
resetAutoBatMotion=function() 
    local char=LP.Character 
    local hrp=char and char:FindFirstChild("HumanoidRootPart") 
    local hum=char and char:FindFirstChildOfClass("Humanoid") 
    if hrp then hrp.AssemblyLinearVelocity=Vector3.zero;hrp.AssemblyAngularVelocity=Vector3.zero end 
    if hum then hum.AutoRotate=true end 
end 
local function enableAutoBat() 
    if autoLeftEnabled then autoLeftEnabled=false;if autoLeftSetVisual then autoLeftSetVisual(false) end;stopAutoLeft() end 
    if autoRightEnabled then autoRightEnabled=false;if autoRightSetVisual then autoRightSetVisual(false) end;stopAutoRight() end 
    local char=LP.Character 
    if char then 
        local hum2=char:FindFirstChildOfClass("Humanoid") 
        if hum2 then hum2.AutoRotate=false end 
    end 
    autoBatEnabled=true 
end 
local function disableAutoBat() 
    autoBatEnabled=false 
    local char=LP.Character 
    if char then 
        local hum2=char:FindFirstChildOfClass("Humanoid") 
        if hum2 then hum2.AutoRotate=true end 
    end 
    if resetAutoBatMotion then resetAutoBatMotion() end 
end 
local function queueAutoLeftStart() 
    autoLeftEnabled=true 
    if autoRightEnabled then autoRightEnabled=false;if autoRightSetVisual then autoRightSetVisual(false) end;stopAutoRight() end 
    if autoBatEnabled then disableAutoBat();if autoBatSetVisual then autoBatSetVisual(false) end end 
    startAutoLeft() 
end 
local function queueAutoRightStart() 
    autoRightEnabled=true 
    if autoLeftEnabled then autoLeftEnabled=false;if autoLeftSetVisual then autoLeftSetVisual(false) end;stopAutoLeft() end 
    if autoBatEnabled then disableAutoBat();if autoBatSetVisual then autoBatSetVisual(false) end end 
    startAutoRight() 
end 
local function queueAutoBatStart() 
    if autoLeftEnabled then autoLeftEnabled=false;if autoLeftSetVisual then autoLeftSetVisual(false) end;stopAutoLeft() end 
    if autoRightEnabled then autoRightEnabled=false;if autoRightSetVisual then autoRightSetVisual(false) end;stopAutoRight() end 
    enableAutoBat() 
end 
RunService.Heartbeat:Connect(function() 
    if not autoBatEnabled then return end 
    local char=LP.Character 
    local hum=char and char:FindFirstChildOfClass("Humanoid") 
    local root=char and char:FindFirstChild("HumanoidRootPart") 
    if not root or not hum then return end 
    if not char:FindFirstChildOfClass("Tool") then 
        local bp=LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack") 
        local bpBat=bp and bp:FindFirstChild("Bat") 
        if bpBat then pcall(function() hum:EquipTool(bpBat) end) end 
    end 
    local target=getAutoBatTarget() 
    if target then 
        local targetVel=target.AssemblyLinearVelocity 
        local targetPos=target.Position 
        local myPos=root.Position 
        local predictPos=targetPos+targetVel*0.14 
        predictPos=predictPos+target.CFrame.LookVector*0.3 
        local direction=predictPos-myPos 
        local flatDir=Vector3.new(direction.X,0,direction.Z) 
        if flatDir.Magnitude>0 then flatDir=flatDir.Unit else flatDir=Vector3.zero end 
        local chaseSpeed=AUTO_BAT_SPEED 
        local desiredHeight=targetPos.Y+3.7 
        local yVel=(desiredHeight-myPos.Y)*19.5+targetVel.Y*0.8 
        if hum.FloorMaterial~=Enum.Material.Air then yVel=math.max(yVel,13) end 
        yVel=math.clamp(yVel,-70,110) 
        local desiredVel=Vector3.new(flatDir.X*chaseSpeed,yVel,flatDir.Z*chaseSpeed) 
        root.AssemblyLinearVelocity=root.AssemblyLinearVelocity:Lerp(desiredVel,0.8) 
        local speed3=targetVel.Magnitude 
        local predictTime=math.clamp(speed3/150,0.05,0.2) 
        local predictedPos=targetPos+targetVel*predictTime 
        local toPredict=predictedPos-myPos 
        if toPredict.Magnitude>0.1 then 
            hum.AutoRotate=false 
            local goalCF=CFrame.lookAt(myPos,predictedPos) 
            local diffCF=root.CFrame:Inverse()*goalCF 
            local rx,ry,rz=diffCF:ToEulerAnglesXYZ() 
            rx=math.clamp(rx,-2.5,2.5); ry=math.clamp(ry,-2.5,2.5); rz=math.clamp(rz,-2.5,2.5) 
            root.AssemblyAngularVelocity=root.CFrame:VectorToWorldSpace(Vector3.new(rx*42,ry*42,rz*42)) 
        end 
    else 
        hum.AutoRotate=true 
        root.AssemblyAngularVelocity=Vector3.zero 
        root.AssemblyLinearVelocity=Vector3.zero 
    end 
    if autoSwingEnabled then 
        local bat=char:FindFirstChild("Bat") 
        if bat then pcall(function() bat:Activate() end) 
        else 
            local tool=char:FindFirstChildOfClass("Tool") 
            if tool then pcall(function() tool:Activate() end) end 
        end 
    end 
end) 
autoSwitchSpeedEnabled=false 
autoTurnOffSpeedEnabled=false 
autoSwitchLaggerSpeedEnabled=false 
autoSwitchSpeedConn=nil 
AUTO_SWITCH_THRESHOLD=25 
fpsBoostEnabled=false 
fovEnabled=false 
fovValue=90 
fovConn=nil 
setAutoSwitchSpeedVisual,setAutoTurnOffSpeedVisual,setAutoSwitchLaggerSpeedVisual,setFpsBoostVisual,setFovVisual=nil,nil,nil,nil,nil 
fovValueBox=nil 
function applyFPSBoost() 
    pcall(function() settings().Rendering.QualityLevel=Enum.QualityLevel.Level01 end) 
end 
if aimbot2Enabled==nil then aimbot2Enabled=false end 
aimbot2Conn=aimbot2Conn or nil 
aimbot2PrevAutoRotate=aimbot2PrevAutoRotate or nil 
aimbot2HitCD=aimbot2HitCD or false
aimbot2LockedTarget=aimbot2LockedTarget or nil
setAimbot2Visual=setAimbot2Visual or nil 
AIMBOT2_SWING_CD=0.35 
AIMBOT2_HIT_DIST=8 
AIMBOT2_BAT_SLAP_LIST=AIMBOT2_BAT_SLAP_LIST or { 
    "Bat","Slap","Iron Slap","Gold Slap","Diamond Slap", 
    "Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap", 
    "Nuclear Slap","Galaxy Slap","Glitched Slap" 
} 
function aimbot2FindBat() 
    local char=LP.Character if not char then return nil end 
    for _,name in ipairs(AIMBOT2_BAT_SLAP_LIST) do 
        local t=char:FindFirstChild(name) if t and t:IsA("Tool") then return t end 
    end 
    local bp=LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack") 
    if bp then 
        for _,name in ipairs(AIMBOT2_BAT_SLAP_LIST) do 
            local t=bp:FindFirstChild(name) 
            if t and t:IsA("Tool") then 
                local hum=char:FindFirstChildOfClass("Humanoid") 
                if hum then pcall(function() hum:EquipTool(t) end) end 
                return t 
            end 
        end 
    end 
    for _,ch in ipairs(char:GetChildren()) do 
        if ch:IsA("Tool") and (ch.Name:lower():find("bat") or ch.Name:lower():find("slap")) then return ch end 
    end 
    return nil 
end 
function aimbot2TrySwing() 
    if aimbot2HitCD then return end 
    aimbot2HitCD=true 
    pcall(function() 
        local char=LP.Character if not char then return end 
        local bat=aimbot2FindBat() 
        if bat then 
            if bat.Parent~=char then 
                local hum=char:FindFirstChildOfClass("Humanoid") 
                if hum then pcall(function() hum:EquipTool(bat) end) end 
            end 
            pcall(function() bat:Activate() end) 
        end 
    end) 
    task.delay(AIMBOT2_SWING_CD,function() aimbot2HitCD=false end) 
end 
function aimbot2TargetIsValid(target)
    if not target or not target.Parent then return false end
    local char=target.Parent
    local hum=char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health<=0 then return false end
    local plr=Players:GetPlayerFromCharacter(char)
    if not plr or plr==LP then return false end
    return true
end

function aimbot2GetClosestTarget() 
    local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") 
    if not root then return nil,math.huge end 
    local closest,minDist=nil,math.huge 
    for _,plr in ipairs(Players:GetPlayers()) do 
        if plr~=LP and plr.Character then 
            local tRoot=plr.Character:FindFirstChild("HumanoidRootPart") 
            local hum=plr.Character:FindFirstChildOfClass("Humanoid") 
            if tRoot and hum and hum.Health>0 then 
                local dist=(tRoot.Position-root.Position).Magnitude 
                if dist<minDist then minDist=dist;closest=tRoot end 
            end 
        end 
    end 
    return closest,minDist 
end 
function startAimbot2() 
    if aimbot2Conn then aimbot2Conn:Disconnect();aimbot2Conn=nil end 
    aimbot2Enabled=true
    aimbot2LockedTarget=nil
    local hum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") 
    if hum then 
        if aimbot2PrevAutoRotate==nil then aimbot2PrevAutoRotate=hum.AutoRotate end 
        hum.AutoRotate=false 
    end 
    aimbot2Conn=RunService.RenderStepped:Connect(function() 
        if not aimbot2Enabled then return end 
        local char=LP.Character;if not char then return end 
        local root=char:FindFirstChild("HumanoidRootPart");if not root then return end 
        local hum=char:FindFirstChildOfClass("Humanoid");if not hum then return end 
        if not char:FindFirstChildOfClass("Tool") then 
            local bat=aimbot2FindBat() 
            if bat then pcall(function() hum:EquipTool(bat) end) end 
        end 
        -- Mantém o mesmo alvo ("grudado") enquanto ele continuar válido.
        if not aimbot2TargetIsValid(aimbot2LockedTarget) then
            aimbot2LockedTarget=nil
            local newTarget=aimbot2GetClosestTarget()
            aimbot2LockedTarget=newTarget
        end
        local target=aimbot2LockedTarget
        if not target then return end
        local targetDist=(target.Position-root.Position).Magnitude

        -- Cancela a influência do analógico enquanto o BAT V2 está perseguindo.
        hum.AutoRotate=false
        hum:Move(Vector3.zero,false)

        local myPos=root.Position 
        local targetPos=target.Position 
        local direction=targetPos-myPos 
        local flatDir=Vector3.new(direction.X,0,direction.Z) 
        if flatDir.Magnitude>0 then flatDir=flatDir.Unit else flatDir=Vector3.zero end 
        local chaseSpeed=58 
        local desiredHeight=targetPos.Y+3.7 
        local yVel=(desiredHeight-myPos.Y)*19.5 
        if hum.FloorMaterial~=Enum.Material.Air then yVel=math.max(yVel,13) end 
        yVel=math.clamp(yVel,-70,110) 
        local desiredVel=Vector3.new(flatDir.X*chaseSpeed,yVel,flatDir.Z*chaseSpeed) 
        root.AssemblyLinearVelocity=root.AssemblyLinearVelocity:Lerp(desiredVel,0.8) 
        local toTarget=targetPos-myPos 
        if toTarget.Magnitude>0.1 then 
            local goalCF=CFrame.lookAt(myPos,targetPos) 
            local diffCF=root.CFrame:Inverse()*goalCF 
            local rx,ry,rz=diffCF:ToEulerAnglesXYZ() 
            rx=math.clamp(rx,-2.5,2.5);ry=math.clamp(ry,-2.5,2.5);rz=math.clamp(rz,-2.5,2.5) 
            root.AssemblyAngularVelocity=root.CFrame:VectorToWorldSpace(Vector3.new(rx*42,ry*42,rz*42)) 
        end 
        if targetDist<=AIMBOT2_HIT_DIST then aimbot2TrySwing() end 
    end) 
end 
function stopAimbot2() 
    aimbot2Enabled=false
    aimbot2LockedTarget=nil
    if aimbot2Conn then aimbot2Conn:Disconnect();aimbot2Conn=nil end 
    local c=LP.Character 
    local root=c and c:FindFirstChild("HumanoidRootPart") 
    if root then root.AssemblyLinearVelocity=Vector3.zero root.AssemblyAngularVelocity=Vector3.zero end 
    local hum=c and c:FindFirstChildOfClass("Humanoid") 
    if hum then 
        hum.AutoRotate=(aimbot2PrevAutoRotate==nil) and true or aimbot2PrevAutoRotate 
        hum.PlatformStand=false 
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end) 
    end 
    aimbot2HitCD=false 
end 
function setAimbot2(on) 
    aimbot2Enabled=on 
    if on then startAimbot2() else stopAimbot2() end 
    if setAimbot2Visual then setAimbot2Visual(on) end 
    if mobBtnRefs and mobBtnRefs.aimbot2 then mobBtnRefs.aimbot2(on) end 
    pcall(saveConfig) 
end 
local tpAimbotEnabled = tpAimbotEnabled or false

_G.DeepTPAimbot = _G.DeepTPAimbot or {
    conn = nil,
    hittingCooldown = false,
    h = nil,
    hrp = nil
}
_G.DeepTPAimbotOn = _G.DeepTPAimbotOn or false

local XLU0_TP_BAT_NAMES = {
    "Bat","Slap","Iron Slap","Gold Slap","Diamond Slap",
    "Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap",
    "Nuclear Slap","Galaxy Slap","Glitched Slap"
}

function _G.DeepTPAimbotGetBat()
    local char = LP.Character
    if not char then return nil end

    for _, name in ipairs(XLU0_TP_BAT_NAMES) do
        local tool = char:FindFirstChild(name)
        if tool and tool:IsA("Tool") then
            return tool
        end
    end

    local bp = LP:FindFirstChildOfClass("Backpack")
    if bp then
        for _, name in ipairs(XLU0_TP_BAT_NAMES) do
            local tool = bp:FindFirstChild(name)
            if tool and tool:IsA("Tool") then
                tool.Parent = char
                return tool
            end
        end
    end

    return nil
end

function _G.DeepTPAimbotTrySwing()
    _G.DeepTPAimbot = _G.DeepTPAimbot or {conn=nil,hittingCooldown=false,h=nil,hrp=nil}
    if _G.DeepTPAimbot.hittingCooldown then return end
    _G.DeepTPAimbot.hittingCooldown = true

    pcall(function()
        local bat = _G.DeepTPAimbotGetBat()
        if not bat then return end

        bat:Activate()
        local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
        if ev then ev:FireServer() end
    end)

    task.delay(0.08, function()
        if _G.DeepTPAimbot then
            _G.DeepTPAimbot.hittingCooldown = false
        end
    end)
end

function _G.DeepTPAimbotGetClosestPlayer()
    _G.DeepTPAimbot = _G.DeepTPAimbot or {conn=nil,hittingCooldown=false,h=nil,hrp=nil}
    local hrp = _G.DeepTPAimbot.hrp
    if not hrp then return nil end

    local closest, bestDist = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if root and hum and hum.Health > 0 then
                local dist = (hrp.Position - root.Position).Magnitude
                if dist < bestDist then
                    bestDist = dist
                    closest = player
                end
            end
        end
    end

    return closest, bestDist
end

function _G.DeepTPAimbotSetupChar(char)
    task.wait(0.2)
    if not _G.DeepTPAimbot then return end
    _G.DeepTPAimbot.h = char and char:FindFirstChildOfClass("Humanoid") or nil
    _G.DeepTPAimbot.hrp = char and char:FindFirstChild("HumanoidRootPart") or nil

    if _G.DeepTPAimbotOn and not _G.DeepTPAimbot.conn then
        _G.DeepStartTPAimbot()
    end
end

LP.CharacterAdded:Connect(function(char)
    pcall(function() _G.DeepTPAimbotSetupChar(char) end)
end)

if LP.Character then
    task.spawn(function()
        pcall(function() _G.DeepTPAimbotSetupChar(LP.Character) end)
    end)
end

function _G.DeepStartTPAimbot()
    if _G.DeepTPAimbot.conn then
        _G.DeepTPAimbot.conn:Disconnect()
        _G.DeepTPAimbot.conn = nil
    end

    _G.DeepTPAimbotOn = true
    tpAimbotEnabled = true

    local char = LP.Character
    if char then
        _G.DeepTPAimbot.h = char:FindFirstChildOfClass("Humanoid")
        _G.DeepTPAimbot.hrp = char:FindFirstChild("HumanoidRootPart")
    end

    _G.DeepTPAimbot.conn = RunService.Heartbeat:Connect(function()
        if not _G.DeepTPAimbotOn then return end

        if not _G.DeepTPAimbot.h or not _G.DeepTPAimbot.hrp then
            local currentChar = LP.Character
            if not currentChar then return end
            _G.DeepTPAimbot.h = currentChar:FindFirstChildOfClass("Humanoid")
            _G.DeepTPAimbot.hrp = currentChar:FindFirstChild("HumanoidRootPart")
            if not _G.DeepTPAimbot.h or not _G.DeepTPAimbot.hrp then return end
        end

        local target = _G.DeepTPAimbotGetClosestPlayer()
        _aimbotTargetPlr = target
        _G.DeepCurrentAimbotTarget = target
        _G.DeepTPAimbotBatTarget = target

        if not target or not target.Character then return end

        local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
        if not targetRoot then return end

        --Leaked By Xlu0 AndPrime--
        if sethiddenproperty then
            pcall(sethiddenproperty, _G.DeepTPAimbot.hrp, "PhysicsRepRootPart", targetRoot)
        end

        --Leaked By Xlu0 AndPrime--
        local targetPos = targetRoot.Position + Vector3.new(0, 0.9, 0)
        if (_G.DeepTPAimbot.hrp.Position - targetPos).Magnitude > 8 then
            _G.DeepTPAimbot.hrp.CFrame = CFrame.new(targetPos)
        end

        --Leaked By Xlu0 AndPrime--
        local cam = workspace.CurrentCamera
        if cam then
            cam.CFrame = CFrame.new(cam.CFrame.Position, targetRoot.Position)
        end

        --Leaked By Xlu0 AndPrime--
        _G.DeepTPAimbotTrySwing()
    end)

    if _G.DeepTPAimbotSetVisual then
        _G.DeepTPAimbotSetVisual(true)
    end

    return true
end

function _G.DeepStopTPAimbot()
    _G.DeepTPAimbotOn = false
    tpAimbotEnabled = false

    if _G.DeepTPAimbot and _G.DeepTPAimbot.conn then
        _G.DeepTPAimbot.conn:Disconnect()
        _G.DeepTPAimbot.conn = nil
    end

    if _G.DeepTPAimbot then
        _G.DeepTPAimbot.hittingCooldown = false
    end

    _G.DeepTPAimbotBatTarget = nil
    if _G.DeepCurrentAimbotTarget == _aimbotTargetPlr then
        _G.DeepCurrentAimbotTarget = nil
    end
    _aimbotTargetPlr = nil

    if _G.DeepTPAimbotSetVisual then
        _G.DeepTPAimbotSetVisual(false)
    end
end

function _G.DeepToggleTPAimbot()
    if _G.DeepTPAimbotOn then
        _G.DeepStopTPAimbot()
    else
        _G.DeepStartTPAimbot()
    end
end

function setTPAimbot(on)
    on = on == true
    if on then
        local ok = _G.DeepStartTPAimbot()
        if ok == false then
            tpAimbotEnabled = false
            if mobBtnRefs and mobBtnRefs.antiDesync then
                mobBtnRefs.antiDesync(false)
            end
            if setTPAimbotVisual then
                setTPAimbotVisual(false)
            end
            return false
        end
        tpAimbotEnabled = true
    else
        _G.DeepStopTPAimbot()
        tpAimbotEnabled = false
    end

    if setTPAimbotVisual then
        setTPAimbotVisual(tpAimbotEnabled)
    end
    if mobBtnRefs and mobBtnRefs.antiDesync then
        mobBtnRefs.antiDesync(tpAimbotEnabled)
    end
    return true
end

-- ============================================================
-- ANTI TP AIMBOT - EXEC FIX
-- O hook original roda em um chunk separado para evitar que
-- os locals dele sejam somados ao chunk enorme do Deep Duels.
-- A GUI própria do hook fica oculta.
-- ============================================================

antiTpAimbotEnabled = antiTpAimbotEnabled or false
setAntiTpAimbotVisual = setAntiTpAimbotVisual or nil

_G.DeepAntiTpHookSource = [====[
-- leaked in fs .gg/vGW4JQmcQS

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local NetworkClient = game:GetService("NetworkClient")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local environment = if getgenv then getgenv() else _G
local RUNTIME_KEY = "__HOOK_ANTI_ANTI_RECONSTRUCTION"

local previousRuntime = environment[RUNTIME_KEY]
if type(previousRuntime) == "table" and type(previousRuntime.destroy) == "function" then
    pcall(previousRuntime.destroy)
end

local runtime = {
    alive = true,
    enabled = false,
    awaitingKey = false,
    boundKey = Enum.KeyCode.Delete,
    character = nil,
    rootPart = nil,
    fakeRoot = nil,
    repRootOwner = nil,
    stepConnection = nil,
    connections = {},
    settingsRestore = {},
    captureGeneration = 0,
}
environment[RUNTIME_KEY] = runtime

local function connect(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(runtime.connections, connection)
    return connection
end

local function disconnect(connection)
    if connection then
        pcall(function()
            connection:Disconnect()
        end)
    end
end

local function createInstance(className, properties, parent)
    local object = Instance.new(className)
    for property, value in pairs(properties or {}) do
        object[property] = value
    end
    if parent then
        object.Parent = parent
    end
    return object
end

local function addCorner(parent, radius)
    return createInstance("UICorner", {
        CornerRadius = typeof(radius) == "UDim" and radius or UDim.new(0, radius),
    }, parent)
end

local function addStroke(parent, color, transparency, thickness)
    return createInstance("UIStroke", {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Color = color,
        Transparency = transparency,
        Thickness = thickness,
    }, parent)
end

local function playTween(object, duration, goals)
    local animation = TweenService:Create(
        object,
        TweenInfo.new(duration, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        goals
    )
    animation:Play()
    return animation
end

local function isBasePart(instance)
    if not instance then
        return false
    end
    local ok, result = pcall(function()
        return instance:IsA("BasePart")
    end)
    return ok and result == true
end

local function getCurrentRoot(character)
    character = character or LocalPlayer.Character
    if not character then
        return nil
    end

    local ok, root = pcall(function()
        return character:FindFirstChild("HumanoidRootPart")
    end)
    if ok and isBasePart(root) then
        return root
    end
    return nil
end

local function findGlobalFunction(...)
    for index = 1, select("#", ...) do
        local name = select(index, ...)
        local value = rawget(environment, name)
        if type(value) == "function" then
            return value
        end
    end
    return nil
end

local function setHidden(instance, property, value)
    if not instance then
        return false
    end

    local setter = findGlobalFunction(
        "sethiddenproperty",
        "set_hidden_property",
        "sethiddenprop",
        "set_hidden_prop"
    )
    if setter then
        local ok = pcall(setter, instance, property, value)
        if ok then
            return true
        end
    end

    return pcall(function()
        instance[property] = value
    end)
end

local function getHidden(instance, property)
    if not instance then
        return false, nil
    end

    local getter = findGlobalFunction(
        "gethiddenproperty",
        "get_hidden_property",
        "gethiddenprop",
        "get_hidden_prop"
    )
    if getter then
        local ok, value = pcall(getter, instance, property)
        if ok then
            return true, value
        end
    end

    local ok, value = pcall(function()
        return instance[property]
    end)
    return ok, value
end

local function rememberSetting(instance, property)
    local ok, value = pcall(function()
        return instance[property]
    end)
    if ok then
        table.insert(runtime.settingsRestore, {
            instance = instance,
            property = property,
            value = value,
        })
    end
end

local function applyPublicSetting(instance, property, value)
    if not instance then
        return false
    end
    rememberSetting(instance, property)
    return pcall(function()
        instance[property] = value
    end)
end

local function configurePhysics()
    setHidden(LocalPlayer, "MaximumSimulationRadius", math.huge)
    setHidden(LocalPlayer, "SimulationRadius", math.huge)

    pcall(function()
        local networkSettings = settings().Network
        applyPublicSetting(
            networkSettings,
            "InterpolationThrottling",
            Enum.InterpolationThrottlingMode.Disabled
        )
    end)

    pcall(function()
        local physicsSettings = settings().Physics
        applyPublicSetting(
            physicsSettings,
            "PhysicsEnvironmentalThrottle",
            Enum.EnviromentalPhysicsThrottle.Disabled
        )
        applyPublicSetting(physicsSettings, "AllowSleep", false)
    end)

    pcall(function()
        NetworkClient:SetOutgoingKBPSLimit(math.huge)
    end)
end

configurePhysics()

local FAKE_ROOT_NAME = "DavidDesyncRoot"
local FAKE_ROOT_Y = -2500
local FAKE_ROOT_VELOCITY = Vector3.new(0, -1000, 0)

local function fakeRootIsUsable()
    local fake = runtime.fakeRoot
    if not isBasePart(fake) then
        return false
    end
    local ok, parent = pcall(function()
        return fake.Parent
    end)
    return ok and parent ~= nil
end

local function destroyFakeRoot()
    local fake = runtime.fakeRoot
    runtime.fakeRoot = nil
    if fake then
        pcall(function()
            fake:Destroy()
        end)
    end
end

local function restoreReplicationRoot()
    local owner = runtime.repRootOwner or runtime.rootPart
    if isBasePart(owner) then
        setHidden(owner, "PhysicsRepRootPart", owner)
    end
    runtime.repRootOwner = nil
end

local function createFakeRoot(rootPart)
    destroyFakeRoot()

    local fake = createInstance("Part", {
        Name = FAKE_ROOT_NAME,
        Size = Vector3.new(2, 2, 1),
        Anchored = true,
        CanCollide = false,
        CanTouch = false,
        CanQuery = false,
        Transparency = 1,
        CFrame = CFrame.new(0, FAKE_ROOT_Y, 0),
        AssemblyLinearVelocity = FAKE_ROOT_VELOCITY,
    }, Workspace)

    local ok, position = pcall(function()
        return rootPart.Position
    end)
    if ok then
        fake.CFrame = CFrame.new(position.X, FAKE_ROOT_Y, position.Z)
    end

    runtime.fakeRoot = fake
    return fake
end

local function assignFakeReplicationRoot(rootPart, fake)
    if not isBasePart(rootPart) or not isBasePart(fake) then
        return false
    end

    setHidden(rootPart, "PhysicsRepRootPart", rootPart)
    runtime.repRootOwner = rootPart
    return setHidden(rootPart, "PhysicsRepRootPart", fake)
end

local function stepDesync()
    if not runtime.alive or not runtime.enabled then
        return
    end

    local root = runtime.rootPart
    if not isBasePart(root) then
        root = getCurrentRoot(runtime.character)
        runtime.rootPart = root
    end
    if not root then
        return
    end

    if not fakeRootIsUsable() then
        local fake = createFakeRoot(root)
        assignFakeReplicationRoot(root, fake)
        return
    end

    local fake = runtime.fakeRoot

    local ok, rootPosition, fakePosition = pcall(function()
        return root.Position, fake.Position
    end)
    if ok and (
        math.abs(rootPosition.X - fakePosition.X) > 0.01
        or math.abs(rootPosition.Z - fakePosition.Z) > 0.01
        or math.abs(fakePosition.Y - FAKE_ROOT_Y) > 0.01
    ) then
        pcall(function()
            fake.CFrame = CFrame.new(rootPosition.X, FAKE_ROOT_Y, rootPosition.Z)
        end)
    end

    pcall(function()
        fake.Anchored = true
        fake.AssemblyLinearVelocity = FAKE_ROOT_VELOCITY
    end)

    local gotValue, current = getHidden(root, "PhysicsRepRootPart")
    if not gotValue or current ~= fake then
        setHidden(root, "PhysicsRepRootPart", fake)
    end
end

local function stopStepConnection()
    disconnect(runtime.stepConnection)
    runtime.stepConnection = nil
end

local function startStepConnection()
    stopStepConnection()
    runtime.stepConnection = RunService.Stepped:Connect(stepDesync)
end

local function bindCharacter(character)
    local oldRoot = runtime.rootPart
    runtime.character = character
    runtime.rootPart = getCurrentRoot(character)

    if runtime.enabled then
        if isBasePart(oldRoot) and oldRoot ~= runtime.rootPart then
            setHidden(oldRoot, "PhysicsRepRootPart", oldRoot)
        end
        destroyFakeRoot()

        local root = runtime.rootPart
        if not root and character then
            local ok, waitedRoot = pcall(function()
                return character:WaitForChild("HumanoidRootPart", 8)
            end)
            if ok and isBasePart(waitedRoot) then
                root = waitedRoot
                runtime.rootPart = root
            end
        end

        if root then
            local fake = createFakeRoot(root)
            assignFakeReplicationRoot(root, fake)
            startStepConnection()
        end
    end
end

bindCharacter(LocalPlayer.Character)
connect(LocalPlayer.CharacterAdded, function(character)
    task.defer(bindCharacter, character)
end)

local COLORS = {
    main = Color3.fromRGB(12, 3, 12),
    row = Color3.fromRGB(26, 6, 22),
    track = Color3.fromRGB(32, 6, 26),
    button = Color3.fromRGB(18, 4, 20),
    text = Color3.new(1, 1, 1),
    muted = Color3.fromRGB(140, 110, 145),
    accent = Color3.fromRGB(217, 70, 239),
    rowStroke = Color3.fromRGB(190, 32, 168),
}

local uiParent = CoreGui
local oldGui = uiParent:FindFirstChild("HookAntiAntiUI")
if oldGui then
    oldGui:Destroy()
end

local screenGui = createInstance("ScreenGui", {
    Name = "HookAntiAntiUI",
    DisplayOrder = 999,
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, nil)

local parented = pcall(function()
    screenGui.Parent = uiParent
end)
if not parented then
    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        or LocalPlayer:WaitForChild("PlayerGui")
    uiParent = playerGui
    local stale = uiParent:FindFirstChild("HookAntiAntiUI")
    if stale then
        stale:Destroy()
    end
    screenGui.Parent = uiParent
end
runtime.gui = screenGui

local main = createInstance("Frame", {
    Name = "Main",
    Active = true,
    ClipsDescendants = true,
    BackgroundTransparency = 0.08,
    BackgroundColor3 = COLORS.main,
    BorderSizePixel = 0,
    Position = UDim2.new(0.5, -155, 0.5, -90),
    Size = UDim2.new(0, 310, 0, 175),
}, screenGui)
addCorner(main, 16)

local mainStroke = addStroke(main, Color3.new(1, 1, 1), 0, 1.8)
local outlineGradient = createInstance("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(75, 0, 125)),
        ColorSequenceKeypoint.new(0.20, Color3.fromRGB(165, 35, 240)),
        ColorSequenceKeypoint.new(0.45, Color3.fromRGB(235, 95, 255)),
        ColorSequenceKeypoint.new(0.50, Color3.new(1, 1, 1)),
        ColorSequenceKeypoint.new(0.55, Color3.fromRGB(235, 95, 255)),
        ColorSequenceKeypoint.new(0.80, Color3.fromRGB(165, 35, 240)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(75, 0, 125)),
    }),
    Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0.00, 0.75),
        NumberSequenceKeypoint.new(0.25, 0.40),
        NumberSequenceKeypoint.new(0.50, 0.00),
        NumberSequenceKeypoint.new(0.75, 0.40),
        NumberSequenceKeypoint.new(1.00, 0.75),
    }),
    Rotation = 0,
}, mainStroke)

local mainScale = createInstance("UIScale", {
    Scale = 1,
}, main)

local backdrop = createInstance("ImageLabel", {
    Name = "Backdrop",
    ScaleType = Enum.ScaleType.Crop,
    ImageTransparency = 0.22,
    AnchorPoint = Vector2.new(1, 0),
    Image = "rbxasset://e108b292ebba4c47d7bac2a9aef23afa/hooklagger_bg.png",
    BackgroundTransparency = 1,
    Position = UDim2.new(1, 10, 0, -5),
    ZIndex = 1,
    Size = UDim2.new(0, 210, 1, 10),
}, main)
addCorner(backdrop, 16)

local header = createInstance("Frame", {
    Name = "Header",
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 16, 0, 6),
    ZIndex = 10,
    Size = UDim2.new(1, -24, 0, 40),
}, main)
addCorner(header, 6)

local logo = createInstance("ImageLabel", {
    Name = "Logo",
    BackgroundTransparency = 1,
    Image = "rbxasset://e108b292ebba4c47d7bac2a9aef23afa/hookduels_logo.png",
    Position = UDim2.new(0, 2, 0, 6),
    ZIndex = 11,
    Size = UDim2.new(0, 28, 0, 28),
}, header)
addCorner(logo, 6)

local title = createInstance("TextLabel", {
    Name = "Title",
    BackgroundTransparency = 1,
    Text = "HOOK ANTI ANTI",
    TextColor3 = COLORS.text,
    Font = Enum.Font.GothamBlack,
    Position = UDim2.new(0, 38, 0, 0),
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 11,
    TextSize = 14,
    Size = UDim2.new(1, -40, 1, 0),
}, header)

local content = createInstance("Frame", {
    Name = "Content",
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 18, 0, 48),
    ZIndex = 5,
    Size = UDim2.new(1, -28, 1, -54),
}, main)
createInstance("UIListLayout", {
    Padding = UDim.new(0, 8),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, content)

local function makeRow(name, layoutOrder)
    local row = createInstance("Frame", {
        Name = name,
        BackgroundColor3 = COLORS.row,
        BackgroundTransparency = 0.25,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 46),
        LayoutOrder = layoutOrder,
        ZIndex = 5,
    }, content)
    addCorner(row, 10)

    createInstance("UIGradient", {
        Color = ColorSequence.new(
            Color3.new(1, 1, 1),
            Color3.fromRGB(205, 210, 230)
        ),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0.00, 0.55),
            NumberSequenceKeypoint.new(0.50, 0.85),
            NumberSequenceKeypoint.new(1.00, 0.70),
        }),
        Rotation = 90,
    }, row)
    addStroke(row, COLORS.rowStroke, 0.60, 1)
    return row
end

local toggleRow = makeRow("AntiAntiRow", 1)
local toggleLabel = createInstance("TextLabel", {
    Name = "Label",
    BackgroundTransparency = 1,
    Text = "Enable Anti Anti",
    TextColor3 = COLORS.text,
    Font = Enum.Font.GothamBold,
    Position = UDim2.new(0, 14, 0, 6),
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 6,
    TextSize = 13,
    Size = UDim2.new(1, -74, 0, 18),
}, toggleRow)

local statusLabel = createInstance("TextLabel", {
    Name = "Status",
    BackgroundTransparency = 1,
    Text = "OFF",
    TextColor3 = COLORS.muted,
    Font = Enum.Font.GothamBold,
    Position = UDim2.new(0, 14, 0, 24),
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 6,
    TextSize = 9,
    Size = UDim2.new(1, -74, 0, 14),
}, toggleRow)

local toggleTrack = createInstance("Frame", {
    Name = "Toggle",
    AnchorPoint = Vector2.new(1, 0.5),
    BackgroundColor3 = COLORS.track,
    BorderSizePixel = 0,
    Position = UDim2.new(1, -12, 0.5, 0),
    ZIndex = 7,
    Size = UDim2.new(0, 44, 0, 22),
}, toggleRow)
addCorner(toggleTrack, 11)
addStroke(toggleTrack, COLORS.rowStroke, 0.50, 1.2)

local toggleKnob = createInstance("Frame", {
    Name = "Knob",
    BackgroundColor3 = Color3.new(1, 1, 1),
    BorderSizePixel = 0,
    Size = UDim2.new(0, 16, 0, 16),
    Position = UDim2.new(0, 3, 0, 3),
    ZIndex = 8,
}, toggleTrack)
addCorner(toggleKnob, UDim.new(1, 0))

local toggleHit = createInstance("TextButton", {
    Name = "ToggleHit",
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Text = "",
    AutoButtonColor = false,
    ZIndex = 9,
    Size = UDim2.new(1, 0, 1, 0),
}, toggleRow)

local keybindRow = makeRow("KeybindRow", 2)
local keybindLabel = createInstance("TextLabel", {
    Name = "Label",
    BackgroundTransparency = 1,
    Text = "Keybind",
    TextColor3 = COLORS.text,
    Font = Enum.Font.GothamBold,
    Position = UDim2.new(0, 14, 0, 0),
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 6,
    TextSize = 13,
    Size = UDim2.new(1, -84, 1, 0),
}, keybindRow)

local keybindButton = createInstance("TextButton", {
    Name = "KeybindBtn",
    AutoButtonColor = false,
    AnchorPoint = Vector2.new(1, 0.5),
    BackgroundColor3 = COLORS.button,
    BackgroundTransparency = 0.30,
    BorderSizePixel = 0,
    Position = UDim2.new(1, -12, 0.5, 0),
    Size = UDim2.new(0, 76, 0, 26),
    Text = "Delete",
    TextColor3 = COLORS.accent,
    Font = Enum.Font.GothamBlack,
    TextSize = 11,
    ZIndex = 7,
}, keybindRow)
addCorner(keybindButton, 7)
addStroke(keybindButton, COLORS.rowStroke, 0.50, 1)

local function ripple(row)
    if not runtime.alive or not row or not row.Parent then
        return
    end

    local mousePosition = UserInputService:GetMouseLocation()
    local absolutePosition = row.AbsolutePosition
    local absoluteSize = row.AbsoluteSize
    local x = mousePosition.X - absolutePosition.X
    local y = mousePosition.Y - absolutePosition.Y
    local diameter = math.max(absoluteSize.X, absoluteSize.Y) * 1.35

    local image = createInstance("ImageLabel", {
        Name = "Ripple",
        BackgroundTransparency = 1,
        Image = "rbxassetid://266543268",
        ImageColor3 = COLORS.accent,
        ImageTransparency = 0.40,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0, x, 0, y),
        Size = UDim2.new(0, 0, 0, 0),
        ZIndex = 30,
    }, row)

    local animation = playTween(image, 0.45, {
        Size = UDim2.new(0, diameter, 0, diameter),
        ImageTransparency = 1,
    })
    animation.Completed:Connect(function()
        if image then
            image:Destroy()
        end
    end)
end

local function applyEnabledVisual(value, instant)
    statusLabel.Text = value and "ACTIVE" or "OFF"
    statusLabel.TextColor3 = value and COLORS.accent or COLORS.muted

    local trackColor = value and Color3.fromRGB(122, 30, 134) or COLORS.track
    local knobPosition = value and UDim2.new(1, -19, 0, 3)
        or UDim2.new(0, 3, 0, 3)

    if instant then
        toggleTrack.BackgroundColor3 = trackColor
        toggleKnob.Position = knobPosition
    else
        playTween(toggleTrack, 0.18, { BackgroundColor3 = trackColor })
        playTween(toggleKnob, 0.18, { Position = knobPosition })
    end
end

local function setEnabled(value)
    if not runtime.alive then
        return false
    end

    value = value == true
    if runtime.enabled == value then
        applyEnabledVisual(value, false)
        return value
    end

    runtime.enabled = value
    applyEnabledVisual(value, false)

    if value then
        local root = getCurrentRoot(runtime.character)
        runtime.rootPart = root
        if not root then
            runtime.enabled = false
            applyEnabledVisual(false, false)
            return false
        end

        local fake = createFakeRoot(root)
        assignFakeReplicationRoot(root, fake)
        startStepConnection()
    else
        stopStepConnection()
        restoreReplicationRoot()
        destroyFakeRoot()
    end

    return runtime.enabled
end

local function toggleEnabled()
    return setEnabled(not runtime.enabled)
end

connect(toggleHit.MouseButton1Click, function()
    ripple(toggleRow)
    toggleEnabled()
end)

connect(keybindButton.MouseButton1Click, function()
    if not runtime.alive or runtime.awaitingKey then
        return
    end

    ripple(keybindRow)
    runtime.awaitingKey = true
    runtime.captureGeneration += 1
    local generation = runtime.captureGeneration

    task.spawn(function()
        for _, text in ipairs({".", "..", "..."}) do
            if not runtime.alive
                or not runtime.awaitingKey
                or generation ~= runtime.captureGeneration
            then
                return
            end
            keybindButton.Text = text
            task.wait(0.15)
        end
    end)
end)

connect(UserInputService.InputBegan, function(input, gameProcessed)
    if not runtime.alive then
        return
    end

    if runtime.awaitingKey then
        if input.UserInputType == Enum.UserInputType.Keyboard
            and input.KeyCode ~= Enum.KeyCode.Unknown
        then
            if input.KeyCode ~= Enum.KeyCode.Escape then
                runtime.boundKey = input.KeyCode
            end
            runtime.awaitingKey = false
            runtime.captureGeneration += 1
            keybindButton.Text = runtime.boundKey.Name
        end
        return
    end

    if not gameProcessed and input.KeyCode == runtime.boundKey then
        ripple(toggleRow)
        toggleEnabled()
    end
end)

local dragging = false
local dragInput = nil
local dragStart = nil
local startPosition = nil

connect(main.InputBegan, function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch
    then
        dragging = true
        dragInput = input
        dragStart = input.Position
        startPosition = main.Position

        local changedConnection
        changedConnection = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                dragInput = nil
                disconnect(changedConnection)
            end
        end)
    end
end)

connect(main.InputChanged, function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    then
        dragInput = input
    end
end)

connect(UserInputService.InputChanged, function(input)
    if not dragging or input ~= dragInput or not dragStart or not startPosition then
        return
    end

    local delta = input.Position - dragStart
    main.Position = UDim2.new(
        startPosition.X.Scale,
        startPosition.X.Offset + delta.X,
        startPosition.Y.Scale,
        startPosition.Y.Offset + delta.Y
    )
end)

connect(RunService.RenderStepped, function(deltaTime)
    if not runtime.alive or not outlineGradient.Parent then
        return
    end
    outlineGradient.Rotation = (outlineGradient.Rotation + deltaTime * 140) % 360
end)

local function destroy()
    if not runtime.alive then
        return
    end

    runtime.alive = false
    runtime.enabled = false
    runtime.awaitingKey = false
    runtime.captureGeneration += 1

    stopStepConnection()
    restoreReplicationRoot()
    destroyFakeRoot()

    for _, connection in ipairs(runtime.connections) do
        disconnect(connection)
    end
    table.clear(runtime.connections)

    for index = #runtime.settingsRestore, 1, -1 do
        local entry = runtime.settingsRestore[index]
        pcall(function()
            entry.instance[entry.property] = entry.value
        end)
    end
    table.clear(runtime.settingsRestore)

    if runtime.gui then
        pcall(function()
            runtime.gui:Destroy()
        end)
    end

    if environment[RUNTIME_KEY] == runtime then
        environment[RUNTIME_KEY] = nil
    end
end

runtime.setEnabled = setEnabled
runtime.toggle = toggleEnabled
runtime.step = stepDesync
runtime.bindCharacter = bindCharacter
runtime.setHidden = setHidden
runtime.getHidden = getHidden
runtime.destroy = destroy
runtime.getBoundKey = function()
    return runtime.boundKey
end
runtime.setBoundKey = function(keyCode)
    if keyCode and keyCode ~= Enum.KeyCode.Unknown then
        runtime.boundKey = keyCode
        keybindButton.Text = keyCode.Name
        return true
    end
    return false
end

applyEnabledVisual(false, true)
]====]

function setAntiTpAimbot(on)
    on = (on == true)

    local env = (getgenv and getgenv()) or _G
    local runtimeKey = "__HOOK_ANTI_ANTI_RECONSTRUCTION"
    local runtime = env[runtimeKey]

    if on then
        if type(runtime) ~= "table" or runtime.alive == false or type(runtime.setEnabled) ~= "function" then
            if type(loadstring) ~= "function" then
                antiTpAimbotEnabled = false
                if setAntiTpAimbotVisual then
                    pcall(function() setAntiTpAimbotVisual(false) end)
                end
                warn("DEEP DUELS - loadstring não está disponível para o Anti Tp Aimbot.")
                return false
            end

            local ok, err = pcall(function()
                local fn = loadstring(_G.DeepAntiTpHookSource)
                if not fn then
                    error("Falha ao compilar o hook Anti Tp Aimbot.")
                end
                fn()
            end)

            if not ok then
                warn("DEEP DUELS - Anti Tp Aimbot hook error:", err)
                antiTpAimbotEnabled = false
                if setAntiTpAimbotVisual then
                    pcall(function() setAntiTpAimbotVisual(false) end)
                end
                return false
            end

            runtime = env[runtimeKey]
        end

        if type(runtime) ~= "table" or type(runtime.setEnabled) ~= "function" then
            antiTpAimbotEnabled = false
            if setAntiTpAimbotVisual then
                pcall(function() setAntiTpAimbotVisual(false) end)
            end
            warn("DEEP DUELS - runtime do Anti Tp Aimbot não foi criado.")
            return false
        end

        if runtime.gui then
            pcall(function()
                runtime.gui.Enabled = false
            end)
        end

        -- Impede o Delete do hook de controlar a função por fora do Deep Duels.
        runtime.boundKey = Enum.KeyCode.Unknown

        local ok, result = pcall(function()
            return runtime.setEnabled(true)
        end)

        antiTpAimbotEnabled = ok and (result == true or runtime.enabled == true)

        if not antiTpAimbotEnabled then
            warn("DEEP DUELS - Anti Tp Aimbot não conseguiu ativar.")
        end
    else
        if type(runtime) == "table" then
            if runtime.gui then
                pcall(function()
                    runtime.gui.Enabled = false
                end)
            end

            if type(runtime.setEnabled) == "function" then
                pcall(function()
                    runtime.setEnabled(false)
                end)
            end
        end

        antiTpAimbotEnabled = false
    end

    if setAntiTpAimbotVisual then
        pcall(function()
            setAntiTpAimbotVisual(antiTpAimbotEnabled)
        end)
    end
    if mobBtnRefs and mobBtnRefs.antiTpAimbot then
        pcall(function()
            mobBtnRefs.antiTpAimbot(antiTpAimbotEnabled)
        end)
    end

    if type(saveConfig) == "function" then
        pcall(saveConfig)
    end

    return antiTpAimbotEnabled
end


if bodyLockEnabled==nil then bodyLockEnabled=false end 
bodyLockRadius=bodyLockRadius or 60 
bodyLockConn=bodyLockConn or nil 
setBodyLockVisual=setBodyLockVisual or nil 
bodyLockRadiusBox=bodyLockRadiusBox or nil 
function getNearestBodyLockTarget() 
    local character=LP.Character 
    local root=character and character:FindFirstChild("HumanoidRootPart") 
    if not root then return nil end 
    local nearest=nil 
    local shortest=math.huge 
    for _,plr in ipairs(Players:GetPlayers()) do 
        if plr~=LP and plr.Character then 
            local tr=plr.Character:FindFirstChild("HumanoidRootPart") 
            local hum=plr.Character:FindFirstChildOfClass("Humanoid") 
            if tr and hum and hum.Health>0 then 
                local d=(tr.Position-root.Position).Magnitude 
                if d<=bodyLockRadius and d<shortest then shortest=d nearest=plr end 
            end 
        end 
    end 
    return nearest 
end 
function startBodyLock() 
    if bodyLockConn then return end 
    bodyLockEnabled=true 
    bodyLockConn=RunService.Heartbeat:Connect(function() 
        if not bodyLockEnabled then return end 
        local character=LP.Character 
        local myRoot=character and character:FindFirstChild("HumanoidRootPart") 
        local humanoid=character and character:FindFirstChildOfClass("Humanoid") 
        if not myRoot or not humanoid or humanoid.Health<=0 then return end 
        local target=getNearestBodyLockTarget() 
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then 
            local targetPos=target.Character.HumanoidRootPart.Position 
            local myPos=myRoot.Position 
            local offset=Vector3.new(targetPos.X,myPos.Y,targetPos.Z)-myPos 
            if offset.Magnitude>0.1 then 
                humanoid.AutoRotate=false 
                local lookDir=offset.Unit 
                local currentDir=myRoot.CFrame.LookVector 
                local cross=currentDir:Cross(lookDir) 
                local currentVel=myRoot.AssemblyAngularVelocity 
                myRoot.AssemblyAngularVelocity=Vector3.new(currentVel.X,cross.Y*40,currentVel.Z) 
            end 
        else 
            humanoid.AutoRotate=true 
        end 
    end) 
end 
function stopBodyLock() 
    bodyLockEnabled=false 
    if bodyLockConn then bodyLockConn:Disconnect();bodyLockConn=nil end 
    local hum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") 
    if hum then hum.AutoRotate=true end 
end 
function setBodyLock(on) 
    bodyLockEnabled=on 
    if on then startBodyLock() else stopBodyLock() end 
    if setBodyLockVisual then setBodyLockVisual(on) end 
    pcall(saveConfig) 
end 
LP.CharacterAdded:Connect(function(char) 
    task.wait(0.5) 
    setupSpeedIndicator(char) 
    if medusaCounterEnabled then setupMedusa(char) end 
    if batCounterEnabled then startBatCounter() end
    if unwalkEnabled then task.wait(0.5);startUnwalk() end 
end) 
if LP.Character then setupSpeedIndicator(LP.Character) end 
if mobileButtonsSize==nil then mobileButtonsSize=100 end 
if mobileButtonShape==nil then mobileButtonShape="squarcle" end 
if mobileDragSmall==nil then mobileDragSmall=false end 
if mobileMovingMode==nil then mobileMovingMode=false end 
if hubImageChoice==nil then hubImageChoice=1 end 
if buttonImageChoice==nil then buttonImageChoice=1 end 
local HUB_ARTS={[1]="rbxassetid://82054758948423",[2]="rbxthumb://type=Asset&id=97069004530020&w=420&h=420"}
local BUTTON_ARTS={[1]="rbxassetid://82054758948423",[2]="rbxthumb://type=Asset&id=97069004530020&w=420&h=420"}
hubBgImageRef=hubBgImageRef or nil
mobBtnRefs=mobBtnRefs or {} 
mobLastLiveSave=mobLastLiveSave or 0 
mobGuiRef=mobGuiRef or nil 
mobContainerRef=mobContainerRef or nil 
mobBtnSavedContainerPos=mobBtnSavedContainerPos or nil 
mobBtnSavedIndPos=mobBtnSavedIndPos or {} 
setMobileDragSmallVisual=setMobileDragSmallVisual or nil 
setMobileMovingModeVisual=setMobileMovingModeVisual or nil 
local configPersistenceEnabled = false
pcall(function()
    if isfile and isfile("exeMobile.json") then configPersistenceEnabled = true end
end)
function deleteSavedConfig()
    configPersistenceEnabled = false
    if delfile then
        pcall(function() if isfile and isfile("exeMobile.json") then delfile("exeMobile.json") end end)
    end
end

local function getHubArtImage()
    return HUB_ARTS[hubImageChoice] or HUB_ARTS[1]
end

local function getButtonArtImage()
    return BUTTON_ARTS[buttonImageChoice] or BUTTON_ARTS[1]
end

local function applyHubArtNow()
    if hubBgImageRef and hubBgImageRef.Parent then
        hubBgImageRef.Image = getHubArtImage()
    end
end

function saveMobileButtonPositions() 
    if not mobGuiRef then return end 
    local container=mobGuiRef:FindFirstChild("Buttons") 
    if not container then return end 
    mobBtnSavedContainerPos={xs=container.Position.X.Scale,xo=container.Position.X.Offset,ys=container.Position.Y.Scale,yo=container.Position.Y.Offset} 
    mobBtnSavedIndPos={} 
    for _,b in ipairs(container:GetChildren()) do 
        if b:IsA("Frame") and b:GetAttribute("Idx") then 
            mobBtnSavedIndPos[tostring(b:GetAttribute("Idx"))]={xs=b.Position.X.Scale,xo=b.Position.X.Offset,ys=b.Position.Y.Scale,yo=b.Position.Y.Offset} 
        end 
    end 
end 
function saveMobileButtonsConfigOnly() 
    if not configPersistenceEnabled then return end
    pcall(saveMobileButtonPositions) 
    pcall(function() 
        if not (writefile and HS) then return end 
        local cfg={} 
        pcall(function() 
            if isfile and isfile("exeMobile.json") and readfile then 
                local old=HS:JSONDecode(readfile("exeMobile.json")) 
                if type(old)=="table" then cfg=old end 
            end 
        end) 
        cfg.mobileButtonsSize=mobileButtonsSize 
        cfg.mobileButtonShape=mobileButtonShape 
        cfg.mobileDragSmall=mobileDragSmall 
        cfg.mobileMovingMode=mobileMovingMode 
        cfg.hubImageChoice=hubImageChoice
        cfg.buttonImageChoice=buttonImageChoice
        cfg.mobBtnSavedContainerPos=mobBtnSavedContainerPos 
        cfg.mobBtnSavedIndPos=mobBtnSavedIndPos 
        cfg.uiScale=uiScale 
        writefile("exeMobile.json",HS:JSONEncode(cfg)) 
    end) 
end 
function destroyMobileButtons() 
    if mobGuiRef then pcall(saveMobileButtonPositions);pcall(function() mobGuiRef:Destroy() end);mobGuiRef=nil end
    mobContainerRef=nil 
    for _,n in ipairs({"ExeMobileButtons","WhiteMobileButtons","AdaptMobileButtons"}) do 
        local old=game:GetService("CoreGui"):FindFirstChild(n);if old then old:Destroy() end 
        local pg=LP:FindFirstChild("PlayerGui");if pg then local o=pg:FindFirstChild(n);if o then o:Destroy() end end 
    end 
    mobBtnRefs={} 
end 
function resetMobileButtonPositions() 
    if mobGuiRef then pcall(function() mobGuiRef:Destroy() end);mobGuiRef=nil end 
    for _,n in ipairs({"ExeMobileButtons","WhiteMobileButtons","AdaptMobileButtons"}) do 
        local old=game:GetService("CoreGui"):FindFirstChild(n);if old then old:Destroy() end 
        local pg=LP:FindFirstChild("PlayerGui");if pg then local o=pg:FindFirstChild(n);if o then o:Destroy() end end 
    end 
    mobBtnSavedContainerPos=nil 
    mobBtnSavedIndPos={} 
    mobileMovingMode=false 
    if setMobileMovingModeVisual then pcall(function() setMobileMovingModeVisual(false) end) end 
    buildMobileButtons() 
    pcall(saveConfig);saveMobileButtonsConfigOnly() 
    task.delay(0.2,function() pcall(saveConfig);saveMobileButtonsConfigOnly() end) 
end 
task.spawn(function() 
    while task.wait(0.5) do 
        pcall(function() 
            saveMobileButtonPositions() 
            saveConfig() 
            saveMobileButtonsConfigOnly() 
        end) 
    end 
end) 
function buildMobileButtons() 
    destroyMobileButtons() 
    local MB_SIZE=math.floor(82*(mobileButtonsSize or 100)/100) 
    local MB_GAP=8 
    local COLS=3 
    local ROWS=4 
    local totalW=COLS*MB_SIZE+(COLS-1)*MB_GAP 
    local totalH=ROWS*MB_SIZE+(ROWS-1)*MB_GAP 
    local WHITE=Color3.fromRGB(255,255,255) 
    local BG=Color3.fromRGB(8,8,12) 
    local OFF=Color3.fromRGB(28,28,35) 
    local DIM=Color3.fromRGB(150,150,150) 
    local W=Color3.fromRGB(255,255,255) 
    local ON_BG=Color3.fromRGB(40,40,50) 
    local defs={ 
        {top="DROP",bot="BRAINROT",key="drop",oneShot=true,layout="stacked"}, 
        {top="AUTO",bot="LEFT",key="autoLeft",layout="stacked"}, 
        {top="BAT",bot="AIMBOT",key="autoBat",layout="stacked"}, 
        {top="AUTO",bot="RIGHT",key="autoRight",layout="stacked"}, 
        {top="TP",bot="DOWN",key="tpDown",oneShot=true,layout="stacked"}, 
        {top="CARRY",bot="SPEED",key="carrySpeed",layout="stacked"}, 
        {top="LAGGER",bot="SPEED",key="laggerSpeed",layout="stacked"}, 
        {top="LAGGER",bot="CARRY",key="laggerCarry",layout="stacked"}, 
        {top="BAT V2",bot="",key="aimbot2",layout="stacked"}, 
        {top="TP",bot="AIMBOT",key="antiDesync",layout="stacked"},
        {top="ANTI TP",bot="AIMBOT",key="antiTpAimbot",layout="stacked"}, 
    } 
    local function getCorner() 
        if mobileButtonShape=="circle" then return UDim.new(1,0) 
        elseif mobileButtonShape=="straight" then return UDim.new(0,0) 
        elseif mobileButtonShape=="squarcle" then return UDim.new(0,14) 
        else return UDim.new(0,12) end 
    end 
    local g=Instance.new("ScreenGui");g.Name="DeepDuels";g.ResetOnSpawn=false;g.DisplayOrder=20;g.IgnoreGuiInset=true 
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(g) end end) 
    if not pcall(function() g.Parent=game:GetService("CoreGui") end) then g.Parent=LP:WaitForChild("PlayerGui") end 
    mobGuiRef=g 
    local container=Instance.new("Frame",g);container.Name="Buttons";container.Size=UDim2.new(0,totalW,0,totalH);container.Position=UDim2.new(1,-(totalW+10),0,80);container.BackgroundTransparency=1;container.BorderSizePixel=0
    mobContainerRef=container
    -- IMPORTANTE: fora do Edit Buttons, o frame transparente não captura toque.
    -- Isso deixa o botão nativo de pulo do Roblox funcionar normalmente.
    container.Active=(mobileMovingMode==true and not uiLocked)

    -- Área branca/conjunto: move TODOS os botões juntos apenas no modo Edit Buttons.
    local groupDrag=false
    local groupDragStart=nil
    local groupStartPos=nil
    container.InputBegan:Connect(function(input)
        if uiLocked or not mobileMovingMode then return end
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            groupDrag=true
            groupDragStart=input.Position
            groupStartPos=container.Position
            input.Changed:Connect(function()
                if input.UserInputState==Enum.UserInputState.End then
                    groupDrag=false
                    mobBtnSavedContainerPos={xs=container.Position.X.Scale,xo=container.Position.X.Offset,ys=container.Position.Y.Scale,yo=container.Position.Y.Offset}
                    saveMobileButtonsConfigOnly()
                end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if not groupDrag then return end
        if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then
            local d=input.Position-groupDragStart
            container.Position=UDim2.new(groupStartPos.X.Scale,groupStartPos.X.Offset+d.X,groupStartPos.Y.Scale,groupStartPos.Y.Offset+d.Y)
        end
    end)
    if mobBtnSavedContainerPos then container.Position=UDim2.new(mobBtnSavedContainerPos.xs,mobBtnSavedContainerPos.xo,mobBtnSavedContainerPos.ys,mobBtnSavedContainerPos.yo) end 
    for i,def in ipairs(defs) do 
        local col=(i-1)%COLS;local row=math.floor((i-1)/COLS) 
        local b=Instance.new("Frame",container);b:SetAttribute("Idx",i);b.Size=UDim2.new(0,MB_SIZE,0,MB_SIZE);b.Position=UDim2.new(0,col*(MB_SIZE+MB_GAP),0,row*(MB_SIZE+MB_GAP));b.BackgroundColor3=OFF;b.BorderSizePixel=0;b.ClipsDescendants=true;b.Active=false 
        local savedInd=mobBtnSavedIndPos and mobBtnSavedIndPos[tostring(i)] 
        if type(savedInd)=="table" then 
            b.Position=UDim2.new(savedInd.xs or 0,savedInd.xo or 0,savedInd.ys or 0,savedInd.yo or 0) 
        end 

        Instance.new("UICorner",b).CornerRadius=getCorner() 
        local art=Instance.new("ImageLabel",b);art.Name="Art";art.BackgroundTransparency=1;art.Image=getButtonArtImage();art.ScaleType=Enum.ScaleType.Crop;art.Size=UDim2.new(1,0,1,0);art.Position=UDim2.new(0,0,0,0);art.ZIndex=1;art.ImageTransparency=0.6
        Instance.new("UICorner",art).CornerRadius=getCorner()
        local artShade=Instance.new("Frame",b);artShade.Name="ArtShade";artShade.Size=UDim2.new(1,0,1,0);artShade.Position=UDim2.new(0,0,0,0);artShade.BackgroundColor3=Color3.fromRGB(0,0,0);artShade.BackgroundTransparency=0.45;artShade.BorderSizePixel=0;artShade.ZIndex=2
        Instance.new("UICorner",artShade).CornerRadius=getCorner()
        local st=Instance.new("UIStroke",b);st.Color=Color3.fromRGB(70,70,80);st.Thickness=1.4;st.Transparency=0 
        local top=Instance.new("TextLabel",b);top.BackgroundTransparency=1;top.Text=def.top;top.TextColor3=W;top.Font=Enum.Font.SciFi;top.TextSize=math.max(8,math.floor(10*mobileButtonsSize/100));top.TextStrokeTransparency=0;top.TextStrokeColor3=Color3.fromRGB(0,0,0);top.ZIndex=3 
        local bot=Instance.new("TextLabel",b);bot.BackgroundTransparency=1;bot.Text=def.bot;bot.TextColor3=W;bot.Font=Enum.Font.SciFi;bot.TextSize=math.max(7,math.floor(7.5*mobileButtonsSize/100));bot.TextStrokeTransparency=0;bot.TextStrokeColor3=Color3.fromRGB(0,0,0);bot.ZIndex=3 
        if def.key=="aimbot2" then bot.TextScaled=true end 
        top.TextYAlignment=Enum.TextYAlignment.Center 
        bot.TextYAlignment=Enum.TextYAlignment.Center 
        top.TextXAlignment=Enum.TextXAlignment.Center 
        bot.TextXAlignment=Enum.TextXAlignment.Center 
        top.TextStrokeTransparency=1 
        bot.TextStrokeTransparency=1 
        if def.layout=="sideBySide" then 
            top.Size=UDim2.new(0.5,0,1,0);top.Position=UDim2.new(0,0,0,0) 
            bot.Size=UDim2.new(0.5,0,1,0);bot.Position=UDim2.new(0.5,0,0,0) 
        elseif def.bot=="" then 
            top.Size=UDim2.new(1,-8,1,-8);top.Position=UDim2.new(0,4,0,4);top.TextScaled=true;top.TextWrapped=false 
            bot.Size=UDim2.new(0,0,0,0);bot.Position=UDim2.new(0,0,0,0) 
        else 
            top.Size=UDim2.new(1,-8,0.5,-4);top.Position=UDim2.new(0,4,0,2);top.TextScaled=true;top.TextWrapped=false 
            bot.Size=UDim2.new(1,-8,0.5,-4);bot.Position=UDim2.new(0,4,0.5,2);bot.TextScaled=true;bot.TextWrapped=false 
        end 
        local on=false 
        local function setOn(state) 
            on=(state==true) 
            art.Image=getButtonArtImage()
            if on then 
                b.BackgroundColor3=Color3.fromRGB(255,255,255) 
                art.ImageTransparency=0.38
                artShade.BackgroundTransparency=0.62
                top.TextColor3=Color3.fromRGB(0,0,0) 
                bot.TextColor3=Color3.fromRGB(0,0,0) 
                st.Color=Color3.fromRGB(255,255,255) 
            else 
                b.BackgroundColor3=Color3.fromRGB(0,0,0) 
                art.ImageTransparency=0.6
                artShade.BackgroundTransparency=0.45
                top.TextColor3=Color3.fromRGB(255,255,255) 
                bot.TextColor3=Color3.fromRGB(255,255,255) 
                st.Color=Color3.fromRGB(70,70,80) 
            end 
        end 
        mobBtnRefs[def.key]=setOn 
        if def.key=="autoLeft" then setOn(autoLeftEnabled) 
        elseif def.key=="autoRight" then setOn(autoRightEnabled) 
        elseif def.key=="autoBat" then setOn(autoBatEnabled) 
        elseif def.key=="carrySpeed" then setOn(speedMode and not laggerToggled) 
        elseif def.key=="laggerSpeed" then setOn(laggerToggled and laggerPhase==1) 
        elseif def.key=="laggerCarry" then setOn(laggerToggled and laggerPhase==2) 
        elseif def.key=="aimbot2" then setOn(aimbot2Enabled) 
        elseif def.key=="antiDesync" then setOn(tpAimbotEnabled)
        elseif def.key=="antiTpAimbot" then setOn(antiTpAimbotEnabled) 
        end 
        local hit=Instance.new("TextButton",b) 
        hit.Name="Hitbox";hit.Size=UDim2.new(1,0,1,0);hit.Position=UDim2.new(0,0,0,0);hit.BackgroundTransparency=1;hit.Text="";hit.ZIndex=20;hit.AutoButtonColor=false 
        local dragging=false 
        local dragStart=nil 
        local startPos=nil 
        local moved=false 
        hit.InputBegan:Connect(function(input) 
            if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then 
                local freeOrangeButton = (def.key=="aimbot2" or def.key=="antiDesync")
                -- Lock UI trava todos os botões, inclusive BAT V2 e TP AIMBOT.
                if uiLocked then return end
                -- BAT V2 e TP AIMBOT podem mover livremente enquanto a UI estiver destravada.
                if not freeOrangeButton and not mobileMovingMode then return end
                dragging=true moved=false dragStart=input.Position startPos=b.Position 
                input.Changed:Connect(function() 
                    if input.UserInputState==Enum.UserInputState.End then dragging=false end 
                end) 
            end 
        end) 
        UIS.InputChanged:Connect(function(input) 
            if not dragging then return end
            if uiLocked then dragging=false return end
            if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then 
                local d=input.Position-dragStart 
                if math.abs(d.X)>5 or math.abs(d.Y)>5 then moved=true end 
                if moved then 
                    b.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y) 
                    mobBtnSavedIndPos[tostring(i)]={xs=b.Position.X.Scale,xo=b.Position.X.Offset,ys=b.Position.Y.Scale,yo=b.Position.Y.Offset} 
                    saveMobileButtonsConfigOnly() 
                end 
            end 
        end) 
        hit.InputEnded:Connect(function(input) 
            if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then 
                local freeOrangeButton = (def.key=="aimbot2" or def.key=="antiDesync")
                if not moved and (not mobileMovingMode or freeOrangeButton) then 
                    if def.key=="drop" then 
                        runJumpDrop() 
                        setOn(true) 
                        task.delay(0.45,function() setOn(false) end) 
                    elseif def.key=="tpDown" then 
                        task.spawn(runTPFloor);setOn(true);task.delay(0.35,function() setOn(false) end) 
                    elseif def.key=="autoLeft" then 
                        autoLeftEnabled=not autoLeftEnabled;if autoLeftEnabled then queueAutoLeftStart() else stopAutoLeft() end;if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end;setOn(autoLeftEnabled);if mobBtnRefs.autoRight then mobBtnRefs.autoRight(autoRightEnabled) end;saveConfig();saveMobileButtonsConfigOnly() 
                    elseif def.key=="autoRight" then 
                        autoRightEnabled=not autoRightEnabled;if autoRightEnabled then queueAutoRightStart() else stopAutoRight() end;if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end;setOn(autoRightEnabled);if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(autoLeftEnabled) end;saveConfig();saveMobileButtonsConfigOnly() 
                    elseif def.key=="autoBat" then 
                        if autoBatEnabled then autoBatEnabled=false;disableAutoBat();setOn(false);if autoBatSetVisual then autoBatSetVisual(false) end 
                        else queueAutoBatStart();setOn(autoBatEnabled);if autoBatSetVisual then autoBatSetVisual(autoBatEnabled) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(autoLeftEnabled) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(autoRightEnabled) end 
                        end;saveConfig();saveMobileButtonsConfigOnly() 
                    elseif def.key=="carrySpeed" then 
                        if speedMode and not laggerToggled then
                            speedMode=false;laggerToggled=false;laggerPhase=0
                        else
                            speedMode=true;laggerToggled=false;laggerPhase=0
                        end
                        if modeValLbl then modeValLbl.Text=speedMode and "CARRY" or "NORMAL" end
                        if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(speedMode and not laggerToggled) end 
                        if mobBtnRefs.laggerSpeed then mobBtnRefs.laggerSpeed(false) end 
                        if mobBtnRefs.laggerCarry then mobBtnRefs.laggerCarry(false) end 
                        saveConfig();saveMobileButtonsConfigOnly() 
                    elseif def.key=="laggerSpeed" then 
                        if laggerToggled and laggerPhase==1 then
                            speedMode=false;laggerToggled=false;laggerPhase=0
                        else
                            speedMode=false;laggerToggled=true;laggerPhase=1
                        end
                        if modeValLbl then modeValLbl.Text=laggerToggled and "LAGGER NORMAL" or "NORMAL" end
                        if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(false) end 
                        if mobBtnRefs.laggerSpeed then mobBtnRefs.laggerSpeed(laggerToggled and laggerPhase==1) end 
                        if mobBtnRefs.laggerCarry then mobBtnRefs.laggerCarry(false) end 
                        saveConfig();saveMobileButtonsConfigOnly() 
                    elseif def.key=="laggerCarry" then 
                        if laggerToggled and laggerPhase==2 then
                            speedMode=false;laggerToggled=false;laggerPhase=0
                        else
                            speedMode=false;laggerToggled=true;laggerPhase=2
                        end
                        if modeValLbl then modeValLbl.Text=laggerToggled and "LAGGER CARRY" or "NORMAL" end
                        if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(false) end 
                        if mobBtnRefs.laggerSpeed then mobBtnRefs.laggerSpeed(false) end 
                        if mobBtnRefs.laggerCarry then mobBtnRefs.laggerCarry(laggerToggled and laggerPhase==2) end 
                        saveConfig();saveMobileButtonsConfigOnly() 
                    elseif def.key=="aimbot2" then 
                        setAimbot2(not aimbot2Enabled);setOn(aimbot2Enabled);saveConfig();saveMobileButtonsConfigOnly() 
                    elseif def.key=="antiDesync" then 
                        setTPAimbot(not tpAimbotEnabled);setOn(tpAimbotEnabled);saveConfig();saveMobileButtonsConfigOnly()
                    elseif def.key=="antiTpAimbot" then
                        setAntiTpAimbot(not antiTpAimbotEnabled);setOn(antiTpAimbotEnabled);saveConfig();saveMobileButtonsConfigOnly() 
                    end 
                end 
                dragging=false moved=false 
            end 
        end) 
    end 
end 
function saveConfig() 
    if not configPersistenceEnabled then return end
    pcall(saveMobileButtonPositions) 
    local function ks(e) return {kb=e.kb and e.kb.Name or nil} end 
    local function ps(o) return o and {xs=o.Position.X.Scale,xo=o.Position.X.Offset,ys=o.Position.Y.Scale,yo=o.Position.Y.Offset} or nil end 
    local cfg={ 
        normalSpeed=NS,carrySpeed=CS, 
        dropBrainrotKey=ks(KB.DropBrainrot),autoLeftKey=ks(KB.AutoLeft),autoRightKey=ks(KB.AutoRight), 
        autoBatKey=ks(KB.AutoBat),laggerToggleKey=ks(KB.LaggerToggle),tpFloorKey=ks(KB.TPFloor),instaResetKey=ks(KB.InstaReset),guiHideKey=ks(KB.GuiHide), 
        speedToggleKey=ks(KB.SpeedToggle),aimbot2Key=ks(KB.Aimbot2),antiDesyncAimbotKey=ks(KB.AntiDesyncAimbot),laggerPanelKey=exeLaggerPanelKey and exeLaggerPanelKey.Name or nil, 
        grabRadius=Steal.StealRadius,stealDuration=Steal.StealDuration,stealMode=Steal.Mode, 
        antiRagdoll=antiRagdollEnabled,autoStealEnabled=Steal.AutoStealEnabled, 
        infiniteJump=infJumpEnabled,medusaCounter=medusaCounterEnabled, 
        batCounter=batCounterEnabled,antiTpAimbot=antiTpAimbotEnabled,bodyLockEnabled=bodyLockEnabled,bodyLockRadius=bodyLockRadius, 
        carryMode=speedMode,laggerMode=laggerToggled,laggerCarryMode=laggerPhase==2,laggerSpeed=LAGGER_SPEED,laggerCarrySpeed=LAGGER_CARRY_SPEED, 
        autoBat=autoBatEnabled,autoSwing=autoSwingEnabled,autoBatSpeed=AUTO_BAT_SPEED,aimbot2=aimbot2Enabled,antiDesyncAimbot=tpAimbotEnabled,         espEnabled=_G.DeepESP.enabled,espLine=_G.DeepESP.line,espSquare=_G.DeepESP.square,espExpanded=_G.DeepESP.expanded,

        unwalkEnabled=unwalkEnabled, 
        anti404Drop=antiDrop404Enabled,anti404Enabled=(antiDrop404Enabled and antiDie404Enabled and antiBat404Enabled and infJumpEnabled),anti404Die=antiDie404Enabled,anti404Bat=antiBat404Enabled, 
        antiLag=antiLagEnabled,stretchRez=stretchRezEnabled,fpsBoostEnabled=fpsBoostEnabled, 
        autoSwitchSpeed=autoSwitchSpeedEnabled,autoTurnOffSpeed=autoTurnOffSpeedEnabled,autoSwitchLaggerSpeed=autoSwitchLaggerSpeedEnabled, 
        fovEnabled=fovEnabled,fovValue=fovValue, 
        uiScale=uiScale,uiLocked=uiLocked,hubImageChoice=hubImageChoice,buttonImageChoice=buttonImageChoice, 
        mobileButtonsSize=mobileButtonsSize,mobileButtonShape=mobileButtonShape,mobileDragSmall=mobileDragSmall,mobileMovingMode=mobileMovingMode,laggerSpeedKey="laggerSpeed",laggerCarryKey="laggerCarry",carrySpeedKey="carrySpeed", 
        mobBtnSavedContainerPos=mobBtnSavedContainerPos,mobBtnSavedIndPos=mobBtnSavedIndPos, 
        guiPos=ps(exeMainFrame),miniPos=ps(exeMiniButton),grabBarPos=ps(exeGrabBar), 
        stealBarPos=stealBarContainer and ps(stealBarContainer) or nil 
    } 
    if writefile then pcall(function() writefile("exeMobile.json",HS:JSONEncode(cfg)) end) end 
end 
task.spawn(function() 
    while task.wait(1) do pcall(saveConfig) end 
end) 
pcall(function() game:BindToClose(function() pcall(saveConfig) end) end) 
pcall(function() LP.AncestryChanged:Connect(function(_,parent) if not parent then pcall(saveConfig) end end) end) 
local function refreshSpeedButtons()
    if mobBtnRefs and mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(speedMode and not laggerToggled) end
    if mobBtnRefs and mobBtnRefs.laggerSpeed then mobBtnRefs.laggerSpeed(laggerToggled and laggerPhase==1) end
    if mobBtnRefs and mobBtnRefs.laggerCarry then mobBtnRefs.laggerCarry(laggerToggled and laggerPhase==2) end
end
local setInstaGrab,setInfJumpVisual,setAntiRagVisual,setMedusaVisual 
local setUnwalkVisual,setAntiLagVisual,setAutoSwingVisual 
local normalBox,carryBox,laggerBox,laggerCarryBox,radInput,durationBox,uiScaleBox 
local set404AntiDropVisual,set404AntiDieVisual,set404InfiniteJumpVisual,set404AntiBatVisual
local antiDrop404Enabled=false
local antiDie404Enabled=false
local antiBat404Enabled=false
local anti404Conns={drop=nil,die=nil,bat=nil}
local anti404LastSafe=nil

local function start404AntiDrop()
    if anti404Conns.drop then return end
    anti404Conns.drop=RunService.Heartbeat:Connect(function()
        if not antiDrop404Enabled then return end
        local char=LP.Character
        local hum=char and char:FindFirstChildOfClass("Humanoid")
        local root=char and char:FindFirstChild("HumanoidRootPart")
        if not root or not hum then return end
        if hum.FloorMaterial~=Enum.Material.Air and root.Position.Y > -500 then
            anti404LastSafe=root.CFrame
        elseif anti404LastSafe and root.Position.Y < -50 then
            root.CFrame=anti404LastSafe
            root.AssemblyLinearVelocity=Vector3.zero
        end
    end)
end

local function stop404AntiDrop()
    if anti404Conns.drop then anti404Conns.drop:Disconnect();anti404Conns.drop=nil end
end

local function start404AntiDie()
    if anti404Conns.die then return end
    anti404Conns.die=RunService.Heartbeat:Connect(function()
        if not antiDie404Enabled then return end
        local char=LP.Character
        local hum=char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        if hum.Health<=0 then
            pcall(function()
                hum.Health=math.max(1,hum.MaxHealth)
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end)
        end
    end)
end

local function stop404AntiDie()
    if anti404Conns.die then anti404Conns.die:Disconnect();anti404Conns.die=nil end
end

local function start404AntiBat()
    if anti404Conns.bat then return end
    anti404Conns.bat=RunService.Heartbeat:Connect(function()
        if not antiBat404Enabled then return end
        local char=LP.Character
        local hum=char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        pcall(function()
            hum.PlatformStand=false
            hum.AutoRotate=true
            if hum:GetState()==Enum.HumanoidStateType.Physics then
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end)
    end)
end

local function stop404AntiBat()
    if anti404Conns.bat then anti404Conns.bat:Disconnect();anti404Conns.bat=nil end
end

local function refreshSpeedModeLabel() 
    if modeValLbl then 
        modeValLbl.Text=laggerToggled and (laggerPhase==2 and "LAGGER CARRY" or "LAGGER NORMAL") or (speedMode and "CARRY" or "NORMAL") 
    end 
end 
local function setCarrySpeedMode() 
    speedMode=true;laggerToggled=false;laggerPhase=0;refreshSpeedModeLabel();refreshSpeedButtons()
end 
local function setLaggerSpeedMode() 
    speedMode=false;laggerToggled=true;laggerPhase=1;refreshSpeedModeLabel();refreshSpeedButtons()
end 
local function setLaggerCarryMode() 
    speedMode=false;laggerToggled=true;laggerPhase=2;refreshSpeedModeLabel();refreshSpeedButtons()
end 
local function toggleCarryMode() 
    if laggerToggled then setCarrySpeedMode() else speedMode=not speedMode;refreshSpeedModeLabel();refreshSpeedButtons() end 
end 
local function toggleLaggerMode() 
    if not laggerToggled then setLaggerCarryMode() elseif laggerPhase==2 then setLaggerSpeedMode() else setLaggerCarryMode() end 
end 
local function setModeNormal() 
    speedMode=false;laggerToggled=false;laggerPhase=0;refreshSpeedModeLabel();refreshSpeedButtons()
end 
local function setModeCarry() setCarrySpeedMode() end 
local function stopAutoSwitchSpeed() 
    if autoSwitchSpeedConn then autoSwitchSpeedConn:Disconnect();autoSwitchSpeedConn=nil end 
end 
local function startAutoSwitchSpeed() 
    if autoSwitchSpeedConn then return end 
    autoSwitchSpeedConn=RunService.Heartbeat:Connect(function() 
        if not autoSwitchSpeedEnabled and not autoTurnOffSpeedEnabled and not autoSwitchLaggerSpeedEnabled then stopAutoSwitchSpeed();return end 
        local char=LP.Character;if not char then return end 
        local hum=char:FindFirstChildOfClass("Humanoid");if not hum then return end 
        local ws=hum.WalkSpeed or 16 
        if autoSwitchSpeedEnabled and ws<=AUTO_SWITCH_THRESHOLD and not speedMode then setModeCarry() 
        elseif autoTurnOffSpeedEnabled and ws>AUTO_SWITCH_THRESHOLD and speedMode then setModeNormal() end 
        if autoSwitchLaggerSpeedEnabled and ws<=AUTO_SWITCH_THRESHOLD and not laggerToggled then 
            speedMode=false laggerToggled=true laggerPhase=2 refreshSpeedModeLabel() 
            if mobBtnRefs and mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(false) end 
            if mobBtnRefs and mobBtnRefs.laggerSpeed then mobBtnRefs.laggerSpeed(false) end
            if mobBtnRefs and mobBtnRefs.laggerCarry then mobBtnRefs.laggerCarry(true) end 
        elseif autoSwitchLaggerSpeedEnabled and ws>AUTO_SWITCH_THRESHOLD and laggerToggled then setModeNormal() end 
    end) 
end 
local function buildGui() 
    local BG = Color3.fromRGB(5,5,7) 
    local BG2 = Color3.fromRGB(9,9,13) 
    local CARD = Color3.fromRGB(14,14,18) 
    local HOV = Color3.fromRGB(22,22,28) 
    local WHITE = Color3.fromRGB(255,255,255) 
    local WHITEDIM= Color3.fromRGB(200,200,200) 
    local STROKE= Color3.fromRGB(80,80,90) 
    local W = Color3.fromRGB(255,255,255) 
    local DIM = Color3.fromRGB(180,180,180) 
    local INP = Color3.fromRGB(10,10,14) 
    local OFF = Color3.fromRGB(28,28,35) 
    local old=game:GetService("CoreGui"):FindFirstChild("DeepDuels") or game:GetService("CoreGui"):FindFirstChild(".exe");if old then old:Destroy() end 
    local pg=LP:FindFirstChild("PlayerGui");if pg then local o=pg:FindFirstChild("DeepDuels") or pg:FindFirstChild(".exe");if o then o:Destroy() end end 
    local gui=Instance.new("ScreenGui") 
    gui.Name="DeepDuels";gui.ResetOnSpawn=false;gui.DisplayOrder=10;gui.IgnoreGuiInset=true 
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end) 
    if not pcall(function() gui.Parent=game:GetService("CoreGui") end) then gui.Parent=LP:WaitForChild("PlayerGui") end 
    local main=Instance.new("Frame",gui) 
    main.Size=UDim2.new(0,272,0,340);main.Position=UDim2.new(0.5,-136,0.5,-170);exeMainFrame=main 
    main.BackgroundColor3=BG;main.BackgroundTransparency=0;main.BorderSizePixel=0;main.ClipsDescendants=true 
    Instance.new("UICorner",main).CornerRadius=UDim.new(0,18) 
    local bgImage = Instance.new("ImageLabel", main) 
    bgImage.Size = UDim2.new(1,0,1,0) 
    bgImage.BackgroundTransparency = 1 
    bgImage.Image = getHubArtImage() 
    bgImage.ScaleType = Enum.ScaleType.Crop 
    bgImage.ZIndex = 0 
    bgImage.Parent = main
    hubBgImageRef = bgImage
    Instance.new("UICorner",bgImage).CornerRadius=UDim.new(0,18) 
    main.BackgroundTransparency = 1 
    local overlay = Instance.new("Frame", main) 
    overlay.Size = UDim2.new(1,0,1,0) 
    overlay.BackgroundColor3 = Color3.fromRGB(0,0,0) 
    overlay.BackgroundTransparency = 0.45 
    overlay.BorderSizePixel = 0 
    overlay.ZIndex = 1 
    Instance.new("UICorner", overlay).CornerRadius = UDim.new(0,18) 
    local scaleObj=Instance.new("UIScale",main);scaleObj.Scale=uiScale 
    local function drag(f,lockable) 
        local dn,ds,sp,di=false 
        f.InputBegan:Connect(function(i) 
            if lockable and uiLocked then return end 
            if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then 
                dn=true;ds=i.Position;sp=f.Position 
                i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dn=false;pcall(saveConfig) end end) 
            end 
        end) 
        f.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then di=i end end) 
        UIS.InputChanged:Connect(function(i) 
            if lockable and uiLocked then dn=false;return end 
            if i==di and dn then 
                local nX=sp.X.Offset+(i.Position.X-ds.X) 
                local nY=sp.Y.Offset+(i.Position.Y-ds.Y) 
                f.Position=UDim2.new(sp.X.Scale,nX,sp.Y.Scale,nY) 
            end 
        end) 
    end 
    drag(main,true) 
    local hdr=Instance.new("Frame",main) 
    hdr.Size=UDim2.new(1,0,0,36);hdr.BackgroundColor3=BG2;hdr.BackgroundTransparency=0;hdr.BorderSizePixel=0;hdr.ZIndex=2 
    Instance.new("UICorner",hdr).CornerRadius=UDim.new(0,18) 
    local ttl=Instance.new("TextLabel",hdr) 
    ttl.Size=UDim2.new(0,120,1,0);ttl.Position=UDim2.new(0,10,0,0) 
    ttl.BackgroundTransparency=1;ttl.Text="DEEP DUELS";ttl.ZIndex=4 
    ttl.TextColor3=WHITE;ttl.Font=Enum.Font.SciFi;ttl.TextSize=13 
    ttl.TextXAlignment=Enum.TextXAlignment.Left 
    local bottomNav=Instance.new("Frame",main) 
    bottomNav.Size=UDim2.new(1,0,0,40);bottomNav.Position=UDim2.new(0,0,0,36);bottomNav.BackgroundColor3=Color3.fromRGB(0,0,0);bottomNav.BorderSizePixel=0;bottomNav.ZIndex=10 
    bottomNav.BackgroundTransparency=0.45 
    Instance.new("UICorner",bottomNav).CornerRadius=UDim.new(0,0) 
    local navStroke=Instance.new("UIStroke",bottomNav);navStroke.Color=Color3.fromRGB(255,255,255);navStroke.Thickness=0.5;navStroke.Transparency=0.7 
    local pages,tabButtons={} ,{} 
    local navDragState={dragging=false,moved=false,start=nil,mainStart=nil} 
    local function navDragBegin(input) 
        if uiLocked then return end 
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then 
            navDragState.dragging=true 
            navDragState.moved=false 
            navDragState.start=input.Position 
            navDragState.mainStart=main.Position 
        end 
    end 
    local function navDragMove(input) 
        if not navDragState.dragging or uiLocked then return end 
        if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then 
            local d=input.Position-navDragState.start 
            if math.abs(d.X)>4 or math.abs(d.Y)>4 then navDragState.moved=true end 
            if navDragState.moved then 
                main.Position=UDim2.new(navDragState.mainStart.X.Scale,navDragState.mainStart.X.Offset+d.X,navDragState.mainStart.Y.Scale,navDragState.mainStart.Y.Offset+d.Y) 
            end 
        end 
    end 
    local function navDragEnd() 
        if navDragState.dragging then 
            local wasMoved=navDragState.moved 
            navDragState.dragging=false 
            navDragState.moved=false 
            if wasMoved then pcall(saveConfig) end 
        end 
    end 
    bottomNav.Active=true 
    bottomNav.InputBegan:Connect(navDragBegin) 
    bottomNav.InputChanged:Connect(navDragMove) 
    bottomNav.InputEnded:Connect(function(input) 
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then navDragEnd() end 
    end) 
    local function selectPage(id) 
        for name,page in pairs(pages) do page.Visible=(name==id) end 
        for name,btn in pairs(tabButtons) do 
            local active=name==id 
            TS:Create(btn,TweenInfo.new(0.12),{BackgroundColor3=active and Color3.fromRGB(255,255,255) or Color3.fromRGB(0,0,0),BackgroundTransparency=active and 0 or 1,TextColor3=active and Color3.fromRGB(0,0,0) or Color3.fromRGB(180,180,180)}):Play() 
            for _,ch in ipairs(btn:GetChildren()) do 
                if ch:IsA("UIStroke") then ch.Transparency=active and 0.6 or 1 end 
            end 
        end 
    end 
    -- Compact navigation: SETTINGS penultimate, KEYBINDS last.
    local tabs={ {"menu","MAIN"}, {"lock","STEAL"}, {"aimbot","AIMBOT"}, {"config","SETTINGS"}, {"keys","KEYBINDS"} } 
    local TAB_W=54
    local TAB_GAP=2
    for i,t in ipairs(tabs) do 
        local btn=Instance.new("TextButton",bottomNav) 
        btn.Size=UDim2.new(0,TAB_W,0,40);btn.Position=UDim2.new(0,3+(i-1)*(TAB_W+TAB_GAP),0.5,-20) 
        btn.BackgroundColor3=Color3.fromRGB(10,10,14);btn.BackgroundTransparency=0;btn.BorderSizePixel=0;btn.Text=t[2];btn.TextColor3=DIM 
        btn.Font=Enum.Font.SciFi;btn.TextSize=8;btn.TextXAlignment=Enum.TextXAlignment.Center;btn.TextYAlignment=Enum.TextYAlignment.Center;btn.ZIndex=11 
        Instance.new("UICorner",btn).CornerRadius=UDim.new(0,6) 
        Instance.new("UIStroke",btn).Color=Color3.fromRGB(40,40,50) 
        tabButtons[t[1]]=btn 
        btn.MouseEnter:Connect(function() if not pages[t[1]].Visible and not navDragState.moved then TS:Create(btn,TweenInfo.new(0.08),{BackgroundColor3=HOV,TextColor3=WHITE}):Play() end end) 
        btn.MouseLeave:Connect(function() if not pages[t[1]].Visible and not navDragState.moved then TS:Create(btn,TweenInfo.new(0.08),{BackgroundColor3=Color3.fromRGB(10,10,14),TextColor3=DIM}):Play() end end) 
        btn.InputBegan:Connect(navDragBegin) 
        btn.InputChanged:Connect(navDragMove) 
        btn.InputEnded:Connect(function(input) 
            if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then navDragEnd() end 
        end) 
        btn.Activated:Connect(function() 
            if not navDragState.moved then selectPage(t[1]) end 
        end) 
    end 
    local miniBtn=Instance.new("TextButton",gui) 
    miniBtn.Size=UDim2.new(0,100,0,28);miniBtn.Position=UDim2.new(1,-110,0,60);exeMiniButton=miniBtn 
    miniBtn.BackgroundColor3=BG2;miniBtn.BorderSizePixel=0 
    miniBtn.Text="DEEP DUELS";miniBtn.TextColor3=WHITE;miniBtn.Font=Enum.Font.SciFi;miniBtn.TextSize=11 
    miniBtn.ZIndex=20;miniBtn.Visible=false 
    Instance.new("UICorner",miniBtn).CornerRadius=UDim.new(0,8) 
    local miniStroke=Instance.new("UIStroke",miniBtn);miniStroke.Color=STROKE;miniStroke.Thickness=1.2 
    drag(miniBtn,false) 
    miniBtn.MouseEnter:Connect(function() TS:Create(miniBtn,TweenInfo.new(0.1),{BackgroundColor3=HOV}):Play() end) 
    miniBtn.MouseLeave:Connect(function() TS:Create(miniBtn,TweenInfo.new(0.1),{BackgroundColor3=BG2}):Play() end) 
    local function showGui() main.Visible=true;miniBtn.Visible=false end 
    local function hideGui() main.Visible=false;miniBtn.Visible=true end 
    local closeBtn=Instance.new("TextButton",hdr) 
    closeBtn.Size=UDim2.new(0,28,0,28);closeBtn.Position=UDim2.new(1,-34,0.5,-14) 
    closeBtn.BackgroundColor3=BG2;closeBtn.BackgroundTransparency=1;closeBtn.BorderSizePixel=0;closeBtn.ZIndex=4 
    closeBtn.Text="-";closeBtn.TextColor3=WHITEDIM;closeBtn.Font=Enum.Font.SciFi;closeBtn.TextSize=22 
    Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(0,6) 
    closeBtn.MouseEnter:Connect(function() TS:Create(closeBtn,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(32,32,40),TextColor3=WHITEDIM}):Play() end) 
    closeBtn.MouseLeave:Connect(function() TS:Create(closeBtn,TweenInfo.new(0.1),{BackgroundColor3=BG2,TextColor3=WHITEDIM}):Play() end) 
    closeBtn.MouseButton1Click:Connect(hideGui) 
    miniBtn.MouseButton1Click:Connect(showGui) 
    local function mkPage(id) 
        local sf=Instance.new("ScrollingFrame",main) 
        sf.Size=UDim2.new(1,0,1,-76);sf.Position=UDim2.new(0,0,0,76) 
        sf.BackgroundTransparency=1;sf.BorderSizePixel=0;sf.ClipsDescendants=true;sf.Visible=false;sf.ZIndex=2 
        sf.ScrollBarThickness=3;sf.ScrollBarImageColor3=WHITE 
        sf.CanvasSize=UDim2.new(0,0,0,0);sf.AutomaticCanvasSize=Enum.AutomaticSize.Y 
        local ll=Instance.new("UIListLayout",sf);ll.SortOrder=Enum.SortOrder.LayoutOrder;ll.Padding=UDim.new(0,2) 
        local pad=Instance.new("UIPadding",sf) 
        pad.PaddingLeft=UDim.new(0,7);pad.PaddingRight=UDim.new(0,7) 
        pad.PaddingTop=UDim.new(0,7);pad.PaddingBottom=UDim.new(0,7) 
        pages[id]=sf 
        return sf 
    end 
    local menuPage,lockPage,aimbotPage,keysPage,configPage=mkPage("menu"),mkPage("lock"),mkPage("aimbot"),mkPage("keys"),mkPage("config") 
    local loByPage={} 
    local function LO(page) loByPage[page]=(loByPage[page] or 0)+1;return loByPage[page] end 
    local function mkSect(page,txt) 
        local f=Instance.new("Frame",page);f.Size=UDim2.new(1,0,0,22);f.BackgroundTransparency=1;f.BorderSizePixel=0;f.LayoutOrder=LO(page);f.ZIndex=3 
        local l=Instance.new("TextLabel",f);l.Size=UDim2.new(1,-8,1,0);l.Position=UDim2.new(0,8,0,0) 
        l.BackgroundTransparency=1;l.Text=txt:upper();l.TextColor3=WHITE;l.ZIndex=4 
        l.Font=Enum.Font.SciFi;l.TextSize=9;l.TextXAlignment=Enum.TextXAlignment.Left 
        l.TextStrokeTransparency=0.85;l.TextStrokeColor3=Color3.fromRGB(0,0,0) 
    end 
    local function mkRow(page,h) 
        local f=Instance.new("Frame",page);f.Size=UDim2.new(1,0,0,h or 32) 
        f.BackgroundColor3=CARD;f.BackgroundTransparency=0.55;f.BorderSizePixel=0;f.LayoutOrder=LO(page);f.ZIndex=3 
        Instance.new("UICorner",f).CornerRadius=UDim.new(0,7) 
        local rowStroke=Instance.new("UIStroke",f);rowStroke.Color=Color3.fromRGB(45,45,52);rowStroke.Thickness=0.7;rowStroke.Transparency=0 
        f.MouseEnter:Connect(function() TS:Create(f,TweenInfo.new(0.08),{BackgroundColor3=HOV,BackgroundTransparency=0.55}):Play() end) 
        f.MouseLeave:Connect(function() TS:Create(f,TweenInfo.new(0.08),{BackgroundColor3=CARD,BackgroundTransparency=0.55}):Play() end) 
        return f 
    end 
    local function mkLabel(row,txt) 
        local l=Instance.new("TextLabel",row);l.Size=UDim2.new(0.62,0,1,0);l.Position=UDim2.new(0,9,0,0) 
        l.BackgroundTransparency=1;l.Text=txt:upper();l.TextColor3=W;l.ZIndex=4 
        l.Font=Enum.Font.SciFi;l.TextSize=10;l.TextXAlignment=Enum.TextXAlignment.Left 
    end 
    local function mkPill(row,offset) 
        local pill=Instance.new("Frame",row);pill.Size=UDim2.new(0,36,0,19) 
        pill.Position=UDim2.new(1,-(offset or 42),0.5,-9.5) 
        pill.BackgroundColor3=OFF;pill.BorderSizePixel=0;pill.ZIndex=3 
        Instance.new("UICorner",pill).CornerRadius=UDim.new(1,0) 
        local dot=Instance.new("Frame",pill);dot.Size=UDim2.new(0,13,0,13);dot.Position=UDim2.new(0,3,0.5,-6.5) 
        dot.BackgroundColor3=DIM;dot.BorderSizePixel=0;dot.ZIndex=4 
        Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0) 
        return pill,dot 
    end 
    local function animPill(pill,dot,on) 
        TS:Create(pill,TweenInfo.new(0.18,Enum.EasingStyle.Quad),{BackgroundColor3=on and Color3.fromRGB(60,60,80) or OFF}):Play() 
        TS:Create(dot,TweenInfo.new(0.18,Enum.EasingStyle.Back),{ Position=on and UDim2.new(1,-16,0.5,-6.5) or UDim2.new(0,3,0.5,-6.5), BackgroundColor3=on and WHITE or DIM }):Play() 
    end 
    local function mkToggle(page,txt,cb) 
        local row=mkRow(page,32);mkLabel(row,txt) 
        local pill,dot=mkPill(row,42) 
        local on=false 
        local function sv(s) on=s;animPill(pill,dot,s) end 
        local clk=Instance.new("TextButton",pill);clk.Size=UDim2.new(1,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=5 
        clk.Activated:Connect(function() if _anyKeyListening then return end;on=not on;sv(on);cb(on) end) 
        pill.ZIndex=3;dot.ZIndex=4 
        return sv 
    end 
    local function mkBox(parent,default,w,xOff,cb) 
        local tb=Instance.new("TextBox",parent) 
        tb.Size=UDim2.new(0,w or 50,0,22);tb.Position=UDim2.new(1,-(xOff or 56),0.5,-11) 
        tb.BackgroundColor3=INP;tb.BorderSizePixel=0;tb.Text=tostring(default);tb.TextColor3=W 
        tb.Font=Enum.Font.SciFi;tb.TextSize=10;tb.ClearTextOnFocus=false;tb.ZIndex=5 
        Instance.new("UICorner",tb).CornerRadius=UDim.new(0,5) 
        local bs=Instance.new("UIStroke",tb);bs.Color=Color3.fromRGB(30,30,38);bs.Thickness=1 
        tb.Focused:Connect(function() TS:Create(bs,TweenInfo.new(0.12),{Color=WHITEDIM}):Play() end) 
        tb.FocusLost:Connect(function() 
            TS:Create(bs,TweenInfo.new(0.12),{Color=Color3.fromRGB(30,30,38)}):Play() 
            if cb then local n=tonumber(tb.Text);if n then cb(n) else tb.Text=tostring(default) end end 
        end) 
        return tb 
    end 
    local function isGamepadInput(inp) return inp and inp.UserInputType and inp.UserInputType.Name:match("^Gamepad")~=nil end 
    local function isBindableInput(inp) 
        if not inp or inp.KeyCode==Enum.KeyCode.Unknown then return false end 
        if inp.UserInputType==Enum.UserInputType.Keyboard then return true end 
        return isGamepadInput(inp) 
    end 
    local function kbMatch(entry,kc) return kc and (kc==entry.kb) end 
    local keyRefs={} 
    local function keyLabel(entry) return (entry.kb and entry.kb.Name:upper()) or "NONE" end 
    local function refreshKeyRefs(entry) 
        for _,r in ipairs(keyRefs) do if r.entry==entry then r.btn.Text=keyLabel(entry) end end 
    end 
    local function mkKBButton(parent,kbEntry) 
        local btn=Instance.new("TextButton",parent) 
        btn.Size=UDim2.new(0,70,0,22);btn.Position=UDim2.new(1,-76,0.5,-11) 
        btn.BackgroundColor3=INP;btn.BorderSizePixel=0 
        btn.Text=keyLabel(kbEntry);btn.TextColor3=W 
        btn.Font=Enum.Font.SciFi;btn.TextSize=9;btn.ZIndex=5 
        Instance.new("UICorner",btn).CornerRadius=UDim.new(0,5) 
        table.insert(keyRefs,{entry=kbEntry,btn=btn}) 
        local listening=false 
        local conn=nil 
        local previous=btn.Text 
        local listenStart=0 
        local function stopListen(cancel) 
            listening=false _anyKeyListening=false 
            if conn then conn:Disconnect();conn=nil end 
            if cancel then btn.Text=previous else refreshKeyRefs(kbEntry) end 
            btn.TextColor3=W 
        end 
        btn.Activated:Connect(function() 
            if listening then stopListen(true);return end 
            previous=btn.Text 
            listening=true _anyKeyListening=true listenStart=tick() 
            btn.Text="..." btn.TextColor3=WHITE 
            conn=UIS.InputBegan:Connect(function(inp,gpe) 
                if not listening then return end 
                if inp.KeyCode==Enum.KeyCode.Escape then stopListen(true);return end 
                if inp.KeyCode==Enum.KeyCode.Unknown then return end 
                if inp.UserInputType~=Enum.UserInputType.Keyboard then return end 
                kbEntry.kb=inp.KeyCode 
                stopListen(false) 
                pcall(saveConfig) 
                pcall(function() if saveMobileButtonsConfigOnly then saveMobileButtonsConfigOnly() end end) 
            end) 
        end) 
        return btn 
    end 
    local function mkKeyRow(page,txt,kbEntry) 
        local row=mkRow(page,32);mkLabel(row,txt);mkKBButton(row,kbEntry) 
    end 
    local function mkModeRow(page) 
        local row=mkRow(page,32);mkLabel(row,"Mode") 
        modeValLbl=Instance.new("TextLabel",row) 
        modeValLbl.Size=UDim2.new(0,110,1,0);modeValLbl.Position=UDim2.new(1,-116,0,0) 
        modeValLbl.BackgroundTransparency=1;modeValLbl.Text="NORMAL";modeValLbl.TextColor3=WHITE 
        modeValLbl.Font=Enum.Font.SciFi;modeValLbl.TextSize=10;modeValLbl.TextXAlignment=Enum.TextXAlignment.Right 
        refreshSpeedModeLabel() 
    end 
    local function mkActionButton(page,labelTxt,btnTxt,cb) 
        local row=mkRow(page,32);mkLabel(row,labelTxt) 
        local btn=Instance.new("TextButton",row) 
        btn.Size=UDim2.new(0,70,0,22);btn.Position=UDim2.new(1,-76,0.5,-11) 
        btn.BackgroundColor3=INP;btn.BorderSizePixel=0;btn.Text=btnTxt:upper();btn.TextColor3=WHITE 
        btn.Font=Enum.Font.SciFi;btn.TextSize=9;btn.ZIndex=5 
        Instance.new("UICorner",btn).CornerRadius=UDim.new(0,6) 
        local bs=Instance.new("UIStroke",btn);bs.Color=STROKE;bs.Thickness=1 
        btn.MouseEnter:Connect(function() TS:Create(btn,TweenInfo.new(0.08),{BackgroundColor3=HOV}):Play() end) 
        btn.MouseLeave:Connect(function() TS:Create(btn,TweenInfo.new(0.08),{BackgroundColor3=INP}):Play() end) 
        btn.Activated:Connect(cb) 
        return btn 
    end 
    mkSect(menuPage,"Speed Configuration") 
    do 
        local row=mkRow(menuPage,32);mkLabel(row,"Normal Speed");normalBox=mkBox(row,NS,55,62,function(v) if v>0 and v<=500 then NS=v end;saveConfig() end) 
    end 
    do 
        local row=mkRow(menuPage,32);mkLabel(row,"Carry Speed");carryBox=mkBox(row,CS,55,62,function(v) if v>0 and v<=500 then CS=v end;saveConfig() end) 
    end 
    mkKeyRow(menuPage,"Speed Key",KB.SpeedToggle) 
    mkModeRow(menuPage) 
    mkSect(menuPage,"Auto Speed") 
    setAutoSwitchSpeedVisual=mkToggle(menuPage,"Auto Switch Speed",function(on) autoSwitchSpeedEnabled=on;if on or autoTurnOffSpeedEnabled or autoSwitchLaggerSpeedEnabled then startAutoSwitchSpeed() else stopAutoSwitchSpeed() end;saveConfig() end) 
    setAutoSwitchLaggerSpeedVisual=mkToggle(menuPage,"Auto Switch Lagger Speed",function(on) autoSwitchLaggerSpeedEnabled=on;if on or autoSwitchSpeedEnabled or autoTurnOffSpeedEnabled then startAutoSwitchSpeed() else stopAutoSwitchSpeed() end;saveConfig() end) 
    setAutoTurnOffSpeedVisual=mkToggle(menuPage,"Auto Turn Off Speed",function(on) autoTurnOffSpeedEnabled=on;if on or autoSwitchSpeedEnabled or autoSwitchLaggerSpeedEnabled then startAutoSwitchSpeed() else stopAutoSwitchSpeed() end;saveConfig() end) 
    mkSect(menuPage,"Lagger Speed") 
    do 
        local row=mkRow(menuPage,32);mkLabel(row,"Lagger Normal Speed");laggerBox=mkBox(row,LAGGER_SPEED,55,62,function(v) if v>0 and v<=500 then LAGGER_SPEED=v end;saveConfig() end) 
    end 
    do 
        local row=mkRow(menuPage,32);mkLabel(row,"Lagger Carry Speed");laggerCarryBox=mkBox(row,LAGGER_CARRY_SPEED,55,62,function(v) if v>0 and v<=500 then LAGGER_CARRY_SPEED=v end;saveConfig() end) 
    end 
    mkKeyRow(menuPage,"Lagger Key",KB.LaggerToggle) 
    mkSect(menuPage,"Jump") 
    setInfJumpVisual=mkToggle(menuPage,"Infinite Jump",function(on) infJumpEnabled=on;saveConfig() end) 
    setAntiRagVisual=mkToggle(menuPage,"Anti Ragdoll",function(on) antiRagdollEnabled=on;if on then startAntiRagdoll() else stopAntiRagdoll() end;saveConfig() end) 
    setUnwalkVisual=mkToggle(menuPage,"Unwalk",function(on) unwalkEnabled=on;if on then startUnwalk() else stopUnwalk() end;saveConfig() end) 
    mkSect(menuPage,"ESP")
    do
        local row=mkRow(menuPage,32);mkLabel(row,"ESP")
        _G.DeepESP.expandBtn=Instance.new("TextButton",row)
        _G.DeepESP.expandBtn.Size=UDim2.new(0,24,0,19)
        _G.DeepESP.expandBtn.Position=UDim2.new(1,-72,0.5,-9.5)
        _G.DeepESP.expandBtn.BackgroundColor3=INP
        _G.DeepESP.expandBtn.BorderSizePixel=0
        _G.DeepESP.expandBtn.Text=_G.DeepESP.expanded and "-" or "+"
        _G.DeepESP.expandBtn.TextColor3=WHITE
        _G.DeepESP.expandBtn.Font=Enum.Font.SciFi
        _G.DeepESP.expandBtn.TextSize=14
        _G.DeepESP.expandBtn.ZIndex=5
        Instance.new("UICorner",_G.DeepESP.expandBtn).CornerRadius=UDim.new(0,5)
        local pill,dot=mkPill(row,42)
        _G.DeepESP.masterVisual=function(v) animPill(pill,dot,v==true) end
        _G.DeepESP.masterVisual(_G.DeepESP.enabled)
        local clk=Instance.new("TextButton",pill)
        clk.Size=UDim2.new(1,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=5
        clk.Activated:Connect(function()
            if _anyKeyListening then return end
            _G.DeepESP.setEnabled(not _G.DeepESP.enabled)
            saveConfig()
        end)
    end
    do
        _G.DeepESP.lineRow=mkRow(menuPage,32);mkLabel(_G.DeepESP.lineRow,"LINE")
        local pill,dot=mkPill(_G.DeepESP.lineRow,42)
        _G.DeepESP.lineVisual=function(v) animPill(pill,dot,v==true) end
        _G.DeepESP.lineVisual(_G.DeepESP.line)
        local clk=Instance.new("TextButton",pill)
        clk.Size=UDim2.new(1,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=5
        clk.Activated:Connect(function()
            if _anyKeyListening then return end
            _G.DeepESP.line=not _G.DeepESP.line
            _G.DeepESP.lineVisual(_G.DeepESP.line)
            if not _G.DeepESP.line then for _,e in pairs(_G.DeepESP.entries) do if e.line then e.line.Visible=false end end end
            saveConfig()
        end)
    end
    do
        _G.DeepESP.squareRow=mkRow(menuPage,32);mkLabel(_G.DeepESP.squareRow,"SQUARE")
        local pill,dot=mkPill(_G.DeepESP.squareRow,42)
        _G.DeepESP.squareVisual=function(v) animPill(pill,dot,v==true) end
        _G.DeepESP.squareVisual(_G.DeepESP.square)
        local clk=Instance.new("TextButton",pill)
        clk.Size=UDim2.new(1,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=5
        clk.Activated:Connect(function()
            if _anyKeyListening then return end
            _G.DeepESP.square=not _G.DeepESP.square
            _G.DeepESP.squareVisual(_G.DeepESP.square)
            if not _G.DeepESP.square then for _,e in pairs(_G.DeepESP.entries) do if e.box then e.box.Visible=false end;if e.name then e.name.Visible=false end end end
            saveConfig()
        end)
    end
    _G.DeepESP.refreshExpanded=function()
        if _G.DeepESP.lineRow then _G.DeepESP.lineRow.Visible=_G.DeepESP.expanded end
        if _G.DeepESP.squareRow then _G.DeepESP.squareRow.Visible=_G.DeepESP.expanded end
        if _G.DeepESP.expandBtn then _G.DeepESP.expandBtn.Text=_G.DeepESP.expanded and "-" or "+" end
    end
    _G.DeepESP.expandBtn.Activated:Connect(function()
        _G.DeepESP.expanded=not _G.DeepESP.expanded
        _G.DeepESP.refreshExpanded()
        saveConfig()
    end)
    _G.DeepESP.refreshExpanded()
    mkSect(lockPage,"Steal Configuration")
    local stealModeBtn
    local function refreshStealModeButton()
        if stealModeBtn then
            stealModeBtn.Text=Steal.Mode
        end
    end
    local function cycleStealMode()
        if Steal.Mode=="NORMAL" then
            Steal.Mode="SEMI"
        elseif Steal.Mode=="SEMI" then
            Steal.Mode="V1"
        else
            Steal.Mode="NORMAL"
        end
        isStealing=false
        refreshStealModeButton()
        saveConfig()
    end
    do
        local row=mkRow(lockPage,32)
        mkLabel(row,"Steal Mode")
        stealModeBtn=Instance.new("TextButton",row)
        stealModeBtn.Size=UDim2.new(0,70,0,22)
        stealModeBtn.Position=UDim2.new(1,-76,0.5,-11)
        stealModeBtn.BackgroundColor3=INP
        stealModeBtn.BorderSizePixel=0
        stealModeBtn.TextColor3=WHITE
        stealModeBtn.Font=Enum.Font.SciFi
        stealModeBtn.TextSize=9
        stealModeBtn.ZIndex=5
        Instance.new("UICorner",stealModeBtn).CornerRadius=UDim.new(0,6)
        local modeStroke=Instance.new("UIStroke",stealModeBtn)
        modeStroke.Color=STROKE
        modeStroke.Thickness=1
        stealModeBtn.MouseEnter:Connect(function() TS:Create(stealModeBtn,TweenInfo.new(0.08),{BackgroundColor3=HOV}):Play() end)
        stealModeBtn.MouseLeave:Connect(function() TS:Create(stealModeBtn,TweenInfo.new(0.08),{BackgroundColor3=INP}):Play() end)
        stealModeBtn.Activated:Connect(cycleStealMode)
        refreshStealModeButton()
    end
    setInstaGrab=mkToggle(lockPage,"Auto Steal",function(on) Steal.AutoStealEnabled=on;if on then if not pcall(startAutoSteal) then Steal.AutoStealEnabled=false;if setInstaGrab then setInstaGrab(false) end end else stopAutoSteal() end;saveConfig() end) 
    do 
        local row=mkRow(lockPage,32);mkLabel(row,"Radius");radInput=mkBox(row,Steal.StealRadius,55,62,function(v) if v>=1 and v<=500 then Steal.StealRadius=v else radInput.Text=tostring(Steal.StealRadius) end;saveConfig() end) 
    end 
    do 
        local row=mkRow(lockPage,32);mkLabel(row,"Duration");durationBox=mkBox(row,Steal.StealDuration,55,62,function(v) if v>=0.05 and v<=10 then Steal.StealDuration=v else durationBox.Text=tostring(Steal.StealDuration) end;saveConfig() end) 
    end 
    mkSect(lockPage,"Counter") 
    setMedusaVisual=mkToggle(lockPage,"Medusa Counter",function(on) medusaCounterEnabled=on;if on then setupMedusa(LP.Character) else stopMedusaCounter() end;saveConfig() end) 
    setBatCounterVisual=mkToggle(lockPage,"Bat Counter",function(on) batCounterEnabled=on;if on then startBatCounter() else stopBatCounter() end;saveConfig() end)
    mkSect(lockPage,"Body Lock") 
    setBodyLockVisual=mkToggle(lockPage,"Body Lock",function(on) setBodyLock(on) end) 
    do 
        local row=mkRow(lockPage,32);mkLabel(row,"Body Lock Radius");bodyLockRadiusBox=mkBox(row,bodyLockRadius,55,62,function(v) if v>=1 and v<=500 then bodyLockRadius=v else bodyLockRadiusBox.Text=tostring(bodyLockRadius) end;saveConfig() end) 
    end 
    mkSect(aimbotPage,"Bat Aimbot") 
    do 
        local row=mkRow(aimbotPage,32);mkLabel(row,"Bat Aimbot") 
        local pill,dot=mkPill(row,42) 
        local abOn=false 
        local function svAutoBat(s) abOn=s;animPill(pill,dot,s) end 
        autoBatSetVisual=svAutoBat 
        local clk=Instance.new("TextButton",pill);clk.Size=UDim2.new(1,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=5 
        clk.Activated:Connect(function() if _anyKeyListening then return end;abOn=not abOn;svAutoBat(abOn);if abOn then queueAutoBatStart() else autoBatEnabled=false;disableAutoBat() end;saveConfig() end) 
    end 
    do 
        local row=mkRow(aimbotPage,32);mkLabel(row,"Bat Aimbot Speed");autoBatSpeedBox=mkBox(row,AUTO_BAT_SPEED,55,62,function(v) if v and v>0 and v<=500 then AUTO_BAT_SPEED=v else autoBatSpeedBox.Text=tostring(AUTO_BAT_SPEED) end;saveConfig() end) 
    end 
    setAimbot2Visual=mkToggle(aimbotPage,"Bat V2",function(on) setAimbot2(on) end) 
    setTPAimbotVisual=mkToggle(aimbotPage,"TP Aimbot",function(on) setTPAimbot(on) end) 
    setAutoSwingVisual=mkToggle(aimbotPage,"Auto Swing",function(on) autoSwingEnabled=on;saveConfig() end) 
    if setAutoSwingVisual then setAutoSwingVisual(autoSwingEnabled) end 
    mkSect(aimbotPage,"Auto Path") 
    autoLeftSetVisual=mkToggle(aimbotPage,"Auto Left",function(on) autoLeftEnabled=on;if on then queueAutoLeftStart() else stopAutoLeft() end;saveConfig() end) 
    autoRightSetVisual=mkToggle(aimbotPage,"Auto Right",function(on) autoRightEnabled=on;if on then queueAutoRightStart() else stopAutoRight() end;saveConfig() end) 
    mkSect(keysPage,"Move Keys") 
    mkKeyRow(keysPage,"Speed Key",KB.SpeedToggle) 
    mkKeyRow(keysPage,"Lagger Key",KB.LaggerToggle) 
    mkKeyRow(keysPage,"Drop Brainrot Key",KB.DropBrainrot) 
    mkKeyRow(keysPage,"TP Down Key",KB.TPFloor) 
    mkKeyRow(keysPage,"Insta Reset Key",KB.InstaReset) 
    mkSect(keysPage,"Combat") 
    mkKeyRow(keysPage,"Bat Aimbot Key",KB.AutoBat) 
    mkKeyRow(keysPage,"Bat V2 Key",KB.Aimbot2) 
    mkKeyRow(keysPage,"TP Aimbot Key",KB.AntiDesyncAimbot) 
    mkKeyRow(keysPage,"Auto Right Key",KB.AutoRight) 
    mkKeyRow(keysPage,"Auto Left Key",KB.AutoLeft) 
    mkSect(keysPage,"Interface") 
    mkKeyRow(keysPage,"UI Toggle Key",KB.GuiHide) 

    mkSect(configPage,"Mobile Button Shape") 
    do 
        local row=mkRow(configPage,34);mkLabel(row,"Shape") 
        local shapeRefs={} 
        local shapes={ 
            {id="circle",txt="CIRCLE"}, 
            {id="squarcle",txt="ROUNDED"}, 
            {id="straight",txt="SQUARE"}, 
        } 
        local function refreshShape(sel) 
            for _,r in ipairs(shapeRefs) do 
                local active=r.id==sel 
                r.btn.BackgroundColor3=active and Color3.fromRGB(255,255,255) or INP 
                r.btn.TextColor3=active and Color3.fromRGB(0,0,0) or WHITE 
            end 
        end 
        for i,s in ipairs(shapes) do 
            local sb=Instance.new("TextButton",row) 
            sb.Size=UDim2.new(0,62,0,22);sb.Position=UDim2.new(1,-(i*65+2),0.5,-11) 
            sb.BackgroundColor3=(mobileButtonShape==s.id) and Color3.fromRGB(255,255,255) or INP 
            sb.BorderSizePixel=0;sb.Text=s.txt;sb.TextColor3=(mobileButtonShape==s.id) and Color3.fromRGB(0,0,0) or WHITE 
            sb.Font=Enum.Font.SciFi;sb.TextSize=7;sb.TextXAlignment=Enum.TextXAlignment.Center;sb.TextYAlignment=Enum.TextYAlignment.Center;sb.ZIndex=5 
            Instance.new("UICorner",sb).CornerRadius=UDim.new(0,6) 
            local bs=Instance.new("UIStroke",sb);bs.Color=STROKE;bs.Thickness=1 
            table.insert(shapeRefs,{btn=sb,id=s.id}) 
            sb.Activated:Connect(function() 
                mobileButtonShape=s.id 
                refreshShape(s.id) 
                buildMobileButtons() 
                saveConfig() 
                saveMobileButtonsConfigOnly() 
            end) 
        end 
    end 

    mkSect(configPage,"Anti Drop") 
    do 
        set404AntiDropVisual=mkToggle(configPage,"Anti Drop",function(on) 
            antiDrop404Enabled=on 
            antiDie404Enabled=on 
            antiBat404Enabled=on 
            infJumpEnabled=on 
            if on then 
                start404AntiDrop() 
                start404AntiDie() 
                start404AntiBat() 
            else 
                stop404AntiDrop() 
                stop404AntiDie() 
                stop404AntiBat() 
            end 
            if setInfJumpVisual then setInfJumpVisual(on) end 
            saveConfig() 
        end) 
        if set404AntiDropVisual then set404AntiDropVisual(antiDrop404Enabled) end 
    end 

    mkSect(configPage,"Visual") 
    setAntiLagVisual=mkToggle(configPage,"Anti Lag",function(on) if on then enableAntiLag() else disableAntiLag() end;saveConfig() end) 
    setFpsBoostVisual=mkToggle(configPage,"FPS Boost",function(on) fpsBoostEnabled=on;if on then applyFPSBoost() end;saveConfig() end) 
    setStretchRezVisual=mkToggle(configPage,"Stretch Rez",function(on) if on then enableStretchRez() else disableStretchRez() end;saveConfig() end) 
    -- Camera/FOV/Insta Reset controls removed from Settings.
    mkActionButton(configPage,"Reset Buttons","Reset",function() resetMobileButtonPositions() end) 
    do 
        local row=mkRow(configPage,32);mkLabel(row,"Btn Scale") 
        local sizes={60,75,100,125,150} 
        local bw=30 
        local startX=-6-(#sizes*(bw+3)) 
        local refs={} 
        local function refresh(sel) 
            for _,r in ipairs(refs) do 
                local a=r.sz==sel 
                r.btn.BackgroundColor3=a and Color3.fromRGB(60,60,80) or INP 
                r.btn.TextColor3=a and WHITE or W 
            end 
        end 
        for i,sz in ipairs(sizes) do 
            local sb=Instance.new("TextButton",row) 
            sb.Size=UDim2.new(0,bw,0,20);sb.Position=UDim2.new(1,startX+(i-1)*(bw+3),0.5,-10) 
            sb.BackgroundColor3=(mobileButtonsSize==sz) and Color3.fromRGB(60,60,80) or INP;sb.BorderSizePixel=0 
            sb.Text=tostring(sz);sb.TextColor3=(mobileButtonsSize==sz) and WHITE or W;sb.Font=Enum.Font.SciFi;sb.TextSize=8;sb.ZIndex=5 
            Instance.new("UICorner",sb).CornerRadius=UDim.new(0,5);local st=Instance.new("UIStroke",sb);st.Color=STROKE;st.Thickness=1 
            table.insert(refs,{btn=sb,sz=sz}) 
            sb.Activated:Connect(function() mobileButtonsSize=sz;refresh(sz);buildMobileButtons();pcall(saveConfig);saveMobileButtonsConfigOnly() end) 
        end 
    end 
    mkSect(configPage,"Artwork")
    do
        local row=mkRow(configPage,32);mkLabel(row,"Hub Art")
        local refs={}
        local names={{1,"TOJI"},{2,"ALT"}}
        local function refresh(sel)
            for _,r in ipairs(refs) do
                local active=(r.id==sel)
                r.btn.BackgroundColor3=active and Color3.fromRGB(60,60,80) or INP
                r.btn.TextColor3=active and WHITE or W
            end
        end
        for i,info in ipairs(names) do
            local id,label=info[1],info[2]
            local btn=Instance.new("TextButton",row)
            btn.Size=UDim2.new(0,42,0,20);btn.Position=UDim2.new(1,-(96-(i-1)*46),0.5,-10)
            btn.BackgroundColor3=(hubImageChoice==id) and Color3.fromRGB(60,60,80) or INP;btn.BorderSizePixel=0
            btn.Text=label;btn.TextColor3=(hubImageChoice==id) and WHITE or W;btn.Font=Enum.Font.SciFi;btn.TextSize=8;btn.ZIndex=5
            Instance.new("UICorner",btn).CornerRadius=UDim.new(0,5)
            local st=Instance.new("UIStroke",btn);st.Color=STROKE;st.Thickness=1
            table.insert(refs,{btn=btn,id=id})
            btn.Activated:Connect(function()
                hubImageChoice=id
                refresh(id)
                applyHubArtNow()
                saveConfig()
                saveMobileButtonsConfigOnly()
            end)
        end
    end
    do
        local row=mkRow(configPage,32);mkLabel(row,"Btn Art")
        local refs={}
        local names={{1,"TOJI"},{2,"ALT"}}
        local function refresh(sel)
            for _,r in ipairs(refs) do
                local active=(r.id==sel)
                r.btn.BackgroundColor3=active and Color3.fromRGB(60,60,80) or INP
                r.btn.TextColor3=active and WHITE or W
            end
        end
        for i,info in ipairs(names) do
            local id,label=info[1],info[2]
            local btn=Instance.new("TextButton",row)
            btn.Size=UDim2.new(0,42,0,20);btn.Position=UDim2.new(1,-(96-(i-1)*46),0.5,-10)
            btn.BackgroundColor3=(buttonImageChoice==id) and Color3.fromRGB(60,60,80) or INP;btn.BorderSizePixel=0
            btn.Text=label;btn.TextColor3=(buttonImageChoice==id) and WHITE or W;btn.Font=Enum.Font.SciFi;btn.TextSize=8;btn.ZIndex=5
            Instance.new("UICorner",btn).CornerRadius=UDim.new(0,5)
            local st=Instance.new("UIStroke",btn);st.Color=STROKE;st.Thickness=1
            table.insert(refs,{btn=btn,id=id})
            btn.Activated:Connect(function()
                buttonImageChoice=id
                refresh(id)
                buildMobileButtons()
                saveConfig()
                saveMobileButtonsConfigOnly()
            end)
        end
    end
    mkSect(configPage,"Interface") 
    setLockVisual=mkToggle(configPage,"Lock UI",function(on) 
        uiLocked=on 
        if uiLocked and mobileMovingMode then 
            mobileMovingMode=false 
            if setMobileMovingModeVisual then setMobileMovingModeVisual(false) end 
        end
        if mobContainerRef then
            mobContainerRef.Active=(mobileMovingMode==true and not uiLocked)
        end
        saveConfig() 
    end) 
    if setLockVisual then setLockVisual(uiLocked) end 
    setMobileMovingModeVisual=mkToggle(configPage,"Edit Buttons",function(on) 
        if on and uiLocked then 
            mobileMovingMode=false
            if mobContainerRef then mobContainerRef.Active=false end
            if setMobileMovingModeVisual then setMobileMovingModeVisual(false) end 
            return 
        end 
        mobileMovingMode=(on==true)
        if mobContainerRef then
            mobContainerRef.Active=(mobileMovingMode==true and not uiLocked)
        end
        saveMobileButtonsConfigOnly() 
        saveConfig() 
    end) 
    if setMobileMovingModeVisual then setMobileMovingModeVisual(mobileMovingMode and not uiLocked) end 
    do 
        local row=mkRow(configPage,32);mkLabel(row,"UI Scale") 
        local UI_SCALES={75,90,100,110,125,150} 
        local uiBtnW=28 
        local uiStartX=-6-(#UI_SCALES*(uiBtnW+2)) 
        local refs={} 
        local function refreshBtns(selected) 
            for _,ref in ipairs(refs) do 
                local active=ref.sz==selected 
                ref.btn.BackgroundColor3=active and Color3.fromRGB(60,60,80) or INP 
                ref.btn.TextColor3=active and WHITE or W 
            end 
        end 
        local selected=math.floor((uiScale*100)+0.5) 
        for i,sz in ipairs(UI_SCALES) do 
            local sb=Instance.new("TextButton",row) 
            sb.Size=UDim2.new(0,uiBtnW,0,20);sb.Position=UDim2.new(1,uiStartX+(i-1)*(uiBtnW+2),0.5,-10) 
            sb.BackgroundColor3=(selected==sz) and Color3.fromRGB(60,60,80) or INP;sb.BorderSizePixel=0 
            sb.Text=tostring(sz);sb.TextColor3=(selected==sz) and WHITE or W;sb.Font=Enum.Font.SciFi;sb.TextSize=8;sb.ZIndex=5 
            Instance.new("UICorner",sb).CornerRadius=UDim.new(0,5) 
            local bs=Instance.new("UIStroke",sb);bs.Color=STROKE;bs.Thickness=1 
            table.insert(refs,{btn=sb,sz=sz}) 
            sb.Activated:Connect(function() uiScale=sz/100;scaleObj.Scale=uiScale;refreshBtns(sz);saveConfig() end) 
        end 
    end 
    mkSect(configPage,"Configuration")
    do
        local row=mkRow(configPage,48);mkLabel(row,"Save Config")
        local btn=Instance.new("TextButton",row)
        btn.Size=UDim2.new(0,130,0,32);btn.Position=UDim2.new(1,-138,0.5,-16)
        btn.BackgroundColor3=INP;btn.BorderSizePixel=0;btn.Text="SAVE CONFIG";btn.TextColor3=WHITE
        btn.Font=Enum.Font.SciFi;btn.TextSize=10;btn.ZIndex=5
        Instance.new("UICorner",btn).CornerRadius=UDim.new(0,7)
        local st=Instance.new("UIStroke",btn);st.Color=STROKE;st.Thickness=1
        btn.Activated:Connect(function()
            configPersistenceEnabled=true
            pcall(saveConfig)
            pcall(saveMobileButtonsConfigOnly)
            btn.Text="SAVED!"
            task.delay(0.9,function() if btn and btn.Parent then btn.Text="SAVE CONFIG" end end)
        end)
    end
    do
        local row=mkRow(configPage,48);mkLabel(row,"Delete Settings")
        local btn=Instance.new("TextButton",row)
        btn.Size=UDim2.new(0,130,0,32);btn.Position=UDim2.new(1,-138,0.5,-16)
        btn.BackgroundColor3=INP;btn.BorderSizePixel=0;btn.Text="DELETE SETTINGS";btn.TextColor3=WHITE
        btn.Font=Enum.Font.SciFi;btn.TextSize=10;btn.ZIndex=5
        Instance.new("UICorner",btn).CornerRadius=UDim.new(0,7)
        local st=Instance.new("UIStroke",btn);st.Color=STROKE;st.Thickness=1
        btn.Activated:Connect(function()
            deleteSavedConfig()
            btn.Text="DELETED!"
            task.delay(0.9,function() if btn and btn.Parent then btn.Text="DELETE SETTINGS" end end)
        end)
    end

    UIS.InputBegan:Connect(function(input,gpe) 
        if _anyKeyListening then return end 
        if input.UserInputType==Enum.UserInputType.Keyboard then 
            if gpe or UIS:GetFocusedTextBox() then return end 
        elseif not isGamepadInput(input) then return end 
        if not isBindableInput(input) then return end 
        local kc=input.KeyCode 
        if kbMatch(KB.LaggerToggle,kc) then toggleLaggerMode();saveConfig() 
        elseif kbMatch(KB.SpeedToggle,kc) then toggleCarryMode();saveConfig() 
        elseif kbMatch(KB.DropBrainrot,kc) then runJumpDrop() 
        elseif kbMatch(KB.TPFloor,kc) then runTPFloor() 
        elseif kbMatch(KB.InstaReset,kc) then cursedInstaReset() 
        elseif kbMatch(KB.AutoLeft,kc) then 
            autoLeftEnabled=not autoLeftEnabled 
            if autoLeftEnabled then queueAutoLeftStart() else stopAutoLeft() end 
            if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end 
            saveConfig() 
        elseif kbMatch(KB.AutoRight,kc) then 
            autoRightEnabled=not autoRightEnabled 
            if autoRightEnabled then queueAutoRightStart() else stopAutoRight() end 
            if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end 
            saveConfig() 
        elseif kbMatch(KB.AutoBat,kc) then 
            if autoBatEnabled then 
                autoBatEnabled=false;disableAutoBat() 
                if autoBatSetVisual then autoBatSetVisual(false) end 
                if mobBtnRefs and mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end 
            else 
                queueAutoBatStart() 
                if autoBatSetVisual then autoBatSetVisual(autoBatEnabled) end 
                if mobBtnRefs and mobBtnRefs.autoBat then mobBtnRefs.autoBat(autoBatEnabled) end 
            end 
            saveConfig() 
        elseif kbMatch(KB.GuiHide,kc) then 
            if main.Visible then hideGui() else showGui() end 
        end 
    end) 
    selectPage("menu") 
end 

-- ============================================================ 
-- STEAL BAR – CLASSIC FPS STYLE (PINALAKI) 
-- ============================================================ 
local StealBarGui = Instance.new("ScreenGui") 
StealBarGui.Name = "TargetStealBar" 
StealBarGui.IgnoreGuiInset = true 
StealBarGui.ResetOnSpawn = false 
StealBarGui.DisplayOrder = 999 
StealBarGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling 
StealBarGui.Parent = LP:WaitForChild("PlayerGui") 

stealBarContainer = Instance.new("Frame", StealBarGui) 
stealBarContainer.Name = "StealBarContainer" 
stealBarContainer.Size = UDim2.new(0, 320, 0, 42) 
stealBarContainer.Position = UDim2.new(0.5, -160, 0, 100) 
stealBarContainer.BackgroundTransparency = 1 
stealBarContainer.ZIndex = 10 

local main = Instance.new("Frame", stealBarContainer) 
main.Size = UDim2.new(1, 0, 1, 0) 
main.Position = UDim2.new(0, 0, 0, 0) 
main.BackgroundColor3 = Color3.fromRGB(0, 0, 0) 
main.BackgroundTransparency = 0 
main.BorderSizePixel = 0 
main.ZIndex = 2 
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8) 

local border = Instance.new("UIStroke", main) 
border.Color = Color3.fromRGB(255, 255, 255) 
border.Thickness = 1.5 
border.Transparency = 0.3 
border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border 

local progressFill = Instance.new("Frame", main) 
progressFill.Name = "ProgressFill" 
progressFill.Size = UDim2.new(0, 0, 1, 0) 
progressFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255) 
progressFill.BackgroundTransparency = 0 
progressFill.BorderSizePixel = 0 
progressFill.ZIndex = 3 
Instance.new("UICorner", progressFill).CornerRadius = UDim.new(0, 8) 

local label = Instance.new("TextLabel", main) 
label.Name = "Label" 
label.Size = UDim2.new(1, -16, 1, 0) 
label.Position = UDim2.new(0, 8, 0, 0) 
label.BackgroundTransparency = 1 
label.Text = "STEALING 0%" 
label.TextColor3 = Color3.fromRGB(255, 255, 255) 
label.TextSize = 16 
label.Font = Enum.Font.SciFi 
label.TextXAlignment = Enum.TextXAlignment.Left 
label.TextStrokeTransparency = 0.7 
label.ZIndex = 4 

local _lastPct = 0 
local _visualSpeed = 0.35
local _fps = 0
local _fpsFrames = 0
local _fpsClock = tick()
local _ping = 0
local StatsService = game:GetService("Stats")

RunService.RenderStepped:Connect(function(dt) 
    local target = 0 
    if isStealing and stealStartTime then 
        target = math.clamp((tick() - stealStartTime) / math.max(Steal.StealDuration, 0.01), 0, 1) 
    end 
    _lastPct = _lastPct + (target - _lastPct) * math.min(dt * _visualSpeed * 60, 1) 
    local f = math.clamp(_lastPct, 0, 1)

    _fpsFrames = _fpsFrames + 1
    local now = tick()
    if now - _fpsClock >= 0.5 then
        _fps = math.floor((_fpsFrames / (now - _fpsClock)) + 0.5)
        _fpsFrames = 0
        _fpsClock = now
        pcall(function()
            local pingText = StatsService.Network.ServerStatsItem["Data Ping"]:GetValueString()
            _ping = tonumber(string.match(pingText, "[%d%.]+")) or _ping
        end)
    end

    if progressFill then progressFill.Size = UDim2.new(f, 0, 1, 0) end 
    if label then
        label.Text = string.format("STEALING %d%%   |   FPS %d   |   PING %d ms", math.floor(f * 100), _fps, math.floor(_ping + 0.5))
    end
end) 

local dragging, dragStart, startPos = false 
stealBarContainer.Active = true
stealBarContainer.InputBegan:Connect(function(inp) 
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        -- Barra STEAL (vermelho): só pode mover quando Edit Buttons estiver ativo.
        if uiLocked or not mobileMovingMode then return end
        dragging = true 
        dragStart = inp.Position 
        startPos = stealBarContainer.Position 
        inp.Changed:Connect(function() 
            if inp.UserInputState == Enum.UserInputState.End then dragging = false end 
        end) 
    end 
end) 
UIS.InputChanged:Connect(function(inp) 
    if not dragging then return end 
    if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then 
        local delta = inp.Position - dragStart 
        local cam = workspace.CurrentCamera 
        local vp = cam and cam.ViewportSize or Vector2.new(1000, 1000) 
        local sz = stealBarContainer.AbsoluteSize 
        local newX = math.clamp(startPos.X.Scale * vp.X + startPos.X.Offset + delta.X, sz.X / 2, vp.X - sz.X / 2) 
        local newY = math.clamp(startPos.Y.Scale * vp.Y + startPos.Y.Offset + delta.Y, 0, vp.Y - sz.Y) 
        stealBarContainer.Position = UDim2.new(startPos.X.Scale, newX - startPos.X.Scale * vp.X, startPos.Y.Scale, newY - startPos.Y.Scale * vp.Y) 
    end 
end) 

-- ============================================================ 
-- LOAD CONFIG AND BUILD 
-- ============================================================ 
local _savedCfg = nil 
local function loadConfigKeys() 
    if not(isfile and isfile("exeMobile.json")) then return end 
    local ok,cfg=pcall(function() return HS:JSONDecode(readfile("exeMobile.json")) end) 
    if not ok or not cfg then return end 
    _savedCfg=cfg 
    local function lk(e,d) 
        if type(d)~="table" then return end;if d.kb and Enum.KeyCode[d.kb] then e.kb=Enum.KeyCode[d.kb] end 
    end 
    lk(KB.DropBrainrot,cfg.dropBrainrotKey);lk(KB.AutoLeft,cfg.autoLeftKey);lk(KB.AutoRight,cfg.autoRightKey) 
    lk(KB.AutoBat,cfg.autoBatKey);lk(KB.LaggerToggle,cfg.laggerToggleKey) 
    lk(KB.TPFloor,cfg.tpFloorKey);lk(KB.InstaReset,cfg.instaResetKey);lk(KB.GuiHide,cfg.guiHideKey);lk(KB.SpeedToggle,cfg.speedToggleKey);lk(KB.Aimbot2,cfg.aimbot2Key);lk(KB.AntiDesyncAimbot,cfg.antiDesyncAimbotKey) 
    if cfg.laggerPanelKey and Enum.KeyCode[cfg.laggerPanelKey] then exeLaggerPanelKey=Enum.KeyCode[cfg.laggerPanelKey] end 
    if cfg.normalSpeed then NS=cfg.normalSpeed end 
    if cfg.carrySpeed then CS=cfg.carrySpeed end 
    if cfg.grabRadius and type(cfg.grabRadius)=="number" then Steal.StealRadius=cfg.grabRadius else Steal.StealRadius=60 end 
    if cfg.stealDuration and type(cfg.stealDuration)=="number" then Steal.StealDuration=cfg.stealDuration else Steal.StealDuration=1.4 end 
    if cfg.stealMode=="SEMI" or cfg.stealMode=="V1" or cfg.stealMode=="NORMAL" then Steal.Mode=cfg.stealMode end
    if cfg.laggerSpeed and type(cfg.laggerSpeed)=="number" then LAGGER_SPEED=cfg.laggerSpeed end 
    if cfg.laggerCarrySpeed and type(cfg.laggerCarrySpeed)=="number" then LAGGER_CARRY_SPEED=cfg.laggerCarrySpeed end 
    if cfg.autoSwing~=nil then autoSwingEnabled=cfg.autoSwing==true end 
    if cfg.espEnabled~=nil then _G.DeepESP.enabled=cfg.espEnabled==true end
    if cfg.espLine~=nil then _G.DeepESP.line=cfg.espLine==true end
    if cfg.espSquare~=nil then _G.DeepESP.square=cfg.espSquare==true end
    if cfg.espExpanded~=nil then _G.DeepESP.expanded=cfg.espExpanded==true end
    if cfg.autoBatSpeed and type(cfg.autoBatSpeed)=="number" then AUTO_BAT_SPEED=math.clamp(cfg.autoBatSpeed,1,500) end 
    if cfg.bodyLockRadius and type(cfg.bodyLockRadius)=="number" then bodyLockRadius=math.clamp(cfg.bodyLockRadius,1,500) end 
    if cfg.uiScale and type(cfg.uiScale)=="number" then uiScale=math.clamp(cfg.uiScale,0.6,1.6) end 
    if cfg.uiLocked~=nil then uiLocked=cfg.uiLocked==true end 
    if cfg.fovValue and type(cfg.fovValue)=="number" then fovValue=math.clamp(cfg.fovValue,30,120) end 
    if cfg.mobileButtonsSize and type(cfg.mobileButtonsSize)=="number" then mobileButtonsSize=cfg.mobileButtonsSize end 
    if cfg.mobileButtonShape and type(cfg.mobileButtonShape)=="string" then mobileButtonShape=cfg.mobileButtonShape end 
    if cfg.hubImageChoice and type(cfg.hubImageChoice)=="number" then hubImageChoice=math.clamp(cfg.hubImageChoice,1,2) end
    if cfg.buttonImageChoice and type(cfg.buttonImageChoice)=="number" then buttonImageChoice=math.clamp(cfg.buttonImageChoice,1,2) end
    if cfg.mobileDragSmall~=nil then mobileDragSmall=cfg.mobileDragSmall==true end 
    if cfg.mobileMovingMode~=nil then mobileMovingMode=cfg.mobileMovingMode==true end 
    if cfg.anti404Drop~=nil then antiDrop404Enabled=cfg.anti404Drop==true end 
    if cfg.anti404Die~=nil then antiDie404Enabled=cfg.anti404Die==true end 
    if cfg.anti404Bat~=nil then antiBat404Enabled=cfg.anti404Bat==true end 
    if cfg.mobBtnSavedContainerPos and type(cfg.mobBtnSavedContainerPos)=="table" then mobBtnSavedContainerPos=cfg.mobBtnSavedContainerPos end 
    if cfg.mobBtnSavedIndPos and type(cfg.mobBtnSavedIndPos)=="table" then mobBtnSavedIndPos=cfg.mobBtnSavedIndPos end 
end 
local function loadConfigState() 
    local cfg=_savedCfg;if not cfg then return end 
    if normalBox then normalBox.Text=tostring(NS) end 
    if carryBox then carryBox.Text=tostring(CS) end 
    if radInput then radInput.Text=tostring(Steal.StealRadius) end 
    if durationBox then durationBox.Text=tostring(Steal.StealDuration) end
    if stealModeBtn then stealModeBtn.Text=Steal.Mode end
    if laggerBox then laggerBox.Text=tostring(LAGGER_SPEED) end 
    if laggerCarryBox then laggerCarryBox.Text=tostring(LAGGER_CARRY_SPEED) end 
    if uiScaleBox then uiScaleBox.Text=tostring(uiScale) end 
    if fovValueBox then fovValueBox.Text=tostring(fovValue) end 
    if bodyLockRadiusBox then bodyLockRadiusBox.Text=tostring(bodyLockRadius) end 
    if autoBatSpeedBox then autoBatSpeedBox.Text=tostring(AUTO_BAT_SPEED) end 
    if cfg.guiPos and exeMainFrame then exeMainFrame.Position=UDim2.new(cfg.guiPos.xs or 0.5,cfg.guiPos.xo or -160,cfg.guiPos.ys or 0.5,cfg.guiPos.yo or -235) end 
    if cfg.miniPos and exeMiniButton then exeMiniButton.Position=UDim2.new(cfg.miniPos.xs or 0,cfg.miniPos.xo or 26,cfg.miniPos.ys or 0,cfg.miniPos.yo or 26) end 
    if cfg.grabBarPos and exeGrabBar then exeGrabBar.Position=UDim2.new(cfg.grabBarPos.xs or 0.5,cfg.grabBarPos.xo or -110,cfg.grabBarPos.ys or 1,cfg.grabBarPos.yo or -50) end 
    if cfg.stealBarPos and stealBarContainer then 
        stealBarContainer.Position = UDim2.new(cfg.stealBarPos.xs or 0.5, cfg.stealBarPos.xo or -160, cfg.stealBarPos.ys or 0, cfg.stealBarPos.yo or 100) 
    end 
    if setLockVisual then setLockVisual(uiLocked) end 
    if setMobileMovingModeVisual then setMobileMovingModeVisual(mobileMovingMode and not uiLocked) end
    if mobContainerRef then
        mobContainerRef.Active=(mobileMovingMode==true and not uiLocked)
    end
    task.spawn(function() 
        task.wait(0.15) 
        if cfg.antiRagdoll then antiRagdollEnabled=true;if setAntiRagVisual then setAntiRagVisual(true) end;startAntiRagdoll() end 
        if cfg.autoStealEnabled then Steal.AutoStealEnabled=true;if setInstaGrab then setInstaGrab(true) end;pcall(startAutoSteal) end 
        if cfg.infiniteJump then infJumpEnabled=true;if setInfJumpVisual then setInfJumpVisual(true) end end 
        if cfg.medusaCounter then medusaCounterEnabled=true;if setMedusaVisual then setMedusaVisual(true) end;setupMedusa(LP.Character) end 
        if cfg.batCounter then batCounterEnabled=true;if setBatCounterVisual then setBatCounterVisual(true) end;startBatCounter() end
        if cfg.antiTpAimbot then setAntiTpAimbot(true) end
        if cfg.bodyLockEnabled then bodyLockEnabled=true;if setBodyLockVisual then setBodyLockVisual(true) end;startBodyLock() end 
        laggerToggled=true;speedMode=false;laggerPhase=1;refreshSpeedModeLabel() 
        if setAutoSwingVisual then setAutoSwingVisual(autoSwingEnabled) end 
        if _G.DeepESP.lineVisual then _G.DeepESP.lineVisual(_G.DeepESP.line) end
        if _G.DeepESP.squareVisual then _G.DeepESP.squareVisual(_G.DeepESP.square) end
        if _G.DeepESP.refreshExpanded then _G.DeepESP.refreshExpanded() end
        _G.DeepESP.setEnabled(_G.DeepESP.enabled)
        if cfg.autoBat then autoBatEnabled=true;if autoBatSetVisual then autoBatSetVisual(true) end;queueAutoBatStart() end 
        if cfg.aimbot2 then setAimbot2(true) end 
        -- TP Aimbot permanece desligado ao iniciar; pode ser ativado manualmente. 
        if cfg.unwalkEnabled then unwalkEnabled=true;if setUnwalkVisual then setUnwalkVisual(true) end;task.spawn(function() task.wait(0.5);startUnwalk() end) end 
        if cfg.anti404Drop then antiDrop404Enabled=true;antiDie404Enabled=true;antiBat404Enabled=true;infJumpEnabled=true;start404AntiDrop();start404AntiDie();start404AntiBat();if set404AntiDropVisual then set404AntiDropVisual(true) end end 
        if cfg.autoSwitchSpeed then autoSwitchSpeedEnabled=true;if setAutoSwitchSpeedVisual then setAutoSwitchSpeedVisual(true) end;startAutoSwitchSpeed() end 
        if cfg.autoTurnOffSpeed then autoTurnOffSpeedEnabled=true;if setAutoTurnOffSpeedVisual then setAutoTurnOffSpeedVisual(true) end;startAutoSwitchSpeed() end 
        if cfg.autoSwitchLaggerSpeed then autoSwitchLaggerSpeedEnabled=true;if setAutoSwitchLaggerSpeedVisual then setAutoSwitchLaggerSpeedVisual(true) end;startAutoSwitchSpeed() end 
        if cfg.fpsBoostEnabled then fpsBoostEnabled=true;if setFpsBoostVisual then setFpsBoostVisual(true) end;applyFPSBoost() end 
        if cfg.fovEnabled then fovEnabled=true;if setFovVisual then setFovVisual(true) end;setFovEnabled(true) end 
        if cfg.antiLag then enableAntiLag();if setAntiLagVisual then setAntiLagVisual(true) end end 
        if cfg.stretchRez then enableStretchRez();if setStretchRezVisual then setStretchRezVisual(true) end end 
    end) 
end 
loadConfigKeys() 
buildGui() 
loadConfigState() 
buildMobileButtons() 
UIS.InputBegan:Connect(function(input,gpe) 
    if _anyKeyListening then return end 
    if UIS:GetFocusedTextBox() then return end 
    if input.KeyCode==Enum.KeyCode.Unknown then return end 
    local kc=input.KeyCode 
    local function matches(entry) return entry and (kc==entry.kb) end 
    if matches(KB.Aimbot2) then setAimbot2(not aimbot2Enabled) pcall(saveConfig) end 
    if matches(KB.AntiDesyncAimbot) then setTPAimbot(not tpAimbotEnabled) pcall(saveConfig) end 
end) 
function openExeLaggerPanel() 
    local cg=game:GetService("CoreGui") 
    local old=cg:FindFirstChild("ExeLagger_UI") or cg:FindFirstChild("ExeLaggerPanel") 
    if old then old:Destroy();return end 
    local laggerScript=[===[ 
    local Players = game:GetService("Players") 
    local UserInputService = game:GetService("UserInputService") 
    local TweenService = game:GetService("TweenService") 
    local CoreGui = game:GetService("CoreGui") 
    local HttpService = game:GetService("HttpService") 
    local RunService = game:GetService("RunService") 
    local player = Players.LocalPlayer 
    local ConfigFile = "ExeMobileLaggerConfig.json" 
    local NIVELES = { 
        Low = { poder = 23 }, 
        Mid = { poder = 32 }, 
        High = { poder = 70 }, 
        Crazy = { poder = 90 } 
    } 
    local keybind = Enum.KeyCode.M 
    local laggerActive = false 
    local lagThread = nil 
    local nivelActual = "Low" 
    local ventanaBloqueada = false 
    local UI_CONFIG = { 
        White = Color3.fromRGB(255, 255, 255), 
        Black = Color3.fromRGB(0, 0, 0), 
        MainBg = Color3.fromRGB(0, 0, 0), 
        TitleColor = Color3.fromRGB(255, 255, 255), 
        TextColor = Color3.fromRGB(255, 255, 255), 
        ButtonInact = Color3.fromRGB(0, 0, 0), 
        ButtonLow = Color3.fromRGB(255, 255, 255), 
        ButtonMid = Color3.fromRGB(255, 255, 255), 
        ButtonHigh = Color3.fromRGB(255, 255, 255), 
        ButtonCrazy = Color3.fromRGB(255, 255, 255), 
        ToggleOff = Color3.fromRGB(0, 0, 0), 
        ToggleOn = Color3.fromRGB(255, 255, 255), 
        LockColor = Color3.fromRGB(255, 255, 255), 
        UnlockColor = Color3.fromRGB(0, 0, 0), 
        Font = Enum.Font.SciFi, 
        BorderColor = Color3.fromRGB(255, 255, 255), 
    } 
    local function SaveConfig() 
        local data = { 
            Nivel = nivelActual, 
            Bloqueado = ventanaBloqueada, 
            Keybind = keybind and keybind.Name or "M" 
        } 
        pcall(function() writefile(ConfigFile, HttpService:JSONEncode(data)) end) 
    end 
    local function LoadConfig() 
        if pcall(isfile, ConfigFile) and isfile(ConfigFile) then 
            pcall(function() 
                local data = HttpService:JSONDecode(readfile(ConfigFile)) 
                nivelActual = data.Nivel or "Low" 
                if nivelActual == "Ultra" then nivelActual = "Crazy" end 
                ventanaBloqueada = data.Bloqueado or false 
                if data.Keybind then 
                    for _,k in ipairs(Enum.KeyCode:GetEnumItems()) do 
                        if k.Name == data.Keybind then keybind = k break end 
                    end 
                end 
            end) 
        end 
    end 
    LoadConfig() 
    local function bomb(poder) 
        local main, spam = {}, {{}} 
        local z = spam[1] 
        for i = 1, 25 do 
            local t = {} 
            table.insert(z, t) 
            z = t 
        end 
        local max = math.min(12000, poder * 50) 
        for i = 1, max do 
            table.insert(main, spam) 
        end 
        pcall(function() game:GetService("RobloxReplicatedStorage").SetPlayerBlockList:FireServer(main) end) 
    end 
    local toggleBall, toggleContainer, btnLow, btnMid, btnHigh, btnCrazy, lockButton 
    local titleLabel, textLagger, keybindTextBox, toggleClick 
    local function actualizarBotonesNivel() 
        if btnLow then 
            if nivelActual == "Low" then 
                btnLow.BackgroundColor3 = UI_CONFIG.ButtonLow 
                btnLow.TextColor3 = UI_CONFIG.Black 
                btnLow.BorderSizePixel = 1 
                btnLow.BorderColor3 = UI_CONFIG.BorderColor 
            else 
                btnLow.BackgroundColor3 = UI_CONFIG.ButtonInact 
                btnLow.TextColor3 = UI_CONFIG.White 
                btnLow.BorderSizePixel = 1 
                btnLow.BorderColor3 = UI_CONFIG.BorderColor 
            end 
        end 
        if btnMid then 
            if nivelActual == "Mid" then 
                btnMid.BackgroundColor3 = UI_CONFIG.ButtonMid 
                btnMid.TextColor3 = UI_CONFIG.Black 
                btnMid.BorderSizePixel = 1 
                btnMid.BorderColor3 = UI_CONFIG.BorderColor 
            else 
                btnMid.BackgroundColor3 = UI_CONFIG.ButtonInact 
                btnMid.TextColor3 = UI_CONFIG.White 
                btnMid.BorderSizePixel = 1 
                btnMid.BorderColor3 = UI_CONFIG.BorderColor 
            end 
        end 
        if btnHigh then 
            if nivelActual == "High" then 
                btnHigh.BackgroundColor3 = UI_CONFIG.ButtonHigh 
                btnHigh.TextColor3 = UI_CONFIG.Black 
                btnHigh.BorderSizePixel = 1 
                btnHigh.BorderColor3 = UI_CONFIG.BorderColor 
            else 
                btnHigh.BackgroundColor3 = UI_CONFIG.ButtonInact 
                btnHigh.TextColor3 = UI_CONFIG.White 
                btnHigh.BorderSizePixel = 1 
                btnHigh.BorderColor3 = UI_CONFIG.BorderColor 
            end 
        end 
        if btnCrazy then 
            if nivelActual == "Crazy" then 
                btnCrazy.BackgroundColor3 = UI_CONFIG.ButtonCrazy 
                btnCrazy.TextColor3 = UI_CONFIG.Black 
                btnCrazy.BorderSizePixel = 1 
                btnCrazy.BorderColor3 = UI_CONFIG.BorderColor 
            else 
                btnCrazy.BackgroundColor3 = UI_CONFIG.ButtonInact 
                btnCrazy.TextColor3 = UI_CONFIG.White 
                btnCrazy.BorderSizePixel = 1 
                btnCrazy.BorderColor3 = UI_CONFIG.BorderColor 
            end 
        end 
    end 
    local function actualizarSwitch() 
        if toggleContainer then toggleContainer.BackgroundColor3 = laggerActive and UI_CONFIG.ToggleOn or UI_CONFIG.ToggleOff end 
        if toggleBall then 
            toggleBall.BackgroundColor3 = laggerActive and UI_CONFIG.Black or UI_CONFIG.White 
            if laggerActive then toggleBall.Position = UDim2.new(1, -18, 0.5, -8) 
            else toggleBall.Position = UDim2.new(0, 2, 0.5, -8) end 
        end 
        if toggleClick then 
            toggleClick.Text = laggerActive and "ON" or "OFF" 
            toggleClick.TextColor3 = laggerActive and UI_CONFIG.Black or UI_CONFIG.White 
        end 
    end 
    local function actualizarCandado() 
        if lockButton then 
            lockButton.Text = ventanaBloqueada and "Locked" or "Unlocked" 
            if ventanaBloqueada then 
                lockButton.BackgroundColor3 = UI_CONFIG.LockColor 
                lockButton.TextColor3 = UI_CONFIG.Black 
            else 
                lockButton.BackgroundColor3 = UI_CONFIG.UnlockColor 
                lockButton.TextColor3 = UI_CONFIG.White 
            end 
        end 
    end 
    local function actualizarKeybindTextBox() 
        if keybindTextBox then keybindTextBox.Text = keybind.Name end 
    end 
    local function toggleLagger() 
        laggerActive = not laggerActive 
        local targetPos = laggerActive and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8) 
        if toggleBall then 
            TweenService:Create(toggleBall, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = targetPos }):Play() 
        end 
        actualizarSwitch() 
        if laggerActive then 
            if lagThread then task.cancel(lagThread) end 
            lagThread = task.spawn(function() 
                while laggerActive do 
                    pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(80000) end) 
                    bomb(NIVELES[nivelActual].poder) 
                    task.wait(0.18) 
                end 
            end) 
        else 
            if lagThread then task.cancel(lagThread); lagThread = nil end 
        end 
    end 
    if CoreGui:FindFirstChild("ExeLagger_UI") then CoreGui.ExeLagger_UI:Destroy() end 
    local screenGui = Instance.new("ScreenGui") 
    screenGui.Name = "ExeLagger_UI" 
    screenGui.Parent = CoreGui 
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling 
    screenGui.ResetOnSpawn = false 
    local mainFrame = Instance.new("Frame") 
    mainFrame.Name = "MainFrame" 
    mainFrame.BackgroundColor3 = UI_CONFIG.MainBg 
    mainFrame.BackgroundTransparency = 0 
    mainFrame.BorderSizePixel = 0 
    mainFrame.Size = UDim2.new(0, 200, 0, 110) 
    mainFrame.Position = UDim2.new(0.15, 0, 0.5, -55) 
    mainFrame.Parent = screenGui 
    mainFrame.ClipsDescendants = true 
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8) 
    local bgImage = Instance.new("ImageLabel") 
    bgImage.Name = "BgImage" 
    bgImage.Size = UDim2.new(1, 0, 1, 0) 
    bgImage.Position = UDim2.new(0, 0, 0, 0) 
    bgImage.BackgroundTransparency = 1 
    bgImage.Image = "rbxthumb://type=Asset&id=97069004530020&w=420&h=420" 
    bgImage.ImageColor3 = Color3.fromRGB(255, 255, 255) 
    bgImage.ImageTransparency = 0 
    bgImage.ScaleType = Enum.ScaleType.Stretch 
    bgImage.ZIndex = 1 
    bgImage.Parent = mainFrame 
    Instance.new("UICorner", bgImage).CornerRadius = UDim.new(0, 8) 
    local bgOverlay = Instance.new("Frame") 
    bgOverlay.Name = "BgOverlay" 
    bgOverlay.Size = UDim2.new(1, 0, 1, 0) 
    bgOverlay.Position = UDim2.new(0, 0, 0, 0) 
    bgOverlay.BackgroundColor3 = UI_CONFIG.Black 
    bgOverlay.BackgroundTransparency = 0.82 
    bgOverlay.BorderSizePixel = 0 
    bgOverlay.ZIndex = 1 
    bgOverlay.Parent = mainFrame 
    Instance.new("UICorner", bgOverlay).CornerRadius = UDim.new(0, 8) 
    titleLabel = Instance.new("TextLabel", mainFrame) 
    titleLabel.BackgroundTransparency = 1 
    titleLabel.Position = UDim2.new(0, 8, 0, 4) 
    titleLabel.Size = UDim2.new(0, 140, 0, 25) 
    titleLabel.Font = UI_CONFIG.Font 
    titleLabel.Text = "DEEP DUELS" 
    titleLabel.TextColor3 = UI_CONFIG.TitleColor 
    titleLabel.TextSize = 13 
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left 
    titleLabel.TextYAlignment = Enum.TextYAlignment.Center 
    titleLabel.ZIndex = 3 
    -- Player avatar and name beside DEEP DUELS
    local playerAvatar = Instance.new("ImageLabel", mainFrame) 
    playerAvatar.Name = "PlayerAvatar" 
    playerAvatar.BackgroundTransparency = 1 
    playerAvatar.Size = UDim2.new(0, 24, 0, 24) 
    playerAvatar.Position = UDim2.new(0, 151, 0, 4) 
    playerAvatar.ZIndex = 4 
    playerAvatar.ScaleType = Enum.ScaleType.Crop 
    Instance.new("UICorner", playerAvatar).CornerRadius = UDim.new(1, 0) 
    local avatarStroke = Instance.new("UIStroke", playerAvatar) 
    avatarStroke.Color = UI_CONFIG.BorderColor 
    avatarStroke.Thickness = 1 
    pcall(function()
        playerAvatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(LP.UserId) .. "&w=100&h=100" 
    end) 
    local playerNameLabel = Instance.new("TextLabel", mainFrame) 
    playerNameLabel.Name = "PlayerName" 
    playerNameLabel.BackgroundTransparency = 1 
    playerNameLabel.Position = UDim2.new(0, 179, 0, 4) 
    playerNameLabel.Size = UDim2.new(0, 95, 0, 24) 
    playerNameLabel.Font = UI_CONFIG.Font 
    playerNameLabel.Text = tostring(LP.DisplayName or LP.Name) 
    playerNameLabel.TextColor3 = UI_CONFIG.White 
    playerNameLabel.TextSize = 10 
    playerNameLabel.TextXAlignment = Enum.TextXAlignment.Left 
    playerNameLabel.TextYAlignment = Enum.TextYAlignment.Center 
    playerNameLabel.TextTruncate = Enum.TextTruncate.AtEnd 
    playerNameLabel.ZIndex = 4 
    local closeBtn = Instance.new("TextButton", mainFrame) 
    closeBtn.Name = "CloseButton" 
    closeBtn.Size = UDim2.new(0, 22, 0, 22) 
    closeBtn.Position = UDim2.new(1, -26, 0, 4) 
    closeBtn.BackgroundColor3 = Color3.fromRGB(220, 35, 55) 
    closeBtn.BorderSizePixel = 0 
    closeBtn.Text = "X" 
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255) 
    closeBtn.Font = UI_CONFIG.Font 
    closeBtn.TextSize = 11 
    closeBtn.ZIndex = 4 
    closeBtn.AutoButtonColor = false 
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0) 
    closeBtn.MouseEnter:Connect(function() TweenService:Create(closeBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(255, 60, 80)}):Play() end) 
    closeBtn.MouseLeave:Connect(function() TweenService:Create(closeBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(220, 35, 55)}):Play() end) 
    closeBtn.MouseButton1Click:Connect(function() laggerActive = false if lagThread then task.cancel(lagThread); lagThread = nil end pcall(function() screenGui:Destroy() end) end) 
    lockButton = Instance.new("TextButton", mainFrame) 
    lockButton.BackgroundColor3 = UI_CONFIG.UnlockColor 
    lockButton.BackgroundTransparency = 0.55 
    lockButton.BorderSizePixel = 1 
    lockButton.BorderColor3 = UI_CONFIG.BorderColor 
    lockButton.Position = UDim2.new(1, -58, 0, 4) 
    lockButton.Size = UDim2.new(0, 28, 0, 16) 
    lockButton.Font = UI_CONFIG.Font 
    lockButton.TextSize = 8 
    lockButton.TextColor3 = UI_CONFIG.White 
    lockButton.AutoButtonColor = false 
    lockButton.ZIndex = 2 
    Instance.new("UICorner", lockButton).CornerRadius = UDim.new(0, 4) 
    lockButton.MouseButton1Click:Connect(function() ventanaBloqueada = not ventanaBloqueada actualizarCandado() SaveConfig() end) 
    actualizarCandado() 
    textLagger = Instance.new("TextLabel", mainFrame) 
    textLagger.BackgroundTransparency = 1 
    textLagger.Position = UDim2.new(0, 6, 0, 34) 
    textLagger.Size = UDim2.new(0, 60, 0, 20) 
    textLagger.Font = UI_CONFIG.Font 
    textLagger.Text = "LAGGER" 
    textLagger.TextColor3 = UI_CONFIG.TextColor 
    textLagger.TextSize = 11 
    textLagger.TextXAlignment = Enum.TextXAlignment.Left 
    textLagger.TextYAlignment = Enum.TextYAlignment.Center 
    textLagger.ZIndex = 2 
    keybindTextBox = Instance.new("TextBox", mainFrame) 
    keybindTextBox.Name = "KeybindTextBox" 
    keybindTextBox.BackgroundColor3 = UI_CONFIG.Black 
    keybindTextBox.BackgroundTransparency = 0.55 
    keybindTextBox.BorderSizePixel = 1 
    keybindTextBox.BorderColor3 = UI_CONFIG.BorderColor 
    keybindTextBox.Position = UDim2.new(0, 70, 0, 34) 
    keybindTextBox.Size = UDim2.new(0, 45, 0, 20) 
    keybindTextBox.Font = UI_CONFIG.Font 
    keybindTextBox.Text = keybind.Name 
    keybindTextBox.TextColor3 = UI_CONFIG.White 
    keybindTextBox.TextSize = 10 
    keybindTextBox.ClearTextOnFocus = true 
    keybindTextBox.ZIndex = 2 
    Instance.new("UICorner", keybindTextBox).CornerRadius = UDim.new(0, 4) 
    local function actualizarKeybind() 
        local text = keybindTextBox.Text 
        local cleanText = text:gsub("%s+", ""):upper() 
        local foundKey = nil 
        for _, item in ipairs(Enum.KeyCode:GetEnumItems()) do 
            if item.Name:upper() == cleanText then foundKey = item break end 
        end 
        if foundKey then keybind = foundKey SaveConfig() end 
        keybindTextBox.Text = keybind.Name 
    end 
    keybindTextBox.FocusLost:Connect(function(enterPressed) actualizarKeybind() end) 
    toggleContainer = Instance.new("Frame", mainFrame) 
    toggleContainer.BackgroundColor3 = UI_CONFIG.ToggleOff 
    toggleContainer.BackgroundTransparency = 0.55 
    toggleContainer.BorderSizePixel = 1 
    toggleContainer.BorderColor3 = UI_CONFIG.BorderColor 
    toggleContainer.Position = UDim2.new(1, -54, 0, 34) 
    toggleContainer.Size = UDim2.new(0, 48, 0, 20) 
    toggleContainer.ZIndex = 2 
    Instance.new("UICorner", toggleContainer).CornerRadius = UDim.new(1, 0) 
    toggleBall = Instance.new("Frame", toggleContainer) 
    toggleBall.BackgroundColor3 = UI_CONFIG.White 
    toggleBall.BackgroundTransparency = 0.55 
    toggleBall.BorderSizePixel = 0 
    toggleBall.Size = UDim2.new(0, 16, 0, 16) 
    toggleBall.Position = UDim2.new(0, 2, 0.5, -8) 
    toggleBall.ZIndex = 2 
    Instance.new("UICorner", toggleBall).CornerRadius = UDim.new(1, 0) 
    toggleClick = Instance.new("TextButton", toggleContainer) 
    toggleClick.BackgroundTransparency = 1 
    toggleClick.Size = UDim2.new(1, 0, 1, 0) 
    toggleClick.ZIndex = 3 
    toggleClick.Font = UI_CONFIG.Font 
    toggleClick.Text = "OFF" 
    toggleClick.TextSize = 8 
    toggleClick.TextColor3 = UI_CONFIG.White 
    toggleClick.TextXAlignment = Enum.TextXAlignment.Center 
    toggleClick.TextYAlignment = Enum.TextYAlignment.Center 
    toggleClick.MouseButton1Click:Connect(toggleLagger) 
    toggleClick.AutoButtonColor = false 
    local btnY = 75 
    local btnW = 44 
    local btnH = 22 
    local espaciado = 4 
    local margenIzq = 6 
    btnLow = Instance.new("TextButton", mainFrame) 
    btnLow.Size = UDim2.new(0, btnW, 0, btnH) 
    btnLow.Position = UDim2.new(0, margenIzq, 0, btnY) 
    btnLow.Font = UI_CONFIG.Font 
    btnLow.Text = "LOW" 
    btnLow.TextColor3 = UI_CONFIG.White 
    btnLow.TextSize = 9 
    btnLow.AutoButtonColor = false 
    btnLow.BackgroundColor3 = UI_CONFIG.ButtonInact 
    btnLow.BackgroundTransparency = 0.55 
    btnLow.BorderSizePixel = 1 
    btnLow.BorderColor3 = UI_CONFIG.BorderColor 
    btnLow.ZIndex = 2 
    Instance.new("UICorner", btnLow).CornerRadius = UDim.new(0, 6) 
    btnLow.MouseButton1Click:Connect(function() nivelActual = "Low" actualizarBotonesNivel() SaveConfig() end) 
    btnMid = Instance.new("TextButton", mainFrame) 
    btnMid.Size = UDim2.new(0, btnW, 0, btnH) 
    btnMid.Position = UDim2.new(0, margenIzq + btnW + espaciado, 0, btnY) 
    btnMid.Font = UI_CONFIG.Font 
    btnMid.Text = "MID" 
    btnMid.TextColor3 = UI_CONFIG.White 
    btnMid.TextSize = 9 
    btnMid.AutoButtonColor = false 
    btnMid.BackgroundColor3 = UI_CONFIG.ButtonInact 
    btnMid.BackgroundTransparency = 0.55 
    btnMid.BorderSizePixel = 1 
    btnMid.BorderColor3 = UI_CONFIG.BorderColor 
    btnMid.ZIndex = 2 
    Instance.new("UICorner", btnMid).CornerRadius = UDim.new(0, 6) 
    btnMid.MouseButton1Click:Connect(function() nivelActual = "Mid" actualizarBotonesNivel() SaveConfig() end) 
    btnHigh = Instance.new("TextButton", mainFrame) 
    btnHigh.Size = UDim2.new(0, btnW, 0, btnH) 
    btnHigh.Position = UDim2.new(0, margenIzq + (btnW + espaciado) * 2, 0, btnY) 
    btnHigh.Font = UI_CONFIG.Font 
    btnHigh.Text = "HIGH" 
    btnHigh.TextColor3 = UI_CONFIG.White 
    btnHigh.TextSize = 9 
    btnHigh.AutoButtonColor = false 
    btnHigh.BackgroundColor3 = UI_CONFIG.ButtonInact 
    btnHigh.BackgroundTransparency = 0.55 
    btnHigh.BorderSizePixel = 1 
    btnHigh.BorderColor3 = UI_CONFIG.BorderColor 
    btnHigh.ZIndex = 2 
    Instance.new("UICorner", btnHigh).CornerRadius = UDim.new(0, 6) 
    btnHigh.MouseButton1Click:Connect(function() nivelActual = "High" actualizarBotonesNivel() SaveConfig() end) 
    btnCrazy = Instance.new("TextButton", mainFrame) 
    btnCrazy.Size = UDim2.new(0, btnW, 0, btnH) 
    btnCrazy.Position = UDim2.new(0, margenIzq + (btnW + espaciado) * 4, 0, btnY) 
    btnCrazy.Font = UI_CONFIG.Font 
    btnCrazy.Text = "CRAZY" 
    btnCrazy.TextColor3 = UI_CONFIG.White 
    btnCrazy.TextSize = 7 
    btnCrazy.AutoButtonColor = false 
    btnCrazy.BackgroundColor3 = UI_CONFIG.ButtonInact 
    btnCrazy.BackgroundTransparency = 0.55 
    btnCrazy.BorderSizePixel = 1 
    btnCrazy.BorderColor3 = UI_CONFIG.BorderColor 
    btnCrazy.ZIndex = 2 
    Instance.new("UICorner", btnCrazy).CornerRadius = UDim.new(0, 6) 
    btnCrazy.MouseButton1Click:Connect(function() nivelActual = "Crazy" actualizarBotonesNivel() SaveConfig() end) 
    actualizarBotonesNivel() 
    actualizarSwitch() 
    actualizarCandado() 
    actualizarKeybindTextBox() 
    local isDragging, dragStart, startPos = false, nil, nil 
    mainFrame.InputBegan:Connect(function(input) 
        if ventanaBloqueada then return end 
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
            isDragging = true 
            dragStart = input.Position 
            startPos = mainFrame.Position 
        end 
    end) 
    UserInputService.InputChanged:Connect(function(input) 
        if not isDragging or ventanaBloqueada then return end 
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then 
            local delta = input.Position - dragStart 
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) 
        end 
    end) 
    mainFrame.InputEnded:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
            isDragging = false 
        end 
    end) 
    UserInputService.InputBegan:Connect(function(input, gp) 
        if not screenGui.Parent then return end 
        if gp then return end 
        if UserInputService:GetFocusedTextBox() then return end 
        if input.KeyCode == keybind then toggleLagger() end 
    end) 
    ]===] 
    local ok,err=pcall(function() loadstring(laggerScript)() end) 
    if not ok then warn("DEEP DUELS LAGGER ERROR",err) end 
end 
function openExeInstaResetPanel() 
    local cg=game:GetService("CoreGui") 
    local old=cg:FindFirstChild("ExeInstaResetPanel");if old then old:Destroy();return end 
    local g=Instance.new("ScreenGui");g.Name="ExeInstaResetPanel";g.ResetOnSpawn=false;g.DisplayOrder=30;g.IgnoreGuiInset=true 
    if not pcall(function() g.Parent=cg end) then g.Parent=LP:WaitForChild("PlayerGui") end 
    local frame=Instance.new("Frame",g);frame.Size=UDim2.new(0,150,0,76);frame.Position=UDim2.new(0.5,-75,0,60);frame.BackgroundColor3=Color3.fromRGB(5,5,7);frame.BorderSizePixel=0;frame.Active=true 
    Instance.new("UICorner",frame).CornerRadius=UDim.new(0,10);local st=Instance.new("UIStroke",frame);st.Color=Color3.fromRGB(90,90,100);st.Thickness=1.2 
    local top=Instance.new("Frame",frame);top.Size=UDim2.new(1,0,0,24);top.BackgroundColor3=Color3.fromRGB(9,9,13);top.BorderSizePixel=0;Instance.new("UICorner",top).CornerRadius=UDim.new(0,10) 
    local title=Instance.new("TextLabel",top);title.Size=UDim2.new(1,-30,1,0);title.Position=UDim2.new(0,8,0,0);title.BackgroundTransparency=1;title.Text="DEEP DUELS RESET";title.TextColor3=Color3.fromRGB(255,255,255);title.Font=Enum.Font.SciFi;title.TextSize=10;title.TextXAlignment=Enum.TextXAlignment.Left 
    local x=Instance.new("TextButton",top);x.Size=UDim2.new(0,18,0,18);x.Position=UDim2.new(1,-22,0.5,-9);x.BackgroundColor3=Color3.fromRGB(28,28,35);x.BorderSizePixel=0;x.Text="X";x.TextColor3=Color3.fromRGB(255,255,255);x.Font=Enum.Font.SciFi;x.TextSize=9;Instance.new("UICorner",x).CornerRadius=UDim.new(0,5);x.MouseButton1Click:Connect(function() g:Destroy() end) 
    local btn=Instance.new("TextButton",frame);btn.Size=UDim2.new(1,-16,0,24);btn.Position=UDim2.new(0,8,0,30);btn.BackgroundColor3=Color3.fromRGB(14,14,18);btn.BorderSizePixel=0;btn.Text="RESET NOW";btn.TextColor3=Color3.fromRGB(255,255,255);btn.Font=Enum.Font.SciFi;btn.TextSize=12;Instance.new("UICorner",btn).CornerRadius=UDim.new(0,7);Instance.new("UIStroke",btn).Color=Color3.fromRGB(90,90,100);btn.MouseButton1Click:Connect(cursedInstaReset) 
    local kb=Instance.new("TextButton",frame);kb.Size=UDim2.new(0,64,0,10);kb.Position=UDim2.new(0.5,-32,0,60);kb.BackgroundColor3=Color3.fromRGB(10,10,14);kb.BorderSizePixel=0;kb.Text=(KB.InstaReset.kb and KB.InstaReset.kb.Name:upper()) or "SET KEY";kb.TextColor3=Color3.fromRGB(235,235,235);kb.Font=Enum.Font.SciFi;kb.TextSize=6;Instance.new("UICorner",kb).CornerRadius=UDim.new(0,5);Instance.new("UIStroke",kb).Color=Color3.fromRGB(90,90,100) 
    kb.MouseButton1Click:Connect(function() 
        exeStartKeyListen(kb,function(key) KB.InstaReset.kb=key;saveConfig() end) 
    end) 
    local dragOn,ds,sp=false,nil,nil 
    frame.InputBegan:Connect(function(i) 
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then 
            dragOn=true;ds=i.Position;sp=frame.Position;i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dragOn=false end end) 
        end 
    end) 
    UIS.InputChanged:Connect(function(i) 
        if dragOn and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then 
            frame.Position=UDim2.new(sp.X.Scale,sp.X.Offset+i.Position.X-ds.X,sp.Y.Scale,sp.Y.Offset+i.Position.Y-ds.Y) 
        end 
    end) 
end 
function exeStartKeyListen(btn,onSet) 
    if not btn or btn:GetAttribute("Listening") then return end 
    btn:SetAttribute("Listening",true) 
    _anyKeyListening=true 
    local prev=btn.Text 
    btn.Text="..." 
    btn.TextColor3=Color3.fromRGB(255,255,255) 
    local started=tick() 
    local conn 
    conn=UIS.InputBegan:Connect(function(inp) 
        if inp.KeyCode==Enum.KeyCode.Escape then 
            if conn then conn:Disconnect() end 
            btn:SetAttribute("Listening",false);_anyKeyListening=false;btn.Text=prev 
            return 
        end 
        if inp.UserInputType~=Enum.UserInputType.Keyboard then return end 
        if conn then conn:Disconnect() end 
        btn:SetAttribute("Listening",false);_anyKeyListening=false 
        btn.Text=inp.KeyCode.Name:upper() 
        if onSet then onSet(inp.KeyCode) end 
    end) 
end 
function setFovEnabled(on) 
    fovEnabled=on 
    if on then 
        if fovConn then fovConn:Disconnect() end 
        fovConn=RunService.RenderStepped:Connect(function() 
            if not fovEnabled then if fovConn then fovConn:Disconnect();fovConn=nil end;return end 
            if workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView=fovValue end 
        end) 
    else 
        if fovConn then fovConn:Disconnect();fovConn=nil end 
        if workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView=70 end 
    end 
end 
function resetFovAndCamera() 
    setFovEnabled(false) 
    if stretchRezEnabled then disableStretchRez();if setStretchRezVisual then setStretchRezVisual(false) end end 
    if workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView=70 end 
end 

-- ============================================================
-- ULTIMATE ANTI-KICK SYSTEM v5.0
-- ============================================================
local antiKickPlayer = Players.LocalPlayer
if antiKickPlayer then
    local antiChar = antiKickPlayer.Character or antiKickPlayer.CharacterAdded:Wait()
    local antiHum = antiChar:WaitForChild("Humanoid")
    local antiRoot = antiChar:WaitForChild("HumanoidRootPart")
    local lastSafePosition = antiRoot.CFrame

    -- Instant health restore
    antiHum.HealthChanged:Connect(function()
        if antiHum.Health <= 0 then
            antiHum.MaxHealth = 100
            antiHum.Health = 100
        end
    end)
    RunService.Heartbeat:Connect(function()
        if antiHum and antiHum.Parent then
            if antiHum.Health <= 0 or antiHum.Health < antiHum.MaxHealth then
                antiHum.Health = antiHum.MaxHealth
            end
        end
    end)

    -- Block death/dying states
    antiHum.StateChanged:Connect(function(_, newState)
        if newState == Enum.HumanoidStateType.Dead or newState == Enum.HumanoidStateType.Dying then
            antiHum:ChangeState(Enum.HumanoidStateType.GettingUp)
            antiHum.Health = antiHum.MaxHealth
        end
    end)

    -- Anti-kick metatable
    pcall(function()
        local mt = getrawmetatable(antiKickPlayer)
        if mt then
            setreadonly(mt, false)
            local old = mt.__namecall
            if old then
                mt.__namecall = function(self, ...)
                    if self == antiKickPlayer and tostring(({...})[#({...})]):lower() == "kick" then
                        return nil
                    end
                    return old(self, ...)
                end
            end
            setreadonly(mt, true)
        end
    end)

    -- Position lock
    RunService.Heartbeat:Connect(function()
        if antiRoot and antiRoot.Parent then
            local dist = (antiRoot.Position - lastSafePosition.Position).Magnitude
            if dist > 150 and antiHum.MoveVector.Magnitude < 1 then
                antiRoot.CFrame = lastSafePosition
            elseif dist < 30 then
                lastSafePosition = antiRoot.CFrame
            end
        end
    end)

    -- Velocity & fall damage prevent
    task.spawn(function()
        while antiHum and antiHum.Parent do
            if antiRoot then
                local vel = antiRoot.AssemblyLinearVelocity
                if vel.Y < -150 then
                    antiRoot.AssemblyLinearVelocity = Vector3.new(vel.X, -50, vel.Z)
                    antiHum.Health = antiHum.MaxHealth
                end
                if vel.Magnitude > 300 and antiHum.MoveVector.Magnitude < 1 then
                    antiRoot.AssemblyLinearVelocity = Vector3.new(0, vel.Y, 0)
                end
            end
            wait(0.05)
        end
    end)

    -- Workspace monitoring
    task.spawn(function()
        while antiChar do
            if antiChar.Parent ~= workspace then
                antiChar.Parent = workspace
            end
            if not antiChar:FindFirstChild("Humanoid") then
                local newH = Instance.new("Humanoid")
                newH.Parent = antiChar
                antiHum = newH
            end
            wait(0.5)
        end
    end)

    -- Health max lock
    task.spawn(function()
        while antiHum and antiHum.Parent do
            if antiHum.MaxHealth ~= 100 then antiHum.MaxHealth = 100 end
            if antiHum.Health <= 0 then antiHum.Health = 100 end
            wait(0.1)
        end
    end)

    -- Character respawn handler
    antiKickPlayer.CharacterAdded:Connect(function(newChar)
        antiChar = newChar
        antiHum = antiChar:WaitForChild("Humanoid")
        antiRoot = antiChar:WaitForChild("HumanoidRootPart")
        lastSafePosition = antiRoot.CFrame
        wait(0.1)
        -- Re-apply health check
        antiHum.HealthChanged:Connect(function()
            if antiHum.Health <= 0 then
                antiHum.MaxHealth = 100
                antiHum.Health = 100
            end
        end)
    end)
end

print("DEEP DUELS - discord.gg/deT7abF96")
