import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dayReqController = TextEditingController();

  GlobalKey<FormState> todoForm = GlobalKey<FormState>();

  List<TodoData> task = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text("Task Management"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  actionsPadding: EdgeInsets.zero,
                  contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  title: const Text(
                    "Add Task",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  content: SingleChildScrollView(
                    child: Form(
                        key: todoForm,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _titleController,
                                validator: (value) {
                                  if (value?.trim().isEmpty ?? true) {
                                    return "Please enter title";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Text("Tittle"),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                validator: (value) {
                                  if (value?.trim().isEmpty ?? true) {
                                    return "Please enter description";
                                  }
                                  return null;
                                },
                                controller: _descriptionController,
                                maxLines: 5,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Text("Description"),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                validator: (value) {
                                  if (value?.trim().isEmpty ?? true) {
                                    return "Please enter required days";
                                  }
                                  return null;
                                },
                                controller: _dayReqController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  label: Text("Days Required"),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        if (todoForm.currentState!.validate()) {
                          int day = int.parse(_dayReqController.text);
                          task.add(TodoData(_titleController.text.trim(),
                              _descriptionController.text.trim(), day));
                          if (mounted) {
                            setState(() {});
                          }
                          _dayReqController.clear();
                          _titleController.clear();
                          _descriptionController.clear();
                          Navigator.pop(context);
                        }
                      },
                      child: const Text("Save"),
                    )
                  ],
                );
              });
        },
        child: const Icon(Icons.add),
      ),
      body: Stack(
        children: [
          ListView.separated(
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 4, right: 4),
                child: ListTile(
                  onLongPress: () {
                    Scaffold.of(context).showBottomSheet((context) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 8.0, bottom: 8),
                                  child: Text(
                                    'Task Details',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  "Tittle: ${task[index].title}",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text("Description: ${task[index].description}"),
                                Text(
                                    "Day's Required: ${task[index].daysRequired}"),
                                ElevatedButton(
                                    child: const Text('Delete'),
                                    onPressed: () {
                                      task.removeAt(index);
                                      setState(() {});
                                      Navigator.pop(context);
                                    })
                              ],
                            ),
                          ),
                        ),
                      );
                    });
                  },
                  title: Text(task[index].title),
                  subtitle: Text(task[index].description),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox();
            },
            itemCount: task.length,
          ),
        ],
      ),
    );
  }
}

class TodoData {
  String title, description;
  int daysRequired;
  TodoData(this.title, this.description, this.daysRequired);
}
