import 'package:flutter/material.dart';

import '../../../utils/constants/sizes.dart';

class TGrildLayout extends StatelessWidget {
  const TGrildLayout({
      super.key,
      required this.itemCount,
      required this.itemBuiler,
      this.mainAxisExtent = 288
      });

  final int itemCount;
  final double? mainAxisExtent;
  final Widget? Function(BuildContext, int) itemBuiler;

  @override
  Widget build(BuildContext context) {
    return  GridView.builder(
      itemCount: itemCount,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: mainAxisExtent,
        mainAxisSpacing: TSizes.gridViewSpacing,
        crossAxisSpacing: TSizes.gridViewSpacing,
      ),
      itemBuilder: itemBuiler,
    );
  }
}
