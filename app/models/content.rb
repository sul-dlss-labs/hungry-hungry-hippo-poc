# frozen_string_literal: true

# Model for a Work's content (files)
class Content < ApplicationRecord
  has_many :content_files, dependent: :destroy

  def broadcast
    broadcast_replace_to ActionView::RecordIdentifier.dom_id(self),
                         partial: 'contents/show',
                         locals: { content: self, content_files: content_files.page(1) },
                         target: ActionView::RecordIdentifier.dom_id(self, 'show')
    broadcast_replace_to ActionView::RecordIdentifier.dom_id(self),
                         partial: 'contents/edit',
                         locals: { content: self },
                         target: ActionView::RecordIdentifier.dom_id(self, 'edit')
  end
end
