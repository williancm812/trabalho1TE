import 'package:flutter/material.dart';
import 'package:my_app/helpers/contact_helper.dart';
import 'package:my_app/objects/contact.dart';
import 'package:my_app/objects/ordem_enum.dart';
import 'package:my_app/ui/contact/contact_page.dart';
import 'package:my_app/ui/home/components/contact_card.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();

  List<Contact> contacts = List();

  @override
  void initState() {
    super.initState();

    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        backgroundColor: Colors.black87,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar por Nome de A-Z"),
                value: OrderOptions.orderAsc,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar por Nome de Z-A"),
                value: OrderOptions.orderDesc,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar por Email de A-Z"),
                value: OrderOptions.orderEmailAsc,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar por Email de Z-A"),
                value: OrderOptions.orderEmailDesc,
              ),
            ],
            onSelected: orderList,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: _showContactPage,
        child: Icon(Icons.add),
        backgroundColor: Colors.black87,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: contacts.length,
        itemBuilder: (_, index) {
          return ContactCard(
            contact: contacts[index],
            onTap: () => _showOptions(context, index),
          );
        },
      ),
    );
  }

  void _getAllContacts() {
    helper.getAllContacts().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }

  void _showOptions(context, index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(

            onClosing: () {},
            builder: (context) {
              return Container(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text(
                          "Ligar",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: () {
                          launch("tel:${contacts[index].phone}");
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text(
                          "Conversar no Whatsapp",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: () {
                           launch("whatsapp://send?phone=55053${contacts[index].phone}&text=");
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text(
                          "Enviar E-mail",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: () {
                          launch("mailto:<${contacts[index].email}>");
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text(
                          "Editar",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _showContactPage(contact: contacts[index]);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text(
                          "Excluir",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Deseja excluir?"),
                                  content: Text("Os dados do Contato serão perdidos"),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("Cancelar"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    FlatButton(
                                      child: Text("Sim"),
                                      onPressed: () {
                                        helper.deleteContact(contacts[index].id);
                                        setState(() {
                                          contacts.removeAt(index);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        });
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  Future<void> _showContactPage({@required Contact contact}) async {
    final recContact = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ContactPage(
                  contact: contact,
                )));
    if (recContact != null) {
      if (contact != null)
        await helper.updateContact(recContact);
      else
        await helper.saveContact(recContact);
      _getAllContacts();
    }
  }

  void orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderAsc:
        contacts.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOptions.orderDesc:
        contacts.sort((a, b) {
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
      case OrderOptions.orderEmailAsc:
        contacts.sort((a, b) {
          return a.email.toLowerCase().compareTo(b.email.toLowerCase());
        });
        break;
      case OrderOptions.orderEmailDesc:
        contacts.sort((a, b) {
          return b.email.toLowerCase().compareTo(a.email.toLowerCase());
        });
        break;
    }
    setState(() {});
  }
}
