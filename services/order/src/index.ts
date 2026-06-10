import express from 'express';

const app = express();
app.use(express.json());

app.get('/healthz', (_req, res) => {
  res.status(200).send('order service healthy');
});

app.post('/api/v1/orders', (_req, res) => {
  res.status(201).json({ message: 'stub create order endpoint' });
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Order Service listening on port ${port}`);
});
