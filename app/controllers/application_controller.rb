class ApplicationController < ActionController::Base
  require 'forecast_io'
  require 'open-uri'

  def show_weather
    begin
      current_ip = request.env['HTTP_CF_CONNECTING_IP']
      location = Geocoder.search(current_ip)
      longlat = location.last.data.dig('loc').split(',')
      longitude = longlat.first
      latitude = longlat.last
      forecast = ForecastIO.forecast(longitude, latitude)
      weather =JSON.parse(forecast.to_json)
      @timezone = weather['timezone']
      @data = weather['currently']
    rescue => error
      Rails.logger.debug(error.message)
      redirect_to error_path
    end
  end

  def show_error
    @error = "Please retry there is an issue with connection"
  end

  private
    def farenheit_to_celcius(farenheit)
      (farenheit - 32) * (5.to_f/9.to_f)
    end

    helper_method :farenheit_to_celcius
end
