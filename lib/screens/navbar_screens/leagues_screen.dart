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

  List<Sport> structure = [];
  List<BetPreviewWidget> displayedMatches = [];
  Sport? selectedSport;
  Country? selectedCountry;
  League? selectedLeague;

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
    debugPrint("RESPONSE:");
    debugPrint(response.body);
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

    if (mounted){
      Navigator.of(context).pop();
    }
  }

  Widget buildListView(
      List<dynamic> items, dynamic selectedItem, void Function(dynamic) onTap, ) {
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: ListView.builder(
        itemCount: items.length,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(10),
        itemBuilder: (context, index) {
          final item = items[index];
          // every item has a name and a svgPath - TODO workaround linter for this
          final String itemName = item.name as String;
          final String itemSvgPath = item.svgPath as String;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: GestureDetector(
              onTap: () {
                onTap(item);
                debugPrint("itemName: $itemName, selectedItem: $selectedItem");
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  width: 100,
                  height: 100,
                  color: item == selectedItem
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.secondary,
                  child: Center(child: Text(itemName)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildSportListView() {
    return buildListView(
      structure.map((sport) => sport).toList(),
      selectedSport,
          (sport) {
        setState(() {
          selectedSport = sport as Sport;
          selectedCountry = null;
          selectedLeague = null;
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
      countries.map((country) => country).toList(),
      selectedCountry,
          (country) {
        setState(() {
          selectedCountry = country as Country;
          selectedLeague = null;
          displayedMatches.clear();
          debugPrint(selectedCountry?.name);
        });
      },
    );
  }


  Widget buildLeagueListView() {
    final leagues = structure
        .firstWhere(
            (sport) => sport.name == selectedSport?.name,
        orElse: () => Sport(name: '', countries: [], svgPath: ''),)
        .countries
        .firstWhere(
            (country) => country.name == selectedCountry?.name,
        orElse: () => Country(name: '', leagues: [], svgPath: ''),)
        .leagues
        .map((league) => league)
        .toList();

    return buildListView(
      leagues,
      selectedLeague,
          (league) {
        setState(() {
          selectedLeague = league as League;
          debugPrint("HERE");
          debugPrint(selectedLeague?.name);
          fetchMatchesGivenLeague(selectedLeague!.id);
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
            if (selectedSport != null) buildCountryListView(),
            if (selectedCountry != null) buildLeagueListView(),
            ...displayedMatches,
          ],
        ),
      ),
    );
  }
}
