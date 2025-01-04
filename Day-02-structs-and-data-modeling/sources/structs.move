/* 
  -------------------------------------------------------------------------------------
  Move's type system shines when it comes to defining custom types. User-defined types 
  can be custom-tailored to the specific needs of the application, both in the data 
  level and in its behavior.

  In this section, we introduce the struct definition and how to use it:
  
  - To define a custom type, use the `struct` keyword followed by the name of the type.
  - After the name, define the fields of the struct using `field_name: field_type`.
  - Fields can be of any type, including other structs (but recursive structs are not allowed).

  Below is an example of a simple Book struct that has two fields: a `title` and an 
  `author`. We also show how to create and manipulate these `Book` instances.
  -------------------------------------------------------------------------------------
*/

module blockchain::structs {
    // We import Move's debug module to print debug messages.
    use std::debug;
    // We import the string module and its `utf8` function to handle strings.
    use std::string;
    use std::string::{utf8};

    // ---------------------------------------------------------------------------------
    // Define a `Book` struct with two fields:
    //   1. `title`:  The book's title, which is a Move `String`.
    //   2. `author`: The author's name, also a Move `String`.
    //
    // The `has copy, drop, store` attributes tell Move:
    //   - `copy`:  Instances of this struct can be copied (useful for local variables).
    //   - `drop`:  Instances can be popped (or dropped) from the stack.
    //   - `store`: Instances can be published as resources if needed (though not used here).

    // We will discuss this further later during capabilities
    // ---------------------------------------------------------------------------------
    struct Book has copy, drop, store {
        title: string::String,
        author: string::String
    }

    // ---------------------------------------------------------------------------------
    // This function creates a new `Book` instance.
    // Parameters:
    //   - `title`:        The title of the book as a Move `String`.
    //   - `author_name`:  The name of the author as a Move `String`.
    //
    // It returns a freshly constructed `Book` struct with the given `title` and `author`.
    // ---------------------------------------------------------------------------------
    public fun new_book(title: string::String, author_name: string::String): Book {
        Book {
            title,
            author: author_name
        }
    }

    // ---------------------------------------------------------------------------------
    // This test entry function demonstrates how to create and print `Book` structs.
    //
    // Steps:
    //   1. We call `new_book()` twice to create two `Book` instances, `book1` and `book2`.
    //   2. We use the `debug::print()` function to log their contents for debugging.
    //
    // Note: `#[test]` indicates this function is for testing, and `public entry` means 
    // it can be invoked when running tests with the Move CLI.
    // ---------------------------------------------------------------------------------
    #[test]
    public entry fun test_struct_of_structs() {
        let book1 = new_book(utf8(b"Move Programming"), utf8(b"Alice"));
        let book2 = new_book(utf8(b"Blockchain Fundamentals"), utf8(b"Bob"));

        // `debug::print()` logs the struct to the console during testing.
        // It will display something like: Book { title: "Move Programming", author: "Alice" }.
        debug::print(&book1);
        debug::print(&book2);
    }

    // ---------------------------------------------------------------------------------
    // This test entry function shows how to access individual properties of the `Book` struct.
    //
    // Steps:
    //   1. Create two `Book` instances again for demonstration.
    //   2. Print out just the `title` and `author` fields of `book1` using `utf8()`
    //      to convert the Move `String` to a more readable ASCII/UTF-8 format for debugging.
    // ---------------------------------------------------------------------------------
    #[test]
    public entry fun test_props_of_struct() {
        let book1 = new_book(utf8(b"Move Programming"), utf8(b"Alice"));
        let book2 = new_book(utf8(b"Blockchain Fundamentals"), utf8(b"Bob"));

        // Here we specifically print the `title` and `author` fields of `book1`.
        // Note how we can access fields with the dot operator: `book1.title` or `book1.author`.
        debug::print(&book1.title);
        debug::print(&book1.author);

         // Here we specifically print the `title` and `author` fields of `book1`.
        // Note how we can access fields with the dot operator: `book2.title` or `book2.author`.
        debug::print(&book2.title);
        debug::print(&book2.author);
    }
}
