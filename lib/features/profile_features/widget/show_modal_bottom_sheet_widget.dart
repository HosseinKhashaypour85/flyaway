import 'package:flutter/material.dart';
import 'package:flyaway/features/profile_features/widget/show_modal_content_widget.dart';

import '../../../config/app_config/app_shapes/border_radius.dart';
import '../../../config/app_config/app_shapes/media_query.dart';

void showModalBottomSheetWidget(BuildContext context, String phone) {
  showModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        width: getAllWidth(context),
        decoration: BoxDecoration(
          borderRadius: getBorderRadiusFunc(40),
          color: Colors.white,
        ),
        child: showModalContent(phone),
      );
    },
  );
}