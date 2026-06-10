import express from 'express';

const app = express();
app.use(express.json());

app.get('/healthz', (_req, res) => {
  res.status(200).send('notification service healthy');
});

app.post('/api/v1/notifications/email', (_req, res) => {
  res.status(202).json({ message: 'stub notification email endpoint' });
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`Notification Service listening on port ${port}`);
});
