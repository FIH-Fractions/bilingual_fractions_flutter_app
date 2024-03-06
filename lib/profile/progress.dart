import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../settings/settings.dart';

class progress extends StatefulWidget {
  const progress({super.key});

  @override
  State<progress> createState() => _progressState();
}

class _progressState extends State<progress> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: IconButton(
                icon: const Icon(Icons.settings_rounded, size: 35, color: Colors.black,),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => settings()),
                  );
                },
              ),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            UserProfile(),
            const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.star_rate_rounded),
                  text: 'Streak',
                ),
                Tab(
                  icon: Icon(Icons.brightness_low_outlined),
                  text: 'Badges',
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Center(child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CalendarView(),
                        StreakStats(),
                      ],
                    ),
                  ),
                  Center(
                    child: Container(
                      height: 450, // Set the height of the grid
                      width: 450, // Set the width of the grid
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // Number of columns
                          crossAxisSpacing: 60, // Space between columns
                          mainAxisSpacing: 30, // Space between rows
                        ),
                        itemCount: 4, // Number of items in the grid (9 images)
                        itemBuilder: (context, index) {
                          // Replace 'assets/image_$index.png' with your actual asset path
                          String assetName = 'assets/badges/i_${index + 1}.jpeg'; // Assuming your images are named image_1.png, image_2.png, etc.
                          return Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(assetName),
                                fit: BoxFit.contain, // Fill the box with the image
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundColor: Color(0xfff8cc1b),
          child: Icon(Icons.person, size: 50, color: Colors.white),
        ),
        SizedBox(height: 8),
        Text(
          'User',
          style: TextStyle(fontSize: 22),
        ),
      ],
    );
  }
}

class CalendarView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50.0),
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: DateTime.now(),
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
        ),
      ),
    );
  }
}

class StreakStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        StatCard(label: 'Active Days', value: '0'),
        StatCard(label: 'Max Streak', value: '0'),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final String label;
  final String value;

  const StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}