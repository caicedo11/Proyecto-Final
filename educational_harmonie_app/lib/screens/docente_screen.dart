import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// ─────────────────────────────────────────────
//  COLORES Y TEMA
// ─────────────────────────────────────────────
const Color kPrimary   = Color(0xFF0B63E5);
const Color kSecondary = Color(0xFF00B4FF);
const Color kBg        = Color(0xFFF0F4FF);
const Color kCard      = Colors.white;
const Color kText      = Color(0xFF2C3E50);
const Color kMuted     = Color(0xFF7F8C8D);
const Color kDanger    = Color(0xFFE74C3C);
const Color kSuccess   = Color(0xFF28A745);
const Color kWarning   = Color(0xFFF39C12);
const Color kBorder    = Color(0xFFE1E8F0);

const LinearGradient kGradient = LinearGradient(
  colors: [kPrimary, kSecondary],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

const LinearGradient kSidebarGradient = LinearGradient(
  colors: [kPrimary, kSecondary],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

// ─────────────────────────────────────────────
//  DOCENTE SCREEN
// ─────────────────────────────────────────────
class DocenteScreen extends StatefulWidget {
  const DocenteScreen({super.key});

  @override
  State<DocenteScreen> createState() => _DocenteScreenState();
}

class _DocenteScreenState extends State<DocenteScreen> {
  String _currentView = 'dashboard';

  // Datos en memoria (equivalente al localStorage del HTML)
  List<Map<String, dynamic>> _reportes           = [];
  List<Map<String, dynamic>> _quejas             = [];
  List<Map<String, dynamic>> _notificaciones     = [];
  List<Map<String, dynamic>> _notifAcudientes    = [];

  // ── snackbar helper ──────────────────────────
  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  Future<bool> _confirm(String msg) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            title: const Text('Confirmar'),
            content: Text(msg),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Cancelar')),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: kDanger),
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Aceptar', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _setView(String view) {
    setState(() => _currentView = view);
    if (Navigator.canPop(context)) Navigator.pop(context);
  }

  // ─────────────────────────────────────────────
  //  BUILD
  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: _buildBody(),
    );
  }

  // ── APP BAR ─────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: kCard,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: const IconThemeData(color: kPrimary),
      title: const Text(
        'PANEL DOCENTE',
        style: TextStyle(
            color: kPrimary, fontWeight: FontWeight.bold,
            fontSize: 16, letterSpacing: 0.5),
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
            if (v == 'logout') Navigator.pushReplacementNamed(context, '/');
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

  // ── DRAWER / SIDEBAR ─────────────────────────
  Widget _buildDrawer() {
    final items = [
      {'id': 'dashboard',  'icon': Icons.home_rounded,         'label': 'Inicio'},
      {'id': 'registrar',  'icon': Icons.edit_note_rounded,    'label': 'Registrar Reporte'},
      {'id': 'ver',        'icon': Icons.folder_open_rounded,  'label': 'Historial de Reportes'},
      {'id': 'quejas',     'icon': Icons.comment_rounded,      'label': 'Quejas'},
      {'id': 'not',        'icon': Icons.notifications_rounded,'label': 'Notificar'},
    ];

    return Drawer(
      child: Container(
        decoration: const BoxDecoration(gradient: kSidebarGradient),
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
                        color: Colors.white, fontWeight: FontWeight.bold,
                        fontSize: 13, letterSpacing: 1.2, height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white24, height: 1),
              const SizedBox(height: 10),
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
                            fontWeight: isActive
                                ? FontWeight.bold
                                : FontWeight.w500,
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

  // ── BODY ROUTER ──────────────────────────────
  Widget _buildBody() {
    switch (_currentView) {
      case 'registrar': return _buildRegistrarView();
      case 'ver':       return _buildHistorialView();
      case 'quejas':    return _buildQuejasView();
      case 'not':       return _buildNotificarView();
      default:          return _buildDashboard();
    }
  }

  // ─────────────────────────────────────────────
  //  1. DASHBOARD
  // ─────────────────────────────────────────────
  Widget _buildDashboard() {
    final cards = [
      {
        'title': 'Reportes Registrados',
        'count': _reportes.length,
        'icon': Icons.analytics_outlined,
        'view': 'ver',
      },
      {
        'title': 'Quejas Recibidas',
        'count': _quejas.length,
        'icon': Icons.comment_outlined,
        'view': 'quejas',
      },
      {
        'title': 'Notificaciones Enviadas',
        'count': _notifAcudientes.length,
        'icon': Icons.send_outlined,
        'view': 'not',
      },
    ];

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Panel de Control Docente'),
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
                Text('Bienvenido al Panel Docente',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15, color: kText)),
                SizedBox(height: 8),
                Text(
                  'Selecciona una opción del menú para comenzar a gestionar tus actividades.',
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
                  child: Text(title,
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 11, height: 1.3)),
                ),
                Icon(icon, color: Colors.white24, size: 28),
              ],
            ),
            Text(count,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold)),
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
  //  2. REGISTRAR REPORTE
  // ─────────────────────────────────────────────
  Widget _buildRegistrarView() {
    final nombreC      = TextEditingController();
    final motivoC      = TextEditingController();
    final descripcionC = TextEditingController();
    String? curso;
    String? acudiente;
    String? tipoReporte;
    DateTime? fecha;
    final formKey      = GlobalKey<FormState>();

    final cursos     = ['Primero Primaria', 'Segundo Primaria', 'Tercero Primaria'];
    final acudientes = ['Padre', 'Madre', 'Tutor'];
    final tipos      = ['Comportamiento', 'Académico', 'Asistencia', 'Otro'];

    return StatefulBuilder(
      builder: (ctx, setS) => SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('Registrar Reporte para Acudiente'),
              const SizedBox(height: 16),

              // Nombre del estudiante
              _fieldLabel('Nombre del Estudiante'),
              _textFormField(nombreC, 'Nombre del estudiante',
                  validator: (v) => (v == null || v.isEmpty)
                      ? 'Campo requerido' : null),

              // Curso
              _fieldLabel('Curso'),
              _dropdownFormField(
                value: curso,
                items: cursos,
                hint: 'Seleccione un curso',
                onChanged: (v) => setS(() => curso = v),
                validator: (v) =>
                    v == null ? 'Campo requerido' : null,
              ),

              // Acudiente
              _fieldLabel('Acudiente'),
              _dropdownFormField(
                value: acudiente,
                items: acudientes,
                hint: 'Seleccione un acudiente',
                onChanged: (v) => setS(() => acudiente = v),
                validator: (v) =>
                    v == null ? 'Campo requerido' : null,
              ),

              // Fecha
              _fieldLabel('Fecha'),
              _datePicker(
                selected: fecha,
                onTap: () async {
                  final d = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                    builder: (ctx, child) => Theme(
                      data: Theme.of(ctx).copyWith(
                        colorScheme:
                            const ColorScheme.light(primary: kPrimary),
                      ),
                      child: child!,
                    ),
                  );
                  if (d != null) setS(() => fecha = d);
                },
              ),

              // Tipo de reporte
              _fieldLabel('Tipo de Reporte'),
              _dropdownFormField(
                value: tipoReporte,
                items: tipos,
                hint: 'Seleccione un tipo',
                onChanged: (v) => setS(() => tipoReporte = v),
                validator: (v) =>
                    v == null ? 'Campo requerido' : null,
              ),

              // Motivo
              _fieldLabel('Motivo'),
              _textFormField(motivoC, 'Motivo del reporte',
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Campo requerido' : null),

              // Descripción
              _fieldLabel('Descripción'),
              _textAreaFormField(descripcionC, 'Descripción detallada...',
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Campo requerido' : null),

              const SizedBox(height: 20),
              _gradientButton(
                label: 'Registrar y Notificar',
                icon: Icons.save_rounded,
                onTap: () {
                  if (!formKey.currentState!.validate()) return;
                  if (fecha == null) {
                    _snack('Selecciona una fecha');
                    return;
                  }
                  final reporte = {
                    'nombreEstudiante': nombreC.text.trim(),
                    'curso': curso ?? '',
                    'acudiente': acudiente ?? '',
                    'tipoReporte': tipoReporte ?? '',
                    'motivo': motivoC.text.trim(),
                    'fecha':
                        '${fecha!.day}/${fecha!.month}/${fecha!.year}',
                    'descripcion': descripcionC.text.trim(),
                  };
                  setState(() {
                    _reportes.add(reporte);
                    _notifAcudientes.add({
                      'destinatario': acudiente ?? '',
                      'estudiante': nombreC.text.trim(),
                      'asunto':
                          'Reporte de ${tipoReporte ?? ''} - ${nombreC.text.trim()}',
                      'mensaje': descripcionC.text.trim(),
                      'fecha': DateTime.now()
                          .toIso8601String()
                          .split('T')[0],
                      'tipo': 'reporte',
                    });
                  });
                  _snack(
                      '✅ Reporte registrado y notificación enviada al acudiente');
                  nombreC.clear();
                  motivoC.clear();
                  descripcionC.clear();
                  setS(() {
                    curso = null;
                    acudiente = null;
                    tipoReporte = null;
                    fecha = null;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  3. HISTORIAL DE REPORTES
  // ─────────────────────────────────────────────
  Widget _buildHistorialView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Historial de Reportes'),
          const SizedBox(height: 16),
          _reportes.isEmpty
              ? _emptyState('No hay reportes aún.')
              : Column(
                  children: List.generate(_reportes.length, (i) {
                    final r = _reportes[i];
                    return _reporteCard(r, i);
                  }),
                ),
        ],
      ),
    );
  }

  Widget _reporteCard(Map<String, dynamic> r, int idx) {
    return _infoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  r['nombreEstudiante'] ?? '',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14, color: kText),
                ),
              ),
              _badge(r['tipoReporte'] ?? '', kPrimary),
            ],
          ),
          const SizedBox(height: 6),
          _detailRow('Curso', r['curso'] ?? ''),
          _detailRow('Acudiente', r['acudiente'] ?? ''),
          _detailRow('Motivo', r['motivo'] ?? ''),
          _detailRow('Fecha', r['fecha'] ?? ''),
          _detailRow('Descripción', r['descripcion'] ?? ''),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_rounded, color: kPrimary, size: 20),
                onPressed: () =>
                    _snack('Funcionalidad de edición en desarrollo'),
              ),
              IconButton(
                icon: const Icon(Icons.delete_rounded,
                    color: kDanger, size: 20),
                onPressed: () async {
                  final ok =
                      await _confirm('¿Desea eliminar este reporte?');
                  if (ok) {
                    setState(() => _reportes.removeAt(idx));
                    _snack('Reporte eliminado');
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  4. QUEJAS
  // ─────────────────────────────────────────────
  Widget _buildQuejasView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Quejas de Acudientes'),
          const SizedBox(height: 16),
          _quejas.isEmpty
              ? _emptyState('No hay quejas registradas aún.')
              : Column(
                  children: List.generate(_quejas.length, (i) {
                    final q = _quejas[i];
                    return _quejaCard(q, i);
                  }),
                ),
        ],
      ),
    );
  }

  Widget _quejaCard(Map<String, dynamic> q, int idx) {
    final resuelta = q['estado'] == 'resuelta';
    return _infoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  q['acudiente'] ?? '',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14, color: kText),
                ),
              ),
              _badge(
                resuelta ? 'Resuelta' : 'Pendiente',
                resuelta ? kSuccess : kWarning,
              ),
            ],
          ),
          const SizedBox(height: 6),
          _detailRow('Estudiante', q['estudiante'] ?? ''),
          _detailRow('Fecha', q['fecha'] ?? ''),
          _detailRow('Asunto', q['asunto'] ?? ''),
          _detailRow('Mensaje', q['mensaje'] ?? ''),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (!resuelta)
                _outlineButton(
                  label: 'Resolver',
                  icon: Icons.check_circle_outline_rounded,
                  onTap: () async {
                    final ok = await _confirm(
                        '¿Marcar esta queja como resuelta?');
                    if (ok) {
                      setState(
                          () => _quejas[idx]['estado'] = 'resuelta');
                    }
                  },
                ),
              const SizedBox(width: 8),
              _dangerButton(
                label: 'Eliminar',
                onTap: () async {
                  final ok =
                      await _confirm('¿Desea eliminar esta queja?');
                  if (ok) {
                    setState(() => _quejas.removeAt(idx));
                    _snack('Queja eliminada');
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  5. NOTIFICAR
  // ─────────────────────────────────────────────
  Widget _buildNotificarView() {
    final asuntoC   = TextEditingController();
    final mensajeC  = TextEditingController();
    String? destinatario;
    final formKey   = GlobalKey<FormState>();
    final destinos  = ['Administración', 'Coordinación', 'Padres de Familia'];

    return StatefulBuilder(
      builder: (ctx, setS) => SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Enviar Notificación'),
            const SizedBox(height: 16),

            _infoCard(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('Destinatario'),
                    _dropdownFormField(
                      value: destinatario,
                      items: destinos,
                      hint: 'Seleccione un destinatario',
                      onChanged: (v) => setS(() => destinatario = v),
                      validator: (v) =>
                          v == null ? 'Campo requerido' : null,
                    ),
                    _fieldLabel('Asunto'),
                    _textFormField(asuntoC, 'Motivo del mensaje',
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Campo requerido'
                            : null),
                    _fieldLabel('Mensaje'),
                    _textAreaFormField(mensajeC, 'Escriba el mensaje aquí...',
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Campo requerido'
                            : null),
                    const SizedBox(height: 12),
                    _gradientButton(
                      label: 'Enviar',
                      icon: Icons.send_rounded,
                      onTap: () {
                        if (!formKey.currentState!.validate()) return;
                        setState(() {
                          _notificaciones.add({
                            'destinatario': destinatario ?? '',
                            'asunto': asuntoC.text.trim(),
                            'mensaje': mensajeC.text.trim(),
                            'fecha': DateTime.now()
                                .toIso8601String()
                                .split('T')[0],
                          });
                        });
                        _snack('📨 Notificación enviada correctamente');
                        asuntoC.clear();
                        mensajeC.clear();
                        setS(() => destinatario = null);
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            _subTitle('Historial de Notificaciones'),
            const SizedBox(height: 10),
            _notificaciones.isEmpty
                ? _emptyState('No hay notificaciones enviadas.')
                : Column(
                    children: _notificaciones
                        .map((n) => _infoCard(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  _detailRow('Destinatario',
                                      n['destinatario'] ?? ''),
                                  _detailRow(
                                      'Asunto', n['asunto'] ?? ''),
                                  _detailRow('Fecha', n['fecha'] ?? ''),
                                ],
                              ),
                            ))
                        .toList(),
                  ),

            const SizedBox(height: 24),
            _subTitle('Notificaciones a Acudientes'),
            const SizedBox(height: 10),
            _notifAcudientes.isEmpty
                ? _emptyState('No hay notificaciones enviadas a acudientes.')
                : Column(
                    children: _notifAcudientes
                        .map((n) => _infoCard(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  _detailRow('Destinatario',
                                      n['destinatario'] ?? ''),
                                  _detailRow('Estudiante',
                                      n['estudiante'] ?? ''),
                                  _detailRow(
                                      'Asunto', n['asunto'] ?? ''),
                                  _detailRow('Fecha', n['fecha'] ?? ''),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
          ],
        ),
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
                color: color, fontSize: 11, fontWeight: FontWeight.bold)),
      );

  Widget _gradientButton({
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

  Widget _dangerButton({required String label, required VoidCallback onTap}) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: kDanger,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(label,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12)),
        ),
      );

  Widget _outlineButton(
          {required String label,
          required VoidCallback onTap,
          IconData? icon}) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: kPrimary),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, color: kPrimary, size: 14),
                const SizedBox(width: 4),
              ],
              Text(label,
                  style: const TextStyle(
                      color: kPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12)),
            ],
          ),
        ),
      );

  Widget _fieldLabel(String label) => Padding(
        padding: const EdgeInsets.only(bottom: 6, top: 4),
        child: Text(label,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: kText)),
      );

  Widget _textFormField(
    TextEditingController ctrl,
    String hint, {
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextFormField(
          controller: ctrl,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 13, color: kMuted),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: kBorder)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: kBorder)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: kPrimary, width: 1.5)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: kDanger, width: 1)),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 10),
          ),
        ),
      );

  Widget _textAreaFormField(
    TextEditingController ctrl,
    String hint, {
    String? Function(String?)? validator,
  }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextFormField(
          controller: ctrl,
          maxLines: 4,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 13, color: kMuted),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: kBorder)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: kBorder)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: kPrimary, width: 1.5)),
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
      );

  Widget _dropdownFormField({
    required String? value,
    required List<String> items,
    required String hint,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
  }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: DropdownButtonFormField<String>(
          value: value,
          validator: validator,
          hint: Text(hint,
              style: const TextStyle(fontSize: 13, color: kMuted)),
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: kBorder)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: kBorder)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: kPrimary, width: 1.5)),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 10),
          ),
          items: items
              .map((i) => DropdownMenuItem(value: i, child: Text(i)))
              .toList(),
          onChanged: onChanged,
        ),
      );

  Widget _datePicker({
    required DateTime? selected,
    required VoidCallback onTap,
  }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: kBorder),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_rounded,
                    color: kPrimary, size: 18),
                const SizedBox(width: 8),
                Text(
                  selected != null
                      ? '${selected.day}/${selected.month}/${selected.year}'
                      : 'Selecciona una fecha',
                  style: TextStyle(
                      fontSize: 13,
                      color: selected != null ? kText : kMuted),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _detailRow(String key, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
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
                  style: const TextStyle(
                      fontSize: 12, color: kText)),
            ),
          ],
        ),
      );
}