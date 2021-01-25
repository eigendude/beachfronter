/*
 * Copyright (C) 2020 Garrett Brown
 * This file is part of the beachfronter repo - https://github.com/eigendude/beachfronter
 *
 * SPDX-License-Identifier: Apache-2.0
 * See the file LICENSE.txt for more information.
 */

module.exports = {
  root: true,
  parser: "@typescript-eslint/parser",
  plugins: ["@typescript-eslint", "simple-import-sort"],
  extends: ["eslint:recommended", "plugin:@typescript-eslint/recommended"],
  env: {
    amd: true,
    browser: true,
    es2021: true,
    node: true,
  },
  rules: {
    "simple-import-sort/imports": "error",
  },
};
