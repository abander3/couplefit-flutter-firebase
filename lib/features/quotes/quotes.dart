class QuoteRepository {
  static final List<String> dailyQuotes = [
    'Small wins still count. Keep going.',
    'Drink your water, nerd.',
    'Consistency beats motivation.',
    'Future you is watching. Make them proud.',
    'One good day at a time.',
    'Creatine is not going to take itself.',
  ];

  static String getTodayQuote() {
    final index = DateTime.now().day % dailyQuotes.length;
    return dailyQuotes[index];
  }
}
