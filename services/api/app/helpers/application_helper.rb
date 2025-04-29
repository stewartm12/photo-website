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
      true => { inner: 'bg-emerald-400', outer: 'bg-emerald-500', label: 'Active' },
      false => { inner: 'bg-red-400', outer: 'bg-red-500', label: 'Inactive' },
      nil => { inner: 'bg-gray-400', outer: 'bg-gray-500', label: 'Unknown' }
    }

    status = status_classes.fetch(gallery.active, status_classes[nil])

    content_tag :span, class: 'inline-flex items-center px-4 py-1 text-xs gap-1.5 text-gray-500 ring-gray-500/40 ring-1 ring-inset rounded-full bg-gray-200' do
      concat(
        content_tag(:span, class: 'flex relative') do
          concat content_tag(:span, '', class: "absolute inline-flex w-full h-full rounded-full opacity-75 animate-ping #{status[:inner]}")
          concat content_tag(:span, '', class: "relative inline-flex w-2 h-2 rounded-full #{status[:outer]}")
        end
      )
      concat(status[:label])
    end
  end
end
