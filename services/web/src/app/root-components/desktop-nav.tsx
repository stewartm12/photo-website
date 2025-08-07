'use client';

import type { ComponentPropsWithoutRef } from "react";
import type { NavItem, BaseMenuItem } from "@/lib/nav-items";
import {
  NavigationMenu,
  NavigationMenuList,
  NavigationMenuItem,
  NavigationMenuTrigger,
  NavigationMenuContent,
  NavigationMenuLink,
} from '@/components/ui/navigation-menu';
import { navigationMenuTriggerStyle } from '@/components/ui/navigation-menu';
import Link from 'next/link';

type DesktopNavProps = {
  items: NavItem[];
  pathname: string;
}

type listItemProps = ComponentPropsWithoutRef<"li"> & {
  href: string
}

export default function DesktopNav({ items, pathname }: DesktopNavProps) {
  return (
    <NavigationMenu viewport={false} className="z-100">
      <NavigationMenuList>
        {items.map((item, index) => {
          if ('hasDropDownItem' in item && item.hasDropDownItem) {
            return (
              <NavigationMenuItem key={index}>
                <NavigationMenuTrigger>{item.title}</NavigationMenuTrigger>
                <NavigationMenuContent>
                  <ul className="grid w-[300px] gap-4">
                    {item.submenu.map((subItem: BaseMenuItem, index) => (
                      <ListItem href={subItem.href} title={subItem.title} key={index}>
                        {subItem.description}
                      </ListItem>
                    ))}
                  </ul>
                </NavigationMenuContent>
              </NavigationMenuItem>
            );
          }

          return (
            <NavigationMenuItem key={item.title}>
              <NavigationMenuLink asChild className={navigationMenuTriggerStyle()}>
                <Link
                  href={item.href}
                  className={`transition-colors hover:underline ${pathname === item.href ? 'underline' : ''}`}
                >
                  {item.title}
                </Link>
              </NavigationMenuLink>
            </NavigationMenuItem>
          );
        })}
      </NavigationMenuList>
    </NavigationMenu>
  );
}

function ListItem({ title, children, href, ...props }: listItemProps) {
  return (
    <li {...props}>
      <NavigationMenuLink asChild>
        <Link href={href}>
          <div className="text-sm leading-none font-medium">{title}</div>
          <p className="text-muted-foreground line-clamp-2 text-sm leading-snug">
            {children}
          </p>
        </Link>
      </NavigationMenuLink>
    </li>
  )
};
