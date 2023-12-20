import 'package:flutter/material.dart';
import 'package:app/models/structure.dart';

class LeagueCreator extends StatefulWidget {
  const LeagueCreator({Key? key});

  @override
  State<LeagueCreator> createState() => _LeagueCreatorState();
}

class _LeagueCreatorState extends State<LeagueCreator> {

  Set<String> selectedLeagues = {};

  Widget setupAlertDialoadContainer() {
  return Container(
    height: 300.0, // Change as per your requirement
    width: 300.0, // Change as per your requirement
    child: ListView.builder(
      shrinkWrap: true,
      itemCount: sportsObject.length,
      itemBuilder: (BuildContext context, int index) {
      return ExpansionTile(
        title: Text(sportsObject[index].name),
        children: sportsObject[index].countries.map((country) {
          return ExpansionTile(
            title: Text(country.name),
            children: country.leagues.map((league) {
              final path = '${sportsObject[index].name}/${country.name}/${league.name}';

              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return CheckboxListTile(
                    title: Text(league.name),
                    value: selectedLeagues.contains(path),
                    onChanged: (val) {
                      setState(() {
                        if (selectedLeagues.contains(path)) {
                          selectedLeagues.remove(path);
                        } else {
                          selectedLeagues.add(path);
                        }
                      });
                    },
                    selected: selectedLeagues.contains(path),
                  );
                },
              );
            }).toList(),
          );
        }).toList(),
      );
      },
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('League Creator'),
      ),
      body: ColoredBox(
        color: Colors.white,
        child: Column(
          children: [
            const Center(child: Text('League name')),
            const Center(child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'League name',
                ),
              ),
            ),
            const Center(child: Text('Entry fee')),
            const Center(child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'League name',
                ),
              ),
            ),
            const Center(child: Text('Competitions included')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 5, 160, 221),
              ),
              onPressed: () async {
                  await showDialog<void>(
                  context: context,
                  builder: (context) => AlertDialog(
                      content: setupAlertDialoadContainer(),
                    ),
                  );
              },
              child: const Text(
                'Pick competitions',
                style: TextStyle(color: Colors.white),
                ),
             ),
            const Center(child: Text('Player cap')),
            const Center(child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Max players',
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 5, 160, 221),
              ),
              onPressed: () {},
              child: const Text(
                'Create league',
                style: TextStyle(color: Colors.white),
                ),
             ),
             const SizedBox(height: 40)
          ],
        ),
      ),
    );
  }
}