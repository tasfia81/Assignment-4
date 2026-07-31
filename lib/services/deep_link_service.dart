import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../core/errors/app_error.dart';
import '../data/repositories/pass_repository.dart';

enum DeepLinkState {
  none,
  processing,
  success,
  error,
}

enum DeepLinkSource {
  coldStart,
  backgroundResume,
  foreground,
}

class DeepLinkService extends GetxService with WidgetsBindingObserver {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;
  final PassRepository _repository = Get.find<PassRepository>();

  final Rx<DeepLinkState> state = DeepLinkState.none.obs;
  final Rx<DeepLinkSource?> lastSource = Rx<DeepLinkSource?>(null);
  final Rx<AppError?> lastError = Rx<AppError?>(null);

  bool _isInitialized = false;
  AppLifecycleState _lastLifecycleState = AppLifecycleState.resumed;

  // Debounce to prevent multiple identical deep link calls
  String? _lastProcessedToken;
  DateTime? _lastProcessedTime;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _linkSubscription?.cancel();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _lastLifecycleState = state;
  }

  Future<void> init() async {
    if (_isInitialized) return;
    _isInitialized = true;

    // Handle runtime links (foreground or background resume)
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (uri) {
        final source = (_lastLifecycleState == AppLifecycleState.resumed)
            ? DeepLinkSource.foreground
            : DeepLinkSource.backgroundResume;
        _handleIncomingUri(uri, source);
      },
      onError: (err) {
        lastError.value = AppError(
          AppErrorType.unknownError,
          "Failed to capture deep link: $err",
        );
        state.value = DeepLinkState.error;
      },
    );
  }

  // Explicit check for cold start link
  Future<Uri?> checkForColdStart() async {
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleIncomingUri(initialUri, DeepLinkSource.coldStart);
        return initialUri;
      }
    } catch (_) {
      // Ignored for cold start, fallback to normal launch
    }
    return null;
  }

  void _handleIncomingUri(Uri uri, DeepLinkSource source) {
    final path = uri.path;
    if (!path.startsWith('/t/')) {
      _triggerError(AppErrorType.malformedLink, source);
      return;
    }

    final token = path.substring(3).trim();
    if (token.isEmpty) {
      _triggerError(AppErrorType.missingToken, source);
      return;
    }

    // Debouncing checks (1 second window)
    final now = DateTime.now();
    if (_lastProcessedToken == token &&
        _lastProcessedTime != null &&
        now.difference(_lastProcessedTime!) < const Duration(seconds: 1)) {
      return;
    }
    _lastProcessedToken = token;
    _lastProcessedTime = now;

    _processToken(token, source);
  }

  void simulateDeepLink(String token) {
    // Helper to simulate deep link from developer console
    _processToken(token, DeepLinkSource.foreground);
  }

  Future<void> _processToken(String token, DeepLinkSource source) async {
    state.value = DeepLinkState.processing;
    lastSource.value = source;
    lastError.value = null;

    // Simulate token validation network delay for a premium user experience
    await Future.delayed(const Duration(milliseconds: 1500));

    // Handle special mock error tokens
    if (token == 'error_expired') {
      _triggerError(AppErrorType.expiredToken, source);
      return;
    } else if (token == 'error_invalid') {
      _triggerError(AppErrorType.invalidToken, source);
      return;
    } else if (token == 'error_redeemed') {
      _triggerError(AppErrorType.redeemedToken, source);
      return;
    } else if (token == 'error_malformed') {
      _triggerError(AppErrorType.malformedLink, source);
      return;
    } else if (token == 'error_network') {
      _triggerError(AppErrorType.networkError, source);
      return;
    }

    // Resolve token to pass
    final pass = _repository.getPassByToken(token);
    if (pass == null) {
      _triggerError(AppErrorType.invalidToken, source);
      return;
    }

    // Success! Navigate directly to the pass and secure path
    state.value = DeepLinkState.success;
    
    final targetRoute = '/wallet/category/${pass.categoryId}/pass/${pass.passId}/secure';
    
    // Trigger navigation using global go_router configuration
    final router = Get.find<GoRouter>();
    router.go(targetRoute);
  }

  void _triggerError(AppErrorType type, DeepLinkSource source) {
    final error = AppError.fromType(type);
    lastError.value = error;
    state.value = DeepLinkState.error;

    // Route to error screen
    final router = Get.find<GoRouter>();
    router.go('/error?type=${type.name}');
  }
}
