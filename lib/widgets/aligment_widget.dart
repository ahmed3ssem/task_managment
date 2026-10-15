import 'package:flutter/cupertino.dart';
import 'package:flutter_project_structure/config/PrefHelper/helper.dart';
import 'package:flutter_project_structure/core/utils/app_strings.dart';

abstract class AlignmentType {
  Alignment returnAlignment();
}

class AlignmentWidget extends AlignmentType {
  @override
  Alignment returnAlignment() {
    if (Helper.getCurrentLocal() == AppStrings.arCountryCode) {
      return Alignment.topRight;
    } else {
      return Alignment.topLeft;
    }
  }
}
