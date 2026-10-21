import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../models/vault_item.dart';
import '../services/storage_service.dart';
import '../services/native_cleaner_service.dart';
import '../widgets/soft_container.dart';
import '../widgets/banner_ad_widget.dart';
import '../theme/app_colors.dart';

import 'lock_screen.dart';

class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key});

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> with WidgetsBindingObserver {
  final StorageService _storage = StorageService();
  Map<String, List<VaultItem>> _groupedItems = {};
  int _totalItems = 0;
  bool _isLoading = true;
  bool _needsAuthOnResume = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadVault();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive || state == AppLifecycleState.hidden) {
      // Destruir a interface sensível instantaneamente ao sair ou minimizar
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    }
  }

  Future<void> _loadVault() async {
    setState(() => _isLoading = true);
    final items = await _storage.getVaultItems();
    
    // Grouping by phone number
    final Map<String, List<VaultItem>> groups = {};
    for (var item in items) {
      if (!groups.containsKey(item.phoneNumber)) {
        groups[item.phoneNumber] = [];
      }
      groups[item.phoneNumber]!.add(item);
    }
    
    setState(() {
      _groupedItems = groups;
      _totalItems = items.length;
      _isLoading = false;
    });
  }

  Future<void> _clearVault() async {
    final l10n = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text(l10n.clearVaultTitle, style: const TextStyle(color: AppColors.textWhite)),
        content: Text(l10n.clearVaultDesc, style: const TextStyle(color: AppColors.textLight)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel, style: const TextStyle(color: AppColors.textLight))),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.deleteAll, style: const TextStyle(color: Colors.redAccent))),
        ],
      ),
    );

    if (confirm == true) {
      await _storage.clearVault();
      _loadVault();
    }
  }

  Future<void> _deleteByPhone(String phoneNumber, String contactName) async {
    final l10n = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text(l10n.deleteGroupTitle, style: const TextStyle(color: AppColors.textWhite)),
        content: Text(l10n.deleteGroupDesc(contactName, phoneNumber), style: const TextStyle(color: AppColors.textLight)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel, style: const TextStyle(color: AppColors.textLight))),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.delete, style: const TextStyle(color: Colors.redAccent))),
        ],
      ),
    );

    if (confirm == true) {
      await _storage.deleteVaultItemsByPhone(phoneNumber);
      _loadVault();
    }
  }

  Future<void> _deleteItem(String id) async {
    await _storage.deleteVaultItemById(id);
    _loadVault();
  }

  Future<void> _makeCall(String phoneNumber) async {
    await NativeCleanerService.makeCall(phoneNumber);
  }

  IconData _getIconForType(String type) {
    if (type == 'call_blocked') return Icons.block;
    if (type.contains('sms')) return Icons.message;
    if (type == 'call_missed') return Icons.call_missed;
    if (type == 'call_out') return Icons.call_made;
    return Icons.call_received;
  }

  Color _getColorForType(String type) {
    if (type == 'call_blocked') return Colors.redAccent;
    if (type.contains('sms')) return AppColors.primaryPurple;
    if (type == 'call_missed') return Colors.redAccent;
    return AppColors.primaryPurple;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.vaultTitle),
        actions: [
          if (_totalItems > 0)
            IconButton(
              icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
              onPressed: _clearVault,
              tooltip: l10n.deleteAll,
            )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _groupedItems.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.inventory_2_outlined, size: 80, color: AppColors.textLight),
                              const SizedBox(height: 20),
                              Text(
                                l10n.logIsClean,
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textWhite),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                l10n.logIsCleanDesc,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: AppColors.textLight, height: 1.5),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(20),
                        itemCount: _groupedItems.length,
                        separatorBuilder: (ctx, i) => const SizedBox(height: 15),
                        itemBuilder: (ctx, i) {
                          final phoneNumber = _groupedItems.keys.elementAt(i);
                          final items = _groupedItems[phoneNumber]!;
                          final recentItem = items.first; 
                          final contactName = recentItem.contactName;

                          return SoftContainer(
                            padding: const EdgeInsets.all(0),
                            child: Theme(
                              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                collapsedIconColor: AppColors.primaryPurple,
                                iconColor: AppColors.primaryPurple,
                                tilePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                leading: CircleAvatar(
                                  backgroundColor: _getColorForType(recentItem.type),
                                  child: Icon(_getIconForType(recentItem.type), color: Colors.white, size: 20),
                                ),
                                title: Text(
                                  contactName != 'Desconhecido' ? contactName : (contactName == 'Desconhecido' && phoneNumber.isEmpty ? l10n.unknown : phoneNumber),
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textWhite),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  l10n.retainedLogs(items.length),
                                  style: const TextStyle(color: AppColors.textLight, fontSize: 12),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.phone, color: AppColors.accentGreen, size: 22),
                                      onPressed: () => _makeCall(phoneNumber),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                    const SizedBox(width: 15),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 22),
                                      onPressed: () => _deleteByPhone(phoneNumber, contactName),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                    ),
                                    const SizedBox(width: 5),
                                  ],
                                ),
                                children: items.map((item) {
                                  final isCall = item.type.contains('call');
                                  String itemTitle = l10n.textPacket;
                                  if (item.type == 'call_blocked') {
                                    itemTitle = l10n.callBlockedSource;
                                  } else if (isCall) {
                                    itemTitle = l10n.callLog;
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
                                    child: Container(
                                      padding: const EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        color: AppColors.background.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: _getColorForType(item.type),
                                            radius: 14,
                                            child: Icon(_getIconForType(item.type), color: Colors.white, size: 14),
                                          ),
                                          const SizedBox(width: 15),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        itemTitle,
                                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textWhite),
                                                      ),
                                                    ),
                                                    Text(
                                                      DateFormat('dd/MM HH:mm').format(item.timestamp),
                                                      style: const TextStyle(fontSize: 12, color: AppColors.textLight),
                                                    ),
                                                  ],
                                                ),
                                                if (item.content.isNotEmpty) ...[
                                                  const SizedBox(height: 5),
                                                  Text(
                                                    item.content,
                                                    style: const TextStyle(color: AppColors.textWhite, height: 1.3),
                                                  ),
                                                ]
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete, color: AppColors.textLight, size: 20),
                                            onPressed: () => _deleteItem(item.id),
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                          ),
                                        ],
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
    );
  }
}
