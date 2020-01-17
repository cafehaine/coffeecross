local m = {}

function m.serialize(val)
	local vtype = type(val)
	if vtype == "string" then
		--TODO use custom function to prevent newlines from taking two lines.
		return ("%q"):format(val)
	elseif vtype == "number" then
		return tostring(val)
	elseif vtype == "boolean" then
		return val and "true" or "false"
	elseif vtype == "table" then
		local output = {}
		for i,v in ipairs(val) do
			output[i] = m.serialize(v)
		end
		return "{"..table.concat(output, ",").."}"
	else
		print("unhandled type: "..vtype)
	end
end

function m.deserialize(str)
	if str == "true" or str == "false" then
		return str == "true"
	elseif str:match('".*"') then
		--TODO totally unsafe
		return loadstring("return"..str)()
	elseif str:match("%-?%d+%.?%d*") then
		return tonumber(str)
	else
		print("Unhandled serialized data: "..str)
	end
end

return m
