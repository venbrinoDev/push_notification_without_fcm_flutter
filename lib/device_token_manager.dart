import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class PushNotificationManager {
  static const _channel = EventChannel('com.example.app/device_token');

  static const _methodChannel = MethodChannel('com.example.app/notifications');

  static Stream<String> tokenStream() {
    debugPrint('Start Listening');
    return _channel.receiveBroadcastStream().map((token) => token.toString());
  }

  static Future<bool> registerForPushNotifications() async {
    try {
      final result = await _methodChannel
          .invokeMethod<bool>('registerForPushNotifications');
      return result ?? false;
    } catch (e) {
      debugPrint('Failed to register for push notifications: $e');
      return false;
    }
  }
}
