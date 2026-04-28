# LootTable

A lightweight, strongly-typed Luau utility for uniform and weighted random selection. Designed for Roblox, `LootTable` provides a stable and performant way to handle randomized selections with support for runtime mutations.

| 💡 *Note: While designed for Roblox, this is written in pure Luau and can be used outside of the Roblox engine.*

## Features

- 🎲 **Uniform & Weighted Selection**: Supports simple arrays for equal probability and dictionaries for custom weights.
- 🔄 **Stable Ordering**: Guarantees deterministic iteration order internally for predictable behavior.
- ⚡ **Performant**: Optimized selection logic with O(1) removals via swap-back.
- 🛠️ **Mutable**: Add or remove items dynamically at runtime.
- 🟦 **Strictly Typed**: Full Luau type support for a better developer experience.

## Installation

### Option 1: RBXM File
Download the latest `LootTable.rbxm` from the [Releases](https://github.com/YOUR_USERNAME/LootTable/releases) page and drag it into your Roblox Studio project (typically into `ReplicatedStorage` or `ServerStorage`).

### Option 2: Copy-Paste
1. Create a new `ModuleScript` named `LootTable`.
2. Copy the source code from `LootTable.luau` and paste it into the script.

## Usage

### Basic Array (Uniform Probability)
```lua
local LootTable = require(path.to.LootTable)

local rarityTable = LootTable.new({"Common", "Uncommon", "Rare"})
local result = rarityTable:getRandomItem()
print(result) -- Equal 33.3% chance for each
```

### Weighted Dictionary
```lua
local weights = {
	["Common"] = 70,
	["Uncommon"] = 25,
	["Legendary"] = 5,
}

local loot = LootTable.new(weights)
local item = loot:getRandomItem()
print(`You rolled: {item}`)
```

### Getting Selection Details
If you need both the item and its calculated probability:
```lua
local entry = loot:getRandomItemWithWeight()
if entry then
	print(`Dropped {entry.item} with a {entry.weight * 100}% chance!`)
end
```

### Dynamic Mutation
```lua
loot:addItem("Mythic", 1) -- Add a new item with weight 1
loot:removeItem("Common") -- Remove an item at runtime
```

## API Reference

### `LootTable.new(items: { string } | { [string]: number })`
Creates a new LootTable instance from either an array or a weighted dictionary.

| 💡 *Note: While technically set up to accept strings, you can use Roblox Instances directly as well.*

### `LootTable:getRandomItem(): string?`
Returns a randomly selected item.

### `LootTable:getRandomItemWithWeight(): { item: string, weight: number }?`
Returns a randomly selected item along with its normalized probability (0 to 1).

### `LootTable:addItem(item: string, weight: number?)`
Adds a new item to the table. If it's a weighted table, you can specify the weight (defaults to 1).

### `LootTable:removeItem(item: string): boolean`
Removes an item from the table. Returns `true` if successful.

### `LootTable:containsItem(item: string): boolean`
Returns whether the table contains the specified item.

### `LootTable:getAllItems(): { string }`
Returns an array containing all items in the table.

### `LootTable:getAllItemsWithWeightsSorted(): { { item: string, weight: number } }`
Returns a list of all entries sorted by their probability (ascending).

---
*Developed by Distracted Games*
