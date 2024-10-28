module counter_addr::task_counter {

    use aptos_framework::account;
    use std::signer;
    use aptos_framework::event;
    use std::string::String;

    // Errors
    const E_NOT_INITIALIZED: u64 = 1;

    // Simple counter to track the number of tasks created
    struct TaskCounter has key {
        counter: u64
    }

    #[event]
    struct TaskCreated has store, drop, copy {
        task_id: u64,
        address: address,
        content: String,
    }

    // Initializes the TaskCounter resource for the account if it doesn't exist
    public entry fun initialize_counter(account: &signer) {
        let task_counter = TaskCounter {
            counter: 0
        };
        move_to(account, task_counter);
    }

    // Creates a task and increments the counter without storing task details
    public entry fun create_task(account: &signer, content: String) acquires TaskCounter {
        let signer_address = signer::address_of(account);
        // Ensure the TaskCounter resource is initialized for this account
        assert!(exists<TaskCounter>(signer_address), E_NOT_INITIALIZED);

        // Access the TaskCounter and increment the task counter
        let task_counter = borrow_global_mut<TaskCounter>(signer_address);
        task_counter.counter = task_counter.counter + 1;

        // Emit a TaskCreated event with the new task ID and content
        let new_task = TaskCreated {
            task_id: task_counter.counter,
            address: signer_address,
            content,
        };
        event::emit(new_task);
    }

    // Retrieve the current task counter value for the given account
    public fun get_task_count(account: address): u64 acquires TaskCounter {
        let task_counter = borrow_global<TaskCounter>(account);
        task_counter.counter
    }

    #[test(admin = @0x123)]
    public entry fun test_counter_flow(admin: signer) acquires TaskCounter {
        account::create_account_for_test(signer::address_of(&admin));
        initialize_counter(&admin);

        // Create a task and verify the counter increment
        create_task(&admin, string::utf8(b"Task 1"));
        let counter_value = get_task_count(signer::address_of(&admin));
        assert!(counter_value == 1, 5);

        // Create another task and check the counter again
        create_task(&admin, string::utf8(b"Task 2"));
        let counter_value = get_task_count(signer::address_of(&admin));
        assert!(counter_value == 2, 6);
    }
}
