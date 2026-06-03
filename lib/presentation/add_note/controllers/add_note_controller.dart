import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/entities/note_entity.dart';
import '../../../domain/usecases/auth_usecases.dart';
import '../../../domain/usecases/note_usecases.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/constants/app_strings.dart';

class AddNoteController extends GetxController {
  final AddNoteUseCase _addNoteUseCase;
  final UpdateNoteUseCase _updateNoteUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  AddNoteController({
    required AddNoteUseCase addNoteUseCase,
    required UpdateNoteUseCase updateNoteUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
  })  : _addNoteUseCase = addNoteUseCase,
        _updateNoteUseCase = updateNoteUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase;

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxInt selectedColorIndex = 0.obs;

  NoteEntity? existingNote;

  void initWithNote(NoteEntity? note) {
    existingNote = note;
    if (note != null) {
      titleController.text = note.title;
      descriptionController.text = note.description;
      selectedColorIndex.value = note.colorIndex;
    }
  }

  bool get isEditing => existingNote != null;

  void selectColor(int index) {
    selectedColorIndex.value = index;
  }

  Future<void> saveNote() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;

    try {
      final user = _getCurrentUserUseCase();
      if (user == null) {
        AppSnackbar.error('Session expired. Please login again.');
        isLoading.value = false;
        return;
      }

      if (isEditing) {
        final updated = existingNote!.copyWith(
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          updatedAt: DateTime.now(),
          colorIndex: selectedColorIndex.value,
        );
        await _updateNoteUseCase(updated);
      } else {
        final note = NoteEntity(
          id: const Uuid().v4(),
          userId: user.uid,
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          colorIndex: selectedColorIndex.value,
        );
        await _addNoteUseCase(note);
      }

      titleController.clear();
      descriptionController.clear();
      selectedColorIndex.value = 0;
      Get.back();
    } catch (e) {
      debugPrint('SaveNote error: $e');
      final msg = e.toString().contains('PERMISSION_DENIED')
          ? 'Permission denied. Check Firestore rules.'
          : AppStrings.somethingWentWrong;
      AppSnackbar.error(msg);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
