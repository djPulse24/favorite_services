import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/service.dart';
import '../../domain/repositories/service_repository.dart';
import '../datasources/service_local_data_source.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceLocalDataSource localDataSource;

  ServiceRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Service>>> getServices() async {
    try {
      final serviceModels = await localDataSource.getServices();
      final favoriteIds = await localDataSource.getFavoriteIds();

      final services = serviceModels.map((model) {
        return model.toEntity(isFavorite: favoriteIds.contains(model.id));
      }).toList();

      return Right(services);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(DataFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> toggleFavorite(Service service) async {
    try {
      if (service.isFavorite) {
        await localDataSource.removeFavorite(service.id);
      } else {
        await localDataSource.addFavorite(service.id);
      }
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(DataFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Service>>> getFavoriteServices() async {
    try {
      final favoriteIds = await localDataSource.getFavoriteIds();
      final serviceModels = await localDataSource.getServices();

      final favoriteServices = serviceModels
          .where((model) => favoriteIds.contains(model.id))
          .map((model) => model.toEntity(isFavorite: true))
          .toList();

      return Right(favoriteServices);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(DataFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> initializeServices() async {
    try {
      await localDataSource.initializeServices();
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(DataFailure('Unexpected error: $e'));
    }
  }
}
