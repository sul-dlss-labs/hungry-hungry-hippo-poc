# frozen_string_literal: true

# Helpers for rendering icons.
module IconHelper
  def icon(icon_classes:, classes: nil)
    all_classes = [icon_classes, classes].compact.join(' ')
    "<i class='#{all_classes}'></i>".html_safe # rubocop:disable Rails/OutputSafety
  end

  def delete_icon(**)
    icon(icon_classes: 'bi bi-trash', **)
  end

  def edit_icon(**)
    icon(icon_classes: 'bi bi-pencil', **)
  end
end
