import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Scrimmage integration example'),
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
  final webViewController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted);

  @override
  void initState() {
    super.initState();
    // Add JavaScriptChannel to handle messages from WebView
    webViewController.addJavaScriptChannel(
      'ScrimmageChannel',
      onMessageReceived: (JavaScriptMessage message) {
        // Handle the message received from the WebView
        showMessage(message.message);
      },
    );
  }

  void showMessage(String message) {
    // Display the message at the top of the screen as text
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<String>(
          future: fetchToken(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              webViewController.loadRequest(Uri.parse(snapshot.data!));
              return Column(
                children: [
                  const Text(
                    'Page content above the Scrimmage Reward',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: WebViewWidget(controller: webViewController),
                    ),
                  ),
                  const Text(
                    'Page content below the Scrimmage Reward',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

Future<String> fetchToken() async {
  const tokenBackendUrl =
      'https://us-central1-bright-practice-331514.cloudfunctions.net/requestGenerateAuthInfo';
  const scrimmageRewardsUrl = 'https://1fa7-91-244-31-199.ngrok-free.app/?token=';

  try {
    final response = await http.get(Uri.parse(tokenBackendUrl));
    if (response.statusCode == 200) {
      final json = response.body;
      final token = jsonDecode(json)['token'];
      final webViewUrl = scrimmageRewardsUrl + token;
      return webViewUrl;
    } else {
      throw Exception('Failed to fetch token');
    }
  } catch (e) {
    throw Exception('Failed to fetch token: $e');
  }
}
