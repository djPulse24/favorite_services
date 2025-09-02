import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:favorite_services/core/error/exceptions.dart';
import 'package:favorite_services/core/error/failures.dart';
import 'package:favorite_services/features/services/data/datasources/service_local_data_source.dart';
import 'package:favorite_services/features/services/data/models/service_model.dart';
import 'package:favorite_services/features/services/data/repositories/service_repository_impl.dart';
import 'package:favorite_services/features/services/domain/entities/service.dart';

class MockLocalDataSource extends Mock implements ServiceLocalDataSource {}

void main() {
  late ServiceRepositoryImpl repository;
  late MockLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockLocalDataSource();
    repository = ServiceRepositoryImpl(
      localDataSource: mockLocalDataSource,
    );
  });

  group('getServices', () {
    final tServiceModels = [
      ServiceModel(
        id: 1,
        name: 'Web Development',
        description: 'Build responsive websites',
        imageUrl: 'https://picsum.photos/200/200?random=1',
        price: 299.99,
        category: 'Development',
      ),
      ServiceModel(
        id: 2,
        name: 'Mobile App Development',
        description: 'Create mobile applications',
        imageUrl: 'https://picsum.photos/200/200?random=2',
        price: 499.99,
        category: 'Development',
      ),
    ];

    final tServices = [
      Service(
        id: 1,
        name: 'Web Development',
        description: 'Build responsive websites',
        imageUrl: 'https://picsum.photos/200/200?random=1',
        price: 299.99,
        category: 'Development',
        isFavorite: true,
      ),
      Service(
        id: 2,
        name: 'Mobile App Development',
        description: 'Create mobile applications',
        imageUrl: 'https://picsum.photos/200/200?random=2',
        price: 499.99,
        category: 'Development',
        isFavorite: false,
      ),
    ];

    test('should return services with favorite status when call is successful', () async {
      // arrange
      when(() => mockLocalDataSource.getServices())
          .thenAnswer((_) async => tServiceModels);
      when(() => mockLocalDataSource.getFavoriteIds())
          .thenAnswer((_) async => [1]);

      // act
      final result = await repository.getServices();

      // assert
      verify(() => mockLocalDataSource.getServices());
      verify(() => mockLocalDataSource.getFavoriteIds());
      expect(result, equals(Right(tServices)));
    });

    test('should return cache failure when getting services fails', () async {
      // arrange
      when(() => mockLocalDataSource.getServices())
          .thenThrow(const CacheException('Failed to get services'));

      // act
      final result = await repository.getServices();

      // assert
      verify(() => mockLocalDataSource.getServices());
      expect(result, equals(const Left(CacheFailure('Failed to get services'))));
    });

    test('should return cache failure when getting favorites fails', () async {
      // arrange
      when(() => mockLocalDataSource.getServices())
          .thenAnswer((_) async => tServiceModels);
      when(() => mockLocalDataSource.getFavoriteIds())
          .thenThrow(const CacheException('Failed to get favorites'));

      // act
      final result = await repository.getServices();

      // assert
      verify(() => mockLocalDataSource.getServices());
      verify(() => mockLocalDataSource.getFavoriteIds());
      expect(result, equals(const Left(CacheFailure('Failed to get favorites'))));
    });

    test('should return data failure when unexpected error occurs', () async {
      // arrange
      when(() => mockLocalDataSource.getServices())
          .thenThrow(Exception('Unexpected error'));

      // act
      final result = await repository.getServices();

      // assert
      expect(result.isLeft(), isTrue);
      result.fold(
            (failure) => expect(failure, isA<DataFailure>()),
            (_) => fail('Should return failure'),
      );
    });
  });

  group('toggleFavorite', () {
    const tService = Service(
      id: 1,
      name: 'Web Development',
      description: 'Build responsive websites',
      imageUrl: 'https://picsum.photos/200/200?random=1',
      price: 299.99,
      category: 'Development',
      isFavorite: false,
    );

    test('should add favorite when service is not favorited', () async {
      // arrange
      when(() => mockLocalDataSource.addFavorite(any()))
          .thenAnswer((_) async {});

      // act
      final result = await repository.toggleFavorite(tService);

      // assert
      verify(() => mockLocalDataSource.addFavorite(1));
      expect(result, equals(const Right(unit)));
    });

    test('should remove favorite when service is favorited', () async {
      // arrange
      const tFavoriteService = Service(
        id: 1,
        name: 'Web Development',
        description: 'Build responsive websites',
        imageUrl: 'https://picsum.photos/200/200?random=1',
        price: 299.99,
        category: 'Development',
        isFavorite: true,
      );
      when(() => mockLocalDataSource.removeFavorite(any()))
          .thenAnswer((_) async {});

      // act
      final result = await repository.toggleFavorite(tFavoriteService);

      // assert
      verify(() => mockLocalDataSource.removeFavorite(1));
      expect(result, equals(const Right(unit)));
    });

    test('should return cache failure when add favorite fails', () async {
      // arrange
      when(() => mockLocalDataSource.addFavorite(any()))
          .thenThrow(const CacheException('Failed to add favorite'));

      // act
      final result = await repository.toggleFavorite(tService);

      // assert
      expect(result, equals(const Left(CacheFailure('Failed to add favorite'))));
    });

    test('should return cache failure when remove favorite fails', () async {
      // arrange
      const tFavoriteService = Service(
        id: 1,
        name: 'Web Development',
        description: 'Build responsive websites',
        imageUrl: 'https://picsum.photos/200/200?random=1',
        price: 299.99,
        category: 'Development',
        isFavorite: true,
      );
      when(() => mockLocalDataSource.removeFavorite(any()))
          .thenThrow(const CacheException('Failed to remove favorite'));

      // act
      final result = await repository.toggleFavorite(tFavoriteService);

      // assert
      expect(result, equals(const Left(CacheFailure('Failed to remove favorite'))));
    });

    test('should return data failure when unexpected error occurs', () async {
      // arrange
      when(() => mockLocalDataSource.addFavorite(any()))
          .thenThrow(Exception('Unexpected error'));

      // act
      final result = await repository.toggleFavorite(tService);

      // assert
      expect(result.isLeft(), isTrue);
      result.fold(
            (failure) => expect(failure, isA<DataFailure>()),
            (_) => fail('Should return failure'),
      );
    });
  });

  group('getFavoriteServices', () {
    final tServiceModels = [
      ServiceModel(
        id: 1,
        name: 'Web Development',
        description: 'Build responsive websites',
        imageUrl: 'https://picsum.photos/200/200?random=1',
        price: 299.99,
        category: 'Development',
      ),
      ServiceModel(
        id: 2,
        name: 'Mobile App Development',
        description: 'Create mobile applications',
        imageUrl: 'https://picsum.photos/200/200?random=2',
        price: 499.99,
        category: 'Development',
      ),
    ];

    final tFavoriteServices = [
      Service(
        id: 1,
        name: 'Web Development',
        description: 'Build responsive websites',
        imageUrl: 'https://picsum.photos/200/200?random=1',
        price: 299.99,
        category: 'Development',
        isFavorite: true,
      ),
    ];

    test('should return favorite services when call is successful', () async {
      // arrange
      when(() => mockLocalDataSource.getFavoriteIds())
          .thenAnswer((_) async => [1]);
      when(() => mockLocalDataSource.getServices())
          .thenAnswer((_) async => tServiceModels);

      // act
      final result = await repository.getFavoriteServices();

      // assert
      verify(() => mockLocalDataSource.getFavoriteIds());
      verify(() => mockLocalDataSource.getServices());
      expect(result, equals(Right(tFavoriteServices)));
    });

    test('should return empty list when no favorites exist', () async {
      // arrange
      when(() => mockLocalDataSource.getFavoriteIds())
          .thenAnswer((_) async => []);
      when(() => mockLocalDataSource.getServices())
          .thenAnswer((_) async => tServiceModels);

      // act
      final result = await repository.getFavoriteServices();

      // assert
      verify(() => mockLocalDataSource.getFavoriteIds());
      verify(() => mockLocalDataSource.getServices());
      expect(result, equals(const Right(<Service>[])));
    });

    test('should return cache failure when getting favorite ids fails', () async {
      // arrange
      when(() => mockLocalDataSource.getFavoriteIds())
          .thenThrow(const CacheException('Failed to get favorite ids'));

      // act
      final result = await repository.getFavoriteServices();

      // assert
      expect(result, equals(const Left(CacheFailure('Failed to get favorite ids'))));
    });
  });

  group('initializeServices', () {
    test('should initialize services successfully', () async {
      // arrange
      when(() => mockLocalDataSource.initializeServices())
          .thenAnswer((_) async {});

      // act
      final result = await repository.initializeServices();

      // assert
      verify(() => mockLocalDataSource.initializeServices());
      expect(result, equals(const Right(unit)));
    });

    test('should return cache failure when initialization fails', () async {
      // arrange
      when(() => mockLocalDataSource.initializeServices())
          .thenThrow(const CacheException('Failed to initialize services'));

      // act
      final result = await repository.initializeServices();

      // assert
      expect(result, equals(const Left(CacheFailure('Failed to initialize services'))));
    });

    test('should return data failure when unexpected error occurs during initialization', () async {
      // arrange
      when(() => mockLocalDataSource.initializeServices())
          .thenThrow(Exception('Unexpected error'));

      // act
      final result = await repository.initializeServices();

      // assert
      expect(result.isLeft(), isTrue);
      result.fold(
            (failure) => expect(failure, isA<DataFailure>()),
            (_) => fail('Should return failure'),
      );
    });
  });
}