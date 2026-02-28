class MeasurementBlueprint < Blueprinter::Base  
  identifier :id

  fields :zone,
         :meter_number,
         :meter_measurement,
         :meter_serie,
         :meter_model,
         :description

  field :meter_images do |measurement|
    measurement.meter_images.map do |img|
      {
        id: img.id,
        url: Rails.application.routes.url_helpers.rails_blob_url(
          img,
          host: Rails.application.routes.default_url_options[:host]
        )
      }
    end
  end
end