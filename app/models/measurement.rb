class Measurement < ApplicationRecord
    has_many_attached :meter_images

    validates :zone, presence: true
    validates :meter_measurement, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
