import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/service.dart';
import '../repositories/service_repository.dart';

class GetServices implements UseCase<List<Service>, NoParams> {
  final ServiceRepository repository;

  GetServices(this.repository);

  @override
  Future<Either<Failure, List<Service>>> call(NoParams params) async {
    return await repository.getServices();
  }
}