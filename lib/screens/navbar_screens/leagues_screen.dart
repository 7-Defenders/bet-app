import 'package:app/components/leagues_screen/bet_preview.dart';
import 'package:app/models/football_event.dart';
import 'package:app/models/structure.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LeaguesScreen extends StatefulWidget {
  const LeaguesScreen({super.key});

  @override
  State<LeaguesScreen> createState() => _LeaguesScreenState();
}

class _LeaguesScreenState extends State<LeaguesScreen> {

  // structure goes here
  List<Sport> structure = [];
  List<BetPreviewWidget> displayedMatches = [];
  String selectedSport = '';
  String selectedCountry = '';
  String selectedLeague = '';

  @override
  void initState() {
    super.initState();
    loadStructure();
  }

  Future<void> loadStructure() async {
    setState(() {
      structure = sportsObject;
    });
  }

  Future<void> fetchMatchesGivenLeague(String league) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    final response = await http.get(Uri.parse('https://bet-app-e520a.ew.r.appspot.com/competitions/$league'));
    print("RESPONSE:");
    print(response.body);
    displayedMatches.clear();
    setState((){
      footballEventFromJson(response.body).forEach((element) =>
        displayedMatches.add(BetPreviewWidget(
          eventName: '${element.homename} - ${element.awayname}',
          eventDetails: element.date,
          bets: {
            '1':element.homeodds,
            '1X':element.homeodds + element.tieodds,
            'X': element.tieodds,
            'X2':element.awayodds + element.tieodds,
            '2':element.awayodds,
          },
        ),),
      );
    });
    print("DISPLAYED MATCHES: ");
    print(displayedMatches);

    if (mounted){
      Navigator.of(context).pop();
    }
  }

  Widget buildListView(
      List<String> items, String selectedItem, void Function(String) onTap,) {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: ListView.builder(
        itemCount: items.length,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(10),
        itemBuilder: (context, index) {
          final String item = items[index];
          return GestureDetector(
            onTap: () {
              onTap(item);
            },
            child: Container(
              width: 100,
              height: 100,
              color: item == selectedItem
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondary,
              child: Center(child: Text(item)),
            ),
          );
        },
      ),
    );
  }

  Widget buildSportListView() {
    return buildListView(
      structure.map((sport) => sport.name).toList(),
      selectedSport,
          (sport) {
        setState(() {
          selectedSport = sport;
          selectedCountry = '';
          selectedLeague = '';
          displayedMatches.clear();
        });
      },
    );
  }

  Widget buildCountryListView() {
    final List<Country> countries = [];

    for (final Sport sport in structure) {
      countries.addAll(sport.countries);
    }

    return buildListView(
      countries.map((country) => country.name).toList(),
      selectedCountry,
          (country) {
        setState(() {
          selectedCountry = country;
          selectedLeague = '';
          displayedMatches.clear();
        });
      },
    );
  }


  Widget buildLeagueListView() {
    final leagues = structure
        .firstWhere(
            (sport) => sport.name == selectedSport,
        orElse: () => Sport(name: '', countries: [], svgPath: ''),)
        .countries
        .firstWhere(
            (country) => country.name == selectedCountry,
        orElse: () => Country(name: '', leagues: [], svgPath: ''),)
        .leagues
        .map((league) => league.id)
        .toList();

    return buildListView(
      leagues,
      selectedLeague,
          (league) {
        setState(() {
          selectedLeague = league;
          print(selectedLeague);
          fetchMatchesGivenLeague(selectedLeague);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildSportListView(),
            if (selectedSport.isNotEmpty) buildCountryListView(),
            if (selectedCountry.isNotEmpty) buildLeagueListView(),
            ...displayedMatches,
          ],
        ),
      ),
    );
  }
}
