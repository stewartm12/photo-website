import withPlaiceholder from "@plaiceholder/next";

/** @type {import('next').NextConfig} */
const bucketName = process.env.NEXT_PUBLIC_AWS_BUCKET_NAME;
const region = process.env.NEXT_PUBLIC_AWS_REGION;

const nextConfig = {
  output: 'standalone',
  images: {
		remotePatterns: [
			{
				protocol: 'https',
				hostname: `${bucketName}.s3.${region}.amazonaws.com`,
			},
		],
	},
};

export default withPlaiceholder(nextConfig);
