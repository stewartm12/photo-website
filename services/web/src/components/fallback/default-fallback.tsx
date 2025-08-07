
type FallbackProps = {
  message?: string;
}

export default function DefaultFallback({ message = "Oops! Failed to load gallery data." }: FallbackProps) {
  return (
    <div className="flex flex-col items-center justify-center h-screen p-6 bg-stone-100 rounded-md shadow-md text-stone-700">
      <svg
        className="w-12 h-12 mb-4 text-stone-400"
        fill="none"
        stroke="currentColor"
        strokeWidth={2}
        viewBox="0 0 24 24"
        aria-hidden="true"
      >
        <path
          strokeLinecap="round"
          strokeLinejoin="round"
          d="M18.364 5.636l-12.728 12.728M5.636 5.636l12.728 12.728"
        />
      </svg>
      <p className="text-lg font-medium">{message}</p>
      <p className="text-sm text-stone-500 mt-2">Please try refreshing the page or check back later.</p>
    </div>
  );
};
