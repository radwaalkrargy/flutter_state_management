import 'package:state_management_task/TaskState.dart';
import 'package:state_management_task/DataModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 

// Cubit class responsible for managing the business logic and state of tasks
class Taskcubit extends Cubit<Taskstate>{
  // In-memory list to store and track the current tasks
  List<TaskModel> tasks = [];

  // Initialize the Cubit with the InitialState containing an empty list
  Taskcubit() : super(InitialState(tasks: []));

  // Adds a new task to the list and emits an updated state to refresh the UI
  void addTask(String taskTitle, int priority){
    tasks.add(TaskModel(title: taskTitle, isCompleted: false, priority: priority));
    // Emitting a new state with a new list copy to trigger BlocBuilder rebuild
    emit(UpdateState(tasks: List.from(tasks)));
  } 

  // Removes a task from the list using its index and notifies the UI
  void deleteTask(int index){
    tasks.removeAt(index);
    emit(UpdateState(tasks: List.from(tasks)));

  }
}
