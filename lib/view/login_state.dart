import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import '../model/auth_model/user.dart';
import '../provider/auth_provider.dart';
import 'auth/login.dart';
import 'dashboard.dart';

class LoginStatus extends ConsumerStatefulWidget {
  const LoginStatus({super.key});

  @override
  ConsumerState<LoginStatus> createState() => _LoginStatusState();
}

class _LoginStatusState extends ConsumerState<LoginStatus> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAutoLoginSetting();
  }

  bool autoLogin = true;
  void getAutoLoginSetting() async {
    var box = await Hive.openBox('autologin');
    bool autoLoginSetting = box.get('key', defaultValue: true);
    setState(() {
      autoLogin = autoLoginSetting;
      // print(autoLogin);
    });
    box.close();
    if (!autoLogin) {
      ref.read(loginProvider.notifier).userLogOut();
      // auth.user.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(loginProvider);
    return auth.user.isEmpty ? Login() : DashboardPage();
  }
}
