import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:todo_list/app/core/notifier/default_listener_notifier.dart';
import 'package:todo_list/app/core/ui/messages.dart';
import 'package:todo_list/app/core/widget/todo_list_logo.dart';
import 'package:todo_list/app/core/widget/txt_form_field.dart';
import 'package:todo_list/app/modules/auth/login/login_controller.dart';
import 'package:validatorless/validatorless.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();
  final _emailFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    DefaultListenerNotifier(changeNotifier: context.read<LoginController>())
        .listener(
            context: context,
            everCallback: (notifier, listenerInstance) {
              if (notifier is LoginController) {
                if (notifier.hasInfo) {
                  Messages.of(context).showInfo(notifier.infoMessage!);
                }
              }
            },
            sucessCallback: (notifier, instance) {
              // encaminhar user para homePage
              print('----login efetuado com sucesso----');
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                  minWidth: constraints.maxWidth),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 24,
                    ),
                    const TodoListLogo(),
                    Padding(
                      padding: const EdgeInsets.all(40),
                      child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TxtFormField(
                                label: 'Email',
                                controller: _emailEC,
                                focusNode: _emailFocus,
                                validator: Validatorless.multiple([
                                  Validatorless.required('Email Obrigatório'),
                                  Validatorless.email('Email Inválido'),
                                ]),
                              ),
                              const SizedBox(height: 20),
                              TxtFormField(
                                controller: _passwordEC,
                                label: 'Senha',
                                obscureText: true,
                                validator: Validatorless.multiple([
                                  Validatorless.required('Senha Obrigatória'),
                                  Validatorless.min(
                                      6, 'A senha tem pelo menos 6 digitos'),
                                ]),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      if (_emailEC.text.isNotEmpty) {
                                        context
                                            .read<LoginController>()
                                            .forgotPassword(_emailEC.text);
                                      } else {
                                        _emailFocus.requestFocus();
                                        Messages.of(context).showError(
                                            'Digite um e-mail para recuperar a senha');
                                      }
                                    },
                                    child: const Text('Esqueceu a senha?'),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    onPressed: () {
                                      final formValid =
                                          _formKey.currentState?.validate() ??
                                              false;
                                      if (formValid) {
                                        final email = _emailEC.text;
                                        final password = _passwordEC.text;
                                        context
                                            .read<LoginController>()
                                            .login(email, password);
                                      }
                                    },
                                    child: const Text('Entrar'),
                                  ),
                                ],
                              )
                            ],
                          )),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: const Color(0xffF0F3F7),
                            border: Border(
                                top: BorderSide(
                                    color: Colors.grey.withAlpha(50),
                                    width: 1))),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            SignInButton(
                              Buttons.google,
                              onPressed: () {},
                              text: 'Entrar com Google',
                              shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Não tem uma conta?'),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed('/register');
                                  },
                                  child: const Text('Cadastre-se'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
