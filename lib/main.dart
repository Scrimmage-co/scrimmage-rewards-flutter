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
  // TODO Remove counter
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  // const token = await fetch('/api/token').then(res => res.text());
  // const iframe = document.getElementById('scrimmage-iframe');
  // var token = '';
  // var webViewUrl = 'https://partnerid.apps.scrimmage.co.co/?token=${token}';

  final webViewController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted);
    // ..loadRequest(Uri.parse('https://deadsimplechat.com/IyL5YkDM3'));
    // ..loadRequest(Uri.parse('https://github.com/AndroidSDKSources/android-sdk-sources-list'));

  // WebViewController controller = WebViewController()
  //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
  //   ..setBackgroundColor(const Color(0x00000000))
  //   ..setNavigationDelegate(
  //     NavigationDelegate(
  //       onProgress: (int progress) {
  //         // Update loading bar.
  //       },
  //       onPageStarted: (String url) {},
  //       onPageFinished: (String url) {},
  //       onWebResourceError: (WebResourceError error) {},
  //       onNavigationRequest: (NavigationRequest request) {
  //         if (request.url.startsWith('https://www.youtube.com/')) {
  //           return NavigationDecision.prevent;
  //         }
  //         return NavigationDecision.navigate;
  //       },
  //     ),
  //   )
  //   ..loadRequest(Uri.parse('https://flutter.dev'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body:

      Center(
        child: FutureBuilder<String>(
          future: fetchToken(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              // return Text('Token: ${snapshot.data}');
              webViewController.loadRequest(Uri.parse(snapshot.data!));
              return WebViewWidget(controller: webViewController);
            }
          },
        ),
      ),

      // WebViewWidget(controller: webViewController),

      // Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       const Text(
      //         'You have pushed the button this many times:',
      //       ),
      //       Text(
      //         '$_counter',
      //         style: Theme.of(context).textTheme.headlineMedium,
      //       ),
      //       WebViewWidget(controller: webViewController)
      //     ],
      //   ),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

Future<String> fetchToken() async {
  const tokenBackendUrl =
      'https://us-central1-bright-practice-331514.cloudfunctions.net/requestGenerateAuthInfo';
  const scrimmageRewardsUrl = 'https://coinflip.apps.scrimmage.co/?token=';

  try {
    final response = await http.get(Uri.parse(tokenBackendUrl));
    if (response.statusCode == 200) {
      final json = response.body;
      final token = jsonDecode(json)['token'];
      // final scrimmageRewardsUrl = 'https://coinflip.apps.scrimmage.co/?token=${token}';
      final webViewUrl = scrimmageRewardsUrl + token;
      return webViewUrl;
    } else {
      throw Exception('Failed to fetch token');
    }
  } catch (e) {
    throw Exception('Failed to fetch token: $e');
  }
}
