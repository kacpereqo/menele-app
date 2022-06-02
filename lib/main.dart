import 'package:flutter/material.dart';
import 'contact.dart';
import 'home.dart';
import 'login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      initialRoute: '/home',
      routes: {
        '/contact': (context) => ContactPage(),
        '/home': (context) => HomePage(),
        '/login': (context) => LoginPage(),
      },
    );
  }
}

class Template extends StatelessWidget {
  final Widget body;
  final BuildContext context;
  const Template({required this.body, required this.context});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.account_circle,
                          size: 64.0,
                        ),
                        SizedBox(
                          width: 16.0,
                        ),
                        Text(
                          "Gość",
                          style: TextStyle(fontSize: 28.0),
                        ),
                      ],
                    ),
                    Spacer(),
                    Divider(
                      height: 1,
                      indent: 10,
                      endIndent: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                "Zaloguj się",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                "Zarejestruj się",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              ListTile(
                title: Text("Strona główna"),
                onTap: () {
                  Navigator.popUntil(
                      context, ModalRoute.withName(Navigator.defaultRouteName));
                },
              ),
              ListTile(
                title: Text("Kontakt"),
                onTap: () {
                  Navigator.pushNamed(context, '/contact');
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text("Menele"),
        ),
        body: body);
  }
}

// CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             title: Text('Menele'),
//             floating: true,
//           ),
//           SliverToBoxAdapter(
//             child: body,
//           ),
//         ],
//       ),
