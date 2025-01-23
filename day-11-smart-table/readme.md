# Smart Table Module Documentation

## Overview

Smart Tables represent an advanced data management solution in the Move programming language, specifically designed for blockchain environments like Aptos and Movement Network. This innovative data structure addresses critical challenges in decentralized application development by providing an optimized, gas-efficient method for storing and manipulating key-value data.
At its core, a Smart Table is a dynamic hash table implemented with a unique bucket-based architecture that enables more efficient data access, reduced computational costs, and improved scalability compared to traditional data structures.

## Code Implementation

```
module blockchain::smart_table {
    use aptos_std::smart_table::{Self, SmartTable};
    use std::debug::print;
    use std::signer::address_of;

    // Resource to store the SmartTable
    struct SmartTableResource has key {
        value: SmartTable<address, u64>
    }

    // Module initialization
    fun init_module(caller: &signer) {
        let val = smart_table::new<address, u64>();
        smart_table::add(&mut val, address_of(caller), 0);
        move_to(caller, SmartTableResource {
            value: val
        });
    }

    // View function to get user points
    #[view]
    public fun get_amount_point(addr: address): u64 acquires SmartTableResource {
        let table = &borrow_global<SmartTableResource>(addr).value;
        *smart_table::borrow(table, addr)
    }

    // Function to add points for a user
    public fun plus_point(addr: address, value: u64) acquires SmartTableResource {
        let table = &mut borrow_global_mut<SmartTableResource>(addr).value;
        let point = *smart_table::borrow_mut(table, addr);
        let new_point = point + value;
        smart_table::upsert(table, addr, new_point);
    }
}
```

## Usage Example

## Key Smart Table Functions Used

- `smart_table::new()`: Create a new SmartTable
- `smart_table::add()`: Add initial entry
- `smart_table::borrow()`: Retrieve a value
- `smart_table::upsert()`: Update or insert a value


## Initiaztion and Deployment

### Step 1: Initialize Aptos Project

```bash
# Create a new directory for your project
mkdir tables-and-maps
cd constants-module

# Initialize new Aptos project
movement init

# Select "testnet" when prompted for network
# This will create a .aptos folder with your config
```

### Step 2: Generate and Configure Account

After running `aptos init`, you'll see output similar to:
```
No default profile found, creating new with random private key...
Enter your profile name [default]: 
Aptos CLI is now set up with an account with profile [default]! 
Account address: {YOUR_ADDRESS}
```

Copy your account address for the next step.

### Step 3: Configure Move.toml

Create or update `Move.toml` in your project root:
```toml
[package]
name = "Smart Table"
version = "1.0.0"
authors = ["Your Name"]

[addresses]
blockchain = "0x1"

[dependencies]
AptosFramework = { git = "https://github.com/aptos-labs/aptos-core.git", subdir = "aptos-move/framework/aptos-framework/", rev = "mainnet" }
```


### Step 4: Compile and Test

```bash
# Compile the module
movement move compile
```

# Run tests
movement move test
```bash
```

### Step 6: Publish to Testnet

```bash
movement move publish
```


# SmartTable Function Reference

## Table Creation and Configuration

| Function | Parameters | Description | Return Value |
|----------|------------|-------------|--------------|
| `new()` | None | Creates an empty SmartTable with default configurations | `SmartTable<K, V>` |
| `new_with_config()` | - `num_initial_buckets`: u64<br>- `split_load_threshold`: u8<br>- `target_bucket_size`: u64 | Creates an empty SmartTable with customized configurations | `SmartTable<K, V>` |

## Table Destruction and Management

| Function | Parameters | Description | Return Value |
|----------|------------|-------------|--------------|
| `destroy_empty()` | `self`: SmartTable<K, V> | Destroys an empty table | None |
| `destroy()` | `self`: SmartTable<K, V> | Destroys a table completely when V has drop | None |
| `clear()` | `self`: &mut SmartTable<K, V> | Clears a table completely when T has drop | None |

## Adding and Populating Entries

| Function | Parameters | Description | Return Value |
|----------|------------|-------------|--------------|
| `add()` | - `self`: &mut SmartTable<K, V><br>- `key`: K<br>- `value`: V | Adds a key-value pair to the table | None |
| `add_all()` | - `self`: &mut SmartTable<K, V><br>- `keys`: vector<K><br>- `values`: vector<V> | Adds multiple key-value pairs to the table | None |
| `upsert()` | - `self`: &mut SmartTable<K, V><br>- `key`: K<br>- `value`: V | Inserts a key-value pair or updates an existing one | None |

## Retrieving Entries

| Function | Parameters | Description | Return Value |
|----------|------------|-------------|--------------|
| `borrow()` | - `self`: &SmartTable<K, V><br>- `key`: K | Borrows an immutable reference to the value associated with the key | &V |
| `borrow_with_default()` | - `self`: &SmartTable<K, V><br>- `key`: K<br>- `default`: &V | Borrows an immutable reference to the value, or returns the default if key not found | &V |
| `borrow_mut()` | - `self`: &mut SmartTable<K, V><br>- `key`: K | Borrows a mutable reference to the value associated with the key | &mut V |
| `borrow_mut_with_default()` | - `self`: &mut SmartTable<K, V><br>- `key`: K<br>- `default`: V | Borrows a mutable reference to the value, or inserts and returns default if key not found | &mut V |

## Querying and Checking

| Function | Parameters | Description | Return Value |
|----------|------------|-------------|--------------|
| `contains()` | - `self`: &SmartTable<K, V><br>- `key`: K | Checks if the table contains a key | bool |
| `length()` | `self`: &SmartTable<K, V> | Returns the number of entries in the table | u64 |
| `load_factor()` | `self`: &SmartTable<K, V> | Returns the load factor of the hashtable | u64 |
| `keys()` | `self`: &SmartTable<K, V> | Gets all keys in a smart table | vector<K> |
| `keys_paginated()` | - `self`: &SmartTable<K, V><br>- `starting_bucket_index`: u64<br>- `starting_vector_index`: u64<br>- `num_keys_to_get`: u64 | Gets keys from a smart table, paginated | (vector<K>, Option<u64>, Option<u64>) |

## Removal and Manipulation

| Function | Parameters | Description | Return Value |
|----------|------------|-------------|--------------|
| `remove()` | - `self`: &mut SmartTable<K, V><br>- `key`: K | Removes and returns the value associated with the key | V |

## Advanced Operations

| Function | Parameters | Description | Return Value |
|----------|------------|-------------|--------------|
| `for_each_ref()` | - `self`: &SmartTable<K, V><br>- `f`: \|&K, &V\| | Applies a function to a reference of each key-value pair | None |
| `for_each_mut()` | - `self`: &mut SmartTable<K, V><br>- `f`: \|&K, &mut V\| | Applies a function to a mutable reference of each key-value pair | None |
| `map_ref()` | - `self`: &SmartTable<K, V1><br>- `f`: \|&V1\|V2 | Maps a function over the values, producing a new SmartTable | SmartTable<K, V2> |
| `any()` | - `self`: &SmartTable<K