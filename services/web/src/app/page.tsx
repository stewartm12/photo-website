import type { Photo } from "@/types/photo";
import { Fragment } from "react";
import { ArrowRight, Camera, Heart, MessageSquare } from "lucide-react";
import { Card, CardContent, CardFooter } from "@/components/ui/card";
import { Separator } from "@/components/ui/separator";
import { Button } from "@/components/ui/button";
import { showcaseQuery } from "@/graphql/queries/showcase";
import { filterPhotosBySection } from "@/utils/helpers";
import SlideshowWrapper from "@/components/wrappers/slideshow-wrapper";
import ServiceCard from "./root-components/service-card";
import Link from "next/link";
import Image from "next/image";

async function getHomePagePhotos(): Promise<Photo[]> {
  try {
    const response = await showcaseQuery("Home");
    const homePagePhotos = response.photos;

    return homePagePhotos;
  } catch(e) {
    console.error("Error fetch home page photos:", e);
    return [];
  } 
}

export default async function HomePage() {
  const photos = await getHomePagePhotos();
  const slideshowPhotos = filterPhotosBySection(photos, "slideshow");
  const [servicePhoto1, servicePhoto2, servicePhoto3] = filterPhotosBySection(photos, "services");
  const [hirePhoto] = filterPhotosBySection(photos, "why_hire_me");

  return (
    <main>
      <section className="relative w-full">
        <SlideshowWrapper photos={slideshowPhotos} />
        <div className="absolute inset-0 bg-black/30 flex items-center">
          <div className="text-center px-4 py-8 bg-white/10 rounded-lg mx-auto">
            <h1 className="text-4xl sm:text-5xl font-bold mb-4 text-white">Warm, Timeless, & Intimate</h1>
            <p className="text-xl sm:text-2xl text-white/90 mx-auto">Preserve Every Emotion, Relive Every Moment</p>
          </div>
        </div>
      </section>

      <section className="py-16 md:py-24 px-4 max-w-5xl mx-auto">
        <div className="text-center space-y-6">
          <h2 className="text-2xl sm:text-3xl md:text-4xl font-semibold text-stone-800">
            Welcome to Victoria Gonzales Photography
          </h2>
          <p className="text-lg md:text-xl text-stone-600 max-w-3xl mx-auto leading-relaxed">
            I don&#39;t just capture images—I preserve the emotions that make your day unforgettable. From the gentle touch
            of a hand to the tears, laughter, and every intimate moment in between, I artfully document the true essence
            of your love story.
          </p>
          <Link href="/galleries/individual-family-portraits">
            <Button className="mt-6 text-white cursor-pointer">
              View My Portfolio <ArrowRight className="ml-2 h-4 w-4" />
            </Button>
          </Link>
        </div>
      </section>

      <section className="py-16 bg-blue-900">
        <div className="max-w-4xl mx-auto px-4">
          <Card className="border-none shadow-xl bg-white relative overflow-hidden">
            <CardContent className="pt-10 pb-8 px-6 md:px-10 relative z-10">
              <div className="absolute top-6 left-6 text-stone-300">
                <svg width="40" height="40" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <path
                    d="M10 11L8 17H5L7 11V7H10V11ZM18 11L16 17H13L15 11V7H18V11Z"
                    fill="currentColor"
                    stroke="currentColor"
                    strokeWidth="1"
                  />
                </svg>
              </div>
              <p className="text-xl md:text-2xl text-stone-700 italic leading-relaxed pt-4">
                &quot;Victoria photographed our wedding back in April and we were absolutely thrilled with our photos! Victoria
                captured every detail beautifully, and we&#39;ll cherish these memories forever. So professional, talented,
                and easy to work with. Highly recommend!&quot;
              </p>
            </CardContent>
            <CardFooter className="px-6 md:px-10 pb-6 pt-0">
              <div className="flex items-center">
                <div className="size-12 rounded-full bg-stone-200 flex items-center justify-center text-stone-500">
                  <Heart className="size-6" />
                </div>
                <div className="ml-4">
                  <p className="font-semibold text-stone-800">Hailey & Xavier</p>
                  <p className="text-stone-500 text-sm">Wedding Portraits</p>
                </div>
              </div>
            </CardFooter>
          </Card>
        </div>
      </section>

      <section className="py-16 md:py-20 bg-stone-100">
        <div className="max-w-4xl mx-auto px-4 text-center">
          <MessageSquare className="size-10 mx-auto mb-6 text-stone-400" />
          <p className="text-xl md:text-2xl text-stone-700 italic leading-relaxed max-w-3xl mx-auto">
            &quot;When I had my session it was a windy day. I loved how she was so patient with the wind and didn&#39;t stop
            taking pictures until she got the perfect ones. I also loved seeing my kids smiling as she placed us to take
            pictures. Her prices are very affordable.&quot;
          </p>
          <div className="mt-8">
            <p className="font-semibold text-stone-800">Silvia</p>
            <p className="text-stone-500">Family Portraits</p>
          </div>
        </div>
      </section>

      <section className="py-16 md:py-24 text-white bg-black">
        <div className="max-w-6xl mx-auto px-4">
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
            <div className="space-y-6">
              <h2 className="text-3xl md:text-4xl font-semibold">Why Hire Me?</h2>
              <Separator className="w-24 bg-stone-400" />
              <p className="text-xl font-light text-stone-300 mb-4">Why choose Victoria&#39;s Photography...</p>
              <p className="text-lg text-stone-200 leading-relaxed">
                Choosing the right photographer is crucial to capturing moments that matter most. When you choose me,
                you&#39;re selecting someone dedicated and passionate about capturing and telling your story to hold on to forever.
                I strive to create images that not only meet but exceed your expectations.
              </p>
              <Link href="/about-me" className="cursor-pointer">
                <Button variant="ghost" className="mt-6 text-white group-hover:scale-102 cursor-pointer">
                  Learn More  <ArrowRight className="ml-2 size-4 transition-transform group-hover:translate-x-1" />
                </Button>
              </Link>
            </div>
            <div className="relative">
              <div className="absolute -top-4 -right-4 size-full inset-ring-2 rounded-lg"></div>
              {hirePhoto && (
                <Image
                  src={hirePhoto.imageUrl}
                  alt={hirePhoto.altText}
                  className="object-cover rounded-lg shadow-lg relative z-10"
                  width={600}
                  height={600}
                />
              )}
            </div>
          </div>
        </div>
      </section>

      <section className="py-16 md:py-24 bg-white">
        <div className="max-w-6xl mx-auto px-4">
          <h2 className="text-3xl md:text-4xl font-semibold text-stone-800 text-center mb-12">Explore My Services</h2>

          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-8">
            {(servicePhoto1 && servicePhoto2 && servicePhoto3) && (
              <Fragment>
                <ServiceCard
                  imgUrl={servicePhoto1.imageUrl}
                  title={"View Galleries"}
                  description={"Check out my work"}
                  link="/galleries/engagement-couples-portraits"
                />

                <ServiceCard
                  imgUrl={servicePhoto2.imageUrl}
                  title={"Contact Me"}
                  description={"Let&#39;s get you booked"}
                  link="/appointment"
                />

                <ServiceCard
                  imgUrl={servicePhoto1.imageUrl}
                  title={"Services"}
                  description={"Pricing and packages"}
                  link="/services"
                />
            </Fragment>
            )}
          </div>
        </div>
      </section>

      <section className="py-16 bg-stone-100">
        <div className="max-w-3xl mx-auto px-4 text-center">
          <Camera className="size-12 mx-auto mb-6 text-stone-700" />
          <h2 className="text-3xl md:text-4xl font-semibold text-stone-800 mb-4">Ready to Capture Your Story?</h2>
          <p className="text-lg text-stone-600 mb-8 max-w-2xl mx-auto">
            Let&#39;s create timeless memories together. Contact me today to discuss your photography needs and book your
            session.
          </p>
          <Link href="/appointment" className="cursor-pointer">
            <Button className="text-white cursor-pointer">
              Get In Touch   <ArrowRight className="ml-2 size-4 transition-transform group-hover:translate-x-1" />
            </Button>
          </Link>
        </div>
      </section>
    </main>
  );
};
