import 'package:flutter/material.dart';
import 'package:note_app_hive/boxes/boxes.dart';
import 'package:note_app_hive/model/notes_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white60,
      appBar: AppBar(
        title: Center(child: Text('Hive Database')),
      ),
      body: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context, box, _) {
          var notesList = box.values.toList().cast<NotesModel>();
          return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 5,right: 5,left: 5),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white, width: 4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    tileColor: Colors.blue,
                    textColor: Colors.white,
                    title: Text(notesList[index].title.toString(),style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),),
                    subtitle: Text(notesList[index].desc.toString(),style: TextStyle(
                      fontSize: 15,
                    ),),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                            onTap: () {
                              editDialog(
                                  notesList[index],
                                  notesList[index].title.toString(),
                                  notesList[index].desc.toString());
                            },
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 30,
                            )),
                        VerticalDivider(
                          color: Colors.white,
                          thickness: 2,
                        ),
                        InkWell(
                            onTap: () {
                              delete(notesList[index]);
                            },
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 30,
                            )),
                      ],
                    ),
                  ),
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showAddDialogue();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void delete(NotesModel notesModel) async {
    await notesModel.delete();
  }

  Future<void> editDialog(
      NotesModel notesModel, String title, String desc) async {
    titleController.text = title;
    descriptionController.text = desc;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Edit Your Notes'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: 'Enter title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      hintText: 'Enter Description',
                      border: OutlineInputBorder(),
                    ),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    notesModel.title = titleController.text.toString();
                    notesModel.desc = descriptionController.text.toString();
                    notesModel.save();

                    titleController.clear();
                    descriptionController.clear();

                    Navigator.pop(context);
                  },
                  child: Text('Edit')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Close'))
            ],
          );
        });
  }

  Future<void> showAddDialogue() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add Your Notes'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: 'Enter title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      hintText: 'Enter Description',
                      border: OutlineInputBorder(),
                    ),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    final data = NotesModel(
                        title: titleController.text,
                        desc: descriptionController.text);
                    final box = Boxes.getData();
                    box.add(data);

                    titleController.clear();
                    descriptionController.clear();
                    Navigator.pop(context);
                  },
                  child: Text('Add')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Close'))
            ],
          );
        });
  }
}
