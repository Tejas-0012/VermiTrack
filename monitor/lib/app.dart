import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:monitor/navigation/app_router.dart';
import 'package:monitor/providers/sensor_provider.dart';
import 'package:monitor/providers/compost_provider.dart';
import 'package:monitor/providers/auth_provider.dart';
import 'package:monitor/providers/theme_provider.dart';
import 'package:monitor/providers/bed_provider.dart';
import 'package:monitor/utils/themes.dart';

class SmartVermiCompostApp extends StatelessWidget {
  const SmartVermiCompostApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SensorProvider()),
        ChangeNotifierProvider(create: (_) => CompostProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => BedProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Smart Vermi Compost',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            debugShowCheckedModeBanner: false,
            initialRoute: '/splash',
            onGenerateRoute: AppRouter.generateRoute,
          );
        },
      ),
    );
  }
}
