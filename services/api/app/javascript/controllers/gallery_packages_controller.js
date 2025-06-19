import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="gallery-packages"
export default class extends Controller {
  static targets = ["gallerySelect", "packagesWrapper", "addonsWrapper", "galleries"]

  loadOptions() {
    const galleryId = parseInt(this.gallerySelectTarget.value)
    if (!galleryId) return
    const galleryData = JSON.parse(this.galleriesTarget.dataset.galleries)
    const gallery = galleryData.find(g => g.id === galleryId)
    if (!gallery) return

    this.renderOptions(gallery.packages, this.packagesWrapperTarget, "appointment[package_id]", "Select a package")
    this.renderOptions(gallery.add_ons, this.addonsWrapperTarget, "appointment[add_on_id]", "Select an add-on")
  }

  renderOptions(options, wrapper, name, label) {
    wrapper.innerHTML = ""

    if (!options || options.length === 0) return

    const selectId = `${name.replace(/\W/g, "_")}select`

    const labelEl = document.createElement("label")
    labelEl.textContent = label
    labelEl.className = "font-medium text-sm"
    labelEl.setAttribute("for", selectId)
    wrapper.appendChild(labelEl)

    const select = document.createElement("select")
    select.name = name
    select.id = selectId
    select.className = "bg-white p-2 rounded-md font-medium text-sm border border-gray-400"

    const blankOption = document.createElement("option")
    blankOption.value = ""
    blankOption.text = `-- ${label} --`
    select.appendChild(blankOption)

    options.forEach(opt => {
      const option = document.createElement("option")
      option.value = opt.id
      option.textContent = `${opt.name} ($${opt.price})`
      select.appendChild(option)
    })

    wrapper.appendChild(select)
  }
}
