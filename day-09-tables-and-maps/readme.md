# Move Language: Understanding Tables and Maps

## Overview
Move provides two primary key-value storage structures: `Table` and `SimpleMap`. While both store key-value pairs, they have different use cases and characteristics.

## Table
### Overview
`Table` is a key-value data structure optimized for on-chain storage. It provides efficient storage and retrieval of values using unique keys.

### Key Characteristics
1. **Storage Efficient**: Optimized for blockchain storage
2. **Generic Types**: Supports any types for keys and values
3. **Dynamic Size**: Can grow and shrink as needed
4. **Direct Access**: Provides O(1) access to elements

### Basic Operations

#### 1. Creating a Table
```move
public fun create_table(): Table<u64, u64> {
    let new_tab: Table<u64, u64> = table::new();
    new_tab
}
```

#### 2. Adding Values
```move
public fun add_value_to_table(table: &mut Table<u64, u64>) {
    table::add(table, 1, 100);
    table::add(table, 2, 200);
}
```

#### 3. Removing Values
```move
public fun remove_value_from_table(table: &mut Table<u64, u64>, key: u64): u64 {
    table::remove(table, key)
}
```

#### 4. Borrowing Values
```move
public fun borrow_value_from_table(table: &Table<u64, u64>, key: u64): &u64 {
    table::borrow(table, key)
}
```

## SimpleMap
### Overview
`SimpleMap` is an in-memory key-value data structure that provides a more traditional map implementation.

### Key Characteristics
1. **In-Memory Storage**: Operates entirely in memory
2. **Flexible Usage**: Good for temporary data storage
3. **Vector-Based**: Implemented using vectors internally
4. **Ordered**: Maintains insertion order

### Basic Operations

#### 1. Creating a Map
```move
public fun create_map(): SimpleMap<address, u64> {
    let mp: SimpleMap<address, u64> = simple_map::create();
    simple_map::add(&mut mp, @blockchain, 10);
    mp
}
```

#### 2. Adding Multiple Values
```move
public fun add_values_to_map(
    map: &mut SimpleMap<address, u64>, 
    keys: vector<address>, 
    values: vector<u64>
) {
    simple_map::add_all(map, keys, values);
}
```

#### 3. Removing Values
```move
public fun remove_value_from_map(map: &mut SimpleMap<address, u64>, key: address) {
    simple_map::remove(map, &key);
}
```

#### 4. Borrowing Values
```move
public fun borrow_value_from_map(map: &SimpleMap<address, u64>, key: address): u64 {
    let borrowed = simple_map::borrow(map, &key);
    *borrowed
}
```

## Method Reference

### Table Methods
| Method | Description | Return Type |
|--------|-------------|-------------|
| `new<K, V>()` | Creates new table | `Table<K, V>` |
| `add<K, V>()` | Adds key-value pair | `()` |
| `remove<K, V>()` | Removes by key | `V` |
| `borrow<K, V>()` | Gets immutable reference | `&V` |
| `borrow_mut<K, V>()` | Gets mutable reference | `&mut V` |
| `contains<K, V>()` | Checks key existence | `bool` |
| `destroy<K, V>()` | Destroys table | `()` |

### SimpleMap Methods
| Method | Description | Return Type |
|--------|-------------|-------------|
| `create<K, V>()` | Creates new map | `SimpleMap<K, V>` |
| `add<K, V>()` | Adds key-value pair | `()` |
| `remove<K, V>()` | Removes by key | `V` |
| `contains_key<K, V>()` | Checks key existence | `bool` |
| `length<K, V>()` | Gets map size | `u64` |
| `destroy_empty<K, V>()` | Destroys empty map | `()` |

## Best Practices

### Table Best Practices
1. **Memory Management**
    - Use tables for long-term storage
    - Clean up unused entries
    - Consider storage costs

2. **Performance**
    - Use appropriate key types
    - Minimize storage operations
    - Handle non-existent keys

### SimpleMap Best Practices
1. **Usage Patterns**
    - Use for temporary storage
    - Consider memory limitations
    - Clear maps when no longer needed

2. **Error Handling**
    - Check key existence
    - Handle duplicate keys
    - Validate input data

## Common Patterns

### Table Usage Pattern
```move
// Create and populate table
let table = create_table();
add_value_to_table(&mut table);

// Access and modify
let value = borrow_value_from_table(&table, 1);
```

### SimpleMap Usage Pattern
```move
// Create and populate map
let map = create_map();
let keys = vector::empty<address>();
let values = vector::empty<u64>();
add_values_to_map(&mut map, keys, values);
```

## Testing
Example of testing map operations:
```move
#[test]
fun test_map_operations_demo() {
    let map = create_map();
    let key1 = @0x01;
    let key2 = @0x02;
    
    let keys = vector::empty<address>();
    let values = vector::empty<u64>();
    vector::push_back(&mut keys, key1);
    vector::push_back(&mut values, 1000);
    
    add_values_to_map(&mut map, keys, values);
    let borrowed_value = borrow_value_from_map(&map, key2);
}
```

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
name = "constants_module"
version = "1.0.0"
authors = ["Your Name"]

[addresses]
Movement = **"{YOUR_ADDRESS}"**
blockchain = "0x1"

[dependencies]
AptosFramework = { git = "https://github.com/aptos-labs/aptos-core.git", subdir = "aptos-move/framework/aptos-framework/", rev = "mainnet" }
```


### Step 4: Compile and Test

```bash
# Compile the module
movement move compile

# Run tests
movement move test
```bash
Running Move unit tests
[debug] 0x1::simple_map::SimpleMap<address, u64> {
  data: [
    0x1::simple_map::Element<address, u64> {
      key: @blockchain,
      value: 10
    }
  ]
}
[debug] 0x1::simple_map::SimpleMap<address, u64> {
  data: [
    0x1::simple_map::Element<address, u64> {
      key: @blockchain,
      value: 10
    },
    0x1::simple_map::Element<address, u64> {
      key: @0x1,
      value: 1000
    },
    0x1::simple_map::Element<address, u64> {
      key: @0x2,
      value: 2000
    }
  ]
}
[debug] 0x1::simple_map::SimpleMap<address, u64> {
  data: [
    0x1::simple_map::Element<address, u64> {
      key: @blockchain,
      value: 10
    },
    0x1::simple_map::Element<address, u64> {
      key: @0x1,
      value: 1000
    },
    0x1::simple_map::Element<address, u64> {
      key: @0x2,
      value: 2000
    }
  ]
}
[debug] 2000
[ PASS    ] blockchain::table_and_map_demo::test_map_operations_demo
Test result: OK. Total tests: 1; passed: 1; failed: 0
{
  "Result": "Success"
}

```

### Step 6: Publish to Testnet

```bash
movement move publish
```

## Summary
Understanding when to use Tables vs SimpleMaps is crucial for efficient Move programming:
- Use Tables for persistent storage
- Use SimpleMaps for temporary, in-memory storage
- Consider performance implications
- Handle resources properly
- Implement appropriate error handling

Always consider the specific requirements of your application when choosing between these data structures.