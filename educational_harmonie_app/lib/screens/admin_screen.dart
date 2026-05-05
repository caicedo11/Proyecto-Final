import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// ─────────────────────────────────────────────
//  COLORES Y TEMA
// ─────────────────────────────────────────────
const Color kPrimary = Color(0xFF0B63E5);
const Color kSecondary = Color(0xFF00B4FF);
const Color kBackground = Color(0xFFF0F4FF);
const Color kCard = Colors.white;
const Color kText = Color(0xFF2C3E50);
const Color kMuted = Color(0xFF7F8C8D);
const Color kDanger = Color(0xFFE74C3C);
const Color kSuccess = Color(0xFF28A745);
const Color kWarning = Color(0xFFFFC107);
const Color kBorder = Color(0xFFE1E8F0);

LinearGradient get kGradient => const LinearGradient(
      colors: [kPrimary, kSecondary],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

LinearGradient get kSidebarGradient => const LinearGradient(
      colors: [kPrimary, kSecondary],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

// ─────────────────────────────────────────────
//  ADMIN SCREEN
// ─────────────────────────────────────────────
class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  String _currentView = 'dashboard';

  // Datos
  List<dynamic> usuarios = [];
  List<dynamic> estudiantes = [];
  List<dynamic> invitaciones = [];
  List<dynamic> pendientes = [];
  List<dynamic> historial = [];
  List<dynamic> notificaciones = [];
  bool isLoading = true;

  final String baseUrl = "http://10.0.2.2:8080";

  @override
  void initState() {
    super.initState();
    _fetchAllData();
  }

  Future<void> _fetchAllData() async {
    setState(() => isLoading = true);
    await Future.wait([
      _fetchUsuarios(),
      _fetchEstudiantes(),
      _fetchInvitaciones(),
      _fetchPendientes(),
    ]);
    setState(() => isLoading = false);
  }

  Future<void> _fetchUsuarios() async {
    try {
      final r = await http.get(Uri.parse("$baseUrl/admin/usuarios/listar"));
      if (r.statusCode == 200) setState(() => usuarios = json.decode(r.body));
    } catch (_) {}
  }

  Future<void> _fetchEstudiantes() async {
    try {
      final r = await http.get(Uri.parse("$baseUrl/admin/estudiantes/listar"));
      if (r.statusCode == 200) setState(() => estudiantes = json.decode(r.body));
    } catch (_) {}
  }

  Future<void> _fetchInvitaciones() async {
    try {
      final r = await http.get(Uri.parse("$baseUrl/admin/invitaciones/listar"));
      if (r.statusCode == 200) setState(() => invitaciones = json.decode(r.body));
    } catch (_) {}
  }

  Future<void> _fetchPendientes() async {
    try {
      final r = await http.get(Uri.parse("$baseUrl/admin/pendientes/listar"));
      if (r.statusCode == 200) setState(() => pendientes = json.decode(r.body));
    } catch (_) {}
  }

  void _setView(String view) {
    setState(() => _currentView = view);
    if (Navigator.canPop(context)) Navigator.pop(context);
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // ── DELETE helpers ──────────────────────────
  Future<void> _eliminarUsuario(int id) async {
    final ok = await _confirm('¿Desea eliminar este usuario?');
    if (!ok) return;
    try {
      final r = await http.delete(Uri.parse("$baseUrl/admin/usuarios/eliminar/$id"));
      final d = json.decode(r.body);
      if (d['success'] == true) {
        _snack('✅ Usuario eliminado');
        await _fetchUsuarios();
        setState(() {});
      } else {
        _snack('❌ ${d['error']}');
      }
    } catch (_) {
      _snack('❌ Error de conexión');
    }
  }

  Future<void> _eliminarEstudiante(int id) async {
    final ok = await _confirm('¿Desea eliminar este estudiante?');
    if (!ok) return;
    try {
      final r = await http.delete(Uri.parse("$baseUrl/admin/estudiantes/eliminar/$id"));
      final d = json.decode(r.body);
      if (d['success'] == true) {
        _snack('✅ Estudiante eliminado');
        await _fetchEstudiantes();
        setState(() {});
      } else {
        _snack('❌ ${d['error']}');
      }
    } catch (_) {
      _snack('❌ Error de conexión');
    }
  }

  Future<void> _eliminarInvitacion(int id) async {
    final ok = await _confirm('¿Desea eliminar esta invitación?');
    if (!ok) return;
    try {
      final r = await http.delete(Uri.parse("$baseUrl/admin/invitaciones/eliminar/$id"));
      final d = json.decode(r.body);
      if (d['success'] == true) {
        _snack('✅ Invitación eliminada');
        await _fetchInvitaciones();
        setState(() {});
      } else {
        _snack('❌ ${d['error']}');
      }
    } catch (_) {
      _snack('❌ Error de conexión');
    }
  }

  Future<bool> _confirm(String msg) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            title: const Text('Confirmar'),
            content: Text(msg),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Cancelar')),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: kDanger),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ) ??
        false;
  }

  // ─────────────────────────────────────────────
  //  BUILD
  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final titles = {
      'dashboard': 'Panel de Control',
      'usuarios': 'Usuarios',
      'invitaciones': 'Invitar Usuarios',
      'estudiantes': 'Estudiantes',
      'historial': 'Historial Disciplinario',
      'notificaciones': 'Notificaciones',
    };

    return Scaffold(
      backgroundColor: kBackground,
      appBar: _buildAppBar(titles[_currentView] ?? ''),
      drawer: _buildDrawer(),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: kPrimary),
            )
          : RefreshIndicator(
              onRefresh: _fetchAllData,
              color: kPrimary,
              child: _buildBody(),
            ),
    );
  }

  // ─────────────────────────────────────────────
  //  APP BAR
  // ─────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(String title) {
    return AppBar(
      backgroundColor: kCard,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: kPrimary),
      title: Text(
        'PANEL ADMINISTRADOR',
        style: const TextStyle(
          color: kPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 16,
          letterSpacing: 0.5,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: kBorder),
      ),
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.account_circle, color: kPrimary, size: 30),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          onSelected: (v) {
            if (v == 'logout') {
              Navigator.pushReplacementNamed(context, '/');
            }
          },
          itemBuilder: (_) => [
            const PopupMenuItem(value: 'perfil', child: Text('Perfil')),
            const PopupMenuItem(value: 'logout', child: Text('Cerrar sesión')),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  // ─────────────────────────────────────────────
  //  DRAWER / SIDEBAR
  // ─────────────────────────────────────────────
  Widget _buildDrawer() {
    final items = [
      {'id': 'dashboard', 'icon': Icons.home_rounded, 'label': 'Inicio'},
      {'id': 'usuarios', 'icon': Icons.manage_accounts_rounded, 'label': 'Usuarios'},
      {'id': 'invitaciones', 'icon': Icons.mark_email_read_rounded, 'label': 'Invitar Usuarios'},
      {'id': 'estudiantes', 'icon': Icons.school_rounded, 'label': 'Estudiantes'},
      {'id': 'historial', 'icon': Icons.history_rounded, 'label': 'Historial Disciplinario'},
      {'id': 'notificaciones', 'icon': Icons.notifications_rounded, 'label': 'Notificaciones'},
    ];

    return Drawer(
      child: Container(
        decoration: BoxDecoration(gradient: kSidebarGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Brand
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.menu_book_rounded,
                          color: Colors.white, size: 42),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'EDUCATIONAL\nHARMONIE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        letterSpacing: 1.2,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white24, height: 1),
              const SizedBox(height: 10),
              // Nav items
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  children: items.map((item) {
                    final isActive = _currentView == item['id'];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.white.withOpacity(0.18)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        dense: true,
                        leading: Icon(item['icon'] as IconData,
                            color: Colors.white, size: 22),
                        title: Text(
                          item['label'] as String,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight:
                                isActive ? FontWeight.bold : FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        onTap: () => _setView(item['id'] as String),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  BODY ROUTER
  // ─────────────────────────────────────────────
  Widget _buildBody() {
    switch (_currentView) {
      case 'usuarios':
        return _buildUsuariosView();
      case 'invitaciones':
        return _buildInvitacionesView();
      case 'estudiantes':
        return _buildEstudiantesView();
      case 'historial':
        return _buildHistorialView();
      case 'notificaciones':
        return _buildNotificacionesView();
      default:
        return _buildDashboard();
    }
  }

  // ─────────────────────────────────────────────
  //  DASHBOARD
  // ─────────────────────────────────────────────
  Widget _buildDashboard() {
    final cards = [
      {
        'title': 'Estudiantes Registrados',
        'count': estudiantes.length,
        'icon': Icons.emoji_emotions_outlined,
        'view': 'estudiantes',
      },
      {
        'title': 'Usuarios Registrados',
        'count': usuarios.length,
        'icon': Icons.people_outline_rounded,
        'view': 'usuarios',
      },
      {
        'title': 'Reportes Disciplinarios',
        'count': historial.length,
        'icon': Icons.gavel_rounded,
        'view': 'historial',
      },
      {
        'title': 'Invitaciones Pendientes',
        'count': invitaciones
            .where((i) => i['estado'] == 'PENDIENTE')
            .length,
        'icon': Icons.mail_outline_rounded,
        'view': 'invitaciones',
      },
    ];

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Panel de Control'),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 1.35,
            ),
            itemCount: cards.length,
            itemBuilder: (_, i) {
              final c = cards[i];
              return _dashCard(
                title: c['title'] as String,
                count: (c['count'] as int).toString(),
                icon: c['icon'] as IconData,
                onTap: () => _setView(c['view'] as String),
              );
            },
          ),
          const SizedBox(height: 24),
          _infoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Indicador | Panel de Control',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: kText),
                ),
                SizedBox(height: 8),
                Text(
                  'Bienvenido al panel de administración de Educational Harmonie. Desde aquí puedes gestionar todos los aspectos del sistema.',
                  style: TextStyle(color: kMuted, fontSize: 13, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dashCard({
    required String title,
    required String count,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: kGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: kPrimary.withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 11, height: 1.3),
                  ),
                ),
                Icon(icon, color: Colors.white24, size: 28),
              ],
            ),
            Text(
              count,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold),
            ),
            Row(
              children: const [
                Text('Ver todo',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500)),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios_rounded,
                    color: Colors.white, size: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  USUARIOS
  // ─────────────────────────────────────────────
  Widget _buildUsuariosView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Registro y Gestión de Usuarios'),
          const SizedBox(height: 14),
          _primaryButton(
            label: 'Registrar Usuario',
            icon: Icons.person_add_rounded,
            onTap: () => _showRegistroUsuarioSheet(),
          ),
          const SizedBox(height: 20),
          _subTitle('Lista de Usuarios'),
          const SizedBox(height: 10),
          usuarios.isEmpty
              ? _emptyState('No hay usuarios registrados.')
              : Column(
                  children: usuarios.map((u) => _usuarioCard(u)).toList(),
                ),
        ],
      ),
    );
  }

  Widget _usuarioCard(dynamic u) {
    return _infoCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: kPrimary.withOpacity(0.12),
            child: Text(
              ((u['nombre'] ?? '?')[0]).toUpperCase(),
              style: const TextStyle(
                  color: kPrimary, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${u['nombre']} ${u['apellido']}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14, color: kText),
                ),
                const SizedBox(height: 2),
                Text(u['correo'] ?? '',
                    style: const TextStyle(fontSize: 12, color: kMuted)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _badge(u['rol'] ?? '', kPrimary),
                    if (u['telefono'] != null && u['telefono'] != '') ...[
                      const SizedBox(width: 6),
                      Text(u['telefono'],
                          style:
                              const TextStyle(fontSize: 11, color: kMuted)),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_rounded, color: kPrimary, size: 20),
                onPressed: () =>
                    _snack('Edición en desarrollo. ID: ${u['id']}'),
              ),
              IconButton(
                icon: const Icon(Icons.delete_rounded, color: kDanger, size: 20),
                onPressed: () => _eliminarUsuario(u['id'] as int),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showRegistroUsuarioSheet() {
    final nombreC = TextEditingController();
    final apellidoC = TextEditingController();
    final correoC = TextEditingController();
    final passC = TextEditingController();
    final telefonoC = TextEditingController();
    final direccionC = TextEditingController();
    String? selectedRol;
    bool showPass = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, sc) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            ),
            child: ListView(
              controller: sc,
              children: [
                _sheetHeader('Agregar Usuario'),
                const SizedBox(height: 16),
                _field('Nombres', nombreC, hint: 'Ej. John'),
                _field('Apellidos', apellidoC, hint: 'Ej. Pérez'),
                _dropdownField(
                  label: 'Rol',
                  value: selectedRol,
                  items: const ['ACUDIENTE', 'DOCENTE', 'ADMIN'],
                  onChanged: (v) => setS(() => selectedRol = v),
                ),
                _field('Teléfono', telefonoC, hint: '+502.0000000'),
                _field('Dirección', direccionC, hint: 'Zona 0, Avenida 7-40'),
                _field('Correo', correoC,
                    hint: 'correo@correo.com',
                    keyboardType: TextInputType.emailAddress),
                _passwordField(passC, showPass,
                    onToggle: () => setS(() => showPass = !showPass)),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _primaryButton(
                        label: 'Registrar',
                        onTap: () async {
                          if (selectedRol == null) {
                            _snack('Selecciona un rol');
                            return;
                          }
                          final body = {
                            'nombre': nombreC.text.trim(),
                            'apellido': apellidoC.text.trim(),
                            'correo': correoC.text.trim(),
                            'contraseña': passC.text,
                            'rol': selectedRol,
                            'telefono': telefonoC.text.trim(),
                            'direccion': direccionC.text.trim(),
                          };
                          try {
                            final r = await http.post(
                              Uri.parse(
                                  "$baseUrl/admin/usuarios/crear-directo"),
                              headers: {
                                'Content-Type': 'application/json'
                              },
                              body: json.encode(body),
                            );
                            final d = json.decode(r.body);
                            if (d['success'] == true) {
                              Navigator.pop(ctx);
                              _snack('✅ Usuario registrado correctamente');
                              await _fetchUsuarios();
                              setState(() {});
                            } else {
                              _snack('❌ ${d['error']}');
                            }
                          } catch (_) {
                            _snack('❌ Error de conexión');
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    _dangerButton(
                        label: 'Cancelar',
                        onTap: () => Navigator.pop(ctx)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  INVITACIONES
  // ─────────────────────────────────────────────
  Widget _buildInvitacionesView() {
    int pendienteCount =
        invitaciones.where((i) => i['estado'] == 'PENDIENTE').length;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Invitar Nuevos Usuarios'),
          const SizedBox(height: 14),

          // Formulario invitación
          _infoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Generar Nueva Invitación',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: kText)),
                const SizedBox(height: 14),
                _InvitacionForm(
                  baseUrl: baseUrl,
                  onSuccess: () async {
                    await _fetchInvitaciones();
                    setState(() {});
                    _snack('✅ Invitación generada y correo enviado');
                  },
                  onError: (msg) => _snack(msg),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Invitaciones activas
          _subTitle('Invitaciones Activas'),
          const SizedBox(height: 10),
          invitaciones.isEmpty
              ? _emptyState('No hay invitaciones generadas.')
              : Column(
                  children:
                      invitaciones.map((inv) => _invitacionCard(inv)).toList(),
                ),

          const SizedBox(height: 20),

          // Pendientes
          _subTitle('Registros Pendientes de Revisión'),
          const SizedBox(height: 10),
          pendientes.isEmpty
              ? _emptyState('No hay registros pendientes de revisión.')
              : Column(
                  children: pendientes
                      .map((p) => _pendienteCard(p))
                      .toList(),
                ),
        ],
      ),
    );
  }

  Widget _invitacionCard(dynamic inv) {
    final expira = DateTime.tryParse(inv['fechaExpiracion'] ?? '');
    final expirada = expira != null && expira.isBefore(DateTime.now());
    final estado = expirada ? 'EXPIRADA' : (inv['estado'] ?? 'PENDIENTE');

    Color badgeColor;
    switch (estado) {
      case 'COMPLETADA':
        badgeColor = kSuccess;
        break;
      case 'EXPIRADA':
        badgeColor = kMuted;
        break;
      default:
        badgeColor = kWarning;
    }

    return _infoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      inv['correoInvitado'] ?? '',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: kText),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            inv['codigo'] ?? '',
                            style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 11,
                                color: kText),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _badge(inv['rol'] ?? '', kPrimary),
                      ],
                    ),
                  ],
                ),
              ),
              _badge(estado, badgeColor),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.access_time_rounded,
                  size: 13, color: kMuted),
              const SizedBox(width: 4),
              Text(
                expira != null
                    ? 'Expira: ${expira.day}/${expira.month}/${expira.year} ${expira.hour}:${expira.minute.toString().padLeft(2, '0')}'
                    : '',
                style: const TextStyle(fontSize: 11, color: kMuted),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  final link =
                      '$baseUrl/registro?codigo=${inv['codigo']}';
                  Clipboard.setData(ClipboardData(text: link));
                  _snack('Enlace copiado al portapapeles');
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: kGradient,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.copy_rounded, color: Colors.white, size: 12),
                      SizedBox(width: 4),
                      Text('Copiar',
                          style:
                              TextStyle(color: Colors.white, fontSize: 11)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _eliminarInvitacion(inv['id'] as int),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: kDanger,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.delete_rounded,
                      color: Colors.white, size: 13),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pendienteCard(dynamic p) {
    return _infoCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: kPrimary.withOpacity(0.1),
            child: const Icon(Icons.person_outline_rounded,
                color: kPrimary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p['correo'] ?? '',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: kText)),
                const SizedBox(height: 3),
                Row(
                  children: [
                    _badge(p['rol'] ?? '', kPrimary),
                    const SizedBox(width: 6),
                    Text(
                      p['fechaCompletado'] != null
                          ? _formatDate(p['fechaCompletado'])
                          : '',
                      style: const TextStyle(fontSize: 11, color: kMuted),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimary,
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            icon: const Icon(Icons.visibility_rounded,
                color: Colors.white, size: 14),
            label: const Text('Revisar',
                style: TextStyle(color: Colors.white, fontSize: 12)),
            onPressed: () => _showRevisarModal(p['id'] as int),
          ),
        ],
      ),
    );
  }

  void _showRevisarModal(int id) async {
    try {
      final r = await http.get(
          Uri.parse("$baseUrl/admin/pendientes/detalles/$id"));
      if (r.statusCode != 200) {
        _snack('❌ No se pudo cargar el registro');
        return;
      }
      final reg = json.decode(r.body);

      final usuarioC = TextEditingController(
          text:
              '${(reg['nombre'] ?? '').toLowerCase()}.${(reg['apellido'] ?? '').toLowerCase()}');
      final passC = TextEditingController(
          text:
              'Temp${DateTime.now().millisecondsSinceEpoch.toRadixString(36)}!');

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Revisar Registro',
              style: TextStyle(color: kPrimary, fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _detailRow('Correo', reg['correo'] ?? ''),
                  _detailRow('Rol', reg['rol'] ?? ''),
                  _detailRow('Nombre',
                      '${reg['nombre'] ?? ''} ${reg['apellido'] ?? ''}'),
                  _detailRow('Teléfono',
                      reg['telefono'] ?? 'No proporcionado'),
                  if (reg['especialidad'] != null)
                    _detailRow('Especialidad', reg['especialidad']),
                  if (reg['relacion'] != null)
                    _detailRow('Relación', reg['relacion']),
                  const SizedBox(height: 14),
                  _field('Usuario generado', usuarioC,
                      hint: 'juan.perez'),
                  _field('Contraseña temporal', passC,
                      hint: 'Temp123!'),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: kDanger),
              onPressed: () async {
                final ok = await _confirm(
                    '¿Está seguro de rechazar este registro?');
                if (!ok) return;
                try {
                  final res = await http.post(Uri.parse(
                      "$baseUrl/admin/pendientes/rechazar/$id"));
                  final d = json.decode(res.body);
                  if (d['success'] == true) {
                    Navigator.pop(ctx);
                    _snack('Registro rechazado');
                    await _fetchPendientes();
                    setState(() {});
                  } else {
                    _snack('❌ ${d['error']}');
                  }
                } catch (_) {
                  _snack('❌ Error de conexión');
                }
              },
              child: const Text('Rechazar',
                  style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: kPrimary),
              onPressed: () async {
                if (usuarioC.text.isEmpty || passC.text.isEmpty) {
                  _snack('Complete usuario y contraseña');
                  return;
                }
                try {
                  final res = await http.post(
                    Uri.parse(
                        "$baseUrl/admin/pendientes/aprobar/$id"),
                    headers: {
                      'Content-Type':
                          'application/x-www-form-urlencoded'
                    },
                    body: Uri(queryParameters: {
                      'usuario': usuarioC.text,
                      'password': passC.text,
                    }).query,
                  );
                  final d = json.decode(res.body);
                  if (d['success'] == true) {
                    Navigator.pop(ctx);
                    _snack('✅ Usuario aprobado y credenciales enviadas');
                    await _fetchAllData();
                    setState(() {});
                  } else {
                    _snack('❌ ${d['error']}');
                  }
                } catch (_) {
                  _snack('❌ Error de conexión');
                }
              },
              child: const Text('Aprobar',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    } catch (_) {
      _snack('❌ No se pudo cargar el registro');
    }
  }

  // ─────────────────────────────────────────────
  //  ESTUDIANTES
  // ─────────────────────────────────────────────
  Widget _buildEstudiantesView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Registro y Gestión de Estudiantes'),
          const SizedBox(height: 14),
          _primaryButton(
            label: 'Registrar Estudiante',
            icon: Icons.person_add_rounded,
            onTap: () => _showRegistroEstudianteSheet(),
          ),
          const SizedBox(height: 20),
          _subTitle('Lista de Estudiantes'),
          const SizedBox(height: 10),
          estudiantes.isEmpty
              ? _emptyState('No hay estudiantes registrados.')
              : Column(
                  children:
                      estudiantes.map((e) => _estudianteCard(e)).toList(),
                ),
        ],
      ),
    );
  }

  Widget _estudianteCard(dynamic e) {
    return _infoCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: kSecondary.withOpacity(0.15),
            child: Text(
              ((e['nombre'] ?? '?')[0]).toUpperCase(),
              style: const TextStyle(
                  color: kSecondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${e['nombre']} ${e['apellido']}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: kText),
                ),
                const SizedBox(height: 3),
                Text('${e['grado']} — Sección ${e['seccion']}',
                    style: const TextStyle(fontSize: 12, color: kMuted)),
                const SizedBox(height: 3),
                Text('Acudiente: ${e['acudiente']}',
                    style: const TextStyle(fontSize: 11, color: kMuted)),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_rounded,
                    color: kPrimary, size: 20),
                onPressed: () =>
                    _snack('Edición en desarrollo. ID: ${e['id']}'),
              ),
              IconButton(
                icon: const Icon(Icons.delete_rounded,
                    color: kDanger, size: 20),
                onPressed: () => _eliminarEstudiante(e['id'] as int),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showRegistroEstudianteSheet() {
    final nombreC = TextEditingController();
    final apellidoC = TextEditingController();
    final telefonoC = TextEditingController();
    final correoC = TextEditingController();
    final direccionC = TextEditingController();
    final edadC = TextEditingController();
    final acudienteC = TextEditingController();
    String? grado;
    String seccion = 'A';
    String? sexo;
    DateTime? nacimiento;

    final grados = [
      'Primero Primaria',
      'Segundo Primaria',
      'Tercero Primaria'
    ];
    final secciones = ['A', 'B', 'C'];
    final sexos = ['M', 'F'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => DraggableScrollableSheet(
          initialChildSize: 0.95,
          minChildSize: 0.5,
          maxChildSize: 0.97,
          builder: (_, sc) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            ),
            child: ListView(
              controller: sc,
              children: [
                _sheetHeader('Datos del Estudiante'),
                const SizedBox(height: 16),
                _dropdownField(
                  label: 'Grado',
                  value: grado,
                  items: grados,
                  onChanged: (v) => setS(() => grado = v),
                ),
                _field('Nombres', nombreC, hint: 'Ej. John'),
                _field('Apellidos', apellidoC, hint: 'Ej. Pérez'),
                _field('Teléfono', telefonoC, hint: '00000000'),
                _dropdownField(
                  label: 'Sección',
                  value: seccion,
                  items: secciones,
                  onChanged: (v) => setS(() => seccion = v ?? 'A'),
                ),
                _field('Correo', correoC,
                    hint: 'correo@correo.com',
                    keyboardType: TextInputType.emailAddress),
                _field('Dirección', direccionC,
                    hint: 'No se estableció una dirección'),
                _field('Edad', edadC,
                    hint: 'Ej. 10',
                    keyboardType: TextInputType.number),
                _dropdownField(
                  label: 'Sexo',
                  value: sexo,
                  items: sexos,
                  onChanged: (v) => setS(() => sexo = v),
                ),
                _field('Nombre del Acudiente', acudienteC,
                    hint: 'Nombre del acudiente'),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _primaryButton(
                        label: 'Registrar Estudiante',
                        onTap: () async {
                          if (grado == null) {
                            _snack('Selecciona un grado');
                            return;
                          }
                          final body = {
                            'nombre': nombreC.text.trim(),
                            'apellido': apellidoC.text.trim(),
                            'grado': grado,
                            'seccion': seccion,
                            'telefono': telefonoC.text.trim(),
                            'correo': correoC.text.trim(),
                            'direccion': direccionC.text.trim(),
                            'edad': edadC.text,
                            'sexo': sexo ?? '',
                            'ciclo': '2025',
                            'acudiente': acudienteC.text.trim(),
                          };
                          try {
                            final r = await http.post(
                              Uri.parse(
                                  "$baseUrl/admin/estudiantes/crear"),
                              headers: {
                                'Content-Type': 'application/json'
                              },
                              body: json.encode(body),
                            );
                            final d = json.decode(r.body);
                            if (d['success'] == true) {
                              Navigator.pop(ctx);
                              _snack('✅ Estudiante registrado correctamente');
                              await _fetchEstudiantes();
                              setState(() {});
                            } else {
                              _snack('❌ ${d['error']}');
                            }
                          } catch (_) {
                            _snack('❌ Error de conexión');
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    _dangerButton(
                        label: 'Cancelar',
                        onTap: () => Navigator.pop(ctx)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  HISTORIAL
  // ─────────────────────────────────────────────
  Widget _buildHistorialView() {
    final searchC = TextEditingController();
    List<dynamic> filtered = historial;

    return StatefulBuilder(
      builder: (ctx, setS) => SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Historial Disciplinario de Estudiantes'),
            const SizedBox(height: 6),
            const Text(
                'Consulta los reportes disciplinarios registrados en la plataforma.',
                style: TextStyle(fontSize: 13, color: kMuted)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchC,
                    decoration: InputDecoration(
                      hintText: 'Buscar estudiante por nombre...',
                      hintStyle: const TextStyle(fontSize: 13),
                      prefixIcon: const Icon(Icons.search_rounded,
                          color: kMuted, size: 18),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: kBorder),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                _primaryButton(
                  label: 'Buscar',
                  onTap: () {
                    final t = searchC.text.toLowerCase();
                    setS(() {
                      filtered = t.isEmpty
                          ? historial
                          : historial
                              .where((h) => h['estudiante']
                                  .toLowerCase()
                                  .contains(t))
                              .toList();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            filtered.isEmpty
                ? _emptyState('No hay registros disciplinarios.')
                : Column(
                    children: filtered
                        .map((h) => _historialCard(h))
                        .toList(),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _historialCard(dynamic h) {
    final resuelto = h['estado'] == 'resuelto';
    return _infoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(h['estudiante'] ?? '',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: kText)),
              ),
              _badge(
                resuelto ? 'Resuelto' : 'Pendiente',
                resuelto ? kSuccess : kWarning,
              ),
            ],
          ),
          const SizedBox(height: 6),
          _detailRow('Grado', h['grado'] ?? ''),
          _detailRow('Docente', h['docente'] ?? ''),
          _detailRow('Motivo', h['motivo'] ?? ''),
          _detailRow('Descripción', h['descripcion'] ?? ''),
          _detailRow('Fecha', h['fecha'] ?? ''),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  NOTIFICACIONES
  // ─────────────────────────────────────────────
  Widget _buildNotificacionesView() {
    final destinatarioC = ValueNotifier<String?>(null);
    final asuntoC = TextEditingController();
    final mensajeC = TextEditingController();
    final docentes =
        usuarios.where((u) => u['rol'] == 'DOCENTE').toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Notificaciones a Docentes'),
          const SizedBox(height: 6),
          const Text('Envía mensajes o recordatorios a los docentes registrados.',
              style: TextStyle(fontSize: 13, color: kMuted)),
          const SizedBox(height: 16),
          _infoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ValueListenableBuilder<String?>(
                  valueListenable: destinatarioC,
                  builder: (_, val, _) => _dropdownField(
                    label: 'Docente',
                    value: val,
                    items: docentes
                        .map<String>((u) =>
                            '${u['nombre']} ${u['apellido']} (${u['correo']})')
                        .toList(),
                    onChanged: (v) {
                      destinatarioC.value = v;
                    },
                  ),
                ),
                _field('Asunto', asuntoC,
                    hint: 'Motivo del mensaje'),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Mensaje',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: kText)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: mensajeC,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Escriba el mensaje aquí...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: kBorder),
                          ),
                          contentPadding: const EdgeInsets.all(12),
                        ),
                      ),
                    ],
                  ),
                ),
                _primaryButton(
                  label: 'Enviar notificación',
                  onTap: () async {
                    if (destinatarioC.value == null) {
                      _snack('Selecciona un docente');
                      return;
                    }
                    final correo = docentes.firstWhere((u) =>
                        '${u['nombre']} ${u['apellido']} (${u['correo']})' ==
                        destinatarioC.value)['correo'];
                    final body = {
                      'destinatario': correo,
                      'asunto': asuntoC.text,
                      'mensaje': mensajeC.text,
                    };
                    try {
                      final r = await http.post(
                        Uri.parse(
                            "$baseUrl/admin/notificaciones/enviar"),
                        headers: {
                          'Content-Type': 'application/json'
                        },
                        body: json.encode(body),
                      );
                      final d = json.decode(r.body);
                      if (d['success'] == true) {
                        _snack('✅ Notificación enviada correctamente');
                        asuntoC.clear();
                        mensajeC.clear();
                      } else {
                        _snack('❌ ${d['error']}');
                      }
                    } catch (_) {
                      _snack('❌ Error de conexión');
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _subTitle('Historial de notificaciones'),
          const SizedBox(height: 10),
          notificaciones.isEmpty
              ? _emptyState('No hay notificaciones enviadas.')
              : Column(
                  children: notificaciones
                      .map((n) => _infoCard(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                _detailRow('Destinatario',
                                    n['destinatario'] ?? ''),
                                _detailRow('Asunto', n['asunto'] ?? ''),
                                _detailRow('Mensaje', n['mensaje'] ?? ''),
                                _detailRow('Fecha', n['fecha'] ?? ''),
                              ],
                            ),
                          ))
                      .toList(),
                ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  HELPERS / WIDGETS REUTILIZABLES
  // ─────────────────────────────────────────────
  Widget _sectionTitle(String t) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t,
              style: const TextStyle(
                  color: kPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
          const SizedBox(height: 6),
          Container(height: 2, width: 50, color: kPrimary),
        ],
      );

  Widget _subTitle(String t) => Text(t,
      style: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: 15, color: kText));

  Widget _infoCard({required Widget child}) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kBorder),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: child,
      );

  Widget _emptyState(String msg) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(msg,
              style: const TextStyle(color: kMuted, fontSize: 14)),
        ),
      );

  Widget _badge(String label, Color color) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(label,
            style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.bold)),
      );

  Widget _primaryButton({
    required String label,
    required VoidCallback onTap,
    IconData? icon,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            gradient: kGradient,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, color: Colors.white, size: 16),
                const SizedBox(width: 6),
              ],
              Text(label,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13)),
            ],
          ),
        ),
      );

  Widget _dangerButton({
    required String label,
    required VoidCallback onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: kDanger,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(label,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13)),
        ),
      );

  Widget _field(
    String label,
    TextEditingController controller, {
    String hint = '',
    TextInputType keyboardType = TextInputType.text,
  }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: kText)),
            const SizedBox(height: 6),
            TextField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(fontSize: 13, color: kMuted),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: kBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: kBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: kPrimary, width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
              ),
            ),
          ],
        ),
      );

  Widget _passwordField(
    TextEditingController controller,
    bool showPass, {
    required VoidCallback onToggle,
  }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Contraseña del Usuario',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: kText)),
            const SizedBox(height: 6),
            TextField(
              controller: controller,
              obscureText: !showPass,
              decoration: InputDecoration(
                hintText: 'Escriba una contraseña',
                hintStyle: const TextStyle(fontSize: 13, color: kMuted),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: kBorder),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    showPass
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    color: kMuted,
                    size: 18,
                  ),
                  onPressed: onToggle,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
              ),
            ),
          ],
        ),
      );

  Widget _dropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: kText)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: value,
              hint: const Text('No se ha seleccionado',
                  style: TextStyle(fontSize: 13, color: kMuted)),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: kBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: kBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: kPrimary, width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
              ),
              items: items
                  .map((i) =>
                      DropdownMenuItem(value: i, child: Text(i)))
                  .toList(),
              onChanged: onChanged,
            ),
          ],
        ),
      );

  Widget _sheetHeader(String title) => Row(
        children: [
          Expanded(
            child: Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: kText)),
          ),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: kBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      );

  Widget _detailRow(String key, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 90,
              child: Text('$key:',
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: kMuted)),
            ),
            Expanded(
              child: Text(value,
                  style:
                      const TextStyle(fontSize: 12, color: kText)),
            ),
          ],
        ),
      );

  String _formatDate(String dateStr) {
    final d = DateTime.tryParse(dateStr);
    if (d == null) return dateStr;
    return '${d.day}/${d.month}/${d.year}';
  }
}

// ─────────────────────────────────────────────
//  WIDGET SEPARADO: FORMULARIO INVITACIÓN
//  (usa StatefulWidget propio para manejar loading)
// ─────────────────────────────────────────────
class _InvitacionForm extends StatefulWidget {
  final String baseUrl;
  final VoidCallback onSuccess;
  final ValueChanged<String> onError;

  const _InvitacionForm({
    required this.baseUrl,
    required this.onSuccess,
    required this.onError,
  });

  @override
  State<_InvitacionForm> createState() => _InvitacionFormState();
}

class _InvitacionFormState extends State<_InvitacionForm> {
  final correoC = TextEditingController();
  String? selectedRol;
  String horas = '48';
  bool loading = false;
  String? successMsg;
  String? errorMsg;

  final roles = ['DOCENTE', 'ACUDIENTE'];
  final horasOpts = [
    {'label': '24 horas', 'value': '24'},
    {'label': '48 horas', 'value': '48'},
    {'label': '72 horas', 'value': '72'},
    {'label': '7 días', 'value': '168'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextField(
                controller: correoC,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'correo@ejemplo.com',
                  hintStyle:
                      const TextStyle(fontSize: 13, color: kMuted),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: kBorder),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: DropdownButtonFormField<String>(
                initialValue: selectedRol,
                hint: const Text('Rol',
                    style: TextStyle(fontSize: 13, color: kMuted)),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: kBorder),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                ),
                items: roles
                    .map((r) => DropdownMenuItem(
                        value: r, child: Text(r)))
                    .toList(),
                onChanged: (v) => setState(() => selectedRol = v),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          initialValue: horas,
          decoration: InputDecoration(
            labelText: 'Tiempo de validez',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: kBorder),
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 10),
          ),
          items: horasOpts
              .map((o) => DropdownMenuItem(
                  value: o['value'],
                  child: Text(o['label']!)))
              .toList(),
          onChanged: (v) => setState(() => horas = v ?? '48'),
        ),
        const SizedBox(height: 12),
        if (successMsg != null)
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: kSuccess.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: kSuccess.withOpacity(0.3)),
            ),
            child: Text(successMsg!,
                style: const TextStyle(color: kSuccess, fontSize: 12)),
          ),
        if (errorMsg != null)
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: kDanger.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: kDanger.withOpacity(0.3)),
            ),
            child: Text(errorMsg!,
                style: const TextStyle(color: kDanger, fontSize: 12)),
          ),
        GestureDetector(
          onTap: loading ? null : _submit,
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: loading
                  ? null
                  : const LinearGradient(
                      colors: [kPrimary, kSecondary]),
              color: loading ? kBorder : null,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (loading)
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: kPrimary),
                  )
                else
                  const Icon(Icons.send_rounded,
                      color: Colors.white, size: 15),
                const SizedBox(width: 6),
                Text(
                  loading ? 'Generando...' : 'Generar Invitación',
                  style: TextStyle(
                      color: loading ? kMuted : Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    if (correoC.text.isEmpty || selectedRol == null) {
      setState(() {
        errorMsg = 'Completa correo y rol';
        successMsg = null;
      });
      return;
    }
    setState(() {
      loading = true;
      errorMsg = null;
      successMsg = null;
    });
    try {
      final r = await http.post(
        Uri.parse("${widget.baseUrl}/admin/invitaciones/generar"),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: Uri(queryParameters: {
          'correo': correoC.text,
          'rol': selectedRol!,
          'horas': horas,
        }).query,
      );
      final d = json.decode(r.body);
      if (d['success'] == true) {
        setState(() {
          successMsg =
              '✅ Invitación generada. Código: ${d['codigo']}';
        });
        correoC.clear();
        setState(() => selectedRol = null);
        widget.onSuccess();
      } else {
        setState(() => errorMsg = '❌ ${d['error']}');
        widget.onError('❌ ${d['error']}');
      }
    } catch (_) {
      setState(() => errorMsg = '❌ Error de conexión con el servidor');
      widget.onError('❌ Error de conexión');
    } finally {
      setState(() => loading = false);
    }
  }
}