"use client";

import dynamic from "next/dynamic";
import type { Photo } from "@/types/photo";
import type { Gallery } from "@/types/gallery";
import LargeImageFallback from "@/components/fallback/large-image-fallback";

const HeroImage = dynamic(() => import("@/app/galleries/[name]/components/hero-image"), {
  ssr: false,
  loading: () => <LargeImageFallback />,
});

type DefaultMessage = {
  title: string;
  message: string;
}


type HeroImageWrapperProps = {
  photo: Photo;
  gallery?: Gallery;
  defaultInfo?: DefaultMessage;
}

export default function HeroImageWrapper({ photo, gallery, defaultInfo }: HeroImageWrapperProps) {
  return <HeroImage photo={photo} gallery={gallery} defaultInfo={defaultInfo} />;
}
