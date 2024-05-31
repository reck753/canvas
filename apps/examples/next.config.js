/** @type {import('next').NextConfig} */
const withBundleAnalyzer = require("@next/bundle-analyzer")({
  enabled: process.env.ANALYZE === "true",
});

const plugins = [withBundleAnalyzer];

const nextConfig = {
  reactStrictMode: false,
  transpilePackages: [
    "@canvas/canvas",
    "@ryyppy/rescript-promise",
    "@rescript/core",
  ],
  experimental: {
    // optimizeCss: true,
    scrollRestoration: true,
  },
};

const nextConfigWithAppliedPlugins = plugins.reduce(
  (acc, next) => next(acc),
  nextConfig
);

module.exports = nextConfigWithAppliedPlugins;
