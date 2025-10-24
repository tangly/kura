import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kura/l10n/app_localizations.dart';
import 'package:kura/src/providers.dart';
import 'package:kura/src/theme.dart';
import 'package:kura/src/views/family_member_list_screen.dart';
import 'package:kura/src/views/medication_list_screen.dart';
import 'package:kura/src/views/pending_notifications_screen.dart';
import 'package:kura/src/views/prescription_list_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;
  String _backgroundImage = 'design/header.png';

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      _HomeView(onNavigate: _onItemTapped),
      const MedicationListScreen(),
      const FamilyMemberListScreen(),
      const PrescriptionListScreen(),
      //const Scaffold(body: Center(child: Text('Settings'))),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (_selectedIndex) {
        case 0:
          _backgroundImage = 'design/header.png';
          break;
        case 2:
          _backgroundImage = 'design/family-background.png';
          break;
        default:
          _backgroundImage = 'design/header.png';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(_backgroundImage, fit: BoxFit.cover),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            //title: const Text('Kura'),
          ),
          drawer: Drawer(
            child: Consumer(
              builder: (context, ref, child) {
                return ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                      ),
                      child: const Text(
                        'Menu',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.notifications),
                      title: const Text('Pending Notifications'),
                      onTap: () {
                        Navigator.pop(context); // Close the drawer
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const PendingNotificationsScreen(),
                          ),
                        );
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Logoff'),
                      onTap: () {
                        ref.read(authServiceProvider).signOut();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              },
            ),
          ),
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
              const BottomNavigationBarItem(
                icon: Icon(Icons.description),
                label: 'Prescriptions',
              ),
              /*BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: l10n.settingsBottomBar,
          ),*/
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: theme.colorScheme.primary,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            onTap: _onItemTapped,
          ),
        ),
      ],
    );
  }
}

class _HomeView extends ConsumerWidget {
  final void Function(int) onNavigate;
  const _HomeView({required this.onNavigate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final medicationList = ref.watch(medicationListProvider);
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child:
              //padding: const EdgeInsets.only(bottom: 50),
              Text(
                'Kura',
                style: theme.textTheme.displayLarge?.copyWith(
                  color: const Color.fromARGB(255, 202, 133, 114),
                  fontWeight: FontWeight.bold,
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
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => onNavigate(1),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: medicationList.when(
                              loading: () => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              error: (err, stack) =>
                                  const Center(child: Text('Error')),
                              data: (medications) {
                                final expiredCount = medications
                                    .where(
                                      (m) =>
                                          m.expirationDate.isBefore(
                                            DateTime.now(),
                                          ),
                                    )
                                    .length;
                                final expiringSoonCount = medications
                                    .where(
                                      (m) =>
                                          (m.expirationDate.isAfter(
                                                DateTime.now(),
                                              )) &&
                                          (m.expirationDate.isBefore(
                                                DateTime.now().add(
                                                  const Duration(days: 30),
                                                ),
                                              )),
                                    )
                                    .length;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Text(
                                        'Medications',
                                        style: theme.textTheme.titleMedium!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                    //const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Text(
                                          expiredCount.toString(),
                                          style: theme.textTheme.headlineSmall
                                              ?.copyWith(
                                                color: theme.colorScheme.error,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Text('Expired'),
                                      ],
                                    ),
                                    //const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Text(
                                          expiringSoonCount.toString(),
                                          style: theme.textTheme.headlineSmall
                                              ?.copyWith(
                                                color: kWarningColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Text('Expiring Soon'),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InkWell(
                        onTap: () => context.push('/prescriptions'),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  'Prescriptions',
                                  style: theme.textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text('View and manage prescriptions'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text('Upcoming Doses', style: theme.textTheme.titleLarge!),
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
    );
  }
}
