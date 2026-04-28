
(function () {

  const container = document.createElement("div");
  container.id = "toast-container";
  Object.assign(container.style, {
    position: "fixed", top: "20px", right: "20px",
    zIndex: "9999", display: "flex", flexDirection: "column", gap: "10px",
    maxWidth: "340px", width: "100%"
  });
  document.body.appendChild(container);

  const colors = {
    success: { bg: "#d1fae5", border: "#10b981", icon: "✅" },
    error:   { bg: "#fee2e2", border: "#ef4444", icon: "❌" },
    warning: { bg: "#fef9c3", border: "#f59e0b", icon: "⚠️" },
    info:    { bg: "#dbeafe", border: "#3b82f6", icon: "ℹ️" },
  };

  window.showToast = function (message, type = "success", duration = 3500) {
    const c = colors[type] || colors.info;
    const toast = document.createElement("div");
    Object.assign(toast.style, {
      background: c.bg,
      border: `1px solid ${c.border}`,
      borderRadius: "10px",
      padding: "14px 16px",
      fontSize: "14px",
      color: "#1e293b",
      display: "flex",
      alignItems: "center",
      gap: "10px",
      boxShadow: "0 4px 12px rgba(0,0,0,0.1)",
      animation: "toastIn 0.25s ease",
      transition: "opacity 0.3s ease",
    });
    toast.innerHTML = `<span>${c.icon}</span><span style="flex:1">${message}</span>
      <button onclick="this.parentElement.remove()" style="background:none;border:none;cursor:pointer;font-size:16px;color:#64748b;padding:0">×</button>`;
    container.appendChild(toast);
    setTimeout(() => {
      toast.style.opacity = "0";
      setTimeout(() => toast.remove(), 300);
    }, duration);
  };

  window.showConfirm = function (message) {
    return new Promise((resolve) => {
      const overlay = document.createElement("div");
      Object.assign(overlay.style, {
        position: "fixed", inset: "0", background: "rgba(0,0,0,0.4)",
        zIndex: "10000", display: "flex", alignItems: "center", justifyContent: "center"
      });
      overlay.innerHTML = `
        <div style="background:#fff;border-radius:14px;padding:28px 32px;max-width:380px;width:90%;box-shadow:0 8px 30px rgba(0,0,0,0.18)">
          <p style="margin:0 0 20px;font-size:15px;color:#1e293b">${message}</p>
          <div style="display:flex;gap:10px;justify-content:flex-end">
            <button id="confirm-no"  style="padding:8px 20px;border-radius:8px;border:1px solid #e2e8f0;background:#f8fafc;cursor:pointer;font-size:14px">Cancelar</button>
            <button id="confirm-yes" style="padding:8px 20px;border-radius:8px;border:none;background:#ef4444;color:white;cursor:pointer;font-size:14px;font-weight:500">Confirmar</button>
          </div>
        </div>`;
      document.body.appendChild(overlay);
      overlay.querySelector("#confirm-yes").onclick = () => { overlay.remove(); resolve(true); };
      overlay.querySelector("#confirm-no").onclick  = () => { overlay.remove(); resolve(false); };
    });
  };


  const style = document.createElement("style");
  style.textContent = `@keyframes toastIn { from { opacity:0; transform:translateX(30px); } to { opacity:1; transform:translateX(0); } }`;
  document.head.appendChild(style);
})();
