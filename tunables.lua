-- MISE À JOUR AUTOMATIQUE DE TUNABLES.LUA

local VERSION_URL = "https://raw.githubusercontent.com/BleuDragonViolet/tunables-update/main/version.txt"
local LUA_URL = "https://raw.githubusercontent.com/BleuDragonViolet/tunables-update/main/tunables.lua"
local LOCAL_VERSION_FILE = filesystem.scripts_dir() .. "HC_version.txt"
local LOCAL_TUNABLES_FILE = filesystem.scripts_dir() .. "tunables.lua"

-- Lire la version locale stockée dans HC_version.txt
local function read_local_version()
    if filesystem.exists(LOCAL_VERSION_FILE) then
        local f = io.open(LOCAL_VERSION_FILE, "r")
        local v = f:read("*a")
        f:close()
        return v:gsub("%s+", "")
    else
        return "none"
    end
end

-- Écrire la version locale après mise à jour
local function write_local_version(version)
    local f = io.open(LOCAL_VERSION_FILE, "w")
    f:write(version)
    f:close()
end

-- Vérifie la version distante et met à jour le fichier tunables.lua si besoin
web.get(VERSION_URL, function(remote_version, status_code)
    if status_code ~= 200 then
        util.toast("[HC Update] Erreur : impossible de récupérer version.txt")
        return
    end

    local local_version = read_local_version()
    if remote_version:gsub("%s+", "") ~= local_version then
        util.toast("[HC Update] Nouvelle version détectée, téléchargement...")

        web.get(LUA_URL, function(lua_data, lua_status)
            if lua_status ~= 200 then
                util.toast("[HC Update] Erreur : téléchargement de tunables.lua échoué")
                return
            end

            local f = io.open(LOCAL_TUNABLES_FILE, "w")
            f:write(lua_data)
            f:close()

            write_local_version(remote_version)
            util.toast("[HC Update] tunables.lua mis à jour avec succès.")
        end)
    else
        util.toast("[HC Update] Fichier déjà à jour.")
    end
end)
HC_DIR = filesystem.store_dir() .. "Heist Control\\"
        FolderDirs = {
            Img = HC_DIR .. "Image\\",
            Setting = HC_DIR .. "Setting\\",
            Lang = HC_DIR .. "Language\\",
            HaxUI = HC_DIR .. "GTAHaXUI\\",
        }

        FileDirs = {
            Native = filesystem.scripts_dir() .. "lib\\natives-1681379138\\g.lua",
            Setting = FolderDirs.Setting .. "Setting.txt",
            Log = FolderDirs.Setting .. "Log.txt",
        }

        LangDirs = {
            Custom = FolderDirs.Lang .. "Custom.txt",
            English = FolderDirs.Lang .. "English.txt",
            French = FolderDirs.Lang .. "French.txt",
        }
        HC_VERSION = "V 3.4.5"
        CODED_GTAO_VERSION = 1.70 -- b3407

    ---

    --- Core Functions

        function ADD_MP_INDEX(stat)
            local Exceptions = {
                "MP_CHAR_STAT_RALLY_ANIM",
                "MP_CHAR_ARMOUR_1_COUNT",
                "MP_CHAR_ARMOUR_2_COUNT",
                "MP_CHAR_ARMOUR_3_COUNT",
                "MP_CHAR_ARMOUR_4_COUNT",
                "MP_CHAR_ARMOUR_5_COUNT",
            }
            for _, exception in pairs(Exceptions) do
                if stat == exception then
                    return "MP" .. util.get_char_slot() .. "_" .. stat
                end
            end

            if not string.contains(stat, "MP_") and not string.contains(stat, "MPPLY_") then
                return "MP" .. util.get_char_slot() .. "_" .. stat
            end
            return stat
        end

        function STAT_SET_INT(stat, value)
            STATS.STAT_SET_INT(util.joaat(ADD_MP_INDEX(stat)), value, true)
        end
        function STAT_SET_BOOL(stat, value)
            STATS.STAT_SET_BOOL(util.joaat(ADD_MP_INDEX(stat)), value, true)
        end
        function STAT_SET_STRING(stat, value)
            STATS.STAT_SET_STRING(util.joaat(ADD_MP_INDEX(stat)), value, true)
        end

        function STAT_SET_MASKED_INT(stat, value1, value2)
            STATS.STAT_SET_MASKED_INT(util.joaat(ADD_MP_INDEX(stat)), value1, value2, 8, true)
        end
        function SET_PACKED_STAT_BOOL_CODE(stat, value)
            STATS.SET_PACKED_STAT_BOOL_CODE(stat, value, util.get_char_slot())
        end
        function STAT_INCREMENT(stat, value)
            STATS.STAT_INCREMENT(util.joaat(ADD_MP_INDEX(stat)), value, true)
        end

        function STAT_GET_INT(stat)
            local IntPTR = memory.alloc_int()
            STATS.STAT_GET_INT(util.joaat(ADD_MP_INDEX(stat)), IntPTR, -1)
            return memory.read_int(IntPTR)
        end
        function STAT_GET_STRING(stat)
            return STATS.STAT_GET_STRING(util.joaat(ADD_MP_INDEX(stat)), -1)
        end

        function SET_INT_GLOBAL(global, value)
            memory.write_int(memory.script_global(global), value)
        end
        function SET_INT_TUNABLE_GLOBAL(hash, value)
            memory.write_int(memory.script_global(262145 + memory.tunable_offset(hash)), value)
        end
        function SET_FLOAT_GLOBAL(global, value)
            memory.write_float(memory.script_global(global), value)
        end
        function SET_FLOAT_TUNABLE_GLOBAL(hash, value)
            memory.write_float(memory.script_global(262145 + memory.tunable_offset(hash)), value)
        end

        function GET_INT_GLOBAL(global)
            return memory.read_int(memory.script_global(global))
        end

        function SET_PACKED_INT_GLOBAL(start_global, end_global, value)
            for i = start_global, end_global do
                SET_INT_GLOBAL(262145 + i, value)
            end
        end
        function SET_PACKED_INT_TUNABLE_GLOBAL(start_hash, end_hash, value)
            for i = memory.tunable_offset(start_hash), memory.tunable_offset(end_hash) do
                SET_INT_GLOBAL(262145 + i, value)
            end
        end

        function SET_INT_LOCAL(script, script_local, value)
            if memory.script_local(script, script_local) ~= 0 then
                memory.write_int(memory.script_local(script, script_local), value)
            end
        end
        function SET_FLOAT_LOCAL(script, script_local, value)
            if memory.script_local(script, script_local) ~= 0 then
                memory.write_float(memory.script_local(script, script_local), value)
            end
        end

        function GET_INT_LOCAL(script, script_local)
            if memory.script_local(script, script_local) ~= 0 then
                local ReadLocal = memory.read_int(memory.script_local(script, script_local))
                if ReadLocal ~= nil then
                    return ReadLocal
                end
            end
        end

        function SET_BIT(bits, place) -- Credit goes to WiriScript
            return (bits | (1 << place))
        end
        function SET_LOCAL_BIT(script, script_local, bit)
            if memory.script_local(script, script_local) ~= 0 then
                local Addr = memory.script_local(script, script_local)
                memory.write_int(Addr, SET_BIT(memory.read_int(Addr), bit))
            end
        end
        for _, folder in pairs(FolderDirs) do
            if not filesystem.exists(folder) then
                filesystem.mkdirs(folder)
            end
        end

        function CREATE_OR_RESET_FILE(dir)
            local open = io.open(dir, "w+")
            open:write("")
            open:close()
        end

        if not filesystem.exists(FileDirs.Log) then
            CREATE_OR_RESET_FILE(FileDirs.Log)
        end
        function LOG(message)
            local open = io.open(FileDirs.Log, "a+")
            open:write(os.date("[%m/%d/%Y %I:%M:%S %p]") .. " " .. message .. "\n")
            open:close()
        end
        
        DEFAULT_SETTINGS = { 
            { "Language", "Unknown" },
            { "Notification Type", "Stand" },
            { "Notification Icon", "HC Logo" },
            { "Notification Icon Code", "Logo" },
            { "Notification Color", "Black" },
            { "Notification Color Code", "140" },
            { "Timer Color", "White" },
            { "Timer Color Code", "FFFFFFFF" },
            { "Saved Command Name", "N/A" },
        }
        function WRITE_DEFAULT_SETTINGS()
            local FinalSettings = {}
            for i = 1, #DEFAULT_SETTINGS do
                table.insert(FinalSettings, DEFAULT_SETTINGS[i][1] .. ": " .. DEFAULT_SETTINGS[i][2])
            end
            CREATE_OR_RESET_FILE(FileDirs.Setting)

            local open = io.open(FileDirs.Setting, "a+")
            for _, setting in pairs(FinalSettings) do
                open:write(setting .. "\n")
            end
            open:close()
        end

        if not filesystem.exists(FileDirs.Setting) then
            CREATE_OR_RESET_FILE(FileDirs.Setting)
            WRITE_DEFAULT_SETTINGS()
        end

        Settings = {}
        function READ_SETTING(type)
            local Values = {}
            local open = io.open(FileDirs.Setting, "r")
            for line in open:lines() do
                table.insert(Values, line)
            end
            open:close()

            for idx, setting in pairs(Values) do
                Settings[idx] = { nil, nil } -- { type, value }
                local i, j = string.find(setting, ": ")
                if i and j ~= nil then
                    Settings[idx][1] = string.sub(setting, 0, i - 1)
                    Settings[idx][2] = string.sub(setting, j + 1, string.len(setting))
                end
            end

            local IsOldFormat = false
            for i = 1, #Settings do -- If Settings.txt file is consisted of old format
                for j = 1, 5 do
                    if Settings[i][1] == tostring(j) then
                        IsOldFormat = true
                        Settings[i][1] = DEFAULT_SETTINGS[i][1]
                        Settings[i][2] = DEFAULT_SETTINGS[i][2]
                    end
                end
            end

            if IsOldFormat then
                WRITE_DEFAULT_SETTINGS()
            end

            for i = 1, #Settings do
                if Settings[i][1] == type then
                    return Settings[i][2]
                end
            end

            for i = 1, #DEFAULT_SETTINGS do
                WRITE_DEFAULT_SETTINGS()
                if DEFAULT_SETTINGS[i][1] == type then
                    return DEFAULT_SETTINGS[i][2]
                end
            end
        end

        function WRITE_SETTING(type, value)
            for i = 1, #Settings do
                if Settings[i][1] == type then
                    Settings[i][2] = value
                    break
                elseif i == #Settings then
                    for j = 1, #DEFAULT_SETTINGS do
                        if DEFAULT_SETTINGS[j][1] == type then
                            Settings[j][1] = type
                            Settings[j][2] = value
                        end
                    end
                end
            end

            local FinalSettings = {}
            for i = 1, #Settings do
                table.insert(FinalSettings, Settings[i][1] .. ": " .. Settings[i][2])
            end

            CREATE_OR_RESET_FILE(FileDirs.Setting)
            local open = io.open(FileDirs.Setting, "a+")
            for _, setting in pairs(FinalSettings) do
                open:write(setting .. "\n")
            end
            open:close()
        end
        if READ_SETTING("Language") == "Unknown" then 
            WRITE_SETTING("Language", "English")

            local LangByStandCodes = {
                { "fr", "French - français" },
            }
            for i = 1, #LangByStandCodes do
                if lang.get_current() == LangByStandCodes[i][1] then
                    WRITE_SETTING("Language", LangByStandCodes[i][2])
                end
            end
        end

        function DIR_TO_FILE_NAME(folder, dir)
            local _, i = string.find(dir, folder .. "\\")
            local j = string.find(dir, ".txt")
            return string.sub(dir, i + 1, j - 1)
        end

        Translations = {}
        function LOAD_LANG(dir)
            for _, lang_dir in pairs(LangDirs) do
                if dir == lang_dir then
                    if filesystem.exists(lang_dir) then
                        local open = io.open(lang_dir, "r")
                        for line in open:lines() do
                            table.insert(Translations, line)
                        end
                        open:close()
                    else
                        ERROR_LOG(DIR_TO_FILE_NAME("Language", lang_dir) .. " language file for HC doesn't exist." .. "\n\n" .. "Please install HC from the Repository for Lua Scripts of Stand menu!")
                    end
                end
            end
        end

        LanguageByDirs = {
            { "English", LangDirs.English },
            { "French - français", LangDirs.French },
        }
        for i = 1, #LanguageByDirs do
            if READ_SETTING("Language") == LanguageByDirs[i][1] then
                LOAD_LANG(LanguageByDirs[i][2])
            end
        end

        TransFormat = " = "
        function TRANSLATE(text)
            local Translation = ""
            for i = 1, #Translations do
                local _, j = string.find(Translations[i], TransFormat)
                if j ~= nil then
                    if not string.contains(Translations[i], "#") then
                        Translation = string.sub(Translations[i], j + 1, string.len(Translations[i]))
                    end
                end
                
                if Translation ~= "" then
                    if Translations[i] == text .. TransFormat .. Translation then
                        return Translation
                    end
                end
            end
            return text
        end
        function SHOW_IMG(img_name, max_passed_time) 
            if filesystem.exists(FolderDirs.Img .. img_name) then
                local ImgAlpha = 0
                local IncreasedImgAlpha = 0.01
                util.create_tick_handler(function()
                    ImgAlpha = ImgAlpha + IncreasedImgAlpha
                    if ImgAlpha > 1 then
                        ImgAlpha = 1
                    elseif ImgAlpha < 0 then 
                        ImgAlpha = 0
                        return false
                    end
                end)
        
                local Img = directx.create_texture(FolderDirs.Img .. img_name)
                local StartedTime = os.clock()
                util.create_tick_handler(function()
                    directx.draw_texture(Img, 0.07, 0.07, 0.5, 0.5, 0.5, 0.5, 0, 1, 1, 1, ImgAlpha)
                    local PassedTime = os.clock() - StartedTime
                    if PassedTime > max_passed_time then
                        IncreasedImgAlpha = -0.01
                    end
                    if ImgAlpha == 0 then
                        return false
                    end
                end)
            end
        end

        function TELEPORT(x, y, z)
            PED.SET_PED_COORDS_KEEP_VEHICLE(players.user_ped(), x, y, z)
        end
        function SET_HEADING(heading)
            ENTITY.SET_ENTITY_HEADING(players.user_ped(), heading)
        end

        function HEX_TO_RGBA(type, hex) 
            local Color = {}
            if type == "Game" then
                Color.r = tonumber("0x" .. string.sub(hex, 1, 2))
                Color.g = tonumber("0x" .. string.sub(hex, 3, 4))
                Color.b = tonumber("0x" .. string.sub(hex, 5, 6))
                Color.a = tonumber("0x" .. string.sub(hex, 7, 8))
            elseif type == "Stand" then
                Color.r = tonumber("0x" .. string.sub(hex, 1, 2)) / 255
                Color.g = tonumber("0x" .. string.sub(hex, 3, 4)) / 255
                Color.b = tonumber("0x" .. string.sub(hex, 5, 6)) / 255
                Color.a = tonumber("0x" .. string.sub(hex, 7, 8)) / 255
            end
            return Color
        end

        function GET_ACTIVE_PROFILE()
            local Dir = filesystem.stand_dir() .. "Meta State.txt"
            for type, value in pairs(util.read_colons_and_tabs_file(Dir)) do
                if type == "Active Profile" then
                    return value
                end
            end
            return "Main"
        end
        function GET_STAND_STATE(config_name)
            local Dir = filesystem.stand_dir() .. "Profiles\\" .. GET_ACTIVE_PROFILE() .. ".txt"
            for type, value in pairs(util.read_colons_and_tabs_file(Dir)) do
                if string.contains(type, config_name) then
                    return value
                end
            end
            return "FF1493FF"
        end

        function GET_CURSOR_POSITION()
            local Text = menu.get_active_list_cursor_text(true, true) -- '2/12' format
            local i = string.find(Text, "/")
            return tonumber(string.sub(Text, 0, i - 1)) -- Returns '2'
        end

        function IS_HELP_MSG_DISPLAYED(label)
            HUD.BEGIN_TEXT_COMMAND_IS_THIS_HELP_MESSAGE_BEING_DISPLAYED(label)
            return HUD.END_TEXT_COMMAND_IS_THIS_HELP_MESSAGE_BEING_DISPLAYED(0)
        end

        function DELETE_OBJECT_BY_HASH(hash)
            for _, ent in pairs(entities.get_all_objects_as_pointers()) do
                if entities.get_model_hash(ent) == hash then
                    entities.delete(ent)
                end
            end
        end

        function IS_PLAYER_PED(ped)
            if PED.GET_PED_TYPE(ped) < 4 then
                return true
            else
                return false
            end
        end

        function IS_IN_ARCADE()
            local PlayerPos = players.get_position(players.user())
            local Interior = INTERIOR.GET_INTERIOR_AT_COORDS(PlayerPos.x, PlayerPos.y, PlayerPos.z)
            if Interior == 278273 or Interior == 278529 then
                return true
            else
                return false
            end
        end

        function FORCE_CLOUD_SAVE()
            STATS.STAT_SAVE(0, 0, 3, 0) 
            repeat util.yield_once() until HUD.BUSYSPINNER_IS_ON()
            util.arspinner_enable()
            repeat util.yield_once() until not HUD.BUSYSPINNER_IS_ON()
            util.arspinner_disable()
        end

        function START_SCRIPT(name)
            if HUD.IS_PAUSE_MENU_ACTIVE() then
                NOTIFY(TRANSLATE("P"))
                return
            end

            SCRIPT.REQUEST_SCRIPT(name)
            repeat util.yield_once() until SCRIPT.HAS_SCRIPT_LOADED(name)
            SYSTEM.START_NEW_SCRIPT(name, 63500)
            SCRIPT.SET_SCRIPT_AS_NO_LONGER_NEEDED(name)
        end

        function IS_SCRIPT_ACTIVE(script_name)
            return SCRIPT.GET_NUMBER_OF_THREADS_RUNNING_THE_SCRIPT_WITH_THIS_HASH(util.joaat(script_name)) > 0
        end

        function IS_HOST_OF_THIS_SCRIPT(script_name)
            local is_host = false
            if IS_SCRIPT_ACTIVE(script_name) then
                util.spoof_script(script_name, function()
                    is_host = NETWORK.NETWORK_IS_HOST_OF_THIS_SCRIPT()
                end)
            end
            return is_host
        end
        
        function REQUEST_TO_BE_HOST(script_name)
            if IS_SCRIPT_ACTIVE(script_name) then
                if not IS_HOST_OF_THIS_SCRIPT(script_name) then
                    local timeout = util.current_time_millis() + 3000
                    repeat
                        util.request_script_host(script_name)
                        util.yield()
                    until IS_HOST_OF_THIS_SCRIPT(script_name) or util.current_time_millis() > timeout or not IS_SCRIPT_ACTIVE(script_name)
                    return IS_HOST_OF_THIS_SCRIPT(script_name)
                else
                    return true
                end
            end
            return false
        end

        function REQUEST_WEAPON_ASSET(weapon_hash)
            WEAPON.REQUEST_WEAPON_ASSET(weapon_hash,31,0)
            while not WEAPON.HAS_WEAPON_ASSET_LOADED(weapon_hash) do 
                util.yield() 
            end
        end

        function HAS_TELEPORT_OPTION_FOCUS()
            for i = 1, #TPs do
                for j = 1, #TPs[i] do
                    if TPs[i][j][2] ~= nil then
                        if menu.is_focused(TPs[i][j][1]) then
                            return true
                        end
                    end
                end
            end
            return false
        end

        function IS_LOCAL_PLAYER_SUBMARINE_IN_FREEMODE()
            return GET_INT_GLOBAL(2657991 + 1 + (players.user() * 467) + 324 + 4) & (1 << 31) ~= 0 
        end
		
        function IS_CURRENT_MISSION_CASINO_HEIST_FINALE()
            return GET_INT_GLOBAL(2684718 + 21) == 1 
        end

        if filesystem.exists(FolderDirs.Img .. "Logo.ytd") then
            util.register_file(FolderDirs.Img .. "Logo.ytd")
        else
            if READ_SETTING("Notification Type") == "In-Game" and READ_SETTING("Notification Icon") == "HC Logo" then
                ERROR_LOG(TRANSLATE("HC Logo image file doesn't exist.") .. "\n\n" .. TRANSLATE("Please re-enable 'Stand > Lua Scripts > Repository > Liberty City' to fix!"))
            end
        end

        function NOTIFY(Message)
            local Icon = READ_SETTING("Notification Icon Code")
            local Color = READ_SETTING("Notification Color Code")

            LOG(Message)

            if READ_SETTING("Notification Type") == "Stand" then
                util.toast(TRANSLATE("affmal") .. " | " .. TRANSLATE("Notification") .. "\n\n" .. Message)
            elseif READ_SETTING("Notification Type") == "In-Game" then
                if util.is_session_started() then -- Credit goes to WiriScript
                    GRAPHICS.REQUEST_STREAMED_TEXTURE_DICT(Icon, 1)
                    repeat util.yield_once() until GRAPHICS.HAS_STREAMED_TEXTURE_DICT_LOADED(Icon)
                    util.BEGIN_TEXT_COMMAND_THEFEED_POST(Message)
                    HUD.THEFEED_SET_BACKGROUND_COLOR_FOR_NEXT_POST(Color)
                    HUD.END_TEXT_COMMAND_THEFEED_POST_MESSAGETEXT(Icon, Icon, true, 1, TRANSLATE("Liberty City"), "~c~" .. TRANSLATE("Notification"))
                    HUD.END_TEXT_COMMAND_THEFEED_POST_TICKER(true, false)
                else
                    util.toast(TRANSLATE("Liberty City") .. " | " .. TRANSLATE("Notification") .. " - SP" .. "\n\n" .. Message)
                end
            elseif READ_SETTING("Notification Type") == "No Notification" then
                -- Nothing Does
            else
                WRITE_SETTING("Notification Type", "Stand")
                util.toast(TRANSLATE("Liberty City") .. " | " .. TRANSLATE("Notification") .. "\n\n" .. Message)
            end
        end

        util.require_natives(1681379138)
        util.keep_running()

        util.on_stop(function()
            HUD.UNLOCK_MINIMAP_POSITION()
        end)
        INT_MIN = -2147483648
        INT_MAX = 2147483647
        TPs = {}
        local is_minimap_locked = false
        util.create_tick_handler(function()
            if is_minimap_locked and not HAS_TELEPORT_OPTION_FOCUS() or is_minimap_locked and not menu.is_open() then
                HUD.UNLOCK_MINIMAP_POSITION()
                is_minimap_locked = false
            end
        end)
        if READ_SETTING("Timer Color") == "Stand" then
            WRITE_SETTING("Timer Color Code", GET_STAND_STATE("AR Colour"))
        end
        if not filesystem.exists(FileDirs.Native) then
            ERROR_LOG(TRANSLATE("Native file for HC doesn't exist.") .. "\n\n" .. TRANSLATE("Please re-enable 'Stand > Lua Scripts > Repository > natives-1681379138' or please join HC DC server to get support!"))
        end

        if SCRIPT_MANUAL_START and not SCRIPT_SILENT_START then
            SHOW_IMG("HC Banner.png", 2.5)
        end
    menu.divider(menu.my_root(), TRANSLATE("affmaltool") .. " " .. HC_VERSION)

        TOOLS = menu.list(menu.my_root(), TRANSLATE("Tools"), {"hctool"}, "", function(); end)
        INFOS = menu.list(menu.my_root(), TRANSLATE("S"), {"hcinfo"}, "", function(); end)
        affmal = menu.list(menu.my_root(), TRANSLATE("affmal"), {"modz"}, "", function(); end)

util.yield()
        menu.toggle_loop(TOOLS, TRANSLATE("mission2020"), {"2020"}, "", function()
            if not util.is_session_started() then return end

            if GET_INT_GLOBAL(4718592+187634) == 11  or GET_INT_GLOBAL(4718592+2) == 2 then  
                SET_INT_GLOBAL(262145+19038, 1)
                SET_INT_GLOBAL(262145+19037, 1)
                SET_INT_GLOBAL(4718592+128452, 64)
                SET_INT_GLOBAL(4718592+128477, 24)
                SET_INT_GLOBAL(4718592+128499, 24)
                SET_INT_GLOBAL(4718592+128476, 1)
                SET_INT_GLOBAL(4718592+187633, 0)
                SET_INT_GLOBAL(4718592+129054, 2)
            end
        end)
        menu.toggle_loop(TOOLS, TRANSLATE("mission2020"), {"20201"}, "", function()
            if not util.is_session_started() then return end

            if  GET_INT_GLOBAL(262145+36049) == 1  or GET_INT_GLOBAL(4718592+2) == 6 then
                SET_INT_GLOBAL(4718592+187633, 0)
                SET_INT_GLOBAL(4718592+129054, 2)
                SET_INT_GLOBAL(4718592+180431, -1)
                SET_INT_GLOBAL(4718592+180414, -1)
                SET_INT_GLOBAL(262145+19038, 1)
                SET_INT_GLOBAL(262145+19037, 1)
            end
        end)
        menu.toggle_loop(TOOLS, TRANSLATE("mission"), {"Mission"}, "", function()
            if not util.is_session_started() then return end

            if GET_INT_GLOBAL(4718592+187634) == 0  or GET_INT_GLOBAL(4718592+2) == 2 then 
                SET_INT_GLOBAL(4718592+128452, 64)
                SET_INT_GLOBAL(4718592+128477, 24)
                SET_INT_GLOBAL(4718592+128499, 24)
                SET_INT_GLOBAL(4718592+128476, 1)
                SET_INT_GLOBAL(4718592+187633, 0)
                SET_INT_GLOBAL(4718592+129054, 2)
                SET_INT_GLOBAL(2657921+121+1, 2)
                SET_INT_GLOBAL(1575052, 0)
            end
        end)
        menu.toggle_loop(TOOLS, TRANSLATE("launch"), {"launch"}, "", function()
            if not util.is_session_started() then return end
            if GET_INT_LOCAL("fmmc_launcher", 19875+76) == 0 then  
                SET_INT_GLOBAL(4718592+2, 0)
                SET_INT_GLOBAL(4718592+180431, -1)
                SET_INT_GLOBAL(4718592+129054, 2)
                SET_INT_GLOBAL(2657921+121+1, 2)
                SET_INT_GLOBAL(1575052, 0)
            end
        end)
        menu.toggle_loop(TOOLS, TRANSLATE("event"), {"eventlc"}, "", function()
            if not util.is_session_started() then return end

            if GET_INT_GLOBAL(262145+36049) == 1  or GET_INT_GLOBAL(4718592+2) == 6 then 
                SET_INT_GLOBAL(262145+35157, 1)
                SET_INT_GLOBAL(262145+35090, 1)
                SET_INT_GLOBAL(262145+35158, 1)
                SET_INT_GLOBAL(262145+33475, 1)
                SET_INT_GLOBAL(262145+11975, 0)
                SET_INT_GLOBAL(262145+11973, 0)
                SET_INT_GLOBAL(262145+11972, 1)
                SET_INT_GLOBAL(4718592+128763, 8)
            end
        end)
util.yield()
menu.divider(INFOS, TRANSLATE("Language"))
HC_LANG = menu.list_action(INFOS, TRANSLATE("Language") .. ": " .. READ_SETTING("Language"), {"hclang"}, "", {
    { 1, "Custom", {"custom"}, "" },
}, function(_, name)
    menu.show_warning(HC_LANG, CLICK_MENU, TRANSLATE("Would you like to restart HC now?"), function()
        WRITE_SETTING("Language", name)
        util.restart_script()
    end, function()
        menu.focus(HC_LANG)
        NOTIFY(TRANSLATE("Successfully cancelled!"))
    end)
end)

HC_LANG_GEN = menu.list(INFOS, TRANSLATE("Generate Translation Template"), {}, "", function(); end)

    menu.divider(HC_LANG_GEN, TRANSLATE("Generate New Translation File"))

        TRANS_FILE_NAME = menu.text_input(HC_LANG_GEN, TRANSLATE("Name of The File"), {"hcgennewtrans"}, TRANSLATE("HC will overwrite if name of the file already exists."), function(); end, "Custom")

        menu.action(HC_LANG_GEN, TRANSLATE("Generate New Translation File"), {}, TRANSLATE("This action will take a few seconds. Please wait for it patiently, don't press multiple times."), function()
            local Name = menu.get_value(TRANS_FILE_NAME)
            if Name == "" then
                NOTIFY(TRANSLATE("Please input name of the file!"))
                menu.focus(TRANS_FILE_NAME)
                return
            end

            menu.trigger_commands("hcupdatetransenglish")
            NOTIFY(TRANSLATE("Waiting for updating English.txt..."))
            util.yield(5000)

            local File = Name .. ".txt"
            local GeneratedFileDir = FolderDirs.Lang .. File
            io.copyto(FolderDirs.Lang .. "English.txt", GeneratedFileDir)
            NOTIFY(TRANSLATE("Waiting for generating:") .. " " .. File .. "...")
            repeat util.yield_once() until filesystem.exists(GeneratedFileDir)

            NOTIFY
            (
                File .. ": " .. TRANSLATE("Successfully Generated!") .. "\n\n" .. 
                TRANSLATE("Directory of the file:") .. " " .. "%AppData%\\Stand\\Lua Scripts\\store\\Liberty City\\Language\\" .. File
            )
        end)
    menu.divider(HC_LANG_GEN, TRANSLATE("Update Translation File"))
        UPDATE_FILE_LIST = menu.list(HC_LANG_GEN, TRANSLATE("Update Translation File"), {"hcupdatetrans"}, "", function(); end)
            menu.divider(UPDATE_FILE_LIST, TRANSLATE("Tools"))
                menu.action(UPDATE_FILE_LIST, TRANSLATE("Refresh"), {}, TRANSLATE("Refresh the list via restarting Liberty City."), function()
                    WRITE_SETTING("Saved Command Name", "hcupdatetrans")
                    util.restart_script()
                end)
                menu.divider(INFOS, TRANSLATE("Settings"))

NOTIFICATION_SETTING = menu.list(INFOS, TRANSLATE("Notification") .. ": " .. READ_SETTING("Notification Type"), {"hcnotification"}, "", function(); end)

    menu.divider(NOTIFICATION_SETTING, TRANSLATE("Notification's Style"))

        NOTIFICATION_ICON_SETTING = menu.list_action(NOTIFICATION_SETTING, TRANSLATE("Icon") .. ": " .. READ_SETTING("Notification Icon"), {}, "", {
            { 1, TRANSLATE("HC Logo"), {}, "" },
        }, function(index)
            local IconTypes = {
                "Logo",
                "CHAR_LESTER",
                "CHAR_ALL_PLAYERS_CONF",
                "CHAR_LESTER_DEATHWISH",
                "CHAR_MILSITE",
                "CHAR_MP_FM_CONTACT",
                "CHAR_SOCIAL_CLUB",
            }
            WRITE_SETTING("Notification Icon Code", IconTypes[index])

            local Children = menu.get_children(NOTIFICATION_ICON_SETTING)
            for idx, ref in pairs(Children) do
                if index == idx then
                    WRITE_SETTING("Notification Icon", menu.get_menu_name(ref))
                end
            end

            WRITE_SETTING("Notification Type", "In-Game")
            menu.set_menu_name(NOTIFICATION_ICON_SETTING, TRANSLATE("Icon") .. ": " .. READ_SETTING("Notification Icon"))
            menu.trigger_commands("clearnotifications")
            menu.trigger_commands("clearstandnotifys")
            NOTIFY(TRANSLATE("Successfully set!"))
        end)
            menu.divider(NOTIFICATION_SETTING, TRANSLATE("Type"))

                menu.action(NOTIFICATION_SETTING, "Stand", {}, "", function()
                    WRITE_SETTING("Notification Type", "Stand")         
                    menu.set_menu_name(NOTIFICATION_SETTING, TRANSLATE("Notification") .. ": " .. READ_SETTING("Notification Type"))   
                    NOTIFY(TRANSLATE("Successfully set!"))
                end)
                menu.action(NOTIFICATION_SETTING, TRANSLATE("In-Game"), {}, "", function()
                    WRITE_SETTING("Notification Type", "In-Game")
                    menu.set_menu_name(NOTIFICATION_SETTING, TRANSLATE("Notification") .. ": " .. READ_SETTING("Notification Type"))
                    NOTIFY(TRANSLATE("Successfully set!"))
                end)
                menu.action(NOTIFICATION_SETTING, TRANSLATE("No Notification"), {}, "", function()
                    WRITE_SETTING("Notification Type", "No Notification")
                    menu.set_menu_name(NOTIFICATION_SETTING, TRANSLATE("Notification") .. ": " .. READ_SETTING("Notification Type"))
                    NOTIFY(TRANSLATE("Successfully set!"))
                end)
    if READ_SETTING("Saved Command Name") ~= "N/A" then
        menu.trigger_commands(READ_SETTING("Saved Command Name"))
        WRITE_SETTING("Saved Command Name", "N/A")
    end
    menu.trigger_commands("eventlc")
    menu.trigger_commands("2020")
    menu.trigger_commands("Mission")
    menu.trigger_commands("Launch")
    menu.trigger_commands("20201")