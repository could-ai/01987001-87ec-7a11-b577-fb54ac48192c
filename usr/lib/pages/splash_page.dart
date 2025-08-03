import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:couldai_user_app/pages/login_page.dart';
import 'package:couldai_user_app/chat_screen.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    // await for for the widget to be fully built
    await Future.delayed(Duration.zero);
    final session = Supabase.instance.client.auth.currentSession;
    if (!mounted) return;
    if (session == null) {
      Navigator.of(context).pushAndRemoveUntil(LoginPage.route(), (route) => false);
    } else {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const ChatScreen()), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
