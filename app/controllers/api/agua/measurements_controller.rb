module Api
    module Agua
        class MeasurementsController < ApplicationController
            before_action :set_measurement, only: %i[ show update destroy]

            def index
                @measurements = Measurement.all
                render json: MeasurementBlueprint.render(@measurements)
            end

            def show
                render json: MeasurementBlueprint.render(@measurement)
            end

            def create
                Rails.logger.debug params.inspect

                @measurement = Measurement.new(measurement_params)
                if @measurement.save
                    render json: MeasurementBlueprint.render(@measurement)
                else
                    render json: @measurement.errors, status: :unprocessable_entity
                end
            end

            def update
                if @measurement.update(measurement_params.except(:meter_images, :existing_images))
                    if measurement_params[:existing_images]
                        keep_urls = measurement_params[:existing_images]

                        @measurement.meter_images.each do |img|
                            url = Rails.application.routes.url_helpers.url_for(img)

                            unless keep_urls.include?(url)
                            img.purge
                            end
                        end
                    end
                    
                    if measurement_params[:meter_images]
                        @measurement.meter_images.attach(measurement_params[:meter_images])
                    end

                    render json: MeasurementBlueprint.render(@measurement)
                else
                    render json: @measurement.errors, status: :unprocessable_entity
                end
            end

            def destroy
                @measurement.destroy
                head :no_content
            end

            private
                def set_measurement
                    @measurement = Measurement.find(params[:id])
                end

                def measurement_params
                    return {} unless params[:measurement]
                    
                    params.require(:measurement).permit( 
                        :zone, 
                        :meter_number,
                        :meter_measurement,
                        :meter_serie, 
                        :meter_model, 
                        :description, 
                        meter_images: [],
                        meter_image_ids: [],
                        existing_images: []
                    ) 
                end
        end
    end
end