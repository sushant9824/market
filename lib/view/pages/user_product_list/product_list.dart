import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:market_app/constant/colors.dart';
import 'package:market_app/constant/text_styles.dart';
import 'package:market_app/view/pages/product/product_details.dart';
import 'package:market_app/view/pages/user_product_list/product_edit.dart';

import '../../../provider/product_provider.dart';

enum _MenuValues { edit, delete }

class ProductList extends ConsumerWidget {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final userProducts = ref.watch(productByUidProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Ads', style: TextStyles.headingStyle),
        centerTitle: true,
        elevation: 0,
      ),
      body: userProducts.isLoad
          ? const Center(
              child: CircularProgressIndicator(
              color: primaryColor,
            ))
          : RefreshIndicator(
              color: primaryColor,
              onRefresh: () async {
                ref.invalidate(productByUidProvider);
              },
              child: userProducts.productList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('You haven\'t posted any ads yet !!',
                              style: TextStyles.settingStyles),
                          IconButton(
                              onPressed: () async {
                                ref.invalidate(productByUidProvider);
                              },
                              icon: const Icon(Icons.refresh))
                        ],
                      ),
                    )
                  : userProducts.isError
                      ? Text(userProducts.errorMessage)
                      : ListView.builder(
                          itemCount: userProducts.productList.length,
                          itemBuilder: (ctx, index) {
                            final userProductData =
                                userProducts.productList[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6.0, horizontal: 12.0),
                              child: InkWell(
                                onTap: () {
                                  Get.to(
                                      () => ProductDetails(
                                          product: userProductData),
                                      transition: Transition.leftToRight);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8.r),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: Offset(2, 2))
                                      ]),
                                  child: Stack(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(8.r),
                                                topLeft: Radius.circular(8.r)),
                                            child: Image.network(
                                              userProductData.marketPictureUrl,
                                              height: 130.h,
                                              width: 130.w,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Flexible(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(userProductData.title,
                                                      maxLines: 2,
                                                      style: TextStyles
                                                          .labelTextStyle),
                                                  Text(
                                                      'brand: ${userProductData.brand}',
                                                      style: TextStyles
                                                          .detailStyle),
                                                  Text(
                                                    'Rs. ${userProductData.price.toString()}',
                                                    style: TextStyles
                                                        .labelTextStyle,
                                                  ),
                                                  Text(
                                                      'address: ${userProductData.address}',
                                                      style: TextStyles
                                                          .detailStyle),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: PopupMenuButton<_MenuValues>(
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              value: _MenuValues.edit,
                                              child: Text('Edit',
                                                  style:
                                                      TextStyles.detailStyle),
                                            ),
                                            PopupMenuItem(
                                                value: _MenuValues.delete,
                                                child: Text('Delete',
                                                    style:
                                                        TextStyles.detailStyle))
                                          ],
                                          onSelected: (value) {
                                            switch (value) {
                                              case _MenuValues.edit:
                                                Get.to(
                                                    () => ProductEdit(
                                                        product:
                                                            userProductData),
                                                    transition:
                                                        Transition.leftToRight);
                                                break;
                                              case _MenuValues.delete:
                                                break;
                                            }
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
            ),
    );
  }
}
