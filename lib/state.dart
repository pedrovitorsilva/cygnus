// ignore_for_file: unnecessary_getters_setters

import 'package:flutter/material.dart';
// My packages
import 'package:cygnus/autenticator.dart';

enum Situation { showingMainFeed, showingProduct }

class StateApp extends ChangeNotifier {
  Situation _situation = Situation.showingMainFeed;
  Situation get situation => _situation;

  late int _idProduct;
  int get idProduct => _idProduct;

  User? _user;
  User? get user => _user;
  set user(User? user) {
    _user = user;
  }

  void showMain() {
    _situation = Situation.showingMainFeed;

    notifyListeners();
  }

  void showProduct(int idProduct) {
    _situation = Situation.showingProduct;
    _idProduct = idProduct;

    notifyListeners();
  }

  void onLogin(User? user) {
    _user = user;

    notifyListeners();
  }

  void onLogout() {
    _user = null;

    notifyListeners();
  }
}

late StateApp stateApp;
