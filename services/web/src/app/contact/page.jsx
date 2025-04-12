import { AppointmentProvider } from "@/context/appointment-context";
import { galleryPackageData } from "@/graphql/queries/galleries";
import { showcaseQuery } from "@/graphql/queries/showcases";
import AppointmentForm from "./components/appointment-form";
import Image from "next/image";

async function getContactPagePhotos() {
  try {
    const galleries = await galleryPackageData();
    const contactPagePhotos = await showcaseQuery("contact");
    const formPhoto = contactPagePhotos.photos[0];

    return { galleries, formPhoto }
  } catch (err) {
    console.error("Failed to fetch homepage photos:", err);
    return {
      galleries: [],
      formPhoto: {}
    }
  }
}

export default async function Contact() {
  const {galleries, formPhoto} = await getContactPagePhotos();

  return (
    <AppointmentProvider galleries={galleries} >
      <div className="pt-12">
      <section className="mb-12">
        <h1 className="text-3xl md:text-5xl font-bold text-center mb-4 bg-gradient-to-r from-gray-800 to-gray-600 bg-clip-text text-transparent">
          Let's Connect & Plan Your Perfect Photoshoot
        </h1>
        <p className="text-center text-gray-600 max-w-2xl mx-auto">
          Fill out the form below to start the booking process. I'll get back to you within 24 hours to confirm details.
        </p>
        <hr className="my-8 border-t border-gray-200 w-1/2 mx-auto" />
      </section>

      <section className="mb-16">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 place-content-around items-start">
          <div className="w-[85%] justify-self-center">
            <AppointmentForm />
          </div>
          <div className="flex justify-center justify-self-center w-full">
            <div className="relative aspect-[3/4] w-[85%] max-h-full rounded-lg overflow-hidden shadow-2xl transform transition-transform hover:scale-[1.01]">
              <Image
                src={`${process.env.NEXT_PUBLIC_AWS_S3_URL}/${formPhoto.fileKey}`}
                className="object-cover"
                fill
                sizes="(max-width: 768px) 100vw, 50vw"
                alt="Victoria Gonzales Photography"
              />
            </div>
          </div>
        </div>
      </section>

      <hr className="my-12 border-t border-gray-200 w-3/4 mx-auto" />

      <section className="mb-16">
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
      </section>

      <hr className="my-12 border-t border-gray-200 w-3/4 mx-auto" />
      </div>
    </AppointmentProvider>
  );
};
