import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/core/enum/state_status.enum.dart';
import 'package:todo_list/core/global_widgets/snackbar.widget.dart';
import 'package:todo_list/core/utils/guard.dart';
import 'package:todo_list/features/auth/domain/bloc/auth/auth_bloc.dart';
import 'package:todo_list/features/auth/domain/models/login_model.dart';
import 'package:todo_list/core/dependency_injection/di_container.dart';
import 'package:todo_list/features/auth/todo/domain/todo_bloc/todo_bloc.dart';
import 'register.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final DIContainer diContainer = DIContainer();

  late AuthBloc _authBloc;

  @override
  void initState() {
    _authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
  }

  void clearText() {
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleTextStyle: const TextStyle(
            fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
        title: const Center(child: Text('TODO')),
        backgroundColor: Colors.black,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        bloc: _authBloc,
        listener: _authBlocListener,
        builder: (context, state) {
          if (state.stateStatus == StateStatus.loading) {
            return _loadingWidget();
          }
          return Container(
            alignment: Alignment.center,
            child: SizedBox(
              
              child: SingleChildScrollView(
                
                child: Form(
                  key: _formKey,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10,),
                      const Center(
                        
                        child: Text(
                          'Login',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 16),
                        child: TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            controller: _emailController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelStyle: const TextStyle(
                                color: Colors.green,
                              ),
                              labelText: 'Enter email',
                            ),
                            validator: (String? val) {
                              return Guard.againstInvalidEmail(val, 'Email');
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelStyle: const TextStyle(color: Colors.green),
                              labelText: 'Enter password',
                            ),
                            validator: (String? val) {
                              return Guard.againstEmptyString(val, 'Password');
                            }),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          _login(context);
                        },
                        child: const Text('Submit'),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.black),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BlocProvider.value(
                                        value: _authBloc,
                                        child: const RegistrationPage(),
                                      )));
                          clearText();
                        },
                        child: const Text('Register'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _authBlocListener(BuildContext context, AuthState state) {
    if (state.stateStatus == StateStatus.error) {
      SnackBarUtils.defualtSnackBar(state.errorMessage, context);
    }

    if (state.authUserModel != null) {
      SnackBarUtils.defualtSnackBar('Login Success!', context);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => MultiBlocProvider(
                      providers: [
                        BlocProvider<AuthBloc>(
                          create: (BuildContext context) =>
                              diContainer.authBloc,
                        ),
                        BlocProvider<TodoBloc>(
                            create: (BuildContext context) =>
                                diContainer.todoBloc)
                      ],
                      child: HomePage(
                        authUserModel: state.authUserModel!,
                      ))),
          ModalRoute.withName('/'));
    }
  }

  Widget _loadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  void _login(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _authBloc.add(
        AuthLoginEvent(
          logInModel: LoginModel(
            email: _emailController.text,
            password: _passwordController.text,
          ),
        ),
      );
    }
    clearText();
  }
}
