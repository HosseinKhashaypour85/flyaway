import 'dart:ui';

import 'package:flutter/material.dart';

IconButton iconButtonWidget(VoidCallback onTap , Widget icon){
  return IconButton(onPressed: onTap, icon: icon);
}