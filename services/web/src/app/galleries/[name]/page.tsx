import type { GalleryWithCollectionsResponse } from "@/types/collection";
import { Separator } from "@/components/ui/separator";
import { photosBySlugQuery } from "@/graphql/queries/galleries";
import HeroImageWrapper from "@/components/wrappers/hero-image-wrapper";
import MasonryImage from "./components/masonry-image";
import DefaultFallback from "@/components/fallback/default-fallback"

type ParamProps = {
  params: Promise<{name: string}>;
}

async function GalleryCollections(galleryName: string): Promise<GalleryWithCollectionsResponse | null> {
  try {
    const response = await photosBySlugQuery(galleryName);

    return response;
  } catch(err) {
    console.error("Failed to fetch gallery collections:", err);
    return null;
  }
}

export default async function GalleryPage({ params }: ParamProps) {
  const { name } = await params;
  const data = await GalleryCollections(name);

  if (data == null) {
    return (
      <DefaultFallback />
    )
  }

  const { gallery } = data;

  return (
    <main>
      <HeroImageWrapper photo={gallery.photo} gallery={gallery}/>

      <section className="max-w-7xl mx-auto px-4 py-8">
        <div className="mb-12 text-center">
          <h2 className="text-3xl font-semibold text-stone-800 mb-4">Collections</h2>
          <p className="text-lg text-stone-600 max-w-3xl mx-auto">
            Browse through my portfolio of {gallery.name.toLowerCase()} work, organized by collections.
          </p>
        </div>

        <div>
          {gallery.collections.map((collection) => (
            <div key={collection.name}>
              <div className="text-center mb-6">
                <h3 className="text-2xl font-semibold text-stone-800">{collection.name}</h3>
              </div>

              <Separator className="mb-10" />

              <div className="px-1 my-3 grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-2">
                {collection.photos.map((photo) => (
                  <MasonryImage key={photo.id} photo={photo} />
                ))}
              </div>
            </div>
          ))}
        </div>
      </section>
    </main>
  )
};
