import withPlaiceholder from "@plaiceholder/next";

/** @type {import('next').NextConfig} */
const bucketName = process.env.NEXT_PUBLIC_AWS_BUCKET_NAME;
const region = process.env.NEXT_PUBLIC_AWS_REGION;

const nextConfig = {
  output: 'standalone',
  images: {
		unoptimized: true,
		remotePatterns: [
			{
				protocol: 'https',
				hostname: `${bucketName}.s3.${region}.amazonaws.com`,
			},
			{
        protocol: 'http',
        hostname: 'localhost',
        port: '3001',
        pathname: '/rails/active_storage/**',
      }
		],
	},
};

export default withPlaiceholder(nextConfig);
