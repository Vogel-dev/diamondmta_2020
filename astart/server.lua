--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

addEventHandler("onResourceStop", getResourceRootElement(getThisResource()), function()
    for k,v in ipairs(getResources()) do
	if string.find(getResourceName(v), "dmta_") or string.find(getResourceName(v), "dmta_") then
        stopResource(v)
        outputDebugString(getResourceName(v).." stopped.")
	end
    end
outputChatBox("DMTA / Skrypty zostały wyłączone", getRootElement())
end)


addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), function()
    for k,v in ipairs(getResources()) do
    if string.find(getResourceName(v), "dmta_") or string.find(getResourceName(v), "dmta_") then
        startResource(v)
        outputDebugString(getResourceName(v).." started.")
        end
    end
end)

addEventHandler("onResourceStop", getResourceRootElement(getThisResource()), function()
    for k,v in ipairs(getResources()) do
	if string.find(getResourceName(v), "maps") or string.find(getResourceName(v), "maps_") then
        stopResource(v)
        outputDebugString(getResourceName(v).." stopped.")
	end
    end
outputChatBox("MAPS / Mapy zostały wyłączone", getRootElement())
end)


addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), function()
    for k,v in ipairs(getResources()) do
    if string.find(getResourceName(v), "maps") or string.find(getResourceName(v), "maps_") then
        startResource(v)
        outputDebugString(getResourceName(v).." started.")
        end
    end
end)

addEventHandler("onResourceStop", getResourceRootElement(getThisResource()), function()
    for k,v in ipairs(getResources()) do
	if string.find(getResourceName(v), "mod") or string.find(getResourceName(v), "mod_") then
        stopResource(v)
        outputDebugString(getResourceName(v).." stopped.")
	end
    end
outputChatBox("MOD / Modele zostały wyłączone", getRootElement())
end)


addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), function()
    for k,v in ipairs(getResources()) do
    if string.find(getResourceName(v), "mod") or string.find(getResourceName(v), "mod_") then
        startResource(v)
        outputDebugString(getResourceName(v).." started.")
        end
    end
end)