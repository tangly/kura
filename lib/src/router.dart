import 'package:kura/src/providers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kura/src/views/home_screen.dart';
import 'package:kura/src/views/login_screen.dart';
import 'package:kura/src/views/prescription_list_screen.dart';
import 'package:kura/src/views/add_edit_prescription_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateChangesProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (BuildContext context, GoRouterState state) {
      final loggedIn = authState.value != null;
      final loggingIn = state.matchedLocation == '/login';

      if (!loggedIn) {
        return '/login';
      }

      if (loggingIn) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/prescriptions',
        builder: (context, state) => const PrescriptionListScreen(),
      ),
      GoRoute(
        path: '/prescriptions/add-edit',
        builder: (context, state) => AddEditPrescriptionScreen(memberId: state.extra as String),
      ),
    ],
  );
});