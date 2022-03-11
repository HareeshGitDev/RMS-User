class DateTimeService{

  static String zeroMonth(DateTime text) =>
      text.month < 10 ? '0${text.month}' : text.month.toString();

  static String zeroDay(DateTime text) =>
      text.day < 10 ? '0${text.day}' : text.day.toString();

  static String ddMMYYYYformatDate(DateTime text) =>
      '${text.year}-${zeroMonth(text)}-${zeroDay(text)}';

}