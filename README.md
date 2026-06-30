# To-Do Application (Flutter & Cubit)

A clean and responsive To-Do application built using Flutter and managed via Cubit (Bloc) for efficient state management. This project demonstrates clean architecture principles, dynamic UI updates, and multiple bonus features.

## Features & Requirements Met
- Core Requirements:
  - Add new tasks with unique data.
  - Delete existing tasks dynamically.
  - Display tasks seamlessly with an automatic UI update.
- Bonus Features Implemented:
  - Task Priority Level: Users can choose between High , Medium , and Low using a smooth Dropdown Selector.
  - Total Tasks Counter: Displays the active total count of tasks at the top of the screen.
  - Empty State Message: Shows a friendly placeholder message when no tasks are currently available.

---

## Project Architecture
The project follows a modular folder structure to maintain the separation of concerns:

- `models/`: Contains `DataModel.dart` which defines the structure of a single Task (`title`, `isCompleted`, `priority`).
- `cubit/`: Contains `TaskCubit.dart` (handles the business logic and methods) and `TaskState.dart` (defines the blueprint of the UI states).
- `main.dart`: Contains the presentation layer, building the layout with a `BlocBuilder` to listen to state modifications.

---

## Application Flow Explanation

1. Initialization: When the application boots up, `main.dart` wraps the root widget with a `BlocProvider` to make the `Taskcubit` accessible. The Cubit initializes itself with an `InitialState` containing an empty list.
2. Empty State Handling: The `BlocBuilder` evaluates the state list. Since it's initially empty, it returns a styled placeholder text instructing the user to start adding tasks.
3. Adding a Task: - Clicking the `FloatingActionButton` opens a context-aware `showModalBottomSheet`.
   - Inside, a `StatefulBuilder` encapsulates a `TextField` for the task title and a `DropdownButtonFormField` for the priority level.
   - Upon pressing "Add Task", the text and chosen priority are passed to `context.read<Taskcubit>().addTask()`.
   - The Cubit modifies its inner list and emits an `UpdateState` with a completely fresh list copy (`List.from`).
4. UI Rebuild: The `BlocBuilder` catches the emitted `UpdateState`, triggers a reactive UI rebuild, updates the Total Tasks Counter, and populates the `ListView.builder` displaying the tasks with customized priority badges.
5. Deleting a Task: Clicking the trash icon passes the item's index to `context.read<Taskcubit>().deleteTask()`, which shifts the array data and emits a new state to instantaneously redraw the clean UI.
