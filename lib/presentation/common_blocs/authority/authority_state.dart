part of 'authority_bloc.dart';

/// Authority status used the success or failure of the authority loading.
enum AuthorityStatus { initial, loading, success, failure }

/// Authority state that contains the current authority and the status of the authority.
/// The status is used to display the loading indicator.
///
/// The state is immutable and copyWith is used to update the state.
class AuthorityState extends Equatable {
  final List? authorities;
  final AuthorityStatus status;

  const AuthorityState({
    this.authorities,
    this.status = AuthorityStatus.initial,
  });

  AuthorityState copyWith({
    List? authorities,
    AuthorityStatus? status,
  }) {
    return AuthorityState(status: status ?? this.status, authorities: authorities ?? authorities);
  }

  @override
  List<Object> get props => [status, authorities ?? []];

  @override
  bool get stringify => true;
}

class AuthorityInitialState extends AuthorityState {}

class AuthorityLoadInProgressState extends AuthorityState {}

class AuthorityLoadSuccessState extends AuthorityState {
  const AuthorityLoadSuccessState({required List authorities}) : super(authorities: authorities, status: AuthorityStatus.success);
}

class AuthorityLoadFailureState extends AuthorityState {
  final String message;

  const AuthorityLoadFailureState({required this.message});
}