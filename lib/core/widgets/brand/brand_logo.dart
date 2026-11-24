import 'package:flutter/material.dart';

import '../../theme/app_text_styles.dart';
import 'logo_mark.dart';

/// Full logo: the mark and the "Oussema Bouchahwa" wordmark, with the app
/// name underneath. Used on onboarding and in the README.
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, required this.markSize, this.dark = false});

  /// Side of the mark; the wordmark scales with it.
  final double markSize;

  /// Light text for dark backgrounds.
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final ink = dark ? BrandColors.parchment : BrandColors.green;
    final m = markSize;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        LogoMark(size: m),
        SizedBox(width: m * 0.28),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Oussema Bouchahwa',
              style: TextStyle(
                fontFamily: AppTextStyles.serifFamily,
                fontWeight: FontWeight.w600,
                fontSize: m * 0.34,
                height: 1.05,
                letterSpacing: -m * 0.004,
                color: ink,
              ),
            ),
            SizedBox(height: m * 0.08),
            Text(
              'NIZAM  ·  DAILY PLANNER',
              style: TextStyle(
                fontFamily: AppTextStyles.sansFamily,
                fontWeight: FontWeight.w700,
                fontSize: m * 0.12,
                letterSpacing: m * 0.03,
                color: BrandColors.brass,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
