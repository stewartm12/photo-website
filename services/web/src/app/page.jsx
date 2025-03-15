import { slideshowQuery } from "@/graphql/queries/slideshow-query";
import { ArrowRight, Camera, Heart, MessageSquare } from "lucide-react";
import { Card, CardContent, CardFooter } from "@/components/ui/card";
import { Separator } from "@/components/ui/separator";
import { Button } from "@/components/ui/button";
import Slideshow from "@/app/components/slideshow";
import Image from "next/image";
import Link from "next/link";

async function getHomepageSlideshow() {
  return await slideshowQuery();
}

export default async function Home() {
  const data = await getHomepageSlideshow();

  return (
    <div className="relative">
      <section className="relative w-full">
        <Slideshow photos={data.photos} />
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
            Welcome to Victoria's Photography
          </h2>
          <p className="text-lg md:text-xl text-stone-600 max-w-3xl mx-auto leading-relaxed">
            I don't just capture images—I preserve the emotions that make your day unforgettable. From the gentle touch
            of a hand to the tears, laughter, and every intimate moment in between, I artfully document the true essence
            of your love story.
          </p>
          <Button className="mt-6 bg-stone-800 hover:bg-stone-700 text-white">
            View My Portfolio <ArrowRight className="ml-2 h-4 w-4" />
          </Button> {/* Replace with dynamic link to gallery */}
        </div>
      </section>

      <section className="py-16 bg-stone-50">
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
                "Victoria photographed our wedding back in April and we were absolutely thrilled with our photos! Victoria
                captured every detail beautifully, and we'll cherish these memories forever. So professional, talented,
                and easy to work with. Highly recommend!"
              </p>
            </CardContent>
            <CardFooter className="px-6 md:px-10 pb-6 pt-0">
              <div className="flex items-center">
                <div className="w-12 h-12 rounded-full bg-stone-200 flex items-center justify-center text-stone-500">
                  <Heart className="h-6 w-6" />
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
          <MessageSquare className="h-10 w-10 mx-auto mb-6 text-stone-400" />
          <p className="text-xl md:text-2xl text-stone-700 italic leading-relaxed max-w-3xl mx-auto">
            "When I had my session it was a windy day. I loved how she was so patient with the wind and didn't stop
            taking pictures until she got the perfect ones. I also loved seeing my kids smiling as she placed us to take
            pictures. Her prices are very affordable."
          </p>
          <div className="mt-8">
            <p className="font-semibold text-stone-800">Silvia</p>
            <p className="text-stone-500">Family Portraits</p>
          </div>
        </div>
      </section>

      <section className="py-16 md:py-24 bg-stone-800 text-white">
        <div className="max-w-6xl mx-auto px-4">
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
            <div className="space-y-6">
              <h2 className="text-3xl md:text-4xl font-semibold">Why Hire a Photographer?</h2>
              <Separator className="w-24 bg-stone-400" />
              <p className="text-xl font-light text-stone-300 mb-4">Why choose Victoria's Photography...</p>
              <p className="text-lg text-stone-200 leading-relaxed">
                Choosing the right photographer is crucial to capturing moments that matter most. When you choose me,
                you're selecting someone dedicated not just to taking pictures, but to crafting visual stories that
                resonate.
              </p>
              <p className="text-lg text-stone-200 leading-relaxed">
                My approach blends technical expertise with a passion for storytelling, ensuring each photograph conveys
                emotion and depth. I strive to create images that not only meet but exceed your expectations.
              </p>
              <Button className="mt-6 bg-white text-stone-800 hover:bg-stone-200">Learn More</Button>
            </div>
            <div className="relative">
              <div className="absolute -top-4 -right-4 w-full h-full border-2 border-stone-600 rounded-lg"></div>
              <Image
                src={`${process.env.NEXT_PUBLIC_AWS_S3_URL}/Damla-Selen-Demir-4.jpg`}
                alt="Why choose Victoria's Photography"
                className="object-cover rounded-lg shadow-lg relative z-10"
                width={600}
                height={600}
              />
            </div>
          </div>
        </div>
      </section>

      <section className="py-16 md:py-24 bg-white">
        <div className="max-w-6xl mx-auto px-4">
          <h2 className="text-3xl md:text-4xl font-semibold text-stone-800 text-center mb-12">Explore My Services</h2>

          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-8">
            <ServiceCard
              image='/selfie-1.jpg'  // Replace with dynamic image and link to gallery
              title="View Galleries"
              description="Check out my work"
              link="#"
            />

            <ServiceCard
              image='/selfie-2.jpg'  // Replace with dynamic image and link to contact page
              title="Contact Me"
              description="Let's get you booked"
              link="#"
            />

            <ServiceCard
              image='/selfie-3.jpg'  // Replace with dynamic image and link to services page
              title="Services"
              description="Pricing and packages"
              link="#"
            />
          </div>
        </div>
      </section>

      <section className="py-16 bg-stone-100">
        <div className="max-w-3xl mx-auto px-4 text-center">
          <Camera className="h-12 w-12 mx-auto mb-6 text-stone-700" />
          <h2 className="text-3xl md:text-4xl font-semibold text-stone-800 mb-4">Ready to Capture Your Story?</h2>
          <p className="text-lg text-stone-600 mb-8 max-w-2xl mx-auto">
            Let's create timeless memories together. Contact me today to discuss your photography needs and book your
            session.
          </p>
          <Button className="bg-stone-800 hover:bg-stone-700 text-white px-8 py-6 text-lg">Get in Touch</Button> {/* Replace with dynamic link to contact page */}
        </div>
      </section>
    </div>
  );
};

function ServiceCard({ image, title, description, link }) {
  return (
    <Link href={link} className="group">
      <Card className="overflow-hidden transition-all duration-300 hover:shadow-xl">
        <div className="relative overflow-hidden aspect-square">
          <Image
            src={`${process.env.NEXT_PUBLIC_AWS_S3_URL}/Damla-Selen-Demir-4.jpg`} // Replace with dynamic image
            alt={title}
            fill
            className="object-cover transition-transform duration-500 group-hover:scale-105"
          />
        </div>
        <CardContent className="p-6 text-center">
          <h3 className="text-xl font-semibold text-stone-800 mb-2">{title}</h3>
          <p className="text-stone-600">{description}</p>
        </CardContent>
        <CardFooter className="pt-0 pb-6 flex justify-center">
          <Button variant="ghost" className="text-stone-800 group-hover:text-stone-600">
            Learn More <ArrowRight className="ml-2 h-4 w-4 transition-transform group-hover:translate-x-1" />
          </Button>
        </CardFooter>
      </Card>
    </Link>
  );
};

