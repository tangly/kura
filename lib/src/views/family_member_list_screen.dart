import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kura/l10n/app_localizations.dart';
import 'package:kura/src/providers.dart';
import 'package:kura/src/views/add_edit_family_member_screen.dart';

class FamilyMemberListScreen extends ConsumerWidget {
  const FamilyMemberListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final familyMembers = ref.watch(familyMembersProvider);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(l10n.familyBottomBar,
            style: theme.textTheme.titleLarge
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, size: 32, color: Colors.white),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddEditFamilyMemberScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: familyMembers.when(
        data: (members) {
          return ListView.builder(
            itemCount: members.length,
            itemBuilder: (context, index) {
              final member = members[index];
              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(member.name),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddEditFamilyMemberScreen(
                            familyMember: member),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text(l10n.couldNotLoadUsers)),
      ),
    );
  }
}
