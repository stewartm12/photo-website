"use client";

import { createContext, useContext, useReducer, ReactNode, Dispatch } from "react";
import type { ServiceProps } from "@/types/service"

// Types
type AppointmentState = {
  galleries: ServiceProps[];
  galleryId?: string;
  firstName: string;
  lastName: string;
  email: string;
  phoneNumber: string;
  displayDate: boolean;
  isSubmitting: boolean;
  isSuccess: boolean;
  preferredDateTime?: string;
  additionalNotes: string;
  addOns: string[];
  packageId?: string;
  displayLocation: boolean;
  address?: string;
};

type AppointmentAction =
  | { type: "SET_GALLERIES"; payload: ServiceProps[] }
  | { type: "SET_FIELD"; field: keyof AppointmentState; value: unknown }
  | { type: "TOGGLE_DISPLAY_DATE" }
  | { type: "SET_SUBMITTING"; payload: boolean }
  | { type: "SET_SUCCESS" }
  | { type: "TOGGLE_LOCATION" }
  | { type: "POPULATE_ADDRESS_SUGGESTIONS"; payload: string }
  | { type: "RESET_FORM" };

export type AppointmentContextType = {
  state: AppointmentState;
  dispatch: Dispatch<AppointmentAction>;
};

// Initial State
const initialState: AppointmentState = {
  galleries: [],
  galleryId: undefined,
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
  packageId: undefined,
  displayLocation: false,
  address: undefined,
};

// Reducer
const appointmentReducer = (state: AppointmentState, action: AppointmentAction): AppointmentState => {
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

// Context
const AppointmentContext = createContext<AppointmentContextType | null>(null);

// Provider
type AppointmentProviderProps = {
  children: ReactNode;
  galleries?: ServiceProps[];
  galleryId?: string;
  packageId?: string;
};

export function AppointmentProvider({ children, galleries = [], galleryId, packageId }: AppointmentProviderProps) {
  const [state, dispatch] = useReducer(appointmentReducer, { ...initialState, galleries, galleryId, packageId });

  return (
    <AppointmentContext.Provider value={{ state, dispatch }}>
      {children}
    </AppointmentContext.Provider>
  );
}

// Hook
export function useAppointment(): AppointmentContextType {
  const context = useContext(AppointmentContext);
  if (!context) {
    throw new Error("useAppointment must be used within an AppointmentProvider");
  }
  return context;
}
