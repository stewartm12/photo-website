import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="gallery-packages"
export default class extends Controller {
  static targets = [
    "gallerySelect",
    "packagesWrapper",
    "galleries",
    "addonsWrapper",
    "packageInfoWrapper"
  ]

  loadOptions() {
    const galleryId = parseInt(this.gallerySelectTarget.value)
    if (!galleryId) return
    const galleryData = JSON.parse(this.galleriesTarget.dataset.galleries)
    const gallery = galleryData.find(g => g.id === galleryId)
    if (!gallery) return

    if (this.hasPackageInfoWrapperTarget) {
      this.packageInfoWrapperTarget.innerHTML = ""
    }

    if (this.hasPackagesWrapperTarget) this.renderOptions(gallery.packages, this.packagesWrapperTarget, "appointment[package_id]", "Select a package");
    if (this.hasAddonsWrapperTarget) this.renderOptions(gallery.add_ons, this.addonsWrapperTarget, "appointment[add_on_id]", "Select an add-on");
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

    if (this.hasPackageInfoWrapperTarget) {
      select.setAttribute("data-action", "change->gallery-packages#renderPackageInfoFromEvent")
    }

    options.forEach(opt => {
      const option = document.createElement("option")
      option.value = opt.id
      option.textContent = `${opt.name} ($${opt.price})`
      select.appendChild(option)
    })

    wrapper.appendChild(select)
  }

  renderPackageInfoFromEvent(event) {
    const selectedId = parseInt(event.target.value)
    if (!selectedId) {
      this.packageInfoWrapperTarget.innerHTML = ""
      return
    }
    const galleryData = JSON.parse(this.galleriesTarget.dataset.galleries)
    // Find the gallery that matches current selected gallery id
    const galleryId = parseInt(this.gallerySelectTarget.value)
    const gallery = galleryData.find(g => g.id === galleryId)
    if (!gallery) {
      this.packageInfoWrapperTarget.innerHTML = ""
      return
    }
    const selectedPackage = gallery.packages.find(p => p.id === selectedId)
    this.renderPackageInfo(selectedPackage)
  }

  renderPackageInfo(pkg) {
    if (!this.hasPackageInfoWrapperTarget) return
    this.packageInfoWrapperTarget.innerHTML = ""
  
    if (!pkg) return
  
    const container = document.createElement("div")
    container.className = "text-sm text-gray-700 space-y-1"
  
    const fields = [
      [`Name`, pkg.name],
      [`Price`, `$${pkg.price}`],
      [`Edited Images`, pkg.edited_images],
      [`Outfit Change`, pkg.outfit_change ? "Yes" : "No"],
      [`Duration`, `${pkg.duration} mins`],
      [`Features`, (pkg.features || []).join(", ")]
    ]
  
    fields.forEach(([label, value]) => {
      const row = document.createElement("div")
      row.innerHTML = `<strong>${label}:</strong> ${value}`
      container.appendChild(row)
    })
  
    this.packageInfoWrapperTarget.appendChild(container)
  }
}
