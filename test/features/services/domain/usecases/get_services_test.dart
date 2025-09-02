import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:favorite_services/core/error/failures.dart';
import 'package:favorite_services/core/usecases/usecase.dart';
import 'package:favorite_services/features/services/domain/entities/service.dart';
import 'package:favorite_services/features/services/domain/repositories/service_repository.dart';
import 'package:favorite_services/features/services/domain/usecases/get_services.dart';

class MockServiceRepository extends Mock implements ServiceRepository {}

void main() {
  late GetServices usecase;
  late MockServiceRepository mockServiceRepository;

  setUp(() {
    mockServiceRepository = MockServiceRepository();
    usecase = GetServices(mockServiceRepository);
  });

  const tServices = [
    Service(
      id: 1,
      name: 'Web Development',
      description: 'Build responsive websites with modern technologies',
      imageUrl: 'https://picsum.photos/200/200?random=1',
      price: 299.99,
      category: 'Development',
    ),
    Service(
      id: 2,
      name: 'Mobile App Development',
      description: 'Create native iOS and Android applications',
      imageUrl: 'https://picsum.photos/200/200?random=2',
      price: 499.99,
      category: 'Development',
    ),
    Service(
      id: 3,
      name: 'UI/UX Design',
      description: 'Design beautiful and user-friendly interfaces',
      imageUrl: 'https://picsum.photos/200/200?random=3',
      price: 199.99,
      category: 'Design',
      isFavorite: true,
    ),
  ];

  group('GetServices', () {
    test('should get services from the repository when call is successful', () async {
      // arrange
      when(() => mockServiceRepository.getServices())
          .thenAnswer((_) async => const Right(tServices));

      // act
      final result = await usecase(NoParams());

      // assert
      expect(result, const Right(tServices));
      verify(() => mockServiceRepository.getServices());
      verifyNoMoreInteractions(mockServiceRepository);
    });

    test('should return CacheFailure when repository call fails with cache error', () async {
      // arrange
      const tFailure = CacheFailure('Failed to load services from cache');
      when(() => mockServiceRepository.getServices())
          .thenAnswer((_) async => const Left(tFailure));

      // act
      final result = await usecase(NoParams());

      // assert
      expect(result, const Left(tFailure));
      verify(() => mockServiceRepository.getServices());
      verifyNoMoreInteractions(mockServiceRepository);
    });

    test('should return DataFailure when repository call fails with data error', () async {
      // arrange
      const tFailure = DataFailure('Unexpected error occurred');
      when(() => mockServiceRepository.getServices())
          .thenAnswer((_) async => const Left(tFailure));

      // act
      final result = await usecase(NoParams());

      // assert
      expect(result, const Left(tFailure));
      verify(() => mockServiceRepository.getServices());
      verifyNoMoreInteractions(mockServiceRepository);
    });

    test('should return empty list when no services are available', () async {
      // arrange
      when(() => mockServiceRepository.getServices())
          .thenAnswer((_) async => const Right(<Service>[]));

      // act
      final result = await usecase(NoParams());

      // assert
      expect(result, const Right(<Service>[]));
      verify(() => mockServiceRepository.getServices());
      verifyNoMoreInteractions(mockServiceRepository);
    });

    test('should return services with favorite status correctly set', () async {
      // arrange
      final servicesWithFavorites = [
        tServices[0], // Not favorite
        tServices[1], // Not favorite
        tServices[2], // Is favorite
      ];
      when(() => mockServiceRepository.getServices())
          .thenAnswer((_) async => Right(servicesWithFavorites));

      // act
      final result = await usecase(NoParams());

      // assert
      result.fold(
            (failure) => fail('Should return success'),
            (services) {
          expect(services.length, 3);
          expect(services[0].isFavorite, false);
          expect(services[1].isFavorite, false);
          expect(services[2].isFavorite, true);
        },
      );
      verify(() => mockServiceRepository.getServices());
      verifyNoMoreInteractions(mockServiceRepository);
    });

    test('should call repository only once per usecase execution', () async {
      // arrange
      when(() => mockServiceRepository.getServices())
          .thenAnswer((_) async => const Right(tServices));

      // act
      await usecase(NoParams());
      await usecase(NoParams());

      // assert
      verify(() => mockServiceRepository.getServices()).called(2);
      verifyNoMoreInteractions(mockServiceRepository);
    });
  });
}