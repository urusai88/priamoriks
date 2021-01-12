import 'package:face/import.dart';
import 'package:face/main.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  UserEntity user;
  MainScreenModel model;

  @override
  void initState() {
    super.initState();

    user = Provider.of<UserManager>(context, listen: false).userEntity;
    model = MainScreenModel(
      contactsService: Provider.of<ContactsService>(context, listen: false),
    );

    Future(model.loadContacts);
  }

  Future<void> onExitTap() async {
    final exit = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Выйти?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Нет'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Да'),
            ),
          ],
        );
      },
    );

    if (exit) {
      Hive.box('box').delete('api_token');

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoadingScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget body = ValueListenableBuilder<List<ContactsListItem>>(
      valueListenable: model.items,
      builder: (context, items, child) {
        if (model.count.value == null) {
          return Center(child: CircularProgressIndicator());
        }

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 500),
            child: ListView.separated(
              itemCount: model.count.value,
              separatorBuilder: (_, __) => Divider(),
              itemBuilder: (_, index) {
                if (index == items.length) {
                  model.loadNextContacts();

                  return Center(child: CircularProgressIndicator());
                }

                if (index > items.length) {
                  return null;
                }

                final item = items[index];

                return ListTile(
                  title: Text(item.user.name),
                  trailing: IconButton(
                    onPressed: () => model.toggleFavorite(item.user.id),
                    icon: Icon(
                      item.contact == null
                          ? Icons.favorite_border
                          : Icons.favorite,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(user.name),
        actions: [
          IconButton(
            onPressed: onExitTap,
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: body,
      persistentFooterButtons: [
        ValueListenableBuilder<int>(
          valueListenable: model.mode,
          builder: (_, mode, __) {
            final iconData = mode == 1 ? Icons.favorite_border : Icons.favorite;
            final text = mode == 1 ? 'Все' : 'Только избранные';

            return TextButton.icon(
              style: ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () => model.toggleMode(),
              icon: Icon(iconData),
              label: Text(text),
            );
          },
        )
      ],
    );
  }
}
