--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local anims, builtins = {}, {"Linear", "InQuad", "OutQuad", "InOutQuad", "OutInQuad", "InElastic", "OutElastic", "InOutElastic", "OutInElastic", "InBack", "OutBack", "InOutBack", "OutInBack", "InBounce", "OutBounce", "InOutBounce", "OutInBounce", "SineCurve", "CosineCurve"}

function table.find(t, v)
	for k, a in ipairs(t) do
		if a == v then
			return k
		end
	end
	return false
end

function animate(f, t, easing, duration, onChange, onEnd)
	assert(type(f) == "number", "Bad argument @ 'animate' [expected number at argument 1, got "..type(f).."]")
	assert(type(t) == "number", "Bad argument @ 'animate' [expected number at argument 2, got "..type(t).."]")
	assert(type(easing) == "string" or (type(easing) == "number" and (easing >= 1 or easing <= #builtins)), "Bad argument @ 'animate' [Invalid easing at argument 3]")
	assert(type(duration) == "number", "Bad argument @ 'animate' [expected function at argument 4, got "..type(duration).."]")
	assert(type(onChange) == "function", "Bad argument @ 'animate' [expected function at argument 5, got "..type(onChange).."]")
	table.insert(anims, {from = f, to = t, easing = table.find(builtins, easing) and easing or builtins[easing], duration = duration, start = getTickCount( ), onChange = onChange, onEnd = onEnd})
	return #anims
end

function destroyAnimation(a)
	if anims[a] then
		table.remove(anims, a)
	end
end

addEventHandler("onClientRender", root, function( )
	local now = getTickCount( )
	for k,v in ipairs(anims) do
		v.onChange(interpolateBetween(v.from, 0, 0, v.to, 0, 0, (now - v.start) / v.duration, v.easing))
		if now >= v.start+v.duration then
			if type(v.onEnd) == "function" then
				v.onEnd( )
			end
			table.remove(anims, k)
		end
	end
end)

-- animation function :D

local dx = exports.dmta_tool_dx;
local editbox = exports.dmta_tool_editbox;
local scroll = exports.dmta_tool_scroll;

local f1 = dx:getFont("rbt-r", 2);
local f2 = dx:getFont("rbt-r", 5);
local f3 = dx:getFont("rbt-r", 2);
local f4 = dx:getFont("rbt-l", 10);
local f5 = dx:getFont("rbt-r", -1);

local sw,sh = guiGetScreenSize()
local baseX = 1920
local zoom = 1
local minzoom = 2
if sw < baseX then
    zoom = math.min(minzoom, baseX/sw)
end

local scoreboard = {}

function isMouseIn(x, y, w, h)
	if not isCursorShowing() then return end

	local pos = {getCursorPosition()}
	pos[1],pos[2] = (pos[1]*sw),(pos[2]*sh)

	if pos[1] >= x and pos[1] <= (x+w) and pos[2] >= y and pos[2] <= (y+h) then
		return true
	end
	return false
end

function isEventHandlerAdded(eventName, rootName, fnc)
  if type(eventName) == "string" and isElement(rootName) and type(fnc) == "function" then
    local eventHandlers = getEventHandlers(eventName, rootName)
    if type(eventHandlers) == "table" and #eventHandlers > 0 then
      for i,v in pairs(eventHandlers) do
        if v == fnc then
          return true
        end
      end
    end
  end
  return false
end

local alpha = 0;

function scoreboard:Construction()
  self.textures = {
    "i/scoreboard.png",
    "i/edit.png",
    "i/logo2.png",
    "i/icons/all.png",
    "i/icons/premium.png",
    "i/icons/admins.png",
  };

  self.img = {};

	for i,v in pairs(self.textures) do
		self.img[i] = dxCreateTexture(v, "argb", false, "clamp");
	end;

  self.min_row = 1

  self.icons = {
    [1] = {self.img[4], "Wszyscy"},
    [2] = {self.img[5], "Diamond"},
    [3] = {self.img[6], "Ekipa"},
  }

  self.players = {}
  self.index = 0

  self.update_player_data = 2500
  self.update_tick = getTickCount()

  self.page = 1;

  self.mouse_showed = false

  self.edit_text = ""

  self.render_fnc = function() self:Render() end
  self.scroll_fnc = function(key, state) self:Scroll(key, state) end
  self.toggle_fnc = function(key, state) self:Toggle(key, state) end
  self.mouse_fnc = function(key, state) self:Mouse(key, state) end
  self.load_players_fnc = function() self:LoadPlayers() end
  self.click = function(...) self:Click(...) end

  bindKey("tab", "both", self.toggle_fnc)
  
  addEventHandler("onPlayerJoin", root, self.load_players_fnc)
  addEventHandler("onPlayerQuit", root, self.load_players_fnc)
  addEventHandler("onClientClick", root, self.click)
end

function scoreboard:GetPlayerHEX(v)
  if getElementData(v, 'rank:duty') and getElementData(v, 'rank:duty') == 1 then
     return '#006400'
  elseif getElementData(v, 'rank:duty') and getElementData(v, 'rank:duty') == 2 then
     return '#f28600'
  elseif getElementData(v, 'rank:duty') and getElementData(v, 'rank:duty') == 3 then
     return '#ff0000'
  elseif getElementData(v, 'rank:duty') and getElementData(v, 'rank:duty') == 4 then
     return '#960000'
  elseif getElementData(v, 'user:premium') then
     return '#69bceb'
  else
    return '#ffffff'
  end
end

function scoreboard:LoadPlayers()
  self["players"] = {}

  for i,v in pairs(getElementsByType("player")) do
    if((self.page == 2 and getElementData(v, "user:premium")) or (self.page == 3 and getElementData(v, "rank:duty")) or self.page == 1)then
      if string.len(self["edit_text"]) > 0 then
        if(string.find(string.gsub(getPlayerName(v):lower(),"#%x%x%x%x%x%x", ""), self["edit_text"]:lower(), 1, true) or string.find(getElementData(v, "user:id"), self["edit_text"], 1, true))then
          table.insert(self["players"], {
            id=(getElementData(v, "user:id") or 0),
            name=(getElementData(v, "user:dbid") and getPlayerName(v) or "Niezalogowany"),
            organization=(getElementData(v, "user:organization") or "Brak"),
            faction=(getElementData(v, "user:faction") or "Brak"), 
            respekt=(getElementData(v, "user:reputation") or "0"), 
            level=(getElementData(v, "user:level") or "1"), 
            ping=getPlayerPing(v),
            hex=self:GetPlayerHEX(v),
          })
        end
      else
        table.insert(self["players"], {
          id=(getElementData(v, "user:id") or 0),
          name=(getElementData(v, "user:dbid") and getPlayerName(v) or "Niezalogowany"),
          organization=(getElementData(v, "user:organization") or "Brak"),
          faction=(getElementData(v, "user:faction") or "Brak"), 
          respekt=(getElementData(v, "user:reputation") or "0"), 
          level=(getElementData(v, "user:level") or "1"), 
          ping=getPlayerPing(v),
          hex=self:GetPlayerHEX(v),
        })    
      end;
    end;
  end;
end;

function scoreboard:Render()
  self["edit_text"] = editbox:dxGetEditText("SCOREBOARD-SEARCH") or "";
  self["index"] = 0;

  local selected = editbox:dxEditGetSelected("SCOREBOARD-SEARCH");
  if #self.edit_text > 0 or selected or (getTickCount() - self["update_tick"]) > self["update_player_data"] then
    self["update_tick"] = getTickCount()
    self:LoadPlayers()
  end

  self.min_row = math.floor(scroll:dxScrollGetPosition("SCOREBOARD-SCROLL") + 1);

  dxDrawImage(sw/2-721/2/zoom, sh/2-787/2/zoom, 721/zoom, 787/zoom, self.img[1], 0, 0, 0, tocolor(255, 255, 255, alpha), false);
  dxDrawImage(sw/2-270/2/zoom, sh/2-740/2/zoom, 274/zoom, 34/zoom, self.img[2], 0, 0, 0, tocolor(255, 255, 255, alpha), false);

  dxDrawImage(sw/2+115/zoom, sh/2-721/2/zoom, 17/zoom, 17/zoom, self.icons[self.page][1], 0, 0, 0, tocolor(255, 255, 255, alpha), false);
  dxDrawText(self.icons[self.page][2], 0, sh/2-360/zoom, sw/2+110/zoom, 0, tocolor(124, 125, 127, alpha), 1, f5, "right", "top", false);

  dxDrawImage(sw/2-700/2/zoom, sh/2-770/2/zoom, 200/zoom, 60/zoom, self.img[3], 0, 0, 0, tocolor(255, 255, 255, alpha), false);

  dxDrawRectangle(599/zoom, 252/zoom, 720/zoom, 4/zoom, tocolor(105, 188, 235, 255), false)

  dxDrawText("Obecnie na serwerze:", 0, sh/2-375/zoom, sw/2+340/zoom, 0, tocolor(200, 200, 200, alpha), 1, f1, "right", "top", false);
  dxDrawText("#69bceb"..#getElementsByType("player").."#ced1d0 ONLINE", 0, sh/2-360/zoom, sw/2+340/zoom, 0, tocolor(255, 255, 255, alpha), 1, f2, "right", "top", false, false, false, true);
  dxDrawText("Naciśnij prawy przycisk myszy by pokazać kursor.", 0+1, sh/2+367/zoom+1, sw+1, sh+1, tocolor(0, 0, 0, 255), 1, f1, "center", "top", false);
  dxDrawText("Naciśnij prawy przycisk myszy by pokazać kursor.", 0, sh/2+367/zoom, sw, sh, tocolor(150, 150, 150, alpha), 1, f1, "center", "top", false);

  dxDrawText("ID", sw/2-655/zoom, sh/2-311/zoom, sw/2, sh, tocolor(150, 150, 150, alpha), 1, f3, "center", "top", false);
  dxDrawText("IMIĘ I NAZWISKO", sw/2-420/zoom, sh/2-311/zoom, sw/2, sh, tocolor(150, 150, 150, alpha), 1, f3, "center", "top", false);
  dxDrawText("POZIOM", sw/2-111/zoom, sh/2-311/zoom, sw/2, sh, tocolor(150, 150, 150, alpha), 1, f3, "center", "top", false);
  dxDrawText("RESPEKT", sw/2+77/zoom, sh/2-311/zoom, sw/2, sh, tocolor(150, 150, 150, alpha), 1, f3, "center", "top", false);
  dxDrawText("SŁUŻBA", sw/2+277/zoom, sh/2-311/zoom, sw/2, sh, tocolor(150, 150, 150, alpha), 1, f3, "center", "top", false);
  dxDrawText("PING", sw/2+590/zoom, sh/2-311/zoom, sw/2, sh, tocolor(150, 150, 150, alpha), 1, f3, "center", "top", false);

  for i,v in pairs(self["players"]) do
    if(self["min_row"]+20 >= i and self["min_row"] <= i)then
       self["index"] = self["index"]+1;

       local sY = (30/zoom)*self["index"]+5;
      -- local sy = 48/zoom * self['index']
       local sx = 30.2/zoom * self['index']

       if isMouseIn(599/zoom, 226/zoom + sx, 705/zoom, 27/zoom) then
        dxDrawRectangle(599/zoom, 226/zoom + sx, 705/zoom, 27/zoom, tocolor(15, 15, 15, 125))
       else
        dxDrawRectangle(599/zoom, 226/zoom + sx, 705/zoom, 27/zoom, tocolor(5, 5, 5, 125))
       end

       dxDrawText(v.id, sw/2-655/zoom+1, sh/2-311/zoom+sY+1, sw/2+1, sh+1, tocolor(5, 5, 5, 255), 1, f3, "center", "top", false);
       dxDrawText(v.name, sw/2-420/zoom+1, sh/2-311/zoom+sY+1, sw/2+1, sh+1, tocolor(5, 5, 5, 255), 1, f3, "center", "top", false, false, false, true);
       dxDrawText(v.level, sw/2-111/zoom+1, sh/2-311/zoom+sY+1, sw/2+1, sh+1, tocolor(5, 5, 5, 255), 1, f3, "center", "top", false, false, false, true);
       dxDrawText(v.respekt, sw/2+77/zoom+1, sh/2-311/zoom+sY+1, sw/2+1, sh+1, tocolor(5, 5, 5, 255), 1, f3, "center", "top", false);
       dxDrawText(v.faction, sw/2+277/zoom+1, sh/2-311/zoom+sY+1, sw/2+1, sh+1, tocolor(5, 5, 5, 255), 1, f3, "center", "top", false);
       dxDrawText(v.ping, sw/2+590/zoom+1, sh/2-311/zoom+sY+1, sw/2+1, sh+1, tocolor(5, 5, 5, 255), 1, f3, "center", "top", false);

       dxDrawText(v.id, sw/2-655/zoom, sh/2-311/zoom+sY, sw/2, sh, tocolor(150, 150, 150, alpha), 1, f3, "center", "top", false);
       dxDrawText(v.hex..v.name, sw/2-420/zoom, sh/2-311/zoom+sY, sw/2, sh, tocolor(150, 150, 150, alpha), 1, f3, "center", "top", false, false, false, true);
       dxDrawText(v.level, sw/2-111/zoom, sh/2-311/zoom+sY, sw/2, sh, tocolor(150, 150, 150, alpha), 1, f3, "center", "top", false, false, false, true);
       dxDrawText(v.respekt, sw/2+77/zoom, sh/2-311/zoom+sY, sw/2, sh, tocolor(150, 150, 150, alpha), 1, f3, "center", "top", false);
       dxDrawText(v.faction, sw/2+277/zoom, sh/2-311/zoom+sY, sw/2, sh, tocolor(150, 150, 150, alpha), 1, f3, "center", "top", false);
       dxDrawText(v.ping, sw/2+590/zoom, sh/2-311/zoom+sY, sw/2, sh, tocolor(150, 150, 150, alpha), 1, f3, "center", "top", false);
     end
   end

   scroll:dxScrollSetAlpha("SCOREBOARD-SCROLL", alpha);
   editbox:dxSetEditAlpha("SCOREBOARD-SEARCH", alpha);
end

function scoreboard:Click(key, state)
  if(key == "left" and state == "down")then
    if(isMouseIn(sw/2+115/zoom, sh/2-721/2/zoom, 17/zoom, 17/zoom))then
      if(self.page < 3)then
        self.page = self.page+1;
      else
        self.page = 1;
      end;
      self["update_tick"] = getTickCount()
      self:LoadPlayers()
    end;
  end;
end;

function scoreboard:Toggle(key, state)
  if key == "tab" and getElementData(localPlayer, "pokaz:hud") then
    if state == "up" and isEventHandlerAdded("onClientRender", root, self["render_fnc"]) then
      if self["mouse_showed"] == true then return end

      animate(alpha, 0, 1, 100, function(a)
        alpha = a;

        if(a == 0)then
          removeEventHandler("onClientRender", root, self["render_fnc"])

          editbox:dxDestroyEdit("SCOREBOARD-SEARCH")
          showCursor(false)
    
          self["mouse_showed"] = false
    
          unbindKey("mouse2", "down", self["mouse_fnc"])
    
          scroll:dxDestroyScroll("SCOREBOARD-SCROLL");
        end;
      end);
    elseif state == "down" then
      if self["mouse_showed"] == true and isEventHandlerAdded("onClientRender", root, self["render_fnc"]) then
        animate(alpha, 0, 1, 100, function(a)
          alpha = a;
  
          if(a == 0)then
            removeEventHandler("onClientRender", root, self["render_fnc"])

            editbox:dxDestroyEdit("SCOREBOARD-SEARCH")
            showCursor(false)
    
            self["mouse_showed"] = false
    
            unbindKey("mouse2", "down", self["mouse_fnc"])
    
            scroll:dxDestroyScroll("SCOREBOARD-SCROLL");
          end;
        end);
      end;

      if isEventHandlerAdded("onClientRender", root, self["render_fnc"]) then return end

      self:LoadPlayers()
      self["update_tick"] = getTickCount()

      addEventHandler("onClientRender", root, self["render_fnc"])

      editbox:dxCreateEdit("SCOREBOARD-SEARCH", "", "Aby wyszukać wpisz nick/id", sw/2-250/2/zoom, sh/2-740/2/zoom, 180/zoom, 34/zoom, false, 0, 255, false, true);
      scroll:dxCreateScroll("SCOREBOARD-SCROLL", sw/2+342/zoom, sh/2-280/zoom, 6/zoom, 60/zoom, 0, 21, self.players, 635/zoom);

      self["mouse_showed"] = false

      bindKey("mouse2", "down", self["mouse_fnc"])

      animate(alpha, 255, 1, 100, function(a)
        alpha = a;
      end);
    end
  end
end

function scoreboard:Mouse(key, state)
  if key == "mouse2" then
    showCursor(not self["mouse_showed"], false)
    self["mouse_showed"] = not self["mouse_showed"]
  end
end

addEventHandler("onClientResourceStart", resourceRoot, function()
  scoreboard:Construction()
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
  editbox:dxDestroyEdit("SCOREBOARD-SEARCH")
  scroll:dxDestroyScroll("SCOREBOARD-SCROLL");
end)