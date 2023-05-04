import 'package:flutter/material.dart';
import 'package:school_cafteria/app_localizations.dart';
import 'package:school_cafteria/core/navigation.dart';
import 'package:school_cafteria/core/widgets/loading_widget.dart';
import 'package:school_cafteria/features/account/presentation/bloc/account/account_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../../bottom.dart';
import '../../../../../core/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/util/snackbar_message.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key, required this.isAnother}) : super(key: key);
  final bool isAnother;

  @override
  Widget build(BuildContext context) {
    final usernameOrEmail = TextEditingController();
    final password = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      body: BlocConsumer<AccountBloc, AccountState>(
        listener: (context, state) {
          if (state is ErrorMsgState) {
            SnackBarMessage()
                .showErrorSnackBar(message: state.message, context: context);
          } else if (state is LoggedInState) {
            Go.offALL(context, BottomNav(user: state.user));
          }
        },
        builder: (context, state) {
          if (state is LoadingState) {
            return const LoadingWidget();
          } else {
            return SingleChildScrollView(
              child: SizedBox(
                width: 100.w,
                height: 100.h,
                child: Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/bg.png'),
                          fit: BoxFit.cover)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      SizedBox(
                        height: 7.h,
                        width: 60.w,
                        child: isAnother
                            ? Text(
                                "NOTE_SECOND_LOGIN".tr(context),
                                style: TextStyle(
                                    fontSize: 15.sp, color: Colors.white),
                              )
                            : const SizedBox(),
                      ),
                      isAnother
                          ? const SizedBox()
                          : Text(
                              "Yes Mederes",
                              style: TextStyle(
                                  fontSize: 20.sp, fontWeight: FontWeight.bold),
                            ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Form(
                          key: formKey,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 4.h,
                                  right: 4.h,
                                  bottom: 3.h,
                                ),
                                child: TextFormField(
                                  style: const TextStyle(color: Colors.white),
                                  validator: (value) => value!.isEmpty
                                      ? "EMPTY_USER".tr(context)
                                      : null,
                                  cursorColor: primaryColor,
                                  controller: usernameOrEmail,
                                  decoration: InputDecoration(
                                    filled: true,
                                    hintStyle:
                                        const TextStyle(color: Colors.white),
                                    //<-- SEE HERE
                                    fillColor: primaryColor.withOpacity(0.4),
                                    prefixIcon: const Icon(
                                      Icons.email,
                                      color: Colors.white,
                                    ),
                                    border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.red, width: 1.5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(40.0)),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.transparent,
                                          width: 1.5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(40.0)),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.transparent,
                                          width: 1.5),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(40.0)),
                                    ),
                                    // errorText: login.userErrorText,
                                    hintText: "LOGIN_USER_HINT".tr(context),
                                    //hintStyle: TextStyle(color: Colors.white)
                                  ),
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                    left: 4.h,
                                    right: 4.h,
                                    bottom: 0.h,
                                  ),
                                  child: TextFormField(
                                    style: const TextStyle(color: Colors.white),
                                    obscureText: true,
                                    validator: (value) => value!.isEmpty
                                        ? "EMPTY_PASSWORD".tr(context)
                                        : null,
                                    cursorColor: primaryColor,
                                    controller: password,
                                    decoration: InputDecoration(
                                      filled: true,
                                      hintStyle:
                                          const TextStyle(color: Colors.white),
                                      //<-- SEE HERE
                                      fillColor: primaryColor.withOpacity(0.4),
                                      prefixIcon: const Icon(
                                        Icons.lock,
                                        color: Colors.white,
                                      ),
                                      border: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.red, width: 1.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(40.0))),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 1.5),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(40.0)),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 1.5),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(40.0)),
                                      ),
                                      // errorText: login.userErrorText,
                                      hintText:
                                          "LOGIN_PASSWORD_HINT".tr(context),
                                    ),
                                  )),
                              SizedBox(
                                height: 10.h,
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                      ),
                                      minimumSize: Size(80.w, 7.h)),
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      if (isAnother) {
                                        BlocProvider.of<AccountBloc>(context)
                                            .add(SecondLoginEvent(
                                                usernameOrEmail.text,
                                                password.text,
                                                usernameOrEmail.text
                                                    .isValidEmail()));
                                      } else {
                                        BlocProvider.of<AccountBloc>(context)
                                            .add(LoginEvent(
                                                usernameOrEmail.text,
                                                password.text,
                                                usernameOrEmail.text
                                                    .isValidEmail()));
                                      }
                                    }
                                  },
                                  child: Text(
                                    "LOGIN_BUTTON".tr(context),
                                    style: TextStyle(fontSize: 13.sp),
                                  ))
                            ],
                          )),
                      SizedBox(
                        height: 4.h,
                      ),
                      isAnother
                          ? const SizedBox()
                          : Padding(
                              padding: EdgeInsets.all(4.h),
                              child: Text(
                                "NOTE_LOGIN_PAGE".tr(context),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12.sp, color: Colors.white),
                              )),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
