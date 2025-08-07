"use client";

import type { ChangeEvent } from "react";
import { useState, useEffect, useRef, useCallback } from "react";
import { useAppointment } from "@/context/appointment-context";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Command, CommandEmpty, CommandGroup, CommandItem, CommandList } from "@/components/ui/command";
import { Loader2, MapPin } from "lucide-react";

type Address = {
  address: string;

}

export default function LocationSearchInput() {
  const { dispatch } = useAppointment();
  const [open, setOpen] = useState(false);
  const [searchQuery, setSearchQuery] = useState("");
  const [selectedAddress, setSelectedAddress] = useState("");
  const [suggestions, setSuggestions] = useState<Address[]>([]);
  const [loading, setLoading] = useState(false);
  const inputRef = useRef<HTMLInputElement>(null);
  const justSelectedRef = useRef(false);

  const searchLocations = useCallback(async (query: string) => {
    if (!query.trim()) return;

    setLoading(true);
    try {
      const response = await fetch(`/api/locations?query=${encodeURIComponent(query)}`);
      const data = await response.json();

      setSuggestions(data.locations.autocompleteLocation);
      setOpen(true);
    } catch (error) {
      console.error("Error fetching location suggestions:", error);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    // Prevent search after selecting an address
    if (justSelectedRef.current) {
      justSelectedRef.current = false;
      return;
    }

    if (searchQuery.trim().length >= 5) {
      const timeoutId = setTimeout(() => {
        searchLocations(searchQuery);
      }, 1000);

      return () => clearTimeout(timeoutId);
    } else {
      setSuggestions([]);
      setOpen(false);
    }
  }, [searchQuery, searchLocations]);

  const handleInputChange = (e: ChangeEvent<HTMLInputElement>) => {
    const value = e.target.value;
    setSearchQuery(value);
    setSelectedAddress(value);
  };

  const handleSelectLocation = (location: Address) => {
    justSelectedRef.current = true;
    setSelectedAddress(location.address);
    setSearchQuery(location.address);
    dispatch({ type: "SET_FIELD", field: "address", value: location.address });
    setOpen(false);
    setSuggestions([]);
    inputRef.current?.focus();
  };

  return (
    <div className="space-y-2 relative">
      <Label htmlFor="address">Location Address</Label>
      <div className="relative">
        <Input
          ref={inputRef}
          id="address"
          name="address"
          value={selectedAddress}
          onChange={handleInputChange}
          autoComplete="true"
          placeholder="123 Studio St, City, Country"
          className="focus-visible:ring-primary w-full"
          required
        />
        {loading && (
          <div className="absolute right-3 top-1/2 -translate-y-1/2">
            <Loader2 className="h-4 w-4 animate-spin text-muted-foreground" />
          </div>
        )}
      </div>

      {open && suggestions.length > 0 && (
        <div className="absolute z-10 w-full">
          <Command className="rounded-lg border shadow-md">
            <CommandList>
              <CommandEmpty>No locations found.</CommandEmpty>
              <CommandGroup heading="Suggestions">
                {suggestions.map((location) => (
                  <CommandItem
                    key={location.address}
                    onSelect={() => handleSelectLocation(location)}
                    className="flex items-center gap-2 cursor-pointer"
                  >
                    <MapPin className="h-4 w-4 text-muted-foreground" />
                    <span>{location.address}</span>
                  </CommandItem>
                ))}
              </CommandGroup>
            </CommandList>
          </Command>
        </div>
      )}
    </div>
  );
};
