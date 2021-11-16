import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:socialapp/cache/cache_helper.dart';
import 'package:socialapp/components/components.dart';
import 'package:socialapp/constants/constants.dart';
import 'package:socialapp/cubit/login/login_cubit.dart';
import 'package:socialapp/cubit/login/login_states.dart';
import 'package:socialapp/presentation/auth/register_screen.dart';
import 'package:socialapp/presentation/social/layouts/social_layout.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginErrorState)
            showToast(message: state.error, state: ToastStates.ERROR);
          if (state is LoginSuccessState) {
            CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {
              uId = state.uId;
              navigateAndFinish(context, SocialLayout());
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOGIN',
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(color: Colors.black),
                        ),
                        Text(
                          'Login now to communicate with friends!',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.grey),
                        ),
                        SizedBox(height: 30.0),
                        defaultFormFeild(
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            returnValidate: 'please enter your email address!',
                            onSubmit: (text) {},
                            label: 'Email Address',
                            prefix: Icons.email_outlined),
                        SizedBox(height: 15.0),
                        defaultFormFeild(
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            suffix: LoginCubit.get(context).suffix,
                            isPassword: LoginCubit.get(context).isPassword,
                            suffixPressed: () {
                              LoginCubit.get(context)
                                  .changePasswordVisibility();
                            },
                            onSubmit: (text) {},
                            returnValidate: 'password is too short!',
                            label: 'Password',
                            prefix: Icons.lock_outline),
                        SizedBox(height: 30.0),
                        Conditional.single(
                            context: context,
                            conditionBuilder: (context) {
                              return state is! LoginLoadingState;
                            },
                            widgetBuilder: (context) => defaultButton(
                                  function: () {
                                    if (formKey.currentState!.validate()) {
                                      LoginCubit.get(context).userLogin(
                                          email: emailController.text,
                                          password: passwordController.text);
                                    }
                                  },
                                  text: 'login',
                                  isUpperCase: true,
                                ),
                            fallbackBuilder: (context) => Center(
                                  child: CircularProgressIndicator(),
                                )),
                        SizedBox(
                          height: 15.0,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Don\'t have an account?',
                              ),
                              defaultTextButton(
                                  function: () {
                                    navigateAndFinish(
                                        context, RegisterScreen());
                                  },
                                  text: 'REGISTER'),
                            ]),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
