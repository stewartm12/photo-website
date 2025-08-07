type FaqsProps = {
  question: string;
  answer: string;
}

export default function Faqs() {
  return (
    <section className="grid grid-cols-1 md:grid-cols-2 gap-x-12 gap-y-8">
      <FaqItem
        question="How do I book a session with you?"
        answer="Booking is easy! Simply contact me through the contact form, email, or phone. We'll discuss your needs, select a package, and secure your date with a deposit and signed contract."
      />

      <FaqItem
        question="How far in advance should I book?"
        answer="For weddings, I recommend booking 6-12 months in advance. For portraits and other sessions, 2-4 weeks is usually sufficient, though peak seasons (fall, spring) book up quickly."
      />

      <FaqItem
        question="What is your payment policy?"
        answer="A non-refundable retainer of 25% is required to secure your date, with the remaining balance due one week before your session. For weddings, the final payment is due two weeks before the event."
      />

      <FaqItem
        question="How long until I receive my photos?"
        answer="Portrait sessions are delivered within 2 weeks. Weddings and events are delivered within 4-6 weeks. Rush delivery is available for an additional fee."
      />

      <FaqItem
        question="What happens if it rains on my session day?"
        answer="For outdoor sessions, we'll monitor the weather and reschedule if necessary at no additional cost. I'm flexible and want to ensure we get the best possible conditions for your photos."
      />

      <FaqItem
        question="Do you travel for sessions or weddings?"
        answer="Yes! I serve the entire San Antonio area at no additional cost. For locations beyond San Antonio, a travel fee applies."
      />
    </section>
  );
}

function FaqItem({question, answer}: FaqsProps) {
  return (
    <div className="space-y-2">
      <h3 className="text-lg font-semibold text-stone-800">{question}</h3>
      <p className="text-stone-600">{answer}</p>
    </div>
  );
};
