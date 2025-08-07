import type { Photo } from "./photo";

export type Gallery = {
  id: string;
  name: string;
  description?: string;
  slug?: string;
};

export type GallerySlugsResponse = {
  store: {
    photo: Photo;
  };
  galleries: Gallery[];
};