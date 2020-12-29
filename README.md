# TouchedPlus
Raycast Based Collision Detection For Primitive Objects


**Accurate** Collision Detection for BaseParts, compatible with all primitive objects but made for cuboids. <br>
**Example:** Adds Touched & Touch Ended for one BasePart.

```lua
local TouchedPlus = require(game:GetService("ReplicatedStorage").TouchedPlus)
local partDetection = TouchedPlus.new(script.Parent, 10) 
--object, precision, optional [delay] (otherwise automatically determined based on precision to balance performance)

partDetection.Touched:Connect(function(obj)
	print("touched: ", obj.Name)
end)

partDetection.TouchEnded:Connect(function(lastObj)
	print("touch ended on: ", lastObj.Name)
end)
```
