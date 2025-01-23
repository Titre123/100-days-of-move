module blockchain::smart_table {
    // Import necessary modules for SmartTable operations and debugging
    use aptos_std::smart_table::{Self, SmartTable};
    use std::debug::print;
    use std::signer::address_of;

    // Define a resource to store the SmartTable with a key
    struct SmartTableResource has key {
        value: SmartTable<address, u64>
    }

    // Function to initialize the module for a caller
    fun init_module(caller: &signer) {
        // Create a new SmartTable and add the caller's address with an initial value of 0
        let val = smart_table::new<address, u64>();
        smart_table::add(&mut val, address_of(caller), 0);
        // Move the SmartTableResource to the caller
        move_to(caller, SmartTableResource {
            value: val
        });
    }

    // View function to get the amount of points for a given address
    #[view]
    public fun get_amount_point(addr: address): u64 acquires SmartTableResource {
        // Borrow the SmartTableResource for the given address and return the value
        let table = &borrow_global<SmartTableResource>(addr).value;
        *smart_table::borrow(table, addr)
    }

    // Function to add points to a user's balance
    public fun plus_point(addr: address, value: u64) acquires SmartTableResource {
        // Borrow the SmartTableResource for the given address, update the value, and upsert it
        let table = &mut borrow_global_mut<SmartTableResource>(addr).value;
        let point = *smart_table::borrow_mut(table, addr);
        let new_point = point + value;
        smart_table::upsert(table, addr, new_point);
    }

    // Test-only function to initialize the module for testing purposes
    #[test_only]
    fun test_init_module(caller: &signer) {
        init_module(caller);
    }

    // Test function to verify get_amount_point functionality
    #[test(caller = @0x1)]
    fun test_get_amount_point(caller: &signer) acquires SmartTableResource {
        // Initialize the module for the caller
        test_init_module(caller);
        // Retrieve the amount of points for the caller and print it
        let amount = get_amount_point(address_of(caller));
        print(&amount); // Outputs: 0
    }

    // Test function to verify plus_point functionality
    #[test(caller = @0x1)]
    fun test_plus_amount_point(caller: &signer) acquires SmartTableResource {
        // Initialize the module for the caller
        test_init_module(caller);
        // Add points to the caller's balance and retrieve the updated amount
        plus_point(address_of(caller), 10);
        let amount = get_amount_point(address_of(caller));
        print(&amount); // Outputs: 10
    }
}
