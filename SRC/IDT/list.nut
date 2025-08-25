::ListNode <- function(value) return {
    value = value,
    prev_ref = null,
    next_ref = null,

    tostring = function () {
        return this.value.tostring();
    }
} 

//! Deleting nodes should cause a leak!
::List <- class {
    length = 0;
    first_node = null;
    last_node = null;

    /*
     * Constructor for a list.
     *
     * @param {...any} vargv - The initial values to add to the list.
    */
    constructor(...) {
        this.first_node = ListNode(0);
        this.last_node = this.first_node;
        
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
        local current_node = this.last_node;

        current_node.next_ref = next_node;
        next_node.prev_ref = current_node;

        this.last_node = next_node;
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

        newNode.next_ref = node
        newNode.prev_ref = node.prev_ref
        
        node.prev_ref.next_ref = newNode 
        node.prev_ref = newNode

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
        if (idx >= this.length) {
            throw("the index '" + idx + "' does not exist!");
        }

        local node = this.first_node.next_ref;
        for (local i = 0; i < idx; i++) {
            node = node.next_ref;
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
        local next = node.next_ref;
        local prev = node.prev_ref;
        // node.drop();

        if (prev) {
            prev.next_ref = next; 
        } else {
            this.first_node.next_ref = next;
        }
    
        if (next) {
            next.prev_ref = prev;
        } else { 
            this.last_node = prev; 
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
        local current = this.last_node;
        this.last_node = current.prev_ref;
        this.last_node.next_ref = null;
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
        return this.last_node.value
    }

    function first() {
        if(this.length == 0) throw("first() on a empty list")
        return this.first_node.next_ref.value
    }

    /*
     * Reverses the order of the elements in the list in-place.
     * @returns {List} - The List instance for chaining.
    */
    function reverse() {
        local prev_node = null;
        local current_node = this.first_node.next_ref;

        while (current_node) {
            local next_node = current_node.next_ref;

            current_node.next_ref = prev_node;
            current_node.prev_ref = next_node;

            prev_node = current_node;
            current_node = next_node;
        }

        local temp = this.first_node.next_ref;
        this.first_node.next_ref = prev_node;
        this.last_node = temp;
        return this
    }

    /*
     * Slice a portion of the list.
     *
     * @param {int} startIndex - The start index.
     * @param {int} endIndex - The end index. (optional)
     * @returns {List} - The sliced list.
    */
    function slice(startIndex, endIndex = null) {
        if(!endIndex) endIndex = this.len()

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
        local diff = size - this.len()
        
        if(diff > 0) {
            // Add elements
            for(local i = 0; i < diff; i++)
                this.append(fill)
            return
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
        this.first_node.next_ref = _mergeSort(this.first_node.next_ref)
        
        // Update prev_ref and next_ref links after sorting
        local current = this.first_node.next_ref;
        local previous = null;
        while (current) {
            current.prev_ref = previous;
            if (previous) {
                previous.next_ref = current; 
            }
            previous = current; 
            current = current.next_ref; 
        } 

        // Update last_node to point to the last node after sorting 
        this.last_node = previous; 
        
        return this
    }

    function _mergeSort(head) {
        if (head == null || head.next_ref == null) {
            return head  // List with one or zero elements already sorted
        }
    
        // Splitting the list into two parts
        local middle = _findMiddleNode(head)
        local nextToMiddle = middle.next_ref 
        middle.next_ref = null 
    
        // Recursive sorting of two halves
        local left = _mergeSort(head)
        local right = _mergeSort(nextToMiddle) 
    
        // Merging sorted halves
        return _merge(left, right) 
    }
    
    
    function _findMiddleNode(head) {
        local slow = head
        local fast = head.next_ref
        while (fast != null && fast.next_ref != null) {
            slow = slow.next_ref
            fast = fast.next_ref.next_ref 
        }
        return slow 
    }
    
    
    function _merge(left, right) {
        local dummyHead = ListNode(null)
        local current = dummyHead
    
        while (left != null && right != null) {
            if (left.value <= right.value) {
                current.next_ref = left
                left = left.next_ref 
            } else {
                current.next_ref = right
                right = right.next_ref 
            } 
            current = current.next_ref
        } 
    
        // Add the remaining elements
        current.next_ref = left != null ? left : right
    
        return dummyHead.next_ref 
    }

    function SwapNode(node1, node2) {
        if (node1 == node2) return
    
        //  Update references of previous nodes
        if (node1.prev_ref) {
            node1.prev_ref.next_ref = node2
        } else {
            this.first_node = node2
        }
    
        if (node2.prev_ref) {
            node2.prev_ref.next_ref = node1
        } else {
            this.first_node = node1
        }
    
        //  Update links for the following nodes
        if (node1.next_ref) {
            node1.next_ref.prev_ref = node2
        } else {
            this.last_node = node2
        }
    
        if (node2.next_ref) {
            node2.next_ref.prev_ref = node1
        } else {
            this.last_node = node1
        }
    
        //  Exchange the `prev_ref` and `next_ref` references of the nodes themselves
        local temp = node1.prev_ref
        node1.prev_ref = node2.prev_ref
        node2.prev_ref = temp
    
        temp = node1.next_ref
        node1.next_ref = node2.next_ref
        node2.next_ref = temp
    }


    /*
     * Removes all elements from the list.
     * @returns {List} - The List instance for chaining.
    */
    function clear() {
        if(this.length == 0) return
        
        local current = this.first_node.next_ref;
        while (current) {
            local next_node = current.next_ref;
            // current.drop()
            current = next_node;
        }

        this.first_node.next_ref = null;
        this.last_node = this.first_node;
        this.length = 0;
        return this
    }

    /*
     * More productive than the built-in iterator.
    */
    function iter() {
        if(this.length == 0) return
        local current = this.first_node.next_ref;
        local next;
        while (current) {
            next = current.next_ref
            yield current.value
            current = next;
        }
    }

    /*
     * Similar to `iter`, but returns the node instead of the node's value.
    */
    function rawIter() {
        local current = this.first_node.next_ref;
        while (current) {
            yield current
            current = current.next_ref;
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
        //! TODO BRUH!!!
        foreach(val in other) 
            this.append(val)
        return this
    }

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
            if(element) table[element] <- null
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
        if(this.len() == 0) return null
        if (previdx == null) return 0;
        return previdx < this.len() - 1 ? previdx + 1 : null;
    }

    function _cmp(other) { // lmao, why? :O
        local thisSum = 0;
        local otherSum = 0;
        foreach (val in this.iter()) { thisSum += val.value; }
        foreach (val in other) { otherSum += val.value; }

        if (thisSum > otherSum) {
            return 1;
        } else if (thisSum < otherSum) {
            return -1;
        } else {
            return 0; 
        }
    }
}