import Link from "next/link"
import { SiInstagram } from '@icons-pack/react-simple-icons';

export default function Footer() {
  return (
    <footer className="bg-blue-900 text-white">
      <div className="max-w-7xl mx-auto px-4 py-8 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
          {/* Logo and Tagline */}
          <div className="flex flex-col items-center md:items-start">
            <h2 className="text-2xl font-bold text-white mb-2 underline">Victoria&#39;s Photography</h2>
            <p className="text-sm text-gray-400 text-center md:text-left">Capturing life&#39;s precious moments</p>
          </div>

          {/* Quick Links */}
          <div className="flex flex-col items-center md:items-start">
            <h3 className="text-lg font-semibold text-white mb-4 underline">Quick Links</h3>
            <nav className="flex flex-col space-y-2">
              <Link href="/services" className="hover:text-white transition-colors">
                Services
              </Link>
              <Link href="/about" className="hover:text-white transition-colors">
                About Me
              </Link>
              <Link href="/appointment" className="hover:text-white transition-colors">
                Contact
              </Link>
            </nav>
          </div>

          {/* Contact Information */}
          <div className="flex flex-col items-center md:items-start">
            <h3 className="text-lg font-semibold text-white mb-4 underline">Let&#39;s Connect</h3>
            <p className="text-sm text-gray-400 mb-2">Serving the San Antonio, TX area</p>
            <Link href="/appointment" className="transition-colors">
              Make an appointment
            </Link>
          </div>
        </div>

        {/* Social Media and Copyright */}
        <div className="mt-8 pt-8 border-t border-black flex flex-col md:flex-row justify-between items-center">
          <div className="flex space-x-4 mb-4 md:mb-0">
            <a
              href="https://instagram.com"
              target="_blank"
              rel="noopener noreferrer"
              className="hover:text-white transition-colors"
            >
              <SiInstagram className="w-6 h-6" />
            </a>
            {/* <a
              href="https://facebook.com"
              target="_blank"
              rel="noopener noreferrer"
              className="hover:text-white transition-colors"
            >
              <SiFacebook className="w-6 h-6" />
            </a>
            <a
              href="https://twitter.com"
              target="_blank"
              rel="noopener noreferrer"
              className="hover:text-white transition-colors"
            >
              <SiX className="w-6 h-6" />
            </a> */}
          </div>
          <p className="text-sm text-gray-400">
            © {new Date().getFullYear()} Victoria&#39;s Photography. All rights reserved.
          </p>
        </div>
      </div>
    </footer>
  )
}
