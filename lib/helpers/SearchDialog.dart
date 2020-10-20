import 'package:flutter/material.dart';

class SearchDialog extends StatelessWidget {
  final String initialtext;

  const SearchDialog({this.initialtext});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 2,
          left: 4,
          right: 4,
          child: Card(
            child: TextFormField(
              initialValue: initialtext,
              autofocus: true,
              textInputAction: TextInputAction.search,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  prefixIcon: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.grey[700],
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )),
              onFieldSubmitted: (text) {
                Navigator.pop(context, text);
              },
            ),
          ),
        )
      ],
    );
  }
}