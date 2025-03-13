import 'package:easy_localization/easy_localization.dart';
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocal_lens/Controllers/auth_controller.dart';
import 'package:vocal_lens/Controllers/theme_controller.dart';

class UserSettingsPage extends StatelessWidget {
  const UserSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Flexify.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
          ),
        ),
        title: Text(
          tr(
            "User Settings",
          ),
        ),
        backgroundColor: Colors.blueGrey.shade900,
      ),
      body: Consumer<AuthController>(builder: (context, authValue, _) {
        final user = authValue.user;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Card(
                elevation: 5,
                color: Colors.blueGrey.shade800,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      user?.photoURL ??
                          'https://img.freepik.com/premium-photo/pink-create-account-screen-icon-isolated-blue-background-minimalism-concept-3d-illustration-3d-render_549897-72.jpg?uid=R120576166&ga=GA1.1.132821578.1730041723&semt=ais_hybrid',
                    ),
                  ),
                  title: Text(
                    user?.displayName ?? 'John Doe',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    user?.email ?? 'johndoe@gmail.com',
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Card(
                elevation: 5,
                color: Colors.blueGrey.shade800,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text(
                    tr('Notifications'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    tr('enable_disable_notifications'),
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                  trailing: Switch(
                    value: true,
                    onChanged: (bool value) {},
                    activeColor: Colors.blueGrey.shade900,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Card(
                elevation: 5,
                color: Colors.blueGrey.shade800,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Consumer<ThemeController>(
                  builder: (context, themeController, value) {
                    return ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Text(
                        tr('dark_mode'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        tr('enable_disable_dark_theme'),
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                      trailing: Switch(
                        value: themeController.isDarkMode,
                        onChanged: (bool value) {
                          themeController.toggleTheme();
                        },
                        activeColor: Colors.blueGrey.shade200,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Card(
                elevation: 5,
                color: Colors.blueGrey.shade800,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text(
                    tr('language'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    tr('change_app_language'),
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                  onTap: () {},
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Card(
                elevation: 5,
                color: Colors.blueGrey.shade800,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text(
                    tr('log_out'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    tr('log_out_account'),
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                  trailing: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        Colors.blueGrey.shade800,
                      ),
                    ),
                    onPressed: () async {
                      bool? shouldSignOut = await showDialog<bool>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.black,
                            title: Text(
                              tr('sign_out'),
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            content: Text(
                              tr('log_out_confirm'),
                              style: const TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text(
                                  tr('cancel'),
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                              ),
                              TextButton(
                                child: Text(
                                  tr('im_sure'),
                                  style: const TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                              ),
                            ],
                          );
                        },
                      );

                      if (shouldSignOut == true) {
                        await authValue.signOut();
                      }
                    },
                    child: const Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        );
      }),
    );
  }
}
