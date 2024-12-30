<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started
This package provides WebSocket setup tools for Flutter applications.

## Installation

1. Add this package to your project:

   flutter pub add websocket_template

2. start using the package, Generate the configuration files
   
   dart run websocket_template:setup_wsconfig


## Usage
Here’s an updated and complete `README.md` file for your package, removing all `TODO` placeholders and ensuring it meets the required standards:

---

# WebSocket Template

A Flutter package to simplify WebSocket setup and integration in Flutter applications. This package provides a pre-configured WebSocket service, a customizable UI for connecting to WebSocket servers, and other helpful utilities.

---

## Features

- **WebSocket Service**: A ready-to-use service for connecting to WebSocket servers, handling reconnection, and sending/receiving messages.
- **Pre-built UI**: A page for entering WebSocket server details and connecting, designed for ease of use.
- **Customizable Button**: A reusable and stylish button widget for performing actions like connecting to a server.

---

## Getting Started

### Prerequisites
1. Ensure your project uses Flutter 2.5.0 or later.
2. Add the required dependencies for `shared_preferences`, `web_socket_channel`, and `lottie` (already included in this package).

---

## Installation

1. Add this package to your project:
   ```bash
   flutter pub add websocket_template
   ```

2. Generate the configuration files:
   ```bash
   dart run websocket_template:setup_wsconfig
   ```

   This will create the `lib/wsconfig` folder in your project with the following files:
   - `websocket_service.dart`: A pre-built service for managing WebSocket connections.
   - `urls_page.dart`: A UI for entering and saving WebSocket server details.
   - `custom_button.dart`: A customizable button widget.

---

## Usage

### WebSocket Service
The `WebSocketService` class manages WebSocket connections and allows you to send and receive messages. It also includes automatic reconnection and manual disconnection support.

```dart
import 'package:websocket_template/wsconfig/websocket_service.dart';

void main() {
  final webSocketService = WebSocketService();

  // Connect to a WebSocket server
  webSocketService.connect();


  // Listen to incoming messages
  webSocketService.messages.listen((message) {
    print("Received: $message");
  });

  // Disconnect when done
  webSocketService.disconnect();
}
```

### UI for Server Configuration
The `UrlsPage` widget provides an intuitive interface for entering and saving the WebSocket server URL. This page integrates seamlessly with the WebSocket service.

```dart
import 'package:flutter/material.dart';
import 'package:websocket_template/wsconfig/urls_page.dart';
import 'package:websocket_template/wsconfig/websocket_service.dart';

class MyApp extends StatelessWidget {
  final webSocketService = WebSocketService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UrlsPage(webSocketService: webSocketService),
    );
  }
}
```

### Custom Button
The `CustomButton` widget is a stylish button for user interactions.

```dart
import 'package:websocket_template/wsconfig/custom_button.dart';

CustomButton(
  text: "Connect",
  onPressed: () {
    print("Button clicked!");
  },
  isEnabled: true,
);
```

---

## Example

For a complete implementation, see the `/example` folder in this repository.

---

## Additional Information

### Repository and Issues
For more information, visit the [GitHub repository](https://github.com/gautamshaileshk/flutter_websocket_template). Please file any issues or feature requests there.

### Contributing
We welcome contributions! To contribute:
1. Fork the repository.
2. Create a branch for your feature or bugfix.
3. Submit a pull request with detailed explanations.

---

This README.md should now satisfy the requirements for publication. Be sure to replace placeholder links (e.g., `https://github.com/gautamshaileshk/flutter_websocket_template`) with the actual URLs for your package's repository.