import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../controllers/add_note_controller.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/validators.dart';
import '../../../domain/entities/note_entity.dart';
import '../../../domain/usecases/auth_usecases.dart';
import '../../../domain/usecases/note_usecases.dart';
import '../../widgets/custom_text_field.dart';

class AddNotePage extends StatelessWidget {
  final NoteEntity? existingNote;

  const AddNotePage({super.key, this.existingNote});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      AddNoteController(
        addNoteUseCase: Get.find<AddNoteUseCase>(),
        updateNoteUseCase: Get.find<UpdateNoteUseCase>(),
        getCurrentUserUseCase: Get.find<GetCurrentUserUseCase>(),
      ),
    );
    controller.initWithNote(existingNote);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.isEditing ? AppStrings.editNote : AppStrings.addNote,
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Color Picker
              Text(
                'Pick a color',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.textDark,
                    ),
              ).animate().fadeIn(duration: 400.ms),

              const SizedBox(height: 12),

              Obx(() => Row(
                    children: List.generate(
                      AppTheme.noteColors.length,
                      (index) => GestureDetector(
                        onTap: () => controller.selectColor(index),
                        child: AnimatedContainer(
                          duration: 200.ms,
                          margin: const EdgeInsets.only(right: 10),
                          width: controller.selectedColorIndex.value == index
                              ? 36
                              : 28,
                          height: controller.selectedColorIndex.value == index
                              ? 36
                              : 28,
                          decoration: BoxDecoration(
                            color: AppTheme.noteColors[index],
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: controller.selectedColorIndex.value == index
                                  ? AppTheme.primary
                                  : Colors.transparent,
                              width: 2.5,
                            ),
                            boxShadow: [
                              if (controller.selectedColorIndex.value == index)
                                BoxShadow(
                                  color: AppTheme.noteColors[index]
                                      .withValues(alpha: 0.6),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )).animate(delay: 100.ms).fadeIn().slideX(begin: -0.1),

              const SizedBox(height: 28),

              // Title Field
              CustomTextField(
                controller: controller.titleController,
                label: AppStrings.noteTitle,
                hint: AppStrings.titleHint,
                prefixIcon: Icons.title_rounded,
                validator: Validators.validateTitle,
              ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.1),

              const SizedBox(height: 16),

              // Description Field
              CustomTextField(
                controller: controller.descriptionController,
                label: AppStrings.noteDescription,
                hint: AppStrings.descriptionHint,
                prefixIcon: Icons.notes_rounded,
                maxLines: 10,
                validator: Validators.validateDescription,
              ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.1),

              const SizedBox(height: 32),

              // Save Button
              Obx(() => ElevatedButton(
                    onPressed:
                        controller.isLoading.value ? null : controller.saveNote,
                    child: controller.isLoading.value
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Text(controller.isEditing
                            ? AppStrings.updateNote
                            : AppStrings.saveNote),
                  )).animate(delay: 400.ms).fadeIn().slideY(begin: 0.3),
            ],
          ),
        ),
      ),
    );
  }
}
