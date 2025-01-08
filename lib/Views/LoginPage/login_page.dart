import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:vocal_lens/Controllers/auth_controller.dart';
import 'package:vocal_lens/Views/HomePage/home_page.dart';
import 'package:vocal_lens/Views/RegistrationPage/registration_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
      ),
      body: Consumer<AuthController>(
        builder: (context, authController, _) {
          return Container(
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
                        key: GlobalKey<FormState>(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              tr("login_title"),
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
                              controller: TextEditingController(),
                              decoration: InputDecoration(
                                labelText: tr("email"),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: const Icon(
                                  Icons.email,
                                  color: Colors.teal,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return tr(
                                    "email_required",
                                  );
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            TextFormField(
                              controller: TextEditingController(),
                              decoration: InputDecoration(
                                labelText: tr(
                                  "password",
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: Colors.teal,
                                ),
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
                                onPressed: () async {
                                  await authController.signInWithEmail(
                                    'email@example.com',
                                    'password',
                                  );
                                  if (authController.isAuthenticated) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                        tr("welcome_user", args: [
                                          authController.user?.email ?? "User"
                                        ]),
                                      ),
                                    ));
                                    Flexify.goRemove(
                                      const HomePage(),
                                      animation: FlexifyRouteAnimations.blur,
                                      duration: Durations.medium1,
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal.shade700,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
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
                            ElevatedButton.icon(
                              onPressed: () async {
                                await authController.signInWithGoogle();
                                if (authController.isAuthenticated) {
                                  Flexify.goRemove(
                                    const HomePage(),
                                    animation: FlexifyRouteAnimations.blur,
                                    duration: Durations.medium1,
                                  );
                                }
                              },
                              icon: const Icon(
                                Icons.login,
                              ),
                              label: Text(
                                tr(
                                  "login_google",
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade400,
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
                                tr("register_prompt"),
                                style: TextStyle(
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
          );
        },
      ),
    );
  }
}
