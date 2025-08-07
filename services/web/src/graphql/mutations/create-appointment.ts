import { fetchData } from "@/utils/fetch-data";

type CreateAppointmentInput = {
  firstName: string;
  lastName: string;
  email: string;
  phoneNumber: string;
  additionalNotes?: string;
  packageId: number;
  address?: string;
  preferredDateTime?: string;
  addOnIds?: number[];
};

type CreateAppointmentResponse = {
  data?: {
    createAppointment?: {
      appointment: unknown;
      errors: unknown[]
    }
  }
}

export const createAppointment = async (input: CreateAppointmentInput) => {
  const mutation = `
    mutation CreateAppointment($input: CreateAppointmentInput!) {
      createAppointment(input: $input) {
        appointment {
          id
          customer {
            firstName
            lastName
            email
            phoneNumber
          }
        }
        errors
      }
    }
  `;

  const result: CreateAppointmentResponse = await fetchData(mutation, { input });

const data = result.data;

  if (!data || !data.createAppointment) {
    return { success: false, appointment: null, errors: ['Unexpected response from server'] };
  }

  const { appointment, errors } = data.createAppointment;

  if (errors.length > 0) {
    return { success: false, appointment: null, errors };
  }

  return { success: true, appointment, errors: [] };
};
