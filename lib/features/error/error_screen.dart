import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/errors/app_error.dart';
import '../../core/theme/app_colors.dart';

class DeepLinkErrorScreen extends StatelessWidget {
  final String errorTypeName;

  const DeepLinkErrorScreen({
    super.key,
    required this.errorTypeName,
  });

  @override
  Widget build(BuildContext context) {
    AppErrorType errorType;
    try {
      errorType = AppErrorType.values.firstWhere(
        (e) => e.toString().split('.').last == errorTypeName,
      );
    } catch (_) {
      errorType = AppErrorType.unknownError;
    }

    final appError = AppError.fromType(errorType);

    String explanation;
    switch (errorType) {
      case AppErrorType.malformedLink:
        explanation =
            "The security URL is formatted incorrectly. Please request a new pass download link.";
        break;
      case AppErrorType.missingToken:
        explanation =
            "The link did not contain a security pass token. Ensure you clicked the complete URL.";
        break;
      case AppErrorType.expiredToken:
        explanation =
            "Secure pass tokens expire after a set time. Please request a fresh link from the issuer.";
        break;
      case AppErrorType.invalidToken:
        explanation =
            "This token does not correspond to any active credential inside our security records.";
        break;
      case AppErrorType.invalidSignature:
        explanation =
            "The token signature verification failed. The pass link might have been modified or tampered with.";
        break;
      case AppErrorType.revokedToken:
        explanation =
            "This pass token has been revoked by the issuer. Please contact support.";
        break;
      case AppErrorType.redeemedToken:
        explanation =
            "This pass has already been validated and redeemed. Single-use passes cannot be loaded twice.";
        break;
      case AppErrorType.networkError:
        explanation =
            "We couldn't reach the verification server to validate this ticket. Check your connection.";
        break;
      case AppErrorType.unknownError:
        explanation =
            "An unexpected error occurred while processing this pass. Please try again later.";
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Access Error"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.go('/wallet'),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.12),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.error.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.error_outline_rounded,
                      color: AppColors.error,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  appError.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  explanation,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => context.go('/wallet'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cardBg,
                      foregroundColor: Colors.white,
                      surfaceTintColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: BorderSide(
                          color: Colors.white.withOpacity(0.08),
                          width: 1,
                        ),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "RETURN TO WALLET HOME",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
