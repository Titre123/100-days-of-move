# Move Programming: Resources and Global Storage Guide

## Table of Contents
1. [Introduction](#introduction)
2. [Resource Fundamentals](#resource-fundamentals)
3. [Global Storage Operations](#global-storage-operations)
4. [Implementation Examples](#implementation-examples)
5. [Testing Resources in Storage](#testing-resources-in-storage)
6. [Complete Module](#complete-module)

## Introduction

Move programming provides a robust system for managing on-chain assets through resources and global storage. This guide explains how resources work, how they are stored globally, and how Move's type system ensures safe asset management.

### Key Concepts

1. **Resources**: Special data types that cannot be copied or dropped implicitly
2. **Global Storage**: The blockchain's persistent storage system
3. **Storage Operations**: Commands to interact with resources in global storage
4. **Linear Type System**: Ensures safe asset handling and prevents double-spending

## Resource Fundamentals

Resources in Move are structs with specific storage abilities:

```move
// Regular struct (local storage only)
struct RegularBook has copy, drop, store {
    title: string::String,
    author: string::String
}

// Resource struct (global storage capable)
struct Book has key, store {
    title: string::String,
    author: string::String
}
```

## Global Storage Operations

### 1. Publishing to Storage (move_to)
```move
public entry fun publish_book(
    account: &signer, 
    title: string::String, 
    author_name: string::String
) {
    let book = new_book(title, author_name);
    move_to<Book>(account, book);  // Stores in global storage
}
```

### 2. Reading from Storage (borrow_global)
```move
public fun borrow_book(addr: &address) acquires Book: &Book {
    borrow_global<Book>(addr)  // Read-only access
}

public fun borrow_book_mut(addr: &address) acquires Book: &mut Book {
    borrow_global_mut<Book>(addr)  // Mutable access
}
```

### 3. Moving from Storage (move_from)
```move
public entry fun transfer_book(sender: &signer, recipient: address) acquires Book {
    let book = move_from<Book>(signer::address_of(sender));  // Remove from sender
    move_to<Book>(&recipient, book);  // Store in recipient's account
}
```

## Implementation Examples

Here's a complete resource implementation with storage operations:

```move
module blockchain::resources_and_storage {
    use std::debug;
    use std::signer;
    use std::string::{self, utf8};

    struct Book has key, store {
        title: string::String,
        author: string::String
    }

    public fun new_book(title: string::String, author_name: string::String): Book {
        Book { 
            title, 
            author: author_name 
        }
    }

    // Storage Operations
    public entry fun publish_book(account: &signer, title: string::String, author_name: string::String) {
        let book = new_book(title, author_name);
        move_to<Book>(account, book);
    }

    public fun borrow_book(addr: &address) acquires Book: &Book {
        borrow_global<Book>(addr)
    }

    public fun borrow_book_mut(addr: &address) acquires Book: &mut Book {
        borrow_global_mut<Book>(addr)
    }

    public entry fun transfer_book(sender: &signer, recipient: address) acquires Book {
        let book = move_from<Book>(signer::address_of(sender));
        move_to<Book>(&recipient, book);
    }
}
```

## Testing Resources in Storage

```move
#[test]
public entry fun test_storage_operations(sender: &signer, receiver: address) acquires Book {
    // Test publishing
    publish_book(sender, utf8(b"Move Resources"), utf8(b"Test Author"));
    
    // Test reading from storage
    let book_ref = borrow_book(&signer::address_of(sender));
    debug::print(book_ref);
    
    // Test transferring between accounts
    transfer_book(sender, receiver);
    let transferred_book = borrow_book(&receiver);
    debug::print(transferred_book);
}
```

Expected test output:
```terminal
Running Move unit tests
[ PASS    ] 0x1::resources_and_storage::test_storage_operations
[debug] (&) { title: "Move Resources", author: "Test Author" }
[debug] (&) { title: "Move Resources", author: "Test Author" }
Test result: OK. Total tests: 1; passed: 1; failed: 0
```


This guide provides a foundation for working with resources and global storage in Move. Remember to always handle resources safely and follow proper storage operation patterns to ensure secure and efficient blockchain applications.
