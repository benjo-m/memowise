// login exceptions
class UserNotFoundException implements Exception {}

// register exceptions
class EmailAlreadyInUseException implements Exception {}

class UsernameTakenException implements Exception {}

class InvalidEmailException implements Exception {}

class PasswordsNotMatching implements Exception {}

class WrongPasswordException implements Exception {}

// generic exceptions
class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}
