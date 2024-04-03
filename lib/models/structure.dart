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

List<League> frenchLeagues = [
  League(name: 'Ligue 1', svgPath: 'lib/assets/images/league_logos/premier_league.svg', id: 'football_61'),
];

List<League> italianLeagues = [
  League(name: 'Serie A', svgPath: 'lib/assets/images/league_logos/premier_league.svg', id: 'football_135'),
];

List<League> germanLeagues = [
  League(name: 'Bundesliga', svgPath: 'lib/assets/images/league_logos/premier_league.svg', id: 'football_78'),
];

List<League> spanishLeagues = [
  League(name: 'La Liga', svgPath: 'lib/assets/images/league_logos/premier_league.svg', id: 'football_140'),
];

List<League> polishLeagues = [
  League(name: 'Ekstraklasa', svgPath: 'lib/assets/images/league_logos/premier_league.svg', id: 'football_106'),
];

List<League> clubInternational = [
  League(name: 'Champions League', svgPath: 'lib/assets/images/league_logos/premier_league.svg', id: 'football_2'),
];

List<League> internationalLeagues = [
  League(name: 'Friendlies', svgPath: 'lib/assets/images/league_logos/Friendlies.svg', id: 'football_10'),
];

//countries
List<Country> footballCountries = [
  Country(name: 'International', svgPath: 'lib/assets/images/country_flags/tz.svg', leagues: internationalLeagues),
  Country(name: 'Club International', svgPath: 'lib/assets/images/country_flags/ug.svg', leagues: clubInternational),
  Country(name: 'England', svgPath: 'lib/assets/images/country_flags/England.svg', leagues: englishLeagues),
  Country(name: 'Italy', svgPath: 'lib/assets/images/country_flags/it.svg', leagues: italianLeagues),
  Country(name: 'France', svgPath: 'lib/assets/images/country_flags/fr.svg', leagues: frenchLeagues),
  Country(name: 'Germany', svgPath: 'lib/assets/images/country_flags/de.svg', leagues: germanLeagues),
  Country(name: 'Spain', svgPath: 'lib/assets/images/country_flags/es.svg', leagues: spanishLeagues),
  Country(name: 'Poland', svgPath: 'lib/assets/images/country_flags/pl.svg', leagues: polishLeagues),
];

//sports
List<Sport> sportsObject = [
  Sport(name: 'Football', icon: Icons.sports_soccer_rounded, countries: footballCountries),
];
