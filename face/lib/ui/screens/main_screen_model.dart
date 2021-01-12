import 'package:face/import.dart';
import 'package:flutter/foundation.dart';

class MainScreenModel {
  final ContactsService contactsService;

  final count = ValueNotifier<int>(null);
  final items = ValueNotifier<List<ContactsListItem>>([]);
  final mode = ValueNotifier<int>(1);

  var loading = false;

  MainScreenModel({@required this.contactsService});

  Future<void> loadContacts() async {
    if (loading) return;

    loading = true;

    try {
      final resp = await contactsService.list(onlyFavorite: mode.value == 2);

      count.value = resp.count;
      items.value = resp.items;
    } catch (e) {
      print(e);
    } finally {
      loading = false;
    }
  }

  Future<void> loadNextContacts() async {
    if (loading) return;

    loading = true;

    try {
      final resp = await contactsService.list(
        offset: items.value.length,
        onlyFavorite: mode.value == 2,
      );

      count.value = resp.count;
      items.value = List.of(items.value)..addAll(resp.items);
    } catch (e) {} finally {
      loading = false;
    }
  }

  Future<void> toggleMode() async {
    if (loading) return;

    mode.value = mode.value == 1 ? 2 : 1;
    count.value = null;
    items.value = [];

    await loadContacts();
  }

  Future<void> toggleFavorite(int userId) async {
    try {
      final i = items.value.indexWhere((e) => e.user.id == userId);
      final item = items.value[i];

      ContactEntity contact;

      if (item.contact == null) {
        contact = await contactsService.make(userId: userId);
      } else {
        await contactsService.remove(userId: userId);
      }

      items.value = List.of(items.value)..[i] = item.withContact(contact);
    } catch (e) {
      print(e);
    }
  }
}
