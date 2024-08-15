import 'package:flutter/material.dart';

import 'curved_edges.dart';

class TCurvedEdgeWidget extends StatelessWidget {
  const TCurvedEdgeWidget({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      //--- Độ cong của cạnh
      clipper: TCustomCurvedEdges(),
      //--- Dùng để chèn child khác khi cần
      child: child,
    );
  }
}