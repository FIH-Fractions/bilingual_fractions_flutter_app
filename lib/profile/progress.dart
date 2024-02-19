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
                  Center(child: Text('Badges')),
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