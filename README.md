# TouchedPlus
Raycast Based Collision Detection For Primitive Objects

**Accurate** Collision Detection for BaseParts, compatible with all primitive objects but made for cuboids. <br>
**Example:** Adds Touched & Touch Ended for one BasePart.

```lua
local TouchedPlus = require(game:GetService("ReplicatedStorage").TouchedPlus)
local partDetection = TouchedPlus.new(script.Parent, 10) 
--object, optional [precision] (integer), optional [dynamic] (boolean),optional [delay] (otherwise automatically determined based on precision to balance performance)

partDetection.Touched:Connect(function(obj)
	print("touched: ", obj.Name)
end)

partDetection.TouchEnded:Connect(function(lastObj)
	print("touch ended on: ", lastObj.Name)
end)
```

**Reason:** Robloxs Built in Touched & TouchEnded events are sensitive and near unusuable. I haven't since found a good, fast and performant alternative to this. Even Zone+ has limitations as it uses Region3 which is much more, costly, than raycasting. I also wanted to offer much more control to the developer to decide the balance on ***accuracy, speed and performance***.
