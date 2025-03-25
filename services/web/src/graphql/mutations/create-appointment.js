import { fetchData } from "@/utils/fetch-data";

export const createAppointment = async (input) => {
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

  const result = await fetchData(mutation, { input });

  const { data } = result;

  if (!data || !data.createAppointment) {
    return { success: false, appointment: null, errors: ['Unexpected response from server'] };
  }

  const { appointment, errors } = data.createAppointment;

  if (errors.length > 0) {
    return { success: false, appointment: null, errors };
  }

  return { success: true, appointment, errors: [] };
};
