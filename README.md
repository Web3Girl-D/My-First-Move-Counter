# Task Counter Module

This module implements a basic task counter on the Aptos blockchain. It allows users to initialize a task counter for their account, create new tasks with a unique ID, and track the total number of tasks created.

## Features

- **Initialize Counter**: Sets up a task counter for a user's account.
- **Create Task**: Increments the counter and emits an event for each new task created.
- **Get Task Count**: Retrieves the total number of tasks created by the user.

## Structure

### `TaskCounter`
The `TaskCounter` struct stores the total count of tasks created by an account.

### Events
- **TaskCreated**: Emitted each time a new task is created. Contains:
  - `task_id`: The unique ID for the task.
  - `address`: The address of the task creator.
  - `content`: A description of the task.

## Functions

### `initialize_counter`
Initializes the `TaskCounter` for a user’s account. This must be called before creating tasks.

```move
public entry fun initialize_counter(account: &signer)
