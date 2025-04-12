import { getPlaiceholder } from "plaiceholder";

async function getBase64(photoUrl) {
  try {
    const res = await fetch(photoUrl)

    if (!res.ok) {
      throw new Error(`Failed to fetch image: ${res.status} ${res.statusText}`)
    }

    const buffer = await res.arrayBuffer();
    const { base64 } = await getPlaiceholder(Buffer.from(buffer));

    return base64;
  } catch(e) {
    console.error(e);
  }
};

export default async function addBlurredDataUrls(collections) {
  // Make all requests at once instead of awaiting each one - avoiding a waterfall
  const base64Promises = collections.flatMap(collection => 
    collection.photos.map(photo => getBase64(`${process.env.NEXT_PUBLIC_AWS_S3_URL}/${photo.fileKey}`))
  );

  // Resolve all requests in order
  const base64Results = await Promise.all(base64Promises);

  let base64Index = 0;

  const photosWithBlur = collections.map(collection =>
    {
      const updatedPhotos = collection.photos.map((photo) => {
        photo.blurredDataUrl = base64Results[base64Index];
        base64Index++;
        return photo;
      });

      return {
        ...collection,
        photos: updatedPhotos
      };
    }
  );

  return photosWithBlur;
};
