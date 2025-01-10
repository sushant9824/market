import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market_app/constant/app_sizes.dart';
import 'package:market_app/constant/colors.dart';
import 'package:market_app/constant/text_styles.dart';
import 'package:market_app/model/product_model/product.dart';

class ProductDetails extends ConsumerWidget {
  final Product product;
  ProductDetails({required this.product});

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product Details',
          style: TextStyles.headingStyle,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 8.r, horizontal: 14.r),
        children: [
          Container(
            height: 310.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: primaryColor.withOpacity(0.5)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: CachedNetworkImage(
                errorWidget: (context, url, error) =>
                    const Center(child: Text('no image')),
                imageUrl: product.marketPictureUrl,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(
                      color: primaryColor, strokeWidth: 4),
                ),
                fit: BoxFit.fill,
              ),
            ),
          ),
          gapH10,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(product.title, style: TextStyles.tileTitle),
              ),
              gapW4,
              Text('Rs. ${product.price.toString()}',
                  style: TextStyles.tileTitle),
            ],
          ),
          Divider(thickness: 0.3, color: primaryColor.withOpacity(0.7)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 38.r,
                  child: Text(
                    product.contactPerson.substring(0, 1),
                    style: TextStyles.headingStyle,
                  ),
                ),
                gapW8,
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.contactPerson,
                      style: TextStyles.infoStyle,
                    ),
                    Text(
                      product.contactNo,
                      style: TextStyles.infoStyle,
                    )
                  ],
                )
              ],
            ),
          ),
          Divider(thickness: 0.3, color: primaryColor.withOpacity(0.7)),
          Text(
            'Description',
            style: TextStyles.tileTitle,
          ),
          Text(
            product.description,
            style: TextStyles.detailStyle,
          ),
          Text(
            'General',
            style: TextStyles.tileTitle,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 6.r, horizontal: 8.r),
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8.0)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Location'),
                  Text(product.address),
                ],
              ),
              Divider(thickness: 0.3, color: primaryColor.withOpacity(0.7)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Delivery'),
                  Text(product.delivery.toString()),
                ],
              ),
              Divider(thickness: 0.3, color: primaryColor.withOpacity(0.7)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Negotiable'),
                  Text(product.negotiable.toString()),
                ],
              ),
              Divider(thickness: 0.3, color: primaryColor.withOpacity(0.7)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Posted Date'),
                  Text(product.addedDate.toString()),
                ],
              ),
              Divider(thickness: 0.3, color: primaryColor.withOpacity(0.7)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Expires Date'),
                  Text(product.expirationDate.toString()),
                ],
              ),
            ]),
          )
        ],
      ),
    );
  }
}
