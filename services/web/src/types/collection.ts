import type { Photo } from "./photo";

type Collection = {
  id: string;
  name: string;
  photos: Photo[];
};

export type GalleryWithCollectionsResponse = {
  gallery: {
    id: string;
    name: string;
    description?: string;
    photo: Photo;
    collections: Collection[];
  }
};
