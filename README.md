# Scrimmage Rewards

This README provides step-by-step instructions on how to integrate
the Scrimmage Rewards program into your Flutter application.

## Prerequisites

Before integrating the Scrimmage Rewards program into your Flutter application,
ensure that you have the following prerequisites in place:

- Android Studio (or any other compatible development environment) installed on your machine.
- Access to the Scrimmage Rewards program and an active account.
- A backend server that can return a valid token for the Scrimmage Rewards program.
- Android minSdkVersion 19+
- iOS 11.0+
- More requirements you can find here https://pub.dev/packages/webview_flutter

## Integration Steps

Follow the steps below to integrate the Scrimmage Rewards program into your Flutter application:

Check [main.dart](./lib/main.dart) for example code.

1. **Install the WebView Support Library**

   To enable the Scrimmage Rewards program to display its content within a WebView,
   you need to install the WebView support library. This library allows you to embed
   web content within your Flutter application.

```bash
$ flutter pub add webview_flutter
```

2. **Import the WebView Support Library**

   Once you have installed the WebView support library, you can import it into your
   Flutter application. You can import the WebView support library using the following
   code:

```dart
import 'package:webview_flutter/webview_flutter.dart';
```

3. **Create a WebViewController to use a WebViewWidget**

It is important to set JavaScript mode as `unrestricted`. `JavaScriptMode.unrestricted`

```dart
final webViewController = WebViewController()
   ..setJavaScriptMode(JavaScriptMode.unrestricted);
``` 

4. **Add token retrieval logic for user authentication**

   The Scrimmage Rewards program requires a valid token to authenticate
   the user and display the program's content. To retrieve a valid token,
   you must implement the logic to retrieve the token from your backend server.
   Once you have retrieved the token, you can pass it to the Scrimmage Rewards
   program to authenticate the user and display the program's content.

```bash
$ flutter pub add http
```

```dart
import 'package:http/http.dart' as http;
```

5. **Ensure WebView Is Not Displayed Until Token Is Available**

   It is essential to ensure that the WebView displaying the Scrimmage Rewards
   program's content is not visible until a valid token is available. Probably you will need to use `FutureBuilder` to
   get token from your backend server and install http lib.
