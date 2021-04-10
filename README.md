# Cheat Sheet for Creating Scenes and Scene Items Functions

# Table of content
- [Creation Functions](#creation-functions)
- [Create Scene Function](#create-scene-function)
- []

# Creation Functions

## Create Scene Function
```lua
function scene_exists(scene_name)

	local scene_names = obs.obs_frontend_get_scene_names()
	local value = 0

	for i, name in ipairs(scene_names) do
		if string.find(scene_names[i], scene_name) then
			value = value + 1
		end
	end

	return value
	
end
```
