"use client"

import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card"
import { useAppointment } from "@/context/appointment-context";
import { Checkbox } from "@/components/ui/checkbox"
import { Textarea } from "@/components/ui/textarea"
import { Button } from "@/components/ui/button"
import { Label } from "@/components/ui/label"
import { Input } from "@/components/ui/input"
import { CheckCircle } from "lucide-react"
import { toast } from "sonner"
import { DateTimePicker } from "@/shared/date-time-picker";
import MultipleSelector from "@/shared/multiple-selector";
import SearchLocation from "./search-location";

export default function AppointmentForm() {
  const { state, dispatch } = useAppointment();

  const galleryPackageData = () => state.galleries.find(obj => obj.id == state.galleryId);

  const formatAddOnData = () => {
    const gallery = state.galleries.find(obj => obj.id == state.galleryId);

    return gallery?.addOns?.map(addOn => ({
      label: `${addOn.name} ($${parseFloat(addOn.price).toFixed(2)})`,
      value: addOn.id,
    })) || [];
  };

  const handleSubmit = async (e) => {
    e.preventDefault()

    if (!state.galleryId) {
      return toast.warning('Please select a gallery.')
    }

    dispatch({ type: "SET_FIELD", field: "isSubmitting", value: true })

    try {
      const response = await fetch("/api/appointment", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(state),
      })

      if (response.ok) {
        dispatch({type: 'SET_SUCCESS'})
      } else {
        toast.error("Something went wrong. Your appointment couldn't be submitted. Please try again.")
      }
    } catch (error) {
      console.error("Error:", error)
      toast.error("An unexpected error occurred. Please try again later.")
    } finally {
      dispatch({ type: "SET_FIELD", field: "isSubmitting", value: false })
    }
  }

  if (state.isSuccess) {
    return (
      <Card className="w-full max-w-md mx-auto shadow-lg">
        <CardContent className="pt-6">
          <div className="flex flex-col items-center justify-center space-y-4 text-center">
            <CheckCircle className="h-16 w-16 text-green-500" />
            <CardTitle className="text-2xl">Appointment Submitted!</CardTitle>
            <CardDescription className="text-base">
              Thank you for your appointment request. We'll be in touch with you soon to confirm the details.
            </CardDescription>
            <Button onClick={() => dispatch({ type: "RESET_FORM" })} className="mt-4">
              Make Another Appointment
            </Button>
          </div>
        </CardContent>
      </Card>
    )
  }

  return (
    <Card className="mx-auto shadow-lg border-0 sm:border">
      <CardHeader className="space-y-1">
        <CardTitle className="text-2xl font-bold text-center">Book Your Session</CardTitle>
        <CardDescription className="text-center">Fill out the form below to request your photoshoot</CardDescription>
      </CardHeader>
      <CardContent>
        <form onSubmit={handleSubmit} className="space-y-4">
          <div className="space-y-2">
            <Label htmlFor="firstName">First Name</Label>
            <Input
              id="firstName"
              name="firstName"
              value={state.firstName}
              onChange={(e) => dispatch({ type: "SET_FIELD", field: "firstName", value: e.target.value })}
              placeholder="Jane"
              className="focus-visible:ring-primary"
              required
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="lastName">Last Name</Label>
            <Input
              id="lastName"
              name="lastName"
              value={state.lastName}
              onChange={(e) => dispatch({ type: "SET_FIELD", field: "lastName", value: e.target.value })}
              placeholder="Doe"
              className="focus-visible:ring-primary"
              required
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="email">Email</Label>
            <Input
              id="email"
              name="email"
              type="email"
              value={state.email}
              onChange={(e) => dispatch({ type: "SET_FIELD", field: "email", value: e.target.value })}
              placeholder="jane@example.com"
              className="focus-visible:ring-primary"
              autoComplete="true"
              required
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="phoneNumber">Phone Number</Label>
            <Input
              id="phoneNumber"
              name="phoneNumber"
              type="tel"
              value={state.phoneNumber}
              onChange={(e) => dispatch({ type: "SET_FIELD", field: "phoneNumber", value: e.target.value })}
              className="focus-visible:ring-primary"
              pattern="^\+?[1-9]\d{1,14}$"
              placeholder="+1234567890"
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="gallery-select">Session Type</Label>
            <Select
              name="gallerySelect"
              value={state.galleryId ?? undefined}
              onValueChange={(value) => dispatch({ type: "SET_FIELD", field: "galleryId", value: value })}
              >
              <SelectTrigger className="focus-visible:ring-primary"  id="gallery-select">
                <SelectValue placeholder="Select a session" />
              </SelectTrigger>
              <SelectContent>
                {state.galleries.map(gallery => (
                    <SelectItem key={gallery.id} value={gallery.id}>
                      {gallery.name}
                    </SelectItem>
                  )
                )}
              </SelectContent>
            </Select>
          </div>

          {state.galleryId && (
            <div className="space-y-2">
              <Label htmlFor="gallery-select">Packages</Label>
              <Select value={state.packageId} onValueChange={(value) => dispatch({ type: "SET_FIELD", field: "packageId", value: value })} name="gallerySelect">
                <SelectTrigger className="focus-visible:ring-primary w-[180px]"  id="gallery-select">
                  <SelectValue placeholder="Select a package" />
                </SelectTrigger>
                <SelectContent>
                  {galleryPackageData().packages.map(pkg => (
                      <SelectItem key={pkg.id} value={pkg.id}>
                        {pkg.name}
                      </SelectItem>
                    )
                  )}
                </SelectContent>
              </Select>
            </div>
          )}

          {state.galleryId && (
            <div className='space-y-2'>
              <span className='flex items-center gap-2 text-sm leading-none font-medium select-none'>
                Add On ( If Applicable)
                </span>
              <MultipleSelector
                defaultOptions={formatAddOnData()}
                onChange={(value) => dispatch({ type: "SET_FIELD", field: "addOns", value: value })}
                placeholder="Select an add on"
              />
            </div>
          )}

          <div className="flex justify-around">
            <div className="flex items-center">
              <Checkbox
                id="displayDate"
                name="displayDate"
                checked={state.displayDate}
                onCheckedChange={() => dispatch({ type: "TOGGLE_DISPLAY_DATE" })}
                className="mr-2"
              />
              <Label htmlFor="displayDate">Date Available? (If Applicable)</Label>
            </div>
            <div className="flex items-center">
              <Checkbox
                id="displayLocation"
                name="displayLocation"
                checked={state.displayLocation}
                onCheckedChange={() => dispatch({ type: "TOGGLE_LOCATION" })}
                className="mr-2"
              />
              <Label htmlFor="displayLocation">Location Available? (If Applicable)</Label>
            </div>
          </div>

          {state.displayDate && (
            <div className="space-y-2">
              <Label className="block pb-2">Preferrable Date
                <DateTimePicker
                  hourCycle={12}
                  value={state.preferredDateTime}
                  onChange={(value) => dispatch({ type: "SET_FIELD", field: "preferredDateTime", value: value })}
                  className="w-full"
                />
              </Label>
            </div>
          )}

          {state.displayLocation && <SearchLocation /> }

          <div className="space-y-2">
            <Label htmlFor="additionalNotes">Additional Notes</Label>
            <Textarea
              id="additionalNotes"
              name="additionalNotes"
              value={state.additionalNotes}
              onChange={(e) => dispatch({ type: "SET_FIELD", field: "additionalNotes", value: e.target.value })}
              placeholder="Tell us about your vision for the photoshoot..."
              className="min-h-[100px] focus-visible:ring-primary"
            />
          </div>

          <Button type="submit" className="w-full transition-all hover:scale-[1.02]" disabled={state.isSubmitting}>
            {state.isSubmitting ? "Submitting..." : "Book Your Session"}
          </Button>
        </form>
      </CardContent>
    </Card>
  )
}
