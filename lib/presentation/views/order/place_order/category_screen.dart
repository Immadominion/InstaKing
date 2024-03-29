import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:insta_king/core/constants/constants.dart';
import 'package:insta_king/data/controllers/insta_categories_controller.dart';
import 'package:insta_king/presentation/views/shared_widgets/shared_loading.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  const CategoryScreen({super.key});

  @override
  ConsumerState<CategoryScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends ConsumerState<CategoryScreen> {
  late final CategoriesController categoriesControllerScreen =
      ref.watch(instaCategoriesController);

  @override
  Widget build(BuildContext context) {
    // Future(() async {
    //   await ref.read(instaCategoriesController).toGetDropdownItemsById(
    //         ref.read(instaCategoriesController).selectedCategory,
    //       );
    // });
    return FutureBuilder(
      future: categoriesControllerScreen.toGetAllCategories(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: TransparentLoadingScreen()),
          ); // Show loading indicator while fetching data
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          // Use ListView.builder with the data returned by toGetAllCategories
          List<CategoryItem> categories =
              categoriesControllerScreen.allCategoriesModel;
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: AppBar(
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  // setState(() {});
                },
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                ),
              ),
              title: Text(
                'Categories',
                style: TextStyle(
                  fontFamily: 'Montesserat',
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            body: SafeArea(
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  CategoryItem category = categories[index];
                  return GestureDetector(
                    onTap: () {
                      categoriesControllerScreen.setCatValue(
                          category.id, category.name);
                      debugPrint(
                          'ID: ${category.id.toString()} and NAME: ${category.name.toString()}');
                      categoriesControllerScreen
                          .toGetDropdownItemsById(category.id);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10.sp),
                      margin: EdgeInsets.symmetric(
                        vertical: 10.w,
                        horizontal: 20.h,
                      ),
                      height: 40.h,
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width - 40.w,
                      decoration: BoxDecoration(
                        color: InstaColors.lightColor,
                        border: Border.all(
                          color: Theme.of(context).shadowColor,
                          width: 0.5.sp,
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: AutoSizeText(
                        category.name,
                        minFontSize: 12.sp,
                        stepGranularity: 2.sp,
                        style: TextStyle(
                          fontFamily: 'Montesserat',
                          fontWeight: FontWeight.w500,
                          fontSize: 13.sp,
                          color: Theme.of(context).colorScheme.scrim,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }
      }),
    );
  }
}
