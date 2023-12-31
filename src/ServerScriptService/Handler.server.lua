local RS = game:GetService("ReplicatedStorage")
local RegionModule = require(RS:WaitForChild("Combat"):WaitForChild("RotatedRegion3"))
local Values = require(RS.Combat.Values)
local AttackEvent = RS:WaitForChild("Remotes").ServerCombat
local Assets = RS:WaitForChild("Assets")
local frameWork = script.Parent.Framework
local damageModule = require(frameWork.Misc.Damage)
local MobAnimationRemote = game.ReplicatedStorage.Remotes.Misc.MobAnimation
local TS = game:GetService("TweenService")

local function Curve(t, p0, p1, p2)
	local A = p0:Lerp(p1, t)
	local B = p1:Lerp(p2, t)
	return A:Lerp(B, t)
end

AttackEvent.OnServerEvent:Connect(function(plr, Type, A1, A2, Damage, size, Last, Air, BH)
	local Char = plr.Character
	local Hum = Char:WaitForChild("Humanoid")
	local HumRP = Char:WaitForChild("HumanoidRootPart")

	local function Hitbox()
		Values:CreateValue("BoolValue", Char, "NoJump", false, 1)

		local HitTable = {}

		local part = Instance.new("Part")
		part.Transparency = 1
		part.Anchored = true
		part.CanCollide = false
		part.Size = size
		part.CFrame = HumRP.CFrame * CFrame.new(0, 0, part.Size.Z - (part.Size.Z * 2) + part.Size.Z / 2)
		part.BrickColor = BrickColor.new("Really red")
		part.Material = "Neon"
		part.Parent = game.Workspace
		game.Debris:AddItem(part, 0.1)

		local Region = RegionModule.FromPart(part)

		local Results = Region:FindPartsInRegion3(nil, 250)

		for _, v in pairs(Results) do
			if v.Parent == Char or v.Parent.Name == "Map" then
				continue
			end
			local PseudoTorso = v.Parent:FindFirstChild("PseudoTorso")

			local Ehum = v.Parent:FindFirstChild("Humanoid")
			local EhumRP = v.Parent:FindFirstChild("HumanoidRootPart")

			if
				PseudoTorso
				and table.find(HitTable, v.Parent) == nil
				and Char.Cooldowns:FindFirstChild("Attacked") == nil
			then
				local LookVector1 = (PseudoTorso.Position - HumRP.Position).unit
				local LookVector2 = PseudoTorso.CFrame.LookVector
				local DotProduct = math.acos(LookVector2:Dot(LookVector1))

				table.insert(HitTable, v.Parent)

				if v.Parent:FindFirstChild("PB") then
					local BlockFX = Assets:WaitForChild("VFX")
						:WaitForChild("Combat")
						:WaitForChild("PBFX")
						:WaitForChild("HitFX")
						:Clone()
					BlockFX.Parent = PseudoTorso
					game.Debris:AddItem(BlockFX, 2)

					local AnimTracks = Hum:GetPlayingAnimationTracks()

					AttackEvent:FireClient(plr, "PB")

					task.spawn(function()
						Hum.AutoRotate = false
						for _, v1 in pairs(AnimTracks) do
							task.wait(0.02)
							v1:AdjustSpeed(0)
							task.delay(2.5, function()
								v1:AdjustSpeed(1)
								Hum.AutoRotate = true
							end)
						end
					end)

					local Sound = Assets:WaitForChild("Sounds"):WaitForChild("PB"):Clone()
					Sound.Parent = PseudoTorso
					Sound:Play()
					game.Debris:AddItem(Sound, 3)

					local DmgCounter =
						Assets:WaitForChild("VFX"):WaitForChild("Combat"):WaitForChild("DmgCounter"):Clone()
					DmgCounter.Parent = workspace
					DmgCounter.Position = PseudoTorso.Position
					DmgCounter.Counter.Number.Text = "Perfect Block"
					DmgCounter.Counter.Number.TextColor3 = Color3.fromRGB(85, 85, 255)
					DmgCounter.Counter.Number.TextStrokeColor3 = Color3.fromRGB(85, 0, 255)

					local goal = {}
					goal.TextColor3 = Color3.fromRGB(255, 255, 255)
					local info = TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.In, 0, true, 0)
					local tween = TS:Create(DmgCounter.Counter.Number, info, goal)
					tween:Play()

					game.Debris:AddItem(DmgCounter, 0.4)

					local P1 = PseudoTorso.Position
					local P2 = PseudoTorso.Position
						+ Vector3.new(math.random(-3, 3), math.random(2, 10), math.random(-3, 3))
					local P3 = P2 + Vector3.new(0, -15, 0)

					task.spawn(function()
						for i = 0, 1, 0.045 do
							local newpos = Curve(i, P1, P2, P3)
							DmgCounter.Position = newpos
							task.wait()
						end
					end)

					for _, v1 in pairs(BlockFX:GetChildren()) do
						local EmitCount = v1:GetAttribute("EmitCount")
						if EmitCount then
							v1:Emit(EmitCount)
						end
					end

					Values:CreateValue("BoolValue", Char.Cooldowns, "StopAttacked", false, 2.5)
					return
				end

				if
					v.Parent:FindFirstChild("Blocking")
					and v.Parent:FindFirstChild("BlockHealth").Value <= 0
					and DotProduct > 1
				then
					local BlockFX = Assets:WaitForChild("VFX")
						:WaitForChild("Combat")
						:WaitForChild("GBFX")
						:WaitForChild("HitFX")
						:Clone()
					BlockFX.Parent = PseudoTorso
					game.Debris:AddItem(BlockFX, 2)

					for _, v1 in pairs(PseudoTorso.Parent:GetChildren()) do
						if v1.Name == "Blocking" then
							v1:Destroy()
						end
					end

					MobAnimationRemote:FireClient(plr, PseudoTorso.Parent.Name, "Combat", "GB", "Stop")

					MobAnimationRemote:FireClient(plr, PseudoTorso.Parent.Name, "Combat", "GB")

					local Sound = Assets:WaitForChild("Sounds"):WaitForChild("BB"):Clone()
					Sound.Parent = PseudoTorso
					Sound:Play()
					game.Debris:AddItem(Sound, 3)

					local DmgCounter =
						Assets:WaitForChild("VFX"):WaitForChild("Combat"):WaitForChild("DmgCounter"):Clone()
					DmgCounter.Parent = workspace
					DmgCounter.Position = PseudoTorso.Position
					DmgCounter.Counter.Number.Text = "Broken"

					Values:CreateValue("BoolValue", PseudoTorso.Parent.Cooldowns, "StopAttacked", false, 1.5)

					local goal = {}
					goal.TextColor3 = Color3.fromRGB(255, 255, 255)
					local info = TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.In, 0, true, 0)
					local tween = TS:Create(DmgCounter.Counter.Number, info, goal)
					tween:Play()

					game.Debris:AddItem(DmgCounter, 0.4)

					local P1 = PseudoTorso.Position
					local P2 = PseudoTorso.Position
						+ Vector3.new(math.random(-3, 3), math.random(2, 10), math.random(-3, 3))
					local P3 = P2 + Vector3.new(0, -15, 0)

					task.spawn(function()
						for i = 0, 1, 0.045 do
							local newpos = Curve(i, P1, P2, P3)
							DmgCounter.Position = newpos
							task.wait()
						end
					end)

					local BV2 = Instance.new("BodyVelocity")
					BV2.Velocity = HumRP.CFrame.LookVector * 10
					BV2.MaxForce = Vector3.new(15000, 15000, 15000)
					BV2.Parent = HumRP
					game.Debris:AddItem(BV2, 0.2)

					for _, v1 in pairs(BlockFX:GetChildren()) do
						local EmitCount = v:GetAttribute("EmitCount")
						if EmitCount then
							v1:Emit(EmitCount)
						end
					end
					return
				end

				if v.Parent:FindFirstChild("Blocking") and DotProduct > 1 then
					v.Parent:FindFirstChild("BlockHealth").Value -= 25
					print(v.Parent:FindFirstChild("BlockHealth").Value)
					local BlockFX = Assets:WaitForChild("VFX")
						:WaitForChild("Combat")
						:WaitForChild("BlockFX")
						:WaitForChild("HitFX")
						:Clone()
					BlockFX.Parent = PseudoTorso
					game.Debris:AddItem(BlockFX, 2)

					local Sound = Assets:WaitForChild("Sounds"):WaitForChild("Blocked"):Clone()
					Sound.Parent = PseudoTorso
					Sound:Play()
					game.Debris:AddItem(Sound, 1)

					local DmgCounter =
						Assets:WaitForChild("VFX"):WaitForChild("Combat"):WaitForChild("DmgCounter"):Clone()
					DmgCounter.Parent = workspace
					DmgCounter.Position = PseudoTorso.Position
					DmgCounter.Counter.Number.Text = "Blocked"
					DmgCounter.Counter.Number.TextColor3 = Color3.fromRGB(199, 199, 199)
					DmgCounter.Counter.Number.TextStrokeColor3 = Color3.fromRGB(152, 152, 152)

					local goal = {}
					goal.TextColor3 = Color3.fromRGB(255, 255, 255)
					local info = TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.In, 0, true, 0)
					local tween = TS:Create(DmgCounter.Counter.Number, info, goal)
					tween:Play()

					game.Debris:AddItem(DmgCounter, 0.4)

					local P1 = PseudoTorso.Position
					local P2 = PseudoTorso.Position
						+ Vector3.new(math.random(-3, 3), math.random(2, 10), math.random(-3, 3))
					local P3 = P2 + Vector3.new(0, -15, 0)

					task.spawn(function()
						for i = 0, 1, 0.045 do
							local newpos = Curve(i, P1, P2, P3)
							DmgCounter.Position = newpos
							task.wait()
						end
					end)

					local BV2 = Instance.new("BodyVelocity")
					BV2.Velocity = HumRP.CFrame.LookVector * 10
					BV2.MaxForce = Vector3.new(15000, 15000, 15000)
					BV2.Parent = HumRP
					game.Debris:AddItem(BV2, 0.2)

					for _, v1 in pairs(BlockFX:GetChildren()) do
						local EmitCount = v1:GetAttribute("EmitCount")
						if EmitCount then
							v1:Emit(EmitCount)
						end
					end
					return
				end

				local DmgCounter = Assets:WaitForChild("VFX"):WaitForChild("Combat"):WaitForChild("DmgCounter"):Clone()
				DmgCounter.Parent = workspace
				DmgCounter.Position = PseudoTorso.Position
				DmgCounter.Counter.Number.Text = Damage

				local goal = {}
				goal.TextColor3 = Color3.fromRGB(255, 255, 255)
				local info = TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.In, 0, true, 0)
				local tween = TS:Create(DmgCounter.Counter.Number, info, goal)
				tween:Play()

				game.Debris:AddItem(DmgCounter, 0.4)

				local P1 = PseudoTorso.Position
				local P2 = PseudoTorso.Position
					+ Vector3.new(math.random(-3, 3), math.random(2, 10), math.random(-3, 3))
				local P3 = P2 + Vector3.new(0, -15, 0)

				task.spawn(function()
					for i = 0, 1, 0.045 do
						local newpos = Curve(i, P1, P2, P3)
						DmgCounter.Position = newpos
						task.wait()
					end
				end)

				MobAnimationRemote:FireClient(plr, PseudoTorso.Parent.Name, "Combat", A2.Name)

				local Sound = Assets:WaitForChild("Sounds").Sounds.Combat:WaitForChild("PunchSound"):Clone()
				Sound.Parent = PseudoTorso
				Sound:Play()
				game.Debris:AddItem(Sound, 1)

				Values:CreateValue("BoolValue", PseudoTorso.Parent.Cooldowns, "Attacked", false, 0.6)

				if Last == false and Air == false then
					HumRP.Parent.States.Combo.Value = 1
				elseif Last == true and Air == false then
					HumRP.Parent.States.Combo.Value = 5

					local raycastParams = RaycastParams.new()
					raycastParams.FilterType = Enum.RaycastFilterType.Exclude
					raycastParams.FilterDescendantsInstances = { Char, PseudoTorso.Parent }
					raycastParams.IgnoreWater = true

					local Origin = PseudoTorso.Position
					local Direction = Vector3.new(0, -5, 0)

					local NewRay = workspace:Raycast(Origin, Direction, raycastParams)

					if NewRay then
						local SmokeParts = { "Left Leg", "Right Leg" }
						for _, _ in pairs(SmokeParts) do
							local trueColor = NewRay.Instance.Color
							local DirtParticle =
								Assets:WaitForChild("VFX"):WaitForChild("Combat"):WaitForChild("DirtParticle"):Clone()
							DirtParticle.Color = ColorSequence.new({
								ColorSequenceKeypoint.new(0, trueColor),
								ColorSequenceKeypoint.new(0.5, trueColor),
								ColorSequenceKeypoint.new(1, trueColor),
							})
							game.Debris:AddItem(DirtParticle, 1)

							if PseudoTorso.Parent:FindFirstChild(v) then
								local Slide = Assets:WaitForChild("Sounds"):WaitForChild("Slide"):Clone()
								Slide.Parent = PseudoTorso
								Slide:Play()
								game.Debris:AddItem(Slide, 1)
								DirtParticle.Parent = PseudoTorso.Parent:FindFirstChild(v)
								task.delay(0.5, function()
									DirtParticle.Enabled = false
								end)
							end
						end
					end
				end

				if Air == false then
					local BV2 = Instance.new("BodyVelocity")
					BV2.Velocity = HumRP.CFrame.LookVector * 10
					BV2.MaxForce = Vector3.new(15000, 15000, 15000)
					BV2.Parent = HumRP
					game.Debris:AddItem(BV2, 0.2)
				end

				--Hits Player up in the air
				if Air == true and Last == false then
					HumRP.Parent.States.Combo.Value = 6

					local BV2 = Instance.new("BodyVelocity")
					BV2.Velocity = HumRP.CFrame.UpVector * 30
					BV2.MaxForce = Vector3.new(55000, 55000, 55000)
					BV2.Name = "SendUp"
					BV2.Parent = HumRP
					task.delay(0.4, function()
						BV2:Destroy()
					end)

					Values:CreateValue("BoolValue", Char.Cooldowns, "Using Move", false, 0.31)
					Values:CreateValue("BoolValue", PseudoTorso.Parent.Cooldowns, "Attacked", false, 0.9)

					task.delay(0.5, function()
						local BP2 = Instance.new("BodyPosition")
						BP2.Position = HumRP.Position
						BP2.MaxForce = Vector3.new(200000, 200000, 200000)
						BP2.P = 400
						BP2.Name = "HoldBP"
						BP2.Parent = HumRP
						task.delay(3.01709150011, function()
							BP2:Destroy()
						end)
					end)
				end

				--Sends opponent flying down and creates crater fx
				if Air == true and Last == true then
					HumRP.Parent.States.Combo.Value = 7

					local StartPos = (HumRP.CFrame.LookVector * 20) + HumRP.Position
					local Direction = Vector3.new(0, -40, 0)

					local RayParams = RaycastParams.new()
					RayParams.FilterDescendantsInstances = { Char, PseudoTorso.Parent }
					RayParams.FilterType = Enum.RaycastFilterType.Exclude
					RayParams.IgnoreWater = true

					local Raycast = workspace:Raycast(StartPos, Direction, RayParams)

					if Raycast then
						print(Raycast.Position, "pre")
						if PseudoTorso:FindFirstChild("HoldBP") then
							PseudoTorso:FindFirstChild("HoldBP"):Destroy()
						end
						if HumRP:FindFirstChild("HoldBP") then
							HumRP:FindFirstChild("HoldBP"):Destroy()
						end

						local function Lerp(i, A, B)
							local LerpThing = A:Lerp(B, i)
							return LerpThing
						end

						task.spawn(function()
							local Lerping = Instance.new("IntValue")
							Lerping.Name = "Lerping"
							Lerping.Parent = PseudoTorso.Parent.States
							task.delay(1, function()
								Lerping:Destroy()
							end)
							for i = 0, 1, 0.03 do
								print(Raycast.Position, "lerp")
								local newpos = Lerp(i, PseudoTorso.Position, Raycast.Position + Vector3.new(0, 3, 0))
								PseudoTorso.Parent:MoveTo(newpos)
								task.wait()
							end
						end)

						task.delay(0.15, function()
							local NumOFParts = 14

							Values:CreateValue("BoolValue", Char, "BigShake", false, 0.1)

							local SmokeWave =
								Assets:WaitForChild("VFX"):WaitForChild("Combat"):WaitForChild("SmokeWave"):Clone()
							SmokeWave.Parent = workspace
							SmokeWave.Position = Raycast.Position + Vector3.new(0, 0.7, 0)
							game.Debris:AddItem(SmokeWave, 2)

							SmokeWave:WaitForChild("Attachment"):WaitForChild("Smoke").Color = ColorSequence.new({
								ColorSequenceKeypoint.new(0, Raycast.Instance.Color),
								ColorSequenceKeypoint.new(1, Raycast.Instance.Color),
							})

							SmokeWave:WaitForChild("Attachment"):WaitForChild("Rocks").Color = ColorSequence.new({
								ColorSequenceKeypoint.new(0, Raycast.Instance.Color),
								ColorSequenceKeypoint.new(1, Raycast.Instance.Color),
							})

							SmokeWave:WaitForChild("Attachment"):WaitForChild("Smoke"):Emit(50)
							SmokeWave:WaitForChild("Attachment"):WaitForChild("Rocks"):Emit(25)
							SmokeWave:WaitForChild("GroundSmash"):Play()

							local Distance = 7
							task.spawn(function()
								for i = 1, NumOFParts, 1 do
									local angle = i * 2 * math.pi / NumOFParts
									local PosOnCircle = Vector3.new(math.sin(angle), 0, math.cos(angle))
										+ PseudoTorso.Position
									local Part =
										Assets:WaitForChild("VFX"):WaitForChild("Combat"):WaitForChild("Rock"):Clone()
									Part.Parent = workspace
									Part.Position = PosOnCircle
									Part.CFrame = CFrame.lookAt(Part.Position, PseudoTorso.Position)
									Part.Position = (Part.CFrame.LookVector * -Distance)
										+ (Vector3.new(PosOnCircle.X, Raycast.Position.Y - 1.5, PosOnCircle.Z))
									Part.Orientation = Vector3.new(
										math.random(-360, 360),
										math.random(-360, 360),
										math.random(-360, 360)
									)
									Part.Color = Raycast.Instance.Color
									Part.Material = Raycast.Instance.Material
									local goal1 = {}
									goal1.Position = Part.Position + Vector3.new(0, 2, 0)
									local info1 = TweenInfo.new(0.2)
									local tween1 = TS:Create(Part, info1, goal1)
									tween1:Play()

									task.delay(2, function()
										local goal2 = {}
										goal2.Position = Part.Position + Vector3.new(0, -2, 0)
										local info2 = TweenInfo.new(1)
										local tween2 = TS:Create(Part, info2, goal2)
										tween2:Play()
									end)

									game.Debris:AddItem(Part, 3)
								end
							end)
						end)
					end
				end

				local HitFX = Assets:WaitForChild("VFX")
					:WaitForChild("Combat")
					:WaitForChild("HitFX")
					:WaitForChild("HitFX")
					:Clone()
				HitFX.Parent = PseudoTorso
				game.Debris:AddItem(HitFX, 1)

				for _, v1 in pairs(HitFX:GetChildren()) do
					if v1.Name == "Crescents" then
						v1:Emit(5)
					end
					if v1.Name == "Gradient" then
						v1:Emit(1)
					end
					if v1.Name == "Shards" then
						v1:Emit(10)
					end
					if v1.Name == "Specs" then
						v1:Emit(10)
					end
				end

				damageModule.damageSNG(plr, PseudoTorso.Parent, Damage, nil)
			end

			if
				Ehum
				and EhumRP
				and v.Parent ~= Char
				and table.find(HitTable, v.Parent) == nil
				and Char:FindFirstChild("Stun") == nil
			then
				print("oh no")
				local LookVector1 = (EhumRP.Position - HumRP.Position).unit
				local LookVector2 = EhumRP.CFrame.LookVector
				local DotProduct = math.acos(LookVector2:Dot(LookVector1))

				table.insert(HitTable, v.Parent)

				if v.Parent:FindFirstChild("PB") then
					local BlockFX = Assets:WaitForChild("VFX")
						:WaitForChild("Combat")
						:WaitForChild("PBFX")
						:WaitForChild("HitFX")
						:Clone()
					BlockFX.Parent = EhumRP
					game.Debris:AddItem(BlockFX, 2)

					local AnimTracks = Hum:GetPlayingAnimationTracks()

					AttackEvent:FireClient(plr, "PB")

					task.spawn(function()
						Hum.AutoRotate = false
						for _, v1 in pairs(AnimTracks) do
							task.wait(0.02)
							v1:AdjustSpeed(0)
							task.delay(2.5, function()
								v1:AdjustSpeed(1)
								Hum.AutoRotate = true
							end)
						end
					end)

					local Sound = Assets:WaitForChild("Sounds"):WaitForChild("PB"):Clone()
					Sound.Parent = EhumRP
					Sound:Play()
					game.Debris:AddItem(Sound, 3)

					local DmgCounter =
						Assets:WaitForChild("VFX"):WaitForChild("Combat"):WaitForChild("DmgCounter"):Clone()
					DmgCounter.Parent = workspace
					DmgCounter.Position = EhumRP.Position
					DmgCounter.Counter.Number.Text = "Perfect Block"
					DmgCounter.Counter.Number.TextColor3 = Color3.fromRGB(85, 85, 255)
					DmgCounter.Counter.Number.TextStrokeColor3 = Color3.fromRGB(85, 0, 255)

					local goal = {}
					goal.TextColor3 = Color3.fromRGB(255, 255, 255)
					local info = TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.In, 0, true, 0)
					local tween = game:GetService("TweenService"):Create(DmgCounter.Counter.Number, info, goal)
					tween:Play()

					game.Debris:AddItem(DmgCounter, 0.4)

					local P1 = EhumRP.Position
					local P2 = EhumRP.Position + Vector3.new(math.random(-3, 3), math.random(2, 10), math.random(-3, 3))
					local P3 = P2 + Vector3.new(0, -15, 0)

					task.spawn(function()
						for i = 0, 1, 0.045 do
							local newpos = Curve(i, P1, P2, P3)
							DmgCounter.Position = newpos
							task.wait()
						end
					end)

					for _, v1 in pairs(BlockFX:GetChildren()) do
						local EmitCount = v1:GetAttribute("EmitCount")
						if EmitCount then
							v1:Emit(EmitCount)
						end
					end

					Values:CreateValue("BoolValue", Char, "StopStun", false, 2.5)
					return
				end

				if
					v.Parent:FindFirstChild("Blocking")
					and v.Parent:FindFirstChild("BlockHealth").Value <= 0
					and DotProduct > 1
				then
					local BlockFX = Assets:WaitForChild("VFX")
						:WaitForChild("Combat")
						:WaitForChild("GBFX")
						:WaitForChild("HitFX")
						:Clone()
					BlockFX.Parent = EhumRP
					game.Debris:AddItem(BlockFX, 2)

					for _, v1 in pairs(EhumRP.Parent:GetChildren()) do
						if v1.Name == "Blocking" then
							v1:Destroy()
						end
					end

					local AnimTracks = Ehum:GetPlayingAnimationTracks()

					for _, v1 in pairs(AnimTracks) do
						v1:Stop()
					end

					local GB = Ehum:LoadAnimation(Assets:WaitForChild("Animations"):WaitForChild("GB"))
					GB:Play()
					task.delay(1.5, function()
						GB:Stop()
					end)

					local Sound = Assets:WaitForChild("Sounds"):WaitForChild("BB"):Clone()
					Sound.Parent = EhumRP
					Sound:Play()
					game.Debris:AddItem(Sound, 3)

					local DmgCounter =
						Assets:WaitForChild("VFX"):WaitForChild("Combat"):WaitForChild("DmgCounter"):Clone()
					DmgCounter.Parent = workspace
					DmgCounter.Position = EhumRP.Position
					DmgCounter.Counter.Number.Text = "Broken"

					Values:CreateValue("BoolValue", EhumRP.Parent, "StopStun", false, 1.5)

					local goal = {}
					goal.TextColor3 = Color3.fromRGB(255, 255, 255)
					local info = TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.In, 0, true, 0)
					local tween = game:GetService("TweenService"):Create(DmgCounter.Counter.Number, info, goal)
					tween:Play()

					game.Debris:AddItem(DmgCounter, 0.4)

					local P1 = EhumRP.Position
					local P2 = EhumRP.Position + Vector3.new(math.random(-3, 3), math.random(2, 10), math.random(-3, 3))
					local P3 = P2 + Vector3.new(0, -15, 0)

					task.spawn(function()
						for i = 0, 1, 0.045 do
							local newpos = Curve(i, P1, P2, P3)
							DmgCounter.Position = newpos
							task.wait()
						end
					end)

					local BV = Instance.new("BodyVelocity")
					BV.Velocity = HumRP.CFrame.LookVector * 10
					BV.MaxForce = Vector3.new(15000, 15000, 15000)
					BV.Parent = EhumRP
					game.Debris:AddItem(BV, 0.2)

					local BV2 = Instance.new("BodyVelocity")
					BV2.Velocity = HumRP.CFrame.LookVector * 10
					BV2.MaxForce = Vector3.new(15000, 15000, 15000)
					BV2.Parent = HumRP
					game.Debris:AddItem(BV2, 0.2)

					for _, v1 in pairs(BlockFX:GetChildren()) do
						local EmitCount = v1:GetAttribute("EmitCount")
						if EmitCount then
							v1:Emit(EmitCount)
						end
					end
					return
				end

				if v.Parent:FindFirstChild("Blocking") and DotProduct > 1 then
					v.Parent:FindFirstChild("BlockHealth").Value -= 25
					print(v.Parent:FindFirstChild("BlockHealth").Value)
					local BlockFX = Assets:WaitForChild("VFX")
						:WaitForChild("Combat")
						:WaitForChild("BlockFX")
						:WaitForChild("HitFX")
						:Clone()
					BlockFX.Parent = EhumRP
					game.Debris:AddItem(BlockFX, 2)

					local Sound = Assets:WaitForChild("Sounds"):WaitForChild("Blocked"):Clone()
					Sound.Parent = EhumRP
					Sound:Play()
					game.Debris:AddItem(Sound, 1)

					local DmgCounter =
						Assets:WaitForChild("VFX"):WaitForChild("Combat"):WaitForChild("DmgCounter"):Clone()
					DmgCounter.Parent = workspace
					DmgCounter.Position = EhumRP.Position
					DmgCounter.Counter.Number.Text = "Blocked"
					DmgCounter.Counter.Number.TextColor3 = Color3.fromRGB(199, 199, 199)
					DmgCounter.Counter.Number.TextStrokeColor3 = Color3.fromRGB(152, 152, 152)

					local goal = {}
					goal.TextColor3 = Color3.fromRGB(255, 255, 255)
					local info = TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.In, 0, true, 0)
					local tween = game:GetService("TweenService"):Create(DmgCounter.Counter.Number, info, goal)
					tween:Play()

					game.Debris:AddItem(DmgCounter, 0.4)

					local P1 = EhumRP.Position
					local P2 = EhumRP.Position + Vector3.new(math.random(-3, 3), math.random(2, 10), math.random(-3, 3))
					local P3 = P2 + Vector3.new(0, -15, 0)

					task.spawn(function()
						for i = 0, 1, 0.045 do
							local newpos = Curve(i, P1, P2, P3)
							DmgCounter.Position = newpos
							task.wait()
						end
					end)

					local BV = Instance.new("BodyVelocity")
					BV.Velocity = HumRP.CFrame.LookVector * 10
					BV.MaxForce = Vector3.new(15000, 15000, 15000)
					BV.Parent = EhumRP
					game.Debris:AddItem(BV, 0.2)

					local BV2 = Instance.new("BodyVelocity")
					BV2.Velocity = HumRP.CFrame.LookVector * 10
					BV2.MaxForce = Vector3.new(15000, 15000, 15000)
					BV2.Parent = HumRP
					game.Debris:AddItem(BV2, 0.2)

					for _, v1 in pairs(BlockFX:GetChildren()) do
						local EmitCount = v1:GetAttribute("EmitCount")
						if EmitCount then
							v1:Emit(EmitCount)
						end
					end
					return
				end

				local DmgCounter = Assets:WaitForChild("VFX"):WaitForChild("Combat"):WaitForChild("DmgCounter"):Clone()
				DmgCounter.Parent = workspace
				DmgCounter.Position = EhumRP.Position
				DmgCounter.Counter.Number.Text = Damage

				local goal = {}
				goal.TextColor3 = Color3.fromRGB(255, 255, 255)
				local info = TweenInfo.new(0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.In, 0, true, 0)
				local tween = game:GetService("TweenService"):Create(DmgCounter.Counter.Number, info, goal)
				tween:Play()

				game.Debris:AddItem(DmgCounter, 0.4)

				local P1 = EhumRP.Position
				local P2 = EhumRP.Position + Vector3.new(math.random(-3, 3), math.random(2, 10), math.random(-3, 3))
				local P3 = P2 + Vector3.new(0, -15, 0)

				task.spawn(function()
					for i = 0, 1, 0.045 do
						local newpos = Curve(i, P1, P2, P3)
						DmgCounter.Position = newpos
						task.wait()
					end
				end)

				local EnemyAnim = Ehum:LoadAnimation(A2)
				EnemyAnim:Play()

				local Sound = Assets:WaitForChild("Sounds"):WaitForChild("PunchSound"):Clone()
				Sound.Parent = EhumRP
				Sound:Play()
				game.Debris:AddItem(Sound, 1)

				Values:CreateValue("BoolValue", EhumRP.Parent, "Stun", false, 0.6)

				if Last == false and Air == false then
					local BV = Instance.new("BodyVelocity")
					BV.Velocity = HumRP.CFrame.LookVector * 10
					BV.MaxForce = Vector3.new(15000, 15000, 15000)
					BV.Parent = EhumRP
					game.Debris:AddItem(BV, 0.2)
				elseif Last == true and Air == false then
					local BV = Instance.new("BodyVelocity")
					BV.Velocity = HumRP.CFrame.LookVector * 50
					BV.MaxForce = Vector3.new(55000, 55000, 55000)
					BV.Parent = EhumRP
					game.Debris:AddItem(BV, 0.4)

					local raycastParams = RaycastParams.new()
					raycastParams.FilterType = Enum.RaycastFilterType.Exclude
					raycastParams.FilterDescendantsInstances = { Char, EhumRP.Parent }
					raycastParams.IgnoreWater = true

					local Origin = EhumRP.Position
					local Direction = Vector3.new(0, -5, 0)

					local NewRay = workspace:Raycast(Origin, Direction, raycastParams)

					if NewRay then
						local SmokeParts = { "Left Leg", "Right Leg" }
						for _, _ in pairs(SmokeParts) do
							local trueColor = NewRay.Instance.Color
							local DirtParticle =
								Assets:WaitForChild("VFX"):WaitForChild("Combat"):WaitForChild("DirtParticle"):Clone()
							DirtParticle.Color = ColorSequence.new({
								ColorSequenceKeypoint.new(0, trueColor),
								ColorSequenceKeypoint.new(0.5, trueColor),
								ColorSequenceKeypoint.new(1, trueColor),
							})
							game.Debris:AddItem(DirtParticle, 1)

							if EhumRP.Parent:FindFirstChild(v) then
								local Slide = Assets:WaitForChild("Sounds"):WaitForChild("Slide"):Clone()
								Slide.Parent = EhumRP
								Slide:Play()
								game.Debris:AddItem(Slide, 1)
								DirtParticle.Parent = EhumRP.Parent:FindFirstChild(v)
								task.delay(0.5, function()
									DirtParticle.Enabled = false
								end)
							end
						end
					end
				end

				if Air == false then
					local BV2 = Instance.new("BodyVelocity")
					BV2.Velocity = HumRP.CFrame.LookVector * 10
					BV2.MaxForce = Vector3.new(15000, 15000, 15000)
					BV2.Parent = HumRP
					game.Debris:AddItem(BV2, 0.2)
				end

				--Hits Player forward in the air if its not the last hit
				if Air == true and Last == false then
					local BV = Instance.new("BodyVelocity")
					BV.Velocity = HumRP.CFrame.UpVector * 30
					BV.MaxForce = Vector3.new(55000, 55000, 55000)
					BV.Parent = EhumRP
					game.Debris:AddItem(BV, 0.4)
					local BV2 = Instance.new("BodyVelocity")
					BV2.Velocity = HumRP.CFrame.UpVector * 30
					BV2.MaxForce = Vector3.new(55000, 55000, 55000)
					BV2.Parent = HumRP
					game.Debris:AddItem(BV2, 0.4)

					Values:CreateValue("BoolValue", Char, "Using Move", false, 0.31)
					Values:CreateValue("BoolValue", EhumRP.Parent, "Stun", false, 0.9)

					task.delay(0.5, function()
						local BP = Instance.new("BodyPosition")
						BP.Position = EhumRP.Position
						BP.MaxForce = Vector3.new(200000, 200000, 200000)
						BP.P = 400
						BP.Name = "HoldBP"
						BP.Parent = EhumRP
						game.Debris:AddItem(BP, 3)

						local BP2 = Instance.new("BodyPosition")
						BP2.Position = HumRP.Position
						BP2.MaxForce = Vector3.new(200000, 200000, 200000)
						BP2.P = 400
						BP2.Name = "HoldBP"
						BP2.Parent = HumRP
						game.Debris:AddItem(BP2, 3)
					end)
				end

				--Sends opponent flying down and creates crater fx
				if Air == true and Last == true then
					local StartPos = (HumRP.CFrame.LookVector * 20) + HumRP.Position
					local Direction = Vector3.new(0, -40, 0)

					local RayParams = RaycastParams.new()
					RayParams.FilterDescendantsInstances = { Char, EhumRP.Parent }
					RayParams.FilterType = Enum.RaycastFilterType.Exclude
					RayParams.IgnoreWater = true

					local Raycast = workspace:Raycast(StartPos, Direction, RayParams)

					if Raycast then
						if EhumRP:FindFirstChild("HoldBP") then
							EhumRP:FindFirstChild("HoldBP"):Destroy()
						end
						if HumRP:FindFirstChild("HoldBP") then
							HumRP:FindFirstChild("HoldBP"):Destroy()
						end

						local function Lerp(i, A, B)
							local LerpThing = A:Lerp(B, i)
							return LerpThing
						end

						task.spawn(function()
							for i = 0, 1, 0.03 do
								local newpos = Lerp(i, EhumRP.Position, Raycast.Position + Vector3.new(0, 3, 0))
								EhumRP.Parent:MoveTo(newpos)
								task.wait()
							end
						end)

						task.delay(0.15, function()
							local NumOFParts = 14

							Values:CreateValue("BoolValue", Char, "BigShake", false, 0.1)

							local SmokeWave =
								Assets:WaitForChild("VFX"):WaitForChild("Combat"):WaitForChild("SmokeWave"):Clone()
							SmokeWave.Parent = workspace
							SmokeWave.Position = Raycast.Position + Vector3.new(0, 0.7, 0)
							game.Debris:AddItem(SmokeWave, 2)

							SmokeWave:WaitForChild("Attachment"):WaitForChild("Smoke").Color = ColorSequence.new({
								ColorSequenceKeypoint.new(0, Raycast.Instance.Color),
								ColorSequenceKeypoint.new(1, Raycast.Instance.Color),
							})

							SmokeWave:WaitForChild("Attachment"):WaitForChild("Rocks").Color = ColorSequence.new({
								ColorSequenceKeypoint.new(0, Raycast.Instance.Color),
								ColorSequenceKeypoint.new(1, Raycast.Instance.Color),
							})

							SmokeWave:WaitForChild("Attachment"):WaitForChild("Smoke"):Emit(50)
							SmokeWave:WaitForChild("Attachment"):WaitForChild("Rocks"):Emit(25)
							SmokeWave:WaitForChild("GroundSmash"):Play()

							local Distance = 7
							task.spawn(function()
								for i = 1, NumOFParts, 1 do
									local angle = i * 2 * math.pi / NumOFParts
									local PosOnCircle = Vector3.new(math.sin(angle), 0, math.cos(angle))
										+ EhumRP.Position
									local Part =
										Assets:WaitForChild("VFX"):WaitForChild("Combat"):WaitForChild("Rock"):Clone()
									Part.Parent = workspace
									Part.Position = PosOnCircle
									Part.CFrame = CFrame.lookAt(Part.Position, EhumRP.Position)
									Part.Position = (Part.CFrame.LookVector * -Distance)
										+ (Vector3.new(PosOnCircle.X, Raycast.Position.Y - 1.5, PosOnCircle.Z))
									Part.Orientation = Vector3.new(
										math.random(-360, 360),
										math.random(-360, 360),
										math.random(-360, 360)
									)
									Part.Color = Raycast.Instance.Color
									Part.Material = Raycast.Instance.Material
									local goal1 = {}
									goal1.Position = Part.Position + Vector3.new(0, 2, 0)
									local info1 = TweenInfo.new(0.2)
									local tween1 = game:GetService("TweenService"):Create(Part, info1, goal1)
									tween1:Play()

									task.delay(2, function()
										local goal2 = {}
										goal2.Position = Part.Position + Vector3.new(0, -2, 0)
										local info2 = TweenInfo.new(1)
										local tween2 = game:GetService("TweenService"):Create(Part, info2, goal2)
										tween2:Play()
									end)

									game.Debris:AddItem(Part, 3)
								end
							end)
						end)
					end
				end

				local HitFX = Assets:WaitForChild("VFX")
					:WaitForChild("Combat")
					:WaitForChild("HitFX")
					:WaitForChild("HitFX")
					:Clone()
				HitFX.Parent = EhumRP
				game.Debris:AddItem(HitFX, 1)

				for _, v1 in pairs(HitFX:GetChildren()) do
					if v1.Name == "Crescents" then
						v1:Emit(5)
					end
					if v1.Name == "Gradient" then
						v1:Emit(1)
					end
					if v1.Name == "Shards" then
						v1:Emit(10)
					end
					if v1.Name == "Specs" then
						v1:Emit(10)
					end
				end

				Ehum:TakeDamage(Damage)
			end
		end

		task.delay(0.1, function()
			Region = nil
		end)
	end

	local function Animation()
		if A1 ~= nil then
			Hum:LoadAnimation(A1):Play()
		end
	end

	if Type == "Animation" and A1 ~= nil then
		Animation()
		Values:CreateValue("BoolValue", Char, "Swinging", false, 0.2)
	end

	if Type == "Hitbox" then
		Hitbox()
	end
end)
