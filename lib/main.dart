import 'package:dunjion_app/ui/Dungeon.dart';
import 'package:dunjion_app/ui/task_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// void main() => runApp(Dungeon());

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskData(),
      child: MaterialApp(
        home: TasksScreen(),
      ),
    ),
  );
}

class Task {
  final String name;
  final DateTime deadline;
  bool isDone;

  Task({required this.name, required this.deadline, this.isDone = false});

  void toggleDone() {
    isDone = !isDone;
  }
}

class TaskData extends ChangeNotifier {
  List<Task> tasks = [];

  void addTask(String newTaskName, DateTime newTaskDeadline) {
    final task = Task(name: newTaskName, deadline: newTaskDeadline);
    tasks.add(task);
    notifyListeners();
  }

  void deleteTask(Task task) {
    tasks.remove(task);
    notifyListeners();
  }
}

class TasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Consumer<TaskData>(
        builder: (context, taskData, child) {
          return ListView.builder(
            itemCount: taskData.tasks.length,
            itemBuilder: (context, index) {
              final task = taskData.tasks[index];
              return ListTile(
                title: Text(task.name),
                subtitle: Text('Deadline: ${task.deadline.toString()}'),
                trailing: Checkbox(
                  value: task.isDone,
                  onChanged: (bool? newValue) {
                    taskData.updateTask(task);
                  },
                ),
                onLongPress: () {
                  taskData.deleteTask(task);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              String newTaskName = '';
              DateTime newTaskDeadline = DateTime.now();

              return AlertDialog(
                title: const Text('Add a task'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      autofocus: true,
                      onChanged: (value) {
                        newTaskName = value;
                      },
                      decoration: InputDecoration(labelText: 'Task Name'),
                    ),
                    SizedBox(height: 16),
                    InkWell(
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(DateTime
                              .now()
                              .year + 5),
                        );
                        if (selectedDate != null) {
                          newTaskDeadline = selectedDate;
                        }
                      },
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today),
                          SizedBox(width: 8),
                          Text(
                            'Deadline: ${newTaskDeadline.toString()}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Provider.of<TaskData>(context, listen: false)
                          .addTask(newTaskName, newTaskDeadline);
                      Navigator.pop(context);
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.lightBlueAccent,
      ),
    );
  }
}
