import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vocal_lens/Controllers/auth_controller.dart';
import 'package:vocal_lens/Views/LoginPage/login_page.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final authController = Provider.of<AuthController>(
      context,
      listen: false,
    );

    void changeLanguage(Locale locale) {
      context.setLocale(locale);
    }

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Flexify.goRemove(
              const LoginPage(),
              animation: FlexifyRouteAnimations.blur,
              duration: Durations.medium1,
            );
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
        backgroundColor: Colors.grey.shade900,
        title: Text(
          'register_title'.tr(),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          DropdownButton<Locale>(
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
            items: const [
              DropdownMenuItem(
                value: Locale('en', 'US'),
                child: Text('English'),
              ),
              DropdownMenuItem(
                value: Locale('es', 'ES'),
                child: Text('Español'),
              ),
              DropdownMenuItem(
                value: Locale('de', 'DE'),
                child: Text('German'),
              ),
              DropdownMenuItem(
                value: Locale('hi', 'IN'),
                child: Text('Hindi'),
              ),
              DropdownMenuItem(
                value: Locale('fr', 'FR'),
                child: Text('Français'),
              ),
              DropdownMenuItem(
                value: Locale('nl', 'NL'),
                child: Text('Dutch'),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black,
              Colors.grey.shade800,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                color: Colors.grey.shade900,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'create_account'.tr(),
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        _buildTextFormField(
                          context: context,
                          controller: usernameController,
                          label: 'username'.tr(),
                          icon: Icons.person,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        _buildTextFormField(
                          context: context,
                          controller: emailController,
                          label: 'email'.tr(),
                          icon: Icons.email,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        _buildTextFormField(
                          context: context,
                          controller: passwordController,
                          label: 'password'.tr(),
                          icon: Icons.lock,
                          isPassword: true,
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              try {
                                await authController.signInWithEmail(
                                  emailController.text,
                                  passwordController.text,
                                );
                                Fluttertoast.showToast(
                                  msg: 'registered_successfully'.tr(),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                );
                                Flexify.goRemove(
                                  const LoginPage(),
                                  animation: FlexifyRouteAnimations.blur,
                                  duration: Durations.medium1,
                                );
                              } catch (e) {
                                Fluttertoast.showToast(
                                  msg: 'registration_failed'.tr(),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                          ),
                          child: Text(
                            'register'.tr(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              await authController.signInWithGoogle();
                              Fluttertoast.showToast(
                                msg: 'google_sign_in_success'.tr(),
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                              );
                            } catch (e) {
                              Fluttertoast.showToast(
                                msg: 'google_sign_in_failed'.tr(),
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                              );
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
                          child: const FaIcon(
                            FontAwesomeIcons.google,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextButton(
                          onPressed: () {
                            Flexify.goRemove(
                              const LoginPage(),
                              animation: FlexifyRouteAnimations.blur,
                              duration: Durations.medium1,
                            );
                          },
                          child: Text(
                            'already_have_account'.tr(),
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.white70,
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.white70,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Colors.white,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Colors.white70,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Colors.transparent,
          ),
        ),
        filled: true,
        fillColor: Colors.grey.shade800.withOpacity(0.8),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '${label}_required'.tr();
        }
        return null;
      },
    );
  }
}
