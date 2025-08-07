export default function LargeImageFallback() {
  return (
    <div className="relative w-full h-[60vh] min-h-[830px] max-h-[900px] bg-black flex flex-col items-center justify-center">
      <div className="w-16 h-16 border-4 border-gray-600 border-t-transparent rounded-full animate-spin mb-4" />
    </div>
  );
};
