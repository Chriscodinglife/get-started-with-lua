obs = obslua

local icon1 = "put base64 data here"

local description = [[
<center><h2>Dope Title</h2></center>
<p>
<center><img width=60 height=60 src=']] .. icon1 .. [['/></center>
<p>
<center>Click here to open Google: <a href="https://www.google.com/">Search on Google</a></center>
<hr/>
</p> 
]]

function script_description()
    return description
end

function button()
	return nil
end

function script_properties()
  	local properties = obs.obs_properties_create()
 	local button = obs.obs_properties_add_button(properties, "new_button", "My New Button", button)
	return properties

end