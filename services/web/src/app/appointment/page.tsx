import type { Showcase } from "@/types/showcase";
import type { ServiceResponse } from "@/types/service";
import { AppointmentProvider } from "@/context/appointment-context";
import { galleryPackageData } from "@/graphql/queries/galleries";
import { showcaseQuery } from "@/graphql/queries/showcase";
import AppointmentForm from "./components/appointment-form";
import Image from "next/image";
import DefaultFallback from "@/components/fallback/default-fallback";
import HeroImageWrapper from "@/components/wrappers/hero-image-wrapper";
import { filterPhotosBySection } from "@/utils/helpers"

type GalleriesAndPackagesProps = {
  showcase: Showcase;
  galleries: ServiceResponse;
}

type AppointmentPageProps = {
  searchParams: Promise<Record<string, string | string[] | undefined>>;
};

async function GalleryPackages(): Promise<GalleriesAndPackagesProps | null> {
  try {
    const [galleries, showcase] = await Promise.all([galleryPackageData(), showcaseQuery("Appointment")])

    return {
      galleries,
      showcase
    }
  }catch (err) {
    console.error("Failed to fetch gallery details:", err);
    return null;
  }
}

export default async function AppointmentPage({ searchParams }: AppointmentPageProps) {
  // const { galleryId, packageId } = await searchParams;
  const sParams = await searchParams;
  const galleryId = Array.isArray(sParams.galleryId) ? sParams.galleryId[0] : sParams.galleryId;
  const packageId = Array.isArray(sParams.packageId) ? sParams.packageId[0] : sParams.packageId;
  const data = await GalleryPackages();

  if (data == null) {
    return <DefaultFallback />
  }

  const { galleries, showcase } = data;
  const { services } = galleries;

  const [heroImage] = filterPhotosBySection(showcase.photos, "hero")
  const [formPhoto] = filterPhotosBySection(showcase.photos, "form_photo")
  const defaultInfo = {
    title: "Let's Connect and Plan Your Session",
    message: "Have questions or ready to get started? Share your details below, and I'll be in touch to answer your questions and schedule your personalized photography session."
  };

  return (
    <main>
      <HeroImageWrapper photo={heroImage} defaultInfo={defaultInfo}/>

      <section className="my-16" id="appointment-form">
        <AppointmentProvider galleries={services} galleryId={galleryId} packageId={packageId} >
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 place-content-around items-start">
            <div className="w-[85%] justify-self-center">
              <AppointmentForm />
            </div>
            <div className="flex justify-center justify-self-center w-full">
              <div className="relative aspect-[3/4] w-[85%] max-h-full rounded-lg overflow-hidden shadow-2xl transform transition-transform hover:scale-[1.01]">
                <Image
                  src={formPhoto.imageUrl}
                  className="object-cover"
                  fill
                  sizes="(max-width: 768px) 100vw, 50vw"
                  alt="Victoria Gonzales Photography"
                />
              </div>
            </div>
          </div>
        </AppointmentProvider>
      </section>

      {/* <section className="mb-16">
        <h2 className="text-2xl md:text-3xl font-bold text-center mb-12">The Booking Process</h2>
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-8">
          {[
            {
              step: "01",
              title: "Inquire",
              description: "Send me a message where we go over pricing, availability, and location.",
            },
            {
              step: "02",
              title: "You're Booked",
              description: "After $50 deposit is paid and contract is signed, you're officially booked!",
            },
            {
              step: "03",
              title: "It's Time",
              description:
                "It's time for your session. I handle everything and we create some gorgeous pictures while having fun!",
            },
            {
              step: "04",
              title: "Delivery",
              description:
                "Within three weeks from your session date, your pictures will be delivered via email. From there you can download your images, print, & share!",
            },
          ].map((item, index) => (
            <div key={index} className="bg-white p-6 rounded-lg shadow-md hover:shadow-lg transition-shadow">
              <div className="flex items-center justify-center w-12 h-12 rounded-full bg-gray-100 text-gray-800 font-bold mb-4 mx-auto">
                {item.step}
              </div>
              <h3 className="text-xl font-semibold text-center mb-2">{item.title}</h3>
              <p className="text-gray-600 text-center text-sm">{item.description}</p>
            </div>
          ))}
        </div>
      </section> */}
    </main>
  )
};
