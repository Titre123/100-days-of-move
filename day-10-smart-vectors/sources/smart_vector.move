// This module demonstrates the concept of Smart Vectors in the Aptos Framework.
// Smart Vectors are advanced data structures optimized for handling large datasets efficiently.

module blockchain::SmartVector {

    // Import the SmartVector module and associated functions from the Aptos standard library.
    use aptos_std::smart_vector::{Self, SmartVector};
    use std::debug::print;

    // Define a custom struct to store a SmartVector.
    // The `has key` attribute allows the struct to be stored in the account's storage.
    struct SmartObject has key {
        value: SmartVector<u64> // A SmartVector that stores unsigned 64-bit integers.
    }

    // Function to initialize the module and create a SmartVector in the account's storage.
    public fun init_module(account: &signer) {
        // Create a new SmartVector that will hold `u64` values.
        let smartvec = smart_vector::new<u64>();

        // Add elements to the SmartVector using `push_back`.
        smart_vector::push_back(&mut smartvec, 1);
        smart_vector::push_back(&mut smartvec, 2);
        smart_vector::push_back(&mut smartvec, 3);

        // Store the SmartVector inside the SmartVector struct in the account's storage.
        move_to(account, SmartObject {
            value: smartvec
        });
    }

    // Function to get the length of the SmartVector stored in an account.
    #[view]
    public fun get_length(addr: address): u64 acquires SmartVector {
        // Borrow the SmartVector from the SmartVector stored in the account.
        let vec = &borrow_global<SmartVector>(addr).value;

        // Return the length of the SmartVector.
        smart_vector::length(vec)
    }

    // Test function to initialize the module and verify the length of the SmartVector.
    #[test(caller = @0x1)]
    fun test_smart_vector_operations(caller: &signer) acquires SmartVector {
        // Initialize the module and create a SmartVector.
        init_module(caller);

        // Retrieve the length of the SmartVector and print it for debugging purposes.
        let len = get_length(address_of(caller));
        print(&len); // Should output: 3
    }

    // Advanced example: Populate the SmartVector with a large number of elements.
    public fun populate_large_vector(caller: &signer) acquires SmartVector {
        let smartvec = smart_vector::new<u64>();
        let i = 0;

        // Use a loop to add 1000 elements to the SmartVector.
        while (i <= 1000) {
            smart_vector::push_back(&mut smartvec, i);
            i = i + 1;
        };

        // Store the populated SmartVector in the SmartVector struct.
        move_to(caller, SmartVector {
            value: smartvec
        });
    }

    // Test function to verify the length of a large SmartVector.
    #[test(caller = @0x1)]
    fun test_large_vector(caller: &signer) acquires SmartVector {
        // Populate the SmartVector with 1000 elements.
        populate_large_vector(caller);

        // Retrieve and print the length of the SmartVector.
        let len = get_length(address_of(caller));
        print(&len); // Should output: 1001
    }
}

/*
Key Concepts:
1. **SmartVector Structure**: Smart Vectors use a bucket system to efficiently handle large datasets.
   - Buckets divide data into smaller chunks, improving performance and reducing gas costs.
   - For example, when querying elements, only the relevant bucket is accessed.

2. **Optimized Operations**:
   - Smart Vectors combine the advantages of vectors, maps, and tables.
   - This allows efficient data addition, retrieval, and storage.

3. **Real-world Usage**:
   - Use Smart Vectors to manage large-scale application data in a gas-efficient manner.

4. **Testing**:
   - Unit tests verify that Smart Vectors function as expected.
   - Example outputs: `3` for a small vector, `1001` for a vector with 1000 elements.
*/
