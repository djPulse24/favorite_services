import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/service.dart';
import '../../domain/usecases/get_favorite_services.dart';
import '../../domain/usecases/get_services.dart';
import '../../domain/usecases/toggle_favorite.dart';
import '../../domain/repositories/service_repository.dart';
import 'services_state.dart';

class ServicesCubit extends Cubit<ServicesState> {
  final GetServices getServices;
  final GetFavoriteServices getFavoriteServices;
  final ToggleFavorite toggleFavorite;
  final ServiceRepository serviceRepository;

  ServicesCubit({
    required this.getServices,
    required this.getFavoriteServices,
    required this.toggleFavorite,
    required this.serviceRepository,
  }) : super(ServicesInitial());

  Future<void> loadServices() async {
    emit(ServicesLoading());

    // Initialize services if needed (first time)
    await serviceRepository.initializeServices();

    final servicesResult = await getServices(NoParams());

    servicesResult.fold(
          (failure) => emit(ServicesError(_mapFailureToMessage(failure))),
          (services) async {
        final favoritesResult = await getFavoriteServices(NoParams());
        favoritesResult.fold(
              (failure) => emit(ServicesError(_mapFailureToMessage(failure))),
              (favorites) => emit(ServicesLoaded(
            allServices: services,
            favoriteServices: favorites,
          )),
        );
      },
    );
  }

  Future<void> toggleServiceFavorite(Service service) async {
    final result = await toggleFavorite(
      ToggleFavoriteParams(service: service),
    );

    result.fold(
          (failure) => emit(ServicesError(_mapFailureToMessage(failure))),
          (_) {
        // Reload services to get updated state
        loadServices();
      },
    );
  }

  void refreshServices() {
    loadServices();
  }

  String _mapFailureToMessage(failure) {
    switch (failure.runtimeType) {
      case CacheFailure:
        return 'Storage Error: ${failure.message}';
      case DataFailure:
        return 'Data Error: ${failure.message}';
      default:
        return 'Unexpected Error: ${failure.message}';
    }
  }
}