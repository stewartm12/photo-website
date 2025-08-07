"use client"

import type { Gallery } from "@/types/gallery";
import { useState } from "react"
import { usePathname } from 'next/navigation';
import { navItems } from "@/lib/nav-items"
import Link from "next/link"
import Image from "next/image"
import MobileNav from "./mobile-nav";
import DesktopNav from "./desktop-nav";

type NavBarProps = {
  galleries: Gallery[];
  logo: {
    imageUrl: string;
  };
};

export default function NavBar({ galleries, logo }: NavBarProps) {
  const [isOpen, setIsOpen] = useState<boolean>(false);
  const [openCollapsible, setOpenCollapsible] = useState<string | null>(null);
  const pathname = usePathname();
  const galleryNavItems = navItems(galleries);

  return (
    <nav  className="flex items-center justify-between h-16 px-4 border-b border-stone-800">
      <Link href="/" className="mr-6 flex items-center space-x-2">
        <Image src={logo.imageUrl} alt="pics by tori logo" width={50} height={50} style={{ objectFit: 'contain' }} priority/>
      </Link>
      <h1 className={`hidden sm:block font-extrabold tracking-wider text-center text-2xl md:text-3xl drop-shadow-md`}>
        Victoria Gonzales Photography
      </h1>
      <div className="flex items-center justify-end">
        <div className="mr-4 hidden md:flex navbar">
          <div className="flex items-center space-x-4 text-sm font-medium">
            <DesktopNav items={galleryNavItems} pathname={pathname} />
          </div>
        </div>
        <div className="md:hidden">
          <MobileNav
            isOpen={isOpen}
            setIsOpen={setIsOpen}
            items={galleryNavItems}
            openCollapsible={openCollapsible}
            setOpenCollapsible={setOpenCollapsible}
          />
        </div>
      </div>
    </nav>
  )
};
