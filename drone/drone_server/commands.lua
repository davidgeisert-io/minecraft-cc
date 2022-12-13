local argument_types = require("argument_types_enum")
local turtle_command_args = {
    craft = {
        arguments = [
            {
                data_type = argument_types.NUMBER
                required = false
            }
        ]
    },

    dig = {
        arguments = [
            {
                data_type = argument_types.STRING,
                required = false
            }
        ]
    },

    digUp = {
        arguments = [
            {
                data_type = argument_types.STRING,
                required = false
            }
        ]
    },

    digDown = {
        arguments = [
            {
                data_type = argument_types.STRING,
                required = false
            }
        ]
    },

    place = {
        arguments = [
            {
                data_type = argument_types.STRING,
                required = false
            }
        ]
    },

    
    placeUp = {
        arguments = [
            {
                data_type = argument_types.STRING,
                required = false
            }                
        ]
    },

    placeDown = {
        arguments = [
            {
                data_type = argument_types.STRING,
                required = false
            }
        ]
    },

    drop = {
        arguments = [
            {
                data_type = argument_types.NUMBER,
                required = false
            }
        ]
    },

    dropUp = {
        arguments = [
            {
                data_type = argument_types.NUMBER,
                required = false
            }
        ]
    },

    dropDown = {
        arguments = [
            {
                data_type = argument_types.NUMBER,
                required = false
            }
        ]
    },

    select = {
        arguments = [
            {
                data_type = argument_types.NUMBER,
                required = true
            }
        ]
    },

    getItemCount = {
        arguments = [
            {
                data_type = argument_types.NUMBER,
                required = false
            }
        ]
    },

    getItemSpace = {
        arguments = [
            {
                data_type = argument_types.NUMBER,
                required = false
            }
        ]
    },

    attack = {
        arguments = [
            {
                data_type = argument_types.STRING,
                required = false
            }
        ]
    },

    attackUp = {
        arguments = [
            {
                data_type = argument_types.STRING,
                required = false
            }
        ]
    },

    attackDown = {
        arguments = [
            {
                data_type = argument_types.STRING,
                required = false
            }
        ]
    },

    suck = {
        arguments = [
            {
                data_type = argument_types.NUMBER,
                required = false
            }
        ]
    },

    suckUp = {
        arguments = [
            {
                data_type = argument_types.NUMBER,
                required = false
            }
        ]
    },

    suckDown = {
        arguments = [
            {
                data_type = argument_types.NUMBER,
                required = false
            }
        ]
    },

    refuel = {
        arguments = [
            {
                data_type = argument_types.NUMBER,
                required = false
            }
        ]
    },

    compareTo = {
        arguments = [
            {
                data_type = argument_types.NUMBER,
                required = true
            }
        ]
    },

    transferTo = {
        arguments = [
            {
                data_type = argument_types.NUMBER,
                required = true
            },
            {
                data_type = argument_types.NUMBER,
                required = false
            }

        ]
    },

    getItemDetail = {
        arguments = [
            {
                data_type = argument_types.NUMBER
                required = false
            },
            {
                data_type = argument_types.BOOLEAN
                required = false
            }

        ]
    }
}

return commands