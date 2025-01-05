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
  - `move_from<T>`: Moves (and thus removes) a resource from an account’s storage, 
    allowing you to transfer it elsewhere (to another account).
  -------------------------------------------------------------------------------------
*/

module blockchain::resources_and_storage {
    use std::debug;
    use std::signer;
    use std::string::{self, utf8};

    // ---------------------------------------------------------------------------------
    // Define a `Book` as a resource with `has key, store`:
    //   - `key`:   Required to publish this resource in an account’s storage.
    //   - `store`: Allows storing the struct in variables or passing it around in functions.
    //
    // Note that it does NOT have `copy` or `drop`, so it behaves like a true resource:
    // you cannot duplicate (`copy`) or discard (`drop`) it without explicit logic.
    // ---------------------------------------------------------------------------------
    struct Book has key, store {
        title: string::String,
        author: string::String
    }

    // ---------------------------------------------------------------------------------
    // PUBLISH A BOOK
    //
    // Creates a new `Book` resource and publishes (stores) it under the sender’s account.
    //
    // - `account`:  The signer reference for the account that will own the Book.
    // - `title`:    Title of the book as a Move `String`.
    // - `author_name`: The author’s name as a Move `String`.
    //
    // `move_to<Book>(account, new_book)` places the resource in on-chain storage at 
    // the address represented by `account`.
    // ---------------------------------------------------------------------------------
    public entry fun publish_book(account: &signer, title: string::String, author_name: string::String) {
        let new_book = Book {
            title,
            author: author_name
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
    public fun borrow_book(addr: &address) acquires Book: &Book {
        borrow_global<Book>(addr)
    }

    // ---------------------------------------------------------------------------------
    // BORROW BOOK (MUTABLE)
    //
    // Returns a mutable reference to the `Book` resource at `addr`, allowing you to modify 
    // its fields without transferring ownership.
    // ---------------------------------------------------------------------------------
    public fun borrow_book_mut(addr: &address) acquires Book: &mut Book {
        borrow_global_mut<Book>(addr)
    }

    // ---------------------------------------------------------------------------------
    // DEBUG BOOK
    //
    // A helper function to print the `title` and `author` fields of a `Book` at a given 
    // address. This is read-only, so we just borrow a reference using `borrow_global`.
    // ---------------------------------------------------------------------------------
    public fun debug_book(addr: &address) {
        let book_ref = borrow_global<Book>(addr);
        debug::print(&book_ref.title);
        debug::print(&book_ref.author);
    }
}
