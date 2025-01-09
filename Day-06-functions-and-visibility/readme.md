# Move Functions and Visibility Guide

## Introduction

This guide explores function types and visibility modifiers in Move, using examples from a real-world implementation. Understanding these concepts is crucial for writing secure and efficient smart contracts on the blockchain.

## Function Types

### 1. Regular Functions (`fun`)

Regular functions can be either public or private. Private functions are only accessible within the module.

```move
fun private_calculation(x: u64, y: u64): u64 {
    let value = x + y;
    print(&value);
    value
}
```

In this example, `private_calculation` is a private function that:
- Takes two u64 parameters
- Performs addition
- Prints the result
- Returns the computed value

### 2. Inline Functions (`inline fun`)

Inline functions suggest to the compiler that the function should be inlined at the call site for performance optimization.

```move
inline fun inline_increment(value: u64): u64 {
    value + 1
}
```

This simple inline function:
- Takes a u64 value
- Increments it by 1
- Returns the incremented value
- Is optimized during compilation by being inlined where it's called

### 3. Public Functions (`public fun`)

Public functions can be called by other modules and scripts.

```move
public fun public_compute(a: u64, b: u64): u64 {
    let sum = private_calculation(a, b);      // Calls the private calculation function
    let incremented = inline_increment(sum);  // Calls the inline increment function
    print(&sum);                              // Prints the sum
    print(&incremented);                      // Prints the incremented value
    incremented                               // Returns the incremented value
}
```

This public function demonstrates:
- Interaction with private functions
- Use of inline functions
- Debug printing
- Implicit return syntax

### 4. Entry Functions (`public entry fun`)

Entry functions can be called directly as transactions.

```move
public entry fun execute_transfer(
    sender: &signer,
    recipient: address,
    amount: u64
) acquires BalanceStore {
    let sender_address = signer::address_of(sender);
    let sender_balance = get_balance(sender_address);

    if (sender_balance < amount) {
        abort EInsufficientFunds
    };

    sub_balance(sender_address, amount);
    add_balance(recipient, amount);
}
```

This entry function shows:
- Transaction entry point definition
- Signer parameter usage
- Resource acquisition
- Error handling
- Complex operation composition

### 5. View Functions (`#[view]`)

View functions are read-only operations that don't modify state.

```move
#[view]
public fun get_balance(account: address): u64 acquires BalanceStore {
    borrow_global<BalanceStore>(account).balance
}
```

This view function demonstrates:
- Read-only state access
- Resource borrowing
- Public visibility
- View attribute usage

## Helper Functions

Helper functions are private functions that support the module's internal operations.

```move
fun add_balance(account: address, amount: u64) acquires BalanceStore {
    let balance_store = borrow_global_mut<BalanceStore>(account);
    balance_store.balance = balance_store.balance + amount;
}

fun sub_balance(account: address, amount: u64) acquires BalanceStore {
    let balance_store = borrow_global_mut<BalanceStore>(account);
    balance_store.balance = balance_store.balance - amount;
}
```

These helper functions show:
- Private visibility
- Resource modification
- State management
- Common operation patterns

## Testing Functions

Test functions verify the behavior of module functions.

```move
#[test]
fun test_calculate() {
    private_calculation(23, 27);
}

#[test]
fun test_public_compute() {
    public_compute(30, 70);
}
```

These test functions demonstrate:
- Test attribute usage
- Function testing methodology
- Direct function invocation
- Verification patterns

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
[debug] 50
[ PASS    ] 0xa8102a53d98b7f2affa45926e4b2dde5464994d88de8b019c3150aadec92d7b1::FunctionAndVisibility::test_calculate
[debug] 100
[debug] 100
[debug] 101
[ PASS    ] 0xa8102a53d98b7f2affa45926e4b2dde5464994d88de8b019c3150aadec92d7b1::FunctionAndVisibility::test_public_compute
Test result: OK. Total tests: 2; passed: 2; failed: 0
{
  "Result": "Success"
}
```

### Step 6: Publish to Testnet

```bash
movement move publish
```