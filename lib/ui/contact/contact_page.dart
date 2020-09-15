import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/helpers/validators.dart';
import 'package:my_app/objects/contact.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({@required this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final nameFocus = FocusNode();
  bool userEdited = false;

  Contact editContact;

  @override
  void initState() {
    super.initState();
    if (widget.contact == null) {
      editContact = Contact();
    } else {
      editContact = Contact.fromMap(widget.contact.toMap());
      nameController.text = editContact.name;
      emailController.text = editContact.email;
      phoneController.text = editContact.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        requestPop();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: Text(editContact.name ?? "Novo Contato"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_formKey.currentState.validate()) {
              if (editContact.name != null)
                Navigator.pop(context, editContact);
              else {
                FocusScope.of(context).requestFocus(nameFocus);
              }
            }
          },
          backgroundColor: Colors.red,
          child: Icon(
            Icons.save,
            color: Colors.white,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    height: 200.0,
                    width: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: editContact.img != null
                        ? Image.file(
                            File(editContact.img),
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            "images/person.jpg",
                            fit: BoxFit.cover,
                          ),
                  ),
                  onTap: () {
                    ImagePicker.pickImage(source: ImageSource.camera).then((file) {
                      if (file == null) return;
                      setState(() {
                        editContact.img = file.path;
                      });
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Nome"),
                  onChanged: (text) {
                    userEdited = true;
                    setState(() {
                      editContact.name = text;
                    });
                  },
                  controller: nameController,
                  focusNode: nameFocus,
                  validator: (a) {
                    if (a.length < 3) return 'Texto muito curto';
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Email"),
                  onChanged: (text) {
                    userEdited = true;
                    editContact.email = text;
                  },
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  validator: (a) {
                    if (!validEmail(a)) return 'E-mail inválido';

                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Phone"),
                  onChanged: (text) {
                    userEdited = true;
                    editContact.phone = text;
                  },
                  keyboardType: TextInputType.phone,
                  controller: phoneController,
                  validator: (a) {
                    if (a.length < 8) return 'Telefone muito curto inválido';

                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> requestPop() async {
    if (userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar alterações?"),
              content: Text("Se sair as alterações serão perdidas"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed: () => Navigator.pop(context),
                ),
                FlatButton(
                  child: Text("Sim"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
      return false;
    } else {
      Navigator.pop(context);
      return true;
    }
  }
}
