import 'dart:io';

void main() {
  final directory = Directory('lib/wsconfig');

  if (!directory.existsSync()) {
    directory.createSync(recursive: true);
    print('Created wsconfig directory.');
  }

// Content for websocket_service.dart
  final websocketServiceContent = '''
   import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketService {
  WebSocketChannel? _channel;
  final StreamController<dynamic> _streamController =
      StreamController.broadcast();
  static final WebSocketService _instance = WebSocketService._internal();
  final ValueNotifier<bool> connectionStatus = ValueNotifier<bool>(false);

  factory WebSocketService() => _instance;

  Timer? _reconnectTimer;
  bool _isConnected = false;
  bool get isConnected => _isConnected;
  bool _isManuallyDisconnected = false;

  WebSocketService._internal();

  // Connect to WebSocket
  Future<void> connect() async {
    if (_isConnected) return; // Prevent duplicate connections

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? url = prefs.getString('ws');

    if (url != null && url.isNotEmpty) {
      try {
        _channel = WebSocketChannel.connect(Uri.parse('ws://url'));
        _isManuallyDisconnected = false;
        await _channel!.ready.then((_) {
          _isConnected = true;
          connectionStatus.value = true;
    
          debugPrint("WebSocket connected");
        });
        // Listen for incoming messages
        _channel!.stream.listen(
          (message) {
            _streamController.add(message);
          },
          onDone: _handleDisconnect,
          onError: (error) {
            _handleDisconnect();
            debugPrint("WebSocket error");
          },
        );
      } catch (e) {
        debugPrint("Error connecting to WebSocket:");
        _reconnectWebSocket();
      }
    } else {
      throw Exception("WebSocket URL is not set in SharedPreferences");
    }
  }

  // Handle WebSocket disconnection
  void _handleDisconnect() {
    _isConnected = false;
    connectionStatus.value = false;
    if (!_isManuallyDisconnected) {
      debugPrint("WebSocket disconnected, attempting to reconnect...");
      _reconnectWebSocket();
    }
  }

  // Reconnect WebSocket
  void _reconnectWebSocket() {
    if (_isConnected || _isManuallyDisconnected) {
      _reconnectTimer?.cancel();
      _reconnectTimer = null;
      return;
    }

    const reconnectInterval =
        Duration(seconds: 5); // Adjust reconnect interval as needed
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer.periodic(reconnectInterval, (timer) async {
      if (_isConnected) {
        timer.cancel();
        return;
      }
      debugPrint("Attempting to reconnect...");
      try {
        await connect();
      } catch (e) {
        debugPrint('Error during reconnection attempt');
      }
    });
  }

  // Send data to WebSocket
  void send(String message) {
    if (_channel != null) {
      try {
        _channel!.sink.add(message);
      } catch (e) {
        debugPrint("Error sending message");
      }
    } else {
      throw Exception("WebSocket is not connected");
    }
  }

  // Disconnect WebSocket manually
  void disconnect() {
    _isManuallyDisconnected = true;
    _isConnected = false;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _channel?.sink.close(status.normalClosure);
    _channel = null;
    debugPrint("WebSocket manually disconnected");
  }

  // Listen to WebSocket messages
  Stream<dynamic> get messages => _streamController.stream;

  // Dispose resources
  void dispose() {
    _streamController.close();
    disconnect();
  }
}

  ''';

  // Content for urls_page.dart
  final urlsPageContent = '''
 import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:websockettemplate/websocket_service.dart';
import 'custom_button.dart';

class UrlsPage extends StatefulWidget {
  final WebSocketService webSocketService;
  const UrlsPage({Key? key, required this.webSocketService}) : super(key: key);

  @override
  State<UrlsPage> createState() => _UrlsPageState();
}

class _UrlsPageState extends State<UrlsPage> with TickerProviderStateMixin {
  final TextEditingController _wsTextController = TextEditingController();
  late AnimationController _controller;
  String _ws = "";
  bool _connectionStatus = false;
  bool _inputStatus = false;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
    _loadStoredUrls();
  }

  Future<void> _loadStoredUrls() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _ws = prefs.getString('ws') ?? "";
      _wsTextController.text = _ws;
    });
    print(_wsTextController.text);
    if (_wsTextController.text.isNotEmpty) {
      setState(() {
        _inputStatus = true;
      });
    }
  }

  Future<void> _storeUrls() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ws', _ws);
  }

  Future<void> _handleSubmit() async {
    if (_ws.isNotEmpty) {
      try {
        setState(() => _connectionStatus = true);
        await _storeUrls();
        await widget.webSocketService.connect();
      } catch (e) {
        debugPrint("Error connecting to the server. Please try again.");
        _showErrorDialog("Connection Error",
            "Failed to connect to the server. Please try again.");
      }
    } else {
      _showErrorDialog("Invalid Input", "Please enter a valid WebSocket URL");
    }
  }

  void _showErrorDialog(String title, String message) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              child: const Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade50,
              Colors.blue.shade100,
              Colors.blue.shade200,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const Spacer(flex: 2),
                const Text(
                  'Welcome',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Connect to your WebSocket server',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(flex: 2),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _wsTextController,
                    textInputAction: TextInputAction.done,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _ws = value;
                        _inputStatus = value.length == 18;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "192.168.1.8:8080",
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(
                        Icons.link_rounded,
                        color: Colors.blue.shade400,
                        size: 24,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                ValueListenableBuilder<bool>(
                  valueListenable: widget.webSocketService.connectionStatus,
                  builder: (context, isConnected, _) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 160,
                      child: _connectionStatus
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset(
                                  isConnected
                                      ? 'assets/connected.json'
                                      : 'assets/connecting.json',
                                  height: 100,
                                  controller: isConnected ? _controller : null,
                                  onLoaded: isConnected
                                      ? (composition) {
                                          _controller.duration =
                                              composition.duration;
                                          _controller.forward().whenComplete(
                                              () => Navigator.pushNamed(
                                                  context, '/home'));
                                        }
                                      : null,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  isConnected
                                      ? "Connected successfully!"
                                      : "Connecting to the server...",
                                  style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )
                          : Center(
                              child: Text(
                                _inputStatus
                                    ? "IP looks good! Click connect to proceed"
                                    : "Enter the server IP address to connect",
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                    );
                  },
                ),
                const Spacer(),
                CustomButton(
                  text: "Connect",
                  onPressed: _handleSubmit,
                  isEnabled: true,
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _wsTextController.dispose();
    super.dispose();
  }
}
  ''';

  // Content for custom_button.dart
  final customButtonContent = '''
  import 'package:flutter/material.dart';
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isEnabled;
   final IconData? icon;


  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isEnabled = true,
    this.icon = Icons.arrow_forward,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onPressed : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isEnabled
                ? [Colors.blue.shade400, Colors.blue.shade700]
                : [Colors.grey.shade400, Colors.grey.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: isEnabled ? Colors.blue.shade200 : Colors.grey.shade300,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
  ''';

  // Write the files
  File('lib/wsconfig/websocket_service.dart')
      .writeAsStringSync(websocketServiceContent);
  File('lib/wsconfig/urls_page.dart').writeAsStringSync(urlsPageContent);
  File('lib/wsconfig/custom_button.dart')
      .writeAsStringSync(customButtonContent);

  print('Generated wsconfig files.');
}
