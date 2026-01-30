import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:taskat_new/firebase_options.dart';
import 'l10n/app_localizations.dart';

// Core
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/localization/locale_provider.dart';

// Data
import 'data/services/firebase_auth_service.dart';
import 'data/services/firebase_firestore_service.dart';
import 'data/services/api_service.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/todo_reposirory.dart';
import 'data/repositories/api_repository.dart';

// Providers
import 'providers/auth_provider.dart' as auth_provider_module;
import 'providers/todo_provider.dart';
import 'providers/api_provider.dart';

// Screens
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),

        // Services
        Provider(create: (_) => FirebaseAuthService()),
        Provider(create: (_) => FirebaseFirestoreService()),
        Provider(create: (_) => ApiService()),

        // Repositories
        ProxyProvider2<FirebaseAuthService, FirebaseFirestoreService,
            auth_provider_module.AuthRepository>(
          update: (_, authService, firestoreService, __) => AuthRepositoryImpl(
            firebaseAuthService: authService,
            firebaseFirestoreService: firestoreService,
          ),
        ),
        ProxyProvider<FirebaseFirestoreService, TodoRepository>(
          update: (_, firestoreService, __) => TodoRepository(
            firebaseFirestoreService: firestoreService,
          ),
        ),
        ProxyProvider<ApiService, ApiRepository>(
          update: (_, apiService, __) => ApiRepository(
            apiService: apiService,
          ),
        ),

        ChangeNotifierProxyProvider<auth_provider_module.AuthRepository,
            auth_provider_module.AuthProvider>(
          create: (context) => auth_provider_module.AuthProvider(
            authRepository: context.read<auth_provider_module.AuthRepository>(),
          ),
          update: (_, repo, provider) => provider!..setRepository(repo),
        ),
        ChangeNotifierProxyProvider<TodoRepository, TodoProvider>(
          create: (context) => TodoProvider(
            todoRepository: context.read<TodoRepository>(),
          ),
          update: (_, repo, provider) => provider!..setRepository(repo),
        ),
        ChangeNotifierProxyProvider<ApiRepository, ApiProvider>(
          create: (context) => ApiProvider(
            apiRepository: context.read<ApiRepository>(),
          ),
          update: (_, repo, provider) => provider!..setRepository(repo),
        ),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (context, themeProvider, localeProvider, _) {
          return MaterialApp(
            title: 'Todo App',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            locale: localeProvider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('ar'),
            ],
            home: Consumer<auth_provider_module.AuthProvider>(
              builder: (context, auth, _) {
                if (!auth.isInitialized) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                return auth.isAuthenticated
                    ? const MainScreen()
                    : const LoginScreen();
              },
            ),
          );
        },
      ),
    );
  }
}
