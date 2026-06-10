import express from 'express';

const app = express();
app.use(express.json());

app.get('/healthz', (_req, res) => {
  res.status(200).send('microservice template healthy');
});

app.get('/api/v1/ping', (_req, res) => {
  res.json({ message: 'pong' });
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Microservice Template listening on port ${port}`);
});
