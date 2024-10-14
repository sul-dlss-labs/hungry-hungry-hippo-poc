# frozen_string_literal: true

module Element
  class ButtonSupport
    def self.classes(variant: nil, size: nil, classes: [])
      ComponentSupport.merge_classes('btn',
                                     variant ? "btn-#{variant}" : nil,
                                     size ? "btn-#{size}" : nil,
                                     classes)
    end
  end
end
