--!strict
local LootTable = require("../../ReplicatedStorage/Libs/LootTable")

local function runTests()
	print("--- Running LootTable Tests ---")

	-- Test: new (Array)
	local rtsArray = LootTable.new({"ItemA", "ItemB", "ItemC"})
	assert(rtsArray ~= nil, "Failed to initialize from array")
	assert(rtsArray:containsItem("ItemA") == true, "Array initialization missing ItemA")

	-- Test: new (Dictionary)
	local rtsDict = LootTable.new({
		["ItemA"] = 10,
		["ItemB"] = 20,
	})
	assert(rtsDict ~= nil, "Failed to initialize from dictionary")
	assert(rtsDict:containsItem("ItemA") == true, "Dictionary initialization missing ItemA")

	-- Test: new (Invalid)
	local success, _ = pcall(function()
		LootTable.new("string" :: any)
	end)
	assert(not success, "Expected error when initializing with a non-table")

	-- Test: getRandomItem
	local rtsSingle = LootTable.new({"ItemA"})
	assert(rtsSingle:getRandomItem() == "ItemA", "getRandomItem failed for array")

	local rtsDictSingle = LootTable.new({["ItemA"] = 10})
	assert(rtsDictSingle:getRandomItem() == "ItemA", "getRandomItem failed for dictionary")

	local rtsEmpty = LootTable.new({})
	assert(rtsEmpty:getRandomItem() == nil, "getRandomItem should return nil for empty structure")

	-- Test: getRandomItemWithWeight
	local rtsUniform = LootTable.new({"ItemA", "ItemB", "ItemC", "ItemD"})
	local uniformEntry = rtsUniform:getRandomItemWithWeight()
	assert(uniformEntry ~= nil, "getRandomItemWithWeight failed for array")
	assert(uniformEntry and uniformEntry.weight == 0.25, "Incorrect uniform weight for array")

	local rtsWeighted = LootTable.new({["ItemA"] = 10})
	local weightedEntry = rtsWeighted:getRandomItemWithWeight()
	assert(weightedEntry ~= nil, "getRandomItemWithWeight failed for dictionary")
	assert(weightedEntry and weightedEntry.item == "ItemA", "Incorrect item for dictionary weight")
	assert(weightedEntry and weightedEntry.weight == 1, "Incorrect normalized weight for dictionary")

	assert(rtsEmpty:getRandomItemWithWeight() == nil, "getRandomItemWithWeight should return nil for empty structure")

	-- Test: containsItem
	local rtsContains = LootTable.new({"ItemA", "ItemB"})
	assert(rtsContains:containsItem("ItemA") == true, "containsItem failed to find existing item")
	assert(rtsContains:containsItem("ItemC") == false, "containsItem incorrectly found non-existent item")

	-- Test: getAllItems
	local items = rtsContains:getAllItems()
	assert(#items == 2, "getAllItems returned incorrect number of items")
	assert(table.find(items, "ItemA") ~= nil, "getAllItems missing ItemA")
	assert(table.find(items, "ItemB") ~= nil, "getAllItems missing ItemB")

	-- Test: getAllItemsWithWeights
	local rtsWeights = LootTable.new({
		["ItemA"] = 10,
		["ItemB"] = 30,
	})
	local entries = rtsWeights:getAllItemsWithWeights()
	assert(#entries == 2, "getAllItemsWithWeights returned incorrect number of entries")
	
	local aEntryWeight = 0
	local bEntryWeight = 0
	for _, entry in entries do
		if entry.item == "ItemA" then
			aEntryWeight = entry.weight
		elseif entry.item == "ItemB" then
			bEntryWeight = entry.weight
		end
	end
	assert(aEntryWeight == 0.25, "getAllItemsWithWeights returned incorrect weight for ItemA")
	assert(bEntryWeight == 0.75, "getAllItemsWithWeights returned incorrect weight for ItemB")

	-- Test: getAllItemsWithWeightsSorted
	local rtsSorted = LootTable.new({
		["ItemA"] = 30,
		["ItemB"] = 10,
		["ItemC"] = 60,
	})
	local sortedEntries = rtsSorted:getAllItemsWithWeightsSorted()
	assert(#sortedEntries == 3, "getAllItemsWithWeightsSorted returned incorrect number of entries")
	assert(sortedEntries[1].item == "ItemB", "getAllItemsWithWeightsSorted incorrect sort at index 1")
	assert(sortedEntries[2].item == "ItemA", "getAllItemsWithWeightsSorted incorrect sort at index 2")
	assert(sortedEntries[3].item == "ItemC", "getAllItemsWithWeightsSorted incorrect sort at index 3")

	-- Test: addItem
	local rtsAddArray = LootTable.new({"ItemA"})
	rtsAddArray:addItem("ItemB")
	assert(rtsAddArray:containsItem("ItemB") == true, "addItem failed for array")
	assert(#rtsAddArray:getAllItems() == 2, "addItem incorrectly updated item list size for array")

	local rtsAddDict = LootTable.new({["ItemA"] = 10})
	rtsAddDict:addItem("ItemB", 10)
	assert(rtsAddDict:containsItem("ItemB") == true, "addItem failed for dictionary")
	
	local addEntries = rtsAddDict:getAllItemsWithWeights()
	assert(#addEntries == 2, "addItem incorrectly updated entry list size for dictionary")
	
	local bAddedWeight = 0
	for _, entry in addEntries do
		if entry.item == "ItemB" then
			bAddedWeight = entry.weight
		end
	end
	assert(bAddedWeight == 0.5, "addItem resulted in incorrect normalized weight for new item")

	-- Test: removeItem
	local rtsRemoveArray = LootTable.new({"ItemA", "ItemB", "ItemC"})
	local removeSuccess = rtsRemoveArray:removeItem("ItemB")
	assert(removeSuccess == true, "removeItem failed to remove existing item from array")
	assert(rtsRemoveArray:containsItem("ItemB") == false, "removeItem did not actually remove item from array")
	assert(#rtsRemoveArray:getAllItems() == 2, "removeItem incorrectly updated list size for array")

	local rtsRemoveDict = LootTable.new({
		["ItemA"] = 10,
		["ItemB"] = 20,
		["ItemC"] = 30,
	})
	local dictRemoveSuccess = rtsRemoveDict:removeItem("ItemB")
	assert(dictRemoveSuccess == true, "removeItem failed to remove existing item from dictionary")
	assert(rtsRemoveDict:containsItem("ItemB") == false, "removeItem did not actually remove item from dictionary")
	
	local removeEntries = rtsRemoveDict:getAllItemsWithWeights()
	assert(#removeEntries == 2, "removeItem incorrectly updated entry list size for dictionary")
	
	local aRemainingWeight = 0
	for _, entry in removeEntries do
		if entry.item == "ItemA" then
			aRemainingWeight = entry.weight
		end
	end
	-- Total weight was 60, removed 20, now 40. ItemA was 10, so 10/40 = 0.25
	assert(aRemainingWeight == 0.25, "removeItem incorrectly updated total weights")

	local notFoundSuccess = rtsRemoveArray:removeItem("NonExistentItem")
	assert(notFoundSuccess == false, "removeItem should return false for non-existent items")

	print("--- All LootTable Tests Passed! ---")
end

return runTests
