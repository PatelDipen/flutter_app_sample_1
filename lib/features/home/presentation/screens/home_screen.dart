import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../people/presentation/screens/people_list_screen.dart';
import '../../../planets/presentation/screens/planets_list_screen.dart';
import '../../../starships/presentation/screens/starships_list_screen.dart';

final navigationIndexProvider = StateProvider<int>((ref) => 0);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);
    final currentUser = ref.watch(currentUserProvider);

    final screens = [
      const PeopleListScreen(),
      const StarshipsListScreen(),
      const PlanetsListScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          ref.read(navigationIndexProvider.notifier).state = index;
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'People',
          ),
          NavigationDestination(
            icon: Icon(Icons.rocket_launch_outlined),
            selectedIcon: Icon(Icons.rocket_launch),
            label: 'Starships',
          ),
          NavigationDestination(
            icon: Icon(Icons.public_outlined),
            selectedIcon: Icon(Icons.public),
            label: 'Planets',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              accountName: Text(currentUser?.fullName ?? 'User'),
              accountEmail: Text(currentUser?.email ?? ''),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: currentUser?.image != null
                    ? ClipOval(
                        child: Image.network(
                          currentUser!.image!,
                          fit: BoxFit.cover,
                          width: 90,
                          height: 90,
                          errorBuilder: (context, error, stackTrace) {
                            return Text(
                              currentUser.firstName
                                  .substring(0, 1)
                                  .toUpperCase(),
                              style: TextStyle(
                                fontSize: 40,
                                color: Theme.of(context).primaryColor,
                              ),
                            );
                          },
                        ),
                      )
                    : Text(
                        currentUser?.firstName.substring(0, 1).toUpperCase() ??
                            'U',
                        style: TextStyle(
                          fontSize: 40,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('People'),
              selected: currentIndex == 0,
              onTap: () {
                ref.read(navigationIndexProvider.notifier).state = 0;
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.rocket_launch),
              title: const Text('Starships'),
              selected: currentIndex == 1,
              onTap: () {
                ref.read(navigationIndexProvider.notifier).state = 1;
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.public),
              title: const Text('Planets'),
              selected: currentIndex == 2,
              onTap: () {
                ref.read(navigationIndexProvider.notifier).state = 2;
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () async {
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) {
                  Navigator.of(context).pushReplacementNamed('/login');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
