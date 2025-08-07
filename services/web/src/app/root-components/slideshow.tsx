"use client";

import type { Photo } from "@/types/photo";
import { useState, useEffect, useRef } from "react";
import { cn } from "@/lib/utils";
import NextImage from 'next/image';
import LargeImageFallback from "@/components/fallback/large-image-fallback";

export default function Slideshow({ photos }: { photos: Photo[] }) {
  const [currentIndex, setCurrentIndex] = useState<number>(0);
  const [isVisible, setIsVisible] = useState<boolean>(true);
  const slideShowRef = useRef<HTMLDivElement | null>(null);

  // Set up intersection observer to detect when slideshow is in view
  useEffect(() => {
    const slideshowNode = slideShowRef.current;

    const observer = new IntersectionObserver(
      ([entry]: IntersectionObserverEntry[]) => {
        setIsVisible(entry.isIntersecting)
      },
      { threshold: 0.1 } // Trigger when at least 10% of the element is visible
    )

    if (slideshowNode) {
      observer.observe(slideshowNode)
    }

    return () => {
      if (slideshowNode) {
        observer.unobserve(slideshowNode)
      }
    }
  }, [])

  // Auto-advance slides only when visible
  useEffect(() => {
    if (!isVisible || photos.length === 0) return

    const timer = setInterval(() => {
      setCurrentIndex((prevIndex) => (prevIndex + 1) % photos.length)
    }, 5000)

    return () => clearInterval(timer)
  }, [isVisible, photos])

  if (photos.length == 0) {
    return <LargeImageFallback />
  }

  return (
    <main className="relative w-full h-[60vh] min-h-[830px] max-h-[900px]" ref={slideShowRef}>
      {photos.map((photo, index) => (
        <div
          key={photo.id}
          className={cn("absolute w-full h-full transition-opacity duration-1000",
            index === currentIndex ? "opacity-100" : "opacity-0")}
          style={{ willChange: "opacity" }}
        >
          <NextImage
            src={photo.imageUrl}
            alt={photo.altText}
            className="absolute inset-0 w-full h-full object-cover"
            quality={75}
            fill
            sizes="100vw"
          />
        </div>
      ))}
    </main>
  );
};
