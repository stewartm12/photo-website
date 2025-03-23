import { NextResponse } from 'next/server';
import { createAppointment } from "@/graphql/mutations/create-appointment"

export async function POST(request) {
  try {
    const params = await request.json();
    
    const formattedParams = {
      firstName: params.firstName,
      lastName: params.lastName,
      email: params.email,
      phoneNumber: params.phoneNumber,
      additionalNotes: params.additionalNotes,
      packageId: parseInt(params.packageId),
      address: params.address
    };

    if (params.displayDate && params.preferredDateTime) {
      formattedParams.preferredDateTime = params.preferredDateTime;
    }

    if (params.displayLocation && params.address) {
      formattedParams.address = params.address;
    }

    if (params.addOns) {
      formattedParams.addOnIds = params.addOns.map(addOn => parseInt(addOn.value));
    }

    const response = await createAppointment(formattedParams);

    if (!response.success) {
      return NextResponse.json(
        { message: 'Failed to create appointment', errors: response.errors },
        { status: 400 }
      );
    }

    return NextResponse.json(
      { message: 'Appointment created successfully', data: response.appointment },
      { status: 201 }
    );
  } catch (error) {
    console.error("Error creating appointment:", error);

    return NextResponse.json(
      { message: 'Internal server error' },
      { status: 500 }
    );
  }
}
