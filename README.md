📱 Taskat – Flutter Todo App

A clean and scalable Todo List mobile application built with Flutter and Firebase, following modern app architecture and state management best practices.

🚀 Features

✅ User Authentication (Login & Register)

📝 Add, Edit, Delete Tasks

✔ Mark tasks as Completed

🔄 Real-time sync with Firebase Firestore

👤 User Profile (Name & Email)

🌍 Localization ready

🧠 State Management using Provider

☁ Cloud-based data storage

🏗 Architecture

The project follows a clean, maintainable structure:

lib/
├── main.dart
├── core/
│   ├── theme/
│   │   ├── app_theme.dart
│   ├── localization/
│   │   ├── app_localizations.dart
│   │   └── locale_provider.dart
│   └── constants/
│       ├── app_constants.dart
|       └── theme_provider.dart
├── data/
│   ├── models/
│   │   ├── todo_model.dart
│   │   ├── user_model.dart
│   │   └── post_model.dart
│   ├── services/
│   │   ├── firebase_auth_service.dart
│   │   ├── firebase_firestore_service.dart
│   │   └── api_service.dart
│   └── repositories/
│       ├── auth_repository.dart
│       ├── todo_repository.dart
│       └── api_repository.dart
├── providers/
│   ├── auth_provider.dart
│   ├── todo_provider.dart
│   └── api_provider.dart
└── presentation/
    ├── screens/
    │   ├── auth/
    │   │   ├── login_screen.dart
    │   │   └── register_screen.dart
    │   ├── main_screen.dart
    │   ├── todo/
    │   │   └── todo_list_screen.dart
    │   ├── profile/
    │   │   └── profile_screen.dart
    │   ├── settings/
    │   │   └── settings_screen.dart
    │   └── api_demo/
    │       └── api_demo_screen.dart
    └── widgets/
        ├── todo_item_widget.dart
        └── custom_text_field.dart

🛠 Tech Stack
Technology	Usage
Flutter	UI Development
Provider	State Management
Firebase Auth	Authentication
Cloud Firestore	Database
Dart	Programming Language

⚙️ Getting Started
1️⃣ Clone the repository
git clone https://github.com/your-username/taskat.git
cd taskat

2️⃣ Install dependencies
flutter pub get

3️⃣ Setup Firebase

Create a Firebase project

Add Android & iOS apps

Download:

google-services.json → android/app

GoogleService-Info.plist → ios/Runner

Enable:

Authentication (Email/Password)

Firestore Database

4️⃣ Run the app
flutter run

🔒 Security Notes

Sensitive files are excluded using .gitignore:

google-services.json

build/

.dart_tool/

📌 Future Improvements

📅 Task deadlines & reminders

📊 Task statistics

🌙 Dark mode

👨‍💻 Author

Your Name
mohammed saeed

⭐ Support

If you like this project, give it a ⭐ on GitHub!
