import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:market_app/constant/colors.dart';
import 'package:market_app/constant/font_styles.dart';
import '../../../constant/common widget/custom_button.dart';
import '../../../constant/common widget/toast_alert.dart';
import '../../../constant/text_styles.dart';
import '../../../provider/auth_provider.dart';
import '../change_password/change_password.dart';
import '../profile/profile.dart';
import 'setting_list.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppSettings extends ConsumerStatefulWidget {
  const AppSettings({super.key});

  @override
  ConsumerState<AppSettings> createState() => _AppSettingsState();
}

class _AppSettingsState extends ConsumerState<AppSettings> {
  //auto login status
  bool autoLogin = true;
  void getAutoLoginSetting() async {
    var box = await Hive.openBox('autologin');
    bool autoLoginSetting = box.get('key', defaultValue: true);
    setState(() {
      autoLogin = autoLoginSetting;
      // print(autoLogin);
    });
    box.close();
  }

  void saveAutoLoginSetting(bool autoLogin) async {
    var box = await Hive.openBox('autologin');
    box.clear();
    await box.put('key', autoLogin);
    box.close();
  }

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAutoLoginSetting();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(loginProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Setting',
          style: TextStyles.headingStyle,
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 18.r),
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          SettingList(
            text: 'Profile',
            widget: const Icon(Icons.chevron_right),
            onTap: () {
              Get.to(() => Profile(), transition: Transition.leftToRight);
            },
          ),
          SettingList(
            text: 'Change Password',
            widget: const Icon(Icons.chevron_right),
            onTap: () {
              Get.to(() => ChangePassword(),
                  transition: Transition.leftToRight);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Auto Login', style: TextStyles.settingStyles),
              Transform.scale(
                scale: 0.95,
                child: Switch(
                  value: autoLogin,
                  inactiveTrackColor: Colors.red.shade300,
                  inactiveThumbColor: Colors.red.shade500,
                  activeColor: Colors.lightGreen,
                  activeTrackColor: Colors.lightGreen.shade400,
                  onChanged: (value) {
                    setState(() {
                      autoLogin = value;
                      // print(autoLogin);
                      saveAutoLoginSetting(autoLogin);
                      autoLogin
                          ? Toasts.showSuccess('Autologin Enabled')
                          : Toasts.showSuccess('Autologin Disabled');
                    });
                  },
                ),
              ),
            ],
          ),
          SettingList(
            text: 'Feedback',
            widget: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          SettingList(
            text: 'App Version',
            widget: Text(_packageInfo.version, style: TextStyles.settingStyles),
            onTap: () {},
          ),
          CustomButton(
              onPressed: () {
                showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(10.0))),
                    context: context,
                    builder: (context) {
                      return SizedBox(
                        height: 250.h,
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 4),
                              height: 4.h,
                              width: 60.w,
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(10.0)),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25.0, vertical: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text('Are you sure?',
                                      style: TextStyles.detailStyle),
                                  SizedBox(height: 8.h),
                                  Text('Are you sure you want to Logout ? ',
                                      style: TextStyles.infoStyle),
                                ],
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25.0),
                              //logout button function
                              child: CustomButton(
                                text: 'Confirm',
                                onPressed: () async {
                                  final res = await ref
                                      .read(loginProvider.notifier)
                                      .userLogOut();
                                  if (res == 'success') {
                                    Navigator.of(context)
                                        .popUntil((route) => route.isFirst);
                                    Toasts.showSuccess('Logout successful !!');
                                  }
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25.0, vertical: 10.0),
                              child: InkWell(
                                splashColor: Colors.red,
                                borderRadius: BorderRadius.circular(8.0),
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border.all(
                                          color: Colors.red.withOpacity(0.8),
                                          width: 2.0)),
                                  child: Text('Cancel',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: FontSizes.s16,
                                          fontFamily: FontStyles.poppins)),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    });
              },
              text: 'logout')
        ],
      ),
    );
  }
}
