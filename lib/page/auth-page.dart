// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khatadiary/common/style.dart';
import 'package:khatadiary/service/firebase/auth.dart';
import 'package:lottie/lottie.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  // variables
  bool obscure = false;
  String email = '';
  String password = '';
  bool loading = false;
  bool register = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(kPad(context) * 0.08),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: kPad(context) * 0.8,
                width: kPad(context),
                child: LottieBuilder.network(
                    'https://assets6.lottiefiles.com/packages/lf20_3GnCTyCFo5.json'),
              ),
              Text(
                'Email',
                style: style(context).copyWith(fontSize: kPad(context) * 0.05),
              ),
              SizedBox(
                height: kPad(context) * 0.03,
              ),
              Container(
                height: kPad(context) * 0.14,
                decoration: BoxDecoration(
                    border: Border.all(color: darkC.withOpacity(0.1)),
                    borderRadius: BorderRadius.circular(7)),
                child: Center(
                  child: TextFormField(
                    showCursor: false,
                    keyboardType: TextInputType.emailAddress,
                    style:
                        style(context).copyWith(fontSize: kPad(context) * 0.05),
                    onChanged: (v) {
                      setState(() {
                        email = v;
                      });
                    },
                    obscureText: false,
                    decoration: InputDecoration(
                        prefixIcon: SizedBox(
                          width: kPad(context) * 0.05,
                          child: Icon(
                            CupertinoIcons.mail,
                            color: darkC.withOpacity(0.8),
                          ),
                        ),
                        hintText: 'Enter your email',
                        hintStyle: style(context).copyWith(
                            color: darkC.withOpacity(0.4),
                            fontSize: kPad(context) * 0.05),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none),
                  ),
                ),
              ),
              SizedBox(
                height: kPad(context) * 0.06,
              ),
              Text(
                'Password',
                style: style(context).copyWith(fontSize: kPad(context) * 0.05),
              ),
              SizedBox(
                height: kPad(context) * 0.03,
              ),
              Container(
                height: kPad(context) * 0.14,
                decoration: BoxDecoration(
                    border: Border.all(color: darkC.withOpacity(0.1)),
                    borderRadius: BorderRadius.circular(7)),
                child: Center(
                  child: TextFormField(
                    showCursor: false,
                    style:
                        style(context).copyWith(fontSize: kPad(context) * 0.05),
                    onChanged: (v) {
                      setState(() {
                        password = v;
                      });
                    },
                    obscureText: obscure ? false : true,
                    decoration: InputDecoration(
                        prefixIcon: SizedBox(
                          width: kPad(context) * 0.05,
                          child: Icon(
                            CupertinoIcons.lock,
                            color: darkC.withOpacity(0.8),
                          ),
                        ),
                        suffixIcon: InkWell(
                          onTap: () => setState(() => obscure = !obscure),
                          child: SizedBox(
                            width: kPad(context) * 0.05,
                            child: Icon(
                              obscure
                                  ? CupertinoIcons.eye_slash
                                  : CupertinoIcons.eye,
                              color: darkC.withOpacity(0.4),
                            ),
                          ),
                        ),
                        hintText: 'Enter your password',
                        hintStyle: style(context).copyWith(
                            color: darkC.withOpacity(0.4),
                            fontSize: kPad(context) * 0.05),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none),
                  ),
                ),
              ),
              SizedBox(
                height: kPad(context) * 0.15,
              ),
              InkWell(
                onTap: register
                    ? () async {
                        setState(() {
                          loading = true;
                        });
                        await create(context, email, password);
                        setState(() {
                          loading = false;
                        });
                      }
                    : () async {
                        setState(() {
                          loading = true;
                        });
                        await login(context, email, password);
                        setState(() {
                          loading = false;
                        });
                      },
                child: Container(
                  height: kPad(context) * 0.14,
                  decoration: BoxDecoration(
                      color: darkC, borderRadius: BorderRadius.circular(7)),
                  child: Center(
                      child: loading
                          ? SizedBox(
                              height: kPad(context) * 0.05,
                              width: kPad(context) * 0.05,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              register ? 'Sign Up' : 'Sign In',
                              style: style(context).copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: kPad(context) * 0.05),
                            )),
                ),
              ),
              SizedBox(
                height: kPad(context) * 0.1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    register
                        ? "Already have an account?"
                        : "Don't have an account?",
                    style:
                        style(context).copyWith(fontSize: kPad(context) * 0.05),
                  ),
                  TextButton(
                      onPressed: () => setState(() => register = !register),
                      child: Text(
                        register ? 'Sign in' : 'Sign up',
                        style: style(context).copyWith(
                            fontSize: kPad(context) * 0.05,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
