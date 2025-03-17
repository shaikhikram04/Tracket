class AppFormatter {
  static String formatBowlerSubTitle(String longCricketRole) {
    int index = longCricketRole.indexOf('|');

    if (index == -1) {
      return longCricketRole;
    } else {
      return longCricketRole.substring(index + 2);
    }
  }
}
