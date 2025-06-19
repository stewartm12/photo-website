module ApplicationHelper
  include Pagy::Frontend

  def render_flash_stream
    turbo_stream.update 'flash', partial: 'shared/flash_messages'
  end

  def flash_css_class(type)
    case type.to_sym
    when :notice then { container: 'bg-yellow-100 border-yellow-500 text-yellow-700', bar: 'bg-yellow-500' }
    when :alert  then { container: 'bg-red-100 border-red-500 text-red-700', bar: 'bg-red-500' }
    when :success then { container: 'bg-green-100 border-green-500 text-green-700', bar: 'bg-green-500' }
    else { container: 'bg-gray-100 border-gray-500 text-gray-700', bar: 'bg-gray-500' }
    end
  end

  def status_badge(record)
    status_classes = {
      true => { style: 'bg-green-200 text-green-800', label: 'Active' },
      false => { style: 'bg-gray-200 text-gray-800', label: 'Inactive' }
    }

    status = status_classes[record.active]

    content_tag :div, class: "inline-flex items-center rounded-full border px-2.5 py-0.5 text-xs font-semibold border-transparent #{status[:style]}" do
      status[:label]
    end
  end

  def appointment_badge_status(appt)
    status_classes = {
      pending:     'bg-yellow-100 text-yellow-700',
      confirmed:   'bg-blue-100 text-blue-700',
      in_progress: 'bg-indigo-100 text-indigo-700',
      editing:     'bg-purple-100 text-purple-700',
      delivered:   'bg-teal-100 text-teal-700',
      completed:   'bg-green-100 text-green-700',
      cancelled:   'bg-red-100 text-red-700',
      no_show:     'bg-gray-100 text-gray-700'
    }

    status = status_classes[appt.status.to_sym]

    content_tag :div, class: "inline-flex items-center rounded-full border px-2.5 py-0.5 text-xs font-semibold border-transparent #{status}" do
      appt.status
    end
  end

  def deposit_badge_status(amount)
    deposit_status_color = amount > 0 ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'
    deposit_status = amount > 0 ? 'Paid' : 'Unpaid'

    content_tag :div, class: "inline-flex items-center rounded-full border px-2.5 py-0.5 text-xs font-semibold border-transparent #{deposit_status_color}" do
      deposit_status
    end
  end

  def invoice_badge_status(invoice)
    invoice_status_classes = {
      unpaid:    'bg-yellow-100 text-yellow-700',
      overdue:   'bg-red-100 text-red-700',
      paid:      'bg-green-100 text-green-700',
      refunded:  'bg-pink-100 text-pink-700',
      void:      'bg-gray-100 text-gray-700'
    }

    status = invoice_status_classes[invoice.status.to_sym]

    content_tag :div, class: "inline-flex items-center rounded-full border px-2.5 py-0.5 text-xs font-semibold border-transparent #{status}" do
      invoice.status
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

  def initials(name)
    return '' if name.blank?

    name.split.map { |n| n[0] }.join[0, 2].upcase
  end

  def add_on_options_with_price(add_ons)
    add_ons.map do |add_on|
      content_tag(:option, add_on.name, value: add_on.id, data: { price: add_on.price })
    end.join.html_safe
  end
end
