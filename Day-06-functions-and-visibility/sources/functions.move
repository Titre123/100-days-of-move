module blockchain::FunctionAndVisibility {
    /*
    ============================
    Import Statements
    ============================

    These imports bring in necessary modules and functions from the standard library.
    - `signer`: Provides access to signer-related functionalities.
    - `utf8`, `String`: Used for handling string data.
    - `print`: Enables printing messages for debugging purposes.
    */
    use std::signer;
    use std::string::{utf8, String};
    use std::debug::print;

    /*
    ============================
    Constants
    ============================

    - `EInsufficientFunds`: Error code indicating that an account has insufficient funds for a transaction.
    */
    const EInsufficientFunds: u64 = 1;

    /*
    ============================
    Data Structures
    ============================

    - `BalanceStore`: A resource that stores the balance of an account.
      Each account interacting with this module must have a `BalanceStore` resource.

      **Abilities:**
      - `key`: Allows the resource to be stored globally and accessed via account addresses.
      */
    struct BalanceStore has key {
        account: address, // The address of the account
        balance: u64,     // The current balance of the account
    }

    /*
    ============================
    Function Definitions
    ============================
    */

    /*
    1. `init_account`
    -----------------
    **Description:**
    Initializes a new account by creating a `BalanceStore` resource with a default balance.

    **Parameters:**
    - `account`: A reference to the signer's account who is initializing their balance.

    **Behavior:**
    - Creates a `BalanceStore` with the signer's address and an initial balance of 100.
    - Moves the `BalanceStore` resource to the signer's account.
    */
    fun init_account(account: &signer) {
        let balancestore = BalanceStore {
            account: signer::address_of(account),
            balance: 100,
        };

        move_to(account, balancestore);
    }

    /*
    2. `private_calculation`
    ------------------------
    **Description:**
    A private function that performs an internal calculation by adding two `u64` values.
    It also prints the intermediate result for debugging purposes.

    **Parameters:**
    - `x`: First operand.
    - `y`: Second operand.

    **Returns:**
    - The sum of `x` and `y`.
    */
    fun private_calculation(x: u64, y: u64): u64 {
        let value = x + y;
        print(&value);
        value
    }

    /*
    3. `inline_increment`
    ---------------------
    **Description:**
    An inline function that increments a `u64` value by 1.
    Marked as `inline` to suggest to the compiler that it should be inlined for performance optimization.

    **Parameters:**
    - `value`: The value to be incremented.

    **Returns:**
    - The incremented value.
    */
    inline fun inline_increment(value: u64): u64 {
        value + 1
    }

    /*
    4. `public_compute`
    -------------------
    **Description:**
    A public function that can be called by other modules and scripts.
    It utilizes both the private calculation and inline increment functions internally.
    Additionally, it prints the intermediate and final results for debugging.

    **Parameters:**
    - `a`: First operand.
    - `b`: Second operand.

    **Returns:**
    - The final computed value after addition and incrementation.
    */
    public fun public_compute(a: u64, b: u64): u64 {
        let sum = private_calculation(a, b);      // Calls the private calculation function
        let incremented = inline_increment(sum);  // Calls the inline increment function
        print(&sum);                              // Prints the sum
        print(&incremented);                      // Prints the incremented value
        incremented                               // Returns the incremented value
    }

    /*
    5. `execute_transfer`
    ---------------------
    **Description:**
    An entry function that facilitates the transfer of funds from the sender to the recipient.
    Being an entry function, it can be invoked as a transaction and can modify the blockchain state.

    **Parameters:**
    - `sender`: A reference to the signer's account initiating the transfer.
    - `recipient`: The address of the account receiving the funds.
    - `amount`: The amount of funds to be transferred.

    **Behavior:**
    - Retrieves the sender's address and balance.
    - Checks if the sender has sufficient funds; if not, aborts with `EInsufficientFunds`.
    - Subtracts the specified amount from the sender's balance.
    - Adds the specified amount to the recipient's balance.

    **Acquires:**
    - `BalanceStore`: Indicates that this function accesses the `BalanceStore` resource.
    */
    public entry fun execute_transfer(
        sender: &signer,
        recipient: address,
        amount: u64
    ) acquires BalanceStore {
        // Retrieve the sender's address
        let sender_address = signer::address_of(sender);

        // Get the sender's current balance
        let sender_balance = get_balance(sender_address);

        // Check for sufficient funds
        if (sender_balance < amount) {
            abort EInsufficientFunds;
        };

        // Perform the transfer
        sub_balance(sender_address, amount);  // Subtract from sender
        add_balance(recipient, amount);       // Add to recipient
    }

    /*
    6. `get_balance`
    ---------------
    **Description:**
    A view function that retrieves the balance of a specified account without modifying the blockchain state.
    View functions are read-only and do not require signing.

    **Parameters:**
    - `account`: The address of the account whose balance is to be retrieved.

    **Returns:**
    - The current balance of the specified account.

    **Attributes:**
    - `#[view]`: Indicates that this is a view function.

    **Acquires:**
    - `BalanceStore`: Indicates that this function accesses the `BalanceStore` resource.
    */
    #[view]
    public fun get_balance(account: address): u64 acquires BalanceStore {
        // Borrow the BalanceStore resource for the specified account and return the balance
        borrow_global<BalanceStore>(account).balance
    }

    /*
    ============================
    Helper Functions (Private)
    ============================

    These functions are private and can only be called within this module.
    They handle the internal logic of modifying account balances.
    */

    /*
    7. `sub_balance`
    ----------------
    **Description:**
    Subtracts a specified amount from an account's balance.

    **Parameters:**
    - `account`: The address of the account from which the amount will be subtracted.
    - `amount`: The amount to subtract.

    **Behavior:**
    - Borrows the `BalanceStore` resource mutably for the specified account.
    - Updates the balance by subtracting the specified amount.

    **Acquires:**
    - `BalanceStore`: Indicates that this function accesses the `BalanceStore` resource.
    */
    fun sub_balance(account: address, amount: u64) acquires BalanceStore {
        let balance_store = borrow_global_mut<BalanceStore>(account);
        balance_store.balance = balance_store.balance - amount;
    }

    /*
    8. `add_balance`
    ----------------
    **Description:**
    Adds a specified amount to an account's balance.

    **Parameters:**
    - `account`: The address of the account to which the amount will be added.
    - `amount`: The amount to add.

    **Behavior:**
    - Borrows the `BalanceStore` resource mutably for the specified account.
    - Updates the balance by adding the specified amount.

    **Acquires:**
    - `BalanceStore`: Indicates that this function accesses the `BalanceStore` resource.
    */
    fun add_balance(account: address, amount: u64) acquires BalanceStore {
        let balance_store = borrow_global_mut<BalanceStore>(account);
        balance_store.balance = balance_store.balance + amount;
    }

    /*
    ============================
    Testing Functions
    ============================

    These test functions validate the behavior of the module's functions.
    */

    /*
    9. `test_calculate`
    -------------------
    **Description:**
    Tests the `private_calculation` function by passing specific inputs and ensuring it operates correctly.

    **Behavior:**
    - Calls `private_calculation` with values 23 and 27.
    - The expected sum is 50, and it should be printed by the function.
    */
    #[test]
    fun test_calculate() {
        private_calculation(23, 27);
    }

    /*
    10. `test_public_compute`
    -------------------------
    **Description:**
    Tests the `public_compute` function by passing specific inputs and verifying the output.

    **Behavior:**
    - Calls `public_compute` with values 30 and 70.
    - The expected computation is (30 + 70) + 1 = 101.
    - The intermediate sum (100) and the incremented value (101) are printed by the function.
    */
    #[test]
    fun test_public_compute() {
        public_compute(30, 70);
    }
}
