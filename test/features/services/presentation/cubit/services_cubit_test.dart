import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:favorite_services/core/error/failures.dart';
import 'package:favorite_services/core/usecases/usecase.dart';
import 'package:favorite_services/features/services/domain/entities/service.dart';
import 'package:favorite_services/features/services/domain/repositories/service_repository.dart';
import 'package:favorite_services/features/services/domain/usecases/get_favorite_services.dart';
import 'package:favorite_services/features/services/domain/usecases/get_services.dart';
import 'package:favorite_services/features/services/domain/usecases/toggle_favorite.dart';
import 'package:favorite_services/features/services/presentation/cubit/services_cubit.dart';
import 'package:favorite_services/features/services/presentation/cubit/services_state.dart';

class MockGetServices extends Mock implements GetServices {}
class MockGetFavoriteServices extends Mock implements GetFavoriteServices {}
class MockToggleFavorite extends Mock implements ToggleFavorite {}
class MockServiceRepository extends Mock implements ServiceRepository {}

void main() {
  late ServicesCubit cubit;
  late MockGetServices mockGetServices;
  late MockGetFavoriteServices mockGetFavoriteServices;
  late MockToggleFavorite mockToggleFavorite;
  late MockServiceRepository mockServiceRepository;

  setUp(() {
    mockGetServices = MockGetServices();
    mockGetFavoriteServices = MockGetFavoriteServices();
    mockToggleFavorite = MockToggleFavorite();
    mockServiceRepository = MockServiceRepository();

    cubit = ServicesCubit(
      getServices: mockGetServices,
      getFavoriteServices: mockGetFavoriteServices,
      toggleFavorite: mockToggleFavorite,
      serviceRepository: mockServiceRepository,
    );
  });

  tearDown(() {
    cubit.close();
  });

  const tAllServices = [
    Service(
      id: 1,
      name: 'Web Development',
      description: 'Build responsive websites with modern technologies',
      imageUrl: 'https://picsum.photos/200/200?random=1',
      price: 299.99,
      category: 'Development',
      isFavorite: false,
    ),
    Service(
      id: 2,
      name: 'Mobile App Development',
      description: 'Create native iOS and Android applications',
      imageUrl: 'https://picsum.photos/200/200?random=2',
      price: 499.99,
      category: 'Development',
      isFavorite: true,
    ),
    Service(
      id: 3,
      name: 'UI/UX Design',
      description: 'Design beautiful and user-friendly interfaces',
      imageUrl: 'https://picsum.photos/200/200?random=3',
      price: 199.99,
      category: 'Design',
      isFavorite: false,
    ),
  ];

  const tFavoriteServices = [
    Service(
      id: 2,
      name: 'Mobile App Development',
      description: 'Create native iOS and Android applications',
      imageUrl: 'https://picsum.photos/200/200?random=2',
      price: 499.99,
      category: 'Development',
      isFavorite: true,
    ),
  ];

  const tNonFavoriteService = Service(
    id: 1,
    name: 'Web Development',
    description: 'Build responsive websites with modern technologies',
    imageUrl: 'https://picsum.photos/200/200?random=1',
    price: 299.99,
    category: 'Development',
    isFavorite: false,
  );

  const tFavoriteService = Service(
    id: 2,
    name: 'Mobile App Development',
    description: 'Create native iOS and Android applications',
    imageUrl: 'https://picsum.photos/200/200?random=2',
    price: 499.99,
    category: 'Development',
    isFavorite: true,
  );

  group('ServicesCubit', () {
    test('initial state should be ServicesInitial', () {
      expect(cubit.state, ServicesInitial());
    });

    group('loadServices', () {
      blocTest<ServicesCubit, ServicesState>(
        'should emit [ServicesLoading, ServicesLoaded] when services and favorites load successfully',
        build: () {
          when(() => mockServiceRepository.initializeServices())
              .thenAnswer((_) async => const Right(unit));
          when(() => mockGetServices(any()))
              .thenAnswer((_) async => const Right(tAllServices));
          when(() => mockGetFavoriteServices(any()))
              .thenAnswer((_) async => const Right(tFavoriteServices));
          return cubit;
        },
        act: (cubit) => cubit.loadServices(),
        expect: () => [
          ServicesLoading(),
          const ServicesLoaded(
            allServices: tAllServices,
            favoriteServices: tFavoriteServices,
          ),
        ],
      );

      blocTest<ServicesCubit, ServicesState>(
        'should emit [ServicesLoading, ServicesError] when getting services fails',
        build: () {
          when(() => mockServiceRepository.initializeServices())
              .thenAnswer((_) async => const Right(unit));
          when(() => mockGetServices(any()))
              .thenAnswer((_) async => const Left(CacheFailure('Failed to load services from cache')));
          return cubit;
        },
        act: (cubit) => cubit.loadServices(),
        expect: () => [
          ServicesLoading(),
          const ServicesError('Storage Error: Failed to load services from cache'),
        ],
      );

      blocTest<ServicesCubit, ServicesState>(
        'should emit [ServicesLoading, ServicesError] when getting favorites fails',
        build: () {
          when(() => mockServiceRepository.initializeServices())
              .thenAnswer((_) async => const Right(unit));
          when(() => mockGetServices(any()))
              .thenAnswer((_) async => const Right(tAllServices));
          when(() => mockGetFavoriteServices(any()))
              .thenAnswer((_) async => const Left(CacheFailure('Failed to load favorites from cache')));
          return cubit;
        },
        act: (cubit) => cubit.loadServices(),
        expect: () => [
          ServicesLoading(),
          const ServicesError('Storage Error: Failed to load favorites from cache'),
        ],
      );

      blocTest<ServicesCubit, ServicesState>(
        'should emit [ServicesLoading, ServicesError] when initialization fails',
        build: () {
          when(() => mockServiceRepository.initializeServices())
              .thenAnswer((_) async => const Left(CacheFailure('Failed to initialize services')));
          when(() => mockGetServices(any()))
              .thenAnswer((_) async => const Right(tAllServices));
          when(() => mockGetFavoriteServices(any()))
              .thenAnswer((_) async => const Right(tFavoriteServices));
          return cubit;
        },
        act: (cubit) => cubit.loadServices(),
        expect: () => [
          ServicesLoading(),
          const ServicesError('Storage Error: Failed to initialize services'),
        ],
      );

      blocTest<ServicesCubit, ServicesState>(
        'should emit [ServicesLoading, ServicesError] when DataFailure occurs',
        build: () {
          when(() => mockServiceRepository.initializeServices())
              .thenAnswer((_) async => const Right(unit));
          when(() => mockGetServices(any()))
              .thenAnswer((_) async => const Left(DataFailure('Unexpected error occurred')));
          return cubit;
        },
        act: (cubit) => cubit.loadServices(),
        expect: () => [
          ServicesLoading(),
          const ServicesError('Data Error: Unexpected error occurred'),
        ],
      );

      blocTest<ServicesCubit, ServicesState>(
        'should handle empty services list correctly',
        build: () {
          when(() => mockServiceRepository.initializeServices())
              .thenAnswer((_) async => const Right(unit));
          when(() => mockGetServices(any()))
              .thenAnswer((_) async => const Right(<Service>[]));
          when(() => mockGetFavoriteServices(any()))
              .thenAnswer((_) async => const Right(<Service>[]));
          return cubit;
        },
        act: (cubit) => cubit.loadServices(),
        expect: () => [
          ServicesLoading(),
          const ServicesLoaded(
            allServices: <Service>[],
            favoriteServices: <Service>[],
          ),
        ],
      );
    });

    group('toggleServiceFavorite', () {
      blocTest<ServicesCubit, ServicesState>(
        'should reload services after successfully toggling non-favorite service',
        build: () {
          when(() => mockToggleFavorite(any()))
              .thenAnswer((_) async => const Right(unit));
          when(() => mockServiceRepository.initializeServices())
              .thenAnswer((_) async => const Right(unit));
          when(() => mockGetServices(any()))
              .thenAnswer((_) async => const Right(tAllServices));
          when(() => mockGetFavoriteServices(any()))
              .thenAnswer((_) async => const Right(tFavoriteServices));
          return cubit;
        },
        act: (cubit) => cubit.toggleServiceFavorite(tNonFavoriteService),
        expect: () => [
          ServicesLoading(),
          const ServicesLoaded(
            allServices: tAllServices,
            favoriteServices: tFavoriteServices,
          ),
        ],
      );

      blocTest<ServicesCubit, ServicesState>(
        'should reload services after successfully toggling favorite service',
        build: () {
          when(() => mockToggleFavorite(any()))
              .thenAnswer((_) async => const Right(unit));
          when(() => mockServiceRepository.initializeServices())
              .thenAnswer((_) async => const Right(unit));
          when(() => mockGetServices(any()))
              .thenAnswer((_) async => const Right(tAllServices));
          when(() => mockGetFavoriteServices(any()))
              .thenAnswer((_) async => const Right(<Service>[]));
          return cubit;
        },
        act: (cubit) => cubit.toggleServiceFavorite(tFavoriteService),
        expect: () => [
          ServicesLoading(),
          const ServicesLoaded(
            allServices: tAllServices,
            favoriteServices: <Service>[],
          ),
        ],
      );

      blocTest<ServicesCubit, ServicesState>(
        'should emit ServicesError when toggle fails with CacheFailure',
        build: () {
          when(() => mockToggleFavorite(any()))
              .thenAnswer((_) async => const Left(CacheFailure('Failed to toggle favorite in cache')));
          return cubit;
        },
        act: (cubit) => cubit.toggleServiceFavorite(tNonFavoriteService),
        expect: () => [
          const ServicesError('Storage Error: Failed to toggle favorite in cache'),
        ],
      );

      blocTest<ServicesCubit, ServicesState>(
        'should emit ServicesError when toggle fails with DataFailure',
        build: () {
          when(() => mockToggleFavorite(any()))
              .thenAnswer((_) async => const Left(DataFailure('Unexpected error during toggle')));
          return cubit;
        },
        act: (cubit) => cubit.toggleServiceFavorite(tFavoriteService),
        expect: () => [
          const ServicesError('Data Error: Unexpected error during toggle'),
        ],
      );

      blocTest<ServicesCubit, ServicesState>(
        'should pass correct ToggleFavoriteParams to use case',
        build: () {
          when(() => mockToggleFavorite(any()))
              .thenAnswer((_) async => const Right(unit));
          when(() => mockServiceRepository.initializeServices())
              .thenAnswer((_) async => const Right(unit));
          when(() => mockGetServices(any()))
              .thenAnswer((_) async => const Right(tAllServices));
          when(() => mockGetFavoriteServices(any()))
              .thenAnswer((_) async => const Right(tFavoriteServices));
          return cubit;
        },
        act: (cubit) => cubit.toggleServiceFavorite(tNonFavoriteService),
        verify: (cubit) {
          verify(() => mockToggleFavorite(const ToggleFavoriteParams(service: tNonFavoriteService)));
        },
      );
    });

    group('refreshServices', () {
      blocTest<ServicesCubit, ServicesState>(
        'should call loadServices when refreshServices is called',
        build: () {
          when(() => mockServiceRepository.initializeServices())
              .thenAnswer((_) async => const Right(unit));
          when(() => mockGetServices(any()))
              .thenAnswer((_) async => const Right(tAllServices));
          when(() => mockGetFavoriteServices(any()))
              .thenAnswer((_) async => const Right(tFavoriteServices));
          return cubit;
        },
        act: (cubit) => cubit.refreshServices(),
        expect: () => [
          ServicesLoading(),
          const ServicesLoaded(
            allServices: tAllServices,
            favoriteServices: tFavoriteServices,
          ),
        ],
      );
    });

    group('_mapFailureToMessage', () {
      test('should return correct message for CacheFailure', () {
        // This is tested implicitly in the other tests, but we can verify behavior
        const failure = CacheFailure('Cache error');
        // The method is private, so we test through public methods
        expect(failure.message, 'Cache error');
      });

      test('should return correct message for DataFailure', () {
        const failure = DataFailure('Data error');
        expect(failure.message, 'Data error');
      });
    });

    group('state transitions', () {
      blocTest<ServicesCubit, ServicesState>(
        'should handle multiple sequential operations correctly',
        build: () {
          when(() => mockServiceRepository.initializeServices())
              .thenAnswer((_) async => const Right(unit));
          when(() => mockGetServices(any()))
              .thenAnswer((_) async => const Right(tAllServices));
          when(() => mockGetFavoriteServices(any()))
              .thenAnswer((_) async => const Right(tFavoriteServices));
          when(() => mockToggleFavorite(any()))
              .thenAnswer((_) async => const Right(unit));
          return cubit;
        },
        act: (cubit) async {
          await cubit.loadServices();
          await cubit.toggleServiceFavorite(tNonFavoriteService);
          cubit.refreshServices();
        },
        expect: () => [
          // First loadServices
          ServicesLoading(),
          const ServicesLoaded(
            allServices: tAllServices,
            favoriteServices: tFavoriteServices,
          ),
          // toggleServiceFavorite
          ServicesLoading(),
          const ServicesLoaded(
            allServices: tAllServices,
            favoriteServices: tFavoriteServices,
          ),
          // refreshServices
          ServicesLoading(),
          const ServicesLoaded(
            allServices: tAllServices,
            favoriteServices: tFavoriteServices,
          ),
        ],
      );
    });
  });
}