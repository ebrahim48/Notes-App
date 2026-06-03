import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/note_entity.dart';
import '../../../domain/usecases/auth_usecases.dart';
import '../../../domain/usecases/note_usecases.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/constants/app_strings.dart';

class HomeController extends GetxController {
  final GetNotesUseCase _getNotesUseCase;
  final DeleteNoteUseCase _deleteNoteUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  HomeController({
    required GetNotesUseCase getNotesUseCase,
    required DeleteNoteUseCase deleteNoteUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
  })  : _getNotesUseCase = getNotesUseCase,
        _deleteNoteUseCase = deleteNoteUseCase,
        _logoutUseCase = logoutUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase;

  final RxList<NoteEntity> notes = <NoteEntity>[].obs;
  final RxList<NoteEntity> filteredNotes = <NoteEntity>[].obs;
  final RxBool isLoading = true.obs;
  final RxString searchQuery = ''.obs;
  final RxString userName = ''.obs;

  StreamSubscription<List<NoteEntity>>? _notesSub;

  @override
  void onInit() {
    super.onInit();
    _loadUser();
    _listenToNotes();
    debounce(
      searchQuery,
      (_) => _filterNotes(),
      time: const Duration(milliseconds: 300),
    );
  }

  void _loadUser() {
    final user = _getCurrentUserUseCase();
    if (user != null) userName.value = user.name;
  }

  void _listenToNotes() {
    final user = _getCurrentUserUseCase();
    if (user == null) return;

    _notesSub?.cancel();
    _notesSub = _getNotesUseCase(user.uid).listen(
      (notesList) {
        notes.value = notesList;
        _filterNotes();
        isLoading.value = false;
      },
      onError: (e) {
        debugPrint('Notes stream error: $e');
        isLoading.value = false;
        AppSnackbar.error(AppStrings.somethingWentWrong);
      },
    );
  }

  void _filterNotes() {
    if (searchQuery.value.isEmpty) {
      filteredNotes.value = notes;
    } else {
      final q = searchQuery.value.toLowerCase();
      filteredNotes.value = notes
          .where((note) =>
              note.title.toLowerCase().contains(q) ||
              note.description.toLowerCase().contains(q))
          .toList();
    }
  }

  void onSearchChanged(String value) => searchQuery.value = value;

  Future<void> deleteNote(NoteEntity note) async {
    final user = _getCurrentUserUseCase();
    if (user == null) return;
    try {
      await _deleteNoteUseCase(note.id, user.uid);
    } catch (e) {
      AppSnackbar.error(AppStrings.somethingWentWrong);
    }
  }

  Future<void> logout() async {
    try {
      _notesSub?.cancel();
      await _logoutUseCase();
      Get.context?.go(AppConstants.loginRoute);
    } catch (e) {
      AppSnackbar.error(AppStrings.somethingWentWrong);
    }
  }

  void navigateToAddNote() => Get.context?.push(AppConstants.addNoteRoute);

  void navigateToEditNote(NoteEntity note) =>
      Get.context?.push(AppConstants.addNoteRoute, extra: note);

  @override
  void onClose() {
    _notesSub?.cancel();
    super.onClose();
  }
}
