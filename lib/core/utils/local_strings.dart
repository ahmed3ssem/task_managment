// ignore_for_file: implementation_imports
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_localization/src/localization/flutter_localization_translator.dart';

extension StringTrExtension on String {
  /// Translates a string key directly.
  /// Usage: 'noData'.tr or AppLocale.noData.tr
  String get tr => FlutterLocalizationTranslator.instance.getStringOrKey(this);

  /// Optional: Translates with [BuildContext] for reactive widget rebuilds on language change.
  String trContext(BuildContext context) => getString(context);
}

class LocalStrings {
  static String get noData => 'noData'.tr;
  static String get english => 'english'.tr;
  static String get arabic => 'arabic'.tr;
  static String get loadingMore => 'loadingMore'.tr;
  static String get refresh => 'refresh'.tr;
  static String get somethingWentWrong => 'somethingWentWrong'.tr;
  static String get pleaseTryAgain => 'pleaseTryAgain'.tr;
  static String get reloadScreen => 'reloadScreen'.tr;
  static String get loading => 'loading'.tr;
  static String get pleaseWait => 'pleaseWait'.tr;
  static String get ok => 'ok'.tr;
  static String get skip => 'skip'.tr;
  static String get taskManagement => 'taskManagement'.tr;
  static String get all => 'all'.tr;
  static String get marketing => 'marketing'.tr;
  static String get software => 'software'.tr;
  static String get finance => 'finance'.tr;
  static String get researchAndDevelopment => 'researchAndDevelopment'.tr;
  static String get search => 'search'.tr;
  static String get filter => 'filter'.tr;
  static String get createBoard => 'createBoard'.tr;
  static String get department => 'department'.tr;
  static String get creationDate => 'creationDate'.tr;
  static String get owner => 'owner'.tr;
  static String get boardName => 'boardName'.tr;
  static String get enterBoardName => 'enterBoardName'.tr;
  static String get boardDepartment => 'boardDepartment'.tr;
  static String get selectDepartment => 'selectDepartment'.tr;
  static String get boardDescription => 'boardDescription'.tr;
  static String get enterBoardDescription => 'enterBoardDescription'.tr;
  static String get save => 'save'.tr;
  static String get nameRequired => 'nameRequired'.tr;
  static String get departmentRequired => 'departmentRequired'.tr;
  static String get descriptionRequired => 'descriptionRequired'.tr;
  static String get boardCreatedSuccessfully => 'boardCreatedSuccessfully'.tr;
  static String get nothingToShowYet => 'nothingToShowYet'.tr;
}

mixin AppLocale {
  static const String nothingToShowYet = 'nothingToShowYet';
  static const String noData = 'noData';
  static const String english = 'english';
  static const String arabic = 'arabic';
  static const String loadingMore = 'loadingMore';
  static const String refresh = 'refresh';
  static const String somethingWentWrong = 'somethingWentWrong';
  static const String pleaseTryAgain = 'pleaseTryAgain';
  static const String reloadScreen = 'reloadScreen';
  static const String loading = 'loading';
  static const String pleaseWait = 'pleaseWait';
  static const String ok = 'ok';
  static const String skip = 'skip';
  static const String taskManagement = 'taskManagement';
  static const String all = 'all';
  static const String marketing = 'marketing';
  static const String software = 'software';
  static const String finance = 'finance';
  static const String researchAndDevelopment = 'researchAndDevelopment';
  static const String search = 'search';
  static const String filter = 'filter';
  static const String createBoard = 'createBoard';
  static const String department = 'department';
  static const String creationDate = 'creationDate';
  static const String owner = 'owner';
  static const String boardName = 'boardName';
  static const String enterBoardName = 'enterBoardName';
  static const String boardDepartment = 'boardDepartment';
  static const String selectDepartment = 'selectDepartment';
  static const String boardDescription = 'boardDescription';
  static const String enterBoardDescription = 'enterBoardDescription';
  static const String save = 'save';
  static const String nameRequired = 'nameRequired';
  static const String departmentRequired = 'departmentRequired';
  static const String descriptionRequired = 'descriptionRequired';
  static const String boardCreatedSuccessfully = 'boardCreatedSuccessfully';

  static const Map<String, dynamic> AR = {
    noData: "لا يوجد بيانات",
    english: "Proceed With English",
    arabic: "المتابعة باللغة العربية",
    loadingMore: "جاري تحميل المزيد...",
    refresh: "إعادة المحاولة",
    somethingWentWrong: "حدث خطأ ما",
    pleaseTryAgain: "يرجى المحاولة مرة أخرى",
    reloadScreen: "إعادة تحميل الشاشة",
    loading: "جاري التحميل",
    pleaseWait: "يرجى الانتظار",
    ok: "حسناً",
    skip: "تخطي",
    taskManagement: "إدارة المهام",
    all: "الكل",
    marketing: "التسويق",
    software: "البرمجيات",
    finance: "المالية",
    researchAndDevelopment: "البحث والتطوير",
    search: "بحث",
    filter: "تصفية",
    createBoard: "إنشاء لوحة",
    department: "القسم: ",
    creationDate: "تاريخ الإنشاء: ",
    owner: "المالك",
    boardName: "اسم اللوحة",
    enterBoardName: "أدخل اسم اللوحة",
    boardDepartment: "القسم",
    selectDepartment: "اختر القسم",
    boardDescription: "الوصف",
    enterBoardDescription: "أدخل وصف اللوحة",
    save: "حفظ",
    nameRequired: "اسم اللوحة مطلوب",
    departmentRequired: "القسم مطلوب",
    descriptionRequired: "الوصف مطلوب",
    boardCreatedSuccessfully: "تم إنشاء اللوحة بنجاح",
    nothingToShowYet: "لا يوجد شيء لعرضه حتى الآن",
  };

  static const Map<String, dynamic> EN = {
    nothingToShowYet: "Nothing to show yet",
    noData: "There is no data",
    english: "Proceed With English",
    arabic: "Proceed With Arabic",
    loadingMore: "Loading more...",
    refresh: "Retry",
    somethingWentWrong: "Something went wrong",
    pleaseTryAgain: "Please try again",
    reloadScreen: "Reload screen",
    loading: "Loading",
    pleaseWait: "Please wait",
    ok: "OK",
    skip: "Skip",
    taskManagement: "Task Management",
    all: "All",
    marketing: "Marketing",
    software: "Software",
    finance: "Finance",
    researchAndDevelopment: "Research and Development",
    search: "Search",
    filter: "Filter",
    createBoard: "Create Board",
    department: "Department: ",
    creationDate: "Creation Date: ",
    owner: "Owner",
    boardName: "Board Name",
    enterBoardName: "Enter board name",
    boardDepartment: "Board Department",
    selectDepartment: "Select Department",
    boardDescription: "Board Description",
    enterBoardDescription: "Enter board description",
    save: "Save",
    nameRequired: "Board name is required",
    departmentRequired: "Department is required",
    descriptionRequired: "Description is required",
    boardCreatedSuccessfully: "Board created successfully",
  };
}
