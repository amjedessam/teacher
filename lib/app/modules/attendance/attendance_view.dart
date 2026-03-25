import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import 'attendance_controller.dart';

class AttendanceView extends GetView<AttendanceController> {
  const AttendanceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تسجيل الحضور'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.students.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            _buildDatePicker(),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.students.length,
                itemBuilder: (context, i) {
                  final s = controller.students[i];
                  final status = controller.statusByStudentId[s.id] ?? 'present';
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(s.name),
                      subtitle: Text(s.studentCode),
                      trailing: DropdownButton<String>(
                        value: status,
                        items: const [
                          DropdownMenuItem(value: 'present', child: Text('حاضر')),
                          DropdownMenuItem(value: 'absent', child: Text('غائب')),
                          DropdownMenuItem(value: 'late', child: Text('متأخر')),
                          DropdownMenuItem(value: 'excused', child: Text('بعذر')),
                        ],
                        onChanged: (v) {
                          if (v != null) controller.setStatus(s.id, v);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: Obx(() => ElevatedButton(
                        onPressed: controller.isSaving.value ? null : controller.submit,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: AppColors.primary,
                        ),
                        child: controller.isSaving.value
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Text('حفظ الحضور'),
                      )),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildDatePicker() {
    return Obx(() {
      final d = controller.selectedDate.value;
      return InkWell(
        onTap: () async {
          final picked = await showDatePicker(
            context: Get.context!,
            initialDate: d,
            firstDate: d.subtract(const Duration(days: 365)),
            lastDate: DateTime.now().add(const Duration(days: 1)),
          );
          if (picked != null) controller.setDate(picked);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.calendar_today, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
    });
  }
}
