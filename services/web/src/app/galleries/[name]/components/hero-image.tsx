import type { Photo } from "@/types/photo";
import type { Gallery } from "@/types/gallery";
import Image from "next/image";

type DefaultMessage = {
  title: string;
  message: string;
}

type HeroImageProps = {
  photo: Photo;
  gallery?: Gallery;
  defaultInfo?: DefaultMessage;
}

export default function HeroImage({ photo, gallery, defaultInfo }: HeroImageProps) {
  const title = !gallery && defaultInfo?.title
    ? defaultInfo.title
    : gallery?.name ?? "";

  const message = !gallery && defaultInfo?.message
    ? defaultInfo.message
    : gallery?.description ?? "";

  return (
    <main className="relative h-[60vh] min-h-[830px] max-h-[900px]">
      <Image
        src={photo.imageUrl}
        alt={`${photo.altText} - Featured Photo`}
        fill
        priority
        className="object-cover object-top"
      />
      <div className="absolute inset-0 bg-black/30 flex items-center">
        <div className="text-center px-4 py-8 bg-white/10 rounded-lg mx-auto">
          <h1 className="text-4xl sm:text-5xl font-bold mb-4 text-white">{title}</h1>
          <p className="text-xl sm:text-2xl text-white/90 mx-auto">{message}</p>
        </div>
      </div>
    </main>
  );
};
