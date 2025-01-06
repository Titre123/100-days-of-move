module blockchain::resources {
  use std::string;

    /* Resource with only the `drop` ability.
    
    **Capabilities:**
    - Can be dropped (i.e., ignored or destroyed).
    - Cannot be copied.
    - Cannot be stored in global storage.
    - Cannot be used as a key for global storage operations. 
    */

    struct DroppableBook has drop {
      author: string::String,
      title: string::String,
    }

    /* 
    Resource with `copy` and `drop` abilities.
    **Capabilities:**
    - Can be copied using the `copy` operator or by dereferencing.
    - Can be dropped (i.e., ignored or destroyed).
    - Cannot be stored in global storage.
    - Cannot be used as a key for global storage operations.
    - THis resource has a bool value to know if a user has read a book
    */
    struct CopyableDroppableReadBook has copy, drop {
      value: bool,
    }

    /* Resource with `drop` and `store` abilities.
     **Capabilities:**
     - Can be dropped (i.e., ignored or destroyed).
     - Can be stored inside global storage structs.
     - Cannot be copied.
     - Cannot be used as a key for global storage operations.

     - Basically, you can use this struct inside another struct with the key ability
     */
    struct StorableResource has drop, store {
        balance: u128,
    }

    /* Resource with `copy`, `drop`, and `store` abilities.
     
     **Capabilities:**
     - Can be copied using the `copy` operator or by dereferencing.
     - Can be dropped (i.e., ignored or destroyed).
     - Can be stored inside global storage structs.
     - Cannot be used as a key for global storage operations.
     */
    struct FullyStorableResource has copy, drop, store {
        name: vector<u8>,
        score: u64,
    }

    /* Resource with the `key` ability.
     
     **Capabilities:**
     - Can be used as a key for global storage operations (e.g., `move_to`, `borrow_global`) which we talked about
      in our previous module
     - Must satisfy the `store` ability implicitly for all contained fields.
     - Cannot be copied.
     */
    struct KeyResource has key {
        identifier: address,
        metadata: StorableResource, // Must have `store` ability
    }

  /*
      This resource leverages the defined abilities to provide comprehensive functionality:
      
      - **Store:** The resource can be stored in global storage, allowing it to persist across transactions.
      - **Drop:** The resource can be safely dropped when it is no longer needed, ensuring proper resource management.
      - **Copy:** The resource can be copied and duplicated as required, facilitating flexible usage patterns.
      - **Dereference:** The resource can be dereferenced, enabling access to its underlying data.
      - **Nested Storage:** The resource can be stored within another struct, promoting modular and reusable code design.
      
      Additionally, a resource can possess all four abilities (`copy`, `drop`, `store`, and `key`), granting it full versatility in various operations and storage scenarios.
  */


    /* Generic resource that conditionally has abilities based on its type parameter.
     
     **Capabilities:**
     - Has `copy` only if `T` has `copy`.
     - Has `drop` only if `T` has `drop`.
     - Has `store` only if `T` has `store`.
     - Has `key` only if `T` has `store`.
     */
    struct GenericResource<T> has copy, drop, store, key {
        item: T,
    }
}
