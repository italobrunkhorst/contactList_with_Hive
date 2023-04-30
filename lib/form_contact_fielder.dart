import 'package:contact_crud_hive/model/user.dart';
import 'package:flutter/material.dart';

class FormContactFielder extends StatelessWidget {
  TextEditingController controller;
  String hintTextName;
  IconData iconData;
  TextInputType textInputType;
  

  FormContactFielder(
      {super.key,
      required this.controller,
      required this.hintTextName,
      required this.iconData,
      this.textInputType = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        icon: Icon(iconData),
        hintText: hintTextName,
        filled: true,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: textInputType,
      validator: (value) {
        if (value == null || value.isEmpty ) {
          return 'Por Favor Digite $hintTextName';
        }
        if(hintTextName == 'Nome' && !validarNome(value)){
          return 'Nome não pode conter número';
        }
        if (hintTextName == 'Email' && !validateEmail(value)) {
          return 'Digite um Email Válido';
        }
        if (hintTextName == 'Telefone' && !validarCelular(value)) {
          return 'Digite um Telefone válido';
        }
        if(hintTextName == 'Idade' && !validarCelular(value)) {
          return 'Idade deve conter só número';
        }
        if (hintTextName == 'Código' && !validarCelular(value)) {
          return 'Código deve conter só número';
        }
      },
    );
  }
}

validarNome(String nome){
  final nomeReg = RegExp(r'(^[a-zA-Z]*$)');
  return nomeReg.hasMatch(nome);
}

validarCelular(String telefone){
    final telefoneReg = RegExp(r'(^[0-9]*$)');
    return telefoneReg.hasMatch(telefone);
}

validarIdade(String idade){
  final idadeReg = RegExp(r'(^[0-9]*$)');
  return idadeReg.hasMatch(idade);
}

validateEmail(String email) {
  final emailReg = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
  return emailReg.hasMatch(email);
}
