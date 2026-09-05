const express = require('express');
const path = require('path');
const app = express();
const PORT = process.env.PORT || 3000;
// Nota: cambio trivial para forzar que Vercel reconstruya esta función
// (producción se había quedado sirviendo una versión vieja que no
// reconocía la ruta /preregistro pese a que este archivo sí la tiene).

// El webhook de Stripe necesita el cuerpo crudo (sin parsear) para
// verificar la firma, así que se monta antes que express.json().
app.post('/api/stripe-webhook', require('./api/stripe-webhook'));

// Middleware
app.use(express.static('public'));
app.use('/admin', express.static('admin'));
app.use('/crm', express.static('crm'));
app.use(express.json());

// Routes
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.get('/admin', (req, res) => {
  res.sendFile(path.join(__dirname, 'admin', 'index.html'));
});

app.get('/crm', (req, res) => {
  res.sendFile(path.join(__dirname, 'crm', 'index.html'));
});

app.get('/preregistro', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'preregistro.html'));
});

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date() });
});

// Error handling
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Something went wrong!' });
});

// 404
app.use((req, res) => {
  res.status(404).json({ error: 'Page not found' });
});

// Start server
app.listen(PORT, () => {
  console.log(`\n🌸 Glow21 Landing en http://localhost:${PORT}`);
  console.log(`📱 Admin en http://localhost:${PORT}/admin`);
  console.log(`\n💡 Presiona Ctrl+C para detener\n`);
});
