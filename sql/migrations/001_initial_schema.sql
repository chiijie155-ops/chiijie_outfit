-- Initial schema for Chiijie Outfit enterprise e-commerce platform

CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";
CREATE EXTENSION IF NOT EXISTS "citext";

CREATE TABLE users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  email citext NOT NULL UNIQUE,
  phone text,
  password_hash text NOT NULL,
  full_name text NOT NULL,
  role text NOT NULL DEFAULT 'customer',
  status text NOT NULL DEFAULT 'active',
  meta jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_status ON users(status);

CREATE TABLE products (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  sku text NOT NULL UNIQUE,
  name text NOT NULL,
  slug text NOT NULL UNIQUE,
  description text,
  category_id uuid NOT NULL,
  brand text,
  status text NOT NULL DEFAULT 'published',
  attributes jsonb,
  metadata jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_products_slug ON products(slug);
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_status ON products(status);
CREATE INDEX idx_products_name_trgm ON products USING gin (name gin_trgm_ops);

CREATE TABLE product_variants (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  product_id uuid NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  sku text NOT NULL UNIQUE,
  variant_name text NOT NULL,
  price_cents bigint NOT NULL,
  sale_price_cents bigint,
  weight_grams int,
  dimensions jsonb,
  attributes jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_variants_product ON product_variants(product_id);
CREATE INDEX idx_variants_sku ON product_variants(sku);

CREATE TABLE inventories (
  product_variant_id uuid PRIMARY KEY REFERENCES product_variants(id),
  available_stock int NOT NULL DEFAULT 0,
  reserved_stock int NOT NULL DEFAULT 0,
  incoming_stock int NOT NULL DEFAULT 0,
  last_restocked_at timestamptz,
  version bigint NOT NULL DEFAULT 0,
  updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_inventories_available_stock ON inventories(available_stock);

CREATE TABLE orders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES users(id),
  order_number text NOT NULL UNIQUE,
  status text NOT NULL,
  payment_status text NOT NULL DEFAULT 'pending',
  total_amount_cents bigint NOT NULL,
  currency text NOT NULL DEFAULT 'IDR',
  shipping_address jsonb,
  billing_address jsonb,
  promo_code text,
  metadata jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);

CREATE TABLE order_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id uuid NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  product_variant_id uuid NOT NULL REFERENCES product_variants(id),
  quantity int NOT NULL,
  unit_price_cents bigint NOT NULL,
  total_price_cents bigint NOT NULL,
  tax_cents bigint NOT NULL DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_order_items_variant ON order_items(product_variant_id);

CREATE TABLE payments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id uuid NOT NULL REFERENCES orders(id),
  payment_gateway text NOT NULL,
  gateway_payment_id text NOT NULL,
  amount_cents bigint NOT NULL,
  currency text NOT NULL DEFAULT 'IDR',
  status text NOT NULL,
  method text NOT NULL,
  idempotency_key text,
  raw_response jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE UNIQUE INDEX idx_payments_gateway_id ON payments(gateway_payment_id);
CREATE UNIQUE INDEX idx_payments_idempotency ON payments(idempotency_key);
CREATE INDEX idx_payments_order ON payments(order_id);

CREATE TABLE invoices (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id uuid NOT NULL REFERENCES orders(id),
  invoice_number text NOT NULL UNIQUE,
  issued_at timestamptz NOT NULL DEFAULT now(),
  due_date timestamptz,
  status text NOT NULL,
  total_amount_cents bigint NOT NULL,
  invoice_pdf_url text,
  metadata jsonb
);
CREATE INDEX idx_invoices_order ON invoices(order_id);
CREATE INDEX idx_invoices_status ON invoices(status);
