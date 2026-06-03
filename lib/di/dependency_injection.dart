import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

// Data Sources
import '../data/datasources/auth_remote_datasource.dart';
import '../data/datasources/note_remote_datasource.dart';

// Repositories (Data)
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/note_repository_impl.dart';

// Repositories (Domain)
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/note_repository.dart';

// Use Cases
import '../domain/usecases/auth_usecases.dart';
import '../domain/usecases/note_usecases.dart';
import '../presentation/home/controllers/home_controller.dart';

class DependencyInjection {
  static Future<void> init() async {
    // Firebase instances (permanent singletons)
    Get.put<FirebaseAuth>(FirebaseAuth.instance, permanent: true);
    Get.put<FirebaseFirestore>(FirebaseFirestore.instance, permanent: true);

    // Data Sources
    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        firebaseAuth: Get.find<FirebaseAuth>(),
        firestore: Get.find<FirebaseFirestore>(),
      ),
      fenix: true,
    );
    Get.lazyPut<NoteRemoteDataSource>(
      () => NoteRemoteDataSourceImpl(
        firestore: Get.find<FirebaseFirestore>(),
      ),
      fenix: true,
    );

    // Repositories
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(dataSource: Get.find<AuthRemoteDataSource>()),
      fenix: true,
    );
    Get.lazyPut<NoteRepository>(
      () => NoteRepositoryImpl(dataSource: Get.find<NoteRemoteDataSource>()),
      fenix: true,
    );

    // Auth Use Cases
    Get.lazyPut(() => LoginUseCase(Get.find<AuthRepository>()), fenix: true);
    Get.lazyPut(() => RegisterUseCase(Get.find<AuthRepository>()), fenix: true);
    Get.lazyPut(() => LogoutUseCase(Get.find<AuthRepository>()), fenix: true);
    Get.lazyPut(
        () => GetCurrentUserUseCase(Get.find<AuthRepository>()), fenix: true);

    // Note Use Cases
    Get.lazyPut(() => GetNotesUseCase(Get.find<NoteRepository>()), fenix: true);
    Get.lazyPut(() => AddNoteUseCase(Get.find<NoteRepository>()), fenix: true);
    Get.lazyPut(
        () => UpdateNoteUseCase(Get.find<NoteRepository>()), fenix: true);
    Get.lazyPut(
        () => DeleteNoteUseCase(Get.find<NoteRepository>()), fenix: true);

    // HomeController registered here so it persists across navigations
    // and keeps the Firestore stream alive while on the Add Note page.
    Get.lazyPut<HomeController>(
      () => HomeController(
        getNotesUseCase: Get.find<GetNotesUseCase>(),
        deleteNoteUseCase: Get.find<DeleteNoteUseCase>(),
        logoutUseCase: Get.find<LogoutUseCase>(),
        getCurrentUserUseCase: Get.find<GetCurrentUserUseCase>(),
      ),
      fenix: true,
    );
  }
}
