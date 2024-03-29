import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:insta_king/core/constants/env_assets.dart';
import 'package:insta_king/presentation/views/transactions/insta_transactions.dart';

class WalletAppBar extends StatelessWidget {
  const WalletAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Fund Wallet',
          style: TextStyle(
            fontFamily: 'Montesserat',
            fontSize: 17.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Consumer(
          builder: (context, ref, child) {
            return GestureDetector(
              onTap: () {
                // ref.read(instaTransactionController).getTransactions();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const InstaTransactions(),
                  ),
                );
              },
              child: Row(
                children: [
                  Icon(
                    Icons.history,
                    size: 30.sp,
                  ),
                  SvgPicture.asset(
                    EnvAssets.getSvgPath('arrow-right'),
                    width: 20.w,
                    height: 20.h,
                    // ignore: deprecated_member_use
                    color: Theme.of(context).unselectedWidgetColor,
                    semanticsLabel: 'Search',
                  ),
                ],
              ),
            );
          },
        )
      ],
    );
  }
}


//  Row(
//           children: [
//             Text(
//               'Transactions History',
//               style: TextStyle(
//                 fontFamily: 'Montesserat',
//                 fontSize: 13.sp,
//                 color: EnvColors.darkColor,
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//             Icon(
//               Icons.play_arrow_rounded,
//               size: 13.sp,
//             )
//           ],
//         ),