import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/core/dependency_injection/di_container.dart';
import 'package:todo_list/core/enum/state_status.enum.dart';
import 'package:todo_list/core/global_widgets/snackbar.widget.dart';
import 'package:todo_list/core/utils/guard.dart';
import 'package:todo_list/features/auth/domain/bloc/auth/auth_bloc.dart';
import 'package:todo_list/features/auth/domain/models/register_model.dart';
import 'package:todo_list/features/auth/todo/domain/todo_bloc/todo_bloc.dart';
import 'home.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final DIContainer diContainer = DIContainer();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  late AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleTextStyle: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white),
        title: const Center(child: 
        Text('Register')
        ),
      
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
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20,),
                      const Text(
                        'Create an Account',
                        style: TextStyle(
                            fontSize: 20.0, color: Colors.black),
                      ),
                      Padding(
                        
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _firstNameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(10)),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(10)),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelStyle: const TextStyle(color: Colors.green),
                            labelText: 'First Name',
                          ),
                          validator: (val) {
                            return Guard.againstEmptyString(val, 'First Name');
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _lastNameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(10)),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(10)),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelStyle: const TextStyle(color: Colors.green),
                            labelText: 'Last Name',
                          ),
                          validator: (val) {
                            return Guard.againstEmptyString(val, 'Last Name');
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _emailController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(10)),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(10)),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelStyle: const TextStyle(color: Colors.green),
                            labelText: 'Email',
                          ),
                          validator: (val) {
                            return Guard.againstInvalidEmail(val, 'Email');
                          },
                        ),
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
                                borderSide:
                                    const BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(10)),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(10)),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelStyle: const TextStyle(color: Colors.green),
                            labelText: 'Password',
                          ),
                          validator: (val) {
                            return Guard.againstEmptyString(val, 'Password');
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _confirmController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(10)),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(10)),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelStyle: const TextStyle(color: Colors.green),
                            labelText: 'Confirm Password',
                          ),
                          validator: (String? val) {
                            return Guard.againstNotMatch(
                                val, _passwordController.text, 'Password');
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.black),
                        onPressed: () {
                          _register(context);
                        },
                        child: const Text('Submit'),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      )
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
      SnackBarUtils.defualtSnackBar('Success!', context);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => MultiBlocProvider(
              providers: [
                BlocProvider<AuthBloc>(
                  create: (BuildContext context) => diContainer.authBloc,
                ),
                BlocProvider<TodoBloc>(
                  create: (BuildContext context) => diContainer.todoBloc,
                ),
              ],
              child: HomePage(
                authUserModel: state.authUserModel!,
              ),
            ),
          ),
          ModalRoute.withName('/'));
    }
  }

  Widget _loadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  void _register(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _authBloc.add(AuthRegisterEvent(
          registerModel: RegisterModel(
              email: _emailController.text,
              password: _passwordController.text,
              confirmPassword: _confirmController.text,
              firstName: _firstNameController.text,
              lastName: _lastNameController.text)));
    }
  }
}
