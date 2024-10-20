import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';
import '../curved_edges/curved_edges_widget.dart';
import 'circular_container.dart';

class TPrimaryHeaderContainer extends StatelessWidget {
  const TPrimaryHeaderContainer({
    super.key, required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TCurvedEdgeWidget(
      child: Container(
        color: TColors.primary1,
        // padding: const EdgeInsets.all(0),
        // child: SizedBox(
        //   height: 400,
          child: Stack(
            children: [
              //--- Background custom shape
              Positioned(
                  top: 150,
                  right: 250,
                  child: TCircularContainer(
                      backgroundColor: TColors.primary2.withOpacity(0.5)
                  )),
              Positioned(
                  top: -150,
                  right: -250,
                  child: TCircularContainer(
                    backgroundColor: TColors.white.withOpacity(0.2),
                  )),
              Positioned(
                  top: 100,
                  right: -300,
                  child: TCircularContainer(
                    backgroundColor: TColors.primary2.withOpacity(0.3),
                  )),
              child,
            ],
          ),
        // ),
      ),
    );
  }
}