import 'package:flutter/material.dart';
import 'package:flutter_oauth2/services/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

import '../helpers/sliderightroute.dart';
import 'login.dart';

class HomeScreen extends StatelessWidget {
  static const String _title = 'Home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: StatefulHomeWidget(),
    );
  }
}

class StatefulHomeWidget extends StatefulWidget {
  const StatefulHomeWidget({super.key});

  @override
  // ignore: no_logic_in_create_state
  State<StatefulHomeWidget> createState() => _StatefulHomeWidget();
}

class _StatefulHomeWidget extends State<StatefulHomeWidget> {
  late final String errMsg = "";
  late String secureMsg = "Not secured";
  final storage = const FlutterSecureStorage();
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();

    if (errMsg.isNotEmpty) {
      Future.delayed(Duration.zero, () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errMsg),
        ));
      });
    }
  }

  Future getSecureData() async {
    Response resp = await apiService.getSecretArea();
    secureMsg = resp.body.toString();
    return resp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 142, 54),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 26, 255, 1)),
        title: const Text(
          'Flutter OAuth2',
          style: TextStyle(
            height: 1.171875,
            fontSize: 18.0,
            fontFamily: 'Roboto Condensed',
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(255, 26, 255, 1),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: () async {
              await storage.deleteAll();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.push(context,
                    SlideRightRoute(
                        page: const LoginScreen(errMsg: 'User logged out',)));
              });
            },
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder(
          future: getSecureData(),
          builder: (context, snapshot) {
            return Text(
              secureMsg,
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
              style: const TextStyle(
                height: 1.171875,
                fontSize: 18.0,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            );
          },
        )
      ),
    );
  }
}
