"use client";

import { createContext, useContext, useReducer } from "react";

export const INDIVIDUAL_AND_FAMILY_GALLERY = "Individual & Family Portraits";
export const ENGAGEMENT_AND_COUPLE_GALLERY = "Engagement & Couples Portraits";
export const CORPORATE_AND_COMMERCIAL_GALLERY = "Corporate & Commercial Portraits";
export const PRODUCT_GALLERY = "Product Portraits";
export const PET_AND_ANIMAL_GALLERY = "Pet & Animal Portraits";
export const GRADUATION_AND_SENIOR_GALLERY = "Graduation & Senior Portraits";

const AppointmentContext = createContext();

const initialState = {
  galleries: [],
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
  packageId: null,
  displayLocation: false,
  address: undefined
};

const appointmentReducer = (state, action) => {
  switch (action.type) {
    case "SET_GALLERIES":
      return { ...state, galleries: action.payload };
    case "SET_FIELD":
      return { ...state, [action.field]: action.value };
    case "TOGGLE_DISPLAY_DATE":
      return { ...state, displayDate: !state.displayDate };
    case "SET_SUBMITTING":
      return { ...state, isSubmitting: action.payload };
    case "SET_SUCCESS":
      return { ...state, isSuccess: true };
    case "TOGGLE_LOCATION":
      return { ...state, displayLocation: !state.displayLocation };
    case "POPULATE_ADDRESS_SUGGESTIONS":
      return { ...state, address: action.payload };
    case "RESET_FORM":
      return { ...initialState, galleries: state.galleries };
    default:
      return state;
  }
};

export function AppointmentProvider({ children, galleries = [] }) {
  const [state, dispatch] = useReducer(appointmentReducer, { ...initialState, galleries });

  return (
    <AppointmentContext.Provider value={{ state, dispatch }}>
      {children}
    </AppointmentContext.Provider>
  );
}

export function useAppointment() {
  return useContext(AppointmentContext);
}
