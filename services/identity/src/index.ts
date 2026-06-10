import express from 'express';

const app = express();
app.use(express.json());

app.get('/healthz', (_req, res) => {
  res.status(200).send('identity service healthy');
});

app.get('/api/v1/users/me', (_req, res) => {
  res.json({ message: 'stub identity profile endpoint' });
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Identity Service listening on port ${port}`);
});
