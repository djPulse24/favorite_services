import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:favorite_services/core/error/failures.dart';
import 'package:favorite_services/features/services/domain/entities/service.dart';
import 'package:favorite_services/features/services/domain/repositories/service_repository.dart';
import 'package:favorite_services/features/services/domain/usecases/toggle_favorite.dart';

class MockServiceRepository extends Mock implements ServiceRepository {}

void main() {
  late ToggleFavorite usecase;
  late MockServiceRepository mockServiceRepository;

  setUp(() {
    mockServiceRepository = MockServiceRepository();
    usecase = ToggleFavorite(mockServiceRepository);
  });

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

  group('ToggleFavorite', () {
    test('should toggle favorite status from false to true in the repository', () async {
      // arrange
      when(() => mockServiceRepository.toggleFavorite(any()))
          .thenAnswer((_) async => const Right(unit));

      // act
      final result = await usecase(const ToggleFavoriteParams(service: tNonFavoriteService));

      // assert
      expect(result, const Right(unit));
      verify(() => mockServiceRepository.toggleFavorite(tNonFavoriteService));
      verifyNoMoreInteractions(mockServiceRepository);
    });

    test('should toggle favorite status from true to false in the repository', () async {
      // arrange
      when(() => mockServiceRepository.toggleFavorite(any()))
          .thenAnswer((_) async => const Right(unit));

      // act
      final result = await usecase(const ToggleFavoriteParams(service: tFavoriteService));

      // assert
      expect(result, const Right(unit));
      verify(() => mockServiceRepository.toggleFavorite(tFavoriteService));
      verifyNoMoreInteractions(mockServiceRepository);
    });

    test('should return CacheFailure when repository toggle fails with cache error', () async {
      // arrange
      const tFailure = CacheFailure('Failed to toggle favorite in cache');
      when(() => mockServiceRepository.toggleFavorite(any()))
          .thenAnswer((_) async => const Left(tFailure));

      // act
      final result = await usecase(const ToggleFavoriteParams(service: tNonFavoriteService));

      // assert
      expect(result, const Left(tFailure));
      verify(() => mockServiceRepository.toggleFavorite(tNonFavoriteService));
      verifyNoMoreInteractions(mockServiceRepository);
    });

    test('should return DataFailure when repository toggle fails with data error', () async {
      // arrange
      const tFailure = DataFailure('Unexpected error during toggle operation');
      when(() => mockServiceRepository.toggleFavorite(any()))
          .thenAnswer((_) async => const Left(tFailure));

      // act
      final result = await usecase(const ToggleFavoriteParams(service: tFavoriteService));

      // assert
      expect(result, const Left(tFailure));
      verify(() => mockServiceRepository.toggleFavorite(tFavoriteService));
      verifyNoMoreInteractions(mockServiceRepository);
    });

    test('should pass the correct service to repository regardless of favorite status', () async {
      // arrange
      when(() => mockServiceRepository.toggleFavorite(any()))
          .thenAnswer((_) async => const Right(unit));

      const testService = Service(
        id: 99,
        name: 'Custom Service',
        description: 'Custom description for testing',
        imageUrl: 'https://picsum.photos/200/200?random=99',
        price: 99.99,
        category: 'Testing',
        isFavorite: false,
      );

      // act
      final result = await usecase(const ToggleFavoriteParams(service: testService));

      // assert
      expect(result, const Right(unit));
      verify(() => mockServiceRepository.toggleFavorite(testService));
      verifyNoMoreInteractions(mockServiceRepository);
    });

    test('should handle multiple toggle operations correctly', () async {
      // arrange
      when(() => mockServiceRepository.toggleFavorite(any()))
          .thenAnswer((_) async => const Right(unit));

      // act
      final result1 = await usecase(const ToggleFavoriteParams(service: tNonFavoriteService));
      final result2 = await usecase(const ToggleFavoriteParams(service: tFavoriteService));

      // assert
      expect(result1, const Right(unit));
      expect(result2, const Right(unit));
      verify(() => mockServiceRepository.toggleFavorite(tNonFavoriteService));
      verify(() => mockServiceRepository.toggleFavorite(tFavoriteService));
      verifyNoMoreInteractions(mockServiceRepository);
    });

    group('ToggleFavoriteParams', () {
      test('should be equal when services are the same', () {
        // arrange
        const params1 = ToggleFavoriteParams(service: tNonFavoriteService);
        const params2 = ToggleFavoriteParams(service: tNonFavoriteService);

        // assert
        expect(params1, equals(params2));
        expect(params1.hashCode, equals(params2.hashCode));
      });

      test('should not be equal when services are different', () {
        // arrange
        const params1 = ToggleFavoriteParams(service: tNonFavoriteService);
        const params2 = ToggleFavoriteParams(service: tFavoriteService);

        // assert
        expect(params1, isNot(equals(params2)));
        expect(params1.hashCode, isNot(equals(params2.hashCode)));
      });

      test('should include service in props for equality comparison', () {
        // arrange
        const params = ToggleFavoriteParams(service: tNonFavoriteService);

        // assert
        expect(params.props, contains(tNonFavoriteService));
        expect(params.props.length, equals(1));
      });
    });
  });
}