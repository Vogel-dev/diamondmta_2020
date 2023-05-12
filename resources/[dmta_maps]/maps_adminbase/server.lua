local irAdentro = createMarker(1163.2182617188,-1585.1824951172,13.546875-0.95, "cylinder", 2, 255, 255, 255, 30)
local irAfuera = createMarker( -1894.73, 653.08, -64.42, "cylinder", 2, 255, 255, 255, 30)
setElementData(irAdentro, 'marker:icon', 'brak')
setElementData(irAfuera, 'marker:icon', 'brak')
--Puerta para Zona Admin
local puerta = createObject (10150,-1947.0670166016,641.17620849609,-80,0,0,90)
local markerADM = createMarker (-1947.06,641.17,-81.7, 'cylinder', 3, 132, 27, 45, 0)
setElementData(markerADM, 'marker:icon', 'brak')
--------------------------


--Define quiénes pueden entrar y quiénes no.
function Entrar( hitPlayer, matchingDimension )

    if getElementData(hitPlayer, "rank:duty") then
        setElementPosition ( hitPlayer, -1901.87, 653.26, -63.42 )
        outputChatBox("#69bceb● #ffffffWitaj w bazie administracji serwera, wszystko co tutaj widzisz jest poufne.", hitPlayer, 255, 255, 255, true)
  else    
    outputChatBox("#69bceb● #ffffffAby wejść do tego pomieszczenia, musisz być członkiem administracji serwera.", hitPlayer, 255, 255, 255, true)     
  end
end

addEventHandler( "onMarkerHit", irAdentro, Entrar )

--Ésta es la salida del laboratorio.
function Salir( hitPlayer, matchingDimension )
  setElementPosition ( hitPlayer, 1160.6926269531,-1582.4620361328,13.546875)
  outputChatBox("#69bceb● #ffffffWyszedłeś z bazy administracji.", hitPlayer, 255, 255, 255, true)
end

addEventHandler( "onMarkerHit", irAfuera, Salir )

--Ésta es una zona de Admins. Sólo ellos pueden ingresar.
addEventHandler ("onMarkerHit",markerADM,
function (hitPlayer)
if getElementData(hitPlayer, "rank:duty") then
  moveObject (puerta,1000,-1947.0670166016,641.17620849609,-77)
  outputChatBox("#69bceb● #ffffffWitaj w pomieszczeniu administracji serwera.", hitPlayer, 255, 255, 255, true)
 else
    outputChatBox("#ff0000● #ffffffNie posiadasz odpowiednich uprawnień do wejścia tu.", hitPlayer, 255, 255, 255, true) 
 end
end)

addEventHandler ("onMarkerLeave",markerADM,
function ()
 moveObject (puerta,1000,-1947.0670166016,641.17620849609,-80)
end)