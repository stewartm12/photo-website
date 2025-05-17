module ApplicationHelper
  include Pagy::Frontend

  def render_flash_stream
    turbo_stream.update 'flash', partial: 'shared/flash_messages'
  end

  def flash_css_class(type)
    case type.to_sym
    when :notice then { container: 'bg-blue-100 border-blue-500 text-blue-700', bar: 'bg-blue-500' }
    when :alert  then { container: 'bg-red-100 border-red-500 text-red-700', bar: 'bg-red-500' }
    when :success then { container: 'bg-green-100 border-green-500 text-green-700', bar: 'bg-green-500' }
    else { container: 'bg-gray-100 border-gray-500 text-gray-700', bar: 'bg-gray-500' }
    end
  end

  def gallery_badge_status(gallery)
    status_classes = {
      true => { style: 'bg-green-200 text-green-800', label: 'Active' },
      false => { style: 'bg-gray-200 text-gray-800', label: 'Inactive' }
    }

    status = status_classes[gallery.active]

    content_tag :div, class: "inline-flex items-center rounded-full border px-2.5 py-0.5 text-xs font-semibold border-transparent #{status[:style]}" do
      status[:label]
    end
  end

  def store_abbreviation
    words = Current.store.name.to_s.split

    if words.size <= 3
      words.map { |word| word[0] }.join
    else
      [Current.store.name[0], Current.store.name[-1]].join
    end
  end

  def nav_link_to(name = nil, options = nil, html_options = nil, &block)
    active_class = current_page?(name) ? 'bg-[oklch(95%_0.03_72.71)] text-[oklch(66.14%_0.0661_72.71)]' : ''
    options[:class] = "#{options[:class]} #{active_class}".strip
    link_to(name, options, html_options, &block)
  end
end
