local CustomUI = {}

function CustomUI:CreateWindow(title)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CustomUI"
    screenGui.Parent = game:GetService("CoreGui")
    screenGui.ResetOnSpawn = false

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainWindow"
    mainFrame.Size = UDim2.new(0, 350, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui

    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame

    local titleText = Instance.new("TextLabel")
    titleText.Name = "Title"
    titleText.Size = UDim2.new(1, -10, 1, 0)
    titleText.Position = UDim2.new(0, 10, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = title or "Custom UI"
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Font = Enum.Font.GothamSemibold
    titleText.TextSize = 14
    titleText.Parent = titleBar

    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 1, 0)
    closeButton.Position = UDim2.new(1, -30, 0, 0)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeButton.BorderSizePixel = 0
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.white
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 14
    closeButton.Parent = titleBar

    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(1, 0, 0, 30)
    tabContainer.Position = UDim2.new(0, 0, 0, 30)
    tabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = mainFrame

    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Size = UDim2.new(1, 0, 1, -60)
    contentContainer.Position = UDim2.new(0, 0, 0, 60)
    contentContainer.BackgroundTransparency = 1
    contentContainer.Parent = mainFrame

    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "ScrollFrame"
    scrollFrame.Size = UDim2.new(1, 0, 1, 0)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 5
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollFrame.Parent = contentContainer

    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.Padding = UDim.new(0, 5)
    uiListLayout.Parent = scrollFrame

    local tabs = {}
    local currentTab = nil

    local dragging = false
    local dragInput, dragStart, startPos

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    function tabs:CreateTab(name)
        local tabButton = Instance.new("TextButton")
        tabButton.Name = name.."Tab"
        tabButton.Size = UDim2.new(0, 80, 1, 0)
        tabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        tabButton.BorderSizePixel = 0
        tabButton.Text = name
        tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        tabButton.Font = Enum.Font.Gotham
        tabButton.TextSize = 12
        tabButton.Parent = tabContainer

        local tabContent = Instance.new("Frame")
        tabContent.Name = name.."Content"
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.Visible = false
        tabContent.Parent = scrollFrame

        local contentList = Instance.new("UIListLayout")
        contentList.Padding = UDim.new(0, 5)
        contentList.Parent = tabContent

        tabButton.MouseButton1Click:Connect(function()
            if currentTab then
                currentTab.Visible = false
            end
            tabContent.Visible = true
            currentTab = tabContent
            
            for _, child in ipairs(tabContainer:GetChildren()) do
                if child:IsA("TextButton") then
                    child.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                    child.TextColor3 = Color3.fromRGB(200, 200, 200)
                end
            end
            tabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            tabButton.TextColor3 = Color3.white
        end)

        if #tabContainer:GetChildren() == 1 then
            tabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            tabButton.TextColor3 = Color3.white
            tabContent.Visible = true
            currentTab = tabContent
        end

        local tabFunctions = {}

        function tabFunctions:CreateButton(options)
            local button = Instance.new("TextButton")
            button.Name = options.Name or "Button"
            button.Size = UDim2.new(1, -20, 0, 30)
            button.Position = UDim2.new(0, 10, 0, 0)
            button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            button.BorderSizePixel = 0
            button.Text = options.Name or "Button"
            button.TextColor3 = Color3.white
            button.Font = Enum.Font.Gotham
            button.TextSize = 14
            button.Parent = tabContent

            button.MouseButton1Click:Connect(options.Callback or function() end)

            return button
        end

        function tabFunctions:CreateToggle(options)
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Name = options.Name or "Toggle"
            toggleFrame.Size = UDim2.new(1, -20, 0, 30)
            toggleFrame.Position = UDim2.new(0, 10, 0, 0)
            toggleFrame.BackgroundTransparency = 1
            toggleFrame.Parent = tabContent

            local toggleButton = Instance.new("TextButton")
            toggleButton.Name = "ToggleButton"
            toggleButton.Size = UDim2.new(0, 50, 1, 0)
            toggleButton.Position = UDim2.new(1, -50, 0, 0)
            toggleButton.BackgroundColor3 = options.Default and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(80, 80, 80)
            toggleButton.BorderSizePixel = 0
            toggleButton.Text = options.Default and "ON" or "OFF"
            toggleButton.TextColor3 = Color3.white
            toggleButton.Font = Enum.Font.GothamBold
            toggleButton.TextSize = 12
            toggleButton.Parent = toggleFrame

            local toggleLabel = Instance.new("TextLabel")
            toggleLabel.Name = "Label"
            toggleLabel.Size = UDim2.new(1, -60, 1, 0)
            toggleLabel.BackgroundTransparency = 1
            toggleLabel.Text = options.Name or "Toggle"
            toggleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            toggleLabel.Font = Enum.Font.Gotham
            toggleLabel.TextSize = 14
            toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            toggleLabel.Parent = toggleFrame

            local state = options.Default or false

            toggleButton.MouseButton1Click:Connect(function()
                state = not state
                if state then
                    toggleButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
                    toggleButton.Text = "ON"
                else
                    toggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                    toggleButton.Text = "OFF"
                end
                if options.Callback then
                    options.Callback(state)
                end
            end)

            return {
                SetState = function(newState)
                    state = newState
                    if state then
                        toggleButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
                        toggleButton.Text = "ON"
                    else
                        toggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                        toggleButton.Text = "OFF"
                    end
                    if options.Callback then
                        options.Callback(state)
                    end
                end,
                GetState = function()
                    return state
                end
            }
        end

        function tabFunctions:CreateSlider(options)
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Name = options.Name or "Slider"
            sliderFrame.Size = UDim2.new(1, -20, 0, 50)
            sliderFrame.Position = UDim2.new(0, 10, 0, 0)
            sliderFrame.BackgroundTransparency = 1
            sliderFrame.Parent = tabContent

            local sliderLabel = Instance.new("TextLabel")
            sliderLabel.Name = "Label"
            sliderLabel.Size = UDim2.new(1, 0, 0, 20)
            sliderLabel.BackgroundTransparency = 1
            sliderLabel.Text = options.Name or "Slider"
            sliderLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            sliderLabel.Font = Enum.Font.Gotham
            sliderLabel.TextSize = 14
            sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            sliderLabel.Parent = sliderFrame

            local sliderValue = Instance.new("TextLabel")
            sliderValue.Name = "Value"
            sliderValue.Size = UDim2.new(0, 50, 0, 20)
            sliderValue.Position = UDim2.new(1, -50, 0, 0)
            sliderValue.BackgroundTransparency = 1
            sliderValue.Text = tostring(options.Default or options.Min or 0)
            sliderValue.TextColor3 = Color3.fromRGB(200, 200, 200)
            sliderValue.Font = Enum.Font.Gotham
            sliderValue.TextSize = 14
            sliderValue.TextXAlignment = Enum.TextXAlignment.Right
            sliderValue.Parent = sliderFrame

            local sliderBar = Instance.new("Frame")
            sliderBar.Name = "Bar"
            sliderBar.Size = UDim2.new(1, 0, 0, 5)
            sliderBar.Position = UDim2.new(0, 0, 0, 25)
            sliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            sliderBar.BorderSizePixel = 0
            sliderBar.Parent = sliderFrame

            local sliderFill = Instance.new("Frame")
            sliderFill.Name = "Fill"
            sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
            sliderFill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
            sliderFill.BorderSizePixel = 0
            sliderFill.Parent = sliderBar

            local sliderButton = Instance.new("TextButton")
            sliderButton.Name = "Button"
            sliderButton.Size = UDim2.new(0, 10, 0, 15)
            sliderButton.Position = UDim2.new(0.5, -5, 0, 20)
            sliderButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            sliderButton.BorderSizePixel = 0
            sliderButton.Text = ""
            sliderButton.Parent = sliderFrame

            local min = options.Min or 0
            local max = options.Max or 100
            local default = options.Default or min
            local value = default
            local dragging = false

            local function updateValue(newValue)
                value = math.clamp(newValue, min, max)
                local ratio = (value - min) / (max - min)
                sliderFill.Size = UDim2.new(ratio, 0, 1, 0)
                sliderButton.Position = UDim2.new(ratio, -5, 0, 20)
                sliderValue.Text = tostring(math.floor(value * 100) / 100)
                if options.Callback then
                    options.Callback(value)
                end
            end

            sliderButton.MouseButton1Down:Connect(function()
                dragging = true
            end)

            game:GetService("UserInputService").InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)

            game:GetService("UserInputService").InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local mousePos = game:GetService("UserInputService"):GetMouseLocation()
                    local sliderPos = sliderBar.AbsolutePosition
                    local sliderSize = sliderBar.AbsoluteSize
                    local relativePos = math.clamp(mousePos.X - sliderPos.X, 0, sliderSize.X)
                    local ratio = relativePos / sliderSize.X
                    local newValue = min + (max - min) * ratio
                    updateValue(newValue)
                end
            end)

            updateValue(default)

            return {
                SetValue = function(newValue)
                    updateValue(newValue)
                end,
                GetValue = function()
                    return value
                end
            }
        end

        function tabFunctions:CreateDropdown(options)
            local dropdownFrame = Instance.new("Frame")
            dropdownFrame.Name = options.Name or "Dropdown"
            dropdownFrame.Size = UDim2.new(1, -20, 0, 30)
            dropdownFrame.Position = UDim2.new(0, 10, 0, 0)
            dropdownFrame.BackgroundTransparency = 1
            dropdownFrame.ClipsDescendants = true
            dropdownFrame.Parent = tabContent

            local dropdownButton = Instance.new("TextButton")
            dropdownButton.Name = "Button"
            dropdownButton.Size = UDim2.new(1, 0, 0, 30)
            dropdownButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            dropdownButton.BorderSizePixel = 0
            dropdownButton.Text = options.Name or "Dropdown"
            dropdownButton.TextColor3 = Color3.fromRGB(200, 200, 200)
            dropdownButton.Font = Enum.Font.Gotham
            dropdownButton.TextSize = 14
            dropdownButton.TextXAlignment = Enum.TextXAlignment.Left
            dropdownButton.Parent = dropdownFrame

            local dropdownLabel = Instance.new("TextLabel")
            dropdownLabel.Name = "Selected"
            dropdownLabel.Size = UDim2.new(1, -30, 1, 0)
            dropdownLabel.Position = UDim2.new(0, 10, 0, 0)
            dropdownLabel.BackgroundTransparency = 1
            dropdownLabel.Text = options.Default or ""
            dropdownLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            dropdownLabel.Font = Enum.Font.Gotham
            dropdownLabel.TextSize = 14
            dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            dropdownLabel.Parent = dropdownButton

            local dropdownArrow = Instance.new("TextLabel")
            dropdownArrow.Name = "Arrow"
            dropdownArrow.Size = UDim2.new(0, 20, 1, 0)
            dropdownArrow.Position = UDim2.new(1, -20, 0, 0)
            dropdownArrow.BackgroundTransparency = 1
            dropdownArrow.Text = "▼"
            dropdownArrow.TextColor3 = Color3.fromRGB(200, 200, 200)
            dropdownArrow.Font = Enum.Font.Gotham
            dropdownArrow.TextSize = 14
            dropdownArrow.Parent = dropdownButton

            local dropdownList = Instance.new("Frame")
            dropdownList.Name = "List"
            dropdownList.Size = UDim2.new(1, 0, 0, 0)
            dropdownList.Position = UDim2.new(0, 0, 0, 30)
            dropdownList.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            dropdownList.BorderSizePixel = 0
            dropdownList.Visible = false
            dropdownList.Parent = dropdownFrame

            local listLayout = Instance.new("UIListLayout")
            listLayout.Padding = UDim.new(0, 1)
            listLayout.Parent = dropdownList

            local isOpen = false

            local function toggleDropdown()
                isOpen = not isOpen
                dropdownList.Visible = isOpen
                dropdownArrow.Text = isOpen ? "▲" : "▼"
                
                if isOpen then
                    local itemCount = #dropdownList:GetChildren() - 1
                    dropdownList.Size = UDim2.new(1, 0, 0, itemCount * 30 + (itemCount - 1))
                else
                    dropdownList.Size = UDim2.new(1, 0, 0, 0)
                end
            end

            dropdownButton.MouseButton1Click:Connect(toggleDropdown)

            local function createOption(option)
                local optionButton = Instance.new("TextButton")
                optionButton.Name = option
                optionButton.Size = UDim2.new(1, 0, 0, 30)
                optionButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                optionButton.BorderSizePixel = 0
                optionButton.Text = option
                optionButton.TextColor3 = Color3.fromRGB(200, 200, 200)
                optionButton.Font = Enum.Font.Gotham
                optionButton.TextSize = 14
                optionButton.Parent = dropdownList

                optionButton.MouseButton1Click:Connect(function()
                    dropdownLabel.Text = option
                    toggleDropdown()
                    if options.Callback then
                        options.Callback(option)
                    end
                end)
            end

            for _, option in ipairs(options.Options or {}) do
                createOption(option)
            end

            return {
                AddOption = function(option)
                    createOption(option)
                end,
                RemoveOption = function(option)
                    local child = dropdownList:FindFirstChild(option)
                    if child then
                        child:Destroy()
                    end
                end,
                SetOptions = function(newOptions)
                    for _, child in ipairs(dropdownList:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    for _, option in ipairs(newOptions) do
                        createOption(option)
                    end
                end,
                SetSelected = function(option)
                    dropdownLabel.Text = option
                    if options.Callback then
                        options.Callback(option)
                    end
                end
            }
        end

        return tabFunctions
    end

    return tabs
end

return CustomUI
