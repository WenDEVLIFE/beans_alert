# Beans Alert 📢

A comprehensive Flutter-based alert system designed for barangay (community) communication and emergency notifications. Send SMS and email alerts to community members with advanced scheduling, user management, and accountability features.

## 🌟 Features

### 📱 Multi-Channel Messaging
- **SMS Messaging**: Send text messages via Semaphore API
- **Email Messaging**: Send emails via Gmail SMTP
- **Dual Channel**: Send via both SMS and Email simultaneously
- **Service Selection**: Choose messaging channels per message

### ⏰ Advanced Scheduling
- **Schedule Messages**: Set future delivery times for alerts
- **Calendar View**: Visual calendar interface for scheduled messages
- **Edit Functionality**: Modify scheduled messages before sending
- **Conflict Prevention**: Warnings for scheduling conflicts
- **Automatic Delivery**: Background service sends messages at scheduled times

### 👥 User Management & Security
- **Role-Based Access**: Admin and Staff user roles
- **Admin Protection**: Admin accounts cannot be deleted
- **Accountability**: Track who scheduled each message
- **Session Management**: Secure login/logout functionality

### 📊 Contact Management
- **Organized by Purok**: Contacts grouped by community zones
- **Dual Contact Info**: Phone numbers and email addresses
- **Visual Indicators**: Icons for different contact types
- **Bulk Selection**: Select multiple recipients easily

### 📈 Message History & Analytics
- **Complete History**: Track all sent messages
- **Service Tracking**: See which channels were used (SMS/Email/Both)
- **Success/Failure Status**: Monitor delivery status
- **Search Functionality**: Find messages by content or recipient

### 🎨 Modern UI/UX
- **Dark Theme**: Professional dark interface
- **Responsive Design**: Optimized for mobile devices
- **Intuitive Navigation**: Easy-to-use sidebar navigation
- **Visual Feedback**: Clear status indicators and icons

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (^3.8.1)
- Firebase project with Authentication and Firestore enabled
- Gmail account for email functionality
- Semaphore API credentials for SMS

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd beans_alert
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Add your `google-services.json` to `android/app/`
   - Add your `GoogleService-Info.plist` to `ios/Runner/`

4. **Configure Email Service**
   - Update Gmail credentials in `lib/src/services/GmailService.dart`:
   ```dart
   static const String appEmail = 'your-email@gmail.com';
   static const String appPW = 'your-app-password';
   ```

5. **Configure SMS Service**
   - Update Semaphore API key in your environment or service configuration

6. **Run the app**
   ```bash
   flutter run
   ```

## 📱 Usage Guide

### User Roles
- **Admin**: Full access to all features including user management
- **Staff**: Can send messages and manage contacts, cannot delete admin accounts

### Sending Messages
1. Navigate to "Send Message" from the sidebar
2. Select recipients by purok (community zone)
3. Choose messaging services (SMS, Email, or Both)
4. Enter your message
5. Choose to send immediately or schedule for later

### Scheduling Messages
1. In the Send Message screen, tap "Schedule" instead of "Send Now"
2. Select date and time for delivery
3. Choose messaging services
4. Confirm scheduling

### Managing Scheduled Messages
1. Navigate to "Scheduled Messages" from the sidebar
2. View messages in calendar or list format
3. Edit unsent messages using the Edit button
4. Delete unwanted scheduled messages

### Contact Management
1. Navigate to "Contacts" from the sidebar
2. View contacts organized by purok
3. Add new contacts with phone and email
4. Edit existing contact information

### Message History
1. Navigate to "Message History" from the sidebar
2. View all sent messages with delivery status
3. Search messages by content or recipient
4. See which services were used for each message

## 🏗️ Architecture

### State Management
- **BLoC Pattern**: Business logic components for state management
- **Events & States**: Clean separation of UI and business logic

### Data Models
- `UserModel`: User authentication and role management
- `ContactModel`: Community member contact information
- `ScheduledMessage`: Future message delivery configuration
- `MessageHistory`: Record of sent messages and delivery status

### Services
- `FirebaseService`: Authentication and data persistence
- `SemaphoreService`: SMS delivery via API
- `GmailService`: Email delivery via SMTP

### Key Features Implementation

#### Scheduler Identification
```dart
// Messages show scheduler info
'From: ${message.senderName} (${message.senderRole})'
```

#### Service Selection
```dart
// Users can choose delivery methods
bool sendSMS = true;
bool sendEmail = false;
```

#### Admin Protection
```dart
// Prevent admin deletion
if (userToDelete.role.toLowerCase() == 'admin') {
  // Show error message
}
```

## 🔧 Configuration

### Firebase Setup
1. Create a Firebase project
2. Enable Authentication (Email/Password)
3. Enable Firestore Database
4. Add your app to Firebase project
5. Download and place configuration files

### Email Configuration
1. Enable 2-factor authentication on Gmail
2. Generate an App Password
3. Use App Password in `GmailService.dart`

### SMS Configuration
1. Sign up for Semaphore account
2. Get API credentials
3. Configure in your environment variables

## 📦 Dependencies

- `flutter_bloc`: State management
- `firebase_core`, `firebase_auth`, `cloud_firestore`: Backend services
- `flutter_svg`, `font_awesome_flutter`: UI components
- `mailer`: Email functionality
- `http`: API communications
- `shared_preferences`: Local storage
- `intl`: Date/time formatting

## 🐛 Troubleshooting

### Common Issues

**Email not sending:**
- Check Gmail App Password configuration
- Verify less secure app access settings

**SMS not sending:**
- Verify Semaphore API credentials
- Check account balance/credits

**Firebase connection issues:**
- Ensure `google-services.json` is properly placed
- Check Firebase project configuration

**UI Overflow:**
- Ensure device screen size compatibility
- Check for proper responsive design implementation

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📞 Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the troubleshooting section above

---

**Beans Alert** - Keeping communities connected and informed! 🌱📢
