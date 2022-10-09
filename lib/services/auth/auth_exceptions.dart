//Login Exceptions
class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

//Register Exceptions
class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

//Generic Exceptions
class ConnectionFailedAuthException implements Exception {}

class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}

class PasswordResetAuthException implements Exception {}

class AccoundDeletionAuthException implements Exception {}
