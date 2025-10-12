import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kura/l10n/app_localizations.dart';
import 'package:kura/src/views/family_member_list_screen.dart';
import 'package:kura/src/views/medication_list_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const _HomeView(),
    const MedicationListScreen(),
    const FamilyMemberListScreen(),
    const Scaffold(body: Center(child: Text('Reminders'))),
    const Scaffold(body: Center(child: Text('Settings'))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: l10n.homeBottomBar,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.medication),
            label: l10n.medicationsBottomBar,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.group),
            label: l10n.familyBottomBar,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.notifications),
            label: l10n.remindersBottomBar,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: l10n.settingsBottomBar,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Kura', style: theme.textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            height: 500,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('design/header.png'),
                fit: BoxFit.cover,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            foregroundDecoration: BoxDecoration(
              
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 500),

                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text('2', style: theme.textTheme.headlineMedium),
                                const SizedBox(height: 8),
                                const Text('Medications Due'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text('8:00 AM', style: theme.textTheme.headlineMedium),
                                const SizedBox(height: 8),
                                const Text('Next Dose'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('Upcoming Doses', style: theme.textTheme.titleLarge),
                  const SizedBox(height: 16),
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.medication),
                          title: const Text('Aspirin'),
                          subtitle: const Text('1 pill'),
                          trailing: const Text('8:00 AM'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.medication),
                          title: const Text('Ibuprofen'),
                          subtitle: const Text('2 pills'),
                          trailing: const Text('12:00 PM'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
