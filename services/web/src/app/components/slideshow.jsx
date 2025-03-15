"use client";

import { useState, useEffect, useRef } from "react";
import NextImage from 'next/image';
import { cn } from "@/lib/utils";

export default function Slideshow({ photos }) {
  const [currentIndex, setCurrentIndex] = useState(0);
  const [isVisible, setIsVisible] = useState(true);
  const slideShowRef = useRef(null);

  const imageLoader = ({ src, width, quality }) => {
    return `${process.env.NEXT_PUBLIC_AWS_S3_URL}/${src}?w=${width}&q=${quality || 100}`
  }

  // Set up intersection observer to detect when slideshow is in view
  useEffect(() => {
    const observer = new IntersectionObserver(
      ([entry]) => {
        setIsVisible(entry.isIntersecting)
      },
      { threshold: 0.1 } // Trigger when at least 10% of the element is visible
    )

    if (slideShowRef.current) {
      observer.observe(slideShowRef.current)
    }

    return () => {
      if (slideShowRef.current) {
        observer.unobserve(slideShowRef.current)
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

  if (photos.length === 0) {
    return null
  }

  return (
    <div className="relative w-full h-[900px]" ref={slideShowRef}>
      {photos.map((photo, index) => (
        <div
          key={photo.id}
          className={cn("absolute w-full h-full transition-opacity duration-1000", index === currentIndex ? "opacity-100" : "opacity-0")}
          style={{ willChange: "opacity" }}
        >
          <NextImage
            src={photo.fileKey}
            alt={photo.altText}
            loader={imageLoader}
            className="absolute inset-0 w-full h-full object-cover"
            priority={index === 0}
            quality={100}
            fill
            sizes="100vw"
          />
        </div>
      ))}
    </div>
  )
};
