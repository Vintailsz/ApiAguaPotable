class MeasurementBlueprint < Blueprinter::Base
  identifier :id

  fields :zone,
         :meter_number,
         :meter_measurement,
         :meter_serie,
         :meter_model,
         :description

  field :meter_images_url do |measurement|
    measurement.meter_images.map do |img|
      Rails.application.routes.url_helpers.url_for(img)
    end
  end
end