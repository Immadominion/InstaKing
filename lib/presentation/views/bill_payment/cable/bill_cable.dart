import 'dart:core';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta_king/core/constants/enum.dart';
import 'package:insta_king/core/extensions/widget_extension.dart';
import 'package:insta_king/data/services/notification.dart';
import 'package:insta_king/data/controllers/insta_profile_controller.dart';
import 'package:insta_king/data/controllers/subscribe_cable_controller.dart';
import 'package:insta_king/presentation/views/shared_widgets/bottom_sheet_modal.dart';
import 'package:insta_king/presentation/views/shared_widgets/choose_container.dart';
import 'package:insta_king/presentation/views/shared_widgets/cta_button.dart';
import 'package:insta_king/presentation/views/shared_widgets/input_data_viewmodel.dart';
import 'package:insta_king/presentation/views/shared_widgets/recurring_appbar.dart';
import 'package:insta_king/presentation/views/shared_widgets/shared_loading.dart';

/// Feel free to use the code in your projects
/// but do not forget to give me the credits adding
/// my app (Flutter Animation Gallery) where you are gonna use it.
/// ---------------------------------->>>>>>>>>>>>>>>>>>>>>>>>

class BillCable extends ConsumerStatefulWidget {
  const BillCable({super.key});

  @override
  ConsumerState<BillCable> createState() => _BillCableState();
}

class _BillCableState extends ConsumerState<BillCable> {
  final TextEditingController cableNumberController = TextEditingController();

  late String decoderName = '';
  late String cablePlanName = '';
  late num cablePlanId = 0;
  late String decoderType = '';

  @override
  void initState() {
    super.initState();
    ref.read(instaCableController).toGetCableDecoderPlans().then((value) {
      setState(() {});
    });
  }

  void showReusableBottomSheet(
      BuildContext context, future, dataList, onStatusChanged) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            return ReusableBottomSheet(
              future: future,
              getLength: dataList?.length ?? 5,
              title: 'Choose Decoder Plan',
              status: 'initialStatus', // Set your initial status here
              networkPr: dataList,
              onStatusChanged: onStatusChanged,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const RecurringAppBar(
                  appBarTitle: "Subscribe TV",
                ).afmPadding(
                  EdgeInsets.only(
                    bottom: 10.h,
                  ),
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showReusableBottomSheet(
                          context,
                          ref
                              .read(instaCableController)
                              .toGetCableDecoderPlans()
                              .then((value) {
                            setState(() {});
                          }),
                          ref
                              .read(instaCableController)
                              .getCableDecoderModel
                              .data,
                          (newStatus, netName) {
                            setState(() {
                              decoderName = '';
                              cablePlanName = '';
                              cablePlanId = 0;
                              decoderType = '';
                              // ref.read(instaCableController).disposeCable();
                              decoderName =
                                  newStatus?[netName].name.toString() ?? '';
                              decoderType =
                                  newStatus?[netName].id.toString() ?? '';
                              ref
                                  .read(instaCableController)
                                  .toGetCablePlans(num.tryParse(decoderType)!);
                            });
                          },
                        );
                      },
                      child: ChooseContainerFromDropDown(
                        headerText: "Decoder Type",
                        hintText: decoderName != ''
                            ? decoderName
                            : "Choose Decoder Type",
                      ),
                    ),
                    decoderName == ''
                        ? const SizedBox()
                        : GestureDetector(
                            onTap: () {
                              ref
                                  .read(instaCableController)
                                  .disposeCableDecoderModel;
                              showReusableBottomSheet(
                                context,
                                ref.watch(instaCableController).toGetCablePlans(
                                    num.tryParse(decoderType)!),
                                ref
                                    .watch(instaCableController)
                                    .getCablePlanModel
                                    .data,
                                (newStatus, netName) {
                                  setState(() {
                                    cablePlanName =
                                        newStatus?[netName].name.toString() ??
                                            '';
                                    cablePlanId = newStatus?[netName].id ?? 1;
                                  });
                                },
                              );
                            },
                            child: ChooseContainerFromDropDown(
                              headerText: "Decoder Plan",
                              hintText: cablePlanName != ''
                                  ? cablePlanName
                                  : "Choose Decoder Plan",
                            ),
                          ),
                    // .afmPadding(
                    //   EdgeInsets.only(
                    //     bottom: 20.h,
                    //   ),
                    // ),
                    CollectPersonalDetailModel(
                      leadTitle: "Cable Number",
                      hintT: "XXXX XXX XXXX",
                      isPasswordT: false,
                      isdigit: [FilteringTextInputFormatter.digitsOnly],
                      controller: cableNumberController,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    CustomButton(
                      pageCTA: "Proceed",
                      buttonOnPressed: () {
                        setState(() {});
                        ref
                            .read(instaCableController)
                            .tovalidateUserCableEligibiity(
                              num.tryParse(decoderType) ?? 0,
                              cableNumberController.text,
                            )
                            .then(
                          (value) {
                            if (value == true) {
                              ref
                                  .read(instaCableController)
                                  .toPurchaseCable(
                                    cablePlanId,
                                    cableNumberController.text,
                                    decoderType,
                                    ref.read(instaCableController).userName,
                                  )
                                  .then((value) {
                                if (value == true) {
                                  // Handle success

                                  AwesomeDialog(
                                    context: context,
                                    animType: AnimType.scale,
                                    dialogType: DialogType.success,
                                    title: 'Order Successful',
                                    desc:
                                        'You have successfully purchased this Cable Subscription',
                                    btnOkOnPress: () {
                                      Navigator.pop(context);
                                    },
                                  ).show();
                                  LocalNotification.showPurchaseNotification(
                                    title: 'Order Successful',
                                    body:
                                        'Dear ${ref.read(instaProfileController.notifier).model.user?.fullname},\nYour purchase of $cablePlanName is successful.\nYour new balance is ₦${ref.read(instaProfileController.notifier).model.user?.balance}.}',
                                    payload: '',
                                  );
                                }
                              });
                            } else {
                              setState(() {
                                ref.read(instaCableController).loadingState ==
                                    LoadingState.idle;
                              });
                              AwesomeDialog(
                                context: context,
                                animType: AnimType.scale,
                                dialogType: DialogType.error,
                                title: 'Order Failed',
                                desc: 'Your order could not be placed',
                                btnOkOnPress: () {
                                  Navigator.pop(context);
                                },
                              ).show();
                            }
                          },
                        );
                      },
                    ).afmPadding(
                      EdgeInsets.only(
                        top: 20.sp,
                      ),
                    ),
                  ],
                ).afmPadding(
                  EdgeInsets.symmetric(
                    horizontal: 20.sp,
                  ),
                ),
              ],
            ).afmNeverScroll,
            if (ref.read(instaCableController).loadingState ==
                LoadingState.loading)
              const TransparentLoadingScreen(),
          ],
        ),
      ),
    );
  }
}
