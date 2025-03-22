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

export default function AppointmentForm() {
  const { formData, setFormData } = useAppointment();

  const updateFormData = (key, value) => {
    setFormData(prev => ({ ...prev, [key]: value }));
  };

  const galleryPackageData = () => formData.galleries.find(obj => obj.id == formData.galleryId);


  const addOnData = () => {
    const gallery = formData.galleries.find(obj => obj.id == formData.galleryId);

    return gallery?.addOns?.map(addOn => ({
      label: `${addOn.name} ($${parseFloat(addOn.price).toFixed(2)})`,
      value: addOn.id,
    })) || [];
  };

  const handleSubmit = async (e) => {
    e.preventDefault()

    if (!formData.galleryId) {
      return toast.warning('Please select a gallery.')
    }

    updateFormData("isSubmitting", true);

    try {
      const response = await fetch("/api/appointment", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(formData),
      })

      if (response.ok) {
        const result = await response.json()

        setFormData({
          galleries: formData.galleries,
          galleryId: null,
          firstName: "",
          lastName: "",
          email: "",
          phoneNumber: "",
          displayDate: false,
          isSubmitting: false,
          isSuccess: true,
          preferredDateTime: undefined,
          additionalNotes: "",
          addOns: []
        })
      } else {
        toast.error("Something went wrong. Your appointment couldn't be submitted. Please try again.")
      }
    } catch (error) {
      console.error("Error:", error)
      toast.error("An unexpected error occurred. Please try again later.")
    } finally {
      updateFormData("isSubmitting", false);
    }
  }

  if (formData.isSuccess) {
    return (
      <Card className="w-full max-w-md mx-auto shadow-lg">
        <CardContent className="pt-6">
          <div className="flex flex-col items-center justify-center space-y-4 text-center">
            <CheckCircle className="h-16 w-16 text-green-500" />
            <CardTitle className="text-2xl">Appointment Submitted!</CardTitle>
            <CardDescription className="text-base">
              Thank you for your appointment request. We'll be in touch with you soon to confirm the details.
            </CardDescription>
            <Button onClick={() => updateFormData("isSuccess", false)} className="mt-4">
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
              value={formData.firstName}
              onChange={e => updateFormData("firstName", e.target.value)}
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
              value={formData.lastName}
              onChange={e => updateFormData("lastName", e.target.value)}
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
              value={formData.email}
              onChange={e => updateFormData("email", e.target.value)}
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
              value={formData.phoneNumber}
              onChange={e => updateFormData("phoneNumber", e.target.value)}
              className="focus-visible:ring-primary"
              pattern="^\+?[1-9]\d{1,14}$"
              placeholder="+1234567890"
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="gallery-select">Session Type</Label>
            <Select onValueChange={value => updateFormData("galleryId", value)} name="gallerySelect">
              <SelectTrigger className="focus-visible:ring-primary w-[180px]"  id="gallery-select">
                <SelectValue placeholder="Select a session" />
              </SelectTrigger>
              <SelectContent>
                {formData.galleries.map(gallery => (
                    <SelectItem key={gallery.id} value={gallery.id}>
                      {gallery.name}
                    </SelectItem>
                  )
                )}
              </SelectContent>
            </Select>
          </div>

          {formData.galleryId && (
            <div className="space-y-2">
              <Label htmlFor="gallery-select">Packages</Label>
              <Select onValueChange={value => updateFormData("packageId", value)} name="gallerySelect">
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

          {formData.galleryId && (
            <div className='space-y-2'>
              <span className='flex items-center gap-2 text-sm leading-none font-medium select-none'>
                Add On ( If Applicable)
                </span>
              <MultipleSelector defaultOptions={addOnData()} onChange={e => updateFormData("addOns", e)} placeholder="Select an add on"/>
            </div>
          )}

          <div className="flex justify-around">
            <div className="flex items-center">
              <Checkbox id="displayDate" name="displayDate" checked={formData.displayDate} onCheckedChange={value => updateFormData("displayDate", value)} className="mr-2"/>
              <Label htmlFor="displayDate">Date Available? (If Applicable)</Label>
            </div>
          </div>

          {formData.displayDate && (
            <div className="space-y-2">
              <Label className="block pb-2">Preferrable Date
                <DateTimePicker hourCycle={12} value={formData.preferredDateTime} onChange={value => updateFormData("preferredDateTime", value)} className="w-full"/>
              </Label>
            </div>
          )}

          <div className="space-y-2">
            <Label htmlFor="additionalNotes">Additional Notes</Label>
            <Textarea
              id="additionalNotes"
              name="additionalNotes"
              value={formData.additionalNotes}
              onChange={e => updateFormData("additionalNotes", e.target.value)}
              placeholder="Tell us about your vision for the photoshoot..."
              className="min-h-[100px] focus-visible:ring-primary"
            />
          </div>

          <Button type="submit" className="w-full transition-all hover:scale-[1.02]" disabled={formData.isSubmitting}>
            {formData.isSubmitting ? "Submitting..." : "Book Your Session"}
          </Button>
        </form>
      </CardContent>
    </Card>
  )
}
