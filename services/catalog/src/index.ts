import express from 'express';

const app = express();
app.use(express.json());

app.get('/healthz', (_req, res) => {
  res.status(200).send('catalog service healthy');
});

app.get('/api/v1/products', (_req, res) => {
  res.json([
    { id: 1, name: 'Slim Fit Shirt', price: 29.99, sku: 'SHIRT-001' },
    { id: 2, name: 'Denim Jeans', price: 49.99, sku: 'JEANS-002' },
    { id: 3, name: 'Sneakers', price: 79.99, sku: 'SHOES-003' }
  ]);
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Catalog Service listening on port ${port}`);
});
