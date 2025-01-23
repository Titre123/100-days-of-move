module blockchain::events {
    use aptos_framework::event;
    use aptos_framework::account;
    use std::signer;
    use std::debug::print;

    // Define the Event Struct
    #[event]
    struct ValueAddedEvent has drop, store {
        value: u64,
        executor: address
    }

    // Define a global resource to store data and an EventHandle
    struct GlobalData has key {
        value: u64,
        event_handle: event::EventHandle<ValueAddedEvent>
    }

    const EResourceNotExist: u64 = 33;
    const ENotEqual: u64 = 10;

    // Create a new global resource with an event handle
    public fun new_global(acc: &signer, value: u64) {
        let event_handle = account::new_event_handle<ValueAddedEvent>(acc);
        let data = GlobalData {
            value,
            event_handle
        };
        move_to(acc, data);
    }

    // Change the value in global storage and emit an event
    public entry fun add_to_value_from_global_storage(signer: &signer, value: u64) acquires GlobalData {
        let addr = signer::address_of(signer);
        if (!exists<GlobalData>(addr)) {
            abort EResourceNotExist;
        };

        let global_data = borrow_global_mut<GlobalData>(addr);
        global_data.value = global_data.value + value;

        // Emit the event
        event::emit_event(&mut global_data.event_handle, ValueAddedEvent {
            value,
            executor: addr
        });
    }

    // Check if global storage exists
    public fun check_global_storage_exists(addr: address): bool {
        exists<GlobalData>(addr)
    }

    // Retrieve the value from global storage
    #[view]
    public fun get_value_from_global_storage(addr: address): u64 acquires GlobalData {
        if (!exists<GlobalData>(addr)) {
            abort EResourceNotExist;
        };
        let global_data = borrow_global<GlobalData>(addr);
        print(&global_data.value);
        global_data.value
    }


    // Test creating a global resource and emitting events
    #[test(account = @0x1)]
    fun test_new_global(account: &signer) {
        new_global(account, 10);
    }

    #[test(account = @0x1)]
    fun test_change_value_global(account: &signer) acquires GlobalData {
        new_global(account, 10);
        add_to_value_from_global_storage(account, 10); // value should now be 20

        let value = get_value_from_global_storage(signer::address_of(account));
        assert!(value == 20, ENotEqual);
    }
}
