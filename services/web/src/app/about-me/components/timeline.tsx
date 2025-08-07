import type { ReactNode } from "react";
import { Camera, Heart, Globe, BookOpen, Calendar, Sparkles } from "lucide-react";

type TimelineItemProps = {
  year: string;
  title: string;
  description: string;
  side: string;
  icon: ReactNode; 
}

export default function Timeline() {
  return (
    <div className="max-w-4xl mx-auto">
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
  )
};

// Timeline Item Component
function TimelineItem({ year, title, description, icon, side }: TimelineItemProps) {
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
        <div className="w-12 h-12 rounded-full bg-blue-900 text-white flex items-center justify-center z-10">
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