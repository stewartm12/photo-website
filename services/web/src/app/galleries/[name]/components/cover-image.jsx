"use client";

import { imageLoader } from "@/lib/image-loader";
import Image from "next/image";

export default function CoverImage({ coverPhoto, gallery }) {
  return (
    <section className="relative h-[50vh] md:h-[60vh]">
      <Image
        src={coverPhoto.imageUrl}
        alt={`${coverPhoto.altText} - Featured Photo`}
        fill
        priority
        className="object-cover object-top"
      />
      <div className="absolute inset-0 bg-black/30 flex items-center">
        <div className="text-center px-4 py-8 bg-white/10 rounded-lg mx-auto">
          <h1 className="text-4xl sm:text-5xl font-bold mb-4 text-white">{gallery.name}</h1>
          <p className="text-xl sm:text-2xl text-white/90 mx-auto">{gallery.description}</p>
        </div>
      </div>
    </section>
  );
};
