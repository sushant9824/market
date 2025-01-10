import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:market_app/view/pages/product/product_create.dart';
import 'package:market_app/view/pages/product/product_details.dart';

import '../../../constant/colors.dart';
import '../../../constant/font_styles.dart';
import '../../../constant/text_styles.dart';
import '../../../provider/product_provider.dart';

class AllProduct extends ConsumerStatefulWidget {
  @override
  ConsumerState<AllProduct> createState() => _AllProductState();
}

class _AllProductState extends ConsumerState<AllProduct> {
  bool isExtended = true;

  @override
  Widget build(BuildContext context) {
    final productData = ref.watch(productShow);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.w),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              alignment: Alignment.centerLeft,
              height: 45.h,
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(color: greyColor),
                  borderRadius: BorderRadius.circular(10.w)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Search product', style: TextStyles.hintStyle),
                  Icon(CupertinoIcons.search, color: greyColor)
                ],
              ),
            ),
          ),
          Expanded(
            child: productData.when(
                data: (data) {
                  return RefreshIndicator(
                    color: primaryColor,
                    onRefresh: () async {
                      ref.invalidate(productShow);
                    },
                    child: data.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('No Products Yet',
                                    style: TextStyles.labelTextStyle),
                                IconButton(
                                    onPressed: () async {
                                      ref.invalidate(productShow);
                                    },
                                    icon: productData.isRefreshing
                                        ? CircularProgressIndicator()
                                        : Icon(Icons.refresh))
                              ],
                            ),
                          )
                        : NotificationListener<UserScrollNotification>(
                            onNotification: (notification) {
                              if (notification.direction ==
                                  ScrollDirection.forward) {
                                if (!isExtended) {
                                  setState(() {
                                    isExtended = true;
                                  });
                                }
                              } else if (notification.direction ==
                                  ScrollDirection.reverse) {
                                if (isExtended) {
                                  setState(() {
                                    isExtended = false;
                                  });
                                }
                              }
                              return true;
                            },
                            child: MasonryGridView.builder(
                                key: const PageStorageKey<String>('page'),
                                itemCount: data.length,
                                padding: EdgeInsets.all(6.r),
                                gridDelegate:
                                    const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                ),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                          border: Border.all(
                                              color: Colors.grey.shade100),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                                offset: Offset(2, 2))
                                          ]),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            Get.to(
                                                () => ProductDetails(
                                                    product: data[index]),
                                                transition: Transition
                                                    .leftToRightWithFade);
                                          },
                                          child: Column(
                                            children: [
                                              CachedNetworkImage(
                                                errorWidget: (context, url,
                                                        error) =>
                                                    Image.asset(
                                                        'assets/images/not_found.png'),
                                                imageUrl: data[index]
                                                    .marketPictureUrl,
                                                placeholder: (context, url) =>
                                                    const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                          color: primaryColor,
                                                          strokeWidth: 1),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Flexible(
                                                            child: Text(
                                                          data[index].title,
                                                          style: TextStyle(
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              fontSize: 16.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        )),
                                                        Text(
                                                            'Rs. ${data[index].price.toString()}'),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.star,
                                                          color:
                                                              Color(0xffFFC501),
                                                          size: 20.r,
                                                        ),
                                                        Text(
                                                            '${data[index].averageRating}/5'),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                  );
                },
                error: (error, stack) => Text('$error'),
                loading: () => const Center(
                        child: CircularProgressIndicator(
                      color: primaryColor,
                    ))),
          ),
        ],
      ),

      //--------------Fab-----------------
      floatingActionButton: AnimatedContainer(
        duration: const Duration(milliseconds: 130),
        width: isExtended ? 120.w : 50.w,
        height: 50.h,
        curve: Curves.linear,
        child: FloatingActionButton.extended(
            isExtended: isExtended,
            backgroundColor: primaryColor,
            onPressed: () {
              Get.to(() => ProductCreate(), transition: Transition.leftToRight);
            },
            icon: const Padding(
              padding: EdgeInsets.only(left: 4.0),
              child: Icon(Icons.add, color: whiteColor),
            ),
            label: Text(
              'Post Ads',
              style: TextStyle(
                  fontFamily: FontStyles.poppins,
                  fontSize: FontSizes.s15,
                  color: whiteColor),
            )),
      ),
    );
  }
}
