
# IDT Module (Improved Data Types)

The `IDT` module provides enhanced versions of standard VScripts data structures, including arrays, lists, and trees, with additional methods and functionality to improve efficiency and flexibility.

## Table of Contents

1. [IDT/array.nut](#idtarraynut)
    * [`ArrayEx(...)`](#arrayex)
    * [`FromArray(array)`](#arrayexfromarrayarray)
    * [`WithSize(numberOfItems, fillValue)`](#arrayexwithsizenumberofitems-fillvalue)
    * [`append(value)`](#appendvalue)
    * [`apply(func)`](#applyfunc)
    * [`clear()`](#clear)
    * [`extend(other)`](#extendother)
    * [`filter(func)`](#filterfunc)
    * [`contains(value)`](#containsvalue)
    * [`search(value or func)`](#searchvalue-or-func)
    * [`insert(index, value)`](#insertindex-value)
    * [`len()`](#len)
    * [`map(func)`](#mapfunc)
    * [`reduce(func, initial)`](#reducefunc-initial)
    * [`unique()`](#unique)
    * [`pop()`](#pop)
    * [`push(value)`](#pushvalue)
    * [`remove(index)`](#removeindex)
    * [`resize(size, fill)`](#resizesize-fill)
    * [`reverse()`](#reverse)
    * [`slice(start, end)`](#slicestart-end)
    * [`sort(func)`](#sortfunc)
    * [`top()`](#top)
    * [`join(separator)`](#joinseparator)
    * [`get(index, default)`](#getindex-default)
    * [`totable(recreate)`](#totablerecreate)
    * [`tolist()`](#tolist)
2. [IDT/list.nut](#idtlistnut)
    * [`List(...)`](#list)
    * [`FromArray(array)`](#fromarrayarray)
    * [`len()`](#len)
    * [`iter()`](#iter)
    * [`rawIter()`](#rawiter)
    * [`append(value)`](#appendvalue)
    * [`insert(index, value)`](#insertindex-value)
    * [`getNode(index)`](#getnodeindex)
    * [`get(index, defaultValue)`](#getindex-defaultvalue)
    * [`remove(index)`](#removeindex)
    * [`pop()`](#pop)
    * [`top()`](#top)
    * [`first()`](#first)
    * [`reverse()`](#reverse)
    * [`slice(startIndex, endIndex)`](#slicestartindex-endindex--null)
    * [`resize(size, fill)`](#resizesize-fill--null)
    * [`sort()`](#sort)
    * [`unique()`](#unique)
    * [`clear()`](#clear)
    * [`join(separator)`](#joinseparator)
    * [`apply(func)`](#applyfunc)
    * [`extend(other)`](#extendother)
    * [`search(match)`](#searchmatch)
    * [`map(func)`](#mapfunc)
    * [`filter(condition)`](#filtercondition)
    * [`reduce(func, initial)`](#reducefunc-initial)
    * [`totable()`](#totable)
    * [`toarray()`](#toarray)
    * [`swapNode(node1, node2)`](#swapnodenode1-node2)
3. [IDT/tree_sort.nut](#idttree_sortnut)
    * [`AVLTree(...)`](#avltree)
    * [`FromArray(array)`](#fromarrayarray)
    * [`len()`](#len)
    * [`toarray()`](#toarray)
    * [`tolist()`](#tolist)
    * [`insert(key)`](#insertkey)
    * [`search(value)`](#searchvalue)
    * [`remove(value)`](#removevalue)
    * [`GetMin()`](#getmin)
    * [`GetMax()`](#getmax)
    * [`inorderTraversal()`](#inordertraversal)
    * [`printTree()`](#printtree)
    * [`Comparison with `](#comparison-with)
* [`*Choosing the Right Data Structure**](#choosing-the-right-data-structure)
4. [IDT/entity_creator.nut](#idtentity_creatornut)
    * [`CreateByClassname(classname, keyvalues)`](#createbyclassnameclassname-keyvalues)
    * [`CreateProp(classname, origin, modelname, activity, keyvalues)`](#createpropclassname-origin-modelname-activity-keyvalues)
    * [`FromEntity(CBaseEntity)`](#fromentitycbaseentity)
    * [`FindByClassname(classname, start_ent)`](#findbyclassnameclassname-start_ent)
    * [`FindByClassnameWithin(classname, origin, radius, start_ent)`](#findbyclassnamewithinclassname-origin-radius-start_ent)
    * [`FindByName(targetname, start_ent)`](#findbynametargetname-start_ent)
    * [`FindByNameWithin(targetname, origin, radius, start_ent)`](#findbynamewithintargetname-origin-radius-start_ent)
    * [`FindByModel(model, start_ent)`](#findbymodelmodel-start_ent)
    * [`FindByModelWithin(model, origin, radius, start_ent)`](#findbymodelwithinmodel-origin-radius-start_ent)
    * [`FindInSphere(origin, radius, start_ent)`](#findinsphereorigin-radius-start_ent)
5. [IDT/entity.nut](#idtentitynut)
    *   **Entity State and Lifecycle:**
        *   [`GetIndex()`](#getindex)
        *   [`IsValid()`](#isvalid)
        *   [`IsPlayer()`](#isplayer)
        *   [`isEqually(other)`](#isequallyother)
        *   [`Destroy(fireDelay, eventName)`](#destroyfiredelay-eventname)
        *   [`Kill(fireDelay, eventName)`](#killfiredelay-eventname)
        *   [`Dissolve(fireDelay, eventName)`](#dissolvefiredelay-eventname)
        *   [`Disable(fireDelay, eventName)`](#disablefiredelay-eventname)
        *   [`Enable(fireDelay, eventName)`](#enablefiredelay-eventname)
        *   [`IsDrawEnabled()`](#isdrawenabled)

    *   **Naming:**
        *   [`SetName(name, fireDelay, eventName)`](#setnamename-firedelay-eventname)
        *   [`SetUniqueName(prefix, fireDelay, eventName)`](#setuniquenameprefix-firedelay-eventname)
        *   [`GetNamePrefix()`](#getnameprefix)
        *   [`GetNamePostfix()`](#getnamepostfix)

    *   **Players Methods:**
        *   [`EyePosition()`](#eyeposition)
        *   [`EyeAngles()`](#eyeangles)
        *   [`EyeForwardVector()`](#eyeforwardvector)

    *   **Transformations:**
        *   [`SetAngles(x, y, z)`](#setanglesx-y-z)
        *   [`SetAbsAngles(angles)`](#setabsanglesangles)
        *   [`SetCenter(vector)`](#setcentervector)
        *   [`SetAbsCenter(vector)`](#setabscentervector)
        *   [`SetParent(parentEnt, fireDelay, eventName)`](#setparentparentent-firedelay-eventname)
        *   [`GetParent()`](#getparent)
        *   [`GetChildren()`](#getchildren)
        *   [`GetAllChildrenRecursively()`](#getallchildrenrecursively)
        *   [`SetModelScale(scaleValue, fireDelay, eventName)`](#setmodelscalescalevalue-firedelay-eventname)
        *   [`GetModelScale()`](#getmodelscale)

    *   **Appearance:**
        *   [`SetAlpha(opacity, fireDelay, eventName)`](#setalphaopacity-firedelay-eventname)
        *   [`SetColor(colorValue, fireDelay, eventName)`](#setcolorcolorvalue-firedelay-eventname)
        *   [`SetSkin(skin, fireDelay, eventName)`](#setskinskin-firedelay-eventname)
        *   [`SetDrawEnabled(isEnabled, fireDelay, eventName)`](#setdrawenabledisenabled-firedelay-eventname)
        *   [`SetAnimation(animationName, fireDelay, eventName)`](#setanimationanimationname-firedelay-eventname)
        *   [`GetAlpha()`](#getalpha)
        *   [`GetColor()`](#getcolor)
        *   [`GetSkin()`](#getskin)
        *   [`GetPartnerInstance()`](#getpartnerinstance)

    *   **Key Values and Data:**
        *   [`SetKeyValue(key, value, fireDelay, eventName)`](#setkeyvaluekey-value-firedelay-eventname)
        *   [`SetUserData(name, value)`](#setuserdataname-value)
        *   [`GetUserData(name)`](#getuserdataname)
        *   [`GetKeyValue(key)`](#getkeyvaluekey)
        *   [`SetContext(name, value, fireDelay, eventName)`](#setcontextname-value-firedelay-eventname)

    *   **Collision and Physics:**
        *   [`SetCollision(solidType, fireDelay, eventName)`](#setcollisionsolidtype-firedelay-eventname)
        *   [`SetCollisionGroup(collisionGroup, fireDelay, eventName)`](#setcollisiongroupcollisiongroup-firedelay-eventname)
        *   [`SetTraceIgnore(isEnabled, fireDelay, eventName)`](#settraceignoreisenabled-firedelay-eventname)
        *   [`SetSpawnflags(flag, fireDelay, eventName)`](#setspawnflagsflag-firedelay-eventname)
        *   [`GetSpawnflags()`](#getspawnflags)

    *   **Sound:**
        *   [`EmitSound(soundName, fireDelay = 0, eventName = "global")`](#emitsoundsoundname-firedelay--0-eventname--global)
        *   [`EmitSoundEx(soundName, volume = 10, looped = false, fireDelay = 0, eventName = "global")`](#emitsoundexsoundname-volume--10-looped--false-firedelay--0-eventname--global)
        *   [`StopSoundEx(soundName, fireDelay = 0, eventName = "global")`](#stopsoundexsoundname-firedelay--0-eventname--global)

    *   **Outputs and Inputs:**
        *   [`AddOutput(outputName, target, input, param, delay, fires)`](#AddOutputoutputname-target-input-param-delay-fires)
        *   [`ConnectOutputEx(outputName, script, delay, fires)`](#connectoutputexoutputname-script-delay-fires)
        *   [`SetInputHook(inputName, closure)`](#setinputhookinputname-closure)

    *   **Bounding Box and Position:**
        *   [`SetBBox(minBounds, maxBounds)`](#setbboxminbounds-maxbounds)
        *   [`GetBBox()`](#getbbox)
        *   [`IsSquareBbox()`](#issquarebbox)
        *   [`GetAABB()`](#getaabb)
        *   [`CreateAABB(stat)`](#createaabbstat)
        *   [`getBBoxPoints()`](#getbboxpoints)
        *   [`getBBoxFaces()`](#getbboxfaces)

## [IDT/array.nut](array.nut)

This file defines the `ArrayEx` class, which is an enhanced version of the standard VScripts array. It provides various methods for manipulating, searching, sorting, and converting arrays, making them more versatile and easier to work with.

### `ArrayEx(...)`

**Constructor**

Creates a new `ArrayEx` object from a variable number of arguments. This constructor allows you to initialize the `ArrayEx` with the specified elements directly.

**Parameters:**

*   `...` (any): A variable number of arguments representing the initial elements of the array.

**Example:**

```js
local myArrayEx = ArrayEx(1, "hello", Vector(0, 0, 0)) // Create an ArrayEx with three elements
```

### `FromArray(array)`

**Static Method**

Creates a new `ArrayEx` object from an existing array. This method is useful when you want to convert a standard Squirrel array into an `ArrayEx` object, preserving its elements. If the input `array` is already an `ArrayEx` object, it's returned directly without creating a new object.

**Parameters:**

*   `array` (array): The initial array to use for the `ArrayEx` object.

**Returns:**

*   (ArrayEx): The newly created or the input `ArrayEx` object.

**Example:**

```js
local myArray = [1, 2, 3]
local myArrayEx = ArrayEx.FromArray(myArray) // Create an ArrayEx object from the existing array

local existingArrayEx = ArrayEx(4, 5, 6)
local sameArrayEx = ArrayEx.FromArray(existingArrayEx) // Returns the same ArrayEx object
```

### `WithSize(numberOfItems, fillValue)`

**Static Method**

Creates a new `ArrayEx` object with a specified size, optionally filling it with a default value. This method is handy for creating arrays of a predefined size with initial values.

**Parameters:**

*   `numberOfItems` (int): The desired number of elements in the array.
*   `fillValue` (any, optional): The value to fill the array with (defaults to `null`).

**Returns:**

*   (ArrayEx): The newly created `ArrayEx` object.

**Example:**

```js
local myArrayEx = ArrayEx.WithSize(5, 0) // Creates an ArrayEx with 5 elements, each initialized to 0
```

### `append(value)`

This method appends a value to the end of the array. It automatically resizes the underlying array if necessary to accommodate the new element.

**Parameters:**

* `value` (any): The value to append to the array.

**Returns:**

* (ArrayEx): The `ArrayEx` object itself (for method chaining).

**Example:**

```js
myArrayEx.append(4) // Add the number 4 to the end of the array
```

### `apply(func)`

This method applies a function to each element of the array and modifies the array in-place. The function should take one argument (the element value) and return the new value for the element.

**Parameters:**

* `func` (function): The function to apply to each element. The function should take two arguments (the element value and index).

**Returns:**

* (ArrayEx): The `ArrayEx` object itself (for method chaining).

**Example:**

```js
myArrayEx.apply(function(x, _) { return x * 2 }) // Multiply each element by 2
myArrayEx.apply(function(val, idx) { return idx + ": " + val })
```

### `clear()`

This method removes all elements from the array and resets its length to 0.

**Returns:**

* (ArrayEx): The `ArrayEx` object itself (for method chaining).

**Example:**

```js
myArrayEx.clear() // Remove all elements from the array
```

### `extend(other)`

This method extends the array by appending all elements from another array or `ArrayEx` object to the end of this array. It automatically resizes the underlying array if necessary.

**Parameters:**

* `other` (array or ArrayEx): The array or `ArrayEx` object to append elements from.

**Returns:**

* (ArrayEx): The `ArrayEx` object itself (for method chaining).

**Example:**

```js
local otherArray = array("a", "b", "c")
myArrayEx.extend(otherArray) // Append the elements of otherArray to myArrayEx
```

### `filter(func)`

This method creates a new `ArrayEx` object containing only the elements that satisfy the predicate function.

**Parameters:**

* `func` (function): The predicate function that takes three arguments:
* `index` (number): The index of the current element.
* `value` (any): The value of the current element.
* `newArray` (ArrayEx): The new array being created.
The function should return `true` if the element should be included in the new array, and `false` otherwise.

**Returns:**

* (ArrayEx): A new `ArrayEx` object containing the filtered elements.

**Example:**

```js
local evenNumbers = myArrayEx.filter(function(index, value) {
    return value % 2 == 0 // Check if the value is even
})
```

### `contains(value)`

This method checks if the array contains the specified value.

**Parameters:**

* `value` (any): The value to search for.

**Returns:**

* (boolean): `true` if the value is found in the array, `false` otherwise.

**Example:**

```js
if (myArrayEx.contains(5)) {
    // The array contains the value 5
}
```

### `search(value or func)`

This method searches for a value or a matching element in the array and returns its index.

**Parameters:**

* `value or func` (any or function):
* If a value, the method searches for the first occurrence of that value in the array.
* If a function, the method searches for the first element that satisfies the predicate function. The function should take one argument (the element value) and return `true` if it matches, `false` otherwise.

**Returns:**

* (number or null): The index of the first matching element, or `null` if no match is found.

**Example:**

```js
local index = myArrayEx.search(5) // Find the index of the value 5
local index2 = myArrayEx.search(function(x) { return x > 10 }) // Find the index of the first element greater than 10
```

### `insert(index, value)`

This method inserts a value into the array at the specified index, shifting all subsequent elements to the right.

**Parameters:**

* `index` (number): The index at which to insert the value.
* `value` (any): The value to insert.

**Returns:**

* (ArrayEx): The `ArrayEx` object itself (for method chaining).

**Example:**

```js
myArrayEx.insert(2, "new element") // Insert "new element" at index 2
```

### `len()`

This method returns the number of elements in the array.

**Returns:**

* (number): The number of elements in the array.

**Example:**

```js
local arrayLength = myArrayEx.len() // Get the length of the array
```

### `map(func)`

This method creates a new `ArrayEx` object by applying a function to each element of this array.

**Parameters:**

* `func` (function): The function to apply to each element. The function should take two arguments (the element value and index) and return the new value for the element.

**Returns:**

* (ArrayEx): A new `ArrayEx` object containing the mapped values.

**Example:**

```js
local squares = myArrayEx.map(function(x, _) { return x * x }) // Create an array of squares of the original elements
```

### `reduce(func, initial)`
Reduce the array to a single value.

**Parameters:**

* `func` (Function): The reducer function, which takes the accumulator and current item as arguments.
* `initial` (any): The initial value of the accumulator.

**Returns:**

* (any): The reduced value.

**Example:**

```js
local myArray = ArrayEx.FromArray([1, 2, 3, 4, 5])
local sum = myArray.reduce(function(acc, item) {
    return acc + item
}, 0)
printl(sum) // Output: 15
```

### `unique()`
Return a new array with only unique elements.

**Returns:**

* (ArrayEx): The new array with unique elements.

**Example:**

```js
local myArray = ArrayEx.FromArray([1, 2, 2, 3, 4, 4, 5])
local uniqueArray = myArray.unique()
printl(uniqueArray) // Output: ArrayEx([1, 2, 3, 4, 5])
```

### `pop()`

This method removes and returns the last element of the array.

**Returns:**

* (any): The removed element.

**Example:**

```js
local lastElement = myArrayEx.pop() // Remove and return the last element of the array
```

### `push(value)`

This method appends a value to the end of the array. It is equivalent to `append(value)`.

**Parameters:**

* `value` (any): The value to append to the array.

**Returns:**

* (ArrayEx): The `ArrayEx` object itself (for method chaining).

**Example:**

```js
myArrayEx.push(5) // Add the value 5 to the end of the array
```

### `remove(index)`

This method removes the element at the specified index from the array, shifting all subsequent elements to the left.

**Parameters:**

* `index` (number): The index of the element to remove.

**Returns:**

* (any): The value of the removed element.

**Example:**

```js
myArrayEx.remove(1) // Remove the element at index 1
```

### `resize(size, fill)`

This method resizes the array to the specified size. If the new size is larger than the current size, the array is extended and the new elements are optionally filled with a specified value.

**Parameters:**

* `size` (number): The new size of the array.
* `fill` (any, optional): The value to fill new elements with (default is `null`).

**Returns:**

* (ArrayEx): The `ArrayEx` object itself (for method chaining).

**Example:**

```js
myArrayEx.resize(10, 0) // Resize the array to 10 elements, filling new elements with 0
```

### `reverse()`

This method reverses the order of elements in the array in-place.

**Returns:**

* (ArrayEx): The `ArrayEx` object itself (for method chaining).

**Example:**

```js
myArrayEx.reverse() // Reverse the order of elements in the array
```

### `slice(start, end)`

This method returns a new `ArrayEx` object containing a portion of the array.

**Parameters:**

* `start` (number): The starting index of the slice (inclusive).
* `end` (number, optional): The ending index of the slice (exclusive, defaults to the end of the array).

**Returns:**

* (ArrayEx): A new `ArrayEx` object containing the sliced elements.

**Example:**

```js
local slicedArray = myArrayEx.slice(1, 3) // Get a new array containing elements from index 1 to 2 (exclusive)
```

### `sort(func)`

This method sorts the elements of the array in-place, optionally using a comparison function.

**Parameters:**

* `func` (function, optional): A comparison function that takes two arguments (the two elements to compare) and returns:
* A negative value if the first element is less than the second element.
* Zero if the elements are equal.
* A positive value if the first element is greater than the second element.
If no comparison function is provided, the elements are sorted according to their default comparison behavior.

**Returns:**

* (ArrayEx): The `ArrayEx` object itself (for method chaining).

**Example:**

```js
myArrayEx.sort() // Sort the array in ascending order (default behavior)
myArrayEx.sort(function(a, b) { return b - a }) // Sort the array in descending order
```

### `top()`

This method returns the last element of the array.

**Returns:**

* (any): The last element of the array.

**Example:**

```js
local lastElement = myArrayEx.top() // Get the last element of the array
```

### `join(separator)`

This method joins the elements of the array into a string, separated by the specified separator.

**Parameters:**

* `separator` (string, optional): The separator to use between elements (default is an empty string).

**Returns:**

* (string): The joined string.

**Example:**

```js
local joinedString = myArrayEx.join(", ") // Join the array elements into a string separated by commas and spaces
```

### `get(index, default)`

This method returns the element at the specified index in the array. If the index is out of bounds, it returns a default value.

**Parameters:**

* `index` (number): The index of the element to retrieve.
* `default` (any, optional): The default value to return if the index is out of bounds (default is `null`).

**Returns:**

* (any): The element at the specified index, or the default value if the index is out of bounds.

**Example:**

```js
local element = myArrayEx.get(2) // Get the element at index 2
local element2 = myArrayEx.get(10, 0) // Get the element at index 10, or 0 if the index is out of bounds
```

### `totable(recreate)`

This method converts the array to a table, using the array elements as keys and setting the values to `null`.

**Parameters:**

* `recreate` (boolean, optional): Whether to recreate the table even if it already exists (default is `false`).

**Returns:**

* (table): The table representation of the array.

**Example:**

```js
local tableRepr = myArrayEx.totable() // Convert the array to a table
```

### `tolist()`

This method converts the array to a `List` object.

**Returns:**

* (List): The `List` object containing the elements of the array.

**Example:**

```js
local listRepr = myArrayEx.tolist() // Convert the array to a list
```

## [IDT/list.nut](list.nut)

This file defines the `List` class, which represents a doubly linked list and provides methods for adding and removing elements, accessing elements by index, reversing the list, and converting the list to an array. **A doubly linked list is a linear data structure where each element (node) contains a value and references to the previous and next nodes in the list.**

#### **Warning:**
Improper use of the List class can lead to memory leaks, as the garbage collector (GC) may not clean up the list if it is used incorrectly.


### `List(...)`
**Constructor** - Creates a new `List` object with optional initial elements.

**Parameters:**

* `...` (any): The initial elements to add to the list.

**Example:**

```js
local myList = List(1, 2, 3)
```

### `FromArray(array)`
Creates a new `List` object from an existing array.

**Parameters:**

* `array` (array): The array to create the list from.

**Returns:**

* (List): The new list containing the elements from the array.

**Example:**

```js
local myArray = [1, 2, 3]
local myList = List.FromArray(myArray)
```

### `len()`
Gets the length of the list, which is the number of elements it contains.

**Returns:**

* (number): The number of elements in the list.

**Example:**

```js
local listLength = myList.len()
```

### `iter()`
Returns an iterator object for the list. This method is more efficient than using a built-in iterator.

**Returns:**

* (iterator): An iterator for the list.

**Example:**

```js
foreach(value in myList.iter()) {
    printl(value)
}
```

### `rawIter()`
Similar to `iter`, but returns the node instead of the node's value.

**Returns:**

* (iterator): An iterator for the nodes in the list.

**Example:**

```js
foreach(node in myList.rawIter()) {
    printl(node.next_ref.value)
}
// Output: 2
//         3
//         null
```

### `append(value)`
Appends a value to the end of the list.

**Parameters:**

*   `value` (any): The value to append.

**Returns:**

*   (List): The `List` object itself (for method chaining).

**Example:**

```js
myList.append(4)
```

### `insert(index, value)`
Inserts a value at a specific index in the list.

**Parameters:**

* `index` (number): The index to insert the value at.
* `value` (any): The value to insert.

**Returns:**

*   (List): The `List` object itself (for method chaining).

**Example:**

```js
myList.insert(2, "inserted")
```

### `getNode(index)`
Gets the node at a specific index in the list. Throws an error if the index is out of bounds.

**Parameters:**

* `index` (number): The index of the node to retrieve.

**Returns:**

* (ListNode): The node at the specified index.

**Example:**

```js
local node = myList.getNode(1)
```

### `get(index, defaultValue)`
Gets the value at a specific index in the list, or a default value if the index is out of bounds.

**Parameters:**

* `index` (number): The index of the value to retrieve.
* `defaultValue` (any, optional): The value to return if the index is out of bounds.

**Returns:**

* (any): The value at the specified index or the default value if the index is out of bounds.

**Example:**

```js
local value = myList.get(2)
```

### `remove(index)`
Removes the node at a specific index from the list.

**Parameters:**

* `index` (number): The index of the node to remove.

**Returns:**

* (any): The value of the removed element.

**Example:**

```js
myList.remove(1)
```

### `pop()`
Removes the last element from the list and returns its value.

**Returns:**

* (any): The value of the removed element.

**Example:**

```js
local lastValue = myList.pop()
```

### `top()`
Gets the value of the last element in the list.

**Returns:**

*   (any): The value of the last element.

**Example:**

```js
local lastValue = myList.top()
```

### `first()`
Gets the value of the first element in the list. Throws an error if the list is empty.

**Returns:**
* (any): The value of the first element.

**Example:**
```js
local firstValue = myList.first()
```

### `reverse()`
Reverses the order of the elements in the list in-place.

**Returns:**

*   (List): The `List` object itself (for method chaining).

**Example:**

```js
myList.reverse()
```

### `slice(startIndex, endIndex = null)`
Returns a new `List` containing a portion of the original list.

**Parameters:**

* `startIndex` (number): The starting index of the slice (inclusive).
* `endIndex` (number, optional): The ending index of the slice (exclusive). If not provided, the slice extends to the end of the list.

**Returns:**

* (List): A new `List` containing the sliced portion.

**Example:**

```js
local newList = List(1, 2, 3, 4, 5)
local slicedList = newList.slice(1, 3) // Contains elements at index 1 and 2
printl(slicedList) // Output: List: [2, 3]
```

### `resize(size, fill = null)`
Resizes the list to the specified size. If the new size is larger than the current size, the list is padded with the `fill` value. If the new size is smaller, elements are removed from the end of the list.

**Parameters:**

* `size` (number): The new size of the list.
* `fill` (any, optional): The value to use for padding if the list is enlarged. Defaults to `null`.

**Returns:**
* (List): The `List` object itself (for method chaining).

**Example:**
```js
local list = List(1,2,3);
list.resize(5, 0); // list is now [1, 2, 3, 0, 0]
list.resize(2); // list is now [1, 2]

```

### `sort()`
Sorts the list in ascending order in-place, using the merge sort algorithm.

**Returns:**

*   (List): The `List` object itself (for method chaining).

**Example:**
```js
local list = List(3, 1, 4, 1, 5, 9, 2, 6)
list.sort()
printl(list) // Output: List: [1, 1, 2, 3, 4, 5, 6, 9]
```

### `unique()`
Returns a new list with only the unique elements from the original list.

**Returns:**

* (List): The new list with unique elements.

**Example:**

```js
local myList = List(1, 2, 2, 3, 4, 4, 5, 2, 5)
local uniqueList = myList.unique()
printl(uniqueList) // Output: List(1, 2, 3, 4, 5)
```

### `clear()`
Removes all elements from the list.

**Example:**

```js
myList.clear()
```

### `join(separator)`
Joins the elements of the list into a string, separated by the specified delimiter.

**Parameters:**

* `separator` (string, optional): The delimiter to use between elements (default is an empty string).

**Returns:**

* (string): The joined string.

**Example:**

```js
local joinedString = myList.join(", ")
```

### `apply(func)`
Applies a function to each element of the list and modifies the list in-place.

**Parameters:**

* `func` (function): The function to apply to each element. The function should take one argument (the element value) and return the modified value.

**Returns:**

* (List): The `List` object itself for method chaining.

**Example:**

```js
myList.apply(function(x, _) {
    return x * 2 // Double each element
})
myList.apply(function(val, idx) { return idx + ": " + val })
```

### `extend(other)`
Extends the list by appending all elements from another iterable.

**Parameters:**

* `other` (iterable): The iterable to append elements from.

**Returns:**

* (List): The `List` object itself for method chaining.

**Example:**

```js
local otherList = List(4, 5, 6)
myList.extend(otherList)
```

### `search(match)`
Searches for a value or a matching element in the list.

**Parameters:**

*  `match` (any or function): The value to search for, or a predicate function.
    *   If `match` is a value, the function returns the index of the *first* occurrence of that value in the list.
    *   If `match` is a function, the function returns the index of the *first* element for which the function returns `true`.  The predicate function receives the element value as its argument.

**Returns:**

* (number or null): The index of the first matching element, or `null` if no match is found.

**Example:**

```js
local list = List(10, 20, 30, 20)
local index1 = list.search(20)   // index1 will be 1
local index2 = list.search(function(x) { return x > 25 })  // index2 will be 2
local index3 = list.search(50)   // index3 will be null
```

### `map(func)`
Creates a new list by applying a function to each element of this list.

**Parameters:**

* `func` (function): The function to apply to each element. The function should take two arguments (the element value and index) and return the new value for the element.

**Returns:**

* (List): The new list with the mapped values.

**Example:**

```js
local squaredValues = myList.map(function(x, _) {
    return x * x // Square each element
})
```

### `filter(condition)`
Filters the list, creating a *new* list containing only the elements that satisfy a given condition.

**Parameters:**

* `condition` (function): The predicate function.  This function should accept up to three arguments: the element's index, the element's value, and the new list being built.  It should return `true` if the element should be included in the new list, and `false` otherwise.

**Returns:**

* (List): The new filtered list.

**Example:**

```js
local myList = List(1, 2, 3, 4, 5)
local evenList = myList.filter(function(idx, val, newList) {
    return val % 2 == 0
})
printl(evenList) // Output: List: [2, 4]
```

### `reduce(func, initial)`
Applies a function to an accumulator and each element in the list (from left to right) to reduce it to a single value.

**Parameters:**

* `func` (Function): The function to apply to each element and accumulator.
* `initial` (any): The initial value of the accumulator.

**Returns:**

* (any): The final reduced value.

**Example:**

```js
local myList = List(1, 2, 3, 4, 5)
local sum = myList.reduce(function(acc, item) {
    return acc + item
}, 0)
printl(sum) // Output: 15
```

### `totable()`
Converts the list to a table. The keys of the table will be the *values* from the list. The values in table will be set to `null`.

**Returns:**

* (table): The table representation.

**Example:**

```js
local myList = List("a", "b", "c")
local myTable = myList.totable()
printl("b" in myTable) // Output: true
printl(myTable) // Output: {"a": null, "b": null, "c": null}
```

### `toarray()`
Converts the list to an array.

**Returns:**

* (array): An array containing the elements of the list.

**Example:**

```js
local myArray = myList.toarray()
```

### `swapNode(node1, node2)`
**This is a global function, not the method of List class**. Swaps two nodes in the list. This method updates the references of the previous and next nodes accordingly.

**Parameters:**

* `node1` (ListNode): The first node to swap.
* `node2` (ListNode): The second node to swap.

**Example:**

```js
local nodeA = myList.getNode(0)
local nodeB = myList.getNode(1)
List.swapNode(nodeA, nodeB)
```

## [IDT/tree_sort.nut](tree_sort.nut)

This file defines the `AVLTree` class, which represents a self-balancing binary search tree (AVL tree). It provides methods for inserting and removing nodes, searching for nodes, and traversing the tree in different orders.

### `AVLTree(...)`
**Constructor** - Creates a new `AVLTree` object with optional initial elements.

**Parameters:**

* `...` (any): The initial elements to add to the tree.

**Example:**

```js
local myTree = AVLTree(5, 2, 8, 1, 3)
```

### `FromArray(array)`
Creates a new `AVLTree` object from an existing array.

**Parameters:**

* `array` (array): The array to create the tree from.

**Returns:**

* (AVLTree): The new tree containing the elements from the array.

**Example:**

```js
local myArray = [5, 2, 8, 1, 3]
local myTree = AVLTree.FromArray(myArray)
```

### `len()`
Gets the number of nodes in the tree.

**Returns:**

* (number): The number of nodes in the tree.

**Example:**

```js
local treeSize = myTree.len()
```

### `toarray()`
Converts the tree to an array using inorder traversal (ascending order).

**Returns:**

* (ArrayEx): An array containing the tree nodes in ascending order.

**Example:**

```js
local sortedArray = myTree.toarray()
```

### `tolist()`
Converts the tree to a list using inorder traversal (ascending order).

**Returns:**

* (List): A list containing the tree nodes in ascending order.

**Example:**

```js
local sortedList = myTree.tolist()
```

### `insert(key)`
Inserts a new node with the given key into the tree, maintaining the AVL tree's balance property.

**Parameters:**

* `key` (any): The key of the node to insert.

**Example:**

```js
myTree.insert(6) // Insert a new node with the key 6
```

### `search(value)`
Searches for a node with the given value in the tree and returns the node if found.

**Parameters:**

* `value` (any): The value to search for.

**Returns:**

* (treeNode or null): The node with the matching value, or `null` if not found.

**Example:**

```js
local node = myTree.search(3)
if (node) {
    // ...
}
```

### `remove(value)`
Removes the node with the given value from the tree, maintaining the AVL tree's balance property.

**Parameters:**

* `value` (any): The value of the node to remove.

**Example:**

```js
myTree.remove(2) // Remove the node with the value 2
```

### `GetMin()`
Returns the minimum value in the tree, which is the value of the leftmost node.

**Returns:**

* (any): The minimum value in the tree.

**Example:**

```js
local minValue = myTree.GetMin()
```

### `GetMax()`
Returns the maximum value in the tree, which is the value of the rightmost node.

**Returns:**

* (any): The maximum value in the tree.

**Example:**

```js
local maxValue = myTree.GetMax()
```

### `inorderTraversal()`
Performs an inorder traversal of the tree and returns an array of nodes in ascending order.

**Returns:**

* (ArrayEx): An array containing the tree nodes in ascending order.

**Example:**

```js
local sortedArray = myTree.inorderTraversal()
```

### `printTree()`
Prints a visual representation of the tree structure to the console, showing the nodes and their relationships.

**Example:**

```js
myTree.printTree()
```


### Comparison with `array`, `list` and `AVLTree`

* **`array`**: Arrays provide efficient random access to elements by index, making them suitable for situations where you need to frequently access elements by their position. However, inserting or removing elements at arbitrary positions in an array can be inefficient, as it may require shifting other elements to maintain the contiguous order.
* **`List`**: Linked lists excel at insertion and deletion operations, especially at the beginning or end of the list. This is because adding or removing a node only requires updating the references of the neighboring nodes. However, accessing elements by index in a linked list is less efficient than in an array, as it requires traversing the list from the beginning until the desired index is reached.
* **`AVLTree`**: AVL trees are self-balancing binary search trees that provide efficient search, insertion, and deletion operations while maintaining a sorted order. They are ideal for situations where you need to maintain a sorted collection of elements and perform frequent searches. However, AVL trees have a more complex structure than arrays or linked lists, which can make them slightly less efficient for simple insertion or deletion operations, especially at arbitrary positions.

### Choosing the Right Data Structure

The choice between `array`, `List`, and `AVLTree` depends on the specific requirements of your application. Consider the following factors:

* **Frequency of access by index**: If you need to frequently access elements by their position, an `array` is a good choice.
* **Frequency of insertions and deletions**: If you perform many insertions and deletions, especially at the beginning or end of the collection, a `List` might be more efficient.
* **Need for sorting**: If you need to maintain a sorted collection and perform frequent searches, an `AVLTree` is the best option.
* **Complexity**: If you need a simple data structure with minimal overhead, an `array` or `List` might be preferable.


## [IDT/entity_creator.nut](entity_creator.nut)

This file defines the `entLib` class, which provides helper functions for creating and finding entities.

### `CreateByClassname(classname, keyvalues)`
Creates an entity of the specified classname with the provided key-value pairs and returns it as a `pcapEntity` object.

**Parameters:**

* `classname` (string): The classname of the entity to create.
* `keyvalues` (table, optional): A table containing key-value pairs to set for the entity (default is an empty table).

**Returns:**

* (pcapEntity): The created entity as a `pcapEntity` object.

**Example:**

```js
local myEntity = entLib.CreateByClassname("prop_physics", {
    model = "models/my_model.mdl",
    health = 100
})
```

### `CreateProp(classname, origin, modelname, activity, keyvalues)`
Creates a prop entity with the specified classname, origin, model name, activity, and key-value pairs.

**Parameters:**

* `classname` (string): The classname of the prop entity to create (e.g., "prop_physics").
* `origin` (Vector): The initial position of the prop.
* `modelname` (string): The model name of the prop (e.g., "models/my_prop.mdl").
* `activity` (number, optional): The initial activity of the prop (default is 1).
* `keyvalues` (table, optional): A table containing additional key-value pairs to set for the prop (default is an empty table).

**Returns:**

* (pcapEntity): The created prop entity as a `pcapEntity` object.

**Example:**

```js
local myProp = entLib.CreateProp("prop_physics", Vector(0, 0, 100), "models/my_prop.mdl")
```

### `FromEntity(CBaseEntity)`
Wraps a `CBaseEntity` object in a `pcapEntity` object.

**Parameters:**

* `CBaseEntity` (CBaseEntity): The `CBaseEntity` object to wrap.

**Returns:**

* (pcapEntity): The wrapped entity as a `pcapEntity` object.

**Example:**

```js
local myPcapEntity = entLib.FromEntity(myEntity)
```

### `FindByClassname(classname, start_ent)`
Finds an entity with the specified classname.

**Parameters:**

* `classname` (string): The classname of the entity to find.
* `start_ent` (CBaseEntity or pcapEntity, optional): The entity to start the search from. If not specified, the search starts from the beginning of the entity list.

**Returns:**

* (pcapEntity or null): The found entity as a `pcapEntity` object, or `null` if no entity is found.

**Example:**

```js
local physicsProp = entLib.FindByClassname("prop_physics") // Find the first prop_physics entity
```

### `FindByClassnameWithin(classname, origin, radius, start_ent)`
Finds an entity with the specified classname within a given radius from the origin point.

**Parameters:**

* `classname` (string): The classname of the entity to find.
* `origin` (Vector): The origin point of the search sphere.
* `radius` (number): The radius of the search sphere.
* `start_ent` (CBaseEntity or pcapEntity, optional): The entity to start the search from. If not specified, the search starts from the beginning of the entity list.

**Returns:**

* (pcapEntity or null): The found entity as a `pcapEntity` object, or `null` if no entity is found.

**Example:**

```js
local nearbyButton = entLib.FindByClassnameWithin("prop_button", myPosition, 50)
// Find a prop_button entity within 50 units of myPosition
```

### `FindByName(targetname, start_ent)`
Finds an entity with the specified targetname.

**Parameters:**

* `targetname` (string): The targetname of the entity to find.
* `start_ent` (CBaseEntity or pcapEntity, optional): The entity to start the search from. If not specified, the search starts from the beginning of the entity list.

**Returns:**

* (pcapEntity or null): The found entity as a `pcapEntity` object, or `null` if no entity is found.

**Example:**

```js
local triggerEntity = entLib.FindByName("my_trigger")
```

### `FindByNameWithin(targetname, origin, radius, start_ent)`
Finds an entity with the specified targetname within a given radius from the origin point.

**Parameters:**

* `targetname` (string): The targetname of the entity to find.
* `origin` (Vector): The origin point of the search sphere.
* `radius` (number): The radius of the search sphere.
* `start_ent` (CBaseEntity or pcapEntity, optional): The entity to start the search from. If not specified, the search starts from the beginning of the entity list.

**Returns:**

* (pcapEntity or null): The found entity as a `pcapEntity` object, or `null` if no entity is found.

**Example:**

```js
local nearbyDoor = entLib.FindByNameWithin("exit_door", myPosition, 100)
// Find an entity named "exit_door" within 100 units of myPosition
```

### `FindByModel(model, start_ent)`
Finds an entity with the specified model.

**Parameters:**

* `model` (string): The model name of the entity to find.
* `start_ent` (CBaseEntity or pcapEntity, optional): The entity to start the search from. If not specified, the search starts from the beginning of the entity list.

**Returns:**

* (pcapEntity or null): The found entity as a `pcapEntity` object, or `null` if no entity is found.

**Example:**

```js
local crateEntity = entLib.FindByModel("models/props_junk/wood_crate001a.mdl")
```

### `FindByModelWithin(model, origin, radius, start_ent)`
Finds an entity with the specified model within a given radius from the origin point.

**Parameters:**

* `model` (string): The model name of the entity to find.
* `origin` (Vector): The origin point of the search sphere.
* `radius` (number): The radius of the search sphere.
* `start_ent` (CBaseEntity or pcapEntity, optional): The entity to start the search from. If not specified, the search starts from the beginning of the entity list.

**Returns:**

* (pcapEntity or null): The found entity as a `pcapEntity` object, or `null` if no entity is found.

**Example:**

```js
local nearbyCrate = entLib.FindByModelWithin("models/props_junk/wood_crate001a.mdl", myPosition, 50)
// Find a crate entity within 50 units of myPosition
```

### `FindInSphere(origin, radius, start_ent)`
Finds entities within a sphere defined by the origin and radius.

**Parameters:**

* `origin` (Vector): The origin point of the search sphere.
* `radius` (number): The radius of the search sphere.
* `start_ent` (CBaseEntity or pcapEntity, optional): The entity to start the search from. If not specified, the search starts from the beginning of the entity list.

**Returns:**

* (pcapEntity or null): The found entity as a `pcapEntity` object, or `null` if no entity is found.

**Example:**

```js
local entitiesInSphere = entLib.FindInSphere(myPosition, 100)
// Find entities within 100 units of myPosition
```

## [IDT/entity.nut](entity.nut)

This file defines the `pcapEntity` class, which extends the functionality of `CBaseEntity` with additional methods for manipulating entity properties, setting outputs, managing user data, and retrieving information about the entity's bounding box and other attributes. **Use entLib to create it**

### `SetAngles(x, y, z)`
Sets the angles (pitch, yaw, roll) of the entity, ensuring that the angles are within the range of 0 to 359 degrees.

**Parameters:**

* `x` (number): The pitch angle in degrees.
* `y` (number): The yaw angle in degrees.
* `z` (number): The roll angle in degrees.

**Example:**

```js
myPcapEntity.SetAngles(45, 90, 0) // Set the entity's angles
```

### `SetAbsAngles(angles)`
Sets the absolute rotation angles of the entity using a Vector.

**Parameters:**

* `angles` (Vector): The angle vector representing the desired rotation.

**Example:**

```js
myPcapEntity.SetAbsAngles(Vector(0, 180, 0)) // Set the entity to face the opposite direction
```

### `Destroy(fireDelay, eventName)`
Destroys the entity, removing it from the game world.

**Parameters:**

* `fireDelay` (number, optional): The delay in seconds before destroying the entity (default is 0).
* `eventName` (string, optional): The name of the event to schedule for (default is "global").

**Example:**

```js
myPcapEntity.Destroy() // Destroy the entity
```

### `Kill(fireDelay, eventName)`
Kills the entity, triggering its "kill" input with an optional delay.

**Parameters:**

* `fireDelay` (number, optional): The delay in seconds before killing the entity (default is 0).
* `eventName` (string, optional): The name of the event to schedule for (default is "global").

**Example:**

```js
myPcapEntity.Kill(2) // Kill the entity after 2 seconds
```

### `Dissolve(fireDelay, eventName)`
Dissolves the entity using an `env_entity_dissolver` entity. This creates a visual effect of the entity dissolving away.

**Parameters:**

* `fireDelay` (number, optional): The delay in seconds before dissolving the entity (default is 0).
* `eventName` (string, optional): The name of the event to schedule for (default is "global").

**Example:**

```js
myPcapEntity.Dissolve() // Dissolve the entity
```

### `IsValid()`
Checks if the entity is valid, meaning that it exists and has not been destroyed or dissolved.

**Returns:**

* (boolean): True if the entity is valid, false otherwise.

**Example:**

```js
if (myPcapEntity.IsValid()) {
    // The entity is valid and can be used
}
```

### `IsPlayer()`
Checks if the entity is the player entity.

**Returns:**

* (boolean): True if the entity is the player, false otherwise.

**Example:**

```js
if (myPcapEntity.IsPlayer()) {
    // The entity is the player
}
```

### `isEqually(other)`
Checks if this entity is equal to another entity based on their entity indices

**Parameters:**

* `other` (pcapEntity|CBaseEntity): The other entity to compare.

**Returns:**

* (boolean): True if the entities are equal, false otherwise.


### `EyePosition()`
Gets the eye position of the player entity as a Vector. This is the position from which the player's view is rendered.

**Returns:**

* (Vector): The eye position of the player, or `null` if the entity is not the player.

**Example:**

```js
local eyePos = GetPlayerEx().EyePosition()
```

### `EyeAngles()`
Gets the eye angles of the player entity as a Vector representing the pitch, yaw, and roll of the player's view.

**Returns:**

* (Vector): The eye angles of the player, or `null` if the entity is not the player.

**Example:**

```js
local eyeAngles = GetPlayerEx().EyeAngles()
```

### `EyeForwardVector()`
Gets the forward vector from the player entity's eye position. This represents the direction in which the player is looking.

**Returns:**

* (Vector): The forward vector from the player's eye position, or `null` if the entity is not the player.

**Example:**

```js
local eyeForward = GetPlayerEx().EyeForwardVector()
```

### `SetKeyValue(key, value, fireDelay, eventName)`
Sets a key-value pair for the entity. This modifies the entity's properties and also stores the value as user data for later retrieval using `GetKeyValue`.

**Parameters:**

* `key` (string): The key of the key-value pair.
* `value` (any): The value to set for the key.
* `fireDelay` (number, optional): The delay in seconds before setting the key-value pair (default is 0).
* `eventName` (string, optional): The name of the event to schedule for (default is "global").

**Example:**

```js
myPcapEntity.SetKeyValue("health", 100) // Set the entity's health to 100
```

### `AddOutput(outputName, target, input, param, delay, fires)`
Sets an output for the entity, connecting it to a target entity and input.

**Parameters:**

* `outputName` (string): The name of the output to set.
* `target` (string, CBaseEntity, or pcapEntity): The target entity to connect the output to (can be a targetname or an entity object).
* `input` (string): The name of the input on the target entity to connect to.
* `param` (string, optional): An optional parameter override for the input.
* `delay` (number, optional): An optional delay in seconds before triggering the input.
* `fires` (number, optional): The number of times the output should fire (default is -1 for unlimited fires).

**Example:**

```js
myPcapEntity.AddOutput("OnTrigger", "targetEntity", "Kill", "", 0.5, 1)
// Connect the "OnTrigger" output to the "Kill" input of "targetEntity" with a 0.5-second delay and fire only once
```

### `ConnectOutputEx(outputName, script, delay, fires)`
Connects an output to a script function or string with optional delay and trigger count.

**Parameters:**

* `outputName` (string or function): The name of the output to connect.
* `script` (string): The VScripts code or function name to execute when the output is triggered.
* `delay` (number, optional): The delay in seconds before executing the script.
* `fires` (number, optional): The number of times the output should fire (default is -1 for unlimited fires).

**Example:**

```js
myPcapEntity.ConnectOutputEx("OnTrigger", function() {
    printl("Output triggered!")
})
```

### `SetInputHook(inputName, closure)`
Sets an input hook for a specified input name, attaching a closure to be executed when the input is triggered.

**Parameters:**

* `inputName` (string): The name of the input to hook.
* `closure` (function): The function to execute when the input is triggered. This function should return `true` if the input should proceed normally, or `false` if the input should be blocked.

**Example:**

```js
local myEntity = ...

myEntity.SetInputHook("Use", function() {
    printl("Use input triggered!")
    return true // Allow the input to proceed
})

myEntity.SetInputHook("Kill", function() {
    printl("Kill input blocked!")
    return false // Block the input
})

```

In this example, when the `Use` input is triggered for `myEntity`, the specified closure function will be executed, printing "Use input triggered!".


### `EmitSound(soundName, fireDelay = 0, eventName = "global")`
This function provides more control over sound playback compared to EmitSound. It allows you to adjust the volume, loop sounds that are not inherently loopable, and stop the sound playback using StopSoundEx.

**Parameters:**

* `soundName` (string): The name of the sound to play.
* `fireDelay` (number, optional): The delay in seconds before playing the sound (default is 0).
* `eventName` (string, optional): The name of the event to schedule for (default is "global").

**Example:**

```js
myEntity.EmitSound("ambient/machines/thumper_hit.wav") // Play the sound immediately
myEntity.EmitSound("ambient/machines/thumper_hit.wav", 2) // Play the sound after 2 seconds
```


### `EmitSoundEx(soundName, volume = 10, looped = false, fireDelay = 0, eventName = "global")`

Plays a sound on the entity with enhanced control over volume and looping. This method is an improved version of `EmitSound` and offers more precise control over sound playback. Unlike the standard `EmitSound`, this method allows you to adjust the volume and force looping for any sound, even those not inherently designed to loop.

**How it Works:**

This method achieves its functionality by creating a hidden `prop_physics` entity with the `ALWAYS_PRECACHED_MODEL` model. This entity is then attached to the calling entity and used as a dedicated sound emitter. The volume is controlled by manipulating the Z-coordinate of the hidden entity, effectively simulating distance-based attenuation. Looping is achieved by scheduling repeated calls to `EmitSound` on the hidden entity. This approach allows for dynamic volume control and looping of any sound, regardless of its original properties.

**Parameters:**

* `soundName` (string): The name of the sound to play.
* `volume` (number, optional): The volume of the sound (0-10, default is 10).
* `looped` (boolean, optional): Whether the sound should loop (default is false).
* `fireDelay` (number, optional): The delay in seconds before playing the sound (default is 0).
* `eventName` (string, optional): The name of the event to schedule for (default is "global").

**Example:**

```js
myEntity.EmitSoundEx("ambient/machines/thumper_hit.wav", 5, true) // Play the sound at half volume and loop it
myEntity.EmitSoundEx("ambient/machines/thumper_hit.wav", 10, false, 2) // Play the sound at full volume after 2 seconds
```


### `StopSoundEx(soundName, fireDelay = 0, eventName = "global")`

Stops a sound previously started with `EmitSoundEx`. 

**Parameters:**

* `soundName` (string): The name of the sound to stop.
* `fireDelay` (number, optional): The delay in seconds before stopping the sound (default is 0).
* `eventName` (string, optional): The name of the event to schedule for (default is "global").

**Example:**

```js
myEntity.StopSoundEx("ambient/machines/thumper_hit.wav") // Stop the specified sound
```

### `SetName(name, fireDelay, eventName)`
Sets the targetname of the entity.

**Parameters:**

* `name` (string): The targetname to set.
* `fireDelay` (number, optional): The delay in seconds before setting the name (default is 0).
* `eventName` (string, optional): The name of the event to schedule for (default is "global").

**Example:**

```js
myPcapEntity.SetName("my_entity") // Set the entity's targetname
```

### `SetUniqueName(prefix, fireDelay, eventName)`
Sets a unique targetname for the entity using the provided prefix and a generated unique identifier.

**Parameters:**

* `prefix` (string, optional): The prefix to use for the unique targetname (default is "pcapEnt").
* `fireDelay` (number, optional): The delay in seconds before setting the unique name (default is 0).
* `eventName` (string, optional): The name of the event to schedule for (default is "global").

**Example:**

```js
myPcapEntity.SetUniqueName("my_entity") // Set a unique targetname starting with "my_entity_"
```

### `SetParent(parentEnt, fireDelay, eventName)`
Sets the parent entity for the entity, establishing a parent-child relationship.

**Parameters:**

* `parentEnt` (string, CBaseEntity, or pcapEntity): The parent entity to set (can be a targetname or an entity object).
* `fireDelay` (number, optional): The delay in seconds before setting the parent (default is 0).
* `eventName` (string, optional): The name of the event to schedule for (default is "global").

**Example:**

```js
local parentEntity = entLib.FindByClassname("prop_static")
myPcapEntity.SetParent(parentEntity) // Set the parent entity
```

### `GetParent()`
Gets the parent entity of the entity, if set.

**Returns:**

* (pcapEntity or null): The parent entity as a `pcapEntity` object, or `null` if no parent is set.

**Example:**

```js
local parent = myPcapEntity.GetParent()
if (parent) {
    // ... do something with the parent entity
}
```

### `GetChildren()`
Gets a list of all **direct** children of this entity. This function is not recursive and will only find entities that are immediate descendants (first level of the hierarchy).

**Returns:**

* (List): A `List` object containing all direct child `pcaptEntity` objects.

**Example:**
```js
local directChildren = myPcapEntity.GetAllChildren()
foreach(child in directChildren) {
    printl("Found direct child: " + child.GetName())
}
```

### `GetAllChildrenRecursively()`
Recursively finds all descendants (children, grandchildren, etc.) of this entity by performing a depth-first search of the entity hierarchy.

**Returns:**

* (List): A `List` object containing all descendant `pcaptEntity` objects.

**Example:**
```js
local allDescendants = myPcapEntity.GetAllChildrenRecursively()
foreach(descendant in allDescendants) {
    printl("Found descendant: " + descendant.GetName())
}

### `SetCollision(solidType, fireDelay, eventName)`
Sets the collision type of the entity, controlling how it interacts with other entities in the game world.

**Parameters:**

* `solidType` (number): The collision type to set (see the Source SDK documentation for valid values).
* `fireDelay` (number, optional): The delay in seconds before setting the collision type (default is 0).
* `eventName` (string, optional): The name of the event to schedule for (default is "global").

**Example:**

```js
myPcapEntity.SetCollision(SOLID_NONE) // Make the entity non-solid (pass through other entities)
```

### `SetCollisionGroup(collisionGroup, fireDelay, eventName)`
Sets the collision group of the entity, determining which other entities it can collide with.

**Parameters:**

* `collisionGroup` (number): The collision group to set (see the Source SDK documentation for valid values).
* `fireDelay` (number, optional): The delay in seconds before setting the collision group (default is 0).
* `eventName` (string, optional): The name of the event to schedule for (default is "global").

**Example:**

```js
myPcapEntity.SetCollisionGroup(COLLISION_GROUP_PLAYER) // Set the collision group to the player group
```

### `SetAnimation(animationName, fireDelay, eventName)`
Starts playing the specified animation on the entity.

**Parameters:**

* `animationName` (string): The name of the animation to play.
* `fireDelay` (number, optional): The delay in seconds before starting the animation (default is 0).
* `eventName` (string, optional): The name of the event to schedule for (default is "global").

**Example:**

```js
myPcapEntity.SetAnimation("run") // Start playing the "run" animation
```

### `SetAlpha(opacity, fireDelay, eventName)`
Sets the alpha (opacity) of the entity, controlling how transparent it appears.

**Parameters:**

* `opacity` (number): The alpha value between 0 (fully transparent) and 255 (fully opaque).
* `fireDelay` (number, optional): The delay in seconds before setting the alpha (default is 0).
* `eventName` (string, optional): The name of the event to schedule for (default is "global").

**Example:**

```js
myPcapEntity.SetAlpha(128) // Set the entity to be semi-transparent
```

### `SetColor(colorValue, fireDelay, eventName)`
Sets the color of the entity.

**Parameters:**

* `colorValue` (string or Vector): The color value as a string (e.g., "255 0 0" for red) or a Vector with components (r, g, b).
* `fireDelay` (number, optional): The delay in seconds before setting the color (default is 0).
* `eventName` (string, optional): The name of the event to schedule for (default is "global").

**Example:**

```js
myPcapEntity.SetColor("0 255 0") // Set the entity to green
```

### `SetSkin(skin, fireDelay, eventName)`
Sets the skin of the entity, if the entity has multiple skins available.

**Parameters:**

* `skin` (number): The index of the skin to set.
* `fireDelay` (number, optional): The delay in seconds before setting the skin (default is 0).
* `eventName` (string, optional): The name of the event to schedule for (default is "global").

**Example:**

```js
myPcapEntity.SetSkin(2) // Set the entity's skin to the third available skin
```

### `SetDrawEnabled(isEnabled, fireDelay, eventName)`
Enables or disables rendering of the entity, controlling whether it is visible in the game world.

**Parameters:**

* `isEnabled` (boolean): True to enable rendering (make the entity visible), false to disable rendering (make the entity invisible).
* `fireDelay` (number, optional): The delay in seconds before setting the draw state (default is 0).
* `eventName` (string, optional): The name of the event to schedule for (default is "global").

**Example:**

```js
myPcapEntity.SetDrawEnabled(false) // Make the entity invisible
```

### `Disable(fireDelay, eventName)`
Disables the entity, making it invisible and preventing interactions. Equivalent to calling `SetDrawEnabled(false)` and `SetTraceIgnore(true)`.

**Parameters:**

* `fireDelay` (number, optional): The delay in seconds before disabling the entity (default is 0).
* `eventName` (string, optional): The name of the event to schedule for (default is "global").

**Example:**

```js
myPcapEntity.Disable() // Disable the entity
```

### `Enable(fireDelay, eventName)`
Enables the entity, making it visible and allowing interactions. Equivalent to calling `SetDrawEnabled(true)` and `SetTraceIgnore(false)`.

**Parameters:**

* `fireDelay` (number, optional): The delay in seconds before enabling the entity (default is 0).
* `eventName` (string, optional): The name of the event to schedule for (default is "global").

**Example:**

```js
myPcapEntity.Enable() // Enable the entity
```

### `IsDrawEnabled()`
Checks if the entity is set to be drawn (visible).

**Returns:**

* (boolean): True if the entity is set to be drawn, false otherwise.

**Example:**

```js
if (myPcapEntity.IsDrawEnabled()) {
    // The entity is visible
}
```

### `SetTraceIgnore(isEnabled, fireDelay, eventName)`
Sets whether the entity should be ignored during traces. This can be used to prevent the entity from blocking traces or being detected by them.

**Parameters:**

* `isEnabled` (boolean): True to ignore the entity during traces, false otherwise.
* `fireDelay` (number, optional): The delay in seconds before setting the trace ignore state (default is 0).
* `eventName` (string, optional): The name of the event to schedule for (default is "global").

**Example:**

```js
myPcapEntity.SetTraceIgnore(true) // Ignore the entity during traces
```

### `SetSpawnflags(flag, fireDelay, eventName)`
Sets the spawnflags of the entity, which can affect its behavior and properties.

**Parameters:**

* `flag` (number): The spawnflags value to set.
* `fireDelay` (number, optional): The delay in seconds before setting the spawnflags (default is 0).
* `eventName` (string, optional): The name of the event to schedule for (default is "global").

**Example:**

```js
myPcapEntity.SetSpawnflags(128) // Set the NPC_GAG spawnflag for an NPC entity
```

### `SetModelScale(scaleValue, fireDelay, eventName)`
Sets the scale of the entity's model, making it larger or smaller.

**Parameters:**

* `scaleValue` (number): The scale value to set.
* `fireDelay` (number, optional): The delay in seconds before setting the model scale (default is 0).
* `eventName` (string, optional): The name of the event to schedule for (default is "global").

**Example:**

```js
myPcapEntity.SetModelScale(2) // Double the size of the entity's model
```

### `GetModelScale()`
Gets the current model scale of the entity.

**Returns:**

* (number): The current model scale value.

**Example:**

```js
local currentScale = myPcapEntity.GetModelScale()
```

### `SetCenter(vector)`
Sets the center of the entity's bounding box. This effectively moves the entity while maintaining its orientation.

**Parameters:**

* `vector` (Vector): The new center position for the entity's bounding box.

**Example:**

```js
myPcapEntity.SetCenter(Vector(10, 20, 30)) // Set the center of the entity's bounding box
```

### `SetAbsCenter(vector)`
Sets the absolute center of the entity in world space. This will override any parent-relative positioning. 
Otherwise, it's the same as SetCenter.


### `SetBBox(minBounds, maxBounds)`
Sets the bounding box of the entity using vectors or string representations of vectors.

**Parameters:**

* `minBounds` (Vector or string): The minimum bounds of the bounding box as a Vector or a string representation (e.g., "-5 -5 -5").
* `maxBounds` (Vector or string): The maximum bounds of the bounding box as a Vector or a string representation (e.g., "5 5 5").

**Example:**

```js
myPcapEntity.SetBBox(Vector(-10, -10, -10), Vector(10, 10, 10)) // Set a bounding box of 20x20x20 units
```

### `SetContext(name, value, fireDelay, eventName)`
Sets a context value for the entity, which can be used for storing additional information or state associated with the entity.

**Parameters:**

* `name` (string): The name of the context value.
* `value` (any): The value to set for the context.
* `fireDelay` (number, optional): The delay in seconds before setting the context value (default is 0).
* `eventName` (string, optional): The name of the event to schedule for (default is "global").

**Example:**

```js
myPcapEntity.SetContext("activated", true) // Set a context value indicating that the entity has been activated
```

### `SetUserData(name, value)`
Stores an arbitrary value associated with the entity using a name. This is a general-purpose mechanism for attaching custom data to entities.

**Parameters:**

* `name` (string): The name of the user data value.
* `value` (any): The value to store.

**Example:**

```js
myPcapEntity.SetUserData("myData", {count = 10, message = "Hello"})
```

### `GetUserData(name)`
Retrieves a stored user data value by name.

**Parameters:**

* `name` (string): The name of the user data value to retrieve.

**Returns:**

* (any or null): The stored value, or `null` if no value is found with the given name.

**Example:**

```js
local myData = myPcapEntity.GetUserData("myData")
macros.PrintIter(myData)
```

### `GetBBox()`
Returns the bounding box of the entity as a table with two Vector properties: `min` and `max`, representing the minimum and maximum extents of the box.

**Returns:**

* (table): A table with `min` and `max` Vector properties representing the bounding box.

**Example:**

```js
local bbox = myPcapEntity.GetBBox()
printl("Bounding box min:", bbox.min)
printl("Bounding box max:", bbox.max)
```

### `IsSquareBbox()`

This function checks if the bounding box of an entity is a cube, meaning all sides of the bounding box have equal length.

**Returns:**

* (boolean): True if the bounding box is a cube, false otherwise.

**Example:**

```js
local isCube = entity.IsSquareBbox() 
if (isCube) {
    // Bounding box is a cube
} else {
    // Bounding box is not a cube 
}
```

### `GetAABB()`
Returns the axis-aligned bounding box (AABB) of the entity, which is a box that is aligned with the world axes and tightly encloses the entity.

**Returns:**

* (table): A table with three Vector properties: `min`, `max`, and `center`, representing the minimum and maximum extents of the AABB, as well as its center point.

**Example:**

```js
local aabb = myPcapEntity.GetAABB()
printl("AABB min:", aabb.min)
printl("AABB max:", aabb.max)
printl("AABB center:", aabb.center)
```

### `GetIndex()`
Returns the index of the entity, which is a unique identifier for the entity within the game.

**Returns:**

* (number): The index of the entity.

**Example:**

```js
local entityIndex = myPcapEntity.GetIndex()
```

### `GetKeyValue(key)`
Returns the value of a key-value pair for the entity, if it was set using the `SetKeyValue` method or other `pcapEntity` methods. It cannot retrieve values set directly through Hammer or the console.

**Parameters:**

* `key` (string): The key of the key-value pair to retrieve.

**Returns:**

* (any or null): The value associated with the key, or `null` if the key is not found.

**Example:**

```js
local healthValue = myPcapEntity.GetKeyValue("health")
```

### `GetSpawnflags()`
Returns the spawnflags of the entity, if they were set using the `SetSpawnflags` method.

**Returns:**

* (number or null): The spawnflags value, or `null` if the spawnflags were not set using `SetSpawnflags`.

**Example:**

```js
local spawnflags = myPcapEntity.GetSpawnflags()
```

### `GetAlpha()`
Returns the alpha (opacity) value of the entity, if it was set using the `SetAlpha` method.

**Returns:**

* (number or null): The alpha value, or 255 if the alpha was not set using `SetAlpha`.

**Example:**

```js
local alpha = myPcapEntity.GetAlpha()
```

### `GetColor()`
Returns the color of the entity as a string, if it was set using the `SetColor` method.

**Returns:**

* (string or null): The color string in format "R G B", or "255 255 255" if the color was not set using `SetColor`.

**Example:**

```js
local color = myPcapEntity.GetColor()
```

### `GetSkin()`
Returns the skin index of the entity, if it was set using the `SetSkin` method.

**Returns:**

* (number or null): The skin index, or 0 if the skin was not set using `SetSkin`.

**Example:**

```js
local skin = myPcapEntity.GetSkin()
```

### `GetNamePrefix()`
Returns the prefix of the entity's name, if the name contains a "-" separator.

**Returns:**

* (string): The prefix of the entity name, or the entire name if no "-" separator is found.

**Example:**

```js
local prefix = myPcapEntity.GetNamePrefix()
```

### `GetNamePostfix()`
Returns the postfix of the entity's name, if the name contains a "-" separator.

**Returns:**

* (string): The postfix of the entity name, or the entire name if no "-" separator is found.

**Example:**

```js
local postfix = myPcapEntity.GetNamePostfix()
```

### `GetPartnerInstance()`
Retrieves the portal partner instance of the entity, prioritizing the actual partner entity if available, and falling back to user-stored partner data if necessary.

**Returns:**

* (Entity|null): The partner entity, or null if no partner is found.

**Example:**

```js
local partner = myPortalEntity.GetPartnerInstance()
if (partner) {
    // ... do something with the partner entity
}
```

### `CreateAABB(stat)`
Returns a specific face of the entity's oriented bounding box (AABB) as a vector. **This is required for `GetAABB`**

**Parameters:**

* `stat` (number): An index indicating which face of the AABB to return (0 for min bounds, 7 for max bounds, 4 for center).

**Returns:**

* (Vector): The vector representing the specified face of the AABB.

**Example:**

```js
local minBounds = myPcapEntity.CreateAABB(0) // Get the minimum bounds of the AABB
```

### `getBBoxPoints()`
Returns an array of vectors representing the 8 vertices of the entity's axis-aligned bounding box (AABB). **This is required for `CreateAABB`**

**Returns:**

* (array): An array of 8 Vectors, each representing a vertex of the AABB.

**Example:**

```js
local vertices = myPcapEntity.getBBoxPoints() // Get the vertices of the AABB
```

### `getBBoxFaces()`
This method retrieves the faces of an entity's bounding box as an array of triangle vertices. It is used to access and work with the individual triangular faces that make up the bounding box.

**Returns:**

* (array): An array of 12 Vector triplets, where each triplet represents the three vertices of a triangle face.

**Example:**

```js
local myEntity = entLib.FindByClassname("prop_physics")
local faces = myEntity.getBBoxFaces()

// Iterate over the faces and print the vertices of each triangle
foreach(i, face in faces ) {
    printl("Face", i, ":")
    foreach(j, vertex in face.vertices) {
        printl(" Vertex", j, ":", vertex)
    }
}
```