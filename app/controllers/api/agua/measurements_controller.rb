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
                @measurement = Measurement.new(measurement_params.except(:meter_image_ids))
                if @measurement.save
                    render json: MeasurementBlueprint.render(@measurement)
                else
                    render json: @measurement.errors, status: :unprocessable_entity
                end
            end

            def update
                Rails.logger.debug "PARAMS RECIBIDOS:"
                Rails.logger.debug params.inspect

                if @measurement.update(measurement_params.except(:meter_images, :meter_image_ids))

                    if measurement_params.key?(:meter_image_ids)
                        ids = Array(measurement_params[:meter_image_ids])
                                .reject(&:blank?)
                                .map(&:to_s)
                        
                        if ids.empty?
                            @measurement.meter_images.purge
                        else
                            @measurement.meter_images.each do |image|
                                image.purge unless ids.include?(image.id.to_s)
                            end
                        end
                    end

                    if measurement_params[:meter_images].present?
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
                        meter_image_ids: []
                    ) 
                end
        end
    end
end