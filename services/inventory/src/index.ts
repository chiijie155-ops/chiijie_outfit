import express from 'express';

const app = express();
app.use(express.json());

app.get('/healthz', (_req, res) => {
  res.status(200).send('inventory service healthy');
});

app.get('/api/v1/inventory/:variantId', (req, res) => {
  res.json({ message: `stub inventory endpoint for ${req.params.variantId}` });
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Inventory Service listening on port ${port}`);
});
