import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../providers/auth_provider.dart';
import '../../../core/routes/route_names.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final ticketController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            margin: const EdgeInsets.all(20),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.directions_bus, size: 90),

                    const SizedBox(height: 15),

                    const Text(
                      "E-BUS",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      width > 600
                          ? "Platform Monitoring Transportasi"
                          : "Transport Monitoring",
                    ),

                    const SizedBox(height: 30),

                    CustomTextField(
                      label: "Email",
                      icon: Icons.email,
                      controller: emailController,
                    ),

                    const SizedBox(height: 15),

                    CustomTextField(
                      label: "Password",
                      icon: Icons.lock,
                      controller: passwordController,
                      obscureText: true,
                    ),

                    const SizedBox(height: 20),

                    Consumer<AuthProvider>(
                      builder: (context, auth, child) {
                        return CustomButton(
                          text: auth.isLoading ? "Loading..." : "Login",

                          onPressed: () async {
                            try {
                              await auth.login(
                                email: emailController.text,

                                password: passwordController.text,
                              );

                              final role = auth.currentUser!.role.toLowerCase();

                              if (role == "super_admin") {
                                context.go("/super-admin");
                              } else if (role == "admin_perusahaan") {
                                context.go("/admin-company");
                              } else if (role == "driver") {
                                context.go("/driver-main");
                              } else if (role == "penumpang") {
                                context.go("/passenger-main");
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 10),

                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.g_mobiledata),
                      label: const Text("Login dengan Google"),
                    ),

                    const SizedBox(height: 10),

                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.facebook),
                      label: const Text("Login dengan Facebook"),
                    ),

                    const SizedBox(height: 10),

                    TextButton(
                      onPressed: () {
                        context.go(RouteNames.forgotPassword);
                      },
                      child: const Text("Lupa Password?"),
                    ),

                    TextButton(
                      onPressed: () {
                        context.go(RouteNames.register);
                      },
                      child: const Text("Belum punya akun? Register"),
                    ),

                    const SizedBox(height: 20),

                    const Divider(),

                    const SizedBox(height: 15),

                    const Text(
                      "Tracking Armada",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 15),

                    CustomTextField(
                      label: "Nomor Tiket",
                      icon: Icons.confirmation_number,
                      controller: ticketController,
                    ),

                    const SizedBox(height: 15),

                    CustomButton(text: "Lihat Tracking", onPressed: () {}),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
