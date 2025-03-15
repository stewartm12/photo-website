export const galleryNavItems= (galleries) => {
  return galleries.map((gallery) => {
    return {
      name: gallery.name,
      href: `/galleries/${gallery.slug}`,
    }
  });
};

export const navItems = (galleries) => {
  return [
    { name: "Home", href: "/" },
    {
      name: "Gallery",
      href: "/galleries",
      hasSubmenu: true,
      submenu: galleryNavItems(galleries),
    },
    { name: "Services", href: "/services" },
    { name: "About Me", href: "/about-me" },
    { name: "Contact", href: "/contact" },
  ];
};
