import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:market_app/constant/colors.dart';
import 'package:market_app/constant/font_styles.dart';
import 'package:market_app/constant/text_styles.dart';
import 'package:market_app/view/pages/drawer/navigation_drawer.dart';
import 'package:market_app/view/pages/product/all_product_page.dart';
import 'package:market_app/view/pages/product/product_create.dart';
import 'package:market_app/view/pages/user_product_list/product_list.dart';
import 'pages/setting/app_setting.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  // int selectedIndex = 0;
  // static List<Widget> _widgetOptions = <Widget>[
  //   AllProduct(),
  //   ProductList(),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'HomePage',
          style: TextStyles.headingStyle,
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => const AppSettings(),
                    transition: Transition.leftToRight);
              },
              icon: const Icon(Icons.settings, color: primaryColor))
        ],
      ),
      drawer: NavigationDrawerWidget(),
      body: AllProduct(),
    );
  }
}
