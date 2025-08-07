"use client";

import dynamic from "next/dynamic";
import type { Photo } from "@/types/photo";
import LargeImageFallback from "@/components/fallback/large-image-fallback";

const Slideshow = dynamic(() => import("@/app/root-components/slideshow"), {
  ssr: false,
  loading: () => <LargeImageFallback />,
});

export default function SlideshowWrapper({ photos }: { photos: Photo[] }) {
  return <Slideshow photos={photos} />;
}
