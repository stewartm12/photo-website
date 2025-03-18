import { Camera, Heart, Coffee, Globe, Award, BookOpen, Calendar, Users, Sparkles } from "lucide-react";
import { Card, CardContent, CardFooter } from "@/components/ui/card";
import { Separator } from "@/components/ui/separator";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import Link from "next/link"
import Image from "next/image";

export default function AboutMe() {
  return (
    <div className="min-h-screen pb-16">
      <section className="relative h-screen md:h-[60vh] overflow-hidden">
        <Image
          src={`${process.env.NEXT_PUBLIC_AWS_S3_URL}/Damla-Selen-Demir-4.jpg`}
          alt="Victoria Gonzales - Professional Photographer"
          fill
          loading="eager"
          className="object-cover"
        />
        <div className="absolute inset-0 bg-black/40 flex items-center justify-center">
          <div className="text-center px-6 py-6 bg-white/5 rounded-lg max-w-3xl">
            <h1 className="text-4xl sm:text-5xl font-bold text-white">Get to Know Victoria</h1>
            <p className="text-lg text-white/80 mt-2">
              The person behind the camera and the stories I love to tell
            </p>
          </div>
        </div>
      </section>

      <section className="py-16 md:py-24 px-4 max-w-5xl mx-auto">
        <div className="grid grid-cols-1 md:grid-cols-2 gap-12 items-center">
          <div className="relative">
            <div className="absolute -top-4 -left-4 w-full h-full border-2 border-stone-200 rounded-lg"></div>
            <Image
              src={`${process.env.NEXT_PUBLIC_AWS_S3_URL}/Damla-Selen-Demir-1.jpg`}
              alt="Victoria Gonzales Portrait"
              width={500}
              height={600}
              className="rounded-lg shadow-lg relative z-10 object-cover"
            />
          </div>
          <div className="space-y-6">
            <h2 className="text-3xl md:text-4xl font-semibold text-stone-800">Hello, I'm Victoria</h2>
            <Separator className="w-24 bg-stone-300" />
            <p className="text-lg text-stone-600 leading-relaxed">
              I'm a photographer based in San Antonio, Texas with a passion for capturing authentic moments that tell
              your unique story.
            </p>
            <p className="text-lg text-stone-600 leading-relaxed">
              My journey into photography began over 10 years ago when I received my first DSLR camera as a gift. What
              started as a hobby quickly evolved into a passion and eventually a fulfilling career that allows me to
              connect with amazing people and preserve their most precious memories.
            </p>
            <div className="flex flex-wrap gap-2 pt-2">
              <Badge className="bg-stone-200 text-stone-800 hover:bg-stone-300">Portrait</Badge>
              <Badge className="bg-stone-200 text-stone-800 hover:bg-stone-300">Wedding</Badge>
              <Badge className="bg-stone-200 text-stone-800 hover:bg-stone-300">Family</Badge>
              <Badge className="bg-stone-200 text-stone-800 hover:bg-stone-300">Engagement</Badge>
              <Badge className="bg-stone-200 text-stone-800 hover:bg-stone-300">Maternity</Badge>
            </div>
          </div>
        </div>
      </section>

      <section className="py-16 md:py-24 bg-caramel-600 text-white">
        <div className="max-w-6xl mx-auto px-4">
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
            <div className="order-2 lg:order-1 space-y-6">
              <h2 className="text-3xl md:text-4xl font-semibold">My Photography Philosophy</h2>
              <Separator className="w-24 bg-stone-400" />
              <p className="text-lg text-stone-200 leading-relaxed">
                I believe photography is about more than just taking pictures—it's about preserving emotions,
                connections, and moments that might otherwise fade with time.
              </p>
              <p className="text-lg text-stone-200 leading-relaxed">
                I specialize in capturing candid and natural moments, where genuine emotions shine through effortlessly.
                My approach revolves around creating a relaxed atmosphere, allowing individuals and families to express
                themselves authentically.
              </p>
              <p className="text-lg text-stone-200 leading-relaxed">
                Whether it's the nervous excitement before a wedding ceremony, spontaneous laughter shared between loved
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
                  src={`${process.env.NEXT_PUBLIC_AWS_S3_URL}/Damla-Selen-Demir-2.jpg`}
                  className="object-cover rounded-lg shadow-lg relative z-10"
                  width={600}
                  height={600}
                  alt="Victoria's Photography Style"
                />
              </div>
            </div>
          </div>
        </div>
      </section>

      <section className="py-16 md:py-20 px-4">
        <div className="max-w-5xl mx-auto text-center mb-12">
          <h2 className="text-3xl md:text-4xl font-semibold text-stone-800 mb-4">My Photography Journey</h2>
          <p className="text-lg text-stone-600 max-w-3xl mx-auto">
            From hobbyist to professional, my path has been filled with growth, learning, and unforgettable moments
          </p>
        </div>

        <div className="max-w-4xl mx-auto">
          {/* Timeline items */}
          <div className="space-y-12">
            <TimelineItem
              year="2012"
              title="Photography Beginnings"
              description="Received my first DSLR camera and began exploring photography as a hobby, focusing on landscapes and street photography."
              icon={<Camera className="h-6 w-6" />}
              side="left"
            />

            <TimelineItem
              year="2014"
              title="First Wedding"
              description="Photographed my first wedding for a friend, discovering my passion for capturing emotional and authentic moments between people."
              icon={<Heart className="h-6 w-6" />}
              side="right"
            />

            <TimelineItem
              year="2016"
              title="Photography Education"
              description="Completed formal photography training and workshops to refine my technical skills and develop my unique style."
              icon={<BookOpen className="h-6 w-6" />}
              side="left"
            />

            <TimelineItem
              year="2018"
              title="Studio Launch"
              description="Officially launched Victoria Gonzales Photography, focusing on weddings, families, and portrait photography throughout Southern California."
              icon={<Globe className="h-6 w-6" />}
              side="right"
            />

            <TimelineItem
              year="2020"
              title="Adapting & Growing"
              description="Pivoted during challenging times to offer intimate sessions and micro-weddings, finding beauty in smaller, more personal gatherings."
              icon={<Sparkles className="h-6 w-6" />}
              side="left"
            />

            <TimelineItem
              year="2022-Now"
              title="Continuing the Journey"
              description="Expanding my craft, teaching photography workshops, and continuing to capture beautiful stories for wonderful clients."
              icon={<Calendar className="h-6 w-6" />}
              side="right"
            />
          </div>
        </div>
      </section>

      <section className="py-16 bg-footer-100">
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
                  "Victoria photographed our wedding back in April and we were absolutely thrilled with our photos! Victoria
                  captured every detail beautifully, and we'll cherish these memories forever. So professional,
                  talented, and easy to work with. Highly recommend!"
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
                  "When I had my session it was a windy day. I loved how Victoria was so patient with the wind and didn't
                  stop taking pictures until she got the perfect ones. I also loved seeing my kids smiling as she posed
                  us. Her prices are very affordable and the quality is exceptional."
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
            A glimpse into my world when I'm not behind the camera
          </p>
        </div>

        <div className="max-w-6xl mx-auto">
          <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-4">
            <div className="aspect-square relative rounded-lg overflow-hidden group">
              <Image
                src={`${process.env.NEXT_PUBLIC_AWS_S3_URL}/Damla-Selen-Demir-1.jpg`}
                alt="Behind the scenes - Camera setup"
                width={300}
                height={300}
                className="object-cover w-full h-full transition-transform duration-500 group-hover:scale-110"
              />
            </div>
            <div className="aspect-square relative rounded-lg overflow-hidden group">
              <Image
                src={`${process.env.NEXT_PUBLIC_AWS_S3_URL}/Damla-Selen-Demir-2.jpg`}
                alt="Behind the scenes - Working with clients"
                width={300}
                height={300}
                className="object-cover w-full h-full transition-transform duration-500 group-hover:scale-110"
              />
            </div>
            <div className="aspect-square relative rounded-lg overflow-hidden group">
              <Image
                src={`${process.env.NEXT_PUBLIC_AWS_S3_URL}/Damla-Selen-Demir-3.jpg`}
                alt="Behind the scenes - Editing session"
                width={300}
                height={300}
                className="object-cover w-full h-full transition-transform duration-500 group-hover:scale-110"
              />
            </div>
            <div className="aspect-square relative rounded-lg overflow-hidden group">
              <Image
                src={`${process.env.NEXT_PUBLIC_AWS_S3_URL}/Damla-Selen-Demir-4.jpg`}
                alt="Behind the scenes - Location scouting"
                width={300}
                height={300}
                className="object-cover w-full h-full transition-transform duration-500 group-hover:scale-110"
              />
            </div>
            <div className="aspect-square relative rounded-lg overflow-hidden group">
              <Image
                src={`${process.env.NEXT_PUBLIC_AWS_S3_URL}/Damla-Selen-Demir-1.jpg`}
                alt="Behind the scenes - Photography gear"
                width={300}
                height={300}
                className="object-cover w-full h-full transition-transform duration-500 group-hover:scale-110"
              />
            </div>
          </div>
        </div>
      </section>

      <section className="py-16 md:py-20 bg-stone-100">
        <div className="max-w-5xl mx-auto px-4 text-center mb-12">
          <h2 className="text-3xl md:text-4xl font-semibold text-stone-800 mb-4">Fun Facts About Me</h2>
          <p className="text-lg text-stone-600 max-w-3xl mx-auto">
            When I'm not photographing amazing people, you might find me...
          </p>
        </div>

        <div className="max-w-5xl mx-auto px-4">
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-8">
            <Card className="text-center p-6 hover:shadow-lg transition-shadow">
              <Coffee className="h-12 w-12 mx-auto mb-4 text-stone-700" />
              <h3 className="text-xl font-semibold mb-2">Coffee Enthusiast</h3>
              <p className="text-stone-600">
                I'm a serious coffee lover and enjoy exploring local coffee shops wherever I travel.
              </p>
            </Card>

            <Card className="text-center p-6 hover:shadow-lg transition-shadow">
              <Globe className="h-12 w-12 mx-auto mb-4 text-stone-700" />
              <h3 className="text-xl font-semibold mb-2">Travel Addict</h3>
              <p className="text-stone-600">
                I've visited 14 countries so far and always bring my camera to document the journey.
              </p>
            </Card>

            <Card className="text-center p-6 hover:shadow-lg transition-shadow">
              <Award className="h-12 w-12 mx-auto mb-4 text-stone-700" />
              <h3 className="text-xl font-semibold mb-2">Dog Lover</h3>
              <p className="text-stone-600">
                Proud dog mom to Bailey, my Golden Retriever who sometimes joins me on photoshoots!
              </p>
            </Card>
          </div>
        </div>
      </section>
    </div>
  );
};

// Timeline Item Component
function TimelineItem({ year, title, description, icon, side }) {
  return (
    <div className="flex items-center">
      {/* Left content */}
      <div className={`w-1/2 ${side === "left" ? "pr-8 text-right" : "invisible"}`}>
        {side === "left" && (
          <div>
            <h3 className="text-xl font-semibold text-stone-800">{title}</h3>
            <p className="text-stone-600 mt-2">{description}</p>
          </div>
        )}
      </div>

      {/* Center icon */}
      <div className="relative flex flex-col items-center">
        <div className="w-12 h-12 rounded-full bg-footer-100 text-white flex items-center justify-center z-10">
          {icon}
        </div>
        <div className="absolute w-1 bg-stone-300 h-[200%] top-0 -z-10"></div>
        <div className="mt-2 font-bold text-stone-800">{year}</div>
      </div>

      {/* Right content */}
      <div className={`w-1/2 ${side === "right" ? "pl-8" : "invisible"}`}>
        {side === "right" && (
          <div>
            <h3 className="text-xl font-semibold text-stone-800">{title}</h3>
            <p className="text-stone-600 mt-2">{description}</p>
          </div>
        )}
      </div>
    </div>
  );
};
