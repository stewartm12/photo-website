"use client"

import { useState, Fragment } from "react"
import { navItems } from '@/utils/navbar-items';
import { usePathname } from 'next/navigation';
import { Menu, ChevronDown } from 'lucide-react';
import { Button } from "@/components/ui/button";
import { Separator } from "@/components/ui/separator";
import {
  Sheet,
  SheetContent,
  SheetTrigger,
  SheetTitle,
  SheetHeader,
  SheetDescription,
} from "@/components/ui/sheet";
import {
  Collapsible,
  CollapsibleContent,
  CollapsibleTrigger
} from "@/components/ui/collapsible";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger
} from "@/components/ui/dropdown-menu";
import Link from "next/link";
import Image from "next/image";

export default function Navbar({ galleries=[], logo={} }) {
  const [isOpen, setIsOpen] = useState(false)
  const [openCollapsible, setOpenCollapsible] = useState(null)
  const pathname = usePathname()

  const toggleCollapsible = (name) => {
    setOpenCollapsible(openCollapsible === name ? null : name)
  }

  const galleryNavItems = navItems(galleries)

  return (
    <nav className="flex items-center justify-between h-16 px-4 border-b border-stone-800 bg-black text-white shadow-md">
      <Link href="/" className="mr-6 flex items-center space-x-2">
        <Image src={logo.imageUrl} alt="pics by tori logo" width={50} height={50} style={{ objectFit: 'contain' }} priority/>
      </Link>
        <h1 style={{ fontFamily: '"Chiron Sung HK", serif' }} className={`hidden sm:block font-extrabold tracking-wider text-center text-2xl md:text-3xl drop-shadow-md`}>
          Victoria Gonzales Photography
        </h1>
      <div className="flex items-center justify-end">
        <div className="mr-4 hidden md:flex">
          <div className="flex items-center space-x-4 text-sm font-medium">
          {galleryNavItems?.map((item) =>
              item.hasSubmenu ? (
                <DropdownMenu key={item.name}>
                  <DropdownMenuTrigger
                    className={`flex items-center cursor-pointer hover:underline ${pathname === item.href ? "underline" : ""}`}
                  >
                    {item.name} <ChevronDown className="ml-1 h-4 w-4" />
                  </DropdownMenuTrigger>
                  <DropdownMenuContent align="start" className="w-56">
                    {item.submenu?.map((subItem) => (
                      <Link key={subItem.name} href={subItem.href} className="w-full">
                        <DropdownMenuItem className="cursor-pointer">{subItem.name}</DropdownMenuItem>
                      </Link>
                    ))}
                  </DropdownMenuContent>
                </DropdownMenu>
              ) : (
                <Link
                  key={item.name}
                  href={item.href}
                  className={`transition-colors hover:underline ${pathname === item.href ? "underline" : ""}`}
                >
                  {item.name}
                </Link>
              ),
            )}
          </div>
        </div>
        <div className="">
          <div className="md:hidden">
            <Sheet open={isOpen} onOpenChange={setIsOpen}>
              <SheetTrigger asChild>
                <Button variant="ghost" size="icon" className="md:hidden">
                  <Menu className="h-5 w-5" />
                  <span className="sr-only">Toggle menu</span>
                </Button>
              </SheetTrigger>
              <SheetContent side="right" className="w-[300px] sm:w-[400px]" aria-describedby={undefined}>
                <SheetHeader>
                  <SheetTitle>Victoria's Photography</SheetTitle>
                  <SheetDescription>Navigation Menu</SheetDescription>
                </SheetHeader>
                <nav className="flex flex-col gap-4 mt-6">
                  {galleryNavItems && galleryNavItems.map((item, index) => (
                    <Fragment key={item.name}>
                      {item.hasSubmenu ? (
                        <Collapsible
                          open={openCollapsible === item.name}
                          onOpenChange={() => toggleCollapsible(item.name)}
                          className="w-full"
                        >
                          <CollapsibleTrigger asChild>
                            <Button variant="ghost" className="w-full justify-between px-2 text-lg font-normal">
                              {item.name}
                              <ChevronDown
                                className={`h-4 w-4 transition-transform ${openCollapsible === item.name ? "rotate-180" : ""}`}
                              />
                            </Button>
                          </CollapsibleTrigger>
                          <CollapsibleContent className="pl-4 space-y-2 mt-2">
                            {item.submenu?.map((subItem) => (
                              <Link
                                key={subItem.name}
                                href={subItem.href}
                                className="block px-2 py-1 text-base"
                                onClick={() => setIsOpen(false)}
                              >
                                {subItem.name}
                              </Link>
                            ))}
                          </CollapsibleContent>
                        </Collapsible>
                      ) : (
                        <Link href={item.href} className="block px-2 py-1 text-lg" onClick={() => setIsOpen(false)}>
                          {item.name}
                        </Link>
                      )}
                      {index < navItems.length - 1 && <Separator />}
                    </Fragment>
                  ))}
                </nav>
              </SheetContent>
            </Sheet>
          </div>
        </div>
      </div>
    </nav>
  );
};