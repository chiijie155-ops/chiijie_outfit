const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());

app.get('/health', (req, res) => {
  res.json({ status: 'ok', service: 'web' });
});

app.get('/api/products', (req, res) => {
  // Sample static product list — replace with real backend calls
  res.json([
    { id: 1, name: 'Slim Fit Shirt', price: 29.99 },
    { id: 2, name: 'Denim Jeans', price: 49.99 },
    { id: 3, name: 'Sneakers', price: 79.99 }
  ]);
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
