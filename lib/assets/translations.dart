Map<String, Map<String, String>> translations = {
  'Polish': {
    'Language': 'Język',
    'Select language:': 'Wybierz język:',
    'Dark Mode': 'Tryb ciemny',
    'Dark mode:': 'Tryb ciemny:',
    'Betting Odds Format': 'Format kursów zakładów',
    'Select odds format:': 'Wybierz format kursów:',
    'Notifications': 'Powiadomienia',
    'Select notification option:': 'Wybierz opcję powiadomień:',
    'EndOfEveryMatch': 'Na koniec każdego meczu',
    'Never': 'Nigdy',
    'Decimal': 'Dziesiętny',
    'Fractional': 'Ułamkowy',
    'American': 'Amerykański',
    'on': 'włączony',
    'off': 'wyłączony',
    'English': 'Angielski',
    'Polish': 'Polski',
    'German': 'Niemiecki',
    'Russian': 'Rosyjski',
    'Log Out': 'Wyloguj się',
    'Settings': 'Ustawienia',
  },
  'German': {
    'Language': 'Sprache',
    'Select language:': 'Sprache auswählen:',
    'Dark Mode': 'Dunkelmodus',
    'Dark mode:': 'Dunkelmodus:',
    'Betting Odds Format': 'Wettquotenformat',
    'Select odds format:': 'Wählen Sie das Wettquotenformat:',
    'Notifications': 'Benachrichtigungen',
    'Select notification option:': 'Benachrichtigungsoption auswählen:',
    'EndOfEveryMatch': 'Ende jedes Spiels',
    'Never': 'Nie',
    'Decimal': 'Dezimal',
    'Fractional': 'Bruch',
    'American': 'Amerikanisch',
    'on': 'ein',
    'off': 'aus',
    'English': 'Englisch',
    'Polish': 'Polnisch',
    'German': 'Deutsch',
    'Russian': 'Russisch',
    'Log Out': 'Ausloggen',
    'Settings': 'Einstellungen',
  },
  'Russian': {
    'Language': 'Язык',
    'Select language:': 'Выбрать язык:',
    'Dark Mode': 'Тёмный режим',
    'Dark mode:': 'Тёмный режим:',
    'Betting Odds Format': 'Формат коэффициентов',
    'Select odds format:': 'Выбрать формат коэффициентов:',
    'Notifications': 'Уведомления',
    'Select notification option:': 'Выбрать вариант уведомлений:',
    'EndOfEveryMatch': 'В конце каждого матча',
    'Never': 'Никогда',
    'Decimal': 'Десятичный',
    'Fractional': 'Дробный',
    'American': 'Американский',
    'on': 'включено',
    'off': 'выключено',
    'English': 'Английский',
    'Polish': 'Польский',
    'German': 'Немецкий',
    'Russian': 'Русский',
    'Log Out': 'Выйти',
    'Settings': 'Настройки',
  },
};

String translate(String phrase, String language) {
  final Map<String, String>? languageTranslations = translations[language];
  if (languageTranslations != null) {
    final translatedPhrase = languageTranslations[phrase];
    if (translatedPhrase != null) {
      return translatedPhrase;
    }
  }
  return phrase;
}
