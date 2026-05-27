#!/usr/bin/env node
/**
 * Remove dependency version ranges from node_modules package.json files.
 * Trivy image scans can treat those ranges as installed versions (false positives).
 */
const fs = require('fs');
const path = require('path');

const root = path.join(__dirname, '..', 'node_modules');
if (!fs.existsSync(root)) {
  process.exit(0);
}

const keys = [
  'dependencies',
  'devDependencies',
  'optionalDependencies',
  'peerDependencies',
  'bundledDependencies',
];

function strip(file) {
  const json = JSON.parse(fs.readFileSync(file, 'utf8'));
  let changed = false;
  for (const key of keys) {
    if (json[key]) {
      delete json[key];
      changed = true;
    }
  }
  if (changed) {
    fs.writeFileSync(file, JSON.stringify(json));
  }
}

function walk(dir) {
  for (const name of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, name.name);
    if (name.isDirectory()) {
      walk(full);
    } else if (name.name === 'package.json') {
      strip(full);
    }
  }
}

walk(root);
