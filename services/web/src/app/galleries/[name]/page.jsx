import { Separator } from "@/components/ui/separator";
import {photosBySlugQuery } from "@/graphql/queries/galleries";
import CoverImage from "./components/cover-image";
import ImageContainer from "./components/image-container";
import addBlurredDataUrls from "@/utils/get-base-64";

async function getGalleryPagePhotos(galleryName) {
  try {
    const gallery = await photosBySlugQuery(galleryName);
    const coverPhoto = gallery.photo;
    const collections = gallery.collections

    return {
      gallery,
      coverPhoto,
      collections,
    }
  } catch (err) {
    console.error("Failed to fetch homepage photos:", err);

    return {
      gallery: {},
      coverPhoto: {},
      collections: [],
    }
  }
}

export default async function Gallery({ params }) {
  const { name } = await params;
  const {gallery, coverPhoto, collections } = await getGalleryPagePhotos(name);

  return (
    <div>
      <CoverImage coverPhoto={coverPhoto} gallery={gallery} />

      <section className="max-w-7xl mx-auto px-4 py-8">
        <div className="mb-12 text-center">
          <h2 className="text-3xl font-semibold text-stone-800 mb-4">Collections</h2>
          <p className="text-lg text-stone-600 max-w-3xl mx-auto">
            Browse through my portfolio of {gallery.name.toLowerCase()} work, organized by collections.
          </p>
        </div>

        <div>
          {collections.map((collection) => (
            <div key={collection.name}>
              <div className="text-center mb-6">
                <h3 className="text-2xl font-semibold text-stone-800">{collection.name}</h3>
              </div>

              <Separator className="mb-10" />

              <div className="px-1 my-3 grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-2">
                {collection.photos.map((photo) => (
                  <ImageContainer key={photo.id} photo={photo} />
                ))}
              </div>
            </div>
          ))}
        </div>
      </section>
    </div>
  );
};
