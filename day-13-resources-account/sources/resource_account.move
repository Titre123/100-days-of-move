module blockchain::resource_account {
    use aptos_framework::account;
    use std::debug::print;
    #[test_only]
    use std::signer;

    const SEED: vector<u8> = b"polish";

    // Initialize the Resource Account Manager for the creator
    public fun initialize_manager(signer: &signer): signer {
        let (resource_account, cap) = account::create_resource_account(signer, SEED);
        resource_account
    }

    // Test the creation of a resource account
    #[test(account = @0x1)]
    fun test_create_resource_account(account: &signer) {
        let account = initialize_manager(account);
        print(&account);
        print(&signer::address_of(&account))
    }
}
