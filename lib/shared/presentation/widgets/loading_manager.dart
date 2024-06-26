import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../theme/extra_colors.dart';

class LoadingManager extends StatelessWidget {
  const LoadingManager(
      {super.key, required this.isLoading, required this.child});
  final bool isLoading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        isLoading
            ? Container(
                color: ExtraColors.black.withOpacity(0.85),
              )
            : Container(),
        isLoading
            ? Center(
                child: SpinKitWaveSpinner(
                    color: Theme.of(context).primaryColor,
                    size: 70,
                    waveColor: ExtraColors.link),
              )
            : Container()
      ],
    );
  }
}
