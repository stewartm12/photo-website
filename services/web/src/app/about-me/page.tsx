import type { Photo } from "@/types/photo";
import { Heart, Coffee, Globe, Award, Users } from "lucide-react";
import { Card, CardContent, CardFooter } from "@/components/ui/card";
import { Separator } from "@/components/ui/separator";
import { Badge } from "@/components/ui/badge";
import { showcaseQuery } from "@/graphql/queries/showcase";
import { filterPhotosBySection } from "@/utils/helpers";
import Image from "next/image";
import DefaultFallback from "@/components/fallback/default-fallback";
import HeroImageWrapper from "@/components/wrappers/hero-image-wrapper";
// import Timeline from "./components/timeline";

type AboutMeShowcaseProps = {
  id: string;
  name: string;
  photos: Photo[];
}

async function aboutMeShowcase(): Promise<AboutMeShowcaseProps | null> {
  try {
    const response = await showcaseQuery("about_me");

    return response
  } catch(err) {
    console.error("Failed to fetch homepage photos:", err);
    return null;
  }
}

export default async function AboutMePage() {
  const data = await aboutMeShowcase();

  if (data == null) {
    return <DefaultFallback />
  }

  const photos = data.photos;
  const [heroImage] = filterPhotosBySection(photos, "hero")
  const [aboutMePhoto]= filterPhotosBySection(photos, "about_me")
  const behindTheScenesPhotos= filterPhotosBySection(photos, "behind_the_scenes")
  // const philosophyPhoto= filterPhotosBySection(photos, "philosophy")[0]
  const defaultInfo = { title: "Meet Your Photographer", message: "The person behind the camera and the stories I love to tell"}

  return (
    <main>
      <HeroImageWrapper photo={heroImage} defaultInfo={defaultInfo}/>

      <section className="py-16 md:py-24 px-4 max-w-5xl mx-auto">
        <div className="grid grid-cols-1 md:grid-cols-2 gap-12 items-center">
          <div className="relative">
            <div className="absolute -top-4 -left-4 w-full h-full border-2 border-stone-200 rounded-lg"></div>
            <Image
              src={aboutMePhoto.imageUrl}
              alt="Victoria Gonzales Portrait"
              width={500}
              height={600}
              className="rounded-lg shadow-lg relative z-10 object-cover"
            />
          </div>
          <div className="space-y-6">
            <h2 className="text-3xl md:text-4xl font-semibold text-stone-800">The Girl Behind The Camera</h2>
            <Separator className="w-24 bg-stone-300" />
            <p className="text-lg text-stone-600 leading-relaxed">
              Hello, I&#39;m Victoria! Based in San Antonio, Texas, born and raised. i&#39;ve had a passion for photography
              ever since i started photographingmy family on my Nintendo 3DS over 10 years ago. There&#39;s something
              magical about freezing moments in time so you can go back and look at them years later. Thanks for
              stopping by, I&#39;d be honored to tell a piece of your story through my lens.
            </p>
            <div className="flex flex-wrap gap-2 pt-2">
              <Badge className="bg-stone-200 text-stone-800 hover:bg-stone-300">Portrait</Badge>
              <Badge className="bg-stone-200 text-stone-800 hover:bg-stone-300">Couples</Badge>
              <Badge className="bg-stone-200 text-stone-800 hover:bg-stone-300">Family</Badge>
              <Badge className="bg-stone-200 text-stone-800 hover:bg-stone-300">Engagement</Badge>
              <Badge className="bg-stone-200 text-stone-800 hover:bg-stone-300">Maternity</Badge>
            </div>
          </div>
        </div>
      </section>

      {/* <section className="py-16 md:py-24 bg-blacktext-white">
        <div className="max-w-6xl mx-auto px-4">
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
            <div className="order-2 lg:order-1 space-y-6">
              <h2 className="text-3xl md:text-4xl font-semibold">My Photography Philosophy</h2>
              <Separator className="w-24 bg-stone-400" />
              <p className="text-lg text-stone-200 leading-relaxed">
                I believe photography is about more than just taking pictures—it&#39;s about preserving emotions,
                connections, and moments that might otherwise fade with time.
              </p>
              <p className="text-lg text-stone-200 leading-relaxed">
                I specialize in capturing candid and natural moments, where genuine emotions shine through effortlessly.
                My approach revolves around creating a relaxed atmosphere, allowing individuals and families to express
                themselves authentically.
              </p>
              <p className="text-lg text-stone-200 leading-relaxed">
                Whether it&#39;s the nervous excitement before a wedding ceremony, spontaneous laughter shared between loved
                ones, or a quiet, reflective moment between parent and child, I aim to document these instances with
                sensitivity and artistry.
              </p>
              <Link href="/galleries/individual-family-portraits" className="cursor-pointer">
                <Button className="mt-6 bg-white text-stone-800 hover:bg-stone-200">View My Portfolio</Button>
              </Link>
            </div>
            <div className="order-1 lg:order-2">
              <div className="relative">
                <div className="absolute -top-4 -left-4 w-full h-full border-2 border-stone-600 rounded-lg"></div>
                <Image
                  src={philosophyPhoto.imageUrl}
                  className="object-cover rounded-lg shadow-lg relative z-10"
                  width={600}
                  height={600}
                  alt="Victoria&#39;s Photography Style"
                />
              </div>
            </div>
          </div>
        </div>
      </section> */}

      {/* <section className="py-16 md:py-20 px-4">
        <div className="max-w-5xl mx-auto text-center mb-12">
          <h2 className="text-3xl md:text-4xl font-semibold text-stone-800 mb-4">My Photography Journey</h2>
          <p className="text-lg text-stone-600 max-w-3xl mx-auto">
            From hobbyist to professional, my path has been filled with growth, learning, and unforgettable moments
          </p>
        </div>

        < Timeline/>
      </section> */}

      <section className="py-16 bg-blue-900">
        <div className="max-w-5xl mx-auto px-4 text-center mb-12">
          <h2 className="text-3xl md:text-4xl font-semibold text-white mb-4">What My Clients Say</h2>
          <p className="text-lg text-white max-w-3xl mx-auto">
            The relationships I build with my clients are as important as the images I create
          </p>
        </div>

        <div className="max-w-6xl mx-auto px-4">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
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
                <p className="text-lg md:text-xl text-stone-700 italic leading-relaxed pt-4">
                  &quot;Victoria photographed our wedding back in April and we were absolutely thrilled with our photos! Victoria
                  captured every detail beautifully, and we&#39;ll cherish these memories forever. So professional,
                  talented, and easy to work with. Highly recommend!&quot;
                </p>
              </CardContent>
              <CardFooter className="px-6 md:px-10 pb-6 pt-0">
                <div className="flex items-center">
                  <div className="w-12 h-12 rounded-full bg-stone-200 flex items-center justify-center text-stone-500">
                    <Heart className="h-6 w-6" />
                  </div>
                  <div className="ml-4">
                    <p className="font-semibold text-stone-800">Hailey & Xavier</p>
                    <p className="text-stone-500 text-sm">Wedding Photography</p>
                  </div>
                </div>
              </CardFooter>
            </Card>

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
                <p className="text-lg md:text-xl text-stone-700 italic leading-relaxed pt-4">
                  &quot;When I had my session it was a windy day. I loved how Victoria was so patient with the wind and didn&#39;t
                  stop taking pictures until she got the perfect ones. I also loved seeing my kids smiling as she posed
                  us. Her prices are very affordable and the quality is exceptional.&quot;
                </p>
              </CardContent>
              <CardFooter className="px-6 md:px-10 pb-6 pt-0">
                <div className="flex items-center">
                  <div className="w-12 h-12 rounded-full bg-stone-200 flex items-center justify-center text-stone-500">
                    <Users className="h-6 w-6" />
                  </div>
                  <div className="ml-4">
                    <p className="font-semibold text-stone-800">Silvia</p>
                    <p className="text-stone-500 text-sm">Family Session</p>
                  </div>
                </div>
              </CardFooter>
            </Card>
          </div>
        </div>
      </section>

      <section className="py-16 md:py-24 px-4 bg-white">
        <div className="max-w-5xl mx-auto text-center mb-12">
          <h2 className="text-3xl md:text-4xl font-semibold text-stone-800 mb-4">Behind the Scenes</h2>
          <p className="text-lg text-stone-600 max-w-3xl mx-auto">
            A glimpse into my world when I&#39;m not behind the camera
          </p>
        </div>

        <div className="max-w-6xl mx-auto">
          <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-4">
            { behindTheScenesPhotos.map(photo => (
              <div key={photo.id} className="aspect-square relative rounded-lg overflow-hidden group">
                <Image
                  src={photo.imageUrl}
                  alt={`${photo.altText}`}
                  width={300}
                  height={300}
                  className="object-cover w-full h-full transition-transform duration-500 group-hover:scale-110"
                />
              </div>
            ))}
          </div>
        </div>
      </section>

      <section className="py-16 md:py-20 bg-black">
        <div className="max-w-5xl mx-auto px-4 text-center mb-12">
          <h2 className="text-3xl md:text-4xl font-semibold text-white mb-4">Fun Facts About Me</h2>
          <p className="text-lg text-white max-w-3xl mx-auto">
            When I&#39;m not photographing amazing people, you might find me...
          </p>
        </div>

        <div className="max-w-5xl mx-auto px-4">
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-8">
            <Card className="text-center p-6 hover:shadow-lg transition-shadow">
              <Coffee className="h-12 w-12 mx-auto mb-4 text-stone-700" />
              <h3 className="text-xl font-semibold mb-2">Coffee Enthusiast</h3>
              <p className="text-stone-600">
                I&#39;m a serious coffee lover and enjoy stopping for a quick drink whenever I can. My favorite is a Golden Eagle from Dutchbros!
              </p>
            </Card>

            <Card className="text-center p-6 hover:shadow-lg transition-shadow">
              <Globe className="h-12 w-12 mx-auto mb-4 text-stone-700" />
              <h3 className="text-xl font-semibold mb-2">Gamer</h3>
              <p className="text-stone-600">
                Bought my own PC over 4 years ago and have been glued to that screen ever since. I love playing games like Valorant and Minecraft.
              </p>
            </Card>

            <Card className="text-center p-6 hover:shadow-lg transition-shadow">
              <Award className="h-12 w-12 mx-auto mb-4 text-stone-700" />
              <h3 className="text-xl font-semibold mb-2">Animal Lover</h3>
              <p className="text-stone-600">
                I grew up with all kinds of animals, from dogs and cats to ducks, bunnies, and even turtles.
              </p>
            </Card>
          </div>
        </div>
      </section>
    </main>
  );
};