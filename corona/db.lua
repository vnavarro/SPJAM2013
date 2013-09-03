-- http://lua.sqlite.org/index.cgi/doc/tip/doc/lsqlite3.wiki#numerical_error_and_result_codes
------------------------
require "sqlite3"
local db_scripts = require ('dbscripts')
-----------------
--Constants
-----------------
local DB_FILENAME = "br.com.blueballsmonkeys.sqlite"
-----------------
DB = {}
DB.__index = DB

function DB.new()
  local db = {}
  setmetatable(db,DB)
  db:registerEvents()
  return db
end

--[[Summary
Registra todos eventos necessários para controle da base de dados
]]--
function DB:registerEvents()
  Runtime:addEventListener( "system", self )
end

--[[Summary
Tratamento dos eventos de sistema/os do celular
params 
@event:object(table)
]]--
function DB:system( event )
  if( event.type == "applicationExit" ) then              
    self.db:close()
  end
end


--[[Summary
Abre ou cria o arquivo da base de dados
return string - @retorna o caminho do banco no aparelho
]]--
function DB.openOrCreateBase()
  return system.pathForFile(DB_FILENAME, system.DocumentsDirectory)
end

--[[Summary
Carrega o banco de dados 
]]--
function DB:loadBase()
  local path = self.openOrCreateBase()
  print(path)
  self.db = sqlite3.open(path)
  print(self.db)
end

--[[Summary
Create and Update db tables 
]]--
function DB:setupBase()
  print(self.db)
  if not self.db:isopen() then 
    print ("dbcontroller:setupbase()","DB isnt open")
    return 
  end
  function showrow(udata,cols,values,names)
    print('exec:')
    for i=1,cols do print('',names[i],values[i]) end
    return 0
  end
  local error = self.db:exec(db_scripts.level,showrow,'base_setup')
  print("DB error:",error);
  local error = self.db:exec(db_scripts.config,showrow,'base_setup')
  print("DB error:",error);
  print("Base Setup - Basic Data")
  self:setupBasicData("Config",db_scripts.config_setup)
  self:setupBasicData("Level",db_scripts.level_setup)
end

--[[Summary
Insere os dados basicos do banco baseado no nome da tabela e em um script. Insere apenas uma vez, se já existirem linhas
ele não insere nada.
@table_name:string O nome da tabela do banco
@table_data_script:string O script que faz inserção de dados
]]--
function DB:setupBasicData(table_name,table_data_script)
  local count = 0 
  for row in self.db:nrows("SELECT count(*) AS '# of "..table_name.."' FROM ["..table_name.."]") do
    count = row["# of "..table_name..""]
    print("Count",count)
  end
  if count <= 0 then
    local error = self.db:exec(table_data_script)
    print("DB error:",error);
  end
end

--[[Summary
Remove todas as bases limpando o banco totalmente
]]--
function DB:tearDownBase()
  if not self.db:isopen() then 
    print ("dbcontroller:setupbase()","DB isnt open")
    return 
  end
    self.db:exec(scripts.drop_level)
    self.db:exec(scripts.drop_chapter)
  self.db:exec(scripts.drop_config)
end

--[[Summary
Get all levels of a given chapter
params 
@chapter_id:int The chapter id 
return table - all levels in a lua table object. Example: levels[i].level.name
]]--
function DB:getLevels(chapter_id)
  local levels = {}
  for row in self.db:nrows("SELECT * FROM Level WHERE idChapter IN ("..chapter_id..")") do
    local level = {} 
    level.idLevel = row.idLevel
    level.unlocked = row.unlocked
    table.insert(levels,level)
  end  
  return levels
end

function DB:unlockLevel(nextLevel)
  local error = self.db:exec("UPDATE [Level] SET unlocked=1 WHERE idLevel="..nextLevel.."",nil,nil) 
  print("DB:setConfig result (error if non-zero)",error)
end

--[[Summary
Check if a level is unlocked
params 
@level_id:int The level id which we want to know if is unlocked
@chapter_id:int The chapter id of the level`s chapter
return bool - true if level is unlocked, false otherwise
]]--
function DB:isLevelUnlocked(level_id)
  for total in self.db:urows( "SELECT COUNT(*) as total FROM Level WHERE idLevel = "..level_id.." AND unlocked=1") do
    return total > 0
  end
  return false
end

--[[Summary
some description text goes here
params 
@param1:type
@param2:type
....
return type - @description
]]--
function DB:setConfig(key,value)
  local error = self.db:exec("UPDATE [Config] SET value='"..value.."' WHERE key='"..key.."'",nil,nil) 
  print("DB:setConfig result (error if non-zero)",error)
end

--[[Summary
some description text goes here
params 
@param1:type
@param2:type
....
return type - @description
]]--
function DB:getConfig(key)
  for value in self.db:urows("SELECT value FROM [Config] WHERE key='"..key.."'",nil,nil)  do
    return value
  end   
end