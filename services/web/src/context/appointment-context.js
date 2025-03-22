"use client";

import { createContext, useContext, useState } from "react";

export const INDIVIDUAL_AND_FAMILY_GALLERY = "Individual & Family Portraits";
export const ENGAGEMENT_AND_COUPLE_GALLERY = "Engagement & Couples Portraits";
export const CORPORATE_AND_COMMERCIAL_GALLERY = "Corporate & Commercial Portraits";
export const PRODUCT_GALLERY = "Product Portraits";
export const PET_AND_ANIMAL_GALLERY = "Pet & Animal Portraits";
export const GRADUATION_AND_SENIOR_GALLERY = "Graduation & Senior Portraits";

const AppointmentContext = createContext();

export function AppointmentProvider({ children, galleries }) {
  const [formData, setFormData] = useState({
    galleries: galleries,
    galleryId: null,
    firstName: "",
    lastName: "",
    email: "",
    phoneNumber: "",
    displayDate: false,
    isSubmitting: false,
    isSuccess: false,
    preferredDateTime: undefined,
    additionalNotes: "",
    addOns: [],
    packageId: null
  });

  return (
    <AppointmentContext.Provider value={{ formData, setFormData }}>
      {children}
    </AppointmentContext.Provider>
  );
}

export function useAppointment() {
  return useContext(AppointmentContext);
}
