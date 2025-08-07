import type { Photo } from "@/types/photo";

export const filterPhotosBySection = (photos: Photo[], key: string): Photo[] => {
  return photos.filter((p) => p.sectionKey === key).sort((a, b) => a.position - b.position);
}

export const formatPrice = (price: string): string => {
  const numericPrice = parseFloat(price);
  return (numericPrice % 1 === 0 ? numericPrice.toFixed(0) : numericPrice.toFixed(2));
};
