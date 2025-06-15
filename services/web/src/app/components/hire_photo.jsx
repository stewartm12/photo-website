"use client";

import { imageLoader } from "@/lib/image-loader";
import Image from "next/image";

export default function HirePhoto({imgSrc, altText}) {
  return (
    <Image
      src={imgSrc}
      alt={altText}
      className="object-cover rounded-lg shadow-lg relative z-10"
      width={600}
      height={600}
    />
  )
}