import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/service_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/home/dashboard_screen.dart';
import 'screens/services/data_screen.dart';
import 'screens/services/airtime_screen.dart';
import 'screens/services/electricity_screen.dart';
import 'screens/transactions/transactions_screen.dart';
import 'screens/referrals/referrals_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/verification/verification_screen.dart';
import 'widgets/app_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AbjikdataApp());
}

class AbjikdataApp extends StatelessWidget {
  const AbjikdataApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ServiceProvider()),
      ],
      child: MaterialApp(
        title: 'Abjikdata',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
        routes: {
          '/login': (_) => const LoginScreen(),
          '/register': (_) => const RegisterScreen(),
          '/forgot-password': (_) => const ForgotPasswordScreen(),
          '/dashboard': (_) => const MainShell(),
          '/data': (_) => const DataScreen(),
          '/airtime': (_) => const AirtimeScreen(),
          '/electricity': (_) => const ElectricityScreen(),
          '/transactions': (_) => const TransactionsScreen(),
          '/referrals': (_) => const ReferralsScreen(),
          '/profile': (_) => const ProfileScreen(),
          '/verify-nin': (_) => const VerificationScreen(type: 'nin'),
          '/verify-bvn': (_) => const VerificationScreen(type: 'bvn'),
        },
      ),
    );
  }
}

// Splash Screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final auth = context.read<AuthProvider>();
    try {
      await auth.checkAuth().timeout(const Duration(seconds: 5));
    } catch (_) {
      // Timeout or error - go to login
    }
    if (mounted) {
      Navigator.pushReplacementNamed(
        context,
        auth.isLoggedIn ? '/dashboard' : '/login',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF224ABE), Color(0xFF4E73DF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.flash_on,
                size: 64,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'ABJIKDATA',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'VTU Services',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}

// Main Shell with Bottom Navigation
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final _screens = const [
    DashboardScreen(),
    DataScreen(),
    TransactionsScreen(),
    ReferralsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppShell(
        currentIndex: _currentIndex,
        onTabChange: (index) {
          setState(() => _currentIndex = index);
        },
        child: _screens[_currentIndex],
      ),
    );
  }
}
