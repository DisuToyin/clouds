
require 'httparty'
class WeatherApi
  include HTTParty
  base_uri 'http://api.weatherapi.com/v1'

  def initialize()
    api_key = ENV['WEATHER_API_KEY']
    @options = { query: { key: api_key } }
  end

  def get_weather_by_location(location_name)
    current_weather_response = self.class.get("/current.json?q=#{location_name}&aqi=no", @options)
    forecast_response = self.class.get("/forecast.json?q=#{location_name}&days=1&alerts=no&aqi=no", @options)
    
    {
      current_weather: current_weather_response.parsed_response,
      forecast: forecast_response.parsed_response
    }
  end

  def get_suggested_locations(location_name)
    response = self.class.get("/search.json?q=#{location_name}", @options)
    # puts "Suggestions response: #{response.body}"
    response
  end
end