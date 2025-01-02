// Declare the module. The module name is usually the same as the file name.
module blockchain::hello {
    use std::debug::print;
    use std::string::utf8;

    // The public entry function serves as the starting point for this module.
    // This function can be called by users of the blockchain.
    #[test]
    public entry fun say_hello() {
        // The `debug::print()` function is used to log messages for debugging.
        // The message below will be displayed when this function is called.
        print(&utf8(b"Hello Blockchain!"));
        
        // Note: `debug::print()` is for testing and debugging purposes only.
        // It does not create any on-chain effects or store any data in the blockchain.
    }
}
