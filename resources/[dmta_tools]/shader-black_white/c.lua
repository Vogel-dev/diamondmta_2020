local screenSize = Vector2(guiGetScreenSize())
local screen = dxCreateScreenSource(screenSize.x, screenSize.y)

addEventHandler("onClientResourceStart", resourceRoot, function()
    if getVersion().sortable < "1.1.0" then 
		return false
	else
		shader, blackWhiteTec = dxCreateShader("fx/blackwhite.fx")
    end
end)

addEventHandler("onClientHUDRender", root, function()
    if shader and localPlayer:getData("player:blackwhite") then
        dxUpdateScreenSource(screen)     
        dxSetShaderValue(shader, "screenSource", screen)
		dxDrawImage(0, 0, screenSize.x, screenSize.y, shader, 0, 0, 0, tocolor(255, 255, 255, 255))
    end
end)
