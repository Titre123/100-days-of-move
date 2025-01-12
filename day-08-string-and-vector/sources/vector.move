module blockchain::VectorAndString {
    use std::vector;
    use std::debug::print;
    use std::string::{String, utf8};

    /* 
    ============================================================================
    Module: VectorAndString
    ============================================================================
    
    This module provides comprehensive functionalities to interact with vectors and 
    strings within the Move language environment. It demonstrates the creation, 
    manipulation, and utilization of vectors and strings, showcasing their fundamental 
    operations and interactions.
    
    Key Components:
    - Vector Operations: Creation, addition, access by index, removal, destruction, and copying.
    - String Operations: Conversion between vectors and strings, and string manipulation.
    - Test Functions: Unit tests that demonstrate and verify the functionalities using debug::print.
    */

    /* 
    ============================================================================
    Definitions
    ============================================================================
    
    Vector<T>:
    - **Type:** Generic vector type `vector<T>`.
    - **Description:** A homogeneous, expandable/shrinkable collection of values of type `T`.
    - **Usage:** Used to store collections of elements, allowing dynamic resizing through various operations.
    
    String:
    - **Type:** `String` from the `std::string` module.
    - **Description:** Represents a sequence of characters encoded as bytes. Internally, it leverages `vector<u8>`.
    - **Usage:** Used for handling textual data, providing utility functions for conversion and manipulation.
    */

    /* 
    ============================================================================
    Vector Operations
    ============================================================================
    */

    /* 
    Function: add_last_vec
    ============================================================================
    
    Description:
    Adds a single `u64` number to the end of a newly created vector and returns the vector.
    
    Parameters:
    - `number`: The `u64` value to be added to the vector.
    
    Returns:
    - `vector<u64>`: The resulting vector containing the added number.
    
    Usage:
    Initializes an empty vector, adds the specified number using `push_back`, and returns the vector.
    */
    public fun add_last_vec(number: u64): vector<u64> {
        let list = vector::empty<u64>();
        vector::push_back(&mut list, number);
        return list
    }


    /* 
    Function: get_value_by_index_vec
    ============================================================================
    
    Description:
    Retrieves a `u64` value from a vector at the specified index.
    
    Parameters:
    - `index`: The index from which to retrieve the value.
    
    Returns:
    - `u64`: The value at the specified index in the vector.
    
    Preconditions:
    - The vector must contain at least `index + 1` elements.
    
    Usage:
    Creates a vector with predefined values, accesses the value at the given index using `borrow`, and returns it.
    */
    public fun get_value_by_index_vec(index: u64): u64 {
        let list = vector::empty<u64>();
        vector::push_back(&mut list, 10);
        vector::push_back(&mut list, 20);
        vector::push_back(&mut list, 30);
        return *vector::borrow(&list, index)
    }

    /* 
    Function: take_last_value_in_vec
    ============================================================================
    
    Description:
    Removes and returns the last value from a vector.
    
    Returns:
    - `(vector<u64>, u64)`: A tuple containing the modified vector and the removed value.
    
    Usage:
    Initializes a vector with predefined values, removes the last element using `pop_back`, and returns both the updated vector and the removed value.
    */
    public fun take_last_value_in_vec(): (vector<u64>, u64) {
        let list = vector::empty<u64>();
        vector::push_back(&mut list, 10);
        vector::push_back(&mut list, 20);
        vector::push_back(&mut list, 30);
        let take_value: u64 = vector::pop_back(&mut list);
        return (list, take_value)
    }

    /* 
    Function: destroy_any_vector
    ============================================================================
    
    Description:
    Explicitly destroys a vector that contains elements with non-droppable types.
    
    Parameters:
    - `vec`: The vector to be destroyed.
    
    Usage:
    Invokes `vector::destroy_empty` to delete the vector. This is necessary for vectors containing elements that cannot be implicitly discarded.
    
    Note:
    - `vector::destroy_empty` will trigger a runtime error if the vector is empty.
    */
    public fun destroy_any_vector<T>(vec: vector<T>) {
        vector::destroy_empty(vec)
    }

    // String functioms
    fun vec_string() {
        let vec_string: vector<u8> = b"Hello by vector u8";
        let by_string: String = utf8(b"Hello by String");
        let by_vec: String = utf8(vec_string);
        print(&vec_string);
        print(&by_string);
        print(&by_vec);
    }


    /* 
    ============================================================================
    Test Functions
    ============================================================================
    */

    /* 
    Function: test_add_last_vec
    ============================================================================
    
    Description:
    Tests the `add_last_vec` function by adding a value to a vector and printing the result.
    
    Usage:
    Invokes `add_last_vec` with a sample value and prints the resulting vector using `debug::print`.
    */
    #[test]
    fun test_add_last_vec() {
        let vec = add_last_vec(500);
        print(&vec);
    }

    /* 
    Function: test_get_value_by_index_vec
    ============================================================================
    
    Description:
    Tests the `get_value_by_index_vec` function by retrieving a value from a vector by index and printing it.
    
    Usage:
    Calls `get_value_by_index_vec` with a sample index and prints the retrieved value.
    */
    #[test]
    fun test_get_value_by_index_vec() {
        let value = get_value_by_index_vec(1);
        print(&value);
    }

    /* 
    Function: test_take_last_value_in_vec
    ============================================================================
    
    Description:
    Tests the `take_last_value_in_vec` function by removing the last value from a vector and printing both the modified vector and the removed value.
    
    Usage:
    Executes `take_last_value_in_vec` and prints the resulting vector and the removed value.
    */
    #[test]
    fun test_take_last_value_in_vec() {
        let (list, take_value) = take_last_value_in_vec();
        print(&list);
        print(&take_value);
    }

    /* 
    Function: test_clone_vector
    ============================================================================
    
    Description:
    Tests the cloning (copying) of a vector that contains elements with the `copy` capability.
    
    Usage:
    Creates a vector, clones it using the `copy` keyword, and prints both the original and cloned vectors.
    */
    #[test]
    fun test_clone_vector() {
        let vec = add_last_vec(10);
        let vec_copy = copy vec;
        print(&vec_copy);
    }

    #[test]
    fun test_vec_string() {
        vec_string()
    }

    /* 
    ============================================================================
    Additional Vector Functions
    ============================================================================
    
    The following table summarizes additional built-in vector functions available in Move:

    | Function         | Parameters                                | Description                                                             | Return Value                |
    |------------------|-------------------------------------------|-------------------------------------------------------------------------|-----------------------------|
    | `empty<T>`       | None                                      | Creates an empty vector that can store values of type `T`.              | `vector<T>`                 |
    | `singleton<T>`   | `t: T`                                    | Creates a vector of size 1 containing `t`.                              | `vector<T>`                 |
    | `push_back<T>`   | `v: &mut vector<T>, t: T`                 | Adds `t` to the end of `v`.                                              | `()`                        |
    | `pop_back<T>`    | `v: &mut vector<T>`                       | Removes and returns the last element in `v`.                            | `T`                         |
    | `borrow<T>`      | `v: &vector<T>, i: u64`                    | Returns an immutable reference to the `T` at index `i`.                 | `&T`                        |
    | `borrow_mut<T>`  | `v: &mut vector<T>, i: u64`                | Returns a mutable reference to the `T` at index `i`.                     | `&mut T`                    |
    | `destroy_empty<T>`| `v: vector<T>`                            | Deletes `v`.                                                             | `()`                        |
    | `append<T>`      | `v1: &mut vector<T>, v2: vector<T>`        | Adds the elements in `v2` to the end of `v1`.                            | `()`                        |
    | `contains<T>`    | `v: &vector<T>, e: &T`                      | Returns `true` if `e` is in the vector `v`, otherwise `false`.          | `bool`                      |
    | `swap<T>`        | `v: &mut vector<T>, i: u64, j: u64`          | Swaps the elements at the `i`th and `j`th indices in the vector `v`.     | `()`                        |
    | `reverse<T>`     | `v: &mut vector<T>`                         | Reverses the order of the elements in the vector `v` in place.          | `()`                        |
    | `index_of<T>`    | `v: &vector<T>, e: &T`                      | Returns `(true, i)` if `e` is in the vector `v` at index `i`, otherwise `(false, 0)`. | `(bool, u64)`             |
    | `remove<T>`      | `v: &mut vector<T>, i: u64`                  | Removes the `i`th element of the vector `v`, shifting all subsequent elements. | `T`                        |
    | `swap_remove<T>` | `v: &mut vector<T>, i: u64`                  | Swaps the `i`th element with the last element and then pops the element. | `T`                        |
    */

    /* 
    ============================================================================
    Conclusion
    ============================================================================
    
    This `VectorAndString` module encapsulates essential operations for vectors and strings in Move. It provides:
    
    - **Vectors:**
        - Creation and initialization with various data types.
        - Fundamental operations like adding, accessing, and removing elements.
        - Handling of vectors containing non-droppable or copyable elements.
        - Comprehensive test functions to validate vector functionalities.
    
    - **Strings:**
        - Creation of strings from byte vectors.
        - Conversion between `vector<u8>` and `String`.
        - Printing and manipulation of string data.
        - Test functions to demonstrate string operations.
    
    Mastery of vectors and strings is crucial for effective Move programming, enabling developers to handle dynamic collections and textual data efficiently within smart contracts and blockchain applications.
    */
}
