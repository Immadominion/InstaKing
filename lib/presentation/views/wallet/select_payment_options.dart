import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta_king/core/extensions/widget_extension.dart';
import 'package:insta_king/presentation/views/shared_widgets/cta_button.dart';
import 'package:insta_king/presentation/views/shared_widgets/input_data_viewmodel.dart';

class SelectPaymentOptions extends StatelessWidget {
  const SelectPaymentOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Payment Option',
            style: TextStyle(
              fontFamily: 'Montesserat',
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
            ),
          ).afmPadding(
            EdgeInsets.only(
              bottom: 20.sp,
            ),
          ),
          const CollectPersonalDetailModel(
                  leadTitle: 'Amount(NGN)', hintT: '500')
              .afmPadding(
            EdgeInsets.only(
              bottom: 20.sp,
            ),
          ),
          CustomButton(
            pageCTA: 'Pay',
            buttonOnPressed: () {},
          )
        ],
      ).afmPadding(
        EdgeInsets.all(20.sp),
      ),
    )
        .afmBorderRadius(
          BorderRadius.circular(10.r),
        )
        .afmPadding(
          EdgeInsets.only(bottom: 20.sp, left: 20.sp, right: 20.sp),
        );
  }
}
