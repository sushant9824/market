import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:market_app/constant/colors.dart';
import 'package:market_app/constant/text_styles.dart';
import '../../../provider/user_detail_provider.dart';
import '../user_product_list/product_list.dart';

class NavigationDrawerWidget extends ConsumerWidget {
  const NavigationDrawerWidget({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final userData = ref.watch(userDetailsProvider);
    Widget buildMenuItem(BuildContext context,
        {required String text, void Function()? onTap}) {
      return Material(
        color: Colors.transparent,
        child: Column(
          children: [
            ListTile(
              title: Text(
                text,
                style: TextStyles.labelTextStyle,
              ),
              onTap: onTap,
            ),
            const Divider()
          ],
        ),
      );
    }

    void selectedItem(BuildContext context, int index) {
      Navigator.of(context).pop();
      switch (index) {
        case 0:
          Get.to(() => ProductList(), transition: Transition.leftToRight);
          break;
      }
    }

    return Drawer(
      width: MediaQuery.of(context).size.width / 1.5,
      child: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(
              height: 160.h,
              child: userData.isLoad
                  ? const Text('loading...')
                  : CachedNetworkImage(
                      height: 200.h,
                      width: double.infinity,
                      errorWidget: (context, url, error) =>
                          Image.asset('assets/images/not_found.png'),
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      imageUrl: userData.userDetail.profilePictureUrl,
                      fit: BoxFit.fitWidth,
                    )),
          buildMenuItem(
            context,
            text: 'Your Post',
            onTap: () {
              selectedItem(context, 0);
            },
          ),
        ],
      )),
    );
  }
}
