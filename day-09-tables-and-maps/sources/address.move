module blockchain::table_and_map_demo {
    use std::table::{Self, Table};
    use std::vector;
    use std::simple_map::{Self, SimpleMap};
    use std::debug::print;
    use std::signer;

    /*
    ============================================================================
    Module: table_and_map_demo
    ============================================================================

    This module demonstrates the usage of both `Table` and `SimpleMap` data structures
    within the Move programming language. It includes functions to create empty tables and maps,
    add entries, remove entries, borrow values, and corresponding test functions that utilize
    `debug::print` to display outputs. Additionally, at the end of the module, detailed comments
    define all methods of `SimpleMap` and `Table` along with their descriptions.

    Key Components:
    - Table Operations: Creating, adding, removing, and borrowing entries.
    - SimpleMap Operations: Creating, adding, removing, and borrowing entries.
    - Test Functions: Unit tests that showcase and validate the operations using `debug::print`.
    */

    /*
    ============================================================================
    Table Operations
    ============================================================================
    */

    /*
    Function: create_table
    ============================================================================

    Description:
    Creates a new, empty `Table<u64, u64>` instance.

    Usage:
    Initializes a new table to store key-value pairs with `u64` keys and `u64` values.

    Returns:
    - `Table<u64, u64>`: A new empty table.
    */
    public fun create_table(): Table<u64, u64> {
        let new_tab: Table<u64, u64> = table::new();
        new_tab
    }

    /*
    Function: add_value_to_table
    ============================================================================

    Description:
    Adds predefined key-value pairs to the provided `Table<u64, u64>`.

    Parameters:
    - `table`: A mutable reference to the table where values will be added.

    Usage:
    Inserts key-value pairs `(1, 100)` and `(2, 200)` into the table.
    */

    public fun add_value_to_table(table: &mut Table<u64, u64>) {
        table::add(table, 1, 100);
        table::add(table, 2, 200);
    }

    /*
    Function: remove_value_from_table
    ============================================================================

    Description:
    Removes a key-value pair from the provided `Table<u64, u64>` based on the key.

    Parameters:
    - `table`: A mutable reference to the table from which the value will be removed.
    - `key`: The key of the value to be removed.

    Returns:
    - `u64`: The value that was removed.

    Usage:
    Removes the key `1` from the table and returns the associated value.
    */
    public fun remove_value_from_table(table: &mut Table<u64, u64>, key: u64): u64 {
        table::remove(table, key)
    }

    /*
    Function: borrow_value_from_table
    ============================================================================

    Description:
    Borrows a value from the provided `Table<u64, u64>` based on the key.

    Parameters:
    - `table`: A reference to the table from which the value will be borrowed.
    - `key`: The key of the value to be borrowed.

    Returns:
    - `&u64`: An immutable reference to the borrowed value.

    Usage:
    Borrows the value associated with key `2` from the table.
    */
    public fun borrow_value_from_table(table: &Table<u64, u64>, key: u64): &u64 {
        table::borrow(table, key)
    }

    /*
    ============================================================================
    SimpleMap Operations
    ============================================================================
    */

    /*
    Function: create_map
    ============================================================================

    Description:
    Creates a new, empty `SimpleMap<address, u64>` instance.

    Parameters:
    - `signer_ref`: A reference to a signer, used to generate a key based on the signer's address.

    Usage:
    Initializes a new map to store key-value pairs with `address` keys and `u64` values.

    Returns:
    - `SimpleMap<address, u64>`: A new empty simple map.
    */
    public fun create_map(): SimpleMap<address, u64> {
        let mp: SimpleMap<address, u64> = simple_map::create();
        simple_map::add(&mut mp, @blockchain, 10);
        mp
    }

    /*
    Function: add_values_to_map
    ============================================================================

    Description:
    Adds predefined key-value pairs to the provided `SimpleMap<address, u64>`.

    Parameters:
    - `map`: A mutable reference to the map where values will be added.
    - `keys`: A vector of addresses to be used as keys.
    - `values`: A vector of `u64` values corresponding to the keys.

    Usage:
    Inserts key-value pairs into the map. Ensures that the lengths of keys and values match.
    */
    public fun add_values_to_map(map: &mut SimpleMap<address, u64>, keys: vector<address>, values: vector<u64>) {
        simple_map::add_all(map, keys, values);
    }

    /*
    Function: remove_value_from_map
    ============================================================================

    Description:
    Removes a key-value pair from the provided `SimpleMap<address, u64>` based on the key.

    Parameters:
    - `map`: A mutable reference to the map from which the value will be removed.
    - `key`: The key of the value to be removed.

    Returns:
    - `u64`: The value that was removed.

    Usage:
    Removes the key associated with `0x1` from the map and returns the associated value.
    */
    public fun remove_value_from_map(map: &mut SimpleMap<address, u64>, key: address) {
        simple_map::remove(map, &key);
    }

    /*
    Function: borrow_value_from_map
    ============================================================================

    Description:
    Borrows a value from the provided `SimpleMap<address, u64>` based on the key.

    Parameters:
    - `map`: A reference to the map from which the value will be borrowed.
    - `key`: The key of the value to be borrowed.

    Returns:
    - `&u64`: An immutable reference to the borrowed value.

    Usage:
    Borrows the value associated with a specific key from the map.
    */
    public fun borrow_value_from_map(map: &SimpleMap<address, u64>, key: address): u64 {
        let borrowed = simple_map::borrow(map, &key);
        *borrowed
    }

    /*
    ============================================================================
    Test Functions
    ============================================================================
    */

    /*
    Function: test_map_operations_demo
    ============================================================================

    Description:
    A unit test that verifies the `demo_map_operations` functions. It performs the following steps:
    1. Creates a map.
    2. Adds values to the map.
    3. Removes a value from the map.
    4. Borrows a value from the map.
    5. Prints the map and borrowed value.

    Usage:
    Executes `demo_map_operations` and observes the debug outputs to ensure correctness.
    */
    #[test]
    fun test_map_operations_demo() {
        // Step 1: Create a new map
        let map = create_map();
        print(&map);

        let key1 = @0x01;
        let key2= @0x02;

        // Step 2: Add values to the map
        let keys = vector::empty<address>();
        let values = vector::empty<u64>();
        vector::push_back(&mut keys, key1);
        vector::push_back(&mut keys, key2);
        vector::push_back(&mut values, 1000);
        vector::push_back(&mut values, 2000);
        add_values_to_map(&mut map, keys, values);
        print(&map);

        // Step 3: Remove a value from the map
        print(&map);

        // Step 4: Borrow a value from the map
        let borrowed_value = borrow_value_from_map(&map, key2);
        print(&borrowed_value); // Should print 2000
    }

/*
============================================================================
Method Definitions and Descriptions
============================================================================

Below is a summary of all methods available in the `SimpleMap` and `Table` modules, along with their descriptions:

### SimpleMap Methods

| Function              | Description                                                                                       | Return Value                |
|-----------------------|---------------------------------------------------------------------------------------------------|-----------------------------|
| `create<K, V>`        | Creates a new, empty `SimpleMap` instance.                                                         | `SimpleMap<K, V>`           |
| `add<K, V>`           | Adds a key-value pair to the map. Aborts if the key already exists.                               | `()`                         |
| `contains_key<K, V>`  | Checks whether the map contains a specific key.                                                  | `bool`                      |
| `remove<K, V>`        | Removes the key-value pair associated with the given key. Aborts if the key does not exist.        | `V`                          |
| `length<K, V>`        | Retrieves the number of elements in the map.                                                      | `u64`                        |
| `borrow<K, V>`        | Borrows an immutable reference to the value associated with the given key. Aborts if the key doesn't exist. | `&V`                 |
| `borrow_mut<K, V>`    | Borrows a mutable reference to the value associated with the given key. Aborts if the key doesn't exist. | `&mut V`           |
| `destroy_empty<K, V>` | Destroys the map if it is empty. Aborts otherwise.                                                | `()`                         |
| `add_all<K, V>`       | Adds multiple key-value pairs to the map. Aborts if the lengths of keys and values vectors don't match or if any key already exists. | `()`        |
| `upsert<K, V>`        | Inserts a key-value pair if the key does not exist; updates the value if the key exists.          | `()`                         |
| `to_vec_pair<K, V>`   | Converts the map into separate vectors of keys and values.                                       | `(vector<K>, vector<V>)`     |
| `destroy<K, V>`       | Destroys the map, removing all its entries and freeing associated resources.                      | `()`                         |

### Table Methods

| Function                  | Description                                                                                           | Return Value              |
|---------------------------|-------------------------------------------------------------------------------------------------------|---------------------------|
| `new<K, V>`               | Creates a new, empty `Table` instance with `u64` keys and `u64` values.                               | `Table<K, V>`             |
| `add<K, V>`               | Adds a key-value pair to the table. Aborts if the key already exists.                                 | `()`                       |
| `borrow<K, V>`            | Borrows an immutable reference to the value associated with the given key. Aborts if the key doesn't exist. | `&V`                |
| `borrow_mut<K, V>`        | Borrows a mutable reference to the value associated with the given key. Aborts if the key doesn't exist. | `&mut V`             |
| `borrow_mut_with_default<K, V>` | Borrows a mutable reference to the value; inserts a default value if the key does not exist.    | `&mut V`                   |
| `upsert<K, V>`            | Inserts a key-value pair if the key does not exist; updates the value if the key exists.              | `()`                       |
| `remove<K, V>`            | Removes the key-value pair associated with the given key. Aborts if the key does not exist.            | `V`                        |
| `contains<K, V>`          | Checks whether the table contains a specific key.                                                     | `bool`                    |
| `destroy<K, V>`           | Destroys the table, removing all its entries and freeing associated resources.                        | `()`                       |
| `move_to_sender`          | (Helper Function) Generates a unique address for the table handle. Placeholder for handle creation.    | `address`                  |

---
*/
}
