export function showFlash(type, message) {
  const flashContainer = document.getElementById("flash");
  if (!flashContainer) return;

  const flashColors = {
    notice: {
      container: 'bg-yellow-100 border-yellow-500 text-yellow-700',
      bar: 'bg-yellow-500'
    },
    alert: {
      container: 'bg-red-100 border-red-500 text-red-700',
      bar: 'bg-red-500'
    },
    success: {
      container: 'bg-green-100 border-green-500 text-green-700',
      bar: 'bg-green-500'
    },
    default: {
      container: 'bg-gray-100 border-gray-500 text-gray-700',
      bar: 'bg-gray-500'
    }
  };

  const css = flashColors[type] || flashColors.default;

  const wrapper = document.createElement("div");
  wrapper.dataset.controller = "flash-message";
  wrapper.dataset.flashMessageTarget = "container";
  wrapper.className = `border-l-4 rounded shadow-md ${css.container} mb-2 transition-all duration-500 transform`;

  wrapper.innerHTML = `
    <div class="flex items-center justify-between p-4">
      <p class="text-sm font-medium">${message}</p>
      <button data-action="click->flash-message#dismiss" class="cursor-pointer">
        <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
        </svg>
      </button>
    </div>
    <div id="progressBar" class="mx-auto h-1 overflow-hidden">
      <div class="h-full ${css.bar}" data-flash-message-target="bar"></div>
    </div>
  `;

  flashContainer.appendChild(wrapper);
}
