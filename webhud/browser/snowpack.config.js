/*
 * Copyright (C) 2020 Garrett Brown
 * This file is part of the beachfronter repo - https://github.com/eigendude/beachfronter
 *
 * SPDX-License-Identifier: Apache-2.0
 * See the file LICENSE.txt for more information.
 */

/* eslint @typescript-eslint/no-var-requires: "off" */

const globals = require("rollup-plugin-node-globals");
const polyfills = require("rollup-plugin-node-polyfills");
const resolve = require("@rollup/plugin-node-resolve").nodeResolve;

module.exports = {
  scripts: {
    "mount:public": "mount public --to /",
    "mount:src": "mount src --to /_dist_",
  },
  devOptions: {
    bundle: false,
  },
  buildOptions: {
    minify: false,
  },
  plugins: ["@snowpack/plugin-typescript"],
  install: [],
  installOptions: {
    sourceMap: true,
    treeshake: true,
    rollup: {
      plugins: [
        // Fix "Uncaught TypeError: bufferEs6.hasOwnProperty is not a function"
        resolve({ preferBuiltins: false }),
        globals(),
        polyfills(),
      ],
    },
  },
};
