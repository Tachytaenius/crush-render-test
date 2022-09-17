local pos, angle, fullCanvas, crushShader
local fullViewDistance, crushStart, crushEnd = 256, 64, 128 -- Crush everything from falloffStart to viewDistance into falloffStart to falloffEnd

local crushCentreX, crushCentreY, showStartCircle, offsetX, offsetY

local img = love.graphics.newImage("render.png")
img:setWrap("clampzero")

function love.load()
	fullCanvas = love.graphics.newCanvas(fullViewDistance * 2, fullViewDistance * 2)
	crushShader = love.graphics.newShader("shaders/crush.glsl")
	fullCanvas:setWrap("clampzero")
	crushCentreX, crushCentreY = fullViewDistance, fullViewDistance
	offsetX, offsetY = 0, 0
	showStartCircle = false
end

function love.keypressed(key)
	if key == "space" then
		showStartCircle = not showStartCircle
	end
end

function love.update(dt)
	local speed = 10
	if love.keyboard.isDown("lshift") then
		speed = speed * 4
	end
	local movementThisFrame = speed * dt
	if love.keyboard.isDown("a") then
		crushCentreX = crushCentreX - movementThisFrame
	end
	if love.keyboard.isDown("d") then
		crushCentreX = crushCentreX + movementThisFrame
	end
	if love.keyboard.isDown("w") then
		crushCentreY = crushCentreY - movementThisFrame
	end
	if love.keyboard.isDown("s") then
		crushCentreY = crushCentreY + movementThisFrame
	end
	if love.keyboard.isDown("left") then
		offsetX = offsetX - movementThisFrame
	end
	if love.keyboard.isDown("right") then
		offsetX = offsetX + movementThisFrame
	end
	if love.keyboard.isDown("up") then
		offsetY = offsetY - movementThisFrame
	end
	if love.keyboard.isDown("down") then
		offsetY = offsetY + movementThisFrame
	end
end

function love.draw()
	love.graphics.setCanvas(fullCanvas)
	love.graphics.draw(img)
	local power = math.log(fullViewDistance / crushStart) / math.log(crushEnd / crushStart)
	love.graphics.setCanvas()
	love.graphics.setShader(crushShader)
	crushShader:send("inputCanvasSize", {fullCanvas:getDimensions()})
	crushShader:send("outputCanvasSize", {crushEnd * 2, crushEnd * 2})
	crushShader:send("crushCentre", {crushCentreX, crushCentreY})
	crushShader:send("crushStart", crushStart)
	crushShader:send("power", power)
	crushShader:send("showStartCircle", showStartCircle)
	crushShader:send("offset", {offsetX, offsetY})
	love.graphics.draw(fullCanvas)
	love.graphics.setShader()
	love.graphics.print("WASD, shift to move faster, space to\ntoggle crush start circle drawn")
end
