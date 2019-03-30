# frozen_string_literal: true

# 本モデル
class Book < ApplicationRecord
  belongs_to :author, class_name: 'Person'

  validates :title, presence: true
  validates :author, presence: true
end
