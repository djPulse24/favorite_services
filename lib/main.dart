import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/services/presentation/cubit/services_cubit.dart';
import 'features/services/presentation/pages/services_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await di.init();
    di.verifyDependencies();
    runApp(const MyApp());
  } catch (e) {
    print('Failed to start app: $e');
    // Handle initialization failure
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Favorite Services - Clean Architecture',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: const CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      home: BlocProvider(
        create: (_) => di.sl<ServicesCubit>(),
        child: const ServicesPage(),
      ),
    );
  }

  @override
  void dispose() {
    di.dispose();
    super.dispose();
  }
}