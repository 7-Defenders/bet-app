import 'package:flutter/material.dart';

class Sport {
  String name;
  IconData icon;
  List<Country> countries;

  Sport({required this.name, required this.countries, required this.icon});
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
  League(name: 'Friendlies', svgPath: 'lib/assets/images/league_logos/Friendlies.svg', id: 'football_10'),
];

//countries
List<Country> footballCountries = [
  Country(name: 'International', svgPath: 'lib/assets/images/country_flags/Globe.svg', leagues: internationalLeagues),
  Country(name: 'England', svgPath: 'lib/assets/images/country_flags/England.svg', leagues: englishLeagues),
];

//sports
List<Sport> sportsObject = [
  Sport(name: 'Football', icon: Icons.sports_soccer_rounded, countries: footballCountries),
];
