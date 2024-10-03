import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wealth/features/profile/requests/requests.dart';
import 'features/authentication/models/SignUp.dart';

final userSignIn = StateProvider<UserSignUp?>((ref) => null);

final profile = FutureProvider<UserSignUp?>((ref) async {
  return fetchProfile();
});
