import { Card, CardContent, CardFooter } from "@/components/ui/card";
import {  MessageSquare, Star } from "lucide-react";
import { galleryPackageData } from "@/graphql/queries/galleries";
import { showcaseQuery } from "@/graphql/queries/showcases";
import PackageTabs from "./package-tabs";
import Image from "next/image";

async function getServicePagePhotos() {
  try {
    const [galleries, servicePagePhotos] = await Promise.all([
      galleryPackageData(),
      showcaseQuery("service"),
    ]);

    const heroPhoto = servicePagePhotos.photos[0] || {};

    return { galleries, heroPhoto };
  } catch (err) {
    console.error("Failed to fetch package data:", err);
    return { galleries: [], heroPhoto: {} };
  }
}

export default async function ServicesPage() {
  const {galleries, heroPhoto} = await getServicePagePhotos();

  return (
    <div className="min-h-screen pb-16">
      <section className="relative h-screen md:h-[60vh]">
        <Image
          src={`${process.env.NEXT_PUBLIC_AWS_S3_URL}/${heroPhoto.fileKey}`}
          alt="Victoria's Photography Services"
          fill
          priority
          className="object-cover"
        />
        <div className="absolute inset-0 bg-black/40 flex items-center justify-center">
          <div className="text-center px-6 py-6 bg-white/5 rounded-lg max-w-3xl">
            <h1 className="text-4xl sm:text-5xl font-bold text-white">Services & Investment</h1>
            <p className="text-lg text-white/80 mt-2">Professional photography packages tailored to your needs</p>
          </div>
        </div>
      </section>

      <PackageTabs galleries={galleries}/>

      <section className="py-12 md:py-16 bg-caramel-500">
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
                  "She's the sweetest and does everything she can to make the session as comfortable and enjoyable as
                  possible. She was encouraging throughout the session despite me not being comfortable in front of a
                  camera."
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
                  "Victoria was amazing to work with! She made our family feel so comfortable during our session and
                  captured the most beautiful photos. The pricing was very reasonable for the quality we received."
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

      <section className="py-12 md:py-16 px-4 max-w-5xl mx-auto">
        <div className="text-center mb-10">
          <h2 className="text-2xl sm:text-3xl font-semibold text-stone-800 mb-4">Frequently Asked Questions</h2>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-x-12 gap-y-8">
          <FaqItem
            question="How do I book a session with you?"
            answer="Booking is easy! Simply contact me through the contact form, email, or phone. We'll discuss your needs, select a package, and secure your date with a deposit and signed contract."
          />

          <FaqItem
            question="How far in advance should I book?"
            answer="For weddings, I recommend booking 6-12 months in advance. For portraits and other sessions, 2-4 weeks is usually sufficient, though peak seasons (fall, spring) book up quickly."
          />

          <FaqItem
            question="What is your payment policy?"
            answer="A non-refundable retainer of 25% is required to secure your date, with the remaining balance due one week before your session. For weddings, the final payment is due two weeks before the event."
          />

          <FaqItem
            question="How long until I receive my photos?"
            answer="Portrait sessions are delivered within 2 weeks. Weddings and events are delivered within 4-6 weeks. Rush delivery is available for an additional fee."
          />

          <FaqItem
            question="What happens if it rains on my session day?"
            answer="For outdoor sessions, we'll monitor the weather and reschedule if necessary at no additional cost. I'm flexible and want to ensure we get the best possible conditions for your photos."
          />

          <FaqItem
            question="Do you travel for sessions or weddings?"
            answer="Yes! I serve the entire San Antonio area at no additional cost. For locations beyond San Antonio, a travel fee applies."
          />
        </div>
      </section>
    </div>
  );
};

function FaqItem({ question, answer }) {
  return (
    <div className="space-y-2">
      <h3 className="text-lg font-semibold text-stone-800">{question}</h3>
      <p className="text-stone-600">{answer}</p>
    </div>
  );
};
