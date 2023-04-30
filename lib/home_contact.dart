import 'package:contact_crud_hive/common/box_user.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import 'contact_listview.dart';
import 'form_contact_fielder.dart';
import 'model/user.dart';

class HomeContact extends StatefulWidget {
  const HomeContact({super.key});

  @override
  State<HomeContact> createState() => _HomeContactState();
}

class _HomeContactState extends State<HomeContact> {
  final _formKey = GlobalKey<FormState>();

  final idUserControl = TextEditingController();
  final nameUserControl = TextEditingController();
  final emailUserControl = TextEditingController();
  final telefoneUserControl = TextEditingController();
  final idadeUserControl = TextEditingController();

  @override
  void dispose() {
    idUserControl.dispose();
    nameUserControl.dispose();
    emailUserControl.dispose();
    telefoneUserControl.dispose();
    idadeUserControl.dispose();
    Hive.close(); // fechar as boxes
    super.dispose();
  }

  /* tirar depois */
  List<UserModel> testeData() {
    List<UserModel> users = [];
    UserModel user = UserModel()
      ..user_id = '1'
      ..user_name = 'Joao'
      ..email = 'xx@xx.com'
      ..telefone = '(41) 98514-4318';
    users.add(user);
    users.add(user);
    users.add(user);
    users.add(user);
    users.add(user);

    return users;
  }

  Future<void> addUser(String id, String name, String email, String telefone, String idade) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final user = UserModel()
        ..user_id = id
        ..user_name = name
        ..email = email
        ..telefone = telefone
        ..idade = idade;

      // pega a caixa aberta
      final box = UserBox.getUsers();
      box.add(user).then((value) => _clearTextControllers());

      //final existContact = box.get(user);
      //var users = box.values.toList().cast<UserModel>();
      // print(users);
      // print(user.key);
      //var exist = users.where((element) => element.user_id == user.user_id);
      //print(exist.isEmpty);

      // existContact == null
      //     ? box.add(user).then((value) => _clearTextControllers())
      //     : user.save();

      //Adiciona o usuario com uma chava autoincrentável
      //box.add(user).then((value) => _clearTextControllers());
    }
  }

  Future<void> editUser(UserModel user) async {
    idUserControl.text = user.user_id;
    nameUserControl.text = user.user_name;
    emailUserControl.text = user.email;
    telefoneUserControl.text = user.telefone;
    idadeUserControl.text = user.idade;
  }

  void _clearTextControllers() {
    idUserControl.clear();
    nameUserControl.clear();
    emailUserControl.clear();
    telefoneUserControl.clear();
    idadeUserControl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final users = testeData();

    return Scaffold(
      key: _formKey,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const Text("Lista de Contatos",
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(onPressed: (){}, icon: Icon(Icons.search))
              ],
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              FormContactFielder(
                controller: idUserControl,
                iconData: Icons.person,
                hintTextName: 'Código',
                textInputType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              FormContactFielder(
                controller: nameUserControl,
                iconData: Icons.person_outline,
                hintTextName: 'Nome',
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 10),
              FormContactFielder(
                controller: emailUserControl,
                iconData: Icons.email_outlined,
                textInputType: TextInputType.emailAddress,
                hintTextName: 'Email',
              ),
              const SizedBox(height: 10),
              FormContactFielder(
                controller: telefoneUserControl, 
                hintTextName: 'Telefone', 
                iconData: Icons.call_outlined,
                textInputType: TextInputType.phone,
              ),
              const SizedBox(height: 10),
              FormContactFielder(
                controller: idadeUserControl, 
                hintTextName: 'Idade', 
                iconData: Icons.question_mark_rounded,
                textInputType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.only(left: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => addUser(
                          idUserControl.text,
                          nameUserControl.text,
                          emailUserControl.text,
                          telefoneUserControl.text,
                          idadeUserControl.text,
                        ),
                        child: const Text('Adicionar'),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _clearTextControllers,
                        child: const Text('Limpar Campos'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ValueListenableBuilder(
                valueListenable: UserBox.getUsers().listenable(),
                builder: (BuildContext context, Box userBox, Widget? child) {
                  final users = userBox.values.toList().cast<UserModel>();
                  if (users.isEmpty) {
                    return Center(
                      child: const Text(
                        'No Users Found',
                        style: const TextStyle(fontSize: 20),
                      ),
                    );
                  } else {
                    return ContactListView(
                      users: users,
                      onEditContact: editUser,
                    );
                  }
                },
              ),
              //ContactListView(users: users)
            ],
          ),
        ),
      );
  }
}
