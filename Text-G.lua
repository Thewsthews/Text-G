--Game State
local player = {
    health = 100,
    inventory = {},
    current_room = "start"
}

-- Room definitions
local rooms ={
    start ={
        description = "You're in a daily llit room. There is a door to the north and east.",
        items = {"key"},
        exits ={
            north = "treasure_room",
            east = "monster_ room"
        }
    },

    treasure_room ={
        description ="A Glittering rooom full of Byzanite! But its locked...",
        items ={"Byzanite"},
        locked = true,
        exits ={
            south = "start"
        }
    },

    monster_room = {
        description = "A scary room with a sleeping monster. There's a health position in the corner.",
        items = {"health_potion"},
        has_monster = true,
        exits ={
            west = "start"
        }
    }
}
--Helper function to check inventory
local function has_item(item)
    for _, inv_item in ipairs(player.inventory) do
        if inv_item ==item then
            return true
        end
    end    
    return false
 end

local function get_exit_directions(exits)
    local directions = {}

    for direction, _ in pairs(exits) do
        table.insert(directions, direction)
    end
    return directions
end

-- Helper functions
local function print_room()
    local room=rooms[player.current_room]
    print("\n" .. room.description)

    if #room.items > 0 then
        print("You see:", table.concat(room.items, ", "))
    end

    print("\nExits:", table.concat(get_exit_directions(room.exits),", "))
    print("\nHealth:, player.health")
    print("inventory:", table.concat(player.inventory,", "))
end


--Game commands
 local commands = {
    go = function (direction)
        local room = rooms[player.current_room]
        local new_room = room.exits[direction]

        if not new_room then
        print("You cant go that way!")
        return
    end

    if rooms[new_room].locked then
        if not has_item("key") then
            print("The room is inaccessible! You need a key.")
            return
        else
            print("You use the key to unlock the door.")
            rooms[new_room].locked = false
        end
    end

    player.current_room = new_room

    if rooms[new_room].has_monster then
        print("The monster wakes up and attacks you!")
        player.health = player.health - 30
    end

    print_room()
end,

take = function(item)
    local room = rooms[player.current_room]
    for i, room_item in ipairs(rooms.items) do
        if room_item == item then
            table.insert(player.inventory, item)
            table.remove(room.items, i)
            print("Taken:", item)

            if item == "health_potion" then
                player.heath = player.health + 50
                print("You drink the health potion and feel better!")
            end

            return
    end
end
print("There's no", item, "here!")
end,

inventory = function()
    print("You are carrying: ", table.concat(player.inventory, ", "))
end,

look = function ()
    print_room()
end,

help = function()
    print([[
        Available Commands:
        -go <direction>: Move in a direction(north, south ,east, west)
        -take <item>: Pick up an item
        -inventory: Show your inventory
        -look: Look around the room
        -help: Show this help message
        -quit: Exit the game
    ]])
end
 }

 --Main game loop

 local function game_loop()
    print("\nWelcome to the Adventure GAme!")
    print("Type 'help' for commands.\n")
    print_room()


    while player.health > 0 do
        io.write("\nWhat would you like to do?")
        local input = io.read()

        if input == "quit" then
            print("Thanks for playing!")
            break
        end

        local command, argument = input:match("(%w+)%s*(.*)")

        if commands[command] then
            commands[command](argument)
        end
        if player.health <= 0 then
            print("\nGame Over! You have died!")
            break
        end
        end
    end

    --Start the game
    game_loop()