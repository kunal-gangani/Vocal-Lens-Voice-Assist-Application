import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:vocal_lens/Views/HomePage/home_page.dart';
import 'package:vocal_lens/Views/RegistrationPage/registration_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Locale _selectedLocale = const Locale('en', 'US');

  void _login() {
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text;
      final password = _passwordController.text;

      if (username == "admin" && password == "123") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              tr(
                "welcome_user",
                args: [username],
              ),
            ),
          ),
        );
        Flexify.goRemove(
          const HomePage(),
          animation: FlexifyRouteAnimations.blur,
          duration: Durations.medium1,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              tr(
                "invalid_credentials",
              ),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade700,
        title: Text(
          tr(
            "login_title",
          ),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          DropdownButton<Locale>(
            value: _selectedLocale,
            dropdownColor: Colors.teal.shade100,
            icon: const Icon(Icons.language, color: Colors.white),
            onChanged: (Locale? newLocale) {
              if (newLocale != null) {
                setState(() {
                  _selectedLocale = newLocale;
                });
                context.setLocale(newLocale);
              }
            },
            items: const [
              Locale('en', 'US'),
              Locale('de', 'DE'),
              Locale('es', 'ES'),
              Locale('fr', 'FR'),
              Locale('hi', 'IN'),
              Locale('nl', 'NL'),
            ].map((locale) {
              return DropdownMenuItem<Locale>(
                value: locale,
                child: Text(
                  locale.languageCode.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.teal.shade300,
              Colors.teal.shade900,
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
                elevation: 12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          tr(
                            "login_title",
                          ),
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal.shade800,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: tr(
                              "username",
                            ),
                            labelStyle: TextStyle(
                              color: Colors.teal.shade700,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(
                              Icons.person,
                              color: Colors.teal,
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return tr(
                                "username_required",
                              );
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: tr(
                              "password",
                            ),
                            labelStyle: TextStyle(
                              color: Colors.teal.shade700,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.teal,
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return tr(
                                "password_required",
                              );
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.teal.shade700,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                              ),
                            ),
                            child: Text(
                              tr("login"),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
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
                            tr(
                              "register_prompt",
                            ),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.teal.shade800,
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
}
