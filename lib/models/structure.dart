class Sport {
  String name;
  String svgPath;
  List<Country> countries;

  Sport({required this.name, required this.countries, required this.svgPath});
}

class Country {
  String name;
  String svgPath;
  List<League> leagues;

  Country({required this.name, required this.leagues, required this.svgPath});
}

class League {
  String id;
  String name;
  String svgPath;
  League({required this.name, required this.svgPath, required this.id});
}

//leagues
List<League> englishLeagues = [
  League(name: 'Premier League', svgPath: 'lib/assets/images/league_logos/premier_league.svg', id: 'football_39'),
];
List<League> internationalLeagues = [
  League(name: 'Friendlies', svgPath: 'lib/assets/images/league_logos/friendlies.svg', id: 'football_10'),
];

//countries
List<Country> footballCountries = [
  Country(name: 'International', svgPath: 'lib/assets/images/country_logos/international.svg', leagues: internationalLeagues),
  Country(name: 'England', svgPath: 'lib/assets/images/country_logos/england.svg', leagues: englishLeagues),
];

//sports
List<Sport> sportsObject = [
  Sport(name: 'Football', svgPath: 'lib/assets/images/sport_logos/football.svg', countries: footballCountries),
];
