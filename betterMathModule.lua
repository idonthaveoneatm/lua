-- ++++++++ WAX BUNDLED DATA BELOW ++++++++ --

-- Will be used later for getting flattened globals
local ImportGlobals

-- Holds direct closure data (defining this before the DOM tree for line debugging etc)
local ClosureBindings = {
    function()local wax,script,require=ImportGlobals(1)local ImportGlobals return (function(...)local MathModule = {}
local JaroWSCheck = false
local ModuleClasses = {
	"Value",
	"Chance",
	"Sequence",
	"String",
	"Convert",
	"Check",
	"Notation",
	"Random",
	"Matrix",
	"Special"
}
for i = 1, #ModuleClasses, 1 do
	MathModule[ModuleClasses[i]] = {}
end
--[[
CLASS Value
]]
function MathModule.Value:EulersNumber()
	return math.exp(1)
end
function MathModule.Value:EulersConstant()
	return 0.577215664901
end
function MathModule.Value:GammaCoeff()
	return -0.65587807152056
end
function MathModule.Value:GammaQuad()
	return -0.042002635033944
end
function MathModule.Value:GammaQui()
	return 0.16653861138228
end
function MathModule.Value:GammaSet()
	return -0.042197734555571
end
function MathModule.Value:GoldenRatio()
	return (1 + math.sqrt(5)) / 2
end
function MathModule.Value:Tau()
	return math.pi * 2
end
function MathModule.Value:AperysConstant()
	return 423203577229 / 352066176000
end
function MathModule.Value:BelphegorsPrimeNumber()
	return 1000000000000066600000000000001
end
--[[
CLASS Chance
]]
function MathModule.Chance:Mean(Table)
	if type(Table) == "table" and Table[1] then else return warn("only tables are allowed in this function") end
	for i = 1, #Table, 1 do
		if typeof(Table[i]) == "number" then else return warn("only numbers are allowed in the table") end
	end
	table.sort(Table)
	local Sum = 0
	for i = 1, #Table, 1 do
		Sum += Table[i]
	end
	return Sum / #Table
end
function MathModule.Chance:Median(Table)
	if type(Table) == "table" and Table[1] then else return warn("only tables are allowed in this function") end
	for i = 1, #Table, 1 do
		if typeof(Table[i]) == "number" then else return warn("only numbers are allowed in the table") end
	end
	table.sort(Table)
	if #Table ~= 1 and #Table ~= 2 then
		repeat wait()
			table.remove(Table, 1)
			table.remove(Table, #Table)
		until #Table == 1 or #Table == 2
	end
	if #Table == 2 then
		local Difference = Table[#Table] - Table[1]
		return Table[1] + (Difference / 2)
	else
		return Table[#Table]
	end
end
function MathModule.Chance:Mode(Table)
	if type(Table) == "table" and Table[1] then else return warn("only tables are allowed in this function") end
	table.sort(Table)
	local ModeTable1 = {}
	local ModeTable2 = {}
	local ModeCount = 0
	for i, v in pairs(Table) do
		ModeTable1[v] = ModeTable1[v] and ModeTable1[v] + 1 or 1
	end
	for i, v in pairs(ModeTable1) do
		if v > ModeCount then
			ModeCount = v
			ModeTable2 = {i}
		elseif v == ModeCount then
			table.insert(ModeTable2, i)
		end
	end
	return ModeTable2, ModeCount
end
function MathModule.Chance:Range(Table)
	if type(Table) == "table" and Table[2] then else return warn("only tables are allowed in this function") end
	for i = 1, #Table, 1 do
		if typeof(Table[i]) == "number" then else return warn("only numbers are allowed in the table") end
	end
	table.sort(Table)
	return Table[#Table] - Table[1]
end
function MathModule.Chance:MidRange(Table)
	if type(Table) == "table" and Table[2] then else return warn("only tables are allowed in this function") end
	for i = 1, #Table, 1 do
		if typeof(Table[i]) == "number" then else return warn("only numbers are allowed in the table") end
	end
	table.sort(Table)
	return (Table[#Table] + Table[1]) / 2
end
function MathModule.Chance:FirstQuartile(Table)
	if type(Table) == "table" and Table[2] then else return warn("only tables are allowed in this function") end
	for i = 1, #Table, 1 do
		if typeof(Table[i]) == "number" then else return warn("only numbers are allowed in the table") end
	end
	table.sort(Table)
	if #Table % 2 == 0 then
		for i = 1, #Table / 2, 1 do
			table.remove(Table, #Table)
		end
	else
		for i = 1, ((#Table - 1) / 2) + 1, 1 do
			table.remove(Table, #Table)
		end
	end
	return MathModule.Chance:Median(Table)
end
function MathModule.Chance:ThirdQuartile(Table)
	if type(Table) == "table" and Table[2] then else return warn("only tables are allowed in this function") end
	for i = 1, #Table, 1 do
		if typeof(Table[i]) == "number" then else return warn("only numbers are allowed in the table") end
	end
	table.sort(Table)
	if #Table % 2 == 0 then
		for i = 1, #Table / 2, 1 do
			table.remove(Table, 1)
		end
	else
		for i = 1, ((#Table - 1) / 2) + 1, 1 do
			table.remove(Table, 1)
		end
	end
	return MathModule.Chance:Median(Table)
end
function MathModule.Chance:InterquartileRange(Table)
	if type(Table) == "table" and Table[2] then else return warn("only tables are allowed in this function") end
	for i = 1, #Table, 1 do
		if typeof(Table[i]) == "number" then else return warn("only numbers are allowed in the table") end
	end
	table.sort(Table)
	local Table1 = {}
	local Table2 = {}
	for i = 1, #Table, 1 do
		table.insert(Table1, Table[i])
		table.insert(Table2, Table[i])
	end
	return MathModule.Chance:ThirdQuartile(Table1) - MathModule.Chance:FirstQuartile(Table2)
end
function MathModule.Chance:StandardDeviation(Table)
	if type(Table) == "table" and Table[1] then else return warn("only tables are allowed in this function") end
	for i = 1, #Table, 1 do
		if typeof(Table[i]) == "number" then else return warn("only numbers are allowed in the table") end
	end
	table.sort(Table)
	local Mean = MathModule.Chance:Mean(Table)
	for i = 1, #Table, 1 do
		Table[i] = (Table[i] - Mean)^2
	end
	return math.sqrt(MathModule.Chance:Mean(Table))
end
function MathModule.Chance:ZScore(Table)
	if type(Table) == "table" and Table[1] then else return warn("only tables are allowed in this function") end
	for i = 1, #Table, 1 do
		if typeof(Table[i]) == "number" then else return warn("only numbers are allowed in the table") end
	end
	local Table1 = {}
	local Table2 = {}
	for i = 1, #Table, 1 do
		table.insert(Table1, Table[i])
		table.insert(Table2, Table[i])
	end
	table.sort(Table1)
	table.sort(Table2)
	local Mean = MathModule.Chance:Mean(Table1)
	local StandardDeviation = MathModule.Chance:StandardDeviation(Table2)
	for i = 1, #Table, 1 do
		Table[i] = (Table[i] - Mean) / StandardDeviation
	end
	return Table
end
function MathModule.Chance:Permutation(Table)
	if type(Table) == "table" and Table[2] then else return warn("only tables are allowed in this function") end
	if Table[3] then return warn("you can't have three table values") end
	for i = 1, #Table, 1 do
		if typeof(Table[i]) == "number" then else return warn("only numbers are allowed in the table") end
	end
	local n = Table[1]
	local r = Table[2]
	return MathModule.Special:Factorial(n) / MathModule.Special:Factorial(n - r)
end
function MathModule.Chance:Combination(Table)
	if type(Table) == "table" and Table[2] then else return warn("only tables are allowed in this function") end
	if Table[3] then return warn("you can't have three table values") end
	for i = 1, #Table, 1 do
		if typeof(Table[i]) == "number" then else return warn("only numbers are allowed in the table") end
	end
	local n = Table[1]
	local r = Table[2]
	return MathModule.Special:Factorial(n) / (MathModule.Special:Factorial(r) * MathModule.Special:Factorial(n - r))
end
--[[
CLASS Sequence
]]
function MathModule.Sequence:ThueMorse(n)
	if typeof(n) == "number" then else return warn("only numbers are allowed") end
	if n % 1 == 0 and math.abs(n) + n ~= 0 then else return warn("number has to be a positive whole number") end
	local Morse = "0"
	for i = 1, n, 1 do
		local String = ""
		for Character in Morse:gmatch(".") do
			String ..= math.abs(tonumber(Character) - 1)
		end
		Morse ..= String
	end
	return Morse
end
function MathModule.Sequence:Integer(Table)
	if type(Table) == "table" and Table[2] then else return warn("only tables are allowed in this function") end
	if Table[3] then return warn("you can't have three table values") end
	for i = 1, #Table, 1 do
		if typeof(Table[i]) == "number" then else return warn("only numbers are allowed in the table") end
	end
	local Min = Table[1]
	local Max = Table[2]
	local Total = {}
	if Min > Max then return warn("min can't be greater than max") end
	if Min % 1 ~= 0 or Max % 1 ~= 0 then return warn("min and max have to be whole numbers") end
	if Min <= 0 or Max <= 0 then return warn("min or max can't be lower than or equal to 0") end
	table.insert(Total, "0")
	for i = 1, Max - 1, 1 do
		if i >= Min then
			table.insert(Total, "±"..i)
		end
	end
	return Total
end
function MathModule.Sequence:Prime(Table)
	if type(Table) == "table" and Table[2] then else return warn("only tables are allowed in this function") end
	if Table[3] then return warn("you can't have three table values") end
	for i = 1, #Table, 1 do
		if typeof(Table[i]) == "number" then else return warn("only numbers are allowed in the table") end
	end
	local Min = Table[1]
	local Max = Table[2]
	local Total = {}
	if Min > Max then return warn("min can't be greater than max") end
	if Min % 1 ~= 0 or Max % 1 ~= 0 then return warn("min and max have to be whole numbers") end
	if Min <= 0 or Max <= 0 then return warn("min or max can't be lower than or equal to 0") end
	local Count = 2
	while true do wait()
		if #Total == Max then
			break
		end
		if MathModule.Check:Prime(Count) then
			table.insert(Total, Count)
		end
		if Count == 2 then
			Count += 1
		else
			Count += 2
		end
	end
	for i = 1, Min - 1, 1 do
		table.remove(Total, 1)
	end
	return Total
end
function MathModule.Sequence:Unprimeable(Table)
	if type(Table) == "table" and Table[2] then else return warn("only tables are allowed in this function") end
	if Table[3] then return warn("you can't have three table values") end
	for i = 1, #Table, 1 do
		if typeof(Table[i]) == "number" then else return warn("only numbers are allowed in the table") end
	end
	local Min = Table[1]
	local Max = Table[2]
	local Total = {}
	if Min > Max then return warn("min can't be greater than max") end
	if Min % 1 ~= 0 or Max % 1 ~= 0 then return warn("min and max have to be whole numbers") end
	if Min <= 0 or Max <= 0 then return warn("min or max can't be lower than or equal to 0") end
	local Count = 200
	while true do wait()
		if #Total == Max then
			break
		end
		if MathModule.Check:Unprimeable(Count) then
			table.insert(Total, Count)
		end
		Count += 1
	end
	for i = 1, Min - 1, 1 do
		table.remove(Total, 1)
	end
	return Total
end
--[[
CLASS String
]]
function MathModule.String:JaroSimilarity(Table)
	if type(Table) == "table" and Table[2] then else return warn("only tables are allowed in this function") end
	if Table[3] then return warn("you can't have three table values") end
	for i = 1, #Table, 1 do
		if typeof(Table[i]) == "string" then else return warn("only strings are allowed in the table") end
	end
	local JWSC = false
	if JaroWSCheck == true then
		JaroWSCheck = false
		JWSC = true
	end
	local String1 = Table[1]
	local String2 = Table[2]
	local Length1 = string.len(String1)
	local Length2 = string.len(String2)
	local Table1 = {}
	local Table2 = {}
	local Table3 = {}
	local Table4 = {}
	local Table5 = {}
	local Table6 = {}
	if Length1 == 0 and Length2 == 0 then return 1 end
	if Length1 == 0 or Length2 == 0 then return 0 end
	local Matches = 0
	local Transposition = 0
	for Character in String1:gmatch(".") do
		if not table.find(Table1, Character) then
			table.insert(Table1, Character)
		else
			local AddCharacter = 0
			while true do wait()
				AddCharacter += 1
				if not table.find(Table1, Character..AddCharacter) then
					table.insert(Table1, Character..AddCharacter)
					break					
				end
			end
		end
	end
	for Character in String2:gmatch(".") do
		if not table.find(Table2, Character) then
			table.insert(Table2, Character)
		else
			local AddCharacter = 0
			while true do wait()
				AddCharacter += 1
				if not table.find(Table2, Character..AddCharacter) then
					table.insert(Table2, Character..AddCharacter)
					break					
				end
			end
		end
	end
	for i, v in pairs(Table1) do
		for ii, vv in pairs(Table2) do
			if Table1[i] == Table2[ii] then
				table.insert(Table3, Table1[i])
				table.insert(Table4, Table2[ii])
				Matches += 1
				break
			end
		end
	end
	if Matches == 0 then return 0 end
	for i = 1, #Table1, 1 do
		if table.find(Table3, Table1[i]) then
			table.insert(Table5, Table1[i])
		end
	end
	for i = 1, #Table2, 1 do
		if table.find(Table4, Table2[i]) then
			table.insert(Table6, Table2[i])
		end
	end
	for i = 1, #Table1 or #Table2, 1 do
		if Table1[i] ~= Table2[i] then
			if JWSC == true then
				return i - 1
			end
		end
	end
	for i = 1, #Table5 or #Table6, 1 do
		if Table5[i] ~= Table6[i] then
			Transposition += 0.5
		end
	end
	return ((Matches / Length1) + (Matches / Length2) + ((Matches - Transposition) / Matches)) / 3
end
function MathModule.String:JaroDistance(Table)
	return 1 - MathModule.String:JaroSimilarity(Table)
end
function MathModule.String:JaroWinklerSimilarity(Table)
	local JaroS = MathModule.String:JaroSimilarity(Table)
	JaroWSCheck = true
	local Prefix = MathModule.String:JaroSimilarity(Table)
	Prefix = math.min(Prefix, 4)
	return JaroS + 0.1 * Prefix * (1 - JaroS)
end
function MathModule.String:JaroWinklerDistance(Table)
	return 1 - MathModule.String:JaroWinklerSimilarity(Table)
end
function MathModule.String:LevenshteinDistance(Table)
	if type(Table) == "table" and Table[2] then else return warn("only tables are allowed in this function") end
	if Table[3] then return warn("you can't have three table values") end
	for i = 1, #Table, 1 do
		if typeof(Table[i]) == "string" then else return warn("only strings are allowed in the table") end
	end
	local String1 = Table[1]
	local String2 = Table[2]
	local Length1 = string.len(String1)
	local Length2 = string.len(String2)
	if String1 == '' then return Length2 end
	if String2 == '' then return Length1 end
	local String1Sub = String1:sub(2, -1)
	local String2Sub = String2:sub(2, -1)
	if String1:sub(0, 1) == String2:sub(0, 1) then
		return MathModule.String:LevenshteinDistance({String1Sub, String2Sub})
	end
	return 1 + math.min(MathModule.String:LevenshteinDistance({String1Sub, String2Sub}), MathModule.String:LevenshteinDistance({String1, String2Sub}), MathModule.String:LevenshteinDistance({String1Sub, String2}))
end
--[[
CLASS Convert
]]
function MathModule.Convert:DecimalToBase(Table)
	if type(Table) == "table" and Table[2] then else return warn("only tables are allowed in this function") end
	if Table[3] then return warn("you can't have three table values") end
	for i = 1, #Table, 1 do
		if typeof(Table[i]) == "number" and Table[2] % 1 == 0 then else return warn("only numbers are allowed in the table, also bases have to be whole numbers") end
	end
	if Table[2] > 36 then return warn("no bases above 36 are allowed") end
	if Table[2] < 1 then return warn("no bases below 1 are allowed") end
	if Table[2] == 10 then return warn("base 10 is not allowed") end
	local Decimal = Table[1]
	local Base = Table[2]
	local Fraction = ""
	local Sign = ""
	local BaseTable = {}
	local FractionTable = {}
	local RepeatTable = {}
	local Base11To36 = {
		[10] = "A",
		[11] = "B",
		[12] = "C",
		[13] = "D",
		[14] = "E",
		[15] = "F",
		[16] = "G",
		[17] = "H",
		[18] = "I",
		[19] = "J",
		[20] = "K",
		[21] = "L",
		[22] = "M",
		[23] = "N",
		[24] = "O",
		[25] = "P",
		[26] = "Q",
		[27] = "R",
		[28] = "S",
		[29] = "T",
		[30] = "U",
		[31] = "V",
		[32] = "W",
		[33] = "X",
		[34] = "Y",
		[35] = "Z"
	}
	if math.abs(Decimal) + Decimal == 0 and Decimal ~= 0 then
		Decimal = math.abs(Decimal)
		Sign = "-"
	end
	if Decimal % 1 ~= 0 then
		local DF = math.floor(Decimal - (Decimal % 1))
		Fraction = DF
		local Digits = 0
		while true do wait()
			Digits += 1
			if (Decimal * (10^Digits)) % 1 == 0 then
				break
			end
		end
		Fraction = tonumber(string.format("%."..(Digits or 0).."f", Decimal - Fraction))
		Decimal = DF
		local MaxPlace = 10^-math.log10(Fraction)
		Fraction *= MaxPlace
		repeat wait()
			if table.find(RepeatTable, Fraction) then
				break
			end
			table.insert(RepeatTable, Fraction)
			Fraction *= Base
			local TableData = math.floor(Fraction / MaxPlace)
			if TableData >= 10 then
				for i, v in pairs(Base11To36) do
					if i == TableData then
						TableData = v
					end
				end
			end
			table.insert(FractionTable, TableData)
			if TableData >= 1 and not (Fraction == MaxPlace) then
				Fraction -= (TableData * MaxPlace)
			end
		until Fraction == MaxPlace
		if DF == 0 then
			Fraction = "0."
		else
			Fraction = "."
		end
		for i = 1, #FractionTable, 1 do
			Fraction ..= FractionTable[i]
		end
		if DF == 0 then
			return Sign..Fraction
		end
	end
	repeat wait()
		local TableData = Decimal % Base
		if TableData >= 10 then
			for i, v in pairs(Base11To36) do
				if i == TableData then
					TableData = v
				end
			end
		end
		table.insert(BaseTable, TableData)
		Decimal = math.floor(Decimal / Base)
	until Decimal / Base == 0
	for i = 1, math.floor(#BaseTable / 2), 1 do
		local v = #BaseTable - i + 1
		BaseTable[i], BaseTable[v] = BaseTable[v], BaseTable[i]
	end
	Base = ""
	for i = 1, #BaseTable, 1 do
		Base ..= BaseTable[i]
	end
	return Sign..Base..Fraction
end
function MathModule.Convert:BaseToDecimal(Table)
	if type(Table) == "table" and Table[2] then else return warn("only tables are allowed in this function") end
	if Table[3] then return warn("you can't have three table values") end
	for i = 1, #Table, 1 do
		if Table[2] % 1 == 0 then else return warn("bases have to be whole numbers") end
	end
	if Table[2] > 36 then return warn("no bases above 36 are allowed") end
	if Table[2] < 1 then return warn("no bases below 1 are allowed") end
	if Table[2] == 10 then return warn("base 10 is not allowed") end
	local BaseValue = Table[1]
	local Base = Table[2]
	local Fraction = ""
	local Sign = ""
	local UnlockFraction = false
	local BaseValueTable = {}
	local Base1To36 = {
		[0] = "0",
		[1] = "1",
		[2] = "2",
		[3] = "3",
		[4] = "4",
		[5] = "5",
		[6] = "6",
		[7] = "7",
		[8] = "8",
		[9] = "9",
		[10] = "A",
		[11] = "B",
		[12] = "C",
		[13] = "D",
		[14] = "E",
		[15] = "F",
		[16] = "G",
		[17] = "H",
		[18] = "I",
		[19] = "J",
		[20] = "K",
		[21] = "L",
		[22] = "M",
		[23] = "N",
		[24] = "O",
		[25] = "P",
		[26] = "Q",
		[27] = "R",
		[28] = "S",
		[29] = "T",
		[30] = "U",
		[31] = "V",
		[32] = "W",
		[33] = "X",
		[34] = "Y",
		[35] = "Z"
	}
	if math.abs(BaseValue) + BaseValue == 0 and BaseValue ~= 0 then
		BaseValue = math.abs(BaseValue)
		Sign = "-"
	end
	for Character in tostring(BaseValue):gmatch(".") do
		if UnlockFraction == true then
			table.insert(BaseValueTable, Character)
		end
		if Character == "." then
			UnlockFraction = true
		end
		for i = 1, #Base1To36, 1 do
			if table.find(Base1To36, Character, i) and i >= Base then return warn("make sure your base value is in order with your base") end
		end
	end
	for i = 1, math.floor(#BaseValueTable / 2), 1 do
		local v = #BaseValueTable - i + 1
		BaseValueTable[i], BaseValueTable[v] = BaseValueTable[v], BaseValueTable[i]
	end
	local DF = math.floor(BaseValue - (BaseValue % 1))
	local FractionCheck = BaseValue % 1 ~= 0
	Fraction = DF
	local Digits = 0
	while true do wait()
		Digits += 1
		if (BaseValue * (10^Digits)) % 1 == 0 then
			break
		end
	end
	Fraction = tonumber(string.format("%."..(Digits or 0).."f", BaseValue - Fraction))
	BaseValue = DF
	if FractionCheck then
		for i = 1, #BaseValueTable, 1 do
			local Data = BaseValueTable[i]
			for ii = 1, #Base1To36, 1 do
				if table.find(Base1To36, Data, ii) then
					Data = Base1To36[ii]
				end
			end
			if i == 1 then
				Fraction = (Data + 0) / Base
			else
				Fraction = (Data + Fraction) / Base
			end
		end
		if DF == 0 then
			return Sign..Fraction
		end
	end
	Base = tonumber(BaseValue, Base)
	return Sign..Base + Fraction
end
function MathModule.Convert:BaseToBase(Table)
	if type(Table) == "table" and Table[3] then else return warn("only tables are allowed in this function") end
	if Table[4] then return warn("you can't have four table values") end
	for i = 1, #Table, 1 do
		if Table[2] % 1 == 0 and Table[3] % 1 == 0 then else return warn("bases have to be whole numbers") end
	end
	if Table[2] > 36 or Table[3] > 36 then return warn("no bases above 36 are allowed") end
	if Table[2] < 1 or Table[3] < 1 then return warn("no bases below 1 are allowed") end
	local BaseValue = Table[1]
	local Base1 = Table[2]
	local Base2 = Table[3]
	local Base1To36 = {
		[0] = "0",
		[1] = "1",
		[2] = "2",
		[3] = "3",
		[4] = "4",
		[5] = "5",
		[6] = "6",
		[7] = "7",
		[8] = "8",
		[9] = "9",
		[10] = "A",
		[11] = "B",
		[12] = "C",
		[13] = "D",
		[14] = "E",
		[15] = "F",
		[16] = "G",
		[17] = "H",
		[18] = "I",
		[19] = "J",
		[20] = "K",
		[21] = "L",
		[22] = "M",
		[23] = "N",
		[24] = "O",
		[25] = "P",
		[26] = "Q",
		[27] = "R",
		[28] = "S",
		[29] = "T",
		[30] = "U",
		[31] = "V",
		[32] = "W",
		[33] = "X",
		[34] = "Y",
		[35] = "Z"
	}
	for Character in tostring(BaseValue):gmatch(".") do
		for i = 1, #Base1To36, 1 do
			if table.find(Base1To36, Character, i) and i >= Base1 then return warn("make sure your base value is in order with your base") end
		end
	end
	return MathModule.Convert:DecimalToBase({tonumber(MathModule.Convert:BaseToDecimal({BaseValue, Base1})), Base2})
end
function MathModule.Convert:DecimalToRomanNumeral(n)
	if typeof(n) == "number" then else return warn("only numbers are allowed") end
	if n == 0 then return warn("number can't be 0") end
	local RomanNumerals = ""
	local RomanTable = {
		{1000, "M"},
		{900, "CM"},
		{500, "D"},
		{400, "CD"},
		{100, "C"},
		{90, "XC"},
		{50, "L"},
		{40, "XL"},
		{10, "X"},
		{9, "IX"},
		{5, "V"},
		{4, "IV"},
		{1, "I"}
	}
	for i, v in pairs(RomanTable) do
		local ii, vv = unpack(v)
		while n >= ii do
			n -= ii
			RomanNumerals ..= vv
		end
	end
	return RomanNumerals
end
function MathModule.Convert:RomanNumeralToDecimal(s)
	if typeof(s) == "string" then else return warn("only roman numerals are allowed") end
	local Decimal = 0
	local i = 1
	local RomanNumeralLength = string.len(s)
	local RomanTable = {
		["M"] = 1000,
		["D"] = 500,
		["C"] = 100,
		["L"] = 50,
		["X"] = 10,
		["V"] = 5,
		["I"] = 1
	}
	for Character in tostring(s):gmatch(".") do
		local StringCheck = false
		for i, v in pairs(RomanTable) do
			if Character == i then StringCheck = true end
		end
		if StringCheck == false then return warn("make sure your Roman Numerals are using the correct letters") end
	end
	while i < RomanNumeralLength do
		local Z1 = RomanTable[string.sub(s, i, i)]
		local Z2 = RomanTable[string.sub(s, i + 1, i + 1)]
		if Z1 < Z2 then
			Decimal += (Z2 - Z1)
			i += 2
		else
			Decimal += Z1
			i += 1
		end
	end
	if i <= RomanNumeralLength then
		Decimal += RomanTable[string.sub(s, i, i)]
	end
	return Decimal
end
function MathModule.Convert:FahrenheitToCelsius(n)
	if typeof(n) == "number" then else return warn("only numbers are allowed") end
	return (n - 32) * (5 / 9)
end
function MathModule.Convert:CelsiusToFahrenheit(n)
	if typeof(n) == "number" then else return warn("only numbers are allowed") end
	return (n * (9 / 5)) + 32
end
--[[
CLASS Check
]]
function MathModule.Check:Integer(n)
	if typeof(n) == "number" then else return false end
	if n % 1 == 0 then
		return true
	else
		return false
	end
end
function MathModule.Check:NonInteger(n)
	if typeof(n) == "number" then else return false end
	if n % 1 ~= 0 then
		return true
	else
		return false
	end
end
function MathModule.Check:Prime(n)
	if typeof(n) == "number" then else return false end
	if n < 1 then return false end
	if n % 1 ~= 0 then return false end
	if n > 2 and n % 2 == 0 then return false end
	for i = 2, n^(1 / 2) do
		if (n % i) == 0 then
			return false
		end
	end
	return true
end
function MathModule.Check:Unprimeable(n)
	if typeof(n) == "number" then else return false end
	if MathModule.Check:Prime(n) == true then return false end
	if n % 1 ~= 0 then return false end
	local StringN1 = tostring(n)
	local StringN2 = tostring(n)
	local Digits = string.len(StringN1)
	local PastDigit = 0
	for i = 1, Digits * 10, 1 do
		local Digit = math.ceil(i / 10)
		if Digit > PastDigit then
			StringN1 = StringN2
		end
		PastDigit = Digit
		local DigitReplace = i - (9 * (Digit - 1)) - Digit
		StringN1 = table.concat{StringN1:sub(1, Digit - 1), DigitReplace, StringN1:sub(Digit + 1)}
		if MathModule.Check:Prime(tonumber(StringN1)) == true then return false end
	end
	return true
end
--[[
CLASS Notation
]]
function MathModule.Notation:Scientific(n)
	if typeof(n) == "number" then else return warn("only numbers are allowed") end
	if n == 0 then return warn("number can't be 0") end
	local Repeat = 0
	if math.abs(n) >= 10 then
		if string.match(n, "^-") then
			repeat
				Repeat += 1
				n /= 10
			until n > -10
			return n.." * 10^"..Repeat
		else
			repeat
				Repeat += 1
				n /= 10
			until n < 10
			return n.." * 10^"..Repeat
		end
	elseif math.abs(n) < 1 then
		if string.match(n, "^-") then
			repeat
				Repeat += 1
				n *= 10
			until n <= -1
			return n.." * 10^"..-Repeat
		else
			repeat
				Repeat += 1
				n *= 10
			until n >= 1
			return n.." * 10^"..-Repeat
		end
	end
end
function MathModule.Notation:E(n)
	if typeof(n) == "number" then else return warn("only numbers are allowed") end
	if n == 0 then return warn("number can't be 0") end
	local Repeat = 0
	if math.abs(n) >= 10 then
		if string.match(n, "^-") then
			repeat
				Repeat += 1
				n /= 10
			until n > -10
			return n.."e+"..Repeat
		else
			repeat
				Repeat += 1
				n /= 10
			until n < 10
			return n.."e+"..Repeat
		end
	elseif math.abs(n) < 1 then
		if string.match(n, "^-") then
			repeat
				Repeat += 1
				n *= 10
			until n <= -1
			return n.."e"..-Repeat
		else
			repeat
				Repeat += 1
				n *= 10
			until n >= 1
			return n.."e"..-Repeat
		end
	end
end
function MathModule.Notation:Engineering(n)
	if typeof(n) == "number" then else return warn("only numbers are allowed") end
	if n == 0 then return warn("number can't be 0") end
	local Repeat = 0
	if math.abs(n) >= 10 then
		if string.match(n, "^-") then
			repeat
				Repeat += 1
				n /= 10
			until n > -10
		else
			repeat
				Repeat += 1
				n /= 10
			until n < 10
		end
		if Repeat % 3 == 0 or Repeat == 0 then
			return n.." * 10^"..Repeat
		else
			repeat
				Repeat -= 1
				n *= 10
			until Repeat % 3 == 0 or Repeat == 0
			return n.." * 10^"..Repeat
		end
	elseif math.abs(n) < 1 then
		if string.match(n, "^-") then
			repeat
				Repeat += 1
				n *= 10
			until n <= -1
		else
			repeat
				Repeat += 1
				n *= 10
			until n >= 1
		end
		if Repeat % 3 == 0 or Repeat == 0 then
			return n.." * 10^"..-Repeat
		else
			repeat
				Repeat += 1
				n *= 10
			until Repeat % 3 == 0 or Repeat == 0
			return n.." * 10^"..Repeat
		end
	end
end
--[[
CLASS Random
]]
function MathModule.Random:Addition(Table)
	if type(Table) == "table" and Table[4] then else return warn("only tables are allowed in this function") end
	if Table[5] then return warn("you can't have five table values") end
	for i = 1, #Table, 1 do
		if typeof(Table[i]) == "number" then else return warn("only numbers are allowed in the table") end
	end
	local Min = Table[1]
	local Max = Table[2]
	local EndProduct = Table[3]
	local RepeatN = Table[4]
	if RepeatN % 1 ~= 0 or RepeatN == 0 then return warn("The total numbers have to be a whole number above 0") end
	if Max * RepeatN >= EndProduct then else return warn("End Product has to be less than or equal to the max number possible") end
	if Min <= EndProduct / Max then else return warn("Minimum has to be less than or equal to the min divider possible") end
	if Min > Max then return warn("min can't be greater than max") end
	local RandomTable = {}
	if RepeatN % 2 == 0 then
		local SplitN = RepeatN / 2
		local DividN = EndProduct / SplitN
		local RangeN = (2 - (DividN / Max)) * Max
		for i = 1, SplitN, 1 do
			local SplitProduct = DividN
			for i = 1, 2, 1 do
				if i ~= 2 then
					local RandomNumber = Random.new():NextNumber(Max - RangeN, Max)
					table.insert(RandomTable, RandomNumber)
					SplitProduct -= RandomNumber
				else
					table.insert(RandomTable, SplitProduct)
					SplitProduct -= SplitProduct
				end
			end
		end
	else
		if RepeatN ~= 1 then
			local RN = Random.new():NextNumber(Min, Max)
			table.insert(RandomTable, RN)
			local SplitN = (RepeatN - 1) / 2
			local DividN = (EndProduct - RN) / SplitN
			local RangeN = (2 - (DividN / Max)) * Max
			for i = 1, SplitN, 1 do
				local SplitProduct = DividN
				for i = 1, 2, 1 do
					if i ~= 2 then
						local RandomNumber = Random.new():NextNumber(Max - RangeN, Max)
						table.insert(RandomTable, RandomNumber)
						SplitProduct -= RandomNumber
					else
						table.insert(RandomTable, SplitProduct)
						SplitProduct -= SplitProduct
					end
				end
			end
		else
			table.insert(RandomTable, Max)
		end
	end
	return RandomTable
end
function MathModule.Random:Multiplication(Table)
	if type(Table) == "table" and Table[4] then else return warn("only tables are allowed in this function") end
	if Table[5] then return warn("you can't have five table values") end
	for i = 1, #Table, 1 do
		if typeof(Table[i]) == "number" then else return warn("only numbers are allowed in the table") end
	end
	local Min = Table[1]
	local Max = Table[2]
	local EndProduct = Table[3]
	local RepeatN = Table[4]
	if RepeatN % 1 ~= 0 or RepeatN == 0 then return warn("The total numbers have to be a whole number above 0") end
	if Max^RepeatN >= EndProduct then else return warn("End Product has to be less than or equal to the max number possible") end
	if Min <= RepeatN * math.sqrt(Max) then else return warn("Minimum has to be less than or equal to the min divider possible") end
	if Min > Max then return warn("min can't be greater than max") end
	local RandomTable = {}
	local function SNToDN(EP, SN)
		local DN = EP
		for i = 1, SN - 1, 1 do
			DN = math.sqrt(DN)
		end
		return DN
	end
	if RepeatN % 2 == 0 then
		local SplitN = RepeatN / 2
		local DividN = SNToDN(EndProduct, SplitN)
		local RangeN = EndProduct / Max
		for i = 1, SplitN, 1 do
			local SplitProduct = DividN
			for i = 1, 2, 1 do
				if i ~= 2 then
					local RandomNumber = Random.new():NextNumber(RangeN, Max)
					table.insert(RandomTable, RandomNumber)
					SplitProduct /= RandomNumber
				else
					table.insert(RandomTable, SplitProduct)
					SplitProduct -= SplitProduct
				end
			end
		end
	else
		if RepeatN ~= 1 then
			local RN = Random.new():NextNumber(Min, Max)
			table.insert(RandomTable, RN)
			local SplitN = (RepeatN - 1) / 2
			local DividN = SNToDN(EndProduct / RN, SplitN)
			local RangeN = (EndProduct / RN) / Max
			for i = 1, SplitN, 1 do
				local SplitProduct = DividN
				for i = 1, 2, 1 do
					if i ~= 2 then
						local RandomNumber = Random.new():NextNumber(RangeN, Max)
						table.insert(RandomTable, RandomNumber)
						SplitProduct /= RandomNumber
					else
						table.insert(RandomTable, SplitProduct)
						SplitProduct -= SplitProduct
					end
				end
			end
		else
			table.insert(RandomTable, Max)
		end
	end
	return RandomTable
end
function MathModule.Random:Integer(Table)
	if type(Table) == "table" and Table[2] then else return warn("only tables are allowed in this function") end
	if Table[3] then return warn("you can't have five table values") end
	for i = 1, #Table, 1 do
		if typeof(Table[i]) == "number" then else return warn("only numbers are allowed in the table") end
	end
	local Min = Table[1]
	local Max = Table[2]
	if Min > Max then return warn("min can't be greater than max") end
	return Random.new():NextInteger(Min, Max)
end
function MathModule.Random:NonInteger(Table)
	if type(Table) == "table" and Table[2] then else return warn("only tables are allowed in this function") end
	if Table[3] then return warn("you can't have five table values") end
	for i = 1, #Table, 1 do
		if typeof(Table[i]) == "number" then else return warn("only numbers are allowed in the table") end
	end
	local Min = Table[1]
	local Max = Table[2]
	if Min > Max then return warn("min can't be greater than max") end
	return Random.new():NextNumber(Min, Max)
end
--[[
CLASS Matrix
]]
function MathModule.Matrix:Multiplication(Table)
	local Table1 = Table[1]
	local Table2 = Table[2]
	local Table3 = Table[3]
	if type(Table1) == "table" and Table1[1] then else return warn("only tables are allowed in this function") end
	if type(Table2) == "table" and Table2[1] then else return warn("only tables are allowed in this function") end
	if Table3 then return warn("you can't enter more then two tables into the function") end
	for i = 1, #Table1, 1 do
		if typeof(Table1[i]) == "table" then
			for ii = 1, #Table1[i], 1 do
				if typeof(Table1[i][ii]) == "number" then else return warn("only numbers are allowed in the table") end
			end
		else
			return warn("only matrices are allowed in this function")
		end
	end
	for i = 1, #Table2, 1 do
		if typeof(Table2[i]) == "table" then
			for ii = 1, #Table2[i], 1 do
				if typeof(Table2[i][ii]) == "number" then else return warn("only numbers are allowed in the table") end
			end
		else
			return warn("only matrices are allowed in this function")
		end
	end
	if #Table1 > #Table2 then
		for i = 1, #Table2, 1 do
			if #Table2[i] ~= #Table1 then
				return warn("inner matrix dimensions have to agree")
			end			
		end
	elseif #Table1 < #Table2 or #Table1 == #Table2 then
		for i = 1, #Table1, 1 do
			if #Table1[i] ~= #Table2 then
				return warn("inner matrix dimensions have to agree")
			end			
		end
	end
	local Matrix = {}
	for i = 1, #Table1, 1 do
		Matrix[i] = {}
		for j = 1, #Table2[1], 1 do
			Matrix[i][j] = 0
			for k = 1, #Table2, 1 do
				Matrix[i][j] = Matrix[i][j] + Table1[i][k] * Table2[k][j]
			end
		end
	end
	return Matrix
end
function MathModule.Matrix:DotProduct(Table)
	local Table1 = Table[1]
	local Table2 = Table[2]
	local Table3 = Table[3]
	if type(Table1) == "table" then else return warn("only tables are allowed in this function") end
	if type(Table2) == "table" then else return warn("only tables are allowed in this function") end
	if Table3 then return warn("you can't have three tables") end
	if #Table1 ~= #Table2 then return warn("both tables need the same amount of values inside") end
	if #Table1 == 3 and #Table2 == 3 then else return warn("both tables need 3 values each") end
	for i = 1, #Table1, 1 do
		if typeof(Table1[i]) == "number" then else return warn("only numbers are allowed in the table") end
	end
	for i = 1, #Table2, 1 do
		if typeof(Table2[i]) == "number" then else return warn("only numbers are allowed in the table") end
	end
	local Product = 0
	for i = 1, #Table1 do
		Product += Table1[i] * Table2[i]
	end
	return Product
end
function MathModule.Matrix:CrossProduct(Table)
	local Table1 = Table[1]
	local Table2 = Table[2]
	local Table3 = Table[3]
	if type(Table1) == "table" then else return warn("only tables are allowed in this function") end
	if type(Table2) == "table" then else return warn("only tables are allowed in this function") end
	if Table3 then return warn("you can't have three tables") end
	if #Table1 ~= #Table2 then return warn("both tables need the same amount of values inside") end
	if #Table1 == 3 and #Table2 == 3 then else return warn("both tables need 3 values each") end
	for i = 1, #Table1, 1 do
		if typeof(Table1[i]) == "number" then else return warn("only numbers are allowed in the table") end
	end
	for i = 1, #Table2, 1 do
		if typeof(Table2[i]) == "number" then else return warn("only numbers are allowed in the table") end
	end
	local TableX = Table1[2] * Table2[3] - Table1[3] * Table2[2]
	local TableY = Table1[3] * Table2[1] - Table1[1] * Table2[3]
	local TableZ = Table1[1] * Table2[2] - Table1[2] * Table2[1]
	return {TableX, TableY, TableZ}
end
function MathModule.Matrix:TensorProduct(Table)
	local Table1 = Table[1]
	local Table2 = Table[2]
	local Table3 = Table[3]
	if type(Table1) == "table" and Table1[1] then else return warn("only tables are allowed in this function") end
	if type(Table2) == "table" and Table2[1] then else return warn("only tables are allowed in this function") end
	if Table3 then return warn("you can't enter more then two tables into the function") end
	for i = 1, #Table1, 1 do
		if typeof(Table1[i]) == "table" then
			for ii = 1, #Table1[i], 1 do
				if typeof(Table1[i][ii]) == "number" then else return warn("only numbers are allowed in the table") end
			end
		else
			return warn("only matrices are allowed in this function")
		end
	end
	for i = 1, #Table2, 1 do
		if typeof(Table2[i]) == "table" then
			for ii = 1, #Table2[i], 1 do
				if typeof(Table2[i][ii]) == "number" then else return warn("only numbers are allowed in the table") end
			end
		else
			return warn("only matrices are allowed in this function")
		end
	end
	local Matrix = {}
	for m = 1, #Table1, 1 do
		for p = 1, #Table2, 1 do
			local Array = {}
			for n = 1, #Table1[m], 1 do
				for q = 1, #Table2[p], 1 do
					table.insert(Array, string.format("%3d ", Table1[m][n] * Table2[p][q]))
				end
			end
			table.insert(Matrix, Array)
		end
	end
	return Matrix
end
function MathModule.Matrix:Transposition(Table)
	if type(Table) == "table" and Table[1] then else return warn("only tables are allowed in this function") end
	for i = 1, #Table, 1 do
		if typeof(Table[i]) == "table" then
			for ii = 1, #Table[i], 1 do
				if typeof(Table[i][ii]) == "number" then else return warn("only numbers are allowed in the table") end
			end
		else
			return warn("only matrices are allowed in this function")
		end
	end
	local Tranposition = {}
	for i = 1, #Table[1], 1 do
		Tranposition[i] = {}
		for j = 1, #Table, 1 do
			Tranposition[i][j] = Table[j][i]
		end
	end
	return Tranposition
end
function MathModule.Matrix:ZigZag(n)
	if typeof(n) == "number" then else return warn("only numbers are allowed") end
	if n % 1 == 0 and n >= 2 then else return warn("number has to be a whole number and can't be smaller than 2") end
	local ZigZagMatrix = {}
	local i = 0
	local j = 0
	for j = 1, n do
		ZigZagMatrix[j] = {}
		for i = 1, n do
			ZigZagMatrix[j][i] = 0
		end
	end
	i = 1
	j = 1
	local di = 0
	local dj = 0
	local k = 0
	while k < n * n do
		ZigZagMatrix[j][i] = k
		k = k + 1
		if i == n then
			j += 1
			ZigZagMatrix[j][i] = k
			k += 1
			di = -1
			dj = 1
		end
		if j == 1 then
			i += 1
			ZigZagMatrix[j][i] = k
			k += 1
			di = -1
			dj = 1
		end
		if j == n then
			i += 1
			ZigZagMatrix[j][i] = k
			k += 1
			di = 1
			dj = -1
		end
		if i == 1 then
			j += 1
			ZigZagMatrix[j][i] = k
			k += 1
			di = 1
			dj = -1
		end
		i += di
		j += dj
	end
	return ZigZagMatrix
end
--[[
CLASS Special
]]
function MathModule.Special:Factorial(n)
	if typeof(n) == "number" then else return warn("only numbers are allowed") end
	local function gammafunction(z)
		local gamma = MathModule.Value:EulersConstant()
		local coeff = MathModule.Value:GammaCoeff()
		local quad = MathModule.Value:GammaQuad()
		local qui = MathModule.Value:GammaQui()
		local set = MathModule.Value:GammaSet()
		local function recigamma(rz)
			return rz + gamma * rz^2 + coeff * rz^3 + quad * rz^4 + qui * rz^5 + set * rz^6
		end
		if z == 1 then
			return 1
		elseif math.abs(z) <= 0.5 then
			return 1 / recigamma(z)
		else
			return (z - 1) * gammafunction(z - 1)
		end
	end
	if math.abs(n) + n == 0 and n ~= 0 then
		n *= -1
		local N = gammafunction(n + 1)
		N *= -1
		return N
	else
		return gammafunction(n + 1)
	end
end
function MathModule.Special:NthRoot(Table)
	if type(Table) == "table" and Table[2] then else return warn("only tables are allowed in this function") end
	if Table[3] then return warn("you can't have three table values") end
	for i = 1, #Table, 1 do
		if typeof(Table[i]) == "number" then else return warn("only whole numbers are allowed in the table") end
	end
	local Number = Table[1]
	local NthRoot = Table[2]
	local FractionCheck = false
	if NthRoot % 1 ~= 0 then
		FractionCheck = true
	end
	if math.abs(Number) + Number == 0 and Number ~= 0 then
		local EvenCheck = 2
		if FractionCheck == true then
			EvenCheck = -2
		end
		if NthRoot % EvenCheck == 0 then
			return ((-Number)^(1 / NthRoot)).."i"
		else
			return -((-Number)^(1 / NthRoot))
		end
	end
	return Number^(1 / NthRoot)
end
function MathModule.Special:PerNth(Table)
	if type(Table) == "table" and Table[2] then else return warn("only tables are allowed in this function") end
	if Table[3] then return warn("you can't have three table values") end
	for i = 1, #Table, 1 do
		if typeof(Table[i]) == "number" then else return warn("only numbers are allowed in the table") end
	end
	local Number = Table[1]
	local NthValue = Table[2]
	local Answer = Number / NthValue
	return Answer.." or "..(Answer * 100).."%"
end

return MathModule
end)() end
} -- [RefId] = Closure

-- Holds the actual DOM data
local ObjectTree = {
    {
        1,
        2,
        {
            "Repo"
        },
        {
            {
                9,
                3,
                {
                    "CLASS_Random"
                }
            },
            {
                3,
                3,
                {
                    "CLASS_Sequence"
                }
            },
            {
                5,
                3,
                {
                    "CLASS_Convert"
                }
            },
            {
                7,
                3,
                {
                    "CLASS_Notation"
                }
            },
            {
                4,
                3,
                {
                    "CLASS_String"
                }
            },
            {
                6,
                3,
                {
                    "CLASS_Check"
                }
            },
            {
                2,
                3,
                {
                    "CLASS_Value"
                }
            },
            {
                11,
                3,
                {
                    "CLASS_Chance"
                }
            },
            {
                10,
                3,
                {
                    "Class_Special"
                }
            },
            {
                8,
                3,
                {
                    "CLASS_Matrix"
                }
            }
        }
    }
}

-- Line offsets for debugging (only included when minifyTables is false)
local LineOffsets = {
    8
}

-- Misc AOT variable imports
local WaxVersion = "0.4.1"
local EnvName = "WaxRuntime"

-- ++++++++ RUNTIME IMPL BELOW ++++++++ --

-- Localizing certain libraries and built-ins for runtime efficiency
local string, task, setmetatable, error, next, table, unpack, coroutine, script, type, require, pcall, tostring, tonumber, _VERSION =
      string, task, setmetatable, error, next, table, unpack, coroutine, script, type, require, pcall, tostring, tonumber, _VERSION

local table_insert = table.insert
local table_remove = table.remove
local table_freeze = table.freeze or function(t) return t end -- lol

local coroutine_wrap = coroutine.wrap

local string_sub = string.sub
local string_match = string.match
local string_gmatch = string.gmatch

-- The Lune runtime has its own `task` impl, but it must be imported by its builtin
-- module path, "@lune/task"
if _VERSION and string_sub(_VERSION, 1, 4) == "Lune" then
    local RequireSuccess, LuneTaskLib = pcall(require, "@lune/task")
    if RequireSuccess and LuneTaskLib then
        task = LuneTaskLib
    end
end

local task_defer = task and task.defer

-- If we're not running on the Roblox engine, we won't have a `task` global
local Defer = task_defer or function(f, ...)
    coroutine_wrap(f)(...)
end

-- ClassName "IDs"
local ClassNameIdBindings = {
    [1] = "Folder",
    [2] = "ModuleScript",
    [3] = "Script",
    [4] = "LocalScript",
    [5] = "StringValue",
}

local RefBindings = {} -- [RefId] = RealObject

local ScriptClosures = {}
local ScriptClosureRefIds = {} -- [ScriptClosure] = RefId
local StoredModuleValues = {}
local ScriptsToRun = {}

-- wax.shared __index/__newindex
local SharedEnvironment = {}

-- We're creating 'fake' instance refs soley for traversal of the DOM for require() compatibility
-- It's meant to be as lazy as possible
local RefChildren = {} -- [Ref] = {ChildrenRef, ...}

-- Implemented instance methods
local InstanceMethods = {
    GetFullName = { {}, function(self)
        local Path = self.Name
        local ObjectPointer = self.Parent

        while ObjectPointer do
            Path = ObjectPointer.Name .. "." .. Path

            -- Move up the DOM (parent will be nil at the end, and this while loop will stop)
            ObjectPointer = ObjectPointer.Parent
        end

        return Path
    end},

    GetChildren = { {}, function(self)
        local ReturnArray = {}

        for Child in next, RefChildren[self] do
            table_insert(ReturnArray, Child)
        end

        return ReturnArray
    end},

    GetDescendants = { {}, function(self)
        local ReturnArray = {}

        for Child in next, RefChildren[self] do
            table_insert(ReturnArray, Child)

            for _, Descendant in next, Child:GetDescendants() do
                table_insert(ReturnArray, Descendant)
            end
        end

        return ReturnArray
    end},

    FindFirstChild = { {"string", "boolean?"}, function(self, name, recursive)
        local Children = RefChildren[self]

        for Child in next, Children do
            if Child.Name == name then
                return Child
            end
        end

        if recursive then
            for Child in next, Children do
                -- Yeah, Roblox follows this behavior- instead of searching the entire base of a
                -- ref first, the engine uses a direct recursive call
                return Child:FindFirstChild(name, true)
            end
        end
    end},

    FindFirstAncestor = { {"string"}, function(self, name)
        local RefPointer = self.Parent
        while RefPointer do
            if RefPointer.Name == name then
                return RefPointer
            end

            RefPointer = RefPointer.Parent
        end
    end},

    -- Just to implement for traversal usage
    WaitForChild = { {"string", "number?"}, function(self, name)
        return self:FindFirstChild(name)
    end},
}

-- "Proxies" to instance methods, with err checks etc
local InstanceMethodProxies = {}
for MethodName, MethodObject in next, InstanceMethods do
    local Types = MethodObject[1]
    local Method = MethodObject[2]

    local EvaluatedTypeInfo = {}
    for ArgIndex, TypeInfo in next, Types do
        local ExpectedType, IsOptional = string_match(TypeInfo, "^([^%?]+)(%??)")
        EvaluatedTypeInfo[ArgIndex] = {ExpectedType, IsOptional}
    end

    InstanceMethodProxies[MethodName] = function(self, ...)
        if not RefChildren[self] then
            error("Expected ':' not '.' calling member function " .. MethodName, 2)
        end

        local Args = {...}
        for ArgIndex, TypeInfo in next, EvaluatedTypeInfo do
            local RealArg = Args[ArgIndex]
            local RealArgType = type(RealArg)
            local ExpectedType, IsOptional = TypeInfo[1], TypeInfo[2]

            if RealArg == nil and not IsOptional then
                error("Argument " .. RealArg .. " missing or nil", 3)
            end

            if ExpectedType ~= "any" and RealArgType ~= ExpectedType and not (RealArgType == "nil" and IsOptional) then
                error("Argument " .. ArgIndex .. " expects type \"" .. ExpectedType .. "\", got \"" .. RealArgType .. "\"", 2)
            end
        end

        return Method(self, ...)
    end
end

local function CreateRef(className, name, parent)
    -- `name` and `parent` can also be set later by the init script if they're absent

    -- Extras
    local StringValue_Value

    -- Will be set to RefChildren later aswell
    local Children = setmetatable({}, {__mode = "k"})

    -- Err funcs
    local function InvalidMember(member)
        error(member .. " is not a valid (virtual) member of " .. className .. " \"" .. name .. "\"", 3)
    end
    local function ReadOnlyProperty(property)
        error("Unable to assign (virtual) property " .. property .. ". Property is read only", 3)
    end

    local Ref = {}
    local RefMetatable = {}

    RefMetatable.__metatable = false

    RefMetatable.__index = function(_, index)
        if index == "ClassName" then -- First check "properties"
            return className
        elseif index == "Name" then
            return name
        elseif index == "Parent" then
            return parent
        elseif className == "StringValue" and index == "Value" then
            -- Supporting StringValue.Value for Rojo .txt file conv
            return StringValue_Value
        else -- Lastly, check "methods"
            local InstanceMethod = InstanceMethodProxies[index]

            if InstanceMethod then
                return InstanceMethod
            end
        end

        -- Next we'll look thru child refs
        for Child in next, Children do
            if Child.Name == index then
                return Child
            end
        end

        -- At this point, no member was found; this is the same err format as Roblox
        InvalidMember(index)
    end

    RefMetatable.__newindex = function(_, index, value)
        -- __newindex is only for props fyi
        if index == "ClassName" then
            ReadOnlyProperty(index)
        elseif index == "Name" then
            name = value
        elseif index == "Parent" then
            -- We'll just ignore the process if it's trying to set itself
            if value == Ref then
                return
            end

            if parent ~= nil then
                -- Remove this ref from the CURRENT parent
                RefChildren[parent][Ref] = nil
            end

            parent = value

            if value ~= nil then
                -- And NOW we're setting the new parent
                RefChildren[value][Ref] = true
            end
        elseif className == "StringValue" and index == "Value" then
            -- Supporting StringValue.Value for Rojo .txt file conv
            StringValue_Value = value
        else
            -- Same err as __index when no member is found
            InvalidMember(index)
        end
    end

    RefMetatable.__tostring = function()
        return name
    end

    setmetatable(Ref, RefMetatable)

    RefChildren[Ref] = Children

    if parent ~= nil then
        RefChildren[parent][Ref] = true
    end

    return Ref
end

-- Create real ref DOM from object tree
local function CreateRefFromObject(object, parent)
    local RefId = object[1]
    local ClassNameId = object[2]
    local Properties = object[3] -- Optional
    local Children = object[4] -- Optional

    local ClassName = ClassNameIdBindings[ClassNameId]

    local Name = Properties and table_remove(Properties, 1) or ClassName

    local Ref = CreateRef(ClassName, Name, parent) -- 3rd arg may be nil if this is from root
    RefBindings[RefId] = Ref

    if Properties then
        for PropertyName, PropertyValue in next, Properties do
            Ref[PropertyName] = PropertyValue
        end
    end

    if Children then
        for _, ChildObject in next, Children do
            CreateRefFromObject(ChildObject, Ref)
        end
    end

    return Ref
end

local RealObjectRoot = CreateRef("Folder", "[" .. EnvName .. "]")
for _, Object in next, ObjectTree do
    CreateRefFromObject(Object, RealObjectRoot)
end

-- Now we'll set script closure refs and check if they should be ran as a BaseScript
for RefId, Closure in next, ClosureBindings do
    local Ref = RefBindings[RefId]

    ScriptClosures[Ref] = Closure
    ScriptClosureRefIds[Ref] = RefId

    local ClassName = Ref.ClassName
    if ClassName == "LocalScript" or ClassName == "Script" then
        table_insert(ScriptsToRun, Ref)
    end
end

local function LoadScript(scriptRef)
    local ScriptClassName = scriptRef.ClassName

    -- First we'll check for a cached module value (packed into a tbl)
    local StoredModuleValue = StoredModuleValues[scriptRef]
    if StoredModuleValue and ScriptClassName == "ModuleScript" then
        return unpack(StoredModuleValue)
    end

    local Closure = ScriptClosures[scriptRef]

    local function FormatError(originalErrorMessage)
        originalErrorMessage = tostring(originalErrorMessage)

        local VirtualFullName = scriptRef:GetFullName()

        -- Check for vanilla/Roblox format
        local OriginalErrorLine, BaseErrorMessage = string_match(originalErrorMessage, "[^:]+:(%d+): (.+)")

        if not OriginalErrorLine or not LineOffsets then
            return VirtualFullName .. ":*: " .. (BaseErrorMessage or originalErrorMessage)
        end

        OriginalErrorLine = tonumber(OriginalErrorLine)

        local RefId = ScriptClosureRefIds[scriptRef]
        local LineOffset = LineOffsets[RefId]

        local RealErrorLine = OriginalErrorLine - LineOffset + 1
        if RealErrorLine < 0 then
            RealErrorLine = "?"
        end

        return VirtualFullName .. ":" .. RealErrorLine .. ": " .. BaseErrorMessage
    end

    -- If it's a BaseScript, we'll just run it directly!
    if ScriptClassName == "LocalScript" or ScriptClassName == "Script" then
        local RunSuccess, ErrorMessage = pcall(Closure)
        if not RunSuccess then
            error(FormatError(ErrorMessage), 0)
        end
    else
        local PCallReturn = {pcall(Closure)}

        local RunSuccess = table_remove(PCallReturn, 1)
        if not RunSuccess then
            local ErrorMessage = table_remove(PCallReturn, 1)
            error(FormatError(ErrorMessage), 0)
        end

        StoredModuleValues[scriptRef] = PCallReturn
        return unpack(PCallReturn)
    end
end

-- We'll assign the actual func from the top of this output for flattening user globals at runtime
-- Returns (in a tuple order): wax, script, require
function ImportGlobals(refId)
    local ScriptRef = RefBindings[refId]

    local function RealCall(f, ...)
        local PCallReturn = {pcall(f, ...)}

        local CallSuccess = table_remove(PCallReturn, 1)
        if not CallSuccess then
            error(PCallReturn[1], 3)
        end

        return unpack(PCallReturn)
    end

    -- `wax.shared` index
    local WaxShared = table_freeze(setmetatable({}, {
        __index = SharedEnvironment,
        __newindex = function(_, index, value)
            SharedEnvironment[index] = value
        end,
        __len = function()
            return #SharedEnvironment
        end,
        __iter = function()
            return next, SharedEnvironment
        end,
    }))

    local Global_wax = table_freeze({
        -- From AOT variable imports
        version = WaxVersion,
        envname = EnvName,

        shared = WaxShared,

        -- "Real" globals instead of the env set ones
        script = script,
        require = require,
    })

    local Global_script = ScriptRef

    local function Global_require(module, ...)
        local ModuleArgType = type(module)

        local ErrorNonModuleScript = "Attempted to call require with a non-ModuleScript"
        local ErrorSelfRequire = "Attempted to call require with self"

        if ModuleArgType == "table" and RefChildren[module]  then
            if module.ClassName ~= "ModuleScript" then
                error(ErrorNonModuleScript, 2)
            elseif module == ScriptRef then
                error(ErrorSelfRequire, 2)
            end

            return LoadScript(module)
        elseif ModuleArgType == "string" and string_sub(module, 1, 1) ~= "@" then
            -- The control flow on this SUCKS

            if #module == 0 then
                error("Attempted to call require with empty string", 2)
            end

            local CurrentRefPointer = ScriptRef

            if string_sub(module, 1, 1) == "/" then
                CurrentRefPointer = RealObjectRoot
            elseif string_sub(module, 1, 2) == "./" then
                module = string_sub(module, 3)
            end

            local PreviousPathMatch
            for PathMatch in string_gmatch(module, "([^/]*)/?") do
                local RealIndex = PathMatch
                if PathMatch == ".." then
                    RealIndex = "Parent"
                end

                -- Don't advance dir if it's just another "/" either
                if RealIndex ~= "" then
                    local ResultRef = CurrentRefPointer:FindFirstChild(RealIndex)
                    if not ResultRef then
                        local CurrentRefParent = CurrentRefPointer.Parent
                        if CurrentRefParent then
                            ResultRef = CurrentRefParent:FindFirstChild(RealIndex)
                        end
                    end

                    if ResultRef then
                        CurrentRefPointer = ResultRef
                    elseif PathMatch ~= PreviousPathMatch and PathMatch ~= "init" and PathMatch ~= "init.server" and PathMatch ~= "init.client" then
                        error("Virtual script path \"" .. module .. "\" not found", 2)
                    end
                end

                -- For possible checks next cycle
                PreviousPathMatch = PathMatch
            end

            if CurrentRefPointer.ClassName ~= "ModuleScript" then
                error(ErrorNonModuleScript, 2)
            elseif CurrentRefPointer == ScriptRef then
                error(ErrorSelfRequire, 2)
            end

            return LoadScript(CurrentRefPointer)
        end

        return RealCall(require, module, ...)
    end

    -- Now, return flattened globals ready for direct runtime exec
    return Global_wax, Global_script, Global_require
end

for _, ScriptRef in next, ScriptsToRun do
    Defer(LoadScript, ScriptRef)
end

-- AoT adjustment: Load init module (MainModule behavior)
return LoadScript(RealObjectRoot:GetChildren()[1])
