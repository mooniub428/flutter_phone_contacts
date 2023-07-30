import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart' as contactsService;
import 'package:flutter_contacts/flutter_contacts.dart' as flutterContacts;
class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<contactsService.Contact>? _contacts;

  @override
  void initState() {
    super.initState();
    fetchContacts();
  }

  void fetchContacts() async {
    // Request contact permission
    await flutterContacts.FlutterContacts.requestPermission();

    // Get all contacts (fully fetched)
    List<contactsService.Contact> contacts =
    (await contactsService.ContactsService.getContacts()).toList();

    setState(() {
      _contacts = contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContactList(),
    );
  }

  Widget _buildContactList() {
    if (_contacts == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_contacts!.isEmpty) {
      return Center(
        child: Text('No contacts available.'),
      );
    }

    // Create a list to hold contact data for all contacts
    List<Map<String, dynamic>> allContactsData = [];

    for (contactsService.Contact contact in _contacts!) {
      String firstName = contact.givenName ?? '';
      String lastName = contact.familyName ?? '';
      List<contactsService.Item>? phoneNumbers = contact.phones?.toList();
      List<contactsService.Item>? emails = contact.emails?.toList();

      // Get contact avatar as base64 encoded string
      Uint8List? avatarBytes = contact.avatar;
      String? avatarBase64;
      if (avatarBytes != null && avatarBytes.isNotEmpty) {
        avatarBase64 = base64Encode(avatarBytes);
      }

      // Create a map to represent the contact data
      Map<String, dynamic> contactData = {
        'first_name': firstName,
        'last_name': lastName,
        'phone_numbers': phoneNumbers != null && phoneNumbers.isNotEmpty
            ? phoneNumbers.map((phone) => phone.value).toList()
            : [],
        'emails': emails != null && emails.isNotEmpty
            ? emails.map((email) => email.value).toList()
            : [],
        'avatar': avatarBase64,
      };

      // Add the contact data to the list
      allContactsData.add(contactData);
    }

    // Convert the list to JSON
    String allContactsJson = jsonEncode(allContactsData);

    // Print the JSON representation of all contacts
    print(allContactsJson);

    return ListView.builder(
      itemCount: _contacts!.length,
      itemBuilder: (context, index) {
        contactsService.Contact contact = _contacts![index];
        String firstName = contact.givenName ?? '';
        String lastName = contact.familyName ?? '';
        List<contactsService.Item>? phoneNumbers = contact.phones?.toList();
        List<contactsService.Item>? emails = contact.emails?.toList();

        return ListTile(
          leading: CircleAvatar(
            backgroundImage: MemoryImage(contact.avatar ?? Uint8List(0)),
          ),
          title: Text('$firstName $lastName'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (phoneNumbers != null && phoneNumbers.isNotEmpty)
                Text('Phone: ${phoneNumbers[0].value}'),
              if (emails != null && emails.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: emails.map((email) => Text('Email: ${email.value}')).toList(),
                ),
            ],
          ),
        );
      },
    );
  }
}
