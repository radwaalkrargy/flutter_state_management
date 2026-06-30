import 'package:state_management_task/DataModel.dart';

// Base abstract class representing all possible states of the task feature
abstract class Taskstate {
  final List<TaskModel> tasks;
  Taskstate({required this.tasks});
}

// Initial state emitted when the app starts with an empty list or initial data
class InitialState extends Taskstate{
  InitialState({required List<TaskModel> tasks}):super(tasks: tasks);
}

// State emitted whenever the task list is modified (added or deleted) to refresh the UI
class UpdateState extends Taskstate{
  UpdateState({required List<TaskModel> tasks}):super(tasks: tasks);
}