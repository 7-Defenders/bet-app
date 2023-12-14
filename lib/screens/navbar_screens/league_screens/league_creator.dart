import 'package:flutter/material.dart';

class LeagueCreator extends StatefulWidget {
  const LeagueCreator({Key? key});

  @override
  State<LeagueCreator> createState() => _LeagueCreatorState();
}

class _LeagueCreatorState extends State<LeagueCreator> {

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
              onPressed: () {},
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