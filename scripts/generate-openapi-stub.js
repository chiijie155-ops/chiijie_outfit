#!/usr/bin/env node
const fs = require('fs');
const path = require('path');
const yaml = require('js-yaml');

const specPath = path.resolve(__dirname, '../openapi-draft.yaml');
const outputPath = path.resolve(__dirname, '../openapi-server-stub/src/generated-routes.ts');

const spec = yaml.load(fs.readFileSync(specPath, 'utf8'));
const paths = spec.paths || {};
const lines = [
  "import { Router, Request, Response } from 'express';",
  'const router = Router();',
  '',
];

Object.entries(paths).forEach(([rawPath, operations]) => {
  if (!operations || typeof operations !== 'object') return;
  const routePath = rawPath.replace(/\{([^}]+)\}/g, ':$1');

  Object.entries(operations).forEach(([method, operation]) => {
    const summary = operation.summary ? String(operation.summary).replace(/'/g, "\\'") : `${method.toUpperCase()} ${rawPath}`;
    lines.push(`router.${method}('${routePath}', (req: Request, res: Response) => {`);
    lines.push('  res.json({');
    lines.push(`    path: '${rawPath}',`);
    lines.push(`    method: '${method.toUpperCase()}',`);
    lines.push(`    summary: '${summary}',`);
    lines.push('    params: req.params,');
    lines.push('    query: req.query,');
    lines.push('    body: req.body');
    lines.push('  });');
    lines.push('});');
    lines.push('');
  });
});

lines.push('export default router;');
fs.writeFileSync(outputPath, lines.join('\n'));
console.log('Generated OpenAPI stub routes at', outputPath);
