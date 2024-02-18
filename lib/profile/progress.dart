import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';


class progress extends StatefulWidget {
  const progress({super.key});

  @override
  State<progress> createState() => _progressState();
}

class _progressState extends State<progress> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: IconButton(
                icon: const Icon(Icons.settings_rounded, size: 35, color: Colors.black,),
                onPressed: () {},
              ),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Adjusted to start to accommodate TabBarView below UserProfile
          children: [
            UserProfile(), // Your UserProfile widget
            TabBar(  // This is your TabBar
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
              // Use Expanded for TabBarView to take the remaining space
              child: TabBarView(
                children: [
                  // Replace these with your actual widgets for each tab's content
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
    return Column(
      children: [
        CircleAvatar(
          radius: 35,
          backgroundColor: const Color(0xfff8cc1b),

          child: const Icon(Icons.person, size: 50, color: Colors.white),
        ),
        const SizedBox(height: 8),
        const Text(
          'Neha',
          style: TextStyle(fontSize: 22),
        ),
      ],
    );
  }
}

class CalendarView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: DateTime.now(),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
      ),
    );
  }
}

class StreakStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        StatCard(label: 'Active Days', value: '20 days'),
        StatCard(label: 'Max Streak', value: '0 days'),
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}