::__listnodetostring <- function () {return this.value.tostring()}
::ListNode <- function(value) return {
    value = value,
    _prevRef = null,
    _nextRef = null,

    tostring = __listnodetostring
} 

::List <- class {
    length = 0;
    firstNode = null;
    lastNode = null;

    /*
     * Constructor for a list.
     *
     * @param {...any} vargv - The initial values to add to the list.
    */
    constructor(...) {
        this.firstNode = ListNode(null);
        this.lastNode = this.firstNode;
        
        for(local i = 0; i < vargc; i++) {
            this.append(vargv[i])
        }
    }

    /*
     * Creates a new list from an array.
     * 
     * @param {array} array - The array to create the list from.
     * @returns {List} - The new list containing the elements from the array.
    */
    function FromArray(array) {
        local list = List()
        foreach(val in array) 
            list.append(val)
        return list
    }

    /*
     * Gets the length of the list.
     *
     * @returns {number} - The number of elements in the list.
    */
    function len() {
        return this.length;
    }

    /*
     * Appends a value to the end of the list.
     * 
     * @param {any} value - The value to append.
     * @returns {List} - The List instance for chaining.
    */
    function append(value) {
        local next_node = ListNode(value);
        local current_node = this.lastNode;

        current_node._nextRef = next_node;
        next_node._prevRef = current_node;

        this.lastNode = next_node;
        this.length++;
        return this
    }

    /*
     * Inserts a value at a specific index in the list.
     * 
     * @param {number} index - The index to insert the value at.
     * @param {any} value - The value to insert.
     * @returns {List} - The List instance for chaining.
    */
    function insert(idx, value) {
        if(this.length == 0 || idx >= this.length) 
            return this.append(value)
        local node = this.getNode(idx)
        local newNode = ListNode(value)

        newNode._nextRef = node
        newNode._prevRef = node._prevRef
        
        node._prevRef._nextRef = newNode 
        node._prevRef = newNode

        this.length++
        return this
    }

    /*
     * Gets the node at a specific index in the list.
     * 
     * @param {number} index - The index of the node to retrieve.
     * @returns {ListNode} - The node at the specified index.
     * @throws {Error} - If the index is out of bounds.
    */
    function getNode(idx) {
        if (idx >= this.length || idx < 0) {
            throw("the index '" + idx + "' does not exist!");
        }

        // If the index is in the first half, we search from the beginning
        if (idx < this.length / 2) {
            local node = this.firstNode._nextRef;
            for (local i = 0; i < idx; i++) {
                node = node._nextRef;
            }
            return node;
        } 
        // Otherwise, we search from the end
        else {
            local node = this.lastNode;
            for (local i = this.length - 1; i > idx; i--) {
                node = node._prevRef;
            }
            return node;
        }
        return node;
    }

    /*
     * Gets the value at a specific index in the list.
     * 
     * @param {number} index - The index of the value to retrieve.
     * @param {any} defaultValue - The value to return if the index is out of bounds. (optional)
     * @returns {any} - The value at the specified index or the default value if the index is out of bounds.
    */
    function get(idx, defaultValue = null) {
        if (idx >= this.length)
            return defaultValue

        return this.getNode(idx).value
    }

    /*
     * Removes the node at a specific index from the list.
     * 
     * @param {number} index - The index of the node to remove.
     * @returns {any} - The value of the removed element.
    */
    function remove(idx) {
        local node = this.getNode(idx);
        local value = node.value
        local next = node._nextRef;
        local prev = node._prevRef;
        
        node._nextRef = null;
        node._prevRef = null;

        if (prev) {
            prev._nextRef = next; 
        } else {
            this.firstNode._nextRef = next;
        }
    
        if (next) {
            next._prevRef = prev;
        } else { 
            this.lastNode = prev; 
        } 

        this.length--;
        return value
    }

    /*
     * Removes the last element from the list and returns its value.
     * 
     * @returns {any} - The value of the removed element.
    */
    function pop() {
        if(this.length == 0) throw("pop() on a empty list")

        local current = this.lastNode;
        this.lastNode = current._prevRef;
        this.lastNode._nextRef = null;
        this.length--
        // current.drop()
        return current.value;
    }

    /*
     * Gets the value of the last element in the list.
     * 
     * @returns {any} - The value of the last element.
    */
    function top() {
        if(this.length == 0) throw("top() on a empty list")
        return this.lastNode.value
    }

    function first() {
        if(this.length == 0) throw("first() on a empty list")
        return this.firstNode._nextRef.value
    }

    /*
     * Reverses the order of the elements in the list in-place.
     * @returns {List} - The List instance for chaining.
    */
    function reverse() {
        if (this.length <= 1) return this;

        local new_tail = this.firstNode._nextRef;
        local new_head = this.lastNode;

        local current = this.firstNode._nextRef;
        local prev = this.firstNode; 

        while (current) {
            local next = current._nextRef; 
            
            current._nextRef = prev;
            current._prevRef = next;

            prev = current;
            current = next;
        }

        this.firstNode._nextRef = new_head;
        new_head._prevRef = this.firstNode;

        this.lastNode = new_tail;
        this.lastNode._nextRef = null; 

        return this;
    }

    /*
     * Slice a portion of the list.
     *
     * @param {int} startIndex - The start index.
     * @param {int} endIndex - The end index. (optional)
     * @returns {List} - The sliced list.
    */
    function slice(startIndex, endIndex = null) {
        if(endIndex == null) endIndex = this.len()

        local result = List()
        foreach(idx, value in this.iter()) {
            if(idx < startIndex || idx >= endIndex) continue
            result.append(value)
        }
        return result
    }

    /*
     * Resize the list.
     * 
     * @param {int} size - The new size.
     * @param {any} fill - The fill value for new slots.
     * @returns {List} - The List instance for chaining.
    */
    function resize(size, fill = null) {
        if(size < 0) throw("Size cannot be negative.")
        local diff = size - this.len()
        
        if(diff > 0) {
            // Add elements
            for(local i = 0; i < diff; i++)
                this.append(fill)
            return this
        }

        // Remove elements
        for (local i = 0; i < -diff; i++)
            this.pop();
        return this
    }

    /*
     * Sorts the list in ascending order using merge sort.
     *
     * @returns {List} - The List instance for chaining.
    */
    function sort() {
        this.firstNode._nextRef = _mergeSort(this.firstNode._nextRef)
        
        // Update _prevRef and _nextRef links after sorting
        local current = this.firstNode._nextRef;
        local previous = this.firstNode;
        while (current) {
            current._prevRef = previous;
            if (previous) {
                previous._nextRef = current; 
            }
            previous = current; 
            current = current._nextRef; 
        } 

        // Update lastNode to point to the last node after sorting 
        this.lastNode = previous; 
        
        return this
    }

    function _mergeSort(head) {
        if (head == null || head._nextRef == null) {
            return head  // List with one or zero elements already sorted
        }
    
        // Splitting the list into two parts
        local middle = _findMiddleNode(head)
        local nextToMiddle = middle._nextRef 
        middle._nextRef = null 
    
        // Recursive sorting of two halves
        local left = _mergeSort(head)
        local right = _mergeSort(nextToMiddle) 
    
        // Merging sorted halves
        return _merge(left, right) 
    }
    
    
    function _findMiddleNode(head) {
        local slow = head
        local fast = head._nextRef
        while (fast != null && fast._nextRef != null) {
            slow = slow._nextRef
            fast = fast._nextRef._nextRef 
        }
        return slow 
    }
    
    
    function _merge(left, right) {
        local dummyHead = ListNode(null)
        local current = dummyHead
    
        while (left != null && right != null) {
            if (left.value <= right.value) {
                current._nextRef = left
                left = left._nextRef 
            } else {
                current._nextRef = right
                right = right._nextRef 
            } 
            current = current._nextRef
        } 
    
        // Add the remaining elements
        current._nextRef = left != null ? left : right
    
        return dummyHead._nextRef 
    }

    function SwapNode(node1, node2) {
        if (node1 == node2) return;
        
        local t = node1.value
        node1.value = node2.value
        node2.value = t;
    }


    /*
     * Removes all elements from the list.
     * @returns {List} - The List instance for chaining.
    */
    function clear() {
        if(this.length == 0) return
        
        local current = this.firstNode._nextRef;
        while (current) {
            local next_node = current._nextRef;
            current._prevRef = null;
            current._nextRef = null;

            current = next_node;
        }

        this.firstNode._nextRef = null;
        this.lastNode = this.firstNode;
        this.length = 0;
        return this
    }

    /*
     * More productive than the built-in iterator.
    */
    function iter() {
        if(this.length == 0) return
        local current = this.firstNode._nextRef;
        local next;
        while (current) {
            next = current._nextRef
            yield current.value
            current = next;
        }
    }

    /*
     * Similar to `iter`, but returns the node instead of the node's value.
    */
    function rawIter() {
        local current = this.firstNode._nextRef;
        while (current) {
            yield current
            current = current._nextRef;
        }
    }

    /*
     * Joins the elements of the list into a string, separated by the specified delimiter.
     * 
     * @param {string} joinstr - The delimiter to use between elements. (optional, default="")
     * @returns {string} - The joined string.
    */
    function join(joinstr = "") {
        if(this.length == 0) return ""
        
        local string = ""
        foreach(elem in this.iter()) {
            string += elem + joinstr
        }

        return joinstr.len() != 0 ? string.slice(0, joinstr.len() * -1) : string
    }

    /*
     * Apply a function to each element and modify the list in-place.
     * 
     * @param {Function} func - The function to apply.
     * @returns {List} - The List instance for chaining.
    */
    function apply(func) {
        foreach(idx, value in this.iter()) {
            this[idx] = func(value, idx)
        }
        return this
    }

    /*
     * Extends the list by appending all elements from another iterable.
     * 
     * @param {iterable} other - The iterable to append elements from.
     * @returns {List} - The List instance for chaining.
    */
    function extend(other) {
        local iter = typeof other == "List" ? other.iter() : other
        foreach(val in iter) 
            this.append(val)
        return this
    }

    // function _unsafeFastExtend(otherLis) { // todo for actions
    //     this.lastNode._nextRef = otherLis.firstNode._nextRef
    //     otherLis.firstNode._nextRef._prevRef = this.lastNode
    //     this.lastNode = otherLis.firstNode._nextRef
    //     return this
    // }

    /*
     * Searches for a value or a matching element in the list.
     * 
     * @param {any|Function} match - The value to search for or a predicate function.
     * @returns {number|null} - The index of the match or null if not found.
    */
    function search(match) {
        if(typeof match == "function") {
            foreach(idx, val in this.iter()) {
                if(match(val))
                    return idx
            }
        }
        else {
            foreach(idx, val in this.iter()) {
                if(val == match)
                    return idx
            }
        }

        return null
    }

    /*
     * Returns a new list with only the unique elements from the original list.
     *
     * @returns {List} - The new list with unique elements.
    */
    function unique() {
        local seen = {}
        local result = List()

        foreach(value in this.iter()) {
            if(value in seen) continue
            seen[value] <- true    
            result.append(value)
        }

        return result
    }

    /*
     * Creates a new list by applying a function to each element of this list.
     * 
     * @param {Function} func - The function to apply to each element.
     * @returns {List} - The new list with the mapped values.
    */
    function map(func) {
        if(typeof func != "function") throw("List.map: The 'func' argument must be a function, but got " + typeof func);
        local newList = List()
        foreach(idx, value in this.iter()) {
            newList.append(func(value, idx))
        }
        return newList
    }

    /*
     * Filter the list by a predicate function.
     * 
     * @param {Function} condition(index, value, newList) - The predicate function. 
     * @returns {List} - The filtered list.
    */
    function filter(condition) {
        local newList = List()
        foreach(idx, val in this.iter()) {
            if(condition(idx, val, newList))
                newList.append(val)
        }
        return newList
    }

    /*
     * Applies a function to an accumulator and each element in the list (from left to right)
     * to reduce it to a single value.
     *
     * @param {function} func - The function to apply to each element and accumulator.
     * @param {any} initial - The initial value of the accumulator.
     * @returns {any} - The final reduced value.
    */
    function reduce(func, initial) {
        local accumulator = initial
        foreach(item in this.iter()) {
            accumulator = func(accumulator, item)
        }
        return accumulator
    }

    /*
     * Convert the list to a table.
     * 
     * @returns {table} - The table representation.
    */
    function totable() {
        local table = {}
        foreach(element in this.iter()) {
            if(element != null) // null can't be the key 
                table[element] <- null
        }
        return table
    }

    /*
     * Converts the list to an array.
     * 
     * @returns {array} - An array containing the elements of the list.
    */
    function toarray() {
        local array = ArrayEx.WithSize(this.length)
        foreach(idx, value in this.iter()) {
            array[idx] = value
        }
        return array
    }

    // Metamethods
    function _tostring() return format("List: [%s]", this.join(", "))
    function _typeof () return "List";
    function _get(idx) return this.getNode(idx).value;
    function _set(idx, val) return this.getNode(idx).value = val

    //* OUTDATED! The standard iterator, it's terrible! Use `.iter()` method
    function _nexti(previdx) {
        local callstack = "\nCallstack:\n"
        // Start at level 2 to skip this _nexti function and the internal VM call.
        for (local level = 2; ; level++) {
            local info = getstackinfos(level)
            // Stop when we've gone through the entire stack.
            if (info == null) break
            
            // Format the information for readability.
            local source = ("src" in info) ? info.src : "unknown_source"
            local line = ("line" in info) ? info.line : "?"
            local func = ("func" in info) ? info.func : "global_scope"
            
            callstack += "  at " + source + ":" + line + " in function '" + func + "'\n"
        }

        local errorMessage = "DEPRECATED ITERATION: Standard 'foreach' is not supported for List. " +
                             "Please use the high-performance '.iter()' method instead.\n\n" +
                             "Example: foreach (item in yourList.iter()) { ... }" +
                             callstack

        throw(errorMessage)
    }
}