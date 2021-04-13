# Cheat Sheet for Creating Scenes and Scene Items Functions

## Using a custom interface with a simple Lua Script inside OBS Studio

![Example Gif](media/example.gif)

This cheatsheet is a TL;DR for the things covered in the [lua scripting tutorial I created](https://morebackgroundsplease.medium.com/use-a-lua-script-to-import-your-twitch-streaming-overlay-designs-into-obs-studio-b8f688aeb9e8) for scripting with Lua for OBS Studio and adding scenes and importing overlays, images, and text.

For an example code of the some of the functions used below please go here: [Example Code](Final/getting_start_with_lua_script.lua)

Please also refer to upgradeQ's Python scripting Cheatsheet here, as it may contain similar items written in Python: [upgradeQ's Python Cheat Sheet](https://github.com/upgradeQ/OBS-Studio-Python-Scripting-Cheatsheet-obspython-Examples-of-API#using-classes)

For more resources definitely check out the amazing group of devs over at the Wiki and the official OBS scripting documentation here:
- [The OBS Getting Started Wiki](https://obsproject.com/wiki/Getting-Started-With-OBS-Scripting)
- [The Official OBS Scripting Documentation](https://obsproject.com/docs/scripting.html)

# Table of content
- [Image to Base64 Converter](#image-to-base64-converter)
- [Setting Keys](#setting-keys)
- [Ffmpeg_source Setting Keys](#ffmpeg_source-setting-keys)
- [Image_source Setting Keys](#image_source-setting-keys)
- [Text_gdiplus Setting Keys](#text_gdiplus_setting_keys)
- [Color_filter Setting Keys](#color-filter-setting-keys)
- [Source Creation Functions](#source-creation-functions)
- [Scene Exists Function](#scene-exists-function)
- [Create Scene Function](#create-scene-function)
- [Create Loop Overlay Function](#create-loop-overlay-function)
- [Create Image Function](#create-image-function)
- [Create Text Function](#create-text-function)
- [Create Color Filter Function](#create-color-filter-function)
- [Import All Scenes Function](#import-all-scenes-function)

# Image To Base64 Converter
[Converter](https://www.base64-image.de/)

# Setting Keys

## Ffmpeg_source Setting Keys
| Key | Type | Set With |
| --- | --- | --- |
| "local_file" | string | obs.obs_data_set_string() |
| "looping" | bool | obs.obs_data_set_bool() |

## Image_source Setting Keys
| Key | Type | Set With |
| --- | --- | --- |
| "file" | string | obs.obs_data_set_string() |

## Text_gdiplus Setting Keys

***For Face, Flags, Size, and Style make sure to set them to a json data object then set the json data object to the Font key.***

| Key | Type | Set With |
| --- | --- | --- |
| "face" | string | obs.obs_data_set_string() |
| "flags" | int | obs.obs_data_set_int() |
| "size" | int | obs.obs_data_set_int() |
| "style" | string | obs.obs_data_set_string() |
| "font" | object | obs.obs_data_set_obj() |
| "text" | string | obs.obs_data_set_string() |
| "align" | string | obs.obs_data_set_string() |
| "color" | int | obs.obs_data_set_int() |
| "outline" | bool | obs.obs_data_set_bool() |
| "outline_color" | int | obs.obs_data_set_int() |
| "outline_size" | int | obs.obs_data_set_int() |

## Color_Filter Setting Keys

| Key | Type | Set With |
| --- | --- | --- |
| "brightness" | int | obs.obs_data_set_int() |
| "contrast" | int | obs.obs_data_set_int() |
| "gamma" | int | obs.obs_data_set_int() |
| "hue_shift" | int | obs.obs_data_set_int() |
| "opacity" | int | obs.obs_data_set_int() |
| "saturation" | int | obs.obs_data_set_int() |

# Source Creation Functions

## Scene Exists Function
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

## Create Scene Function
```lua
function create_scene(scene_name)

	if scene_exists(scene_name) >= 1 then
		scene_name = scene_name .. " " .. scene_exists(scene_name)
	end

	local new_scene = obs.obs_scene_create(scene_name)

	obs.obs_frontend_set_current_scene(obs.obs_scene_get_source(new_scene))
	local current_scene = obs.obs_frontend_get_current_scene()
	local scene = obs.obs_scene_from_source(current_scene)

	obs.obs_scene_release(new_scene)
	obs.obs_scene_release(scene)

	return new_scene, scene

end
```

## Create Loop Overlay Function
```lua
function create_loop_overlay(file_location, name, new_scene, scene, xpos, ypos, xscale, yscale)

	local pos = obs.vec2()
	local scale = obs.vec2()

	local overlay_settings = obs.obs_data_create()
	obs.obs_data_set_string(overlay_settings, "local_file", script_path() .. file_location)
	obs.obs_data_set_bool(overlay_settings, "looping", true)
	local overlay_source = obs.obs_source_create("ffmpeg_source", name, overlay_settings, nil)
	obs.obs_scene_add(new_scene, overlay_source)

	local overlay_sceneitem = obs.obs_scene_find_source(scene, name)
	local overlay_location = pos
	local overlay_scale = scale
	if overlay_sceneitem then
		overlay_location.x = xpos
		overlay_location.y = ypos
		overlay_scale.x = xscale
		overlay_scale.y = yscale
		obs.obs_sceneitem_set_pos(overlay_sceneitem, overlay_location)
		obs.obs_sceneitem_set_scale(overlay_sceneitem, overlay_scale)
	end

	obs.obs_source_update(overlay_source, overlay_settings)
	obs.obs_data_release(overlay_settings)
	obs.obs_source_release(overlay_source)

end
```

## Create Image Function
```lua
function create_image(file_location, name, new_scene, scene, xpos, ypos, xscale, yscale)

	local pos = obs.vec2()
	local scale = obs.vec2()

	local image_settings = obs.obs_data_create()
	obs.obs_data_set_string(image_settings, "file", script_path() .. file_location)
	local image_source = obs.obs_source_create("image_source", name, image_settings, nil)
	obs.obs_scene_add(new_scene, image_source)

	local image_sceneitem = obs.obs_scene_find_source(scene, name)
	local image_location = pos
	local image_scale = scale
	if image_sceneitem then
		image_location.x = xpos
		image_location.y = ypos
		image_scale.x = xscale
		image_scale.y = yscale
		obs.obs_sceneitem_set_pos(image_sceneitem, image_location)
		obs.obs_sceneitem_set_scale(image_sceneitem, image_scale)
	end

	obs.obs_source_update(image_source, image_settings)
	obs.obs_data_release(image_settings)
	obs.obs_source_release(image_source)

end
```

## Create Text Function
```lua
function create_text(face, size, style, text, align, name, new_scene, scene, x, y)

	local pos = obs.vec2()
	local scale = obs.vec2()

	local text_settings = obs.obs_data_create()
	local text_settings = obs.obs_data_create()
	local text_font_object = obs.obs_data_create_from_json('{}')
	obs.obs_data_set_string(text_font_object, "face", face)
	obs.obs_data_set_int(text_font_object, "flags", 0)
	obs.obs_data_set_int(text_font_object, "size", size)
	obs.obs_data_set_string(text_font_object, "style", style)
	obs.obs_data_set_obj(text_settings, "font", text_font_object)
	obs.obs_data_set_string(text_settings, "text", text)
	obs.obs_data_set_string(text_settings, "align", align)
	local text_source = obs.obs_source_create("text_gdiplus", name, text_settings, nil)
	obs.obs_scene_add(new_scene, text_source)

	local text_sceneitem = obs.obs_scene_find_source(scene, name)
	local text_location = pos
	if text_sceneitem then
		text_location.x = x
		text_location.y = y
		obs.obs_sceneitem_set_pos(text_sceneitem, text_location)
	end

	obs.obs_source_update(text_source, text_settings)
	obs.obs_data_release(text_settings)
	obs.obs_data_release(text_font_object)
	obs.obs_source_release(text_source)

end
```

## Create Color Filter Function
```lua
function add_color_filter(name, brightness, contrast, gamma, hue_shift, opacity, saturation)

	source = obs.obs_get_source_by_name(name)

	filter_settings = obs.obs_data_create()
	obs.obs_data_set_int(filter_settings, "brightness", brightness)
	obs.obs_data_set_int(filter_settings, "contrast", contrast)
	obs.obs_data_set_int(filter_settings, "gamma", gamma)
	obs.obs_data_set_int(filter_settings, "hue_shift", hue_shift)
	obs.obs_data_set_int(filter_settings, "opacity", opacity)
	obs.obs_data_set_int(filter_settings, "saturation", saturation)
	color_filter = obs.obs_source_create_private("color_filter", "Color Correct", filter_settings)
	obs.obs_source_filter_add(source, color_filter)
	
	obs.obs_source_update(color_filter, filter_settings)
	obs.obs_source_release(source)
	obs.obs_data_release(filter_settings)
	obs.obs_source_release(color_filter)

end
```

## Import All Scenes Function
```lua
function import_all_scenes()

	--
	-- your hard coded list of scene functions
	--

	local scene_names = obs.obs_frontend_get_scene_names()
	local scene_list = obs.obs_frontend_get_scenes()
	
	for i, name in ipairs(scene_names) do
		if scene_names[i] == "Welcome" then
			scene = scene_list[i]
			obs.obs_frontend_set_current_scene(scene)
			break
		end
	end
	
	for i, scene in ipairs(scene_list) do
        obs.obs_source_release(scene)
    end

end
```