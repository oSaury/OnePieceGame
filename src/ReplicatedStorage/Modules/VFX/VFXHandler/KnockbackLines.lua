local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local Visual = workspace.World.Visual

return function(Data)
	local MAX, ITERATION = Data.MAX, Data.ITERATION
	local WIDTH, LENGTH = Data.WIDTH, Data.LENGTH
	local COLOR1, COLOR2 = Data.COLOR1, Data.COLOR2
	local STARTPOS, ENDGOAL = Data.STARTPOS, Data.ENDGOAL
	local DURATION = Data.DURATION or 0.25
	--[[ Lines in Front/Gravity Force ]]--
	local MAX = 5
	for j = 1,ITERATION do
		for i = 1,MAX do
			local Block = script.Block:Clone()
			Block.Transparency = 0
			Block.Size = Vector3.new(WIDTH,WIDTH,LENGTH)
			Block.Material = Enum.Material.Neon
			if COLOR2 then
				if i%2 == 0 then
					Block.Color = COLOR1
				else
					Block.Color = COLOR2 or COLOR1
				end
			else
				Block.Color = COLOR1
			end

			Block.CFrame = (STARTPOS * CFrame.new(math.random(-MAX*2,MAX*2),math.random(1,MAX*2), math.random(-MAX*2,0)))
			Block.Parent = Visual
			local tween = TweenService:Create(Block, TweenInfo.new(DURATION, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {["Transparency"] = 1, ["CFrame"] = Block.CFrame * ENDGOAL})
			tween:Play()
			tween:Destroy()
			Debris:AddItem(Block, DURATION)
		end
		wait()
	end		
end
