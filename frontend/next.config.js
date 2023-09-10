/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  experimental: {
    appDir: true,
  },
  env: {
    PORT: process.env.PORT,
    NAME: process.env.NAME,
    LOGGER: process.env.LOGGER,
  },
};

module.exports = nextConfig;
