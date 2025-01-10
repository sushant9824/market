import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:market_app/constant/colors.dart';

import '../../../constant/common widget/custom_button.dart';
import '../../../constant/common widget/profile_info.dart';
import '../../../constant/text_styles.dart';
import '../../../provider/user_detail_provider.dart';
import 'profile_edit.dart';

class Profile extends ConsumerWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final userData = ref.watch(userDetailsProvider);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Profile',
            style: TextStyles.headingStyle,
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: userData.isLoad
            ? const Center(
                child: CircularProgressIndicator(color: primaryColor))
            : ListView(
                padding: EdgeInsets.symmetric(horizontal: 20.r),
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  userData.userDetail.profilePictureUrl.isEmpty
                      ? CircleAvatar(
                          radius: 80.r, child: const Icon(Icons.person))
                      : CircleAvatar(
                          radius: 80.r,
                          backgroundColor: primaryColor.withOpacity(0.4),
                          child: AspectRatio(
                            aspectRatio: 1.0,
                            child: ClipOval(
                              child: Image.network(
                                  userData.userDetail.profilePictureUrl,
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                  SizedBox(
                    height: 28.h,
                  ),
                  ProfileInfo(
                      userData.userDetail.fullName,
                      const Icon(Icons.person_2_outlined,
                          color: textIconColor)),
                  ProfileInfo(userData.userDetail.mobileNumber,
                      const Icon(Icons.phone_outlined, color: textIconColor)),
                  ProfileInfo(userData.userDetail.email,
                      const Icon(Icons.email_outlined, color: textIconColor)),
                  CustomButton(
                      onPressed: () {
                        Get.to(
                            () => ProfileEdit(userDetail: userData.userDetail),
                            transition: Transition.leftToRight);
                      },
                      text: 'Update Profile'),
                ],
              ));
  }
}
