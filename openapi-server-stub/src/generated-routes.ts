import { Router, Request, Response } from 'express';
const router = Router();

router.post('/auth/login', (req: Request, res: Response) => {
  res.json({
    path: '/auth/login',
    method: 'POST',
    summary: 'Login user and return access token',
    params: req.params,
    query: req.query,
    body: req.body
  });
});

router.get('/products', (req: Request, res: Response) => {
  res.json({
    path: '/products',
    method: 'GET',
    summary: 'List products',
    params: req.params,
    query: req.query,
    body: req.body
  });
});

router.get('/products/:productId', (req: Request, res: Response) => {
  res.json({
    path: '/products/{productId}',
    method: 'GET',
    summary: 'Get product detail',
    params: req.params,
    query: req.query,
    body: req.body
  });
});

router.get('/inventory/:variantId', (req: Request, res: Response) => {
  res.json({
    path: '/inventory/{variantId}',
    method: 'GET',
    summary: 'Retrieve inventory snapshot',
    params: req.params,
    query: req.query,
    body: req.body
  });
});

router.post('/orders', (req: Request, res: Response) => {
  res.json({
    path: '/orders',
    method: 'POST',
    summary: 'Create a new order',
    params: req.params,
    query: req.query,
    body: req.body
  });
});

router.get('/orders/:orderId', (req: Request, res: Response) => {
  res.json({
    path: '/orders/{orderId}',
    method: 'GET',
    summary: 'Retrieve order detail',
    params: req.params,
    query: req.query,
    body: req.body
  });
});

router.post('/payments/create', (req: Request, res: Response) => {
  res.json({
    path: '/payments/create',
    method: 'POST',
    summary: 'Create a payment intent',
    params: req.params,
    query: req.query,
    body: req.body
  });
});

router.post('/payments/webhook', (req: Request, res: Response) => {
  res.json({
    path: '/payments/webhook',
    method: 'POST',
    summary: 'Payment gateway webhook endpoint',
    params: req.params,
    query: req.query,
    body: req.body
  });
});

router.post('/notifications/email', (req: Request, res: Response) => {
  res.json({
    path: '/notifications/email',
    method: 'POST',
    summary: 'Send transactional email',
    params: req.params,
    query: req.query,
    body: req.body
  });
});

export default router;