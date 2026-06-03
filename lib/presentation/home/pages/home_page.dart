import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/home_controller.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/note_entity.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.myNotes,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (controller.userName.value.isNotEmpty)
                  Text(
                    'Hi, ${controller.userName.value} 👋',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textLight,
                          fontSize: 12,
                        ),
                  ),
              ],
            )),
        actions: [
          IconButton(
            onPressed: () => _showLogoutDialog(context, controller),
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              onChanged: controller.onSearchChanged,
              decoration: InputDecoration(
                hintText: AppStrings.searchHint,
                prefixIcon: const Icon(Icons.search_rounded,
                    color: AppTheme.textLight),
                suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded,
                            color: AppTheme.textLight),
                        onPressed: () {
                          controller.onSearchChanged('');
                        },
                      )
                    : const SizedBox.shrink()),
              ),
            ),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2),

          const SizedBox(height: 12),

          // Notes List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppTheme.primary),
                );
              }

              if (controller.filteredNotes.isEmpty) {
                return _buildEmptyState(context, controller.searchQuery.value);
              }

              return ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: controller.filteredNotes.length,
                itemBuilder: (context, index) {
                  final note = controller.filteredNotes[index];
                  return _NoteCard(
                    note: note,
                    onTap: () => controller.navigateToEditNote(note),
                    onDelete: () =>
                        _showDeleteDialog(context, note, controller),
                  )
                      .animate(delay: Duration(milliseconds: index * 60))
                      .fadeIn()
                      .slideY(begin: 0.1);
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.navigateToAddNote,
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Note'),
      ).animate(delay: 300.ms).scale(),
    );
  }

  Widget _buildEmptyState(BuildContext context, String query) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            query.isNotEmpty
                ? Icons.search_off_rounded
                : Icons.note_add_outlined,
            size: 80,
            color: AppTheme.textLight,
          ),
          const SizedBox(height: 16),
          Text(
            query.isNotEmpty ? 'No results for "$query"' : AppStrings.noNotes,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.textMedium,
                ),
          ),
          const SizedBox(height: 8),
          if (query.isEmpty)
            Text(
              AppStrings.noNotesSubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textLight,
                  ),
            ),
        ],
      ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.9, 0.9)),
    );
  }

  void _showLogoutDialog(BuildContext context, HomeController controller) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(AppStrings.cancel,
                style: TextStyle(color: AppTheme.textMedium)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              controller.logout();
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(80, 40),
              backgroundColor: AppTheme.error,
            ),
            child: const Text(AppStrings.logout),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context, NoteEntity note, HomeController controller) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(AppStrings.deleteNote),
        content: const Text(AppStrings.deleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(AppStrings.cancel,
                style: TextStyle(color: AppTheme.textMedium)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              controller.deleteNote(note);
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(80, 40),
              backgroundColor: AppTheme.error,
            ),
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final NoteEntity note;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _NoteCard({
    required this.note,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        AppTheme.noteColors[note.colorIndex % AppTheme.noteColors.length];
    final dateStr =
        DateFormat('MMM d, yyyy').format(note.updatedAt);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    note.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.textDark,
                          fontWeight: FontWeight.w700,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline_rounded,
                      color: AppTheme.textLight, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              note.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textMedium,
                  ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Text(
              dateStr,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textLight,
                    fontSize: 11,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
