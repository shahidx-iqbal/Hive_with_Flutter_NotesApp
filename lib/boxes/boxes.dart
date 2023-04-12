
import 'package:hive/hive.dart';
import 'package:note_app_hive/model/notes_model.dart';

class Boxes {
static Box<NotesModel> getData() {
  return Hive.box<NotesModel>('notes');
}
}