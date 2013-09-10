local SheetInfo = {}

SheetInfo.sheet = {
	frames = {
				{ x = 0, y = 0, width = 32, height = 32 },
				{ x = 32, y = 0, width = 32, height = 32 },
				{ x = 64, y = 0, width = 32, height = 32 },
				{ x = 96, y = 0, width = 32, height = 32 },
				{ x = 0, y = 32, width = 32, height = 32 },
				{ x = 32, y = 32, width = 32, height = 32 },
				{ x = 64, y = 32, width = 32, height = 32 },
				{ x = 96, y = 32, width = 32, height = 32 },
				{ x = 0, y = 64, width = 32, height = 32 },
				{ x = 32, y = 64, width = 32, height = 32 },
				{ x = 64, y = 64, width = 32, height = 32 },
				{ x = 96, y = 64, width = 32, height = 32 },
				-- { x = 0, y = 0, width = 32, height = 32 },
				-- { x = 32, y = 0, width = 32, height = 32 },
				-- { x = 64, y = 0, width = 32, height = 32 },
				-- { x = 96, y = 0, width = 32, height = 32 },
				-- { x = 0, y = 32, width = 32, height = 32 },
				-- { x = 32, y = 32, width = 32, height = 32 },
				-- { x = 64, y = 32, width = 32, height = 32 },
				-- { x = 96, y = 32, width = 32, height = 32 },
				-- { x = 0, y = 64, width = 32, height = 32 },
				-- { x = 32, y = 64, width = 32, height = 32 },
				-- { x = 64, y = 64, width = 32, height = 32 },
				-- { x = 96, y = 64, width = 32, height = 32 },
	},
	
	sheetContentWidth = 128,
	sheetContentHeight = 128
}

SheetInfo.frameIndex = {
	["portal0"] = 1,
	["portal1"] = 2,
	["portal2"] = 3,
	["portal3"] = 4,
	["portal4"] = 5,
	["portal5"] = 6,
	["portal_mal0"] = 7,
	["portal_mal1"] = 8,
	["portal_mal2"] = 9,
	["portal_mal3"] = 10,
	["portal_mal4"] = 11,
	["portal_mal5"] = 12,
}

function SheetInfo:getSheet()
	return self.sheet
end

function SheetInfo:getFrameIndex(name)
	return self.frameIndex[name]
end
return SheetInfo

