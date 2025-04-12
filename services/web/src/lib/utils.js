import { clsx } from "clsx";
import { twMerge } from "tailwind-merge"

export function cn(...inputs) {
  return twMerge(clsx(inputs));
}

export function filterPhotosBySection(photos, key) {
  return photos.filter((p) => p.sectionKey === key).sort((a, b) => a.position - b.position);
}

export function formatPrice(price) {
  const numericPrice = parseFloat(price);
  return (numericPrice % 1 === 0 ? numericPrice.toFixed(0) : numericPrice.toFixed(2));
};