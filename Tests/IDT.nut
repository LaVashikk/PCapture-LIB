// IDT Module Unit Tests
if(!("RunTests" in getroottable())) IncludeScript("PCapture-LIB/Tests/test_exec")

idt_tests <- {

    // --- Array Tests ---
    function array_creation_test() {
        local arr = ArrayEx(1, 2, 3)
        return assert(arr.len() == 3 && arr[0] == 1 && arr[1] == 2 && arr[2] == 3)
    },

    function array_append_test() {
        local arr = ArrayEx()
        arr.append(1)
        arr.append(2)
        return assert(arr.len() == 2 && arr[0] == 1 && arr[1] == 2)
    },

    function array_apply_test() {
        local arr = ArrayEx(1, 2, 3)
        arr.apply(function(x, _) return x * 2)
        return assert(arr[0] == 2 && arr[1] == 4 && arr[2] == 6)
    },

    function array_clear_test() {
        local arr = ArrayEx(1, 2, 3)
        arr.clear()
        return assert(arr.len() == 0)
    },

    function array_extend_test() {
        local arr1 = ArrayEx(1, 2)
        local arr2 = ArrayEx(3, 4)
        arr1.extend(arr2)
        return assert(arr1.len() == 4 && arr1[2] == 3 && arr1[3] == 4)
    },

    function array_filter_test() {
        local arr = ArrayEx(1, 2, 3, 4)
        local filtered = arr.filter(function(_, val, _) return val % 2 == 0)
        return assert(filtered.len() == 2 && filtered[0] == 2 && filtered[1] == 4)
    },

    function array_contains_test() {
        local arr = ArrayEx(1, 2, 3)
        return assert(arr.contains(2) && !arr.contains(4))
    },

    function array_search_test() {
        local arr = ArrayEx("apple", "banana", "cherry")
        return assert(arr.search("banana") == 1 && arr.search("grape") == null)
    },

    function array_insert_test() {
        local arr = ArrayEx(1, 3)
        arr.insert(1, 2)
        return assert(arr.len() == 3 && arr[1] == 2)
    },

    function array_remove_test() {
        local arr = ArrayEx(1, 2, 3)
        arr.remove(1) 
        return assert(arr.len() == 2 && arr[1] == 3)
    },

    function array_pop_test() {
        local arr = ArrayEx(1, 2, 3)
        local poppedValue = arr.pop()
        return assert(arr.len() == 2 && poppedValue == 3)
    },

    function array_push_test() {
        local arr = ArrayEx(1, 2)
        arr.push(3)
        return assert(arr.len() == 3 && arr[2] == 3)
    },

    function array_resize_test() {
        local arr = ArrayEx(1, 2)
        arr.resize(4, 0)
        return assert(arr.len() == 4 && arr[2] == 0 && arr[3] == 0)
    },

    function array_reverse_test() {
        local arr = ArrayEx(1, 2, 3)
        arr.reverse()
        return assert(arr[0] == 3 && arr[1] == 2 && arr[2] == 1)
    },

    function array_slice_test() {
        local arr = ArrayEx(1, 2, 3, 4)
        local sliced = arr.slice(1, 3)
        return assert(sliced.len() == 2 && sliced[0] == 2 && sliced[1] == 3)
    },

    function array_sort_test() {
        local arr = ArrayEx(3, 1, 2)
        arr.sort()
        return assert(arr[0] == 1 && arr[1] == 2 && arr[2] == 3)
    },

    function array_top_test() {
        local arr = ArrayEx(1, 2, 3)
        return assert(arr.top() == 3) 
    },

    function array_join_test() {
        local arr = ArrayEx("a", "b", "c")
        return assert(arr.join("-") == "a-b-c")
    },

    function array_get_test() {
        local arr = ArrayEx(1, 2, 3)
        return assert(arr.get(1) == 2 && arr.get(4, -1) == -1)
    },

    function array_tolist_test() {
        local arr = ArrayEx(1, 2, 3)
        local list = arr.tolist()
        return assert(list.len() == 3 && typeof list == "List")
    },


    // --- List Tests ---
    function list_creation_test() {
        local list = List(1, 2, 3)
        return assert(list.len() == 3 && list[0] == 1 && list[1] == 2 && list[2] == 3)
    },

    function list_append_test() {
        local list = List()
        list.append(1)
        list.append(2)
        return assert(list.len() == 2 && list[0] == 1 && list[1] == 2)
    },

    function list_apply_test() {
        local list = List(1, 2, 3)
        list.apply(function(x, _) return x * 2)
        return assert(list[0] == 2 && list[1] == 4 && list[2] == 6)
    },

    function list_insert_test() {
        local list = List(1, 3)
        list.insert(1, 2)
        return assert(list.len() == 3 && list[1] == 2)
    },

    function list_remove_test() {
        local list = List(1, 2, 3)
        list.remove(1)
        return assert(list.len() == 2 && list[1] == 3)
    },

    function list_pop_test() {
        local list = List(1, 2, 3)
        local poppedValue = list.pop()
        return assert(list.len() == 2 && poppedValue == 3)
    },

    function list_top_test() {
        local list = List(1, 2, 3)
        return assert(list.top() == 3)
    },

    function list_sort_test() {
        local list = List(3, 1, 2)
        list.sort()
        return assert(list[0] == 1 && list[1] == 2 && list[2] == 3)
    },

    function list_hard_sort_test() {
        local list = List(3, 1, 2)
        list.sort()

        for(local i = 100; i >= 0; i--) {
            list.append(RandomInt(1, 10000))
            list.insert(RandomInt(0, 100), RandomInt(1, 10000))
        }
        list.sort()
        
        for(local i = 1; i < list.len(); i++) {
            if(list[i - 1] > list[i]) {
                return assert(false)
            }
        }
    },

    function list_get_test() {
        local list = List(1, 2, 3)
        return assert(list.get(1) == 2 && list.get(4, -1) == -1)
    },

    function list_reverse_test() {
        local list = List(1, 2, 3)
        list.reverse() 
        return assert(list[0] == 3 && list[1] == 2 && list[2] == 1)
    },

    function list_clear_test() {
        local list = List(1, 2, 3)
        list.clear()
        return assert(list.len() == 0)
    },

    function list_join_test() {
        local list = List("a", "b", "c")
        return assert(list.join("-") == "a-b-c")
    },

    function list_extend_test() {
        local list1 = List(1, 2)
        local list2 = List(3, 4)
        list1.extend(list2)
        return assert(list1.len() == 4 && list1[2] == 3 && list1[3] == 4)
    },

    function list_extend_test2() {
        local list1 = List(1, 2)

        local list2 = List(3, 4)
        local list3 = List(5, 6, 7)
        local list4 = List(7, 8, 9)
        
        list1.extend(list2)
        list1.extend(list3)
        list1.extend(list4)
        
        for(local i = 1; i < list1.len(); i++) {
            if(list1[i - 1] > list1[i]) {
                return assert(false)
            }
        }
    },

    function list_search_test() {
        local list = List("apple", "banana", "cherry")
        return assert(list.search("banana") == 1 && list.search("grape") == null)
    },

    function list_map_test() {
        local list = List(1, 2, 3)
        local mapped = list.map(function(x, _) return x * 2)
        return assert(mapped.len() == 3 && mapped[0] == 2 && mapped[1] == 4 && mapped[2] == 6)
    },

    function list_toarray_test() {
        local list = List(1, 2, 3)
        local arr = list.toarray()
        return assert(arr.len() == 3 && typeof arr == "ArrayEx")
    },


    // --- AVLTree Tests ---
    function tree_creation_test() {
        local tree = AVLTree(3, 2, 1)
        return assert(tree.len() == 3 && tree[0] == 1 && tree[1] == 2 && tree[2] == 3)
    },

    function tree_insert_test() {
        local tree = AVLTree()
        tree.insert(2)
        tree.insert(1)
        tree.insert(3)
        return assert(tree.len() == 3 && tree[0] == 1 && tree[1] == 2 && tree[2] == 3)
    },

    function tree_search_test() {
        local tree = AVLTree(3, 2, 1)
        return assert(tree.search(2) != null && tree.search(4) == null) 
    },

    function tree_remove_test() {
        local tree = AVLTree(3, 2, 1)
        tree.remove(2)
        return assert(tree.len() == 2 && tree[0] == 1 && tree[1] == 3)
    },

    function tree_min_test() {
        local tree = AVLTree(3, 2, 1)
        return assert(tree.min(tree.root).value == 1)
    },

    function tree_max_test() {
        local tree = AVLTree(3, 2, 1)
        return assert(tree.max(tree.root).value == 3)
    },

    function tree_inordertraversal_test() {
        local tree = AVLTree(3, 2, 1)
        local result = tree.inorderTraversal()
        return assert(result.len() == 3 && result[0] == 1 && result[1] == 2 && result[2] == 3)
    },


    function tree_fromarray_test() {
        local arr = ArrayEx(3, 2, 1)
        local tree = AVLTree.FromArray(arr)
        return assert(tree.len() == 3 && tree[0] == 1 && tree[1] == 2 && tree[2] == 3)
    },


    // --- Entity Tests ---
    function entity_creation_test() {
        local modelName = GetPlayer().GetModelName()
        local ent = entLib.CreateByClassname("prop_dynamic", {model = modelName})
        return assert(ent.IsValid() && ent.GetModelName() == modelName)
    },

    function entity_from_entity_test() {
        local originalEnt = Entities.CreateByClassname("prop_dynamic")
        local pcapEnt = entLib.FromEntity(originalEnt)
        return assert(pcapEnt.IsValid() && pcapEnt.CBaseEntity == originalEnt && typeof pcapEnt == "pcapEntity")
    },

    function entity_find_by_name_test() {
        local ent = entLib.CreateByClassname("prop_dynamic", {targetname = "test_name_prop"})
        local foundEnt = entLib.FindByName("test_name_prop")
        return assert(foundEnt.IsValid() && foundEnt.GetName() == ent.GetName())
    },

    function entity_key_value_test() {
        local ent = entLib.CreateByClassname("prop_dynamic")
        ent.SetKeyValue("targetname", "i love pcapture")
        return assert(ent.GetName() == "i love pcapture")
    },

    function entity_name_test() {
        local ent = entLib.CreateByClassname("prop_dynamic")
        ent.SetName("test_entity")
        return assert(ent.GetName() == "test_entity")
    },

    function entity_collision_test() {
        local ent = entLib.CreateByClassname("prop_dynamic")
        ent.SetCollision(2) 
        return assert(ent.GetKeyValue("Solidtype") == 2)
    },

    function entity_collision_group_test() {
        local ent = entLib.CreateByClassname("prop_dynamic")
        ent.SetCollisionGroup(COLLISION_GROUP_DEBRIS)
        return assert(ent.GetKeyValue("CollisionGroup") == COLLISION_GROUP_DEBRIS)
    },

    function entity_alpha_test() {
        local ent = entLib.CreateByClassname("prop_dynamic")
        ent.SetAlpha(128)
        return assert(ent.GetKeyValue("alpha") == 128)
    },

    function entity_color_test() {
        local ent = entLib.CreateByClassname("prop_dynamic")
        ent.SetColor(Vector(255, 0, 0))
        return assert(ent.GetColor() == "255 0 0")
    },

    function entity_draw_enabled_test() {
        local ent = entLib.CreateByClassname("prop_dynamic")
        ent.SetDrawEnabled(false)
        return assert(!ent.IsDrawEnabled())
    },

    function entity_spawnflags_test() {
        local ent = entLib.CreateByClassname("prop_dynamic")
        ent.SetSpawnflags(8)
        return assert(ent.GetSpawnflags() == 8)
    },

    function entity_model_scale_test() {
        local ent = entLib.CreateByClassname("prop_dynamic")
        ent.SetModelScale(2.0) 
        return assert(ent.GetModelScale() == 2.0)
    },

    function entity_bbox_test() {
        local ent = entLib.CreateByClassname("prop_dynamic") 
        ent.SetBBox(Vector(-5, -5, -5), Vector(5, 5, 5))
        local min = ent.GetBoundingMins()
        local max = ent.GetBoundingMaxs()
        return assert(math.vector.IsEqual(min, Vector(-5, -5, -5)) && math.vector.IsEqual(max, Vector(5, 5, 5)))
    },

    function entity_context_test() {
        local ent = entLib.CreateByClassname("prop_dynamic")
        ent.SetContext("test_key", "test_value") 
        return assert(ent.GetUserData("test_key") == "test_value")
    },

    function entity_get_aabb_test() {
        local ent = entLib.CreateByClassname("prop_dynamic") 
        local aabb = ent.GetAABB()
        return assert(aabb.min != null && aabb.max != null && aabb.center != null)
    }, 

    function entity_get_index_test() {
        local ent = entLib.CreateByClassname("prop_dynamic") 
        return assert(ent.GetIndex() >= 0) 
    }, 

    function entity_get_alpha_test() {
        local ent = entLib.CreateByClassname("prop_dynamic")
        return assert(ent.GetAlpha() == 255) 
    },

    function entity_get_color_test() {
        local ent = entLib.CreateByClassname("prop_dynamic")
        return assert(ent.GetColor() == "255 255 255") 
    }, 

    function entlib_find_by_classname_within_test() {
        local origin = Vector(1708, 1012, 1110)
        local radius = 100 
        local ent = entLib.CreateByClassname("point_playermoveconstraint", {targetname = "test_ent"})
        ent.SetAbsOrigin(origin)
        local foundEnt = entLib.FindByClassnameWithin("point_playermoveconstraint", origin, radius) 
        return assert(foundEnt.IsValid() && foundEnt.GetName() == "test_ent")
    },

    function entlib_find_by_name_within_test() {
        local origin = Vector(1708, 1012, 1110)
        local radius = 100
        local ent = entLib.CreateByClassname("point_push", {targetname = "test_teta"})
        ent.SetAbsOrigin(origin) 
        local foundEnt = entLib.FindByNameWithin("test_teta", origin, radius) 
        return assert(foundEnt.IsValid() && foundEnt.GetName() == ent.GetName())
    },

    function entlib_find_by_model_test() {
        local ent = entLib.CreateByClassname("prop_dynamic", {model = "models/props_junk/watermelon01.mdl"})
        local foundEnt = entLib.FindByModel("models/props_junk/watermelon01.mdl")
        return assert(foundEnt.IsValid() && foundEnt.GetModelName() == ent.GetModelName())
    },

    function entlib_find_in_sphere_test() {
        local origin = math.vector.random(1000, 100000)
        local radius = 100
        local ent = entLib.CreateByClassname("prop_dynamic")
        ent.SetAbsOrigin(origin) 
        local foundEnt = entLib.FindInSphere(origin, radius)
        return assert(foundEnt.IsValid() && foundEnt == ent)
    },
}

// Run all tests
RunTests("Improved Data Type's", idt_tests)