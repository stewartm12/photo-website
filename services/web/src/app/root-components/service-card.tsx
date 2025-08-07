import { Card, CardContent, CardFooter } from "@/components/ui/card";
import { ArrowRight } from "lucide-react";
import { Button } from "@/components/ui/button";
import Link from "next/link";
import Image from "next/image";

type ServiceCardProps = {
  imgUrl: string;
  title: string;
  description: string;
  link: string;
};

export default function ServiceCard({ imgUrl, title, description, link }: ServiceCardProps) {
  return (
    <Link href={link} className="group">
      <Card className="overflow-hidden transition-all duration-300 hover:shadow-xl max-w-xs mx-auto bg-black">
        <div className="relative overflow-hidden aspect-square">
          <Image
            src={imgUrl}
            alt={title}
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
            Learn More <ArrowRight className="ml-2 h-4 w-4 transition-transform group-hover:translate-x-1" />
          </Button>
        </CardFooter>
      </Card>
    </Link>
  );
};
