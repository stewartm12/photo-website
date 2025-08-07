import type { Gallery } from "@/types/gallery";

export type BaseMenuItem = {
  title: string;
  href: string;
  description?: string;
};

type DropdownNavItem = BaseMenuItem & {
  hasDropDownItem: boolean;
  submenu: BaseMenuItem[];
};

export type NavItem = BaseMenuItem | DropdownNavItem;

export const baseMenuItems = (galleries: Gallery[]): BaseMenuItem[] => {
  return galleries.map((gallery) => ({
    title: gallery.name,
    href: `/galleries/${gallery.slug}`,
    description: gallery.description,
  }));
};

export const navItems = (galleries: Gallery[]): NavItem[] => {
  return [
    { title: "Home", href: "/" },
    {
      title: "Gallery",
      href: "/galleries",
      hasDropDownItem: true,
      submenu: baseMenuItems(galleries),
    },
    { title: "Services", href: "/services" },
    { title: "About Me", href: "/about-me" },
    { title: "Appointment", href: "/appointment" },
  ];
};
