# Move Language: Understanding Vectors and Strings

## Vectors
### Overview
In Move, a Vector is a homogeneous, dynamically-sized sequence of elements. It serves as the primary collection type for storing multiple values of the same type.

### Key Characteristics
1. **Generic Type**: Can hold any type T (written as `vector<T>`)
2. **Dynamic Sizing**: Can grow or shrink as needed
3. **Zero-based Indexing**: Elements are accessed using 0-based indices
4. **Type Safety**: All elements must be of the same type

### Basic Operations

#### 1. Creating and Adding Elements
```move
public fun add_last_vec(number: u64): vector<u64> {
    let list = vector::empty<u64>();
    vector::push_back(&mut list, number);
    return list
}
```

#### 2. Accessing Elements by Index
```move
public fun get_value_by_index_vec(index: u64): u64 {
    let list = vector::empty<u64>();
    vector::push_back(&mut list, 10);
    vector::push_back(&mut list, 20);
    vector::push_back(&mut list, 30);
    return *vector::borrow(&list, index)
}
```

#### 3. Removing Elements
```move
public fun take_last_value_in_vec(): (vector<u64>, u64) {
    let list = vector::empty<u64>();
    vector::push_back(&mut list, 10);
    vector::push_back(&mut list, 20);
    vector::push_back(&mut list, 30);
    let take_value: u64 = vector::pop_back(&mut list);
    return (list, take_value)
}
```

#### 4. Destroying Vectors
```move
public fun destroy_any_vector<T>(vec: vector<T>) {
    vector::destroy_empty(vec)
}
```

### Common Vector Operations Reference

| Operation | Description | Example Usage |
|-----------|-------------|---------------|
| `empty<T>()` | Creates an empty vector | `let list = vector::empty<u64>();` |
| `push_back()` | Adds element to end | `vector::push_back(&mut list, 10);` |
| `pop_back()` | Removes and returns last element | `let value = vector::pop_back(&mut list);` |
| `borrow()` | Gets immutable reference | `let elem = vector::borrow(&list, 0);` |
| `destroy_empty()` | Destroys empty vector | `vector::destroy_empty(vec);` |
| `contains()` | Checks for element | `vector::contains(&list, &element)` |
| `swap()` | Swaps two elements | `vector::swap(&mut list, i, j);` |
| `reverse()` | Reverses vector in place | `vector::reverse(&mut list);` |

## Strings
### Overview
In Move, strings are represented as sequences of UTF-8 encoded bytes. They can be created either from byte vectors (`vector<u8>`) or directly from byte literals.

### Key Characteristics
1. **UTF-8 Encoding**: Stores text as UTF-8 encoded bytes
2. **Immutable**: Once created, string contents cannot be modified
3. **Vector Backing**: Internally implemented using `vector<u8>`
4. **Conversion Support**: Can convert between byte vectors and strings

### String Operations

#### 1. Creating Strings
```move
fun vec_string() {
    // From byte literal
    let vec_string: vector<u8> = b"Hello by vector u8";
    
    // Direct string creation
    let by_string: String = utf8(b"Hello by String");
    
    // From byte vector
    let by_vec: String = utf8(vec_string);
}
```

### Best Practices


## Common Patterns

### Vector Initialization Pattern
```move
let list = vector::empty<u64>();
vector::push_back(&mut list, 10);
vector::push_back(&mut list, 20);
vector::push_back(&mut list, 30);
```

### String Conversion Pattern
```move
// Convert byte vector to string
let vec_bytes: vector<u8> = b"Hello World";
let string_value: String = utf8(vec_bytes);
```


## Testing
Example of vector testing:
```move
#[test]
fun test_add_last_vec() {
    let vec = add_last_vec(500);
    print(&vec);
}

#[test]
fun test_get_value_by_index_vec() {
    let value = get_value_by_index_vec(1);
    print(&value);
}
```

## Initiaztion and Deployment

### Step 1: Initialize Aptos Project

```bash
# Create a new directory for your project
mkdir constants-module
cd constants-module

# Initialize new Aptos project
aptos init

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
[debug] [ 500 ]
[ PASS    ] blockchain::VectorAndString::test_add_last_vec
[debug] [ 10 ]
[ PASS    ] blockchain::VectorAndString::test_clone_vector
[debug] 20
[ PASS    ] blockchain::VectorAndString::test_get_value_by_index_vec
[debug] [ 10, 20 ]
[debug] 30
[ PASS    ] blockchain::VectorAndString::test_take_last_value_in_vec
[debug] 0x48656c6c6f20627920766563746f72207538
[debug] "Hello by String"
[debug] "Hello by vector u8"
[ PASS    ] blockchain::VectorAndString::test_vec_string
Test result: OK. Total tests: 5; passed: 5; failed: 0
{
  "Result": "Success"
}
```

### Step 6: Publish to Testnet

```bash
movement move publish
```

## Summary
Understanding Vectors and Strings is fundamental to Move programming as they provide:
- Dynamic collection capabilities
- Text handling and manipulation
- Resource management patterns
- Type-safe operations

Always consider performance implications and proper resource management when working with these types in your Move programs.