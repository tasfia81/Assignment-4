enum AppErrorType {
  malformedLink,
  missingToken,
  expiredToken,
  invalidToken,
  redeemedToken,
  networkError,
  unknownError,
}

class AppError {
  final AppErrorType type;
  final String message;

  AppError(this.type, this.message);

  factory AppError.fromType(AppErrorType type) {
    switch (type) {
      case AppErrorType.malformedLink:
        return AppError(type, "The link format is malformed or invalid.");
      case AppErrorType.missingToken:
        return AppError(type, "The request is missing a valid security token.");
      case AppErrorType.expiredToken:
        return AppError(type, "This secure access pass token has expired.");
      case AppErrorType.invalidToken:
        return AppError(type, "This secure access pass token is invalid.");
      case AppErrorType.redeemedToken:
        return AppError(type, "This pass token has already been used/redeemed.");
      case AppErrorType.networkError:
        return AppError(type, "Failed to connect to the secure pass server.");
      case AppErrorType.unknownError:
        return AppError(type, "An unknown secure token error occurred.");
    }
  }

  @override
  String toString() => message;
}
