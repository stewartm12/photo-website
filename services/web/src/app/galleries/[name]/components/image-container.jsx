"use client";

import { useState, useEffect } from "react";
import { imageLoader } from "@/lib/image-loader";
import NextImage from "next/image";

export default function ImageContainer({ photo }) {
  const [naturalWidth, setNaturalWidth] = useState(0);
  const [naturalHeight, setNaturalHeight] = useState(0);
  const [photoSpans, setPhotoSpans] = useState(1);

  useEffect(() => {
    if (naturalWidth && naturalHeight) {
      const widthHeightRatio = naturalHeight / naturalWidth;
      const calculatedGalleryHeight = Math.ceil(250 * widthHeightRatio);
      const calculatedPhotoSpans = Math.ceil(calculatedGalleryHeight / 10) + 1;
      setPhotoSpans(calculatedPhotoSpans);
    }
  }, [naturalWidth, naturalHeight]);

  return (
    <div className="w-full justify-self-center" style={{gridRow: `span ${photoSpans}`}}>
        <NextImage
          src={photo.imageUrl}
          alt={photo.altText}
          width={0}
          height={250}
          sizes="250px"
          onLoad={({ target }) => {
            const { naturalWidth, naturalHeight } = target;
            setNaturalWidth(naturalWidth);
            setNaturalHeight(naturalHeight);
          }}
          className="w-full h-auto object-cover"
        />
    </div>
  );
};
