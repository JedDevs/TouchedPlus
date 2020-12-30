--[[

	Name: TouchedPlus
	By: JedDevs
	Date: 30/12/2020 (DD/MM/YYYY)

--]]

local TouchedPlus = {}
TouchedPlus.__index = TouchedPlus

local RunService = game:GetService("RunService")

local Signal = require(script.Signal)
local Thread = require(script.Thread)
local Maid = require(script.Maid)

local function round(number, precision)
	local fmtStr = string.format('%%0.%sf',precision)
	number = string.format(fmtStr,number)
	return number
end

function TouchedPlus:VectorSetup(pos, size)
	self.TopPos =  Vector3.new(pos.X, pos.Y + size.Y / 2, pos.Z)
	self.TopSize = Vector2.new(size.X,size.Z)
	self.BottomPos = Vector3.new(pos.X, pos.Y - size.Y / 2, pos.Z)

	local inc = self.TopSize / self.sects
	self.IncX = round(inc.X, 1)
	self.IncY = round(inc.Y, 1)
end

function TouchedPlus.new(object, precision, dynamic, delay)
	if not object or not precision then return warn("Missing Parameter") end
	if precision <= 0 or precision > 100 then return warn("precision must be 1-100") end
	if not object:IsA("BasePart") then return warn("Currently Only Supports Primative Objects") end
	if type(dynamic) ~= "boolean" and dynamic ~= nil then return warn("Dynamic must be a boolean") end
	
	local self = setmetatable({
		_maid = Maid.new(),
		
		object = object,
		sects = precision,
		
		Touched = Signal.new(),
		TouchEnded = Signal.new(),
		
		updatePosition = dynamic or true,
		
		lastTouched = {},
		touching = {},
	}, TouchedPlus)
	
	self.raycastParams = RaycastParams.new()
	self.raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
	self.raycastParams.FilterDescendantsInstances = {object}
	
	local delay = delay or (((precision - 1) * 0.09) / 99) + 0.01 --balance out precision with performance
	self._maid:GiveTask(Thread.DelayRepeat(delay, self.Update, self))
	self:VectorSetup(self.object.Position, self.object.Size)
	
	return self
end

function TouchedPlus:RaycastDown(origin, distance)
	local raycastResult = workspace:Raycast(origin, distance, self.raycastParams)
	if not raycastResult then return end
	
	
	if not self.lastTouched[raycastResult.Instance] then
		self.lastTouched[raycastResult.Instance] = raycastResult.Instance
		self.Touched:Fire(raycastResult.Instance)
	end
	
	self.touching[raycastResult.Instance] = raycastResult.Instance
end


function TouchedPlus:CheckResults(obj)
	if self.touching[obj] then return end
	self.TouchEnded:Fire(obj)
	
	self.lastTouched[obj] = nil
end

function TouchedPlus:Update()
	if self.updatePosition then self:VectorSetup(self.object.Position, self.object.Size) end
	local startPos = Vector2.new(self.TopPos.X - (self.TopSize.X / 2), self.TopPos.Z - (self.TopSize.Y / 2) )
	self.touching = {}
	
	for x = 0, self.TopSize.X, self.IncX do --x
		for y = 0, self.TopSize.Y, self.IncY do --y
			local newPos = startPos + Vector2.new(x, y)
			
			local origin =  Vector3.new(newPos.X, self.TopPos.Y, newPos.Y)
			local destination =  Vector3.new(newPos.X, self.BottomPos.Y, newPos.Y)
			
			self:RaycastDown(origin, destination - origin)
		end
	end
	
	for _,obj  in next, self.lastTouched do
		self:CheckResults(obj)
	end
end


function TouchedPlus:Destroy()
	self._maid:DoCleaning()
	self = nil
end

return TouchedPlus
