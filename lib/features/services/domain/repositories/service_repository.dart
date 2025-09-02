import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/service.dart';

abstract class ServiceRepository {
  Future<Either<Failure, List<Service>>> getServices();
  Future<Either<Failure, Unit>> toggleFavorite(Service service);
  Future<Either<Failure, List<Service>>> getFavoriteServices();
  Future<Either<Failure, Unit>> initializeServices();
}