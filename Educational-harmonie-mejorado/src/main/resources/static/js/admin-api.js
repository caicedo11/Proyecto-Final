

const AdminAPI = {


  async listarUsuarios() {
    const res = await fetch("/admin/usuarios/listar");
    if (!res.ok) throw new Error("Error al cargar usuarios");
    return res.json();
  },

  async crearUsuario(data) {
    const res = await fetch("/admin/usuarios/crear-directo", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(data),
    });
    return res.json();
  },

  async eliminarUsuario(id) {
    const res = await fetch(`/admin/usuarios/eliminar/${id}`, { method: "DELETE" });
    return res.json();
  },



  async listarEstudiantes() {
    const res = await fetch("/admin/estudiantes/listar");
    if (!res.ok) throw new Error("Error al cargar estudiantes");
    return res.json();
  },

  async crearEstudiante(data) {
    const res = await fetch("/admin/estudiantes/crear", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(data),
    });
    return res.json();
  },

  async eliminarEstudiante(id) {
    const res = await fetch(`/admin/estudiantes/eliminar/${id}`, { method: "DELETE" });
    return res.json();
  },

  

  async listarInvitaciones() {
    const res = await fetch("/admin/invitaciones/listar");
    if (!res.ok) throw new Error("Error al cargar invitaciones");
    return res.json();
  },

  async generarInvitacion(correo, rol, horas) {
    const res = await fetch("/admin/invitaciones/generar", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: new URLSearchParams({ correo, rol, horas }),
    });
    return res.json();
  },

  async eliminarInvitacion(id) {
    const res = await fetch(`/admin/invitaciones/eliminar/${id}`, { method: "DELETE" });
    return res.json();
  },



  async listarPendientes() {
    const res = await fetch("/admin/pendientes/listar");
    if (!res.ok) throw new Error("Error al cargar pendientes");
    return res.json();
  },

  async obtenerDetallesPendiente(id) {
    const res = await fetch(`/admin/pendientes/detalles/${id}`);
    if (!res.ok) throw new Error("Registro no encontrado");
    return res.json();
  },

  async aprobarRegistro(id, usuario, password) {
    const res = await fetch(`/admin/pendientes/aprobar/${id}`, {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: new URLSearchParams({ usuario, password }),
    });
    return res.json();
  },

  async rechazarRegistro(id) {
    const res = await fetch(`/admin/pendientes/rechazar/${id}`, { method: "POST" });
    return res.json();
  },



  async enviarNotificacion(data) {
    const res = await fetch("/admin/notificaciones/enviar", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(data),
    });
    return res.json();
  },
};
