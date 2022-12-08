local CollectionService = game:GetService("CollectionService")
local RS = game:GetService("ReplicatedStorage")

local SomeFunctions= {}


--------------------FindFirstChild Functions--------------------

function SomeFunctions.FindFirstChildWithTag(Parent: Instance, Tag: string, Recursive: boolean?): Instance
	if typeof(Parent) ~= "Instance" then warn("Parent:", Parent, "must be an instance") return end
	if typeof(Tag) ~= "string" then warn("Tag:", Tag, "must be a string") return end
	for i, v in ipairs(Recursive and Parent:GetDescendants() or Parent:GetChildren()) do
		if CollectionService:HasTag(v, Tag) then
			return v
		end
	end
	return nil
end
--[[^Returns first child found with tag
SomeFunctions.FindFirstChildWithTag(Character, "Weapon")
]]

function SomeFunctions.RecursiveFindFirstChildOfClass(Parent: Instance, Class: string): Instance
	if typeof(Parent) ~= "Instance" then warn("Parent:", Parent, "must be an instance") return end
	if typeof(Class) ~= "string" then warn("Class:", Class, "must be a string") return end
	for i, v in ipairs(Parent:GetChildren()) do
		if v.ClassName == Class then
			return v
		end
		local child = SomeFunctions.RecursiveFindFirstChildOfClass(v, Class)
		if child then
			return child
		end
	end
	return nil
end
--[[^Returns first Descendant found of a class
function SomeFunctions.RecursiveFindFirstChildOfClass(Character, "IntValue")
]]


--------------------Object Creation--------------------

function SomeFunctions.CreateAnimation(ID: string): Animation
	if not ID then warn("AnimationId cannot be nil") return end
	local anim = Instance.new("Animation")
	anim.AnimationId = string.match(ID, "^rbxassetid://") and ID or "rbxassetid://"..ID
	return anim
end
--[[^like the function below but only for animations
SomeFunctions.CreateAnimtion"123456789"
]]

function SomeFunctions.CreateObjectWithProperties(ClassName: string, Properties: {[string]: any}): Instance
	local obj = Instance.new(ClassName)
	if not Properties then return end
	for i, v in pairs(Properties) do
		obj[i] = v
	end
	return obj
end
--[[^Returns a new object with the properties provided
SomeFunctions.CreateObjectWithProperties("Animation", {AnimationId = "123456789"})
]]

--------------------Table Functions--------------------

function SomeFunctions.DeepCopy(Table: {}, Depth: number?): {}
	local new = {}
	Depth = Depth or math.huge
	local CurrentLevel = 1
	for i, v in pairs(Table) do
		if typeof(v) == "table" then
			if Depth - 1 >= 1 then
				new[i] = SomeFunctions.DeepCopy(v, Depth - 1)
			end
		else
			new[i] = v
		end
	end
	return new
end
--[[^returns a copy of a table with a copy of the tables inside if found
SomeFunctions.DeepCopy({"Hi", ["1"] = {"Hello"}})
]]


--------------------WaitForChild Functions--------------------

function SomeFunctions.WaitForChildOfClass(Parent: Instance, Class: string, TimeOut: number?): Instance?
	local clock = os.clock()
	repeat task.wait() until
	Parent:FindFirstChildOfClass(Class) or (TimeOut and os.clock() - clock >= TimeOut)
	return Parent:FindFirstChildOfClass(Class)
end
--[[^yields thread until a child with the class is added or the timeout has passed and returns it
SomeFunctions.WaitForChildOfClass(Model, "IKControl", 2)
]]

function SomeFunctions.WaitForChildWithTag(Parent: Instance, Tag: string, TimeOut: number?): Instance?
	local clock = os.clock()
	repeat task.wait() until
	SomeFunctions.FindFirstChildWithTag(Parent, Tag) or (TimeOut and os.clock() - clock >= TimeOut)
	return SomeFunctions:FindFirstChildWithTag(Parent, Tag)
end
--[[^yields thread until a child with the tag is added or the timeout has passed and returns it
SomeFunctions.WaitForChildOfClass(Model, "Controllers", 2)
]]


--------------------AddTag Functions--------------------

function SomeFunctions.AddTagInBulk(Tag: string, Instances: {})
	for i, v in ipairs(Instances) do
		CollectionService:AddTag(v, Tag)
	end
end
--[[^Adds Same tag to multiple instances
SomeFunctions.AddTagInBulk("Iron Weapon", {IronSword, IronAxe})
]]

function SomeFunctions.AddTagsToObjects(TagToObject: {[string]: Instance | {Instance}})
	for i, v in pairs(TagToObject) do
		if typeof(v) == "table" then
			SomeFunctions.AddTagInBulk(i, v)
		else
			CollectionService:AddTag(v, i)
		end
	end
end
--[[^Adds each tag to the instance(s) associated with it
SomeFunctions.AddTagsToObjects({["Iron Weapon"] = {IronSword, IronAxe}, "Potion" = HealthPotion})
]]


--------------------RemoveTag Functions--------------------

function SomeFunctions.RemoveTagInBulk(Tag: string, Instances: {})
	for i, v in ipairs(Instances) do
		CollectionService:RemoveTag(v, Tag)
	end
end
--[[^Removes same tag from multiple instances
SomeFunctions.RemoveTagInBulk("Iron Weapon", {IronSword, IronAxe})
]]

function SomeFunctions.RemoveTagsFromObjects(TagToObject: {[string]: Instance | {Instance}})
	for i, v in pairs(TagToObject) do
		if typeof(v) == "table" then
			SomeFunctions.RemoveTagInBulk(i, v)
		else
			CollectionService:RemoveTag(v, i)
		end
	end
end
--[[^Remove each tag from the instance(s) associated with it
SomeFunctions.RemoveTagsFromObjects({["Iron Weapon"] = {IronSword, IronAxe}, "Potion" = HealthPotion})
]]


--------------------Ancestry Functions--------------------

function SomeFunctions.GetAncestorsInTable(Child: Instance): {}
	if typeof(Child) ~= "Instance" then warn("Child:", Child, "must be an instance") return end
	if Child.Parent == nil then
		return nil
	end
	local ret = {Child.Parent}
	repeat
		task.wait()
		table.insert(ret, ret[#ret].Parent)
	until ret[#ret].Parent == game
	return ret
end
--[[^Returns all acnestors of child until game in a table or nil if chil has no parent
function SomeFunctions.GetAncestorsInTable(Part)
]]

function SomeFunctions.FindFirstAncestorWithTag(Child: Instance, Tag: string): Instance
	if typeof(Child) ~= "Instance" then warn("Child:", Child, "must be an instance") return end
	if typeof(Tag) ~= "string" then warn("Tag:", Tag, "must be a string") return end
	for i, v in ipairs(SomeFunctions.GetAncestorsInTable(Child)) do
		if CollectionService:HasTag(v, Tag) then
			return v
		end
	end
	return nil
end
--[[^Returns first ancestor of Child found with tag Tag or nil if not found
function SomeFunctions.FindFirstAncestorWithTag(Wand, "Wizard"): Instance?
]]

return SomeFunctions
