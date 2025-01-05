/* 
  -------------------------------------------------------------------------------------
  Move's type system shines when it comes to defining custom types. User-defined types 
  can be custom-tailored to the specific needs of the application, both in the data 
  level and in its behavior.

  This example shows how to create a `Book` resource (struct with `key`), publish it 
  to an account, read or modify it via references, and transfer ownership to another 
  account. 

  Key points:
  - `has key`: Allows this struct to be published in global storage under an account.
  - `move_to<T>`: Publishes a resource to an account's on-chain storage.
  - `borrow_global<T>` and `borrow_global_mut<T>`: Grants a reference or mutable reference 
    to a resource stored in an account.
  - `move_from<T>`: Moves (and thus removes) a resource from an account storage, 
    allowing you to transfer it elsewhere (to another account).
  -------------------------------------------------------------------------------------
*/

module blockchain::resources_and_storage {
    use std::debug;
    use std::signer;
    use std::string;

    // ---------------------------------------------------------------------------------
    // Define a `Book` as a resource with `has key, store`:
    //   - `key`:   Required to publish this resource in an account storage.
    //   - `store`: Allows storing the struct in variables or passing it around in functions.
    //
    // Note that it does NOT have `copy` or `drop`, so it behaves like a true resource:
    // you cannot duplicate (`copy`) or discard (`drop`) it without explicit logic.
    // ---------------------------------------------------------------------------------
    struct Book has key, store, copy, drop {
        title: string::String,
        author: string::String
    }

    // ---------------------------------------------------------------------------------
    //
    // Creates a new `Book` resource and publishes (stores) it under the sender account.
    //
    // - `account`:  The signer reference for the account that will own the Book.
    // - `title`:    Title of the book as a Move `String`.
    // - `author_name`: The author name as a Move `String`.
    //
    // `move_to<Book>(account, new_book)` places the resource in on-chain storage at 
    // the address represented by `account`.
    // ---------------------------------------------------------------------------------
    fun init_module(account: &signer) {
        let new_book = Book {
            title: string::utf8(b"In an harrowed place"),  // Convert byte string to String type
            author: string::utf8(b"James Spader")  // Initialize with empty string
        };
        move_to<Book>(account, new_book);
    }

    // ---------------------------------------------------------------------------------
    // BORROW BOOK (READ-ONLY)
    //
    // Returns an immutable reference to the `Book` resource stored at `addr`.
    // If `addr` does not store a `Book`, this will abort at runtime.
    //
    // `acquires Book` tells Move that this function will read (borrow) the
    // `Book` resource from global storage.
    // ---------------------------------------------------------------------------------
    public fun borrow_book(addr: &address): Book acquires Book {
        let book = borrow_global<Book>(*addr);
        *book
    }

    // ---------------------------------------------------------------------------------
    // BORROW BOOK (MUTABLE)
    //
    // Returns a mutable reference to the `Book` resource at `addr`, allowing you to modify 
    // its fields without transferring ownership.
    // ---------------------------------------------------------------------------------
    public fun borrow_book_mut(addr: &address): Book acquires Book {
        let book = borrow_global_mut<Book>(*addr);
        *book
    }

}
