# SQL Migrations

This folder contains PostgreSQL migration scripts for the e-commerce platform.

## Usage
- `001_initial_schema.sql`: initial schema for users, products, inventory, orders, payments, and invoices.

## Recommended workflow
1. Keep each migration file immutable once applied in production.
2. Use a migration runner such as `Flyway`, `Liquibase`, or a custom Node.js migration script.
3. Execute migrations in order using the filename prefix.
