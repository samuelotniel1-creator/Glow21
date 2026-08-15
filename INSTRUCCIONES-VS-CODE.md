# 🌸 Glow21 Landing - Instrucciones VS Code + Claude Code

## Setup Rápido

### 1. Crear estructura de proyecto
```bash
# En tu terminal de VS Code:
mkdir glow21-landing
cd glow21-landing

# Crear carpetas
mkdir public
mkdir admin
```

### 2. Copiar archivos

**Archivo 1:** `public/index.html`
- Copia el contenido de `glow21-landing-index.html`
- Pégalo en `public/index.html`

**Archivo 2:** `admin/index.html`
- Copia el contenido de `glow21-landing-admin.html`
- Pégalo en `admin/index.html`

---

## Estructura Final

```
glow21-landing/
├── public/
│   └── index.html (landing principal)
├── admin/
│   └── index.html (panel de control)
└── package.json (si usas Node)
```

---

## Cómo usar en VS Code

### Opción A: Live Server (MÁS SIMPLE)

1. **Instala extensión:**
   - Abre VS Code
   - Extensions (Ctrl+Shift+X)
   - Busca "Live Server"
   - Instala de Ritwick Dey

2. **Ejecuta:**
   - Click derecho en `public/index.html`
   - "Open with Live Server"
   - Se abre en `http://localhost:5500`

3. **Accede:**
   - Landing: `http://localhost:5500`
   - Admin: `http://localhost:5500/../admin/`

### Opción B: Node + Express (RECOMENDADO)

1. **Crea `server.js` en raíz:**

```javascript
const express = require('express');
const path = require('path');
const app = express();
const PORT = 3000;

app.use(express.static('public'));

app.get('/admin', (req, res) => {
  res.sendFile(path.join(__dirname, 'admin', 'index.html'));
});

app.listen(PORT, () => {
  console.log(`🌸 Glow21 landing en http://localhost:${PORT}`);
});
```

2. **Terminal:**
```bash
npm init -y
npm install express
node server.js
```

3. **Accede:**
   - Landing: `http://localhost:3000`
   - Admin: `http://localhost:3000/admin`

---

## Usar con Claude Code

### Prompt para Claude Code:

```
Tengo una landing de Glow21 (masterclass con Zoom en vivo).

Archivos:
- public/index.html (landing)
- admin/index.html (admin panel)

Necesito que:
1. Revises el código
2. Optimices la experiencia visual
3. Agregues transiciones suaves
4. Mejores el responsive en móvil
5. [Lo que necesites]

Usa el vibe de Polímata pero con colores Glow21.
```

---

## Testing Admin Panel

1. Abre Admin: `http://localhost:3000/admin` (o 5500)

2. Llena:
   - **Zoom ID:** `123456789` (tu meeting ID real)
   - **Botón Compra:** Activa el toggle

3. Guarda

4. Vuelve a landing: verás el Zoom cargado

---

## URLs importantes

| Sección | URL |
|---------|-----|
| Landing | `http://localhost:3000` |
| Admin | `http://localhost:3000/admin` |
| Zoom Config | Admin panel |
| Modal Test | Consola: `testModal()` |

---

## Testing del Modal

Abre consola (F12) y escribe:
```javascript
testModal()
```

Aparecerá el modal CTA para que verifiques el diseño.

---

## Variables de Configuración (localStorage)

El sistema guarda en **localStorage** del navegador:

```javascript
// Zoom ID
localStorage.getItem('glow21_zoom_id')

// Botón Premium activo
localStorage.getItem('glow21_boton_compra')
```

Puedes limpiar en consola (F12):
```javascript
localStorage.clear()
```

---

## Próximos Pasos

Cuando esté listo:

1. **Integra Supabase:**
   - Email capture para Free
   - CRM de datos
   - Webhook de Stripe

2. **Deploy:**
   - Vercel (recomendado para Node)
   - Netlify (para solo HTML)
   - AWS/Azure

3. **SSL + Dominio:**
   - Tu dominio en DNS
   - Certificate HTTPS

---

## Notas

✅ **Colores Glow21 integrados:**
- Blanco Perla: `#FDFBF7`
- Gris Pizarra: `#2C3539`
- Oro Champaña: `#E5C4A3`
- Rosa Cuarzo: `#F4DCD6`

✅ **Tipografía:**
- Serif (Georgia) para títulos elegantes
- Sans limpia para cuerpo

✅ **Zoom dinámico:**
- Cambia en admin sin tocar código
- localStorage persiste entre sesiones

✅ **Modal simplificado:**
- Botón Premium + Link Free
- Sin formulario desplegado

---

¿Necesitas algo más? Pregunta en Claude Code. 🌸
