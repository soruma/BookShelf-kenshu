# frozen_string_literal: true

# 人モデル
class Person < ApplicationRecord
  validates :name, presence: true
end
