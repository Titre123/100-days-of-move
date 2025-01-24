# Events in Move: Code-Specific Guide

## Event Structure
```move
#[event]
struct ValueAddedEvent has drop, store {
    value: u64,
    executor: address
}
```
- Marked with `#[event]` macro
- Uses `drop` and `store` abilities
- Captures two key pieces of information:
  1. `value`: The numeric value changed
  2. `executor`: Address of the account performing the action

## Event Handle in Global Resource
```move
struct GlobalData has key {
    value: u64,
    event_handle: event::EventHandle<ValueAddedEvent>
}
```
- Stores both the value and an event handle
- `event::EventHandle` allows tracking multiple events

## Event Creation and Emission
```move
public entry fun add_to_value_from_global_storage(signer: &signer, value: u64) acquires GlobalData {
    // Modify global data
    let global_data = borrow_global_mut<GlobalData>(addr);
    global_data.value = global_data.value + value;

    // Emit event
    event::emit_event(&mut global_data.event_handle, ValueAddedEvent {
        value,
        executor: addr
    });
}
```
- Modifies global storage value
- Uses `event::emit_event()` to create an event
- Passes event handle and event struct

## Key Methods
- `new_global()`: Initializes resource with event handle
- `add_to_value_from_global_storage()`: Updates value and emits event
- `check_global_storage_exists()`: Verifies resource presence
- `get_value_from_global_storage()`: Retrieves stored value

## Initiaztion and Deployment

### Step 1: Initialize Aptos Project

```bash
# Create a new directory for your project
mkdir events
cd events

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