import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'model/auth_model/user.dart';
import 'view/login_state.dart';

final box = Provider<List<User>>((ref) => []);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //lock orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  final userBox = await Hive.openBox<User>('user');

  runApp(ProviderScope(
      overrides: [box.overrideWithValue(userBox.values.toList())],
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height),
      builder: (BuildContext context, Widget? child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              // colorScheme: ColorScheme.fromSwatch().copyWith(primary: primaryColor),
              useMaterial3: true,
              appBarTheme: AppBarTheme(
                  surfaceTintColor: Colors.transparent,
                  backgroundColor: Colors.white),
              scaffoldBackgroundColor: Colors.white),
          home: LoginStatus(),
        );
      },
    );
  }
}
