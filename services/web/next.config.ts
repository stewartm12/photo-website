import type { NextConfig } from "next";

/** @type {import('next').NextConfig} */
const nextConfig: NextConfig = {
  output: 'standalone',
  images: {
    unoptimized: process.env.NODE_ENV === "development" ? true : false,
		remotePatterns: [
			{
        protocol: 'http',
        hostname: 'localhost',
        port: '3001',
        pathname: '/rails/**',
      }
		],
	},
};

export default nextConfig;
