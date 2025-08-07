import type { Showcase } from "@/types/showcase";
import type { ServiceResponse } from "@/types/service";
import { Card, CardContent, CardFooter } from "@/components/ui/card";
import {  MessageSquare, Star } from "lucide-react";
import { galleryPackageData } from "@/graphql/queries/galleries";
import { showcaseQuery } from "@/graphql/queries/showcase";
import { filterPhotosBySection } from "@/utils/helpers";
import PackageTabs from "./components/package-tabs";
import DefaultFallback from "@/components/fallback/default-fallback";
import HeroImageWrapper from "@/components/wrappers/hero-image-wrapper";
// import Faqs from "./components/faqs";

type PackagesAndAddonsProps = {
  showcase: Showcase;
  galleries: ServiceResponse;
}

async function PackagesAndAddons(): Promise<PackagesAndAddonsProps | null> {
  try {
    const [galleries, showcase] = await Promise.all([
      galleryPackageData(),
      showcaseQuery("service"),
    ]);

    return { showcase, galleries }
  } catch (err) {
    console.error("Failed to fetch package data:", err);
    return null;
  }
}

export default async function ServicesPage() {
  const data = await PackagesAndAddons();

  if (data == null) {
    return <DefaultFallback />
  }
  
  const { galleries, showcase } = data;
  const { services } = galleries;

  const [heroImage] = filterPhotosBySection(showcase.photos, "hero")
  const defaultInfo = {
    title: "Tailored Photography Sessions",
    message: "Explore the sessions I offer — from portraits to events — each crafted to capture your story with intention and artistry."
  };

  return (
    <main>
      <HeroImageWrapper photo={heroImage} defaultInfo={defaultInfo}/>

      <PackageTabs services={services}/>

      <section className="py-12 md:py-16 bg-black">
        <div className="max-w-4xl mx-auto px-4">
          <div className="text-center mb-10">
            <h2 className="text-2xl sm:text-3xl font-semibold text-white mb-4">What My Clients Say</h2>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
            <Card className="border-none shadow-xl bg-white relative overflow-hidden">
              <CardContent className="pt-10 pb-8 px-6 md:px-10 relative z-10">
                <div className="absolute top-6 left-6 text-stone-300">
                  <MessageSquare className="h-8 w-8" />
                </div>
                <div className="flex items-center mb-4">
                  <div className="flex text-amber-400">
                    <Star className="h-5 w-5 fill-current" />
                    <Star className="h-5 w-5 fill-current" />
                    <Star className="h-5 w-5 fill-current" />
                    <Star className="h-5 w-5 fill-current" />
                    <Star className="h-5 w-5 fill-current" />
                  </div>
                </div>
                <p className="text-lg text-stone-700 italic leading-relaxed">
                  &quot;She&#39;s the sweetest and does everything she can to make the session as comfortable and enjoyable as
                  possible. She was encouraging throughout the session despite me not being comfortable in front of a
                  camera.&quot;
                </p>
              </CardContent>
              <CardFooter className="px-6 md:px-10 pb-6 pt-0">
                <div className="flex items-center">
                  <div className="ml-4">
                    <p className="font-semibold text-stone-800">Monte</p>
                    <p className="text-stone-500 text-sm">Graduate Session</p>
                  </div>
                </div>
              </CardFooter>
            </Card>

            <Card className="border-none shadow-xl bg-white relative overflow-hidden">
              <CardContent className="pt-10 pb-8 px-6 md:px-10 relative z-10">
                <div className="absolute top-6 left-6 text-stone-300">
                  <MessageSquare className="h-8 w-8" />
                </div>
                <div className="flex items-center mb-4">
                  <div className="flex text-amber-400">
                    <Star className="h-5 w-5 fill-current" />
                    <Star className="h-5 w-5 fill-current" />
                    <Star className="h-5 w-5 fill-current" />
                    <Star className="h-5 w-5 fill-current" />
                    <Star className="h-5 w-5 fill-current" />
                  </div>
                </div>
                <p className="text-lg text-stone-700 italic leading-relaxed">
                  &quot;Victoria was amazing to work with! She made our family feel so comfortable during our session and
                  captured the most beautiful photos. The pricing was very reasonable for the quality we received.&quot;
                </p>
              </CardContent>
              <CardFooter className="px-6 md:px-10 pb-6 pt-0">
                <div className="flex items-center">
                  <div className="ml-4">
                    <p className="font-semibold text-stone-800">Jessica</p>
                    <p className="text-stone-500 text-sm">Family Session</p>
                  </div>
                </div>
              </CardFooter>
            </Card>
          </div>
        </div>
      </section>

      {/* <section className="py-12 md:py-16 px-4 max-w-5xl mx-auto">
        <div className="text-center mb-10">
          <h2 className="text-2xl sm:text-3xl font-semibold text-stone-800 mb-4">Frequently Asked Questions</h2>
        </div>

        <Faqs />
      </section> */}
    </main>
  )
}