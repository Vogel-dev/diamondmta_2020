--[[
@Author: Vogel
@Copyright: Vogel / DiamondMTA // 2020-2021

@Pierwotne prawo do użytku tego skryptu ma TYLKO autor i serwery otrzymujące zgodę na jego użytkowanie przez autora
@Obowiązuje całkowity zakaz rozpowszechniania skryptów, zmiany autora, edycji skryptów bez zgody autora
@Nie masz prawa użytkować tego skryptu bez mojej zgody.
]]--

local sw,sh = guiGetScreenSize();
local dx = exports.dmta_tool_dx;
local img = false;

local buttons = {};

function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
    local sx, sy = guiGetScreenSize ( )
    local cx, cy = getCursorPosition ( )
    local cx, cy = ( cx * sx ), ( cy * sy )
    if ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) then
        return true
    else
        return false
    end
end

function createButton(id, text, x, y, w, h, fontSize, a, postGUI, types)
	buttons[#buttons+1] = {id=id,types=types,isMouseTick=false,isMouseType=false,isMouseColor={194, 197, 200},alpha=a or 255,target=dxCreateRenderTarget(w, h, true),clickX=0,clickY=0,postGUI=postGUI,text=text,x=x,y=y,w=w,h=h,size=0,tick=false,type="join",clicked=false,a=0,font=dx:getFont("rbt-r", fontSize)};

	if(#buttons == 1)then
		addEventHandler("onClientRender", root, render);
		img = dxCreateTexture("img/circle.png", "argb", false, "clamp");
	end;
end;

function destroyButton(id)
	for i,v in pairs(buttons) do
		if(v.id == id)then
			if(v.target and isElement(v.target))then
				destroyElement(v.target);
			end;

			buttons[i] = nil;

			if(#buttons < 1)then
				removeEventHandler("onClientRender", root, render);

				if(img and isElement(img))then
					destroyElement(img);
					img = false;
				end;
			end;

			break;
		end;
	end;
end;

function setButtonAlpha(id, a)
	for i,v in pairs(buttons) do
		if(v.id == id)then
			v.alpha = a or 255;
			break;
		end;
	end;
end;

function setButtonPosition(id, x, y)
	for i,v in pairs(buttons) do
		if(v.id == id)then
			v.x = x;
			v.y = y;
			break;
		end;
	end;
end;

function render()
	for i,v in pairs(buttons) do
		if(not v.types)then
			dxDrawRectangle(v.x, v.y, v.w, v.h, tocolor(26,26,34, v.alpha), v.postGUI);
		end;

	  	if(v.type == "join" and v.tick)then
	  		v.size = interpolateBetween(0, 0, 0, v.w*3, 0, 0, (getTickCount()-v.tick)/500, "Linear");
	    	v.a = interpolateBetween(0, 0, 0, 222, 0, 0, (getTickCount()-v.tick)/10, "Linear");

	  		if((getTickCount()-v.tick) > 500)then
	    		v.tick = getTickCount();
	      		v.type = "quit";
	  		end;
	  	elseif(v.type == "quit" and v.tick)then
	  		v.a = interpolateBetween(222, 0, 0, 0, 0, 0, (getTickCount()-v.tick)/300, "Linear");
	  	end;

		dxSetRenderTarget(v.target, true);
			dxDrawImage(v.clickX-v.size/2, v.clickY-v.size/2, v.size, v.size, img);
		dxSetRenderTarget();
		dxDrawImage(v.x, v.y, v.w+1, v.h, v.target, 0, 0, 0, tocolor(48,48,57, v.alpha > v.a and v.a or v.alpha), v.postGUI);

		if(v.isMouseType == "join")then
			v.isMouseColor[1], v.isMouseColor[2], v.isMouseColor[3] = interpolateBetween(v.isMouseColor[1], v.isMouseColor[2], v.isMouseColor[3], 199, 150, 35, (getTickCount()-v.isMouseTick)/100, "Linear");
		elseif(v.isMouseType == "quit")then
			v.isMouseColor[1], v.isMouseColor[2], v.isMouseColor[3] = interpolateBetween(v.isMouseColor[1], v.isMouseColor[2], v.isMouseColor[3], 194, 197, 200, (getTickCount()-v.isMouseTick)/100, "Linear");
		end;

		if(not v.types)then
			dxDrawRectangle(v.x, v.y+v.h-2, v.w, 2, tocolor(v.isMouseColor[1], v.isMouseColor[2], v.isMouseColor[3], v.alpha), v.postGUI);
			dxDrawText(v.text, v.x, v.y, v.x+v.w, v.y+v.h, tocolor(194, 197, 200, v.alpha), 1, v.font, "center", "center", false, false, v.postGUI);
		end;
		  
		if(isMouseInPosition(v.x, v.y, v.w, v.h))then
			v.isMouseTick = getTickCount();
			v.isMouseType = "join";
		elseif(not isMouseInPosition(v.x, v.y, v.w, v.h))then
			v.isMouseTick = getTickCount();
			v.isMouseType = "quit";
		end;

		if(getKeyState("mouse1") and not v.clicked and isMouseInPosition(v.x, v.y, v.w, v.h) and isCursorShowing())then
			local cX,cY = getCursorPosition();
			cX,cY = cX*sw,cY*sh;

			v.clicked = true;
			v.tick = getTickCount();
			v.type = "join";
			v.clickX, v.clickY = cX-v.x, cY-v.y;
			v.size = 0;
		elseif(not getKeyState("mouse1") and v.clicked)then
			v.clicked = false;
		end;
	end;
end;

--createButton("NR1", "Zaloguj", 500, 500, 150, 50, 4);
--showCursor(true,false)
--createButton("NR1", "Przycisk testowy nr. 1", 1000, 500, 300, 50, 10);
