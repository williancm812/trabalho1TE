bool validNumber(String num) {
  try {
    double.parse(num);
    return true;
  } catch (e) {
    return false;
  }
}

String validDate(String input) {
  if(input == "") return "Data não informada";
  List<String> number = input.split("/");
  int day = int.parse(number[0]);
  int month = int.parse(number[1]);
  int year = int.parse(number[2]);
  DateTime now = DateTime.now();

  print(input);

  if (day < 32 && day > 0 && month > 0 && month < 13 && year > 1800) {
    if (day == 31 && (month == 4 || month == 6 || month == 9 || month == 11)) {
      return 'Mes $month não suporta 31 dias';
    } else if (day >= 30 && month == 2) {
      return 'Fevereiro só aceita até 29 dias';
    } else if (month == 2 &&
        day == 29 &&
        !(year % 4 == 0 && (year % 100 != 0 || year % 400 == 0))) {
      return 'Dia 29 de fevereiro só aceito em ano bissexto';
    } else {
      return null;
    }
  }

  return 'Data inválida';
}
