// // question_quality_controller.dart
// import 'package:get/get.dart';
// import '../../data/services/mock_data_service.dart';
// import '../../data/models/question_model.dart';

// class QuestionQualityController extends GetxController {
//   final mockDataService = MockDataService();
//   final isLoading = true.obs;
//   final questions = <QuestionModel>[].obs;

//   @override
//   void onInit() {
//     super.onInit();
//     loadQuestions();
//   }

//   Future<void> loadQuestions() async {
//     isLoading.value = true;
//     await Future.delayed(const Duration(milliseconds: 500));
//     questions.value = mockDataService.getQuestions();
//     isLoading.value = false;
//   }

//   List<QuestionModel> get excellentQuestions =>
//       questions.where((q) => q.quality == 'Excellent').toList();

//   List<QuestionModel> get goodQuestions =>
//       questions.where((q) => q.quality == 'Good').toList();

//   List<QuestionModel> get fairQuestions =>
//       questions.where((q) => q.quality == 'Fair').toList();

//   List<QuestionModel> get poorQuestions =>
//       questions.where((q) => q.quality == 'Poor').toList();
// }

// question_quality_controller.dart
import 'package:get/get.dart';
import '../../data/services/mock_data_service.dart';
// import '../../data/models/question_model.dart';

class QuestionQualityController extends GetxController {
  final mockDataService = MockDataService();
  final isLoading = true.obs;
  final questions = [].obs;

  @override
  void onInit() {
    super.onInit();
    loadQuestions();
  }

  Future loadQuestions() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 500));
    questions.value = mockDataService.getQuestions();
    isLoading.value = false;
  }

  List get excellentQuestions =>
      questions.where((q) => q.quality == 'Excellent').toList();

  List get goodQuestions =>
      questions.where((q) => q.quality == 'Good').toList();

  List get fairQuestions =>
      questions.where((q) => q.quality == 'Fair').toList();

  List get poorQuestions =>
      questions.where((q) => q.quality == 'Poor').toList();
}
