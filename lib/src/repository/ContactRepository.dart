import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/ContactModel.dart';

class ContactRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection references
  CollectionReference get _puroks => _firestore.collection('puroks');
  CollectionReference _contacts(String purokId) =>
      _puroks.doc(purokId).collection('contacts');

  // Get all puroks
  Stream<Map<String, List<ContactModel>>> getPurokContacts() {
    return _puroks.snapshots().asyncMap((purokSnapshot) async {
      Map<String, List<ContactModel>> purokContacts = {};

      for (var purokDoc in purokSnapshot.docs) {
        String purokId = purokDoc.id;
        QuerySnapshot contactsSnapshot = await _contacts(purokId).get();

        List<ContactModel> contacts = contactsSnapshot.docs.map((doc) {
          return ContactModel.fromMap(
            doc.data() as Map<String, dynamic>,
            doc.id,
          );
        }).toList();

        purokContacts[purokId] = contacts;
      }

      return purokContacts;
    });
  }

  // Add a new purok
  Future<void> addPurok(String purokId) async {
    await _puroks.doc(purokId).set({'createdAt': FieldValue.serverTimestamp()});
  }

  // Add a contact to a purok
  Future<void> addContact(String purokId, ContactModel contact) async {
    await _contacts(purokId).doc(contact.id).set(contact.toMap());
  }

  // Update a contact
  Future<void> updateContact(String purokId, ContactModel contact) async {
    await _contacts(purokId).doc(contact.id).update(contact.toMap());
  }

  // Remove a contact from a purok (delete)
  Future<void> deleteContact(String purokId, String contactId) async {
    await _contacts(purokId).doc(contactId).delete();
  }

  // Delete a purok and all its contacts
  Future<void> deletePurok(String purokId) async {
    // Delete all contacts first
    QuerySnapshot contactsSnapshot = await _contacts(purokId).get();
    for (var doc in contactsSnapshot.docs) {
      await doc.reference.delete();
    }
    // Then delete the purok
    await _puroks.doc(purokId).delete();
  }

  // Check if contact with same name and phone exists
  Future<bool> checkDuplicateContact(String name, String phoneNumber) async {
    // Check across all puroks
    final purokSnapshot = await _puroks.get();
    for (var purokDoc in purokSnapshot.docs) {
      final contactsSnapshot = await _contacts(purokDoc.id).get();
      for (var contactDoc in contactsSnapshot.docs) {
        final contact = ContactModel.fromMap(
          contactDoc.data() as Map<String, dynamic>,
          contactDoc.id,
        );
        if (contact.name.toLowerCase() == name.toLowerCase() &&
            contact.phoneNumber == phoneNumber) {
          return true;
        }
      }
    }
    return false;
  }
}
