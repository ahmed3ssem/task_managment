import 'package:equatable/equatable.dart';

abstract class Failures extends Equatable {
  final String msg;

  const Failures({required this.msg});

  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failures {
  final bool requiresOrderOverride;
  final String? errorCode;
  final double? minimumAmount;
  const ServerFailure({
    required super.msg,
    String? message,
    this.requiresOrderOverride = false,
    this.errorCode,
    this.minimumAmount,
  });

  @override
  List<Object?> get props => [
    msg,
    requiresOrderOverride,
    errorCode,
    minimumAmount,
  ];
}

class CashFailure extends Failures {
  const CashFailure({required super.msg});
}
