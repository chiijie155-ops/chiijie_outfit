import express from 'express';
import generatedRoutes from './generated-routes';

const app = express();
app.use(express.json());
app.use('/', generatedRoutes);

app.get('/healthz', (_req, res) => {
  res.status(200).send('OpenAPI Stub Server healthy');
});

const port = Number(process.env.PORT || 3000);
app.listen(port, () => {
  console.log(`OpenAPI Stub Server running on port ${port}`);
});
