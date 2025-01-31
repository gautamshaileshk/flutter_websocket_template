Here is the updated **README.md** with the correct command:

---

# **WebSocket Template**

A Flutter package to simplify WebSocket setup and integration in Flutter applications. This package provides a pre-configured WebSocket service, a customizable UI for connecting to WebSocket servers, and other helpful utilities.

---

## **Features**
✅ **WebSocket Service**: A ready-to-use service for connecting to WebSocket servers, handling reconnection, and sending/receiving messages.  
✅ **Socket.IO Support**: Option to use Socket.IO instead of WebSockets.  
✅ **Pre-built UI**: A user-friendly interface for entering WebSocket server details and connecting.  
✅ **Automatic Reconnection**: Keeps your WebSocket connection alive with retry logic.  
✅ **Customizable Button**: A reusable and stylish button widget for triggering actions like connecting to a server.  
✅ **Shared Preferences Support**: Saves WebSocket server details for seamless user experience.  

---

## **Getting Started**

### **Prerequisites**
- Flutter **2.5.0+**
- Dart **2.12+**
- Dependencies already included:  
  - `web_socket_channel` (for WebSockets)  
  - `socket_io_client` (for Socket.IO)  
  - `shared_preferences` (for saving WebSocket URLs)  
  - `lottie` (for animations)  

---

## **Installation**

### **1. Add this package to your project**
```bash
flutter pub add socket_config
```

### **2. Generate the configuration files**
```bash
dart run socket_config:setup_config
```
This command creates the `lib/socketconfig` directory with:
- `websocket_service.dart` – WebSocket connection service.
- `socketio_service.dart` – Alternative Socket.IO connection service.
- `urls_page.dart` – UI for entering WebSocket URLs.
- `custom_button.dart` – A customizable button widget.
- `assets/connected.json` & `assets/connecting.json` – Lottie animations for UI feedback.

---

## **Usage**

### **1. WebSocket Service**
The `WebSocketService` class manages WebSocket connections, listens to messages, and supports automatic reconnection.

#### **Example Usage**
```dart
import 'package:socket_config/socketconfig/websocket_service.dart';

void main() {
  final webSocketService = WebSocketService();

  // Connect to the WebSocket server
  webSocketService.connect();

  // Listen for incoming messages
  webSocketService.messages.listen((message) {
    print("Received: $message");
  });

  // Send a message
  webSocketService.send("Hello, WebSocket!");

  // Disconnect when done
  webSocketService.disconnect();
}
```

---

### **2. Socket.IO Service**
If you prefer **Socket.IO** instead of WebSockets, you can use `SocketIOService`.

#### **Example Usage**
```dart
import 'package:socket_config/socketconfig/socketio_service.dart';

void main() {
  final socketIOService = SocketIOService();

  // Connect to the Socket.IO server
  socketIOService.connect();

  // Listen for incoming messages
  socketIOService.messages.listen((message) {
    print("Received: $message");
  });

  // Send a message
  socketIOService.send("Hello, Socket.IO!");

  // Disconnect when done
  socketIOService.disconnect();
}
```

---

### **3. UI for WebSocket Configuration**
The package includes a **pre-built UI** for users to enter and save WebSocket URLs.  

#### **Example Usage**
```dart
import 'package:flutter/material.dart';
import 'package:socket_config/socketconfig/urls_page.dart';
import 'package:socket_config/socketconfig/websocket_service.dart';

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
✅ Users enter the **WebSocket URL** → Click **Connect** → The app connects automatically.

---

### **4. Custom Button Widget**
A **reusable and stylish button** for user actions like connecting to a server.

#### **Example Usage**
```dart
import 'package:socket_config/socketconfig/custom_button.dart';

CustomButton(
  text: "Connect",
  onPressed: () {
    print("Button clicked!");
  },
  isEnabled: true,
);
```

---

## **Example App**
A complete example is available in the `/example` folder.

---

## **FAQ**

### **1. How do I switch between WebSocket and Socket.IO?**
Run the command:
```bash
dart run socket_config:setup_config
```
You'll be prompted to select:
- `1` for **WebSocket**
- `2` for **Socket.IO**  
The corresponding configuration files will be generated.

### **2. What happens if the connection is lost?**
- The service automatically **attempts reconnection** every few seconds.
- A **manual disconnect** prevents automatic reconnection.

### **3. Can I customize the UI?**
Yes! The `urls_page.dart` file is fully editable.

---

## **Contributing**
We welcome contributions! Follow these steps:
1. Fork the repository.
2. Create a branch (`feature/your-feature`).
3. Submit a pull request.

For major changes, please open an issue first to discuss.

---

## **Support & Issues**
For bugs, feature requests, or questions, visit the [GitHub Issues](https://github.com/gautamshaileshk/flutter_websocket_template).

---

This **README** now reflects the correct command `dart run socket_config:setup_config`. 🚀