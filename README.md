# Cheat Sheet for Creating Scenes and Scene Items Functions in Lua

## Creating A Custom Interface With A Simple Lua Script Inside OBS Studio

![Example Gif](media/example.gif)

This cheatsheet is a TL;DR for the things covered in the [lua scripting tutorial I created](https://morebackgroundsplease.medium.com/use-a-lua-script-to-import-your-twitch-streaming-overlay-designs-into-obs-studio-b8f688aeb9e8) for scripting with Lua for OBS Studio and adding scenes and importing overlays, images, and text.

For an example code of the some of the functions used below please go here: [Example Code](Final/getting_start_with_lua_script.lua)

Please also refer to upgradeQ's Python scripting Cheatsheet here, as it may contain similar items written in Python: [upgradeQ's Python Cheat Sheet](https://github.com/upgradeQ/OBS-Studio-Python-Scripting-Cheatsheet-obspython-Examples-of-API#using-classes)

For more resources definitely check out the amazing group of devs over at the Wiki and the official OBS scripting documentation here:
- [The OBS Getting Started Wiki](https://obsproject.com/wiki/Getting-Started-With-OBS-Scripting)
- [The Official OBS Scripting Documentation](https://obsproject.com/docs/scripting.html)

# Table Of Contents
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
- [OBS Lua Library Methods](#obs-lua-library-methods)
- [Initiate The OBS Lua Library](#initiate-the-obs-lua-library)
- [Get The Script Path](#get-the-script-path)
- [Useful Scene Methods](#useful-scene-methods)
- [Get All The Scene Names](#get-all-the-scene-names)
- [Create A New Scene Object And Release The Scene Object](#create-a-new-scene-object-and-release-the-scene-object)
- [Get The Source Of A Specific Scene](#get-the-source-of-a-specific-scene)
- [Get The Source Of The Current Viewed/Selected Scene](#get-the-source-of-the-current-viewed/selected-scene)
- [Set The Current Viewed Scene Inside OBS](#set-the-current-viewed-scene-inside-obs)
- [Get The Scene Context From A Scene](#get-the-scene-context-from-a-scene)
- [Release A Scene Object](#release-a-scene-object)
- [Useful Source Methods](#useful-source-methods)
- [Create A Data Settings Object](#create-a-data-settings-object)
- [Set A String Key](#set-a-string-key)
- [Set A Bool Key](#set-a-bool-key)
- [Create A Blank Object Value Array](#create-a-blank-object-value-array)
- [Set An Object Key](#set-an-object-key)
- [Create A Source Object And Release It](#create-a-source-object-and-release-it)
- [Update The Settings Of Your Source](#update-the-settings-of-your-source)
- [Add A Source Object To A Scene](#add-a-source-object-to-a-scene)
- [Create An OBS Vector](#create-an-obs-vector)
- [Get The Scene Item From A Scene](#get-the-scene-item-from-a-scene)
- [Set The Position Of A Scene Item](#set-the-position-of-a-scene-item)
- [Set The Scale Of A Scene Item](#set-the-scale-of-a-scene-item)
- [Release The Settings Object](#release-the-settings-object)
- [Release A Source Object](#release-a-source-object)
- [Get A List Of All The Scenes Created In OBS In Source Object Form](#get-a-list-of-all-the-sccenes-created-in-obs-in-source-object-form)
- [Useful Properties Methods](#useful-properties-methods)
- [Create A Properties Object](#create-a-properties-object)
- [Create A Button](#create-a-button)


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

# OBS Lua Library Methods

Below covers some of the library methods I used in my tutorial. There are definitely plenty more and you can find them referring to the C documentation in the [OBS Documentation](https://obsproject.com/docs/index.html)

## Initiate the OBS Lua library

```lua
obs = obslua
```

## Get The Script Path

This is useful in returning the location of your script on your local machine. You can use this to make relative paths to files located near your script such as a folder with your overlays.

```lua
script_path()
```

# Useful Scene Methods 

Use the following methods I commonly used in my tutorial for creating and editing scenes.

## Get All The Scene Names

This will return a list of all the names of your scenes created inside OBS.

```lua
list_of_scene_names = obs.obs_frontend_get_scene_names()
```

## Create A New Scene Object And Release The Scene Object

Add a New Scene into OBS using this method, make sure to release the reference to the scene after.

The release method will only expect a scene object.

```lua
scene_name = "My New Scene"

local scene_object = obs.obs_scene_create(scene_name) -- This will create your scene object and make your new scene appear inside OBS

obs.obs_scene_release(scene_object)
```

## Get The Source Of A Specific Scene

A scene can also be considered a source. So to return the scene as a source object do the following:

```lua
obs.obs_scene_get_source(scene_object)
```

## Get the Source of the Current Viewed/Selected Scene

Do the following to get the source object of the currently selected scene inside OBS:

```lua
local current_scene = obs.obs_frontend_get_current_scene()
```

## Set The Current Viewed Scene Inside OBS

This method expects a source object instead of a scene object. So use the obs_scene_get_source method to get the source from a scene.

```lua
obs.obs_frontend_set_current_scene(obs.obs_scene_get_source(scene_object))
```

## Get The "Scene Context" From A Scene

This is different from obs_scene_get_source because scene_get_source returns the scene's source object. This returns the window or context of what the scene consists of.

```lua
local scene_context = obs.obs_scene_from_source(source_object)
```

## Release A Scene Object

Do this after creating a Scene Object

```lua
obs.obs_Scene_release(scene_object)
```

# Useful Source Methods

The following covers methods related around creating sources within a scene, which can also be known as sceneitems. Sceneitems have properties or settings that can set by using specific methods for editing various setting keys. In my tutorial I go over a few source types, but the following can be applied generally to all types of sources.

## Create A Data Settings Object

After creating your data settings object, make sure to release it.

```lua
local settings_object = obs.obs_data_create()

obs.obs_data_release(settings_object)
```

## Set A String Key

In this example we will set the "local_file" string key for a source type "ffmpeg_source"

```lua
local file_path = path/to/a/video

obs.obs_data_set_string(settings_object, "local_file", file_path)
```

## Set A Bool Key

For this example we will set the "looping" bool key for a source type "ffmpeg_source". The following method will expect three input parameters, the last one being a bool of either true or false.

```lua
obs.obs_data_set_bool(settings_object, "looping", true)
```

## Create A Blank Object Value Array

```lua
local blank_object = obs.obs_data_create_from_json('{}')
```

## Set An Object Key

Object Keys are Keys that expect an Array of values instead of just one value. This method is useful for when you have to set the font. Below is an example of how to set the "font" key for a source type of "text_gdiplus" or basically a text source:

```lua
local settings_object = obs.obs_data_create()

local font_object = obs.obs_data_create_from_json('{}')

obs.obs_data_set_string(font_object, "face", face)
obs.obs_data_set_int(font_object, "flags", 0)
obs.obs_data_set_int(font_object, "size", size)
obs.obs_data_set_string(font_object, "style", style)

obs.obs_data_set_obj(settings_object, "font", text_font_object)
```

## Create A Source Object And Release It

It is a good idea to create your source object after you have created your settings object. Your Settings object will be used as an input paramater for creating the source object.

The following method will expect 4 input parameters: the type of source, a string value for name, the settings object, and hotkeydata. We will not be inputting any hotkey data so we will leave this as nil, or basically null.

This example will show how to create a source type of "ffmpeg_source". Always make sure to release your data settings object and your source object.

```lua
local settings_object = obs.obs_data_create()
local file_path = path/to/a/video
local name = "my_source_name"

obs.obs_data_set_string(settings_object, "local_file", script_path() .. file_path)
obs.obs_data_set_bool(settings_object, "looping", true)

local source_object = obs.obs_source_create("ffmpeg_source", name, settings_object, nil)

obs.obs_data_release(settings_object)
obs.obs_source_release(source_object)

```

## Update the Settings Of Your Source

It is a good idea to always update your source settings with any key you have set. Do the following:
```lua
obs.obs_source_update(source_object, settings_object)
```

## Add A Source Object To A Scene

After you succesfully created your source object, you can add it to your scene like so:

```lua
obs.obs_scene_add(scene_object, source_object)
```

## Create an OBS Vector

This is useful for whenever you have to set a value for position or scale. 

```lua
local position = obs.vec2()
```

## Get The Scene Item From A Scene

In order to edit or change the position or scale of a Source Object in a scene, you need to call it as a scene item. The following method will expect a scene object, and the name given to your source that you added to your scene. To get the scene item from a source do:

```lua
local sceneitem_object = obs.obs_scene_find_source(scene_object, name)
```

## Set The Position Of A Scene Item

Position is based on x,y coordinates in pixels, with the top left corner of the OBS Stream Viewer being 0,0. The following method will expect the sceneitem object and a vector for position x and position y.

```lua
local position = obs.vec2()

position.x = 25
position.y = 25

obs.obs_sceneitem_set_pos(sceneitem_object, position)
```

## Set The Scale Of A Scene Item

Scale is based on a scalar percentage of your original source's size. If you were to have a 1920 by 1080 video, then 1 would be 100% of your video's scale, and 0.5 being half the size. Use the following method to set your size of your source. Note that the Scale needs to be a vector, so create a vector first:

```lua
local scale = obs.vec2()

scale.x = 1
scale.y = 0.5

obs.obs_sceneotem_set_scale(sceneitem_object, scale)
```

## Release The Settings Object

```lua
obs.obs_data_release(settings_object)
```

## Release A Source Object

```lua
obs.obs_source_release(source_object)

```

## Get A List Of All The Scenes Created In OBS In Source Object Form

This is useful if you want to retrieve a full list of all scenes in the form of source objects you made inside OBS. Always make sure to release your source objects as well. Please don't confuse this as a list of all the sceneitems you have in your scene.

```lua
local scene_list = obs.obs_front_end_get_scenes()

for i, scene in ipairs(scene_list) do
    obs.obs_source_release(scene)
end
```

# Useful Properties Methods

## Create A Properties Object

Here is where you can create and add cool menu items, buttons, and sliders into your script. You start with first creating the actual properties object that will contain all your cool stuff.

```lua
local properties_object = obs.obs_properties_create()
```

## Create A Button

This will show how to add a button to your UI by incorporating it into your properties object. This method will expect 4 input parameters which are your properties object, a name, the actual displayed text, and a callback function. In the example below I have a "welcome_scene_function" function that will act as my callback function. Please note that I intentionally left this function blank

```lua
function welcome_scene_function)
end

local properties_object = obs.obs_properties_create()

local welcome_button = obs.obs_properties_add_button(properties_object, "welcome_button", "Welcome!", welcome_scene_function)
```