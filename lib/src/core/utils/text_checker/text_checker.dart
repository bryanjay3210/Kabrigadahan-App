String textLenghtChecker(String text, int lenght) {
  var res = "";
  if (text.length > lenght) {
    res = text.substring(0, lenght - 1) + "...";
    return res;
  } else {
    return text;
  }
}
