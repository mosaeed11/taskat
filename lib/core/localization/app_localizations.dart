import 'package:flutter/material.dart';

class AppLocalizations {
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'login': 'Login',
      'register': 'Register',
      'email': 'Email',
      'password': 'Password',
      'firstName': 'First Name',
      'lastName': 'Last Name',
      'phone': 'Phone',
      'welcome': 'Welcome',
      'logout': 'Logout',
      'settings': 'Settings',
      'profile': 'Profile',
      'todos': 'Todos',
      'addTodo': 'Add Todo',
      'apiDemo': 'API Demo',
    },
    'ar': {
      'login': 'تسجيل الدخول',
      'register': 'التسجيل',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'firstName': 'الاسم الأول',
      'lastName': 'الاسم الأخير',
      'phone': 'الهاتف',
      'welcome': 'مرحبا',
      'logout': 'تسجيل الخروج',
      'settings': 'الإعدادات',
      'profile': 'الملف الشخصي',
      'todos': 'المهام',
      'addTodo': 'إضافة مهمة',
      'apiDemo': 'عرض API',
    },
  };

  final Locale locale;

  AppLocalizations(this.locale);

  String get login => _localizedValues[locale.languageCode]!['login']!;
  String get register => _localizedValues[locale.languageCode]!['register']!;
  String get email => _localizedValues[locale.languageCode]!['email']!;
  String get password => _localizedValues[locale.languageCode]!['password']!;
  String get firstName => _localizedValues[locale.languageCode]!['firstName']!;
  String get lastName => _localizedValues[locale.languageCode]!['lastName']!;
  String get phone => _localizedValues[locale.languageCode]!['phone']!;
  String get welcome => _localizedValues[locale.languageCode]!['welcome']!;
  String get logout => _localizedValues[locale.languageCode]!['logout']!;
  String get settings => _localizedValues[locale.languageCode]!['settings']!;
  String get profile => _localizedValues[locale.languageCode]!['profile']!;
  String get todos => _localizedValues[locale.languageCode]!['todos']!;
  String get addTodo => _localizedValues[locale.languageCode]!['addTodo']!;
  String get apiDemo => _localizedValues[locale.languageCode]!['apiDemo']!;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
