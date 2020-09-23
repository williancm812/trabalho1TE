import 'package:flutter/material.dart';
import 'package:my_app/user_model.dart';
import 'package:provider/provider.dart';

import 'ui/home/home_page.dart';

void main() => runApp(
  ChangeNotifierProvider(
        create: (_) => UserModel(),
        lazy: true,
        builder: (context, child) {
          return MaterialApp(
            home: HomePage(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
