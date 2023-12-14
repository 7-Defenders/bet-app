import 'package:app/components/events_screen/bet_preview.dart';
import 'package:app/components/other/nunito_text.dart';
import 'package:app/models/football_event.dart';
import 'package:app/models/structure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';

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

  final List<bool> _selected = [true, false];

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
        return Center(
          child: LoadingAnimationWidget.hexagonDots(color: Theme.of(context).colorScheme.primary, size: 55,),
        );
      },
    );

    final response = await http.get(Uri.parse('https://bet-app-e520a.ew.r.appspot.com/competitions/$league'));
    displayedMatches.clear();
    setState((){
      footballEventFromJson(response.body).forEach((element) =>
        displayedMatches.add(BetPreviewWidget(
          eventName: '${element.homename} - ${element.awayname}',
          eventDetails: element.date,
          bets: {
            '1':element.homeodds,
            '1X':0,
            'X': element.tieodds,
            'X2':0,
            '2':element.awayodds,
          },
          onOptionSelected: (option) {
            print(option);
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
      height: 75,
      width: double.infinity,
      child: ListView.builder(
        itemCount: items.length,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(bottom: 5),
        itemBuilder: (context, index) {
          final item = items[index];
          // every item has a name - TODO workaround linter for this, maybe cast
          final String itemName = item.name as String;
          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 5),
            child: GestureDetector(
              onTap: () {
                onTap(item);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.only(top: 5),
                  width: 115,
                  color: item == selectedItem
                      ? Theme.of(context).colorScheme.background
                      : Theme.of(context).colorScheme.error,
                  child: Column(
                    children: [
                      if (item is Country || item is League)
                        SvgPicture.asset(
                          item.svgPath as String,
                          width: (item is Country) ? 45 : 40,
                          height: (item is Country) ? 38 : 38,
                        )
                      else if (item is Sport)
                        Icon(
                          item.icon,
                          color: Theme.of(context).colorScheme.onBackground,
                          size: 35,
                        ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            child: nunitoText(
                              itemName,
                              14,
                              FontWeight.normal,
                              Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
        });
      },
    );
  }


  Widget buildLeagueListView() {
    final leagues = structure
        .firstWhere(
            (sport) => sport.name == selectedSport?.name,
        orElse: () => Sport(name: '', countries: [], icon: Icons.abc),)
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
          fetchMatchesGivenLeague(selectedLeague!.id);
        });
      },
    );
  }

  void onMakeBetPressed() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: const Center(child: Text("Hello")),
        );
      },
    );
  }

  void moveToLeagueCreator() {
    Navigator.of(context).pushNamed('/league_creator');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: 
        [
          const SizedBox(height: 40,),
            ToggleButtons(
              onPressed: (int index) {
                setState(() {
                  final int other = (index+1)%2;
                  _selected[index] = true;
                  _selected[other] = false;
                });
              },
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              selectedBorderColor: Colors.red[700],
              selectedColor: Colors.white,
              fillColor: Colors.red[200],
              color: Colors.red[400],
              constraints: const BoxConstraints(
                minHeight: 30.0,
                minWidth: 120.0,
              ),
              isSelected: _selected,
              children: const [Text('Private'), Text('Public')],
            ),

          const SizedBox(height: 40,),
          const Center(
            child: Text(
              'Sunba widget',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 120,),
          const Center(
            child: Text(
              'Herman widget',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 5, 160, 221),
            ),
            onPressed: moveToLeagueCreator,
            child: const Text(
              'Create league',
              style: TextStyle(color: Colors.white),
              ),
        ),
            const SizedBox(height: 40,),
      ],
      // child: Stack(
    //     children: [

    //       // SingleChildScrollView(
    //       //   child: Column(
    //       //     children: [
    //       //       // filters
    //       //       AnimatedContainer(
    //       //         duration: const Duration(milliseconds: 250),
    //       //         height: selectedSport == null ? 140 : selectedCountry == null ? 220 : selectedLeague == null ? 290 : 290,
    //       //         curve: Curves.easeInOut,
    //       //         child: SingleChildScrollView( // this helps avoid overflow during animation
    //       //           child: ClipRRect(
    //       //             borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
    //       //             child: Container(
    //       //               color: Theme.of(context).colorScheme.primary,
    //       //               padding: const EdgeInsets.only(left: 20, top: 55, bottom: 10),
    //       //               child: Column(
    //       //                 children: [
    //       //                   buildSportListView(),
    //       //                   if (selectedSport != null)
    //       //                     buildCountryListView().animate(
    //       //                       effects: [
    //       //                         const SlideEffect(
    //       //                           duration: Duration(milliseconds: 250),
    //       //                           begin: Offset(0, -0.5),
    //       //                           end: Offset.zero,
    //       //                         ),
    //       //                         const FadeEffect(
    //       //                           duration: Duration(milliseconds: 250),
    //       //                           begin: 0,
    //       //                           end: 1,
    //       //                         ),
    //       //                       ],
    //       //                     ),
    //       //                   if (selectedCountry != null) buildLeagueListView(),
    //       //                 ],
    //       //               ),
    //       //             ),
    //       //           ),
    //       //         ),
    //       //       ),
    //       //       // matches
    //       //       Container(
    //       //         padding: const EdgeInsets.only(top: 10),
    //       //         child: Column(
    //       //           children: [
    //       //             ...displayedMatches,
    //       //             const SizedBox(height: 100,),
    //       //           ],
    //       //         ),
    //       //       ),
    //       //     ],
    //       //   ),
    //       // ),
    //       // Positioned(
    //       //   bottom: 20,
    //       //   right: 20,
    //       //   child: SizedBox(
    //       //     width: 70,
    //       //     height: 70,
    //       //     child: FloatingActionButton(
    //       //       elevation: 10,
    //       //       onPressed: onMakeBetPressed,
    //       //       backgroundColor: Theme.of(context).colorScheme.primary,
    //       //       child: Icon(
    //       //         Icons.keyboard_arrow_up_rounded,
    //       //         size: 40,
    //       //         color: Theme.of(context).colorScheme.background,
    //       //       ),
    //       //     ),
    //       //   ),
    //       // ),
    //     ],
    // )
    )
    );
  }
}
