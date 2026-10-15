import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failures, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}

class ObjectParams extends Equatable {
  final Map<String, dynamic> params;

  const ObjectParams({required this.params});

  @override
  List<Object?> get props => [params];
}

class StringParams extends Equatable {
  final String params;

  const StringParams({required this.params});

  @override
  List<Object?> get props => [params];
}

class IntParams extends Equatable {
  final int params;

  const IntParams({required this.params});

  @override
  List<Object?> get props => [params];
}
