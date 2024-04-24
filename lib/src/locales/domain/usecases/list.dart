import 'package:dartz/dartz.dart';
import 'package:evangelism_admin/shared/usecase/usecase.dart';
import 'package:evangelism_admin/src/locales/domain/entities/locales.dart';
import 'package:evangelism_admin/src/locales/domain/repositories/locale_repository.dart';

import '../../../../shared/error/failure.dart';

class ListLocales implements UseCase<List<Locales>, NoParams> {
  final LocaleRepository repository;

  ListLocales(this.repository);

  @override
  Future<Either<Failure, List<Locales>>> call(NoParams params) async {
    return repository.listLocales();
  }
}
