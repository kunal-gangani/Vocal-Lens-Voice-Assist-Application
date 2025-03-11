import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vocal_lens/Controllers/auth_controller.dart';
import 'package:vocal_lens/Views/HomePage/home_page.dart';
import 'package:vocal_lens/Views/RegistrationPage/registration_page.dart';
import 'package:vocal_lens/Widgets/auth_text_field.dart';
import 'package:vocal_lens/Widgets/drop_down_text_style.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    AuthController authController = Provider.of<AuthController>(
      context,
      listen: false,
    );

    void changeLanguage(Locale locale) {
      context.setLocale(locale);
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          tr("login_title"),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: DropdownButton<Locale>(
              dropdownColor: Colors.grey[900],
              icon: const Icon(
                Icons.language,
                color: Colors.white,
              ),
              underline: Container(),
              onChanged: (Locale? newLocale) {
                if (newLocale != null) {
                  changeLanguage(newLocale);
                }
              },
              items: [
                DropdownMenuItem(
                  value: const Locale('en', 'US'),
                  child: Text(
                    'English',
                    style: dropDownMenuTextStyle(),
                  ),
                ),
                DropdownMenuItem(
                  value: const Locale('es', 'ES'),
                  child: Text(
                    'Español',
                    style: dropDownMenuTextStyle(),
                  ),
                ),
                DropdownMenuItem(
                  value: const Locale('de', 'DE'),
                  child: Text(
                    'German',
                    style: dropDownMenuTextStyle(),
                  ),
                ),
                DropdownMenuItem(
                  value: const Locale('hi', 'IN'),
                  child: Text(
                    'Hindi',
                    style: dropDownMenuTextStyle(),
                  ),
                ),
                DropdownMenuItem(
                  value: const Locale('fr', 'FR'),
                  child: Text(
                    'Français',
                    style: dropDownMenuTextStyle(),
                  ),
                ),
                DropdownMenuItem(
                  value: const Locale('nl', 'NL'),
                  child: Text(
                    'Dutch',
                    style: dropDownMenuTextStyle(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.grey],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Text(
                            'welcome_back'.tr(),
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          buildTextFormField(
                            context: context,
                            controller: emailController,
                            label: 'email'.tr(),
                            icon: Icons.email,
                          ),
                          const SizedBox(height: 16),
                          buildTextFormField(
                            context: context,
                            controller: passwordController,
                            label: 'password'.tr(),
                            icon: Icons.lock,
                            isPassword: true,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                try {
                                  await authController.signInWithEmail(
                                    emailController.text,
                                    passwordController.text,
                                  );
                                  Fluttertoast.showToast(
                                    msg: 'login_successful'.tr(),
                                    backgroundColor: Colors.green,
                                    textColor: Colors.white,
                                  );
                                } catch (e) {
                                  Fluttertoast.showToast(
                                    msg: 'login_failed'.tr(),
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                            ),
                            child: Text(
                              'login_title'.tr(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () async {
                              await authController.signInWithGoogle();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const FaIcon(
                                  FontAwesomeIcons.google,
                                  color: Colors.red,
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Text(
                                  "Sign in with Google",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          TextButton(
                            onPressed: () {
                              Flexify.goRemove(
                                const RegistrationPage(),
                                animation: FlexifyRouteAnimations.blur,
                                duration: Durations.medium1,
                              );
                            },
                            child: Text(
                              'register_prompt'.tr(),
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
