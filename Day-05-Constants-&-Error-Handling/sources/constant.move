module blockchain::ConstantsAndErrorHandling {
   /* 
    ============================
    Constants Module
    ============================
     
    This module centralizes all constant definitions, including error codes.
    By organizing constants in a dedicated module, we enhance code readability
    and maintainability, allowing for easy updates and reuse across different modules.

    Import necessary modules
    */
    use std::signer;

    /* Error Codes
      Naming Convention:
       - Error codes start with an uppercase 'E' followed by CamelCase.
       - Example: `EInsufficientFunds`, `EUnauthorizedAccess`
    */
    const EInsufficientFunds: u64 = 1001;
    const EUnauthorizedAccess: u64 = 1002;
    const EInvalidInput: u64 = 1003;

    /* Non-Error Constants
    Naming Convention:
    - Non-error constants use UPPER_SNAKE_CASE.
    - Example: `MAX_SUPPLY`, `MIN_BALANCE`
    */
    const MAX_SUPPLY: u64 = 1000000;
    const MIN_BALANCE: u64 = 100;
    const OWNER: address = @blockchain;


    /* ============================
      Error Handling Section
    ============================
    
    This section demonstrates error handling using `abort` and `assert!`.
    It leverages constants defined in the `Constants` module for consistent error reporting.

    Constants Module: Contains all constant definitions and error codes.
    */
    

    /* Function: `check_balance`
    Checks if a user's balance meets the minimum required balance.
    If not, aborts with `EInsufficientFunds` error code.
    */
    inline fun check_balance(balance: u64) {
        if (balance < MIN_BALANCE) {
            abort EInsufficientFunds
        }
    }

     /* Function: `authorize_action`
      Authorizes a user to perform a specific action.
      If the user lacks the necessary permissions, aborts with `EUnauthorizedAccess`.
    */
    inline fun authorize_action(address: address) {
        assert!(OWNER == address, EUnauthorizedAccess);
    }

    /* Function: `validate_input`
      Validates user input.
      If the input is invalid, aborts with `EInvalidInput` error code.
    */
    fun validate_input(input: u64) {
        assert!(input > 0, EInvalidInput);
    }

    #[test]
    #[expected_failure(abort_code = EInsufficientFunds)]
    fun test_check_balance_insufficient() {
        check_balance(89)
    }

    #[test]
    fun test_pass_balance_insufficient() {
        check_balance(102)
    }

    #[test]
    #[expected_failure(abort_code = EUnauthorizedAccess)]
    fun test_authorize_action_unauthorized() {
        authorize_action(@std)
    }

    #[test]
    fun test_authorize_pass_action_unauthorized() {
        authorize_action(@blockchain)
    }

    #[test]
    #[expected_failure(abort_code = EInvalidInput)]
    fun test_validate_input_invalid() {
        let input = 0; // Invalid input
        validate_input(input);
    }

    #[test]
    fun test_validate_input_valid() {
        let input = 10; // Valid input
        validate_input(input);
        // If no abort occurs, the test passes
    }
}