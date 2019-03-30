# frozen_string_literal: true

# 人モデル
class Person < ApplicationRecord
  has_many :books, foreign_key: :author_id

  validates :name, presence: true
end
