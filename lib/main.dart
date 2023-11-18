import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/core/dependency_injection/di_container.dart';
import 'package:todo_list/features/auth/domain/bloc/auth/auth_bloc.dart';
import 'package:todo_list/features/auth/presentation/pages/initial.page.dart';
import 'package:todo_list/features/auth/todo/domain/todo_bloc/todo_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final DIContainer diContainer = DIContainer();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>(
              create: (BuildContext context) => diContainer.authBloc,
            ),
            BlocProvider<TodoBloc>(
              create: (BuildContext context) => diContainer.todoBloc,
            ),
          ],
          child: const InitialPage(),
        ));
  }
}
