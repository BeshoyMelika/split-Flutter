part of 'otp_verification_bloc.dart';

abstract class OtpVerificationEvent extends Equatable {}

class OtpVerifyEvent extends OtpVerificationEvent {
  final String pinCode;

  OtpVerifyEvent({required this.pinCode});

  @override
  List<Object?> get props => [pinCode];
}

class OtpRequestAgainEvent extends OtpVerificationEvent {
  @override
  List<Object?> get props => [];
}

class ValidateOtpVerificationFormEvent extends OtpVerificationEvent {
  final GlobalKey<FormState> formKey;

  ValidateOtpVerificationFormEvent({required this.formKey});

  @override
  List<Object?> get props => [formKey];
}
