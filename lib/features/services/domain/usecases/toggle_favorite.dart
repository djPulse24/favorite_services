import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/service.dart';
import '../repositories/service_repository.dart';

class ToggleFavorite implements UseCase<Unit, ToggleFavoriteParams> {
  final ServiceRepository repository;

  ToggleFavorite(this.repository);

  @override
  Future<Either<Failure, Unit>> call(ToggleFavoriteParams params) async {
    return await repository.toggleFavorite(params.service);
  }
}

class ToggleFavoriteParams extends Equatable {
  final Service service;

  const ToggleFavoriteParams({required this.service});

  @override
  List<Object> get props => [service];
}