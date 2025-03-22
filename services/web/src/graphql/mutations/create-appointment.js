export const createAppointment = async (input) => {
  const apiUrl = process.env.RAILS_API_URL;

  const response = await fetch(apiUrl, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      query: `
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
      `,
      variables: { input }
    }),
  });

  const result = await response.json();
  const { data } = result

  if (!data || !data.createAppointment) {
    return { success: false, appointment: null, errors: ['Unexpected response from server'] };
  }

  const { appointment, errors } = data.createAppointment;

    if (errors.length > 0) {
      return { success: false, appointment: null, errors };
    }

    return { success: true, appointment, errors: [] };
};
