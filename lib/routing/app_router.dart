import 'package:go_router/go_router.dart';
import '../features/splash/splash_screen.dart';
import '../features/wallet/wallet_home_screen.dart';
import '../features/category/category_screen.dart';
import '../features/pass_detail/pass_detail_screen.dart';
import '../features/secure_ticket/secure_ticket_screen.dart';
import '../features/error/error_screen.dart';
import '../features/profile/profile_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/wallet',
      builder: (context, state) => const WalletHomeScreen(),
      routes: [
        GoRoute(
          path: 'category/:categoryId',
          builder: (context, state) {
            final categoryId = state.pathParameters['categoryId']!;
            return CategoryScreen(categoryId: categoryId);
          },
          routes: [
            GoRoute(
              path: 'pass/:passId',
              builder: (context, state) {
                final categoryId = state.pathParameters['categoryId']!;
                final passId = state.pathParameters['passId']!;
                return PassDetailScreen(categoryId: categoryId, passId: passId);
              },
              routes: [
                GoRoute(
                  path: 'secure',
                  builder: (context, state) {
                    final categoryId = state.pathParameters['categoryId']!;
                    final passId = state.pathParameters['passId']!;
                    return SecureTicketScreen(categoryId: categoryId, passId: passId);
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/error',
      builder: (context, state) {
        final errorTypeName = state.uri.queryParameters['type'] ?? 'unknownError';
        return DeepLinkErrorScreen(errorTypeName: errorTypeName);
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
);
