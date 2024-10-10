// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/widgets.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:todo_list/app/core/notifier/default_change_notifier.dart';
import 'package:todo_list/app/core/ui/messages.dart';

class DefaultListenerNotifier {
  final DefaultChangeNotifier changeNotifier;

  DefaultListenerNotifier({
    required this.changeNotifier,
  });

  void listener(
      {required BuildContext context,
      required SucessVoidCallback sucessCallback,
      EverVoidCallback? everCallback,
      ErrorVoidCallback? errorCallback}) {
    changeNotifier.addListener(
      () {
        if (everCallback != null) {
          everCallback(changeNotifier, this);
        }

        if (changeNotifier.loading) {
          Loader.show(context);
        } else {
          Loader.hide();
        }

        if (changeNotifier.hasError) {
          if (errorCallback != null) {
            errorCallback(changeNotifier, this);
          }
          Messages.of(context)
              .showError(changeNotifier.error ?? 'Erro interno');
        } else if (changeNotifier.isSucess) {
          sucessCallback(changeNotifier, this);
        }
      },
    );
  }

  void dispose() {
    changeNotifier.removeListener(() {});
  }
}

typedef SucessVoidCallback = void Function(
    DefaultChangeNotifier notifier, DefaultListenerNotifier listenerInstance);

typedef ErrorVoidCallback = void Function(
    DefaultChangeNotifier notifier, DefaultListenerNotifier listenerInstance);

typedef EverVoidCallback = void Function(
    DefaultChangeNotifier notifier, DefaultListenerNotifier listenerInstance);
