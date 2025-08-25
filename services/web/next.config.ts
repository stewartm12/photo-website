import type { NextConfig } from "next";

/** @type {import('next').NextConfig} */
const nextConfig: NextConfig = {
  output: 'standalone',
  images: {
    unoptimized: false,
		remotePatterns: [
			{
        protocol: 'http',
        hostname: 'localhost',
        port: '3001',
        pathname: '/rails/**',
      },
      {
        protocol: 'https',
        hostname: 'pix-cloud-staging-e3a3287b0eb9.herokuapp.com',
        pathname: '/rails/**',
      },
      {
        protocol: "https",
        hostname: "pics-cloud.com", // production Rails
        pathname: "/rails/**",
      }
		],
	},
};

export default nextConfig;
