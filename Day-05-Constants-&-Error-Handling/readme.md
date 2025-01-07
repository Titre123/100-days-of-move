# Movement Constants and Error Handling Guide

## Introduction
This guide explains a Move module that implements best practices for constant management and error handling on the Movement blockchain. The module serves as a template for handling common scenarios like balance checks, authorization, and input validation.

## Core Components Explained

### 1. Module Structure
```move
module Movement::ConstantsAndErrorHandling {
    use std::signer;
    // ... constants and functions
}
```
The module is named `ConstantsAndErrorHandling` under the `Movement` address space. It imports the `signer` module for authentication purposes.

### 2. Error Constants
```move
const EInsufficientFunds: u64 = 1001;
const EUnauthorizedAccess: u64 = 1002;
const EInvalidInput: u64 = 1003;
```
- Error codes follow the `E` prefix convention
- Each code represents a specific error condition
- Values start from 1001 to avoid conflicts with system errors
- These are used with `abort` and `assert!` statements

### 3. Business Constants
```move
const MAX_SUPPLY: u64 = 1000000;
const MIN_BALANCE: u64 = 100;
const OWNER: address = @blockchain;
```
- `MAX_SUPPLY`: Defines the maximum token supply
- `MIN_BALANCE`: Sets minimum required balance
- `OWNER`: Stores the contract owner's address (set to @blockchain)

### 4. Utility Functions

#### Balance Checking
```move
inline fun check_balance(balance: u64) {
    if (balance < MIN_BALANCE) {
        abort EInsufficientFunds
    }
}
```
- Validates if a balance meets minimum requirements
- Uses `inline` for gas optimization
- Aborts with `EInsufficientFunds` if balance is too low

#### Authorization
```move
inline fun authorize_action(address: address) {
    assert!(OWNER == address, EUnauthorizedAccess);
}
```
- Verifies if the caller is the contract owner
- Uses `assert!` for condition checking
- Aborts with `EUnauthorizedAccess` if unauthorized

#### Input Validation
```move
fun validate_input(input: u64) {
    assert!(input > 0, EInvalidInput);
}
```
- Ensures input values are valid (greater than zero)
- Uses `assert!` for validation
- Aborts with `EInvalidInput` for invalid inputs

### 5. Testing Framework

The module includes comprehensive tests:

```move
#[test]
#[expected_failure(abort_code = EInsufficientFunds)]
fun test_check_balance_insufficient() {
    check_balance(89)
}
```
- Tests both success and failure cases
- Uses `#[expected_failure]` for negative test cases
- Verifies correct error codes are thrown

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
Movement = "{YOUR_ADDRESS}"
blockchain = "0x1"

[dependencies]
AptosFramework = { git = "https://github.com/aptos-labs/aptos-core.git", subdir = "aptos-move/framework/aptos-framework/", rev = "mainnet" }
```

### Step 4: Create Module Structure

1. Create a `sources` directory:
```bash
mkdir sources
```

2. Create `constants_and_error_handling.move` in the `sources` directory and paste the formatted code from above.

### Step 5: Compile and Test

```bash
# Compile the module
aptos move compile

# Run tests
aptos move test
```

Expected test output:
```
Running Move unit tests
[ PASS    ] blockchain::ConstantsAndErrorHandling::test_authorize_action_unauthorized
[ PASS    ] blockchain::ConstantsAndErrorHandling::test_authorize_pass_action_unauthorized
[ PASS    ] blockchain::ConstantsAndErrorHandling::test_check_balance_insufficient
[ PASS    ] blockchain::ConstantsAndErrorHandling::test_pass_balance_insufficient
[ PASS    ] blockchain::ConstantsAndErrorHandling::test_validate_input_invalid
[ PASS    ] blockchain::ConstantsAndErrorHandling::test_validate_input_valid
Test result: OK. Total tests: 6; passed: 6; failed: 0
{
  "Result": "Success"
}

```

### Step 6: Publish to Testnet

```bash
aptos move publish
```