local SheetInfo = {}

SheetInfo.sheet = {
	frames = {
		{ x = 0, y = 0, width = 32, height = 64 },
		{ x = 32, y = 0, width = 32, height = 64 },
		{ x = 64, y = 0, width = 32, height = 64 },
		{ x = 96, y = 0, width = 32, height = 64 },
		{ x = 128, y = 0, width = 32, height = 64 },
		{ x = 160, y = 0, width = 32, height = 64 },
		{ x = 192, y = 0, width = 32, height = 64 },
		{ x = 224, y = 0, width = 32, height = 64 },
		{ x = 0, y = 64, width = 32, height = 64 },
		{ x = 32, y = 64, width = 32, height = 64 },
	},
	
	sheetContentWidth = 256,
	sheetContentHeight = 256
}

SheetInfo.frameIndex = {
	["andando01"] = 1,
	["andando02"] = 2,
	["andando03"] = 3,
	["andando04"] = 4,
	["andando05"] = 5,
	["andando06"] = 6,
	["andando07"] = 7,
	["andando08"] = 8,
	["andando09"] = 9,
	["andando10"] = 10,
}

function SheetInfo:getSheet()
	return self.sheet
end

function SheetInfo:getFrameIndex(name)
	return self.frameIndex[name]
end
return SheetInfo

