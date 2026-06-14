import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visionary_lens/providers/auth_provider.dart';
import 'package:visionary_lens/views/register_view.dart';
import 'package:flutter_tts/flutter_tts.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FlutterTts _tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _speak("Login Screen. Double tap the bottom to register.");
  }

  Future<void> _speak(String text) async {
    await _tts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("LOGIN", style: TextStyle(letterSpacing: 2)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "EMAIL",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                style: const TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "PASSWORD",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                style: const TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 70,
                child: ElevatedButton(
                  onPressed: auth.isLoading
                      ? null
                      : () async {
                          await auth.login(_emailController.text, _passwordController.text);
                          if (auth.isAuthenticated) {
                            _speak("Login Successful. Welcome to Visionary Lens.");
                          } else {
                            _speak("Login Failed. Please check your credentials.");
                          }
                        },
                  child: auth.isLoading
                      ? const CircularProgressIndicator()
                      : const Text("LOGIN NOW", style: TextStyle(fontSize: 24)),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  _speak("Moving to Registration Screen");
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterView()));
                },
                child: const Text("NEW USER? REGISTER HERE", style: TextStyle(fontSize: 18, color: Colors.blue)),
              ),
            ],
        ),
      ),
    );
  }
}
