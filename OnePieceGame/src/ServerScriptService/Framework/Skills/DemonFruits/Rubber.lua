--/Services
local collectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--/Modules
local frameWork = script.Parent.Parent.Parent
local G = require(game.ReplicatedStorage.Modules.GlobalFunctions)
local cooldownHandler = require(frameWork.Handlers.CooldownHandler)
local stateHandler = require(frameWork.Handlers.StateHandler)
local attackData = require(game.ReplicatedStorage.Modules.Manager.AttackData)
local damageModule = require(frameWork.Misc.Damage)
local dataStore = require(frameWork.Systems.Datastore)
local bezierCurve = require(game.ReplicatedStorage.Modules.Misc.BezierCurves)
local hitDetection = require(game.ReplicatedStorage.Modules.Misc.HitDetection)
local masteryHandler = require(frameWork.Handlers.MasteryHandler)
local module = {}

--/Variables
local attackRemote = game.ReplicatedStorage.Remotes.DemonFruits[script.Name]
local clientRemote = game.ReplicatedStorage.Remotes.Misc.ClientRemote
local CameraRemote = game.ReplicatedStorage.Remotes.Misc.CameraRemote
local getMouse = game.ReplicatedStorage.Remotes.Functions.GetMouse

--// Modules
local Modules = ReplicatedStorage.Modules
local SharedFunctions = require(Modules.SharedFunctions)

function module.TestMastery(p)
	masteryHandler.IncreaseMastery(p,"Rubber",10)
end

--/TODO: MOVE DESCRIPTION
function module.Move1(p)
	local c = p.Character
	local cooldowns = c.Cooldowns
	local states = c.States
	local mousePos = getMouse:InvokeClient(p)

	local skillName = "Rubber Pistol"

	local skillData = attackData.getData(script.Name,skillName)
	local damage = skillData.baseDamage + dataStore.GetData(p, "Fruit")
	
	if cooldowns:GetAttribute(skillName) then return end
	cooldownHandler.addCooldown(c,skillName)
	
	
	SharedFunctions:FireAllDistanceClients(c, script.Name, 100, {Character = c, Function = "Move1"})
	wait(0.35)
	
	local RootStartCFrame = c.HumanoidRootPart.CFrame

	--/Damage
	CameraRemote:FireClient(p, "CameraShake", {FirstText = 4, SecondText = 6})
	for j = 1,5 do
		local hitPoint = (RootStartCFrame * CFrame.new(0,0,-j * 5)).Position
		if hitPoint then

			local targets = damageModule.getAOE(c,hitPoint,20)
			for i = 1,#targets do
				local target = targets[i]

				damageModule.damageSNG(p,target,damage,{script.Name,skillName})
			end
		end
	end
end

--/TODO: MOVE DESCRIPTION
function module.Move2(p,chargeUp)
	local c = p.Character
	local cooldowns = c.Cooldowns
	local states = c.States
	local mousePos = getMouse:InvokeClient(p)

	local skillName = "Rubber Bazooka"

	local skillData = attackData.getData(script.Name,skillName)
	local damage = skillData.baseDamage + dataStore.GetData(p, "Fruit")
	
	if cooldowns:GetAttribute(skillName) then return end
	cooldownHandler.addCooldown(c,skillName)


	SharedFunctions:FireAllDistanceClients(c, script.Name, 100, {Character = c, Function = "Move2"})
	wait(0.5)
	
	local RootStartCFrame = c.HumanoidRootPart.CFrame

	--/Damage
	CameraRemote:FireClient(p, "CameraShake", {FirstText = 4, SecondText = 6})
	for j = 1,5 do
		local hitPoint = (RootStartCFrame * CFrame.new(0,0,-j * 5)).Position
		if hitPoint then

			local targets = damageModule.getAOE(c,hitPoint,30)
			for i = 1,#targets do
				local target = targets[i]

				damageModule.damageSNG(p,target,damage,{script.Name,skillName})
			end
		end
	end
end

--/TODO: MOVE DESCRIPTION
function module.Move3(p)
	local c = p.Character
	local cooldowns = c.Cooldowns
	local states = c.States
	local mousePos = getMouse:InvokeClient(p)

	local skillName = "Rubber Axe Stamp"

	local skillData = attackData.getData(script.Name,skillName)
	local damage = skillData.baseDamage + dataStore.GetData(p, "Fruit")
	
	if cooldowns:GetAttribute(skillName) then return end
	cooldownHandler.addCooldown(c,skillName)


	SharedFunctions:FireAllDistanceClients(c, script.Name, 100, {Character = c, Function = "Move3"})
	
	wait(0.5)
	--/Damage
	local hitPoint = c.HumanoidRootPart.Position
	if hitPoint then

		CameraRemote:FireClient(p, "CameraShake", {FirstText = 4, SecondText = 6})

		local targets = damageModule.getAOE(c,hitPoint,30)
		for i = 1,#targets do
			local target = targets[i]

			damageModule.damageSNG(p,target,damage,{script.Name,skillName})
		end
	end
end

--/TODO: MOVE DESCRIPTION
function module.Move4(p)
	local c = p.Character
	local cooldowns = c.Cooldowns
	local states = c.States
	local mousePos = getMouse:InvokeClient(p)

	local skillName = "Rubber Gattling"

	local skillData = attackData.getData(script.Name,skillName)
	local damage = skillData.baseDamage + dataStore.GetData(p, "Fruit")
	
	if cooldowns:GetAttribute(skillName) then return end
	cooldownHandler.addCooldown(c,skillName)


	SharedFunctions:FireAllDistanceClients(c, script.Name, 100, {Character = c, Function = "Move4"})
	
	for _ = 1,10 do
		local RootStartCFrame = c.HumanoidRootPart.CFrame
		for j = 1,5 do
			local hitPoint = (RootStartCFrame * CFrame.new(0,0,-j * 5)).Position
			if hitPoint then

				local targets = damageModule.getAOE(c,hitPoint,20)
				for i = 1,#targets do
					local target = targets[i]

					damageModule.damageSNG(p,target,damage,{script.Name,skillName})
				end
			end
		end
		wait(0.1)
	end
end

--/Events
attackRemote.OnServerEvent:connect(function(p,action,info)
	if module[action] then
		module[action](p,info)
	end
end)


return module