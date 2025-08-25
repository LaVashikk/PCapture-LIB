::macros <- {}

/* 
 * Precaches a sound script or a list of sound scripts for later use.
 * 
 * @param {string|array|ArrayEx} sound_path - The path to the sound script or a list of paths.
*/
macros["Precache"] <- function(soundPath) {
    if(typeof soundPath == "string")
        return self.PrecacheSoundScript(soundPath)
    foreach(path in soundPath)
        self.PrecacheSoundScript(path)
}


/* 
 * Gets a value from a table, returning a default value if the key is not found. 
 *
 * @param {table} table - The table to retrieve the value from. 
 * @param {any} key - The key of the value to get. 
 * @param {any} defaultValue - The default value to return if the key is not found. (optional) 
 * @returns {any} - The value associated with the key, or the default value if the key is not found. 
*/ 
macros["GetFromTable"] <- function(table, key, defaultValue = null) {
    if(key in table && table[key]) 
        return table[key]
    return defaultValue
}

/* 
 * Gets a list of all keys in a table.
 *
 * @param {table} table - The table to retrieve the keys from.
 * @returns {List} - A list containing all the keys in the table.
*/ 
macros["GetKeys"] <- function(table) {
    local result = List()
    foreach(key, _ in table) {
        result.append(key)
    }
    return result
}

/*
 * Gets a list of all values in a table.
 *
 * @param {table} table - The table to retrieve the values from.
 * @returns {List} - A list containing all the values in the table.
*/ 
macros["GetValues"] <- function(table) {
    local result = List()
    foreach(value in table) {
        result.append(value)
    }
    return result
}

/*
 * Inverts a table, swapping keys and values.
 *
 * @param {table} table - The table to invert.
 * @returns {table} - A new table with keys and values swapped.
*/ 
macros["InvertTable"] <- function(table) {
    local result = {}
    foreach(key, value in table) {
        result[value] = key
    }
    return result
}

/*
 * Prints the keys and values of an iterable object to the console. 
 *
 * @param {iterable} iterable - The iterable object to print.
*/
macros["PrintIter"] <- function(iterable) {
    foreach(k, i in iterable) 
        macros.fprint("{}: {}", k, i)
}

/*
 * Generates a list of numbers within a specified range.
 *
 * @param {number} start - The starting value of the range.
 * @param {number} end - The ending value of the range.
 * @param {number} [step=1] - The increment between each value in the range.
 * @returns {List} - A list of numbers within the specified range.
*/ 
macros["Range"] <- function(start, end, step = 1) {
    local result = List()
    for (local i = start; i <= end; i += step) {
        result.append(i)
    }
    return result
}

/*
 * Generates an iterator that yields numbers within a specified range.
 *
 * @param {number} start - The starting value of the range.
 * @param {number} end - The ending value of the range.
 * @param {number} [step=1] - The increment between each value in the range.
 * @yields {number} - The next number in the range.
*/ 
macros["RangeIter"] <- function(start, end, step = 1) {
    for (local i = start; i <= end; i += step) {
        yield i
    }
    return null
}

/*
 * Searches for a matching string in an array, considering wildcard '*'.
 *
 * @param {array|ArrayEx} iter - The array to search in.
 * @param {string} match - The string to search for.
 * @returns {int|null} - The index of the first matching element, or null if not found. 
 *           If the first element of iter is '*', returns 0. 
*/
macros["MaskSearch"] <- function(iter, match) {
    if(iter.len() == 0) return null
    if(iter[0] == "*") return 0

    foreach(idx, val in iter) {
        if(match.find(val) >= 0)
            return idx
    }
    return null
}

/*
 * Prints a formatted message to the console.
 * 
 * @param {string} msg - The message string containing `{}` placeholders.
 * @param {any} vargs... - Additional arguments to substitute into the placeholders.
*/
macros["format"] <- function(msg, ...) {
    if(msg.len() == 1) return msg
    
    // If you are sure of what you are doing, you don't have to use it
    local subst_count = 0;
    for (local i = 0; i < msg.len() - 1; i++) {
        if (msg.slice(i, i+2) == "{}") {
            subst_count++; 
        }
    }

    if (subst_count != vargc)
        throw("Discrepancy between the number of arguments and substitutions")

    local args = array(vargc)
    for(local i = 0; i< vargc; i++) {
        args[i] = vargv[i]
    }

    if (msg.slice(0, 2) == "{}") {
        msg = args[0] + msg.slice(2); 
        args.remove(0); 
    }

    local parts = split(msg, "{}");
    local result = "";

    for (local i = 0; i < parts.len(); i++) {
        result += parts[i];
        if (i < args.len()) {
            local txt = args[i]
            result += txt;
        }
    }

    return result
}

/*
 * Prints a formatted message to the console.
 *
 * This function is similar to dev.format, but it automatically calls printl 
 * with the formatted message. 
 *
 * @param {string} msg - The message string containing `{}` placeholders. 
 * @param {any} vargs... - Additional arguments to substitute into the placeholders. 
*/
macros["fprint"] <- function(msg, ...) {
    local args = array(vargc + 2)
    args[0] = this
    args[1] = msg

    for(local i = 0; i< vargc; i++) {
        args[i + 2] = vargv[i]
    }

    printl(macros.format.acall(args))
}

/*
 * Compiles a function from a string representation.
 * This function is similar to dev.format.
 *
 * @param {string} funcBody - The body of the function to be compiled.
 * @param {any} vargs... - Additional arguments to substitute into the placeholders.
 * @returns {function} - The compiled function.
*/
macros["CompileFromStr"] <- function(funcBody, ...) {
    local args = array(vargc + 2)
    args[0] = this
    args[1] = funcBody

    for(local i = 0; i< vargc; i++) {
        args[i + 2] = vargv[i]
    }

    return compilefromstr(macros.format.acall(args))
}

/* 
 * Calculates the distance between two vectors.
 *
 * @param {Vector} vec1 - The first vector.
 * @param {Vector} vec2 - The second vector.
 * @returns {number} - The distance between the vectors.
*/
macros["GetDist"] <- function(vec1, vec2) {
    return (vec2 - vec1).Length()
}

/* 
 * Converts a string to a Vector object.
 * 
 * @param {string} str - The string representation of the vector, e.g., "x y z".
 * @param {string} sep - The separator string.
 * @returns {Vector} - The converted vector.
*/
macros["StrToVec"] <- function(str, sep = " ") {
    local str_arr = split(str, sep)
    if (str_arr.len() != 3) throw(format("macros.StrToVec: Input string '%s' is malformed. Expected 3 components separated by '%s', but got %d.", str, sep, str_arr.len()));
    try {
        local vec = Vector(str_arr[0].tofloat(), str_arr[1].tofloat(), str_arr[2].tofloat())
        return vec
    }
    catch(ex) {
        throw(format("macros.StrToVec: Failed to convert components of string '%s' to numbers. Details: %s", str, ex));
    }

}

/*
 * Converts a Vector object to a string representation.
 * 
 * @param {Vector} vec - The vector to convert. 
 * @returns {string} - The separator string.
*/
macros["VecToStr"] <- function(vec, sep = " ") {
    return vec.x + sep + vec.y + sep + vec.z 
}

/*
 * Gets the duration of a sound by its name. 
 * 
 * @param {string} soundName - The name of the sound. 
 * @returns {number} - The duration of the sound in seconds.
*/
macros["GetSoundDuration"] <- function(soundName) {
    return self.GetSoundDuration(soundName, "")
}

/*
 * Creates a simple console alias.
 *
 * @param {string} key - The alias name.
 * @param {string} action - The command to be executed when the alias is called.
 * @returns {void}
*/
macros["CreateAlias"] <- function(key, action) {
    SendToConsole(::format("alias \"%s\" \"%s\"", key, action))
}

/*
 * Creates a primitive console command.
 *
 * @param {string} key - The name of the command.
 * @param {string} command - The command to be executed.
*/
 macros["CreateCommand"] <- function(key, command) {
    SendToConsole(::format("setinfo %s \"\"", key))
    macros.CreateAlias(key, command)
}

/*
 * Checks if two values are equal, handling different data types.
 *
 * @param {any} val1 - The first value.
 * @param {any} val2 - The second value.
 * @returns {boolean} - True if the values are equal, false otherwise. 
*/
macros["isEqually"] <- function(val1, val2) {
    if((typeof val1 == "instance" || typeof val2 == "instance") && (val1 instanceof CBaseEntity || val2 instanceof CBaseEntity)) 
        return val1.entindex() == val2.entindex()
    
        switch (typeof val1) {
        case "integer": 
            return val1 == val2 
        case "float": 
            return math.round(val1, 1000) == math.round(val2, 1000)
        case "Vector": 
            return math.vector.isEqually(val1, val2)
        case "instance": 
            return val1 == val2; 
        case "Quaternion": 
        case "Matrix": 
        case "pcapEntity": 
            return val1.isEqually(val2)  
    }
}

/*
 * Creates a deep copy of a container (table, array, ArrayEx, or List).
 * Note: The container must not have circular references.
 *
 * @param {table|array|ArrayEx|List} container - The container to be copied.
 * @returns {table|array|ArrayEx|List} - A deep copy of the container.
*/
macros["DeepCopy"] <- function(container, _ = null) { 
    switch (typeof container) {
        case "table": 
            local result = clone container; 
            foreach( k,v in container) result[k] = macros.DeepCopy(v); 
            return result; 
        case "array": 
        case "ArrayEx": 
        case "List":
            return container.map(macros.DeepCopy); 
        default: return container; 
    }
}


/*
 * Gets the prefix of an entity name. 
 *
 * @param {string} name - The entity name. 
 * @returns {string} - The prefix of the entity name, or the original name if no "-" is found. 
*/
macros["GetPrefix"] <- function(name) {
    local parts = split(name, "-")
    if(parts.len() == 0)
        return name
    
    local lastPartLength = parts.pop().len()
    local prefix = name.slice(0, -lastPartLength)
    return prefix;
}


/* 
 * Gets the postfix of an entity name. 
 *
 * @param {string} name - The entity name. 
 * @returns {string} - The postfix of the entity name, or the original name if no "-" is found. 
*/
macros["GetPostfix"] <- function(name) {
    local parts = split(name, "-")
    if(parts.len() == 0)
        return name

    local lastPartLength = parts[0].len();
    local prefix = name.slice(lastPartLength);
    return prefix;
}

/*
 * Calculates the end position of a ray cast from the player's eyes.
 * 
 * @param {CBaseEntity|pcapEntity} player - The player entity.
 * @param {number} distance - The distance of the ray cast.
 * @returns {Vector} - The end position of the ray cast. 
*/
macros["GetEyeEndpos"] <- function(player, distance) {
    if(typeof player != "pcapEntity") 
        player = entLib.FromEntity(player)
    return player.EyePosition() + player.EyeForwardVector() * distance
}

/*
 * Gets one vertex of the bounding box based on x, y, z bounds.
 * 
 * @param {Vector} x - The x bounds.
 * @param {Vector} y - The y bounds.  
 * @param {Vector} z - The z bounds.
 * @param {Vector} ang - The angle vector.
 * @returns {Vector} - The vertex.
*/
macros["GetVertex"] <- function(x, y, z, ang) {
    return math.vector.rotate(Vector(x.x, y.y, z.z), ang)
}

/*
 * Creates a triangle representation from three vertices. 
 *
 * @param {Vector} v1 - The first vertex of the triangle.
 * @param {Vector} v2 - The second vertex of the triangle.
 * @param {Vector} v3 - The third vertex of the triangle.
 * @returns {table} - A table containing the origin and vertices of the triangle.
*/
macros["GetTriangle"] <- function(v1, v2, v3) {
    return {
        origin = (v1 + v2 + v3) * 0.3333,
        vertices = [v1, v2, v3]
    }
}

/*
 * Creates a rectangle object from four vertices. 
 *
 * @param {Vector} v1 - The first vertex.
 * @param {Vector} v2 - The second vertex. 
 * @param {Vector} v3 - The third vertex. 
 * @param {Vector} v4 - The fourth vertex.
 * @returns {table} - A table representing the rectangle with 'origin' and 'vertices' properties. 
*/
macros["GetRectangle"] <- function(v1, v2, v3, v4) {
    return {
        origin = (v1 + v2 + v3 + v4) * 0.25,
        vertices = [v1, v2, v3, v4]
    }
}

/*
 * Checks if a point is inside a bounding box. 
 * 
 * @param {Vector} point - The point to check.
 * @param {Vector} bMin - The minimum corner of the bounding box. 
 * @param {Vector} bMax - The maximum corner of the bounding box. 
 * @returns {boolean} - True if the point is inside the bounding box, false otherwise.
*/
macros["PointInBBox"] <- function(point, bMin, bMax) {
    return (
        point.x >= bMin.x && point.x <= bMax.x &&
        point.y >= bMin.y && point.y <= bMax.y &&
        point.z >= bMin.z && point.z <= bMax.z
    )
}

/*
 * Checks if a point is within the defined bounds of the map using raycasts.
 *
 * @param {Vector} point - The point to check.
 * @returns {boolean} - True if the point is within the bounds, false otherwise.
*/
macros["PointInBounds"] <- function(point) {
    local m = 64000
    return (
        TraceLine(point, point + Vector(m, 0, 0), null) >= 0.98 ||
        TraceLine(point, point - Vector(m, 0, 0), null) >= 0.98 ||
        TraceLine(point, point + Vector(0, m, 0), null) >= 0.98 ||
        TraceLine(point, point - Vector(0, m, 0), null) >= 0.98 || 
        TraceLine(point, point + Vector(0, 0, m), null) >= 0.98 ||
        TraceLine(point, point - Vector(0, 0, m), null) >= 0.98
    ) == false
}


/*
 * Creates a function that animates a property of one or more entities.
 * 
 * @param {string} name - The name of the animation. This name is used to identify the animation internally. 
 * @param {function} propertySetterFunc - A function that takes an entity and a value, and sets a property on that entity. This function will be called repeatedly during the animation to update the property.
 * @param {function} valueCalculator (optional) - A custom function that calculates the animated value for each step. 
 * @returns {function} - A function that can be used to start the animation. This function takes the following arguments:
 *   * `entities` {array|pcapEntity} - An array of entities or a single entity to animate.
 *   * `startValue` {any} - The starting value for the property.
 *   * `endValue` {any} - The ending value for the property.
 *   * `time` {number} - The duration of the animation in seconds.
 *   * `animSetting` {table} (optional) - A table of additional animation settings. See the `AnimEvent` constructor for details.
*/
macros["BuildAnimateFunction"] <- function(name, propertySetterFunc, valueCalculator = null) {
    if (typeof propertySetterFunc != "function") throw("macros.BuildAnimateFunction: 'propertySetterFunc' must be a function, but got " + typeof propertySetterFunc);
    if (valueCalculator != null && typeof valueCalculator != "function") throw("macros.BuildAnimateFunction: 'valueCalculator' must be a function or null, but got " + typeof valueCalculator);

    return function(entities, startValue, endValue, time, animSetting = {}) : (name, propertySetterFunc, valueCalculator) {
        local animSetting = AnimEvent(name, animSetting, entities, time) 
        local varg = {
            start = startValue,
            delta = endValue - startValue,
            easeFunc = animSetting.easeFunc
        }

        animate.applyAnimation(
            animSetting,
            valueCalculator ? valueCalculator : function(step, steps, v) {return v.start + v.delta * v.easeFunc(step / steps)},
            propertySetterFunc
            varg
        ) 

        return animSetting.delay
    }
}

/*
 * Same as BuildAnimateFunction, only for creating RealTime animations.
*/
macros["BuildRTAnimateFunction"] <- function(name, propertySetterFunc, valueCalculator = null) {
    return function(entities, startValue, endValue, time, animSetting = {}) : (name, propertySetterFunc, valueCalculator) {
        local animSetting = AnimEvent(name, animSetting, entities, time) 
        local varg = {
            start = startValue,
            delta = endValue - startValue,
            easeFunc = animSetting.easeFunc
        }

        animate.applyRTAnimation(
            animSetting,
            valueCalculator ? valueCalculator : function(step, steps, v) {return v.start + v.delta * v.easeFunc(step / steps)},
            propertySetterFunc
            varg
        ) 

        return animSetting.delay
    }
}