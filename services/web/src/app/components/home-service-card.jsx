"use client";

import Link from "next/link";
import Image from "next/image";
import { Card, CardContent, CardFooter } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { ArrowRight } from "lucide-react";

export default function ServiceCard({ imgSrc, title, description, link }) {
  const imageLoader = ({ src, width, quality }) => {
    return `${process.env.NEXT_PUBLIC_AWS_S3_URL}/${src}?w=${width}&q=${quality || 100}`
  };

  return (
    <Link href={link} className="group">
      <Card className="overflow-hidden transition-all duration-300 hover:shadow-xl max-w-xs mx-auto bg-caramel-400">
        <div className="relative overflow-hidden aspect-square">
          <Image
            src={`${imgSrc}`}
            alt={title}
            loader={imageLoader}
            fill
            sizes="(max-width: 640px) 90vw, 352px"
            className="object-cover transition-transform duration-500 group-hover:scale-105"
          />
        </div>
        <CardContent className="p-6 text-center">
          <h3 className="text-xl font-semibold text-white mb-2">{title}</h3>
          <p className="text-white">{description}</p>
        </CardContent>
        <CardFooter className="pt-0 pb-6 flex justify-center">
          <Button variant="ghost" className="text-white cursor-pointer">
            Learn More <ArrowRight className="ml-2 h-4 w-4 transition-transform group-hover:translate-x-1" /> {/* Replace with dynamic link to contact page */}
          </Button>
        </CardFooter>
      </Card>
    </Link>
  );
}