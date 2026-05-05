import 'package:flutter/material.dart';

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
//  ACUDIENTE SCREEN
// ─────────────────────────────────────────────
class AcudienteScreen extends StatefulWidget {
  const AcudienteScreen({super.key});

  @override
  State<AcudienteScreen> createState() => _AcudienteScreenState();
}

class _AcudienteScreenState extends State<AcudienteScreen> {
  String _currentView = 'dashboard';

  // Datos en memoria (equivalente al localStorage del HTML)
  List<Map<String, dynamic>> _quejas  = [];
  List<Map<String, dynamic>> _reportes = [
    {
      'fecha': '15/10/2025',
      'docente': 'Profesor Gómez',
      'motivo': 'Inasistencia a clase',
      'accion': 'Notificación enviada',
      'estado': 'resuelto'
    },
    {
      'fecha': '21/10/2025',
      'docente': 'Profesora Ruiz',
      'motivo': 'Comportamiento inadecuado',
      'accion': 'Reunión con acudiente',
      'estado': 'pendiente'
    },
  ];

  // ── helpers ──────────────────────────────────
  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
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
        'PANEL ACUDIENTE',
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
      {'id': 'dashboard',   'icon': Icons.home_rounded,          'label': 'Inicio'},
      {'id': 'enviarQueja', 'icon': Icons.comment_rounded,       'label': 'Enviar Queja'},
      {'id': 'verReportes', 'icon': Icons.description_rounded,   'label': 'Historial de Reportes'},
      {'id': 'verQuejas',   'icon': Icons.forum_rounded,         'label': 'Historial de Quejas'},
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
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
      case 'enviarQueja': return _buildEnviarQuejaView();
      case 'verReportes': return _buildVerReportesView();
      case 'verQuejas':   return _buildVerQuejasView();
      default:            return _buildDashboard();
    }
  }

  // ─────────────────────────────────────────────
  //  1. DASHBOARD
  // ─────────────────────────────────────────────
  Widget _buildDashboard() {
    final cards = [
      {
        'title': 'Reportes del Estudiante',
        'count': _reportes.length,
        'icon': Icons.assignment_outlined,
        'view': 'verReportes',
      },
      {
        'title': 'Quejas Enviadas',
        'count': _quejas.length,
        'icon': Icons.forum_outlined,
        'view': 'verQuejas',
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
                Text('Bienvenido al Panel del Acudiente',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15, color: kText)),
                SizedBox(height: 8),
                Text(
                  'Desde aquí puedes consultar los reportes del estudiante y enviar quejas fácilmente.',
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
                          color: Colors.white70,
                          fontSize: 11, height: 1.3)),
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
  //  2. ENVIAR QUEJA
  // ─────────────────────────────────────────────
  Widget _buildEnviarQuejaView() {
    final nombreC      = TextEditingController();
    final codigoC      = TextEditingController();
    final asuntoC      = TextEditingController();
    final descripcionC = TextEditingController();
    String? destinatario;
    final formKey      = GlobalKey<FormState>();
    final destinos     = ['Dirección', 'Coordinación', 'Docente'];

    return StatefulBuilder(
      builder: (ctx, setS) => SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Enviar Queja'),
            const SizedBox(height: 16),
            _infoCard(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nombre del acudiente
                    _fieldLabel('Nombre del acudiente *'),
                    _textFormField(
                      nombreC,
                      'Ingrese su nombre completo',
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Campo requerido'
                          : null,
                    ),

                    // Código del estudiante
                    _fieldLabel('Código del estudiante *'),
                    _textFormField(
                      codigoC,
                      'Código del estudiante',
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Campo requerido'
                          : null,
                    ),

                    // Destinatario
                    _fieldLabel('Destinatario *'),
                    _dropdownFormField(
                      value: destinatario,
                      items: destinos,
                      hint: 'Seleccione un destinatario',
                      onChanged: (v) => setS(() => destinatario = v),
                      validator: (v) =>
                          v == null ? 'Campo requerido' : null,
                    ),

                    // Asunto
                    _fieldLabel('Asunto *'),
                    _textFormField(
                      asuntoC,
                      'Asunto de la queja',
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Campo requerido'
                          : null,
                    ),

                    // Descripción
                    _fieldLabel('Descripción *'),
                    _textAreaFormField(
                      descripcionC,
                      'Escriba su queja aquí...',
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Campo requerido'
                          : null,
                    ),

                    const SizedBox(height: 12),
                    _gradientButton(
                      label: 'Enviar Queja',
                      icon: Icons.send_rounded,
                      onTap: () {
                        if (!formKey.currentState!.validate()) return;
                        final queja = {
                          'nombre': nombreC.text.trim(),
                          'codigoEstudiante': codigoC.text.trim(),
                          'destinatario': destinatario ?? '',
                          'asunto': asuntoC.text.trim(),
                          'descripcion': descripcionC.text.trim(),
                          'fecha': DateTime.now()
                              .toIso8601String()
                              .split('T')[0],
                          'estado': 'Pendiente',
                        };
                        setState(() => _quejas.add(queja));
                        _snack('✅ La queja ha sido enviada correctamente.');
                        nombreC.clear();
                        codigoC.clear();
                        asuntoC.clear();
                        descripcionC.clear();
                        setS(() => destinatario = null);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  3. VER REPORTES
  // ─────────────────────────────────────────────
  Widget _buildVerReportesView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Historial de Reportes'),
          const SizedBox(height: 16),
          _reportes.isEmpty
              ? _emptyState(
                  'No hay reportes registrados para el estudiante.')
              : Column(
                  children: _reportes
                      .map((r) => _reporteCard(r))
                      .toList(),
                ),
        ],
      ),
    );
  }

  Widget _reporteCard(Map<String, dynamic> r) {
    final resuelto = r['estado'] == 'resuelto';
    return _infoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  r['motivo'] ?? '',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14, color: kText),
                ),
              ),
              _badge(
                resuelto ? 'Resuelto' : 'Pendiente',
                resuelto ? kSuccess : kWarning,
              ),
            ],
          ),
          const SizedBox(height: 6),
          _detailRow('Fecha', r['fecha'] ?? ''),
          _detailRow('Docente', r['docente'] ?? ''),
          _detailRow('Acción', r['accion'] ?? ''),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  4. VER QUEJAS (HISTORIAL)
  // ─────────────────────────────────────────────
  Widget _buildVerQuejasView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Historial de Quejas'),
          const SizedBox(height: 16),
          _quejas.isEmpty
              ? _emptyState('No has enviado ninguna queja aún.')
              : Column(
                  children: _quejas
                      .map((q) => _quejaCard(q))
                      .toList(),
                ),
        ],
      ),
    );
  }

  Widget _quejaCard(Map<String, dynamic> q) {
    final resuelta = q['estado'] == 'Resuelta';
    return _infoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  q['asunto'] ?? '',
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
          _detailRow('Fecha', q['fecha'] ?? ''),
          _detailRow('Destinatario', q['destinatario'] ?? ''),
          _detailRow('Descripción', q['descripcion'] ?? ''),
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
          child: Column(
            children: [
              const Icon(Icons.inbox_rounded, color: kMuted, size: 48),
              const SizedBox(height: 10),
              Text(msg,
                  style: const TextStyle(color: kMuted, fontSize: 14)),
            ],
          ),
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
                  style:
                      const TextStyle(fontSize: 12, color: kText)),
            ),
          ],
        ),
      );
}