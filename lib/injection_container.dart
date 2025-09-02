import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'core/constants/constants.dart';
import 'features/services/data/datasources/service_local_data_source.dart';
import 'features/services/data/models/service_model.dart';
import 'features/services/data/repositories/service_repository_impl.dart';
import 'features/services/domain/repositories/service_repository.dart';
import 'features/services/domain/usecases/get_favorite_services.dart';
import 'features/services/domain/usecases/get_services.dart';
import 'features/services/domain/usecases/toggle_favorite.dart';
import 'features/services/presentation/cubit/services_cubit.dart';

final sl = GetIt.instance;

/// Main initialization function
Future<void> init() async {
  try {
    print('🚀 Starting dependency injection initialization...');

    //! External Dependencies
    await _initHive();
    print('✅ Hive initialized successfully');

    //! Features - Services
    await _initServices();
    print('✅ Services feature initialized successfully');

    //! Core
    _initCore();
    print('✅ Core dependencies initialized successfully');

    print('🎉 Dependency injection completed successfully!');
  } catch (e, stackTrace) {
    print('❌ Failed to initialize dependencies: $e');
    print('Stack trace: $stackTrace');
    rethrow;
  }
}

/// Initialize Hive database and register adapters
Future<void> _initHive() async {
  try {
    // Get application documents directory for Hive
    final appDocumentDir = await getApplicationDocumentsDirectory();

    // Initialize Hive with custom path
    Hive.init(appDocumentDir.path);

    // For Flutter apps, use Hive.initFlutter() instead
    await Hive.initFlutter();

    // Register Hive adapters
    _registerHiveAdapters();

    // Open Hive boxes with error handling
    final servicesBox = await _openBox<ServiceModel>(
      Constants.servicesBox,
      'Services box',
    );

    final favoritesBox = await _openBox<int>(
      Constants.favoritesBox,
      'Favorites box',
    );

    // Register boxes as singletons
    sl.registerLazySingleton<Box<ServiceModel>>(() => servicesBox);
    sl.registerLazySingleton<Box<int>>(() => favoritesBox);

  } catch (e) {
    throw Exception('Failed to initialize Hive: $e');
  }
}

/// Register all Hive adapters
void _registerHiveAdapters() {
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(ServiceModelAdapter());
    print('📦 ServiceModelAdapter registered');
  }

  // Add more adapters here as needed
  // if (!Hive.isAdapterRegistered(1)) {
  //   Hive.registerAdapter(AnotherModelAdapter());
  // }
}

/// Open a Hive box with error handling
Future<Box<T>> _openBox<T>(String boxName, String description) async {
  try {
    final box = await Hive.openBox<T>(boxName);
    print('📦 $description opened successfully (${box.length} items)');
    return box;
  } catch (e) {
    print('❌ Failed to open $description: $e');

    // Try to delete corrupted box and recreate
    try {
      await Hive.deleteBoxFromDisk(boxName);
      print('🗑️ Deleted corrupted $description');

      final newBox = await Hive.openBox<T>(boxName);
      print('✅ Recreated $description successfully');
      return newBox;
    } catch (deleteError) {
      throw Exception('Failed to open or recreate $description: $deleteError');
    }
  }
}

/// Initialize Services feature dependencies
Future<void> _initServices() async {
  //! Presentation Layer
  // Cubit - Factory registration for multiple instances
  sl.registerFactory(
        () => ServicesCubit(
      getServices: sl(),
      getFavoriteServices: sl(),
      toggleFavorite: sl(),
      serviceRepository: sl(),
    ),
  );

  //! Domain Layer
  // Use cases - Lazy singletons for better performance
  sl.registerLazySingleton(() => GetServices(sl()));
  sl.registerLazySingleton(() => GetFavoriteServices(sl()));
  sl.registerLazySingleton(() => ToggleFavorite(sl()));

  // Repository - Abstract to concrete implementation
  sl.registerLazySingleton<ServiceRepository>(
        () => ServiceRepositoryImpl(
      localDataSource: sl(),
    ),
  );

  //! Data Layer
  // Data sources
  sl.registerLazySingleton<ServiceLocalDataSource>(
        () => ServiceLocalDataSourceImpl(
      servicesBox: sl<Box<ServiceModel>>(),
      favoritesBox: sl<Box<int>>(),
    ),
  );
}

/// Initialize Core dependencies
void _initCore() {
  // Register core utilities, constants, etc.
  // Example:
  // sl.registerLazySingleton<Logger>(() => Logger());
  // sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  print('🔧 Core dependencies registered');
}

/// Clean up resources when app is disposed
Future<void> dispose() async {
  try {
    print('🧹 Starting cleanup...');

    // Close all Hive boxes gracefully
    if (sl.isRegistered<Box<ServiceModel>>()) {
      await sl<Box<ServiceModel>>().close();
      print('📦 Services box closed');
    }

    if (sl.isRegistered<Box<int>>()) {
      await sl<Box<int>>().close();
      print('📦 Favorites box closed');
    }

    // Close Hive completely
    await Hive.close();
    print('🗃️ Hive closed');

    // Reset GetIt instance
    await sl.reset();
    print('♻️ GetIt reset');

    print('✅ Cleanup completed successfully');
  } catch (e) {
    // Log error but don't throw to avoid app crashes during disposal
    print('❌ Error during cleanup: $e');
  }
}

/// Check if dependencies are properly initialized
bool get isInitialized {
  try {
    return sl.isRegistered<ServicesCubit>() &&
        sl.isRegistered<ServiceRepository>() &&
        sl.isRegistered<Box<ServiceModel>>() &&
        sl.isRegistered<Box<int>>();
  } catch (e) {
    return false;
  }
}

/// Get initialization status details
Map<String, bool> get initializationStatus => {
  'ServicesCubit': sl.isRegistered<ServicesCubit>(),
  'ServiceRepository': sl.isRegistered<ServiceRepository>(),
  'ServicesBox': sl.isRegistered<Box<ServiceModel>>(),
  'FavoritesBox': sl.isRegistered<Box<int>>(),
  'GetServices': sl.isRegistered<GetServices>(),
  'GetFavoriteServices': sl.isRegistered<GetFavoriteServices>(),
  'ToggleFavorite': sl.isRegistered<ToggleFavorite>(),
};

/// Reset all dependencies (useful for testing)
Future<void> reset() async {
  try {
    await dispose();
    print('🔄 Dependencies reset successfully');
  } catch (e) {
    print('❌ Error during reset: $e');
    // Force reset GetIt even if disposal fails
    await sl.reset();
  }
}

/// Initialize dependencies for testing with mock data
Future<void> initForTesting({
  Box<ServiceModel>? mockServicesBox,
  Box<int>? mockFavoritesBox,
}) async {
  // Clear any existing registrations
  await reset();

  print('🧪 Initializing dependencies for testing...');

  // Initialize with mock boxes if provided, otherwise use real Hive
  if (mockServicesBox != null && mockFavoritesBox != null) {
    sl.registerLazySingleton<Box<ServiceModel>>(() => mockServicesBox);
    sl.registerLazySingleton<Box<int>>(() => mockFavoritesBox);
    print('🧪 Mock boxes registered');
  } else {
    await _initHive();
  }

  await _initServices();
  _initCore();

  print('✅ Testing dependencies initialized');
}

/// Verify all critical dependencies are available
void verifyDependencies() {
  final status = initializationStatus;
  final missingDependencies = status.entries
      .where((entry) => !entry.value)
      .map((entry) => entry.key)
      .toList();

  if (missingDependencies.isNotEmpty) {
    throw Exception(
        'Missing dependencies: ${missingDependencies.join(', ')}'
    );
  }

  print('✅ All dependencies verified successfully');
}
