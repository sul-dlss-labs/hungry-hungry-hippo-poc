# frozen_string_literal: true

# Helper methods for components.
class ComponentSupport
  # Merge classes together.
  #
  # @param args [Array<String>, String] The classes to merge (array, classes, space separated classes).
  # @return [String] The merged classes.
  def self.merge_classes(*args)
    args.flat_map do |arg|
      Array(arg&.split)
    end.uniq.join(' ')
  end
end
