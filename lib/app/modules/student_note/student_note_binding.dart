import 'package:get/get.dart';
import 'package:teacher/app/modules/student_note/student_note_controller.dart';

class StudentNoteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StudentNoteController>(() => StudentNoteController());
  }
}
