import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/core/auth/auth_provider.dart';
import 'package:todo_list/app/core/ui/messages.dart';
import 'package:todo_list/app/services/user/user_service.dart';

class HomeDrawer extends StatelessWidget {
  final nameVN = ValueNotifier<String>('');

  HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.white.withAlpha(70)),
            child: Row(
              children: [
                Selector<MyAuthProvider, String>(
                    selector: (context, authProvider) {
                  return authProvider.user?.photoURL ??
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTHwgDKk0us5SDUhCcc2WZVhawxftjZOVqVhw&s';
                }, builder: (_, value, __) {
                  return CircleAvatar(
                    backgroundImage: NetworkImage(value),
                    radius: 30,
                  );
                }),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Selector<MyAuthProvider, String>(
                        selector: (context, authProvider) {
                      return authProvider.user?.displayName ?? 'Não informado';
                    }, builder: (_, value, __) {
                      return Text(value);
                    }),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: const Text('Alterar Nome'),
                      content: TextField(
                        onChanged: (value) {
                          nameVN.value = value;
                        },
                      ),
                      actions: [
                        TextButton(
                            onPressed: Navigator.of(context).pop,
                            child: const Text(
                              'Cancelar',
                              style: TextStyle(color: Colors.red),
                            )),
                        TextButton(
                            onPressed: () async {
                              final nameValue = nameVN.value;
                              if (nameValue.isEmpty) {
                                Messages.of(context)
                                    .showError('Nome obrigatório');
                              } else {
                                await context
                                    .read<UserService>()
                                    .updateDisplayName(nameValue);
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                              }
                            },
                            child: const Text('Alterar'))
                      ],
                    );
                  });
            },
            title: const Text('Alterar Nome'),
          ),
          ListTile(
            onTap: () => context.read<MyAuthProvider>().logout(),
            title: const Text(
              'Sair',
            ),
          )
        ],
      ),
    );
  }
}
