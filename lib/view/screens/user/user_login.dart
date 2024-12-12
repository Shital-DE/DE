import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/user/login/login_bloc.dart';
import '../../../bloc/user/login/login_event.dart';
import '../../../bloc/user/login/login_state.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_theme.dart';
import '../../../utils/common/quickfix_widget.dart';

class UserLogin extends StatelessWidget {
  const UserLogin({super.key});

  @override
  Widget build(BuildContext context) {
    final blocProvider = BlocProvider.of<LoginBloc>(context);
    blocProvider.add(LoginCredentialsEvent(
      obsecurePassword: ValueNotifier<bool>(true),
    ));
    return Scaffold(
      backgroundColor: AppColors.secondarybackgroundColor,
      body: Center(
        child: Container(
          width: 400,
          height: 300,
          margin: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Login', style: AppTheme.loginHeaderTextStyle()),
              BlocBuilder<LoginBloc, UserLoginstate>(
                builder: (context, state) {
                  return TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.person,
                        size: 30,
                        color: AppColors.appTheme,
                      ),
                      border: QuickFixUi.makeTextFieldCircular(),
                      hintText: 'Username',
                    ),
                    onChanged: (value) {
                      if (state is LoginState) {
                        blocProvider.add(LoginCredentialsEvent(
                            username: value.toString(),
                            password: state.password,
                            obsecurePassword: ValueNotifier<bool>(true)));
                      } else if (state is LoginErrorState) {
                        blocProvider.add(LoginCredentialsEvent(
                            username: value.toString(),
                            password: state.password,
                            obsecurePassword: ValueNotifier<bool>(true)));
                      }
                    },
                  );
                },
              ),
              BlocBuilder<LoginBloc, UserLoginstate>(
                builder: (context, state) {
                  return TextField(
                    obscureText: state is LoginState
                        ? state.obsecurePassword.value
                        : false,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.password_outlined,
                        size: 30,
                        color: AppColors.appTheme,
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                          if (state is LoginState) {
                            final newPasswordVisibility =
                                !state.obsecurePassword.value;
                            blocProvider.add(LoginCredentialsEvent(
                              username: state.username,
                              password: state.password,
                              obsecurePassword:
                                  ValueNotifier<bool>(newPasswordVisibility),
                            ));
                          }
                        },
                        child: state is LoginState
                            ? Icon(
                                state.obsecurePassword.value
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility,
                                color: AppColors.appTheme,
                              )
                            : const Icon(
                                Icons.visibility_off_outlined,
                                color: AppColors.appTheme,
                              ),
                      ),
                      border: QuickFixUi.makeTextFieldCircular(),
                      hintText: 'Password',
                    ),
                    onChanged: (value) {
                      if (state is LoginState) {
                        blocProvider.add(LoginCredentialsEvent(
                            username: state.username,
                            password: value.toString(),
                            obsecurePassword: ValueNotifier<bool>(true)));
                      } else if (state is LoginErrorState) {
                        blocProvider.add(LoginCredentialsEvent(
                            username: state.username,
                            password: value.toString(),
                            obsecurePassword: ValueNotifier<bool>(true)));
                      }
                    },
                  );
                },
              ),
              SizedBox(
                  width: 150,
                  height: 50,
                  child: BlocConsumer<LoginBloc, UserLoginstate>(
                    listener: (context, state) {
                      if (state is LoginErrorState) {
                        QuickFixUi.errorMessage(state.errorMessage, context);
                      }
                    },
                    builder: (context, state) {
                      return FilledButton(
                        onPressed: () async {
                          if (state is LoginState) {
                            if (state.username == '' && state.password == '') {
                              QuickFixUi.errorMessage(
                                  'User credentials not found', context);
                            } else if (state.username == '') {
                              QuickFixUi.errorMessage(
                                  'Username not found', context);
                            } else if (state.password == '') {
                              QuickFixUi.errorMessage(
                                  'Password not found', context);
                            } else {
                              blocProvider.add(LoginCredentialsEvent(
                                  username: state.username,
                                  password: state.password,
                                  obsecurePassword: ValueNotifier<bool>(false),
                                  submitting: true));
                            }
                          } else if (state is LoginErrorState) {
                            blocProvider.add(LoginCredentialsEvent(
                                username: state.username,
                                password: state.password,
                                obsecurePassword: ValueNotifier<bool>(false),
                                submitting: true));
                            return QuickFixUi.errorMessage(
                                state.errorMessage, context);
                          }
                          // if (state is LoginState) {
                          //   if (state.username == '' && state.password == '') {
                          //     QuickFixUi.errorMessage(
                          //         'User credentials not found', context);
                          //   } else if (state.username == '') {
                          //     QuickFixUi.errorMessage(
                          //         'Username not found', context);
                          //   } else if (state.password == '') {
                          //     QuickFixUi.errorMessage(
                          //         'Password not found', context);
                          //   } else {
                          //     blocProvider.add(LoginCredentialsEvent(
                          //       username: state.username,
                          //       password: state.password,
                          //       obsecurePassword: ValueNotifier<bool>(false),
                          //       submitting: true,
                          //     ));
                          //   }
                          // } else if (state is LoginErrorState) {
                          //   blocProvider.add(LoginCredentialsEvent(
                          //     username: state.username,
                          //     password: state.password,
                          //     obsecurePassword: ValueNotifier<bool>(false),
                          //     submitting: true,
                          //   ));
                          //   return QuickFixUi.errorMessage(
                          //       state.errorMessage, context);
                          // }
                        },
                        child: state is LoginState
                            ? state.submitting == false
                                ? const Text('Login',
                                    style: TextStyle(fontSize: 20))
                                : const CircularProgressIndicator(
                                    color: AppColors.whiteTheme)
                            : const Text('Login',
                                style: TextStyle(fontSize: 20)),
                      );
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../bloc/user/login/login_bloc.dart';
// import '../../../bloc/user/login/login_event.dart';
// import '../../../bloc/user/login/login_state.dart';
// import '../../../utils/app_colors.dart';
// import '../../../utils/app_theme.dart';
// import '../../../utils/common/quickfix_widget.dart';

// class UserLogin extends StatelessWidget {
//   const UserLogin({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final blocProvider = BlocProvider.of<LoginBloc>(context);
//     blocProvider.add(LoginCredentialsEvent(
//       obsecurePassword: ValueNotifier<bool>(true),
//     ));
//     return Scaffold(
//       backgroundColor: AppColors.secondarybackgroundColor,
//       body: Center(
//         child: Container(
//           width: 400,
//           height: 300,
//           margin: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text('Login', style: AppTheme.loginHeaderTextStyle()),
//               BlocBuilder<LoginBloc, UserLoginstate>(
//                 builder: (context, state) {
//                   return TextField(
//                     decoration: InputDecoration(
//                       prefixIcon: const Icon(
//                         Icons.person,
//                         size: 30,
//                         color: AppColors.appTheme,
//                       ),
//                       border: QuickFixUi.makeTextFieldCircular(),
//                       hintText: 'Username',
//                     ),
//                     onChanged: (value) {
                      // if (state is LoginState) {
                      //   blocProvider.add(LoginCredentialsEvent(
                      //       username: value.toString(),
                      //       password: state.password,
                      //       obsecurePassword: ValueNotifier<bool>(true)));
                      // } else if (state is LoginErrorState) {
                      //   blocProvider.add(LoginCredentialsEvent(
                      //       username: value.toString(),
                      //       password: state.password,
                      //       obsecurePassword: ValueNotifier<bool>(true)));
                      // }
//                     },
//                   );
//                 },
//               ),
//               BlocBuilder<LoginBloc, UserLoginstate>(
//                 builder: (context, state) {
//                   return TextField(
//                     obscureText: state is LoginState
//                         ? state.obsecurePassword.value
//                         : false,
//                     keyboardType: TextInputType.number,
//                     decoration: InputDecoration(
//                       prefixIcon: const Icon(
//                         Icons.password_outlined,
//                         size: 30,
//                         color: AppColors.appTheme,
//                       ),
//                       suffixIcon: InkWell(
//                         onTap: () {
//                           if (state is LoginState) {
//                             blocProvider.add(LoginCredentialsEvent(
//                                 username: state.username,
//                                 password: state.password,
//                                 obsecurePassword:
//                                     state.obsecurePassword.value == true
//                                         ? ValueNotifier<bool>(false)
//                                         : ValueNotifier<bool>(true)));
//                           }
//                         },
//                         child: state is LoginState
//                             ? state.obsecurePassword.value == true
//                                 ? const Icon(
//                                     Icons.visibility_off_outlined,
//                                     color: AppColors.appTheme,
//                                   )
//                                 : const Icon(
//                                     Icons.visibility,
//                                     color: AppColors.appTheme,
//                                   )
//                             : const Icon(
//                                 Icons.visibility_off_outlined,
//                                 color: AppColors.appTheme,
//                               ),
//                       ),
//                       border: QuickFixUi.makeTextFieldCircular(),
//                       hintText: 'Password',
//                     ),
//                     onChanged: (value) {
//                       if (state is LoginState) {
//                         blocProvider.add(LoginCredentialsEvent(
//                             username: state.username,
//                             password: value.toString(),
//                             obsecurePassword: ValueNotifier<bool>(true)));
//                       } else if (state is LoginErrorState) {
//                         blocProvider.add(LoginCredentialsEvent(
//                             username: state.username,
//                             password: value.toString(),
//                             obsecurePassword: ValueNotifier<bool>(true)));
//                       }
//                     },
//                   );
//                 },
//               ),
//               SizedBox(
//                   width: 150,
//                   height: 50,
//                   child: BlocConsumer<LoginBloc, UserLoginstate>(
//                     listener: (context, state) {
//                       if (state is LoginErrorState) {
//                         QuickFixUi.errorMessage(state.errorMessage, context);
//                       }
//                     },
//                     builder: (context, state) {
//                       return FilledButton(
//                           onPressed: () async {
                            // if (state is LoginState) {
                            //   if (state.username == '' &&
                            //       state.password == '') {
                            //     QuickFixUi.errorMessage(
                            //         'User credentials not found', context);
                            //   } else if (state.username == '') {
                            //     QuickFixUi.errorMessage(
                            //         'Username not found', context);
                            //   } else if (state.password == '') {
                            //     QuickFixUi.errorMessage(
                            //         'Password not found', context);
                            //   } else {
                            //     blocProvider.add(LoginCredentialsEvent(
                            //         username: state.username,
                            //         password: state.password,
                            //         obsecurePassword:
                            //             ValueNotifier<bool>(false),
                            //         submitting: true));
                            //   }
                            // } else if (state is LoginErrorState) {
                            //   blocProvider.add(LoginCredentialsEvent(
                            //       username: state.username,
                            //       password: state.password,
                            //       obsecurePassword: ValueNotifier<bool>(false),
                            //       submitting: true));
                            //   return QuickFixUi.errorMessage(
                            //       state.errorMessage, context);
                            // }
//                           },
//                           child: state is LoginState
//                               ? state.submitting == false
//                                   ? const Text(
//                                       'Login',
//                                       style: TextStyle(fontSize: 20),
//                                     )
//                                   : const CircularProgressIndicator(
//                                       color: AppColors.whiteTheme,
//                                     )
//                               : const Text(
//                                   'Login',
//                                   style: TextStyle(fontSize: 20),
//                                 ));
//                     },
//                   )),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
