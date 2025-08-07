import type { NavItem, BaseMenuItem } from "@/lib/nav-items";
import { Fragment } from "react"
import { Separator } from "@/components/ui/separator";
import { Menu, ChevronDown } from 'lucide-react';
import { Button } from "@/components/ui/button";
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
import Link from "next/link";

type MobileNavProps = {
  isOpen: boolean;
  setIsOpen: (open: boolean) => void;
  items: NavItem[];
  openCollapsible: string | null;
  setOpenCollapsible: (val: string | null) => void;
};

export default function MobileNav({ isOpen, setIsOpen, items, openCollapsible, setOpenCollapsible }: MobileNavProps) {
  const toggleCollapsible = (name: string | null) => {
    setOpenCollapsible(openCollapsible === name ? null : name);
  };

  return (
    <Sheet open={isOpen} onOpenChange={setIsOpen}>
      <SheetTrigger asChild>
        <Button variant="ghost" size="icon">
          <Menu className="h-5 w-5" />
          <span className="sr-only">Toggle menu</span>
        </Button>
      </SheetTrigger>
      <SheetContent side="right" className="w-[300px] sm:w-[400px]" aria-describedby={undefined}>
        <SheetHeader>
          <SheetTitle>Victoria&#39;s Photography</SheetTitle>
          <SheetDescription>Navigation Menu</SheetDescription>
        </SheetHeader>
        <nav className="flex flex-col gap-4 mt-6">
          {items.map((item) => {
            if ('hasDropDownItem' in item && item.hasDropDownItem) {
              return (
                <Fragment key={item.title}>
                  <Collapsible
                    open={openCollapsible === item.title}
                    onOpenChange={() => toggleCollapsible(item.title)}
                    className="w-full"
                  >
                    <CollapsibleTrigger asChild>
                      <Button variant="ghost" className="w-full justify-between px-2 text-lg font-normal">
                        {item.title}
                        <ChevronDown
                          className={`h-4 w-4 transition-transform ${
                            openCollapsible === item.title ? 'rotate-180' : ''
                          }`}
                        />
                      </Button>
                    </CollapsibleTrigger>
                    <CollapsibleContent className="pl-4 space-y-2 mt-2">
                      {item.submenu?.map((subItem: BaseMenuItem) => (
                        <Link
                          key={subItem.title}
                          href={subItem.href}
                          className="block px-2 text-base"
                          onClick={() => setIsOpen(false)}
                        >
                          {subItem.title}
                        </Link>
                      ))}
                    </CollapsibleContent>
                  </Collapsible>
                  <Separator />
                </Fragment>
              );
            }

            return (
              <Fragment key={item.title}>
                <Link
                  href={item.href}
                  className="block px-2 text-lg"
                  onClick={() => setIsOpen(false)}
                >
                  {item.title}
                </Link>
                <Separator />
              </Fragment>
            );
          })}
        </nav>
      </SheetContent>
    </Sheet>
  )
};
