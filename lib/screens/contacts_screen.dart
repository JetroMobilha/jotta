import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as fc;
import 'package:permission_handler/permission_handler.dart';
import '../l10n/app_localizations.dart';
import '../models/target_contact.dart';
import '../services/storage_service.dart';
import '../services/native_cleaner_service.dart';
import '../widgets/soft_container.dart';
import '../widgets/banner_ad_widget.dart';
import '../theme/app_colors.dart';

import 'lock_screen.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> with WidgetsBindingObserver {
  final StorageService _storage = StorageService();
  List<TargetContact> _contacts = [];
  Map<String, List<TargetContact>> _groupedContacts = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadContacts();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive || state == AppLifecycleState.hidden) {
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    }
  }

  Future<void> _loadContacts() async {
    setState(() => _isLoading = true);
    final contacts = await _storage.getContacts();
    
    final Map<String, List<TargetContact>> groups = {};
    for (var c in contacts) {
      final group = c.groupName.isEmpty ? 'Geral' : c.groupName;
      if (!groups.containsKey(group)) {
        groups[group] = [];
      }
      groups[group]!.add(c);
    }

    setState(() {
      _contacts = contacts;
      _groupedContacts = groups;
      _isLoading = false;
    });
  }

  Future<void> _toggleGroupBlock(String groupName, bool blockAll) async {
    final groupContacts = _groupedContacts[groupName] ?? [];
    for (var c in groupContacts) {
      final updated = c.copyWith(blockCalls: blockAll);
      await _storage.updateContact(updated);
    }
    _loadContacts();
  }

  List<String> get _existingGroupNames {
    final groups = _groupedContacts.keys.toList();
    if (!groups.contains('Geral')) groups.insert(0, 'Geral');
    return groups;
  }

  Future<String?> _promptForGroup(BuildContext context, {String initialGroup = 'Geral'}) async {
    String selectedGroup = initialGroup;
    final TextEditingController controller = TextEditingController(text: initialGroup == 'Geral' ? '' : initialGroup);
    final existing = _existingGroupNames;

    return showDialog<String>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: AppColors.cardBackground,
            title: const Text('Selecionar ou Criar Grupo', style: TextStyle(color: AppColors.textWhite)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Grupos Existentes:', style: TextStyle(color: AppColors.textLight, fontSize: 12)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: existing.map((g) {
                      final isSelected = selectedGroup == g;
                      return ChoiceChip(
                        label: Text(g),
                        selected: isSelected,
                        selectedColor: AppColors.primaryPurple,
                        backgroundColor: AppColors.background,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textWhite,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        onSelected: (sel) {
                          if (sel) {
                            setDialogState(() {
                              selectedGroup = g;
                              controller.text = g == 'Geral' ? '' : g;
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      labelText: 'Ou crie um novo grupo',
                      hintText: 'ex: Trabalho, Família',
                      labelStyle: TextStyle(color: AppColors.textLight),
                    ),
                    style: const TextStyle(color: AppColors.textWhite),
                    onChanged: (val) {
                      setDialogState(() {
                        selectedGroup = val.trim().isEmpty ? 'Geral' : val.trim();
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, null),
                child: const Text('Cancelar', style: TextStyle(color: AppColors.textLight)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, selectedGroup.isEmpty ? 'Geral' : selectedGroup),
                child: const Text('Confirmar', style: TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _addFromPhone() async {
    final l10n = AppLocalizations.of(context)!;
    if (await Permission.contacts.request().isGranted) {
      final fc.Contact? contact = await fc.FlutterContacts.native.showPicker();
      if (contact != null && contact.phones.isNotEmpty) {
        final group = await _promptForGroup(context, initialGroup: l10n.general);
        if (group == null) return; // User cancelled

        final newContact = TargetContact(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: contact.displayName ?? l10n.unknown,
          phoneNumber: contact.phones.first.number,
          groupName: group,
        );
        await _storage.addContact(newContact);
        _loadContacts();
      }
    } else {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.contactsPermDenied)),
        );
      }
    }
  }

  Future<void> _addManual() async {
    final l10n = AppLocalizations.of(context)!;
    String name = '';
    String number = '';
    String group = l10n.general;
    final existing = _existingGroupNames;
    final groupTextController = TextEditingController(text: l10n.general);

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: AppColors.cardBackground,
            title: Text(l10n.addContactManual, style: const TextStyle(color: AppColors.textWhite)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: InputDecoration(labelText: l10n.nameOptional),
                    style: const TextStyle(color: AppColors.textWhite),
                    onChanged: (val) => name = val,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: l10n.number),
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(color: AppColors.textWhite),
                    onChanged: (val) => number = val,
                  ),
                  const SizedBox(height: 15),
                  Text(l10n.selectExistingGroup, style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: existing.map((g) {
                      final isSelected = group == g;
                      return ChoiceChip(
                        label: Text(g),
                        selected: isSelected,
                        selectedColor: AppColors.primaryPurple,
                        backgroundColor: AppColors.background,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textWhite,
                          fontSize: 12,
                        ),
                        onSelected: (sel) {
                          if (sel) {
                            setDialogState(() {
                              group = g;
                              groupTextController.text = g;
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: groupTextController,
                    decoration: InputDecoration(
                      labelText: l10n.setGroup,
                      hintText: l10n.orCreateNewGroup,
                    ),
                    style: const TextStyle(color: AppColors.textWhite),
                    onChanged: (val) {
                      setDialogState(() {
                        group = val.trim().isEmpty ? l10n.general : val.trim();
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel, style: const TextStyle(color: AppColors.textLight))),
              TextButton(
                onPressed: () async {
                  if (number.isNotEmpty) {
                    final newContact = TargetContact(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: name.isEmpty ? l10n.unknown : name,
                      phoneNumber: number,
                      groupName: group.isEmpty ? l10n.general : group,
                    );
                    await _storage.addContact(newContact);
                    Navigator.pop(ctx);
                    _loadContacts();
                  }
                },
                child: Text(l10n.save, style: const TextStyle(color: AppColors.primaryPurple, fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _addFromCallLog() async {
    final l10n = AppLocalizations.of(context)!;
    if (!await NativeCleanerService.hasCallLogPermission()) {
      await NativeCleanerService.requestCallLogPermission();
      await Future.delayed(const Duration(milliseconds: 1500));
    }

    if (!await NativeCleanerService.hasCallLogPermission()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.callLogPermDenied)),
        );
      }
      return;
    }

    final calls = await NativeCleanerService.getRecentCalls();
    
    if (!mounted) return;
    
    if (calls.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.noCallLogsFound)),
      );
      return;
    }

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Material(
          color: Colors.transparent,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(l10n.recentCalls, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: calls.length,
                  itemBuilder: (ctx, i) {
                    final call = calls[i];
                    return ListTile(
                      leading: const CircleAvatar(backgroundColor: AppColors.accentBlue, child: Icon(Icons.call, color: Colors.white)),
                      title: Text(call['name'] ?? l10n.unknown, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(call['number'] ?? ''),
                      onTap: () async {
                        final group = await _promptForGroup(context, initialGroup: l10n.general);
                        if (group == null) return;

                        final newContact = TargetContact(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          name: call['name'] ?? l10n.unknown,
                          phoneNumber: call['number'] ?? '',
                          groupName: group,
                        );
                        await _storage.addContact(newContact);
                        if (mounted) Navigator.pop(ctx);
                        _loadContacts();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddOptions() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.addContact, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textWhite)),
              const SizedBox(height: 20),
              ListTile(
                leading: const CircleAvatar(backgroundColor: AppColors.primaryPurple, child: Icon(Icons.call, color: Colors.white)),
                title: Text(l10n.fromCallLog, style: const TextStyle(color: AppColors.textWhite)),
                onTap: () {
                  Navigator.pop(ctx);
                  _addFromCallLog();
                },
              ),
              ListTile(
                leading: const CircleAvatar(backgroundColor: AppColors.primaryPurple, child: Icon(Icons.contact_phone, color: Colors.white)),
                title: Text(l10n.fromContactList, style: const TextStyle(color: AppColors.textWhite)),
                onTap: () {
                  Navigator.pop(ctx);
                  _addFromPhone();
                },
              ),
              ListTile(
                leading: const CircleAvatar(backgroundColor: AppColors.primaryPurple, child: Icon(Icons.dialpad, color: Colors.white)),
                title: Text(l10n.enterManually, style: const TextStyle(color: AppColors.textWhite)),
                onTap: () {
                  Navigator.pop(ctx);
                  _addManual();
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.contactsTitle),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _contacts.isEmpty
                    ? Center(child: Text(l10n.noRulesConfigured, style: const TextStyle(color: AppColors.textLight)))
                    : ListView.separated(
                        padding: const EdgeInsets.all(20),
                        itemCount: _groupedContacts.length,
                        separatorBuilder: (ctx, i) => const SizedBox(height: 15),
                        itemBuilder: (ctx, i) {
                          final groupName = _groupedContacts.keys.elementAt(i);
                          final contactsInGroup = _groupedContacts[groupName]!;
                          final isAllBlocked = contactsInGroup.every((c) => c.blockCalls);

                          return SoftContainer(
                            padding: EdgeInsets.zero,
                            child: Theme(
                              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                collapsedIconColor: AppColors.primaryPurple,
                                iconColor: AppColors.primaryPurple,
                                tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                leading: const CircleAvatar(
                                  backgroundColor: AppColors.primaryPurple,
                                  child: Icon(Icons.folder_shared, color: Colors.white, size: 20),
                                ),
                                title: Text(
                                  groupName,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textWhite),
                                ),
                                subtitle: Text(
                                  l10n.entitiesInGroup(contactsInGroup.length),
                                  style: const TextStyle(color: AppColors.textLight, fontSize: 12),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.block, color: isAllBlocked ? Colors.redAccent : AppColors.textLight),
                                      onPressed: () => _toggleGroupBlock(groupName, !isAllBlocked),
                                      tooltip: isAllBlocked ? l10n.unblockGroup : l10n.blockEntireGroup,
                                    ),
                                    const Icon(Icons.expand_more),
                                  ],
                                ),
                                children: contactsInGroup.map((c) {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 15, right: 15, bottom: 12),
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: AppColors.background.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        leading: const CircleAvatar(backgroundColor: AppColors.primaryPurple, radius: 18, child: Icon(Icons.person, color: Colors.white, size: 18)),
                                        title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textWhite)),
                                        subtitle: Text(c.phoneNumber, style: const TextStyle(color: AppColors.textLight)),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.block, color: c.blockCalls ? Colors.redAccent : AppColors.textLight, size: 20),
                                              onPressed: () async {
                                                final updated = c.copyWith(blockCalls: !c.blockCalls);
                                                await _storage.updateContact(updated);
                                                _loadContacts();
                                              },
                                              tooltip: c.blockCalls ? l10n.unblockCalls : l10n.rejectCallsImm,
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.phone, color: AppColors.accentGreen, size: 20),
                                              onPressed: () async {
                                                await NativeCleanerService.makeCall(c.phoneNumber);
                                              },
                                              tooltip: l10n.call,
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                                              onPressed: () async {
                                                await _storage.removeContact(c.id);
                                                _loadContacts();
                                              },
                                              tooltip: l10n.delete,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: BannerAdWidget(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryPurple,
        onPressed: _showAddOptions,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}
