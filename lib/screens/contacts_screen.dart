import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as fc;
import 'package:permission_handler/permission_handler.dart';
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
  bool _isLoading = true;
  bool _needsAuthOnResume = false;

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
      // Destruir a interface sensível instantaneamente ao sair ou minimizar
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    }
  }

  Future<void> _loadContacts() async {
    setState(() => _isLoading = true);
    final contacts = await _storage.getContacts();
    setState(() {
      _contacts = contacts;
      _isLoading = false;
    });
  }

  Future<void> _addFromPhone() async {
    if (await Permission.contacts.request().isGranted) {
      final fc.Contact? contact = await fc.FlutterContacts.native.showPicker();
      if (contact != null && contact.phones.isNotEmpty) {
        final newContact = TargetContact(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: contact.displayName ?? 'Desconhecido',
          phoneNumber: contact.phones.first.number,
        );
        await _storage.addContact(newContact);
        _loadContacts();
      }
    } else {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permissão de contactos negada.')),
        );
      }
    }
  }

  Future<void> _addManual() async {
    String name = '';
    String number = '';

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Adicionar Contacto Manual'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Nome (Opcional)'),
              onChanged: (val) => name = val,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Número'),
              keyboardType: TextInputType.phone,
              onChanged: (val) => number = val,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              if (number.isNotEmpty) {
                final newContact = TargetContact(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: name.isEmpty ? 'Desconhecido' : name,
                  phoneNumber: number,
                );
                await _storage.addContact(newContact);
                Navigator.pop(ctx);
                _loadContacts();
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Future<void> _addFromCallLog() async {
    if (!await NativeCleanerService.hasCallLogPermission()) {
      await NativeCleanerService.requestCallLogPermission();
      await Future.delayed(const Duration(milliseconds: 1500));
    }

    if (!await NativeCleanerService.hasCallLogPermission()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permissão de chamadas negada.')),
        );
      }
      return;
    }

    final calls = await NativeCleanerService.getRecentCalls();
    
    if (!mounted) return;
    
    if (calls.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhum registo de chamadas encontrado.')),
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
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('Chamadas Recentes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark)),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: calls.length,
                  itemBuilder: (ctx, i) {
                    final call = calls[i];
                    return ListTile(
                      leading: const CircleAvatar(backgroundColor: AppColors.accentBlue, child: Icon(Icons.call, color: Colors.white)),
                      title: Text(call['name'] ?? 'Desconhecido', style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(call['number'] ?? ''),
                      onTap: () async {
                        final newContact = TargetContact(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          name: call['name'] ?? 'Desconhecido',
                          phoneNumber: call['number'] ?? '',
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
              const Text('Adicionar Contacto', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textWhite)),
              const SizedBox(height: 20),
              ListTile(
                leading: const CircleAvatar(backgroundColor: AppColors.primaryPurple, child: Icon(Icons.call, color: Colors.white)),
                title: const Text('Do Registo de Chamadas', style: TextStyle(color: AppColors.textWhite)),
                onTap: () {
                  Navigator.pop(ctx);
                  _addFromCallLog();
                },
              ),
              ListTile(
                leading: const CircleAvatar(backgroundColor: AppColors.primaryPurple, child: Icon(Icons.contact_phone, color: Colors.white)),
                title: const Text('Da Lista de Contactos', style: TextStyle(color: AppColors.textWhite)),
                onTap: () {
                  Navigator.pop(ctx);
                  _addFromPhone();
                },
              ),
              ListTile(
                leading: const CircleAvatar(backgroundColor: AppColors.primaryPurple, child: Icon(Icons.dialpad, color: Colors.white)),
                title: const Text('Digitar Manualmente', style: TextStyle(color: AppColors.textWhite)),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filtro de Entidades'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _contacts.isEmpty
                    ? const Center(child: Text('Nenhuma regra configurada.', style: TextStyle(color: AppColors.textLight)))
                    : ListView.separated(
                        padding: const EdgeInsets.all(20),
                        itemCount: _contacts.length,
                        separatorBuilder: (ctx, i) => const SizedBox(height: 15),
                        itemBuilder: (ctx, i) {
                          final c = _contacts[i];
                          return SoftContainer(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const CircleAvatar(backgroundColor: AppColors.primaryPurple, child: Icon(Icons.person, color: Colors.white)),
                              title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textWhite)),
                              subtitle: Text(c.phoneNumber, style: const TextStyle(color: AppColors.textLight)),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.phone, color: AppColors.accentGreen),
                                    onPressed: () async {
                                      await NativeCleanerService.makeCall(c.phoneNumber);
                                    },
                                    tooltip: 'Ligar',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                    onPressed: () async {
                                      await _storage.removeContact(c.id);
                                      _loadContacts();
                                    },
                                    tooltip: 'Apagar',
                                  ),
                                ],
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
