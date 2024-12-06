import 'package:flutter/material.dart';
import 'package:push_notification_without_fcm/device_token_manager.dart';

void main() => runApp(const PushNotificationWithoutFcm());

class PushNotificationWithoutFcm extends StatefulWidget {
  const PushNotificationWithoutFcm({super.key});

  @override
  State<PushNotificationWithoutFcm> createState() =>
      _PushNotificationWithoutFcmState();
}

class _PushNotificationWithoutFcmState
    extends State<PushNotificationWithoutFcm> {
  @override
  void initState() {
    _startListeningForTokens();
    _registerDeviceForPushNotification();
    super.initState();
  }

  void _registerDeviceForPushNotification() {
    PushNotificationManager.registerForPushNotifications();
  }

  void _startListeningForTokens() {
    PushNotificationManager.tokenStream().listen(
      (token) {
        debugPrint('Received token: $token');
      },
      onError: (error) {
        debugPrint('Error receiving token: $error');
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Push Notification WITHOUT FCM',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Push Notification WITHOUT FCM'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() => _counter++);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
