
local Author 		= "knife9707"

local UseAutoUpdate = true --if the user dont want an autoupdate he can set it HERE to false
--[[Auto update]]--
local CurVer = 1.0 --our local version
local NetVersion = nil --netversion/the version of the script that is online, atm nil, we check it later
local NeedUpdate = false
local Do_Once = true
local ScriptName = "MasterYi - Eyeless Bladesman"
local Host = "http://github.com"
local NetFile = Host.."/knife9707/Script/raw/master/"..ScriptName..".lua" --here is the updated script hosted
local LocalFile = BOL_PATH.."Scripts\\"..ScriptName..".lua" --here is the local file stored

function CheckVersion(data)
    NetVersion = tonumber(data)
    if type(NetVersion) ~= "number" then return end
    if NetVersion and NetVersion > CurVer then --if the netversion is bigger then the local => script get an update
        print("<font color='#FF4000'> >> "..ScriptName..": New version available "..NetVersion..".</font>")
        print("<font color='#FF4000'> >> "..ScriptName..": Updating, please do not press F9 until update is finished.</font>")
        NeedUpdate = true  --if we need an update we set it to true
    else
        print("<font color='#00BFFF' >> "..ScriptName..": You have the lastest version.</font>")
    end
end

function UpdateScript()
    if Do_Once then    --we execute the upder just once@game start
        Do_Once = false --after the first start we set it to false, so we dont execute it twice        
        GetAsyncWebResult(Host, ScriptName.."ver.txt", CheckVersion) -- we check the version file, this lower the traffic and save time        
    end    
    if NeedUpdate then --if we need an update, we update
        NeedUpdate = false --one update is enough, so again false
        DownloadFile(NetFile, LocalFile, function() --we download the online version and overwrite the local
        if FileExist(LocalFile) then
            print("<font color='#00BFFF'> >> "..ScriptName..": Successfully updated v"..CurVer.." -> v"..NetVersion.." - Please reload.</font>")                                
        end
    end
                )
    end
end
if UseAutoUpdate then AddTickCallback(UpdateScript) end
--[[/Auto update]]--

if myHero.charName ~= "MasterYi" then return end

local levelSequence = {1,3,1,2,1,4,1,3,1,3,4,3,2,3,2,4,2,2}
local lastAttack, lastWindUpTime, lastAttackCD = 0, 0, 0
local myTrueRange = 0
-- These variables need to be near the top of your script so you can call them in your callbacks.
HWID = Base64Encode(tostring(os.getenv("PROCESSOR_IDENTIFIER")..os.getenv("USERNAME")..os.getenv("COMPUTERNAME")..os.getenv("PROCESSOR_LEVEL")..os.getenv("PROCESSOR_REVISION")))
-- DO NOT CHANGE. This is set to your proper ID.
id = 261

-- CHANGE ME. Make this the exact same name as the script you added into the site!
ScriptName = "MasterYiEyelessBladesman3"

-- Thank you to Roach and Bilbao for the support!
assert(load(Base64Decode("G0x1YVIAAQQEBAgAGZMNChoKAAAAAAAAAAAAAQIDAAAAJQAAAAgAAIAfAIAAAQAAAAQKAAAAVXBkYXRlV2ViAAEAAAACAAAADAAAAAQAETUAAAAGAUAAQUEAAB2BAAFGgUAAh8FAAp0BgABdgQAAjAHBAgFCAQBBggEAnUEAAhsAAAAXwAOAjMHBAgECAgBAAgABgUICAMACgAEBgwIARsNCAEcDwwaAA4AAwUMDAAGEAwBdgwACgcMDABaCAwSdQYABF4ADgIzBwQIBAgQAQAIAAYFCAgDAAoABAYMCAEbDQgBHA8MGgAOAAMFDAwABhAMAXYMAAoHDAwAWggMEnUGAAYwBxQIBQgUAnQGBAQgAgokIwAGJCICBiIyBxQKdQQABHwCAABcAAAAECAAAAHJlcXVpcmUABAcAAABzb2NrZXQABAcAAABhc3NlcnQABAQAAAB0Y3AABAgAAABjb25uZWN0AAQQAAAAYm9sLXRyYWNrZXIuY29tAAMAAAAAAABUQAQFAAAAc2VuZAAEGAAAAEdFVCAvcmVzdC9uZXdwbGF5ZXI/aWQ9AAQHAAAAJmh3aWQ9AAQNAAAAJnNjcmlwdE5hbWU9AAQHAAAAc3RyaW5nAAQFAAAAZ3N1YgAEDQAAAFteMC05QS1aYS16XQAEAQAAAAAEJQAAACBIVFRQLzEuMA0KSG9zdDogYm9sLXRyYWNrZXIuY29tDQoNCgAEGwAAAEdFVCAvcmVzdC9kZWxldGVwbGF5ZXI/aWQ9AAQCAAAAcwAEBwAAAHN0YXR1cwAECAAAAHBhcnRpYWwABAgAAAByZWNlaXZlAAQDAAAAKmEABAYAAABjbG9zZQAAAAAAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQA1AAAAAgAAAAIAAAACAAAAAgAAAAIAAAACAAAAAgAAAAMAAAADAAAAAwAAAAMAAAAEAAAABAAAAAUAAAAFAAAABQAAAAYAAAAGAAAABwAAAAcAAAAHAAAABwAAAAcAAAAHAAAABwAAAAgAAAAHAAAABQAAAAgAAAAJAAAACQAAAAkAAAAKAAAACgAAAAsAAAALAAAACwAAAAsAAAALAAAACwAAAAsAAAAMAAAACwAAAAkAAAAMAAAADAAAAAwAAAAMAAAADAAAAAwAAAAMAAAADAAAAAwAAAAGAAAAAgAAAGEAAAAAADUAAAACAAAAYgAAAAAANQAAAAIAAABjAAAAAAA1AAAAAgAAAGQAAAAAADUAAAADAAAAX2EAAwAAADUAAAADAAAAYWEABwAAADUAAAABAAAABQAAAF9FTlYAAQAAAAEAEAAAAEBvYmZ1c2NhdGVkLmx1YQADAAAADAAAAAIAAAAMAAAAAAAAAAEAAAAFAAAAX0VOVgA="), nil, "bt", _ENV))()

local SxOW_downloadNeeded, SxOW_downloadName = false, "SxOrbWalk"

function AfterDownload()
	SxOW_downloadNeeded = false
	print("<font color=\"#FF0000\">MasterYi - Eyeless Bladesman:</font> <font color=\"#FFFFFF\">Orbwalker library downloaded successfully, please reload (double F9).</font>")
end

local SxOW_fileName = LIB_PATH .. SxOW_downloadName .. ".lua"

if FileExist(SxOW_fileName) then
	require(SxOW_downloadName)
else
	SxOW_downloadNeeded = true

	LuaSocket = require("socket")
	ScriptSocket = LuaSocket.connect("sx-bol.eu", 80)
	ScriptSocket:send("GET /BoL/TCPUpdater/GetScript.php?script=raw.githubusercontent.com/Superx321/BoL/master/common/SxOrbWalk.lua&rand=" .. tostring(math.random(1000)) .. " HTTP/1.0\r\n\r\n")
	ScriptReceive, ScriptStatus = ScriptSocket:receive('*a')
	ScriptRaw = string.sub(ScriptReceive, string.find(ScriptReceive, "<bols" .. "cript>") + 11, string.find(ScriptReceive, "</bols" .. "cript>") - 1)
	ScriptFileOpen = io.open(SxOW_fileName, "w+")
	ScriptFileOpen:write(ScriptRaw)
	ScriptFileOpen:close()

	DelayAction(function() AfterDownload() end, 0.3)
end

if SxOW_downloadNeeded then return end

function OnLoad()
	Variables()
	Menu()
	myTrueRange = myHero.range + GetDistance(myHero.minBBox)
		UpdateWeb(true, ScriptName, id, HWID)
end

function OnTick()

	if MasterYiMenu.combo.comboKey then
		Combo(Target)
	end
	if MasterYiMenu.harass.harassKey then
		Harass(Target)
	end
	if MasterYiMenu.farming.farmKey then
		Farm()
	end
	if MasterYiMenu.jungle.jungleKey then
		JungleClear()
	end

	if MasterYiMenu.ks.killSteal then
		KillSteal()
	end

		--[[ Auto Level ]]--
	if MasterYiMenu.misc.autoLevel then
		autoLevelSetSequence(levelSequence)
	end
	
	if MasterYiMenu.misc.ult.Enable then
		if CountEnemyHeroInRange(125) >= MasterYiMenu.misc.ult.minEnemies then
					if not VIP_USER or not MasterYiMenu.misc.cast.usePackets then
			CastSpell(_R, unit)
		elseif VIP_USER and MasterYiMenu.misc.cast.usePackets then
			Packet("S_CAST", { spellId = _R, Target }):send()
		end
		end
	end

	TickChecks()
	
		if GetGame().isOver then
	UpdateWeb(false, ScriptName, id, HWID)
	-- This is a var where I stop executing what is in my OnTick()
	startUp = false;
end
	
end

function Variables()
	if GetGame().map.shortName == "twistedTreeline" then
		TTMAP = true
	else
		TTMAP = false
	end

	SpellQ = { name = "Alpha Strike",			range = 600,			ready = false, dmg = 0, manaUsage = 0						}
	SpellW = { name = "Meditate",				range = myHero.range,	ready = false, dmg = 0, manaUsage = 0						}
	SpellE = { name = "Wuju Style",			range = myHero.range,			ready = false, dmg = 0, manaUsage = 0,	variable = false	}
	SpellR = { name = "Highlander",	range = myHero.range																			}

	SpellI = { name = "SummonerDot",			range = 600,			ready = false, dmg = 0,					variable = nil		}

	enemyMinions	= minionManager(MINION_ENEMY,	SpellQ.range, myHero.visionPos, MINION_SORT_HEALTH_ASC)

	JungleMobs = {}
	JungleFocusMobs = {}

	priorityTable = {
			AP = {
				"Annie", "Ahri", "Akali", "Anivia", "Annie", "Brand", "Cassiopeia", "Diana", "Evelynn", "FiddleSticks", "Fizz", "Gragas", "Heimerdinger", "Karthus",
				"Kassadin", "Katarina", "Kayle", "Kennen", "Leblanc", "Lissandra", "Lux", "Malzahar", "Mordekaiser", "Morgana", "Nidalee", "Orianna",
				"Ryze", "Sion", "Swain", "Syndra", "Teemo", "TwistedFate", "Veigar", "Viktor", "Vladimir", "Xerath", "Ziggs", "Zyra"
			},
			Support = {
				"Alistar", "Blitzcrank", "Janna", "Karma", "Leona", "Lulu", "Nami", "Nunu", "Sona", "Soraka", "Taric", "Thresh", "Zilean"
			},
			Tank = {
				"Amumu", "Chogath", "DrMundo", "Galio", "Hecarim", "Malphite", "Maokai", "Nasus", "Rammus", "Sejuani", "Nautilus", "Shen", "Singed", "Skarner", "Volibear",
				"Warwick", "Yorick", "Zac"
			},
			ADC = {
				"Ashe", "Caitlyn", "Corki", "Draven", "Ezreal", "Graves", "Jayce", "Jinx", "KogMaw", "Lucian", "MasterYi", "MissFortune", "Pantheon", "Quinn", "Shaco", "Sivir",
				"Talon","Tryndamere", "Tristana", "Twitch", "Urgot", "Varus", "Vayne", "Yasuo", "Zed"
			},
			Bruiser = {
				"Aatrox", "Darius", "Elise", "Fiora", "Gangplank", "Garen", "Irelia", "JarvanIV", "MasterYi", "Khazix", "LeeSin", "Nocturne", "Olaf", "Poppy",
				"Renekton", "Rengar", "Riven", "Rumble", "Shyvana", "Trundle", "Udyr", "Vi", "MonkeyKing", "XinZhao"
			}
		}

	--[[InterruptingSpells = {
		["AbsoluteZero"]				= true,
		["AlZaharNetherGrasp"]			= true,
		["CaitlynAceintheHole"]			= true,
		["Crowstorm"]					= true,
		["DrainChannel"]				= true,
		["FallenOne"]					= true,
		["GalioIdolOfDurand"]			= true,
		["InfiniteDuress"]				= true,
		["KatarinaR"]					= true,
		["MissFortuneBulletTime"]		= true,
		["Teleport"]					= true,
		["Pantheon_GrandSkyfall_Jump"]	= true,
		["ShenStandUnited"]				= true,
		["UrgotSwap2"]					= true
	}  ]]--
	Items = {
		["BLACKFIRE"]	= { id = 3188, range = 750 },
		["BRK"]			= { id = 3153, range = 500 },
		["BWC"]			= { id = 3144, range = 450 },
		["DFG"]			= { id = 3128, range = 750 },
		["HXG"]			= { id = 3146, range = 700 },
		["ODYNVEIL"]	= { id = 3180, range = 525 },
		["DVN"]			= { id = 3131, range = 200 },
		["ENT"]			= { id = 3184, range = 350 },
		["HYDRA"]		= { id = 3074, range = 350 },
		["TIAMAT"]		= { id = 3077, range = 350 },
		["YGB"]			= { id = 3142, range = 350 }
	}

	if TTMAP then --
		FocusJungleNames = {
			["TT_NWraith1.1.1"]		= true,
			["TT_NGolem2.1.1"]		= true,
			["TT_NWolf3.1.1"]		= true,
			["TT_NWraith4.1.1"]		= true,
			["TT_NGolem5.1.1"]		= true,
			["TT_NWolf6.1.1"]		= true,
			["TT_Spiderboss8.1.1"]	= true
		}		
		JungleMobNames = {
			["TT_NWraith21.1.2"]	= true,
			["TT_NWraith21.1.3"]	= true,
			["TT_NGolem22.1.2"]		= true,
			["TT_NWolf23.1.2"]		= true,
			["TT_NWolf23.1.3"]		= true,
			["TT_NWraith24.1.2"]	= true,
			["TT_NWraith24.1.3"]	= true,
			["TT_NGolem25.1.1"]		= true,
			["TT_NWolf26.1.2"]		= true,
			["TT_NWolf26.1.3"]		= true
		}
	else 
		JungleMobNames = { 
			["Wolf8.1.2"]			= true,
			["Wolf8.1.3"]			= true,
			["YoungLizard7.1.2"]	= true,
			["YoungLizard7.1.3"]	= true,
			["LesserWraith9.1.3"]	= true,
			["LesserWraith9.1.2"]	= true,
			["LesserWraith9.1.4"]	= true,
			["YoungLizard10.1.2"]	= true,
			["YoungLizard10.1.3"]	= true,
			["SmallGolem11.1.1"]	= true,
			["Wolf2.1.2"]			= true,
			["Wolf2.1.3"]			= true,
			["YoungLizard1.1.2"]	= true,
			["YoungLizard1.1.3"]	= true,
			["LesserWraith3.1.3"]	= true,
			["LesserWraith3.1.2"]	= true,
			["LesserWraith3.1.4"]	= true,
			["YoungLizard4.1.2"]	= true,
			["YoungLizard4.1.3"]	= true,
			["SmallGolem5.1.1"]		= true
		}
		FocusJungleNames = {
			["Dragon6.1.1"]			= true,
			["Worm12.1.1"]			= true,
			["GiantWolf8.1.1"]		= true,
			["AncientGolem7.1.1"]	= true,
			["Wraith9.1.1"]			= true,
			["LizardElder10.1.1"]	= true,
			["Golem11.1.2"]			= true,
			["GiantWolf2.1.1"]		= true,
			["AncientGolem1.1.1"]	= true,
			["Wraith3.1.1"]			= true,
			["LizardElder4.1.1"]	= true,
			["Golem5.1.2"]			= true,
			["GreatWraith13.1.1"]	= true,
			["GreatWraith14.1.1"]	= true
		}
	end

	enemyCount = 0
	enemyTable = {}

	for i = 1, heroManager.iCount do
		local champ = heroManager:GetHero(i)
        
		if champ.team ~= player.team then
			enemyCount = enemyCount + 1
			enemyTable[enemyCount] = { player = champ, indicatorText = "", damageGettingText = "", ultAlert = false, ready = true}
		end
    end

    for i = 0, objManager.maxObjects do
		local object = objManager:getObject(i)
		if object and object.valid and not object.dead then
			if FocusJungleNames[object.name] then
				JungleFocusMobs[#JungleFocusMobs+1] = object
			elseif JungleMobNames[object.name] then
				JungleMobs[#JungleMobs+1] = object
			end
		end
	end
end

function Menu()
	MasterYiMenu = scriptConfig("MasterYi - Eyeless Bladesman", "MasterYi")
	
	MasterYiMenu:addSubMenu("[" .. myHero.charName .. "] - Combo Settings", "combo")
		MasterYiMenu.combo:addParam("comboKey", "Full Combo Key (SBTW)", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		MasterYiMenu.combo:addParam("useW", "Use " .. SpellW.name .. " (W) in Combo", SCRIPT_PARAM_ONOFF, true)
		MasterYiMenu.combo:addParam("comboItems", "Use Items in Combo", SCRIPT_PARAM_ONOFF, true)
		MasterYiMenu.combo:permaShow("comboKey")
	
	MasterYiMenu:addSubMenu("[" .. myHero.charName .. "] - Harass Settings", "harass")
		MasterYiMenu.harass:addParam("harassKey", "Harass key (C)", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("C"))
		MasterYiMenu.harass:addParam("useQ", "Use " .. SpellQ.name .. " (Q) in Harass", SCRIPT_PARAM_ONOFF, true)
		MasterYiMenu.harass:addParam("useE", "Use " .. SpellE.name .. " (E) in Harass", SCRIPT_PARAM_ONOFF, true)
		MasterYiMenu.harass:addParam("harassMana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
		MasterYiMenu.harass:permaShow("harassKey")
		
	
	MasterYiMenu:addSubMenu("[" .. myHero.charName .. "] - Farm Settings", "farming")
		MasterYiMenu.farming:addParam("farmKey", "Farming Key (X)", SCRIPT_PARAM_ONKEYDOWN, false, GetKey('X'))
		MasterYiMenu.farming:addParam("qFarm", "Farm with " .. SpellQ.name .. " (Q)", SCRIPT_PARAM_ONOFF, true)
		MasterYiMenu.farming:addParam("FarmMana", "Min. Mana Percent: ", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
		MasterYiMenu.farming:permaShow("farmKey")
		
	MasterYiMenu:addSubMenu("[" .. myHero.charName .. "] - Jungle Clear Settings", "jungle")
		MasterYiMenu.jungle:addParam("jungleKey", "Jungle Clear Key (V)", SCRIPT_PARAM_ONKEYDOWN, false, GetKey('V'))
		MasterYiMenu.jungle:addParam("jungleQ", "Clear with " .. SpellQ.name .. " (Q)", SCRIPT_PARAM_ONOFF, true)
		MasterYiMenu.jungle:addParam("jungleE", "Clear with " .. SpellE.name .. " (E)", SCRIPT_PARAM_ONOFF, true)
		MasterYiMenu.jungle:permaShow("jungleKey")
		
		
	MasterYiMenu:addSubMenu("[" .. myHero.charName .. "] - KillSteal Settings", "ks")
		MasterYiMenu.ks:addParam("killSteal", "Use Smart Kill Steal", SCRIPT_PARAM_ONOFF, true)
		MasterYiMenu.ks:addParam("autoIgnite", "Auto Ignite", SCRIPT_PARAM_ONOFF, true)
		MasterYiMenu.ks:permaShow("killSteal")
			
	MasterYiMenu:addSubMenu("[" .. myHero.charName .. "] - Draw Settings", "drawing")	
		MasterYiMenu.drawing:addParam("mDraw", "Disable All Range Draws", SCRIPT_PARAM_ONOFF, false)
		MasterYiMenu.drawing:addParam("Target", "Draw Circle on Target", SCRIPT_PARAM_ONOFF, true)
		MasterYiMenu.drawing:addParam("cDraw", "Draw Damage Text", SCRIPT_PARAM_ONOFF, true)
		MasterYiMenu.drawing:addParam("qDraw", "Draw " .. SpellQ.name .. " (Q) Range", SCRIPT_PARAM_ONOFF, true)
		MasterYiMenu.drawing:addParam("eDraw", "Draw " .. SpellE.name .. " (E) Range", SCRIPT_PARAM_ONOFF, true)
	
	MasterYiMenu:addSubMenu("[" .. myHero.charName .. "] - Misc Settings", "misc")
	MasterYiMenu.misc:addParam("autoLevel", "Auto level spells", SCRIPT_PARAM_ONOFF, false)
		if VIP_USER then
			MasterYiMenu.misc:addSubMenu("Spells - Cast Settings", "cast")
				MasterYiMenu.misc.cast:addParam("usePackets", "Use Packets to Cast Spells", SCRIPT_PARAM_ONOFF, false)
		end
		MasterYiMenu.misc:addSubMenu("Spells - " .. SpellQ.name .. " (Q) Settings", "q")
			MasterYiMenu.misc.q:addParam("howTo", "Use " .. SpellQ.name .. " (Q): ", SCRIPT_PARAM_LIST, 1, { "Always", "Only as a Gap-Closer", "If target not in E Range" })
		MasterYiMenu.misc:addSubMenu("Spells - " .. SpellR.name .. " (R) Settings", "ult")
			MasterYiMenu.misc.ult:addParam("Enable", "Enable Auto Ult", SCRIPT_PARAM_ONOFF, true)
			MasterYiMenu.misc.ult:addParam("minEnemies", "Min. Enemies in Range: ", SCRIPT_PARAM_SLICE, 1, 1, 5, 0)

		MasterYiMenu:addSubMenu("[" .. myHero.charName .. "] - Orbwalking Settings", "Orbwalking")
			SxOrb:LoadToMenu(MasterYiMenu.Orbwalking, false)

	TargetSelector = TargetSelector(TARGET_LESS_CAST, SpellQ.range, DAMAGE_PHYSICAL)
	TargetSelector.name = "MasterYi"
	MasterYiMenu:addTS(TargetSelector)

	MasterYiMenu:addParam("CurVer", "CurVer: ", SCRIPT_PARAM_INFO, CurVer)
	MasterYiMenu:addParam("Author", "Author: ", SCRIPT_PARAM_INFO, Author)
end

function OnProcessSpell(unit, spell)
	if unit == myHero then
		if spell.name:lower():find("attack") then
			lastAttack = GetTickCount() - GetLatency()/2
			lastWindUpTime = spell.windUpTime*1000
			lastAttackCD = spell.animationTime*1000
		end 
	end

	end

	function _OrbWalk()
	if Target ~=nil and GetDistance(Target) <= myTrueRange then		
		if timeToShoot() then
			packetAttack(Target)
		elseif heroCanMove()  then
			packetAttack(Target)
					if not VIP_USER or not MasterYiMenu.misc.cast.usePackets then
			CastSpell(_W, unit)
		elseif VIP_USER and MasterYiMenu.misc.cast.usePackets then
			Packet("S_CAST", { spellId = _W, Target }):send()
		end
			packetAttack(Target)
		end
	end
end
	
function OnCreateObj(obj)
	if obj.valid then
		if FocusJungleNames[obj.name] then
			JungleFocusMobs[#JungleFocusMobs+1] = obj
		elseif JungleMobNames[obj.name] then
			JungleMobs[#JungleMobs+1] = obj
		end
	end
end

function OnDeleteObj(obj)
	for i, Mob in pairs(JungleMobs) do
		if obj.name == Mob.name then
			table.remove(JungleMobs, i)
		end
	end
	for i, Mob in pairs(JungleFocusMobs) do
		if obj.name == Mob.name then
			table.remove(JungleFocusMobs, i)
		end
	end
end

function OnDraw()
	if not myHero.dead then
		if not MasterYiMenu.drawing.mDraw then
			if MasterYiMenu.drawing.qDraw and SpellQ.ready then
				DrawCircle(myHero.x, myHero.y, myHero.z, SpellQ.range, ARGB(255,178, 0 , 0 ))
			end
			if MasterYiMenu.drawing.eDraw and SpellE.ready then
				DrawCircle(myHero.x, myHero.y, myHero.z, SpellE.range, ARGB(255, 32,178,170))
			end
		end
		if MasterYiMenu.drawing.Target then
			if Target ~= nil then
				DrawCircle3D(Target.x, Target.y, Target.z, 70, 1, ARGB(255, 255, 0, 0))
			end
		end
		if MasterYiMenu.drawing.cDraw then
			for i = 1, enemyCount do
				local enemy = enemyTable[i].player

				if ValidTarget(enemy) and enemy.visible then
					local barPos = WorldToScreen(D3DXVECTOR3(enemy.x, enemy.y, enemy.z))
					local pos = { X = barPos.x - 35, Y = barPos.y - 50 }

					DrawText(enemyTable[i].indicatorText, 15, pos.X, pos.Y, (enemyTable[i].ready and ARGB(255, 0, 255, 0)) or ARGB(255, 255, 220, 0))
					DrawText(enemyTable[i].damageGettingText, 15, pos.X, pos.Y + 15, ARGB(255, 255, 0, 0))
				end
			end
		end
	end
end

function TickChecks()
	-- Checks if Spells Ready
	SpellQ.ready = (myHero:CanUseSpell(_Q) == READY)
	SpellW.ready = (myHero:CanUseSpell(_W) == READY)
	SpellE.ready = (myHero:CanUseSpell(_E) == READY)
	SpellR.ready = (myHero:CanUseSpell(_R) == READY)

	SpellQ.manaUsage = myHero:GetSpellData(_Q).mana
	SpellW.manaUsage = myHero:GetSpellData(_W).mana
	SpellE.manaUsage = myHero:GetSpellData(_E).mana
	SpellR.manaUsage = myHero:GetSpellData(_R).mana

	if myHero:GetSpellData(SUMMONER_1).name:find(SpellI.name) then
		SpellI.variable = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find(SpellI.name) then
		SpellI.variable = SUMMONER_2
	end
	SpellI.ready = (SpellI.variable ~= nil and myHero:CanUseSpell(SpellI.variable) == READY)

	TargetSelector.range = TargetSelectorRange()

	Target = GetCustomTarget()
	SxOrb:ForceTarget(Target)

	DmgCalc()

	if not MasterYiMenu.combo.comboKey and not MasterYiMenu.farming.farmKey and not MasterYiMenu.harass.harassKey and not MasterYiMenu.jungle.jungleKey then
		for i, cb in ipairs(SxOrb.AfterAttackCallbacks) do
			table.remove(SxOrb.AfterAttackCallbacks, i)
		end
	end
end

function GetCustomTarget()
	TargetSelector:update()
    if _G.MMA_Target and _G.MMA_Target.type == myHero.type then
    	return _G.MMA_Target
   	elseif _G.AutoCarry and _G.AutoCarry.Crosshair and _G.AutoCarry.Attack_Crosshair then
   		return _G.AutoCarry.Attack_Crosshair.target
   	elseif TargetSelector.target and not TargetSelector.target.dead and TargetSelector.target.type  == myHero.type then
    	return TargetSelector.target
    else
    	return nil
    end
end

function UseItems(unit)
	for i, Item in pairs(Items) do
		local Item = Items[i]
		if GetInventoryItemIsCastable(Item.id) and GetDistanceSqr(unit) <= Item.range * Item.range then
			CastItem(Item.id, unit)
		end
	end
end

function Combo(unit)
	if ValidTarget(unit) and unit ~= nil and unit.type == myHero.type then
		
		CastQ(unit)
				
		CastE(unit)

		_OrbWalk()
		if MasterYiMenu.combo.comboItems then
			UseItems(unit)
		end

	end
end

function Harass(unit)
	if ValidTarget(unit) and unit ~= nil and unit.type == myHero.type then
		if not isLow('Mana', myHero, MasterYiMenu.harass.harassMana) then
			if GetDistanceSqr(unit, myHero) <= SpellQ.range * SpellQ.range and MasterYiMenu.harass.useQ and SpellQ.ready then
				CastSpell(_W)
			elseif not MasterYiMenu.harass.useQ then
				SxOrb:RegisterAfterAttackCallback(function()
												CastSpell(_W)
											end)
			end
			if MasterYiMenu.harass.useE then
				CastE(unit)
			end
			if MasterYiMenu.harass.useQ then
				CastQ(unit)
			end
		end
	end
end

function Farm()
	enemyMinions:update()
	for i, minion in pairs(enemyMinions.objects) do
		if ValidTarget(minion) and minion ~= nil then
			if minion.health <= SpellQ.dmg and (not SxOrb:CanAttack() or GetDistanceSqr(minion, myHero) > SxOrb.MyRange * SxOrb.MyRange) and MasterYiMenu.farming.qFarm and not isLow('Mana', myHero, MasterYiMenu.farming.FarmMana) then
				CastQ(minion)
			end
		end		 
	end
end

function JungleClear()
	if MasterYiMenu.jungle.jungleKey then
		local JungleMob = GetJungleMob()
		if JungleMob ~= nil then
			if MasterYiMenu.jungle.jungleE then
				CastE(JungleMob)
			end
			if MasterYiMenu.jungle.jungleQ then
				CastQ(JungleMob)
			end
			if MasterYiMenu.combo.useW then
			if MasterYiMenu.misc.w.howTo ~= 3 then
				SxOrb.RegisterAfterAttackCallback(function()
													CastSpell(_W)
												end)
			else
				if GetDistanceSqr(JungleMob, myHero) <= SxOrb.MyRange * SxOrb.MyRange then
					CastSpell(_W)
				end
			end
		end
		end
	end
end

function CastQ(unit)
	if unit == nil or not SpellQ.ready or (GetDistanceSqr(unit, myHero) > SpellQ.range * SpellQ.range) then
		return false
	end
	if MasterYiMenu.misc.q.howTo == 1 or (MasterYiMenu.misc.q.howTo == 2 and GetDistanceSqr(unit, myHero) > SxOrb.MyRange * SxOrb.MyRange) or (MasterYiMenu.misc.q.howTo == 3 and GetDistanceSqr(unit, myHero) > SpellE.range * SpellE.range) then
		if not VIP_USER or not MasterYiMenu.misc.cast.usePackets then
			CastSpell(_Q, unit)
		elseif VIP_USER and MasterYiMenu.misc.cast.usePackets then
			Packet("S_CAST", { spellId = _Q,targetNetworkId = unit.networkID}):send()
		end
	end
end


function CastE(unit)
	if unit == nil or not SpellE.ready or SpellE.variable then
		return false
	end
		if not VIP_USER or not MasterYiMenu.misc.cast.usePackets then
			CastSpell(_E, unit)
		elseif VIP_USER and MasterYiMenu.misc.cast.usePackets then
			Packet("S_CAST", { spellId = _E,targetNetworkId = unit.networkID}):send()
		end
	end

function ArrangePriorities()
	for i = 1, enemyCount do
		local enemy = enemyTable[i].player
		SetPriority(priorityTable.ADC, enemy, 1)
		SetPriority(priorityTable.AP, enemy, 2)
		SetPriority(priorityTable.Support, enemy, 3)
		SetPriority(priorityTable.Bruiser, enemy, 4)
		SetPriority(priorityTable.Tank, enemy, 5)
	end
end

function ArrangeTTPriorities()
	for i = 1, enemyCount do
		local enemy = enemyTable[i].player
		SetPriority(priorityTable.ADC, enemy, 1)
		SetPriority(priorityTable.AP, enemy, 1)
		SetPriority(priorityTable.Support, enemy, 2)
		SetPriority(priorityTable.Bruiser, enemy, 2)
		SetPriority(priorityTable.Tank, enemy, 3)
	end
end
function SetPriority(table, hero, priority)
	for i = 1, #table do
		if hero.charName:find(table[i]) ~= nil then
			TS_SetHeroPriority(priority, hero.charName)
		end
	end
end

function GetJungleMob()
	for _, Mob in pairs(JungleFocusMobs) do
		if ValidTarget(Mob, SpellQ.range) then return Mob end
	end
	for _, Mob in pairs(JungleMobs) do
		if ValidTarget(Mob, SpellQ.range) then return Mob end
	end
end

function getMousePos(range)
	local temprange = range or SpellW_.range
	local MyPos = Vector(myHero.x, myHero.y, myHero.z)
	local MousePos = Vector(mousePos.x, mousePos.y, mousePos.z)

	return MyPos - (MyPos - MousePos):normalized() * SpellW_.range
end

function moveToCursor()
	if GetDistance(mousePos) then
		local moveToPos = myHero + (Vector(mousePos) - myHero):normalized()*300
		if not VIP_USER then
			myHero:MoveTo(moveToPos.x, moveToPos.z)
		else
			Packet('S_MOVE', {x = moveToPos.x, y = moveToPos.z}):send()
		end
	end		
end

function TargetSelectorRange()
	return SpellQ.ready and SpellQ.range or SpellE.range
end

function DmgCalc()
	for i = 1, enemyCount do
		local enemy = enemyTable[i].player
		if ValidTarget(enemy) and enemy.visible then
			SpellQ.dmg = (SpellQ.ready and getDmg("Q",		enemy, myHero	)) or 0
			SpellW.dmg = (SpellQ.ready and getDmg("W",		enemy, myHero	)) or 0
			SpellE.dmg = (SpellE.ready and getDmg("E",		enemy, myHero	)) or 0
			SpellI.dmg = (SpellI.ready and getDmg("IGNITE", enemy, myHero	)) or 0

			if enemy.health < SpellQ.dmg then
				enemyTable[i].indicatorText = "Q Kill"
				enemyTable[i].ready = SpellQ.ready and SpellQ.manaUsage <= myHero.mana
			elseif enemy.health < SpellQ.dmg + SpellI.dmg then
				enemyTable[i].indicatorText = "Q + Ign Kill"
				enemyTable[i].ready = SpellQ.ready and SpellI.ready and SpellQ.manaUsage <= myHero.mana
			elseif enemy.health < SpellW.dmg then
				enemyTable[i].indicatorText = "W Kill"
				enemyTable[i].ready = SpellW.ready and SpellW.manaUsage <= myHero.mana
			elseif enemy.health < SpellW.dmg + SpellI.dmg then
				enemyTable[i].indicatorText = "W + Ign Kill"
				enemyTable[i].ready = SpellW.ready and SpellI.ready and SpellW.manaUsage <= myHero.mana
			elseif enemy.health < SpellE.dmg then
				enemyTable[i].indicatorText = "E Kill"
				enemyTable[i].ready = SpellE.ready and SpellE.manaUsage <= myHero.mana
			elseif enemy.health < SpellE.dmg + SpellI.dmg then
				enemyTable[i].indicatorText = "E + Ign Kill"
				enemyTable[i].ready = SpellE.ready and SpellI.ready and SpellE.manaUsage <= myHero.mana
			elseif enemy.health < SpellQ.dmg + SpellW.dmg then
				enemyTable[i].indicatorText = "Q + W Kill"
				enemyTable[i].ready = SpellQ.ready and SpellW.ready and SpellQ.manaUsage + SpellW.manaUsage <= myHero.mana
			elseif enemy.health < SpellQ.dmg + SpellW.dmg + SpellI.dmg then
				enemyTable[i].indicatorText = "Q + W + Ign Kill"
				enemyTable[i].ready = SpellQ.ready and SpellW.ready and SpellI.ready and SpellQ.manaUsage + SpellW.manaUsage <= myHero.mana
			else
				local dmgTotal = SpellQ.dmg + SpellW.dmg + SpellE.dmg
				local hpLeft = math.round(enemy.health - dmgTotal)
				local percentLeft = math.round(hpLeft / enemy.maxHealth * 100)

				enemyTable[i].indicatorText = percentLeft .. "% Harass"
				enemyTable[i].ready = SpellQ.ready and SpellE.ready and SpellR.ready
			end

			local enemyAD = getDmg("AD", myHero, enemy)

			enemyTable[i].damageGettingText = enemy.charName .. " kills me with " .. math.ceil(myHero.health / enemyAD) .. " hits"
		end
	end
end

function KillSteal()
	for i = 1, enemyCount do
		local enemy = enemyTable[i].player
		if ValidTarget(enemy) and enemy.visible then
			if enemy.health < SpellQ.dmg then
				CastQ(enemy)
			elseif enemy.health < SpellQ.dmg + SpellW.dmg and GetDistanceSqr(enemy, myHero) <= SpellQ.range * SpellQ.range and SpellQ.ready and SpellW.ready and MasterYiMenu.ks.useW then
				CastSpell(_W)
				CastQ(enemy)
			end

			if MasterYiMenu.ks.autoIgnite then
				AutoIgnite(enemy)
			end
		end
	end
end

function AutoIgnite(unit)
	if unit.health < SpellI.dmg and GetDistanceSqr(unit) <= SpellI.range * SpellI.range then
		if SpellI.ready then
			CastSpell(SpellI.variable, unit)
		end
	end
end

function isLow(what, unit, slider)
	if what == 'Mana' then
		if unit.mana < (unit.maxMana * (slider / 100)) then
			return true
		else
			return false
		end
	elseif what == 'HP' then
		if unit.health < (unit.maxHealth * (slider / 100)) then
			return true
		else
			return false
		end
	end
end

function heroCanMove()
	return (GetTickCount() + GetLatency()/2 > lastAttack + lastWindUpTime + 20)
end 
 
function timeToShoot()
	return (GetTickCount() + GetLatency()/2 > lastAttack + lastAttackCD)
end 

function packetAttack(enemy)
    Packet('S_MOVE', {type = 3, Target}):send()
end

function OnBugsplat()
	UpdateWeb(false, ScriptName, id, HWID)
end

function OnUnload()
	UpdateWeb(false, ScriptName, id, HWID)
end

