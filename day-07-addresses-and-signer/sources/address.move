module blockchain::AddressAndSigner {
    use std::signer;
    use std::debug;

    /* 
    ============================================================================
    Module: AddressAndSigner
    ============================================================================
    
    This module provides functionalities to interact with blockchain addresses and 
    signers within the Move language environment. It allows for the creation and 
    borrowing of resources associated with specific addresses and signers.
    
    Key Components:
    - Constant Addresses: Predefined addresses used for demonstration and testing.
    - Resource Definitions: Structures stored in global storage, managed via addresses.
    - Functions: Operations to create and borrow resources, along with testing utilities.
    */

    /* 
    ============================================================================
    Constants
    ============================================================================
    
    MY_CONSTANT_ADDRESS: 
    A constant address used for demonstration purposes.
    Note: In production environments, addresses should be managed securely 
    and not hard-coded.
    */
    const MY_CONSTANT_ADDRESS: address = @blockchain;

    /* 
    ============================================================================
    Resource Definitions
    ============================================================================
    
    MyResource: 
    A resource structure that holds a single `u64` data field.
    The `has key` attribute indicates that this resource can be stored in global storage 
    and accessed via an address.
    */
    struct MyResource has key {
        data: u64,
    }

    /* 
    ============================================================================
    Function: create_resource
    ============================================================================
    
    Description:
    Creates a new instance of `MyResource` with the provided `new_data` and moves it 
    to the account associated with the given signer.
    
    Parameters:
    - `account`: A reference to the signer who will own the newly created resource.
    - `new_data`: The data to be stored within the resource.
    
    Usage:
    This function is used to initialize and store resources under a specific signer's account.
    */
    public fun create_resource(account: &signer, new_data: u64) {
        /* 
        Move the newly created `MyResource` instance to the signer's account. 
        The `move_to` function handles the storage of the resource in global storage.
        */
        move_to(account, MyResource {
            data: new_data
        });
    }

    /* 
    ============================================================================
    Function: borrow_resource
    ============================================================================
    
    Description:
    Borrows a reference to a `MyResource` stored at the specified address.
    
    Parameters:
    - `addr`: The address from which to borrow the resource.
    
    Returns:
    - A reference to the borrowed `MyResource`.
    
    Preconditions:
    - The specified address must have a `MyResource` stored in global storage.
    
    Usage:
    This function allows other modules or functions to access resources associated with a specific address without taking ownership.
    */
    public fun borrow_resource(addr: address): MyResource  acquires MyResource {
        *borrow_global<MyResource>(addr)
    }

    /* 
    ============================================================================
    Function: test_address_and_signer
    ============================================================================
    
    Description:
    A test function designed to verify the correct behavior of address and signer interactions.
    It demonstrates the use of the constant address and ensures that resources can be 
    created and accessed as expected.
    
    Parameters:
    - `account`: A reference to the signer account used in testing.
    
    Test Steps:
    1. Prints the constant address `MY_CONSTANT_ADDRESS` to verify its value.
    */
    #[test]
    fun test_address_and_signer(account: &signer) {
        /* 
        Print the constant address to the debug output. This helps in verifying that the 
        address is correctly defined and accessible within the test context.
        */
        debug::print(&MY_CONSTANT_ADDRESS);
    }
}
