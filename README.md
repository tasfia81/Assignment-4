# OmniPass Digital Wallet

OmniPass is a digital wallet application for storing event tickets, access passes, and smart-access credentials. This project is built as part of the Khizex Mobile Engineering Internship Week 4 assignment.

The core architecture is built around a **deep-link driven routing structure** that automatically constructs backstack paths when loading direct pass states.

---

## Technical Stack

- **Framework**: [Flutter](https://flutter.dev) (Dart with strong typing & null safety)
- **Routing**: [go_router](https://pub.dev/packages/go_router) (Declarative type-safe routing)
- **State Management**: [GetX](https://pub.dev/packages/get) (Decoupled controllers and dependency injection)
- **Secure Storage**: [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage) (For credentials cache)
- **Networking**: [Dio](https://pub.dev/packages/dio) (HTTP client foundation)
- **Deep Linking**: [app_links](https://pub.dev/packages/app_links) (Unified link streams handling cold/warm launches)

---

## Directory Architecture

The project implements a feature-based Clean Architecture structure separation of concerns:

```text
lib/
├── core/
│   ├── errors/          # Typed AppError classes
│   ├── network/         # HTTP Dio client wrapper
│   ├── storage/         # Secure storage persistence layer
│   └── theme/           # Color palettes, gradients, and custom themes
├── data/
│   ├── models/          # Strongly-typed models (PassModel, CategoryModel)
│   └── repositories/    # Mock pass repository (40+ passes, categorizations)
├── features/            # UI Views & business controllers
│   ├── category/        # Pass listings for specific category IDs
│   ├── error/           # Error display view for malformed/expired links
│   ├── pass_detail/     # Detailed ticket card display
│   ├── profile/         # User preferences and Deep Link Simulator
│   ├── secure_ticket/   # High-security access pass with sweeping scanner animation
│   ├── splash/          # Bootstrapper and launch handler
│   └── wallet/          # Main dashboard (featured carousels, quick links)
├── routing/             # go_router declarative route maps
├── services/            # DeepLinkService for listening and parsing links
└── main.dart            # Application bootstrap and DI configurations
```

---

## Route Structure

We configure `go_router` in a nested/hierarchical route design. When navigating directly to a deep sub-route, `go_router` automatically builds the parent navigator stack. Tapping "Back" will step backward correctly through the stack:

```text
/ (Splash Screen)
 └── /wallet (Wallet Home Dashboard)
      └── /wallet/category/:categoryId (Category Screen)
           └── /wallet/category/:categoryId/pass/:passId (Pass Detail Screen)
                └── /wallet/category/:categoryId/pass/:passId/secure (Secure Ticket View)

/error (Deep Link Error Screen)
/profile (Profile & Settings Screen)
```

For example, navigating directly to `/wallet/category/events/pass/pass_concert_1/secure` builds the following stack:
1. `WalletHomeScreen` (Base)
2. `CategoryScreen(categoryId: 'events')`
3. `PassDetailScreen(passId: 'pass_concert_1')`
4. `SecureTicketScreen(passId: 'pass_concert_1')` (Active viewport)

Tapping **Back** from the Secure Ticket Screen returns to the Pass Detail Screen, then to the Category Screen, and finally to the Wallet Home Screen.

---

## How Deep Links Work Conceptually

1. **Android/iOS Registration**: The OS registers `omnipass.app` under the `/t/` pathPrefix. When a link like `https://omnipass.app/t/<token>` is clicked, the OS routes the intent to OmniPass.
2. **Cold Start vs. Warm Start**:
   - **Cold Start**: The app is launched from a closed state. `DeepLinkService` polls `getInitialLink()` on startup, parses the token, and handles redirection during the splash sequence.
   - **Warm Start**: The app is already running. The service listens to the `uriLinkStream` and redirects the active viewport to the target route.
3. **Validation & Resolution**: In Phase 1, the `DeepLinkService` extracts the token and resolves it to a corresponding local pass in the mock repository. Phase 2 will replace this simulation with real cryptographic token exchange.
4. **Error Handling**: Malformed or invalid tokens are captured and routed directly to the `/error` screen.

---

## Setup & Running Instructions

### 1. Installation

Verify your environment matches our configurations, then run:

```bash
flutter pub get
```

### 2. Run the App

To run the application on a connected device/emulator:

```bash
flutter run
```

### 3. Run Analysis & Tests

To execute widget tests:

```bash
flutter test
```

---

## Testing Deep Links (Phase 1)

We have built **two separate ways** to test and verify the deep link routing and error handling flows.

### Method A: Interactive Deep Link Simulator Console (Recommended)

Since command-line deep linking requires setting up emulator links associations, we integrated a **Deep Link Simulator Console** directly inside the app:
1. Open the app and navigate to the **Profile Screen** (tap the profile icon in the top right of the Wallet Home).
2. Scroll to the **Deep Link Simulator** section.
3. Click any of the simulation triggers:
   - **Concert Pass / Lounge Key**: Simulates a valid token link. The app will automatically reset to the splash loader, verify the token, and navigate directly to the Secure Ticket View with the full navigation backstack constructed.
   - **Expired / Invalid / Redeemed / Malformed / Network**: Simulates various token validation failures. The app will reset, parse, and route to the **Access Error Screen** detailing the failure state.

### Method B: Native ADB Link Trigger (Android Emulator)

With the emulator open, trigger deep links directly using Android Activity Manager:

```bash
# Test Valid Concert Pass Link
adb shell am start -W -a android.intent.action.VIEW -d "https://omnipass.app/t/pass_concert_1" assignment_4

# Test Valid Lounge Pass Link
adb shell am start -W -a android.intent.action.VIEW -d "https://omnipass.app/t/pass_vip_1" assignment_4

# Test Expired Token Error Link
adb shell am start -W -a android.intent.action.VIEW -d "https://omnipass.app/t/error_expired" assignment_4

# Test Invalid Token Error Link
adb shell am start -W -a android.intent.action.VIEW -d "https://omnipass.app/t/error_invalid" assignment_4
```
