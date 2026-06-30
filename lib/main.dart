import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:state_management_task/DataModel.dart';
import 'package:state_management_task/TaskCubit.dart';
import 'package:state_management_task/TaskState.dart';

void main() {
  runApp(const MyApp());
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Providing the Taskcubit to the entire widget tree
    return BlocProvider(
      create: (context) => Taskcubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 168, 28, 114),
            title: Center(child: Text("TO DO APP" , style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold))),
          ),
          // Rebuilds the UI automatically whenever the task state changes
          body: BlocBuilder<Taskcubit, Taskstate>(
            builder: (BuildContext context, state){
              List<TaskModel> currentTasks = state.tasks;
              // Display a friendly message if the task list is empty
              if(currentTasks.isEmpty){
                return const Center(
                  child: Text(
                    'There are no tasks currently; start adding some tasks!',
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }
              // Otherwise, display the task statistics and list view 
              return Column(
                children: [
                  // Displays the total number of tasks
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Total Taskes: ${currentTasks.length}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Dynamic list builder to present the tasks
                  Expanded(
                    child: ListView.builder(
                      itemCount: currentTasks.length,
                      itemBuilder: (context, index){
                        final task = currentTasks[index];
                        return ListTile(
                          title: Row(
                            children: [
                              Text(task.title),
                              const SizedBox(width: 10),
                              // Visual indicator showing the task priority badge
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: task.priority == 1 
                                      ? Colors.red.withOpacity(0.2) 
                                      : task.priority == 2 
                                          ? Colors.amber.withOpacity(0.2) 
                                          : Colors.green.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  task.priority == 1 ? 'High' : task.priority == 2 ? 'Medium' : 'Low',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: task.priority == 1 
                                        ? Colors.red 
                                        : task.priority == 2 
                                            ? Colors.amber[900] 
                                            : Colors.green,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Delete button to trigger task removal from the Cubit
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              // Invokes the deleteTask logic from Cubit using the item's index
                              context.read<Taskcubit>().deleteTask(index);
                            },
                          ),
                        );
                      }
                    )
                  ),
                ],
              );
            }
          ),
          // Floating button wrapped in a Builder to access the correct context for the BottomSheet
          floatingActionButton: Builder(
            builder: (context) {
              return FloatingActionButton(
                onPressed: () {
                  final TextEditingController titleController = TextEditingController();
                  int selectedPriority = 2; // Default priority set to Medium               
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true, // Slides up fully when the keyboard appears
                    builder: (BuildContext context) {
                      // StatefulBuilder allows managing the dropdown state inside the bottom sheet
                      return StatefulBuilder( 
                        builder: (context, setModalState) {
                        return Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom, 
                          top: 20, left: 20, right: 20,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,  
                          children: [
                            const Text('Add New Task',style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                            const SizedBox(height: 15),
                            TextField(
                              controller: titleController,
                              decoration: const InputDecoration(
                                hintText: 'Enter task name...',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 15),
                            // Dropdown menu for selecting a fixed priority level
                            DropdownButtonFormField<int>(
                              initialValue: selectedPriority,
                              decoration: const InputDecoration(
                                labelText: 'Task Priority',
                                border: OutlineInputBorder(),
                              ),
                              items: const [
                                DropdownMenuItem(value: 1, child: Text('High 🔴')),
                                DropdownMenuItem(value: 2, child: Text('Medium 🟡')),
                                DropdownMenuItem(value: 3, child: Text('Low 🟢')),
                              ],
                              onChanged: (value) {
                                if (value != null) {
                                  // Updates the dropdown's UI locally within the bottom sheet
                                  setModalState(() {
                                    selectedPriority = value;
                                  });
                                }
                              },
                            ),
                            const SizedBox(height: 15),
                            ElevatedButton(
                              onPressed: () {
                                if (titleController.text.isNotEmpty) {
                                  // Triggers the addTask function in Cubit with the title and priority
                                  context.read<Taskcubit>().addTask(titleController.text,selectedPriority);
                                  // Closes the bottom sheet after successfully adding the task
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text('Add Task'),
                            ),
                            const SizedBox(height: 15),
                          ],
                        ),
                      );
                    },
                  );
                },
                );
                },
                child: const Icon(Icons.add),
              );
            }
          ),
        )
      )
    );
  }
}
