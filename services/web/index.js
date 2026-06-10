const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());

app.get('/health', (req, res) => {
  res.json({ status: 'ok', service: 'web' });
});

app.get('/api/products', async (req, res) => {
  const catalogUrl = process.env.CATALOG_URL || 'http://catalog:3000/api/v1/products';
  try {
    const response = await fetch(catalogUrl, { method: 'GET' });
    if (!response.ok) throw new Error('upstream_error');
    const data = await response.json();
    return res.json(data);
  } catch (err) {
    // Fallback to static list when catalog service is unavailable
    return res.json([
      { id: 1, name: 'Slim Fit Shirt', price: 29.99 },
      { id: 2, name: 'Denim Jeans', price: 49.99 },
      { id: 3, name: 'Sneakers', price: 79.99 }
    ]);
  }
});

app.post('/api/checkout', (req, res) => {
  const { cart } = req.body || {};
  if (!cart || !Array.isArray(cart)) {
    return res.status(400).json({ error: 'invalid_cart' });
  }
  // Placeholder checkout flow — in production integrate with order/payment services
  return res.json({ success: true, order_id: `order_${Date.now()}` });
});

app.get('/', (req, res) => {
  res.send(`
    <html>
      <head><title>Chiijie Outfit</title></head>
      <body>
        <h1>Welcome to Chiijie Outfit (Demo)</h1>
        <p>API endpoints: <a href="/api/products">/api/products</a>, <a href="/health">/health</a></p>
      </body>
    </html>
  `);
});

app.listen(port, () => {
  console.log(`Web service listening on port ${port}`);
});
