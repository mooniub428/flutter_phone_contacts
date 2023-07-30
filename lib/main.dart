import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:untitled2/ContactsPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Phone Contacts'),
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

  Future<void> _incrementCounter() async {
    setState(() {
      _counter++;
    });


    // Request contact permission
    if (await FlutterContacts.requestPermission()) {
    // Get all contacts (lightly fetched)
    List<Contact> contacts = await FlutterContacts.getContacts();

    // Get all contacts (fully fetched)
    contacts = await FlutterContacts.getContacts(
    withProperties: true, withPhoto: true);

    // Get contact with specific ID (fully fetched)
    Contact? contact = await FlutterContacts.getContact(contacts.first.id);
    String myphone = contacts.toString();
    print("contacts of phone book $myphone");
    }





  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(

        child: ContactsPage(),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
