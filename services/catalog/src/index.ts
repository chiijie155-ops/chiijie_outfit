import express from 'express';

const app = express();
app.use(express.json());

app.get('/healthz', (_req, res) => {
  res.status(200).send('catalog service healthy');
});

app.get('/api/v1/products', (_req, res) => {
  res.json({ message: 'stub product listing endpoint' });
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Catalog Service listening on port ${port}`);
});
