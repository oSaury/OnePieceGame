--/Services

--/Modules
local module = {}

--/Variables
local attackRemote = game.ReplicatedStorage.Remotes.DemonFruits[string.split(script.Name, "VFX")[1]]

--// Wunbo Variables
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Modules = ReplicatedStorage.Modules
local Debris = require(Modules.Misc.Debris)
local Assets = ReplicatedStorage.Assets
local VFXEffects = Assets.VFXEffects
local World = game.Workspace:WaitForChild("World")
local Visual = World.Visual
local Live = World.Live
local SoundManager = require(Modules.Manager.SoundManager)

function module.Move1(Data)
	local Character = Data.Character
	local Root = Character:FindFirstChild("HumanoidRootPart")

	--[[ Play Sound ]]
	--
	SoundManager:Play(Root, "GomuSFX", { Volume = 2, TimePosition = 1 })

	task.wait(0.1)

	local Arm = Character["Right Arm"]
	local GomuArm = Arm:Clone()
	GomuArm.CanCollide = false
	GomuArm.Anchored = false
	GomuArm.Massless = true

	--[[ Weld GomuArm to CharacterArm ]]
	--
	local Motor6D = Instance.new("Motor6D")
	Motor6D.Part0 = Arm
	Motor6D.Part1 = GomuArm
	Motor6D.Parent = Arm
	GomuArm.Parent = Visual

	--[[ Arm Tweening Out ]]
	--
	local LENGTH = 50
	local StartSize = GomuArm.Size
	local GoalSize = Vector3.new(GomuArm.Size.X, LENGTH, GomuArm.Size.Z)

	local StartCFrame = Motor6D.Part0.CFrame:Inverse() * (Arm.CFrame * CFrame.new(0, 0, 0))
	local GoalCFrame = Motor6D.Part0.CFrame:Inverse() * (Arm.CFrame * CFrame.new(0, -LENGTH / 1.925, 0))

	--[[ Tween the size Outwards of the Arm ]]
	--
	local tween = TweenService:Create(
		GomuArm,
		TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{ ["CFrame"] = GoalCFrame, ["Size"] = GoalSize }
	)
	tween:Play()
	tween:Destroy()

	--[[ Tween the CFrame of the Arm according to Arm Size ]]
	--
	local tween1 = TweenService:Create(
		Motor6D,
		TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{ ["C0"] = GoalCFrame }
	)
	tween1:Play()
	tween1:Destroy()

	--[[ Effects ]]
	--

	--[[ Shockwave 5 ]]
	--
	local shockwave5 = VFXEffects.Mesh.shockwave5:Clone()
	shockwave5.Transparency = 0
	shockwave5.Material = "Neon"
	shockwave5.Color = Color3.fromRGB(255, 255, 255)
	shockwave5.Size = Vector3.new(5, 6, 5)
	shockwave5.CFrame = GomuArm.CFrame * CFrame.new(0, -5, 0)
	shockwave5.Parent = Visual
	local tween2 =
		TweenService:Create(shockwave5, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			["CFrame"] = shockwave5.CFrame * CFrame.new(0, -20, 0) * CFrame.fromEulerAnglesXYZ(0, math.rad(90), 0),
			["Size"] = Vector3.new(7, 50, 7),
			["Transparency"] = 1,
		})
	tween2:Play()
	tween2:Destroy()
	Debris:AddItem(shockwave5, 0.2)

	--[[ HollowCylinder ]]
	--
	local HollowCylinder = VFXEffects.Mesh.HollowCylinder:Clone()
	HollowCylinder.Size = Vector3.new(5, 5, 5)
	HollowCylinder.CFrame = GomuArm.CFrame * CFrame.new(0, -5, 0)
	HollowCylinder.Parent = Visual
	local tween3 =
		TweenService:Create(HollowCylinder, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			["CFrame"] = HollowCylinder.CFrame * CFrame.new(0, -15, 0) * CFrame.fromEulerAnglesXYZ(0, math.rad(270), 0),
			["Size"] = Vector3.new(8, 50, 8),
			["Transparency"] = 1,
		})
	tween3:Play()
	tween3:Destroy()
	Debris:AddItem(HollowCylinder, 0.2)

	--[[ WindMesh ]]
	--
	local WindMesh = VFXEffects.Mesh.WindMesh:Clone()
	WindMesh.Size = Vector3.new(2, 15, 15)
	WindMesh.CFrame = Root.CFrame * CFrame.new(0, 0, -15) * CFrame.fromEulerAnglesXYZ(0, math.rad(90), 0)
	WindMesh.Parent = Visual
	local tween5 = TweenService:Create(WindMesh, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		["CFrame"] = WindMesh.CFrame * CFrame.new(-15, 0, 0) * CFrame.fromEulerAnglesXYZ(math.rad(270), 0, 0),
		["Size"] = Vector3.new(0, 15, 15),
		["Transparency"] = 1,
	})
	tween5:Play()
	tween5:Destroy()
	Debris:AddItem(WindMesh, 0.25)

	--[[ Ring ]]
	--
	local Ring = VFXEffects.Mesh.RingInnit:Clone()
	Ring.Size = Vector3.new(5, 0.05, 5)
	Ring.CFrame = Arm.CFrame * CFrame.new(0, -10, 0)
	Ring.Parent = Visual
	local tween4 = TweenService:Create(
		Ring,
		TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{ ["CFrame"] = Ring.CFrame * CFrame.new(0, 10, 0), ["Size"] = Vector3.new(5, 0, 5), ["Transparency"] = 1 }
	)
	tween4:Play()
	tween4:Destroy()
	Debris:AddItem(Ring, 0.25)

	task.wait(0.2)
	--[[ Play Sound ]]
	--
	SoundManager:Play(Root, "GomuSlap", { Volume = 1, TimePosition = 0.1 })

	--[[ Return Arm size Back to Normal ]]
	--
	local tween0 = TweenService:Create(
		GomuArm,
		TweenInfo.new(0.2, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out),
		{ ["CFrame"] = Arm.CFrame, ["Size"] = StartSize }
	)
	tween0:Play()
	tween0:Destroy()

	--[[ Tween the CFrame Arm Back ]]
	--
	local tween6 = TweenService:Create(
		Motor6D,
		TweenInfo.new(0.2, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out),
		{ ["C0"] = StartCFrame }
	)
	tween6:Play()
	tween6:Destroy()

	wait(0.2)

	--[[ WindMesh ]]
	--
	local WindMesh1 = VFXEffects.Mesh.WindMesh:Clone()
	WindMesh1.Size = Vector3.new(0.1, 3, 3)
	WindMesh1.Transparency = 0.5
	WindMesh1.CFrame = Arm.CFrame * CFrame.fromEulerAnglesXYZ(0, 0, math.rad(90))
	WindMesh1.Parent = Visual

	local tween7 = TweenService:Create(WindMesh1, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		["CFrame"] = WindMesh1.CFrame * CFrame.new(2, 0, 0) * CFrame.fromEulerAnglesXYZ(math.rad(90), 0, 0),
		["Size"] = Vector3.new(0.1, 3, 3),
		["Transparency"] = 1,
	})
	tween7:Play()
	tween7:Destroy()
	Debris:AddItem(WindMesh1, 0.5)

	task.wait(0.2)
	GomuArm:Destroy()
end

function module.Move2(Data)
	local Character = Data.Character
	local Root = Character:FindFirstChild("HumanoidRootPart")

	--[[ Play Sound ]]
	--
	SoundManager:Play(Root, "GomuSFX", { Volume = 2, TimePosition = 0.7 })

	--wait(0.25)

	for i = 1, 2 do
		local Arm
		if i == 1 then
			Arm = Character["Right Arm"]
		else
			Arm = Character["Left Arm"]
		end
		coroutine.wrap(function()
			local GomuArm = Arm:Clone()
			GomuArm.CanCollide = false
			GomuArm.Anchored = false
			GomuArm.Massless = true

			--[[ Weld GomuArm to CharacterArm ]]
			--
			local Motor6D = Instance.new("Motor6D")
			Motor6D.Part0 = Arm
			Motor6D.Part1 = GomuArm
			Motor6D.Parent = Arm
			GomuArm.Parent = Visual

			--[[ Arm Tweening Out ]]
			--
			local LENGTH = 50
			local StartSize = GomuArm.Size
			local GoalSize = Vector3.new(GomuArm.Size.X, LENGTH, GomuArm.Size.Z)

			local StartCFrame = Motor6D.Part0.CFrame:inverse() * (Arm.CFrame * CFrame.new(0, 0, 0))
			local GoalCFrame = Motor6D.Part0.CFrame:inverse() * (Arm.CFrame * CFrame.new(0, -LENGTH / 1.925, 0))

			--[[ Tween the size Outwards of the Arm ]]
			--
			local tween = TweenService:Create(
				GomuArm,
				TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{ ["CFrame"] = GoalCFrame, ["Size"] = GoalSize }
			)
			tween:Play()
			tween:Destroy()

			--[[ Tween the CFrame of the Arm according to Arm Size ]]
			--
			local tween1 = TweenService:Create(
				Motor6D,
				TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{ ["C0"] = GoalCFrame }
			)
			tween1:Play()
			tween1:Destroy()

			wait(0.2)
			--[[ Return Arm size Back to Normal ]]
			--
			local tween2 = TweenService:Create(
				GomuArm,
				TweenInfo.new(0.2, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out),
				{ ["CFrame"] = Arm.CFrame, ["Size"] = StartSize }
			)
			tween2:Play()
			tween2:Destroy()

			--[[ Tween the CFrame Arm Back ]]
			--
			local tween3 = TweenService:Create(
				Motor6D,
				TweenInfo.new(0.2, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out),
				{ ["C0"] = StartCFrame }
			)
			tween3:Play()
			tween3:Destroy()

			task.wait(0.2)

			--[[ WindMesh ]]
			--
			local WindMesh = VFXEffects.Mesh.WindMesh:Clone()
			WindMesh.Size = Vector3.new(0.1, 3, 3)
			WindMesh.Transparency = 0.5
			WindMesh.CFrame = Arm.CFrame * CFrame.fromEulerAnglesXYZ(0, 0, math.rad(90))
			WindMesh.Parent = Visual

			local tween4 =
				TweenService:Create(WindMesh, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					["CFrame"] = WindMesh.CFrame * CFrame.new(2, 0, 0) * CFrame.fromEulerAnglesXYZ(math.rad(90), 0, 0),
					["Size"] = Vector3.new(0.1, 3, 3),
					["Transparency"] = 1,
				})
			tween4:Play()
			tween4:Destroy()
			Debris:AddItem(WindMesh, 0.5)

			task.wait(0.2)
			GomuArm:Destroy()
		end)()
	end
	task.wait(0.6)

	--[[ Now ReLEASE !!! ]]
	--
	for i = 1, 2 do
		local Arm
		if i == 1 then
			Arm = Character["Right Arm"]
		else
			Arm = Character["Left Arm"]
		end
		coroutine.wrap(function()
			local GomuArm = Arm:Clone()
			GomuArm.CanCollide = false
			GomuArm.Anchored = false
			GomuArm.Massless = true

			--[[ Weld GomuArm to CharacterArm ]]
			--
			local Motor6D = Instance.new("Motor6D")
			Motor6D.Part0 = Arm
			Motor6D.Part1 = GomuArm
			Motor6D.Parent = Arm
			GomuArm.Parent = Visual

			--[[ Arm Tweening Out ]]
			--
			local LENGTH = 50
			local StartSize = GomuArm.Size
			local GoalSize = Vector3.new(GomuArm.Size.X, LENGTH, GomuArm.Size.Z)

			local StartCFrame = Motor6D.Part0.CFrame:inverse() * (Arm.CFrame * CFrame.new(0, 0, 0))
			local GoalCFrame = Motor6D.Part0.CFrame:inverse() * (Arm.CFrame * CFrame.new(0, -LENGTH / 1.925, 0))

			--[[ Tween the size Outwards of the Arm ]]
			--
			local tween = TweenService:Create(
				GomuArm,
				TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{ ["CFrame"] = GoalCFrame, ["Size"] = GoalSize }
			)
			tween:Play()
			tween:Destroy()

			--[[ Tween the CFrame of the Arm according to Arm Size ]]
			--
			local tween1 = TweenService:Create(
				Motor6D,
				TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{ ["C0"] = GoalCFrame }
			)
			tween1:Play()
			tween1:Destroy()

			--[[ Side Shockwaves ]]
			--
			for j = 1, 2 do
				local Offset = 5
				local Rot = 288
				local GoalSize1 = Vector3.new(35, 0.05, 7.5)
				if j ~= 1 then
					Offset = Offset * -1
					Rot = 252
				end

				local SideWind = VFXEffects.Mesh.SideWind:Clone()
				SideWind.Size = Vector3.new(8, 0.05, 2)
				SideWind.Transparency = 0.75
				SideWind.CFrame = Root.CFrame
					* CFrame.new(Offset, -0.5, 0)
					* CFrame.fromEulerAnglesXYZ(math.rad(90), math.rad(180), math.rad(Rot))
				SideWind.Parent = Visual

				--[[ Tween the Side Shockwaves ]]
				--
				local tween2 = TweenService:Create(
					SideWind,
					TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{ ["CFrame"] = SideWind.CFrame * CFrame.new(-10, 0, 0), ["Size"] = GoalSize1, ["Transparency"] = 1 }
				)
				tween2:Play()
				tween2:Destroy()

				Debris:AddItem(SideWind, 0.25)
			end

			--[[ Effects ]]
			--

			--[[ Shockwave 5 ]]
			--
			local shockwave5 = VFXEffects.Mesh.shockwave5:Clone()
			shockwave5.Transparency = 0
			shockwave5.Material = "Neon"
			shockwave5.Color = Color3.fromRGB(255, 255, 255)
			shockwave5.Size = Vector3.new(5, 6, 5)
			shockwave5.CFrame = GomuArm.CFrame * CFrame.new(0, -5, 0)
			shockwave5.Parent = Visual
			local tween2 =
				TweenService:Create(shockwave5, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					["CFrame"] = shockwave5.CFrame
						* CFrame.new(0, -20, 0)
						* CFrame.fromEulerAnglesXYZ(0, math.rad(90), 0),
					["Size"] = Vector3.new(7, 50, 7),
					["Transparency"] = 1,
				})
			tween2:Play()
			tween2:Destroy()
			Debris:AddItem(shockwave5, 0.2)

			--[[ HollowCylinder ]]
			--
			local HollowCylinder = VFXEffects.Mesh.HollowCylinder:Clone()
			HollowCylinder.Size = Vector3.new(5, 5, 5)
			HollowCylinder.CFrame = GomuArm.CFrame * CFrame.new(0, -5, 0)
			HollowCylinder.Parent = Visual
			local tween3 = TweenService:Create(
				HollowCylinder,
				TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{
					["CFrame"] = HollowCylinder.CFrame
						* CFrame.new(0, -15, 0)
						* CFrame.fromEulerAnglesXYZ(0, math.rad(270), 0),
					["Size"] = Vector3.new(8, 50, 8),
					["Transparency"] = 1,
				}
			)
			tween3:Play()
			tween3:Destroy()
			Debris:AddItem(HollowCylinder, 0.2)

			--[[ WindMesh ]]
			--
			local WindMesh = VFXEffects.Mesh.WindMesh:Clone()
			WindMesh.Size = Vector3.new(2, 15, 15)
			WindMesh.Transparency = 0.5
			WindMesh.CFrame = Root.CFrame * CFrame.new(0, 0, -15) * CFrame.fromEulerAnglesXYZ(0, math.rad(90), 0)
			WindMesh.Parent = Visual
			local tween4 =
				TweenService:Create(WindMesh, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					["CFrame"] = WindMesh.CFrame
						* CFrame.new(-15, 0, 0)
						* CFrame.fromEulerAnglesXYZ(math.rad(270), 0, 0),
					["Size"] = Vector3.new(0, 15, 15),
					["Transparency"] = 1,
				})
			tween4:Play()
			tween4:Destroy()
			Debris:AddItem(WindMesh, 0.25)

			--[[ Ring ]]
			--
			local Ring = VFXEffects.Mesh.RingInnit:Clone()
			Ring.Size = Vector3.new(5, 0.05, 5)
			Ring.CFrame = Arm.CFrame * CFrame.new(0, -10, 0)
			Ring.Parent = Visual
			local tween5 =
				TweenService:Create(Ring, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					["CFrame"] = Ring.CFrame * CFrame.new(0, 10, 0),
					["Size"] = Vector3.new(5, 0, 5),
					["Transparency"] = 1,
				})
			tween5:Play()
			tween5:Destroy()
			Debris:AddItem(Ring, 0.25)

			if i == 1 then
				--[[ Play Sound ]]
				--
				SoundManager:Play(Root, "GomuSlap", { Volume = 1, TimePosition = 0.1 })
			end

			wait(0.2)

			--[[ Return Arm size Back to Normal ]]
			--
			local tween6 = TweenService:Create(
				GomuArm,
				TweenInfo.new(0.2, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out),
				{ ["CFrame"] = Arm.CFrame, ["Size"] = StartSize }
			)
			tween6:Play()
			tween6:Destroy()

			--[[ Tween the CFrame Arm Back ]]
			--
			local tween7 = TweenService:Create(
				Motor6D,
				TweenInfo.new(0.2, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out),
				{ ["C0"] = StartCFrame }
			)
			tween7:Play()
			tween7:Destroy()

			wait(0.2)

			--[[ WindMesh ]]
			--
			local WindMesh1 = VFXEffects.Mesh.WindMesh:Clone()
			WindMesh1.Size = Vector3.new(0.1, 3, 3)
			WindMesh1.Transparency = 0.5
			WindMesh1.CFrame = Arm.CFrame * CFrame.fromEulerAnglesXYZ(0, 0, math.rad(90))
			WindMesh1.Parent = Visual

			local tween8 =
				TweenService:Create(WindMesh1, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					["CFrame"] = WindMesh1.CFrame * CFrame.new(2, 0, 0) * CFrame.fromEulerAnglesXYZ(math.rad(90), 0, 0),
					["Size"] = Vector3.new(0.1, 3, 3),
					["Transparency"] = 1,
				})
			tween8:Play()
			tween8:Destroy()
			Debris:AddItem(WindMesh1, 0.5)

			task.wait(0.2)
			GomuArm:Destroy()
		end)()
	end
	--[[ Block becomes Cylinder ]]
	--
	local Block = VFXEffects.Part.Block:Clone()
	Block.BrickColor = BrickColor.new("Institutional white")
	Block.Shape = "Cylinder"
	Block.Transparency = 0
	Block.Material = "Neon"
	Block.Size = Vector3.new(50, 5, 5)
	Block.CFrame = Root.CFrame * CFrame.new(0, 0, -15) * CFrame.fromEulerAnglesXYZ(0, math.rad(90), math.rad(180))
	Block.Parent = Visual

	local tween = TweenService:Create(
		Block,
		TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{ ["Size"] = Vector3.new(50, 0, 0) }
	)
	tween:Play()
	tween:Destroy()
	Debris:AddItem(Block, 0.2)

	--[[ shockwave5 ]]
	--
	local shockwave5 = VFXEffects.Mesh.shockwave5:Clone()
	shockwave5.CFrame = Root.CFrame * CFrame.fromEulerAnglesXYZ(math.rad(90), 0, 0)
	shockwave5.Size = Vector3.new(25, 50, 25)
	shockwave5.Transparency = 0
	shockwave5.Material = "Neon"
	shockwave5.BrickColor = BrickColor.new("Institutional white")
	shockwave5.Parent = Visual

	local tween1 =
		TweenService:Create(shockwave5, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			["CFrame"] = shockwave5.CFrame * CFrame.new(0, 10, 0) * CFrame.fromEulerAnglesXYZ(0, 5, 0),
			["Size"] = Vector3.new(0, 75, 0),
		})
	tween1:Play()
	tween1:Destroy()
	Debris:AddItem(shockwave5, 0.2)

	--[[ Terrain Rocks on Ground ]]
	--
	local RootPos = Root.CFrame
	for loops = 1, 2 do
		coroutine.wrap(function()
			local OffsetX = 10
			--[[ Change Offset. Two Rocks on Both Sides. ]]
			--
			if loops == 2 then
				OffsetX = -10
			end

			for i = 1, 10 do
				--[[ Raycast ]]
				--
				local StartPosition = (RootPos * CFrame.new(OffsetX / i, 0, -i * 5)).Position
				local EndPosition = CFrame.new(StartPosition).UpVector * -10

				local RayData = RaycastParams.new()
				RayData.FilterDescendantsInstances = { Character, Live, Visual } or Visual
				RayData.FilterType = Enum.RaycastFilterType.Exclude
				RayData.IgnoreWater = true

				local ray = game.Workspace:Raycast(StartPosition, EndPosition, RayData)
				if ray then
					local partHit, pos = ray.Instance or nil, ray.Position or nil
					if partHit then
						local Block1 = VFXEffects.Part.Block:Clone()

						local RATE = 10
						local X, Y, Z = 0.25 + (i / RATE), 0.25 + (i / RATE), 0.25 + (i / RATE)
						Block1.Size = Vector3.new(X, Y, Z)

						Block1.Position = pos
						Block1.Anchored = true
						Block1.Rotation =
							Vector3.new(math.random(-360, 360), math.random(-360, 360), math.random(-360, 360))
						Block1.Transparency = 0
						Block1.Color = partHit.Color
						Block1.Material = partHit.Material
						Block1.Parent = Visual
						Debris:AddItem(Block1, 0.25)
					end
				end
				game:GetService("RunService").Heartbeat:Wait()
			end
		end)()
	end

	task.wait(0.4)
	--[[ Move Towards Goal ]]
	--
	local BodyPosition = Instance.new("BodyPosition")
	BodyPosition.MaxForce = Vector3.new(1e5, 1e5, 1e5)
	BodyPosition.P = 200
	BodyPosition.D = 20
	BodyPosition.Parent = Root
	BodyPosition.Position = (Root.CFrame * CFrame.new(0, 0, 10)).Position
	Debris:AddItem(BodyPosition, 0.1)
end

function module.Move3(Data)
	local Character = Data.Character
	local Root = Character:FindFirstChild("HumanoidRootPart")

	--[[ Play Sound ]]
	--
	SoundManager:Play(Root, "GomuSFX", { Volume = 2, TimePosition = 0.55 })

	--[[ Effect When Ball Hit Ground ]]
	--
	local function GroundTouched(RootPos, PartHit)
		--[[ Rocks xD ]]
		--
		local Rocks = VFXEffects.Particle.ParticleAttatchments.Rocks:Clone()
		Rocks.Rocks.Color = ColorSequence.new(PartHit.Color)
		Rocks.Rocks.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.2), NumberSequenceKeypoint.new(1, 0) })
		Rocks.Rocks.Drag = 5
		Rocks.Rocks.Rate = 100
		Rocks.Rocks.Acceleration = Vector3.new(0, -100, 0)
		Rocks.Rocks.Lifetime = NumberRange.new(3)
		Rocks.Rocks.Speed = NumberRange.new(100, 200)
		Rocks.Parent = Root
		Rocks.Rocks:Emit(100)
		Debris:AddItem(Rocks, 4)

		local Smoke = VFXEffects.Particle.Smoke:Clone()
		Smoke.Smoke.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 5), NumberSequenceKeypoint.new(1, 0) })
		Smoke.Smoke.Color = ColorSequence.new(PartHit.Color)
		Smoke.Smoke.Acceleration = Vector3.new(0, -15, 0)
		Smoke.Smoke.Drag = 5
		Smoke.Smoke.Lifetime = NumberRange.new(2)
		Smoke.Smoke:Emit(100)
		Smoke.Smoke.Speed = NumberRange.new(100)
		Smoke.Position = RootPos
		Smoke.Parent = Visual
		Debris:AddItem(Smoke, 3)

		RootPos = Root.Position
		local Offset = 20
		--[[ Flying Debris Rock ]]
		--
		for i = 1, 2 do
			local StartPosition = (Vector3.new(math.sin(360 * i) * Offset, 0, math.cos(360 * i) * Offset) + RootPos)
			local EndPosition = CFrame.new(StartPosition).UpVector * -10

			local RayData = RaycastParams.new()
			RayData.FilterDescendantsInstances = { Character, Live, Visual } or Visual
			RayData.FilterType = Enum.RaycastFilterType.Exclude
			RayData.IgnoreWater = true

			local ray = game.Workspace:Raycast(StartPosition, EndPosition, RayData)
			if ray then
				local partHit, pos = ray.Instance or nil, ray.Position or nil
				if partHit then
					local Block = VFXEffects.Part.Block:Clone()

					local X, Y, Z = math.random(1, 2), math.random(1, 2), math.random(1, 2)
					Block.Size = Vector3.new(X, Y, Z)

					Block.Position = pos
					Block.Rotation = Vector3.new(math.random(-360, 360), math.random(-360, 360), math.random(-360, 360))
					Block.Transparency = 0
					Block.Color = partHit.Color
					Block.Material = partHit.Material
					Block.Anchored = false
					Block.CanCollide = true
					Block.Parent = Visual

					local BodyVelocity = Instance.new("BodyVelocity")
					BodyVelocity.MaxForce = Vector3.new(1000000, 1000000, 1000000)
					BodyVelocity.Velocity = Vector3.new(math.random(-80, 80), math.random(50, 60), math.random(-80, 80))
						* (i * 0.65)
					BodyVelocity.P = 100000
					Block.Velocity = Vector3.new(math.random(-80, 80), math.random(50, 60), math.random(-80, 80))
						* (i * 0.65)
					BodyVelocity.Parent = Block

					Debris:AddItem(BodyVelocity, 0.05)
					Debris:AddItem(Block, 2)
				end
			end
			wait()
		end

		--[[ Smoke Effect on Ground ]]
		--
		local Smoke1 = VFXEffects.Particle.Smoke:Clone()
		Smoke1.Smoke.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 5) })
		Smoke1.Smoke.Drag = 5
		Smoke1.Smoke.Lifetime = NumberRange.new(0.75, 1)
		Smoke1.Smoke.Rate = 250
		Smoke1.Smoke:Emit(5)
		Smoke1.Smoke.Speed = NumberRange.new(75)
		Smoke1.Smoke.SpreadAngle = Vector2.new(1, 180)
		Smoke1.Smoke.Enabled = true
		Smoke1.CFrame = Root.CFrame * CFrame.new(0, -2.5, 0) * CFrame.fromEulerAnglesXYZ(math.rad(90), 0, 0)
		Smoke1.Parent = Visual
		--[[ Set Smoke Properties ]]
		--
		Smoke1.Smoke.Color = ColorSequence.new(PartHit.Color)
		if PartHit == nil then
			Smoke1:Destroy()
		end
		coroutine.wrap(function()
			for _ = 1, 2 do
				Smoke1.Smoke:Emit(50)
				wait(0.1)
			end
			Smoke1.Smoke.Enabled = false
		end)()
		Debris:AddItem(Smoke1, 2.5)

		--[[ Terrain Rocks on Ground ]]
		--
		local GroundRocks = {}
		for i = 1, 15 do
			--[[ Raycast ]]
			--
			local StartPosition = (Vector3.new(math.sin(360 * i) * Offset, 0, math.cos(360 * i) * Offset) + RootPos)
			local EndPosition = CFrame.new(StartPosition).UpVector * -10

			local RayData = RaycastParams.new()
			RayData.FilterDescendantsInstances = { Character, Live, Visual } or Visual
			RayData.FilterType = Enum.RaycastFilterType.Exclude
			RayData.IgnoreWater = true

			local ray = game.Workspace:Raycast(StartPosition, EndPosition, RayData)
			if ray then
				local partHit, pos = ray.Instance or nil, ray.Position or nil
				if partHit then
					local Block = VFXEffects.Part.Block:Clone()

					local X, Y, Z = 2, 2, 2
					Block.Size = Vector3.new(X, Y, Z)

					Block.Position = pos
					Block.Anchored = true
					Block.Rotation = Vector3.new(math.random(-360, 360), math.random(-360, 360), math.random(-360, 360))
					Block.Transparency = 0
					Block.Color = partHit.Color
					Block.Material = partHit.Material
					Block.Parent = Visual
					GroundRocks[i] = Block
					Debris:AddItem(Block, 2)
				end
			end
		end

		--[[ Delete Rocks ]]
		--
		task.wait(1.5)
		if #GroundRocks > 0 then
			for _, v in ipairs(GroundRocks) do
				v.Anchored = false
			end
		end
	end

	local Arm = Character["Right Leg"]
	local GomuArm = Arm:Clone()
	GomuArm.CanCollide = false
	GomuArm.Anchored = false
	GomuArm.Massless = true

	--[[ Weld GomuArm to CharacterArm ]]
	--
	local Motor6D = Instance.new("Motor6D")
	Motor6D.Part0 = Arm
	Motor6D.Part1 = GomuArm
	Motor6D.Parent = Arm
	GomuArm.Parent = Visual

	--[[ Arm Tweening Out ]]
	--
	local LENGTH = 50
	local StartSize = GomuArm.Size
	local GoalSize = Vector3.new(GomuArm.Size.X, LENGTH, GomuArm.Size.Z)

	local StartCFrame = Motor6D.Part0.CFrame:Inverse() * (Arm.CFrame * CFrame.new(0, 0, 0))
	local GoalCFrame = Motor6D.Part0.CFrame:Inverse() * (Arm.CFrame * CFrame.new(0, -LENGTH / 1.925, 0))

	--[[ Tween the size Outwards of the Arm ]]
	--
	local tween = TweenService:Create(
		GomuArm,
		TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{ ["CFrame"] = GoalCFrame, ["Size"] = GoalSize }
	)
	tween:Play()
	tween:Destroy()

	--[[ Tween the CFrame of the Arm according to Arm Size ]]
	--
	local tween1 = TweenService:Create(
		Motor6D,
		TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{ ["C0"] = GoalCFrame }
	)
	tween1:Play()
	tween1:Destroy()

	--[[ Effects ]]
	--
	task.wait(0.05)

	--[[ Shockwave 5 ]]
	--
	local shockwave5 = VFXEffects.Mesh.shockwave5:Clone()
	shockwave5.Transparency = 0
	shockwave5.Material = "Neon"
	shockwave5.Color = Color3.fromRGB(255, 255, 255)
	shockwave5.Size = Vector3.new(5, 6, 5)
	shockwave5.CFrame = GomuArm.CFrame * CFrame.new(0, -5, 0)
	shockwave5.Parent = Visual
	local tween2 =
		TweenService:Create(shockwave5, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			["CFrame"] = shockwave5.CFrame * CFrame.new(0, -20, 0) * CFrame.fromEulerAnglesXYZ(0, math.rad(90), 0),
			["Size"] = Vector3.new(7, 50, 7),
			["Transparency"] = 1,
		})
	tween2:Play()
	tween2:Destroy()
	Debris:AddItem(shockwave5, 0.2)

	--[[ HollowCylinder ]]
	--
	local HollowCylinder = VFXEffects.Mesh.HollowCylinder:Clone()
	HollowCylinder.Size = Vector3.new(5, 5, 5)
	HollowCylinder.CFrame = GomuArm.CFrame * CFrame.new(0, -5, 0)
	HollowCylinder.Parent = Visual
	local tween3 =
		TweenService:Create(HollowCylinder, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			["CFrame"] = HollowCylinder.CFrame * CFrame.new(0, -15, 0) * CFrame.fromEulerAnglesXYZ(0, math.rad(270), 0),
			["Size"] = Vector3.new(8, 50, 8),
			["Transparency"] = 1,
		})
	tween3:Play()
	tween3:Destroy()
	Debris:AddItem(HollowCylinder, 0.2)

	--[[ WindMesh ]]
	--
	local WindMesh = VFXEffects.Mesh.WindMesh:Clone()
	WindMesh.Size = Vector3.new(2, 15, 15)
	WindMesh.CFrame = Root.CFrame * CFrame.new(0, 10, 0) * CFrame.fromEulerAnglesXYZ(0, 0, math.rad(90))
	WindMesh.Parent = Visual
	local tween4 = TweenService:Create(WindMesh, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		["CFrame"] = WindMesh.CFrame * CFrame.new(-5, 0, 0) * CFrame.fromEulerAnglesXYZ(math.rad(270), 0, 0),
		["Size"] = Vector3.new(0, 15, 15),
		["Transparency"] = 1,
	})
	tween4:Play()
	tween4:Destroy()
	Debris:AddItem(WindMesh, 0.25)

	--[[ Ring ]]
	--
	local Ring = VFXEffects.Mesh.RingInnit:Clone()
	Ring.Size = Vector3.new(5, 2, 5)
	Ring.CFrame = Arm.CFrame * CFrame.new(0, -10, 0)
	Ring.Parent = Visual
	local tween5 = TweenService:Create(
		Ring,
		TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{ ["CFrame"] = Ring.CFrame * CFrame.new(0, 10, 0), ["Size"] = Vector3.new(5, 0, 5), ["Transparency"] = 1 }
	)
	tween5:Play()
	tween5:Destroy()
	Debris:AddItem(Ring, 0.25)

	task.wait(0.2)
	--[[ Return Arm size Back to Normal ]]
	--
	local tween6 = TweenService:Create(
		GomuArm,
		TweenInfo.new(0.2, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out),
		{ ["CFrame"] = Arm.CFrame, ["Size"] = StartSize }
	)
	tween6:Play()
	tween6:Destroy()

	--[[ Tween the CFrame Arm Back ]]
	--
	local tween7 = TweenService:Create(
		Motor6D,
		TweenInfo.new(0.2, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out),
		{ ["C0"] = StartCFrame }
	)
	tween7:Play()
	tween7:Destroy()

	--[[ Lines in Front/Gravity Force ]]
	--
	coroutine.wrap(function()
		local WIDTH, LENGTH1 = 0.5, 20
		for j = 1, 10 do
			for i = 1, 5 do
				local Block = VFXEffects.Part.Sphere:Clone()
				Block.Transparency = 0
				Block.Mesh.Scale = Vector3.new(WIDTH, LENGTH1, WIDTH)
				Block.Material = Enum.Material.Neon
				if j % 2 == 0 then
					Block.Color = Color3.fromRGB(255, 255, 255)
				else
					Block.Color = Color3.fromRGB(0, 0, 0)
				end
				Block.CFrame = Root.CFrame * CFrame.new(math.random(-5, 5) * i, 50, math.random(-2, 2) * i)
				Block.Parent = Visual

				local tween9 = TweenService:Create(
					Block,
					TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{ ["Transparency"] = 1, ["Position"] = Block.Position - Vector3.new(0, 100, 0) }
				)
				tween9:Play()
				tween9:Destroy()
				Debris:AddItem(Block, 0.15)
			end
			wait()
		end
	end)()

	wait(0.2)

	--[[ WindMesh ]]
	--
	local WindMesh1 = VFXEffects.Mesh.WindMesh:Clone()
	WindMesh1.Size = Vector3.new(0.1, 3, 3)
	WindMesh1.Transparency = 0.5
	WindMesh1.CFrame = Arm.CFrame * CFrame.fromEulerAnglesXYZ(0, 0, math.rad(90))
	WindMesh1.Parent = Visual

	local tween10 =
		TweenService:Create(WindMesh1, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			["CFrame"] = WindMesh1.CFrame * CFrame.new(2, 0, 0) * CFrame.fromEulerAnglesXYZ(math.rad(90), 0, 0),
			["Size"] = Vector3.new(0.1, 3, 3),
			["Transparency"] = 1,
		})
	tween10:Play()
	tween10:Destroy()
	Debris:AddItem(WindMesh1, 0.5)

	--[[ Ring2 ]]
	--
	local Ring2 = VFXEffects.Mesh.Ring2OG:Clone()
	Ring2.Transparency = 0.5
	Ring2.CFrame = Root.CFrame * CFrame.fromEulerAnglesXYZ(math.rad(90), 0, 0)
	Ring2.Size = Vector3.new(10, 10, 1)
	Ring2.Parent = Visual
	Debris:AddItem(Ring2, 0.15)

	local tween11 = TweenService:Create(
		Ring2,
		TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{ ["Size"] = Vector3.new(50, 50, 1), ["Transparency"] = 1 }
	)
	tween11:Play()
	tween11:Destroy()

	--[[ Foot Lands Earth ]]
	--

	--[[ Expand Lines Out ]]
	--
	coroutine.wrap(function()
		for _ = 1, 10 do
			for _ = 1, 2 do
				local originalPos = Root.Position
				local beam = VFXEffects.Part.Block:Clone()
				beam.Shape = "Block"
				local mesh = Instance.new("SpecialMesh")
				mesh.MeshType = "Sphere"
				mesh.Parent = beam
				beam.Size = Vector3.new(2, 2, 5)
				beam.Material = Enum.Material.Neon
				beam.Color = Color3.fromRGB(255, 255, 255)
				beam.Transparency = 0
				beam.Parent = Visual

				beam.CFrame = CFrame.new(
					originalPos + Vector3.new(math.random(-1, 1), math.random(-1, 1), math.random(-1, 1)),
					originalPos
				)
				local tween12 =
					TweenService:Create(beam, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						["Size"] = beam.Size + Vector3.new(0, 0, math.random(1, 2)),
						["CFrame"] = beam.CFrame * CFrame.new(0, 0, 35),
					})
				local tween13 = TweenService:Create(
					beam,
					TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
					{ ["Size"] = Vector3.new(0, 0, math.random(0, 5)) }
				)
				tween12:Play()
				tween12:Destroy()
				tween13:Play()
				tween13:Destroy()
				Debris:AddItem(beam, 0.15)
			end
		end
	end)()
	--[[ Block becomes Cylinder ]]
	--
	local Block = VFXEffects.Part.Block:Clone()
	Block.BrickColor = BrickColor.new("Institutional white")
	Block.Shape = "Cylinder"
	Block.Transparency = 0
	Block.Material = "Neon"
	Block.Size = Vector3.new(50, 5, 5)
	Block.Position = Root.Position + Vector3.new(0, 50, 0)
	Block.CFrame = Block.CFrame * CFrame.fromEulerAnglesXYZ(0, 0, math.rad(90))
	Block.Parent = Visual

	local tween14 = TweenService:Create(
		Block,
		TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{ ["Size"] = Vector3.new(100, 0, 0) }
	)
	tween14:Play()
	tween14:Destroy()
	Debris:AddItem(Block, 0.2)

	--[[ shockwave5 ]]
	--
	local shockwave6 = VFXEffects.Mesh.shockwave5:Clone()
	shockwave6.CFrame = Root.CFrame * CFrame.fromEulerAnglesXYZ(0, math.rad(90), 0)
	shockwave6.Size = Vector3.new(25, 50, 25)
	shockwave6.Transparency = 0
	shockwave6.Material = "Neon"
	shockwave6.BrickColor = BrickColor.new("Institutional white")
	shockwave6.Parent = Visual

	local tween15 =
		TweenService:Create(shockwave6, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			["CFrame"] = shockwave6.CFrame * CFrame.new(0, 25, 0) * CFrame.fromEulerAnglesXYZ(0, 5, 0),
			["Size"] = Vector3.new(0, 75, 0),
		})
	tween15:Play()
	tween15:Destroy()
	Debris:AddItem(shockwave6, 0.2)

	--[[ Move Towards Goal ]]
	--
	local BodyPosition = Instance.new("BodyPosition")
	BodyPosition.MaxForce = Vector3.new(1e5, 1e5, 1e5)
	BodyPosition.P = 200
	BodyPosition.D = 20
	BodyPosition.Parent = Root
	BodyPosition.Position = Root.Position + Vector3.new(0, 5, 0)
	Debris:AddItem(BodyPosition, 0.1)

	--[[ Raycast Directly Below by x Studs Away ]]
	--
	local StartPosition = Root.Position
	local EndPosition = CFrame.new(StartPosition).UpVector * -10

	local RayData = RaycastParams.new()
	RayData.FilterDescendantsInstances = { Character, Live, Visual } or Visual
	RayData.FilterType = Enum.RaycastFilterType.Exclude
	RayData.IgnoreWater = true

	local ray = game.Workspace:Raycast(StartPosition, EndPosition, RayData)
	if ray then
		local partHit, pos = ray.Instance or nil, ray.Position or nil
		if partHit then
			--[[ Rocks Fall Down ]]
			--
			coroutine.wrap(function()
				GroundTouched(pos, partHit)
			end)()
		end
	end
	task.wait(0.2)
	GomuArm:Destroy()
end

function module.Move4(Data)
	local Character = Data.Character
	local Root = Character:FindFirstChild("HumanoidRootPart")

	--[[ Play Sound ]]
	--
	SoundManager:Play(Root, "JetGatling", { Volume = 0.5, PlaybackSpeed = 2 })

	--[[ Set Arms Invisible ]]
	--
	local RightArm = Character["Right Arm"]
	local LeftArm = Character["Left Arm"]

	RightArm.Transparency = 1
	LeftArm.Transparency = 1

	--[[ Side Shockwaves ]]
	--
	for j = 1, 2 do
		local Offset = 5
		local Rot = 288
		local GoalSize = Vector3.new(35, 0.05, 7.5)
		if j ~= 1 then
			Offset = Offset * -1
			Rot = 252
		end

		local SideWind = VFXEffects.Mesh.SideWind:Clone()
		SideWind.Size = Vector3.new(8, 0.05, 2)
		SideWind.Transparency = 0
		SideWind.CFrame = Character.HumanoidRootPart.CFrame
			* CFrame.new(Offset, -0.5, 0)
			* CFrame.fromEulerAnglesXYZ(math.rad(90), math.rad(180), math.rad(Rot))
		SideWind.Parent = Visual

		--[[ Tween the Side Shockwaves ]]
		--
		local tween = TweenService:Create(
			SideWind,
			TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{ ["CFrame"] = SideWind.CFrame * CFrame.new(-10, 0, 0), ["Size"] = GoalSize, ["Transparency"] = 1 }
		)
		tween:Play()
		tween:Destroy()

		Debris:AddItem(SideWind, 0.15)
	end

	coroutine.wrap(function()
		for i = 1, 10 do
			local shockwaveOG = VFXEffects.Mesh.shockwaveOG:Clone()
			shockwaveOG.CFrame = Character.HumanoidRootPart.CFrame
				* CFrame.new(0, 0, -3)
				* CFrame.fromEulerAnglesXYZ(math.rad(90), 0, 0)
			shockwaveOG.Size = Vector3.new(5, 2, 5)
			shockwaveOG.Transparency = 0
			shockwaveOG.Material = "Neon"
			if i % 2 == 0 then
				shockwaveOG.Color = Color3.fromRGB(255, 255, 255)
			else
				shockwaveOG.Color = Color3.fromRGB(0, 0, 0)
			end
			shockwaveOG.Parent = Visual
			local tween =
				TweenService:Create(shockwaveOG, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					["Transparency"] = 1,
					["Size"] = Vector3.new(25, 5, 25),
					["CFrame"] = shockwaveOG.CFrame * CFrame.fromEulerAnglesXYZ(0, 5, 0),
				})
			tween:Play()
			tween:Destroy()
			Debris:AddItem(shockwaveOG, 0.2)

			--[[ Ring Behind Player ]]
			--
			local cs = VFXEffects.Mesh.Ring2:Clone()
			cs.Size = Vector3.new(5, 2, 5)
			local c1, c2 =
				Root.CFrame * CFrame.new(0, 0, -40) * CFrame.Angles(math.pi / 2, 0, 0),
				Root.CFrame * CFrame.new(0, 0, 10) * CFrame.Angles(math.pi / 2, 0, 0)
			cs.CFrame = c1
			cs.Material = Enum.Material.Neon
			cs.Parent = Visual

			local Tween = TweenService:Create(
				cs,
				TweenInfo.new(0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0),
				{ Size = Vector3.new(25, 0, 25), CFrame = c2 }
			)
			Tween:Play()
			Tween:Destroy()

			Debris:AddItem(cs, 0.15)

			--[[ Wind Debris Effect ]]
			--
			local slash = VFXEffects.Mesh.ThreeDSlashEffect:Clone()
			local size = math.random(2, 4) * 4
			local sizeadd = math.random(2, 4) * 20
			local x, y, z =
				math.rad(math.random(8, 12) * 30), math.rad(math.random(8, 12) * 30), math.rad(math.random(8, 12) * 30)
			local add = math.random(1, 2)
			if add == 2 then
				add = -1
			end
			slash.Transparency = 0.4
			slash.Size = Vector3.new(2, size, size)
			slash.CFrame = Root.CFrame * CFrame.Angles(x, y, z)
			slash.Parent = Visual

			local Tween1 = TweenService:Create(
				slash,
				TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0),
				{
					Transparency = 1,
					CFrame = slash.CFrame * CFrame.Angles(math.pi * add, 0, 0),
					Size = slash.Size + Vector3.new(0, sizeadd, sizeadd),
				}
			)
			Tween1:Play()
			Tween1:Destroy()

			Debris:AddItem(slash, 0.3)

			--[[ Delay Iteration ]]
			--
			task.wait(0.15)
		end
	end)()

	--[[ Ring ]]
	--
	coroutine.wrap(function()
		for _ = 1, 12 do
			local Ring = VFXEffects.Mesh.Ring:Clone()
			Ring.CFrame = Character.HumanoidRootPart.CFrame
				* CFrame.new(0, 0, -5)
				* CFrame.fromEulerAnglesXYZ(math.rad(90), 0, 0)
			Ring.Size = Vector3.new(2.5, 0, 2.5)
			Ring.Transparency = 0
			Ring.Parent = Visual

			local tween = TweenService:Create(
				Ring,
				TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{ ["Transparency"] = 1, ["Size"] = Vector3.new(20, 0, 20) }
			)
			tween:Play()
			tween:Destroy()
			Debris:AddItem(Ring, 0.15)
			wait(0.15)
		end
	end)()
	coroutine.wrap(function()
		local WIDTH, LENGTH = 0.25, 10
		for j = 1, 55 do
			for i = 1, 3 do
				local Block = VFXEffects.Part.Sphere:Clone()
				Block.Transparency = 0
				Block.Mesh.Scale = Vector3.new(WIDTH, WIDTH, LENGTH)
				Block.Material = Enum.Material.Neon
				if j % 2 == 0 then
					Block.Color = Color3.fromRGB(255, 255, 255)
				else
					Block.Color = Color3.fromRGB(0, 0, 0)
				end
				Block.CFrame = Character.HumanoidRootPart.CFrame
					* CFrame.new(math.random(-2.5, 2.5) * i, math.random(-2, 2) * i, 0)
				Block.Parent = Visual

				local tween = TweenService:Create(
					Block,
					TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{ ["Transparency"] = 1, ["CFrame"] = Block.CFrame * CFrame.new(0, 0, -25) }
				)
				tween:Play()
				tween:Destroy()
				Debris:AddItem(Block, 0.15)
			end
			wait()
		end
	end)()

	--
	for _ = 1, 55 do
		local ToCFrame = Root.CFrame * CFrame.new(0, 0, -30)

		local CFrameConfig = CFrame.new(
			(Root.CFrame * CFrame.new(math.random(-3, 3), math.random(-2, 2), math.random(-4, -3))).p,
			ToCFrame.p
		) * CFrame.Angles(math.rad(90), 0, 0)

		local Arm = script.LuffyGattlingArm:Clone()
		Arm.Color = Color3.fromRGB(232, 186, 200)
		Arm.Anchored = true
		Arm.Massless = true
		Arm.CFrame = CFrameConfig
		Arm.Parent = Visual

		local Shockwave = script["Meshes/SHOCKWAVE"]:Clone()
		Shockwave.Transparency = 0.5
		Shockwave.Size = Vector3.new(2.078, 0.23, 2.077)
		Shockwave.CFrame = Arm.CFrame
		Shockwave.Anchored = true
		Shockwave.CanCollide = false
		Shockwave.Parent = Visual

		Debris:AddItem(Shockwave, 0.05)

		game:GetService("RunService").Heartbeat:Wait()

		local Tween = TweenService:Create(
			Arm,
			TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
			{ CFrame = Arm.CFrame * CFrame.new(0, -math.random(3, 5), 0) }
		)
		Tween:Play()
		Tween:Destroy()

		local Tween1 = TweenService:Create(
			Shockwave,
			TweenInfo.new(0.05, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out),
			{
				Size = Vector3.new(3.654, 0.405, 3.653),
				CFrame = Shockwave.CFrame * CFrame.new(0, -math.random(1, 2), 0),
			}
		)
		Tween1:Play()
		Tween1:Destroy()

		game:GetService("RunService").Heartbeat:Wait()

		local Tween2 = TweenService:Create(Arm, TweenInfo.new(0.2, Enum.EasingStyle.Quad), { Transparency = 1 })
		Tween2:Play()
		Tween2:Destroy()

		local ShockwaveTween =
			TweenService:Create(Shockwave, TweenInfo.new(0.05, Enum.EasingStyle.Quad), { Transparency = 1 })
		ShockwaveTween:Play()
		ShockwaveTween:Destroy()

		for _, v in ipairs(Arm:GetDescendants()) do
			if v:IsA("Decal") or v:IsA("UnionOperation") then
				local Animate = TweenService:Create(v, TweenInfo.new(0.35, Enum.EasingStyle.Quad), { Transparency = 1 })
				Animate:Play()
				Animate:Destroy()
			end
		end
		Debris:AddItem(Arm, 0.75)
	end

	RightArm.Transparency = 0
	LeftArm.Transparency = 0
end
attackRemote.OnClientEvent:connect(function(info)
	local action = info.Function
	if module[action] then
		module[action](info)
	end
end)

return module
