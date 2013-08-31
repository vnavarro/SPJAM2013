module(...,package.seeall)

level = [[CREATE TABLE IF NOT EXISTS [Level] (
  [idLevel] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ON CONFLICT ROLLBACK,
  [unlocked] INTEGER DEFAULT 0);]]

config = [[CREATE TABLE IF NOT EXISTS [Config] (
  [idConfig] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ON CONFLICT ROLLBACK,
  [key] TEXT NOT NULL ON CONFLICT ROLLBACK,
  [value] TEXT NOT NULL ON CONFLICT ROLLBACK);]]

drop_level = [[DROP TABLE IF EXISTS [Level];]]
drop_config = [[DROP TABLE IF EXISTS [Config];]]

config_setup = [[INSERT INTO [Config] VALUES (1,'sound','on');]]
level_setup = [[
  insert into [Level] values (1, 1);
  insert into [Level] values (2, 0);
  insert into [Level] values (3, 0);
  insert into [Level] values (4, 0);
  insert into [Level] values (5, 0);
  insert into [Level] values (6, 0);
]]
