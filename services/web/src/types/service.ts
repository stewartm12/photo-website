import type { Photo } from "./photo";

type Package = {
  id: string;
  name: string;
  price: number;
  popular: boolean;
  duration: number;
  features: string[];
}

type AddOn = {
  id: string;
  name: string;
  price: string;
}

export type ServiceProps = {
  id: string;
  name: string;
  description: string;
  photo: Photo;
  packages: Package[];
  addOns: AddOn[];
}

export type ServiceResponse = ServiceProps[] & {
  services: ServiceProps[]
}
