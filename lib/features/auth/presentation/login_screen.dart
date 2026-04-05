import 'package:email_client_app/features/auth/provider/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';


class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {

  final _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();

    // 🔥 Load remembered email + checkbox
    Future.microtask(() {
      ref.read(loginProvider.notifier).loadRememberedEmail();
    });

  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginProvider);
    final notifier = ref.read(loginProvider.notifier);


    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            color: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.email, size: 50),
                  const SizedBox(height: 10),

                  const Text(
                    "Sign in to continue",
                    style: TextStyle(color: Colors.grey),
                  ),

                  const Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Form(
                    key: _formKey,
                    onChanged: () => notifier.validateForm(_formKey),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [



                        Padding(
                          padding: const EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
                          child: TextFormField(
                            validator: (value) {
                              final trimmedValue = value?.trim() ?? '';
                              final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                              if (trimmedValue  == null || trimmedValue .isEmpty) {
                                return 'Enter your email';
                                // return null;
                              }
                              if (trimmedValue.length < 8) {
                                return 'Enter a valid email address';
                              }
                              if (!regex.hasMatch(trimmedValue)) {
                                return 'Enter a valid email address';
                              }
                              else{
                                return null; // Return null if the input is valid
                              }
                            },
                            cursorColor: Colors.black,
                            controller: notifier.emailController,
                            keyboardType:TextInputType.text,
                            decoration: InputDecoration(
                              hintText: "Email",
                              hintStyle: TextStyle(color: HexColor("#A0A5BA"), fontSize: 14.0, fontWeight: FontWeight.normal),
                              filled: true, // Set this to true to enable the background color
                              fillColor: Colors.white, // Set the desired background color
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black, width: 0.0),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color:Colors.black, width: 0.0),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              counterText: '',
                            ),
                          ),
                        ),


                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                          child: TextFormField(
                            validator: (value) {
                              final trimmedValue = value?.trim() ?? '';
                              if (trimmedValue.isEmpty) {
                                return 'Enter your password';
                              }
                              if (trimmedValue.length < 8) {
                                return 'Must be at least 8 characters long';
                              }
                              return null;
                            },
                            cursorColor: Colors.black,
                            controller: notifier.passwordController,
                            obscureText: state.passwordVisible,
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              hintText: "Password",
                              hintStyle: TextStyle(color: HexColor("#A0A5BA"), fontSize: 14.0, fontWeight: FontWeight.normal),
                              filled: true, // Set this to true to enable the background color
                              fillColor: Colors.white, // Set the desired background color
                              suffixIcon: IconButton(
                                icon: Icon(state.passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: notifier.togglePassword,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black, width: 0),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:  BorderSide(color: Colors.black, width: 0),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              counterText: '',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),



                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [

                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Checkbox(
                              value: state.rememberMe,
                              onChanged: (v) =>
                                  notifier.toggleRememberMe(v ?? false),
                              activeColor: Colors.blueAccent, // color of the checkbox when selected
                              checkColor: Colors.white,  // color of the checkmark itself
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: Text("Remember me", style: TextStyle(fontFamily: 'DM Sans', color: HexColor("#7E8A97"), fontSize: 14.0, fontWeight: FontWeight.normal),),
                          ),

                          const Expanded(child: SizedBox()),

                        ]
                    ),
                  ),

                  Padding(
                      padding: const EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0, bottom: 20.0),
                      child: state.isLoading
                          ? Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Center(
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                          : ElevatedButton(
                        onPressed: state.isButtonEnabled
                            ? () => notifier.loginUsers(context)
                            : null,
                        child: Text("Login", style: TextStyle(fontSize: 14.0)),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blueAccent,
                          // padding: EdgeInsets.all(10.0),
                          minimumSize: Size(MediaQuery.of(context).size.width, 50.0),
                          textStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      )
                  ),



                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}