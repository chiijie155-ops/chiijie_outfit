import express from 'express';

const app = express();
app.use(express.json());

app.get('/healthz', (_req, res) => {
  res.status(200).send('payment service healthy');
});

app.post('/api/v1/payments/create', (_req, res) => {
  res.status(201).json({ message: 'stub payment create endpoint' });
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Payment Service listening on port ${port}`);
});
