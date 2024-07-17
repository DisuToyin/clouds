# class PagesController < ApplicationController


#     def search
#       api = WeatherApi.new
#       @location = params[:location]
#       weather_data = api.get_weather_by_location(@location)
#       forecast = weather_data[:forecast]
  
#       if forecast && forecast['forecast'] && forecast['forecast']['forecastday']
#         current_time = Time.now
#         forecast_data = forecast['forecast']['forecastday'][0]['hour']

#         highest_temp = forecast_data.map { |hour| hour['temp_c'] }.max
#         lowest_temp = forecast_data.map { |hour| hour['temp_c'] }.min
        
#         five_hours_forecast = forecast_data.select do |hour|
#           forecast_time = Time.parse(hour['time'])
#           forecast_time > current_time && forecast_time <= current_time + 5.hours
#         end
#         @weather = {
#           current_weather: weather_data[:current_weather],
#           forecast: five_hours_forecast,
#           greeting: determine_greeting(current_time),
#           highest_temp: highest_temp,
#           lowest_temp: lowest_temp

#         }
#       else
#         @weather = { 
#           current_weather: weather_data[:current_weather], 
#           forecast: [], 
#           greeting: determine_greeting(current_time),
#           highest_temp: nil,
#           lowest_temp: nil
#         }
#       end
    
#         # render json: @weather
#     end

#     def autocomplete
#         api = WeatherApi.new()
#         @location = params[:q]
#         @suggestions = api.get_suggested_locations(@location)
#         # puts "Autocomplete response: #{@suggestions.body}"
#         render json: @suggestions.parsed_response
#     end

#     private

#     def determine_greeting(time)
#       case time.hour
#       when 0..11
#         "Good morning!"
#       when 12..16
#         "Good afternoon!"
#       else
#         "Good evening!"
#       end
#     end
# end

class PagesController < ApplicationController
  def search
    api = WeatherApi.new
    @location = params[:location]
    weather_data = api.get_weather_by_location(@location)
    forecast = weather_data[:forecast]
    
    current_time = Time.now

    if forecast && forecast['forecast'] && forecast['forecast']['forecastday']
      forecast_data = forecast['forecast']['forecastday'][0]['hour']

      highest_temp = forecast_data.map { |hour| hour['temp_c'] }.max
      lowest_temp = forecast_data.map { |hour| hour['temp_c'] }.min
      
      five_hours_forecast = forecast_data.select do |hour|
        forecast_time = Time.parse(hour['time'])
        forecast_time > current_time && forecast_time <= current_time + 5.hours
      end
      @weather = {
        current_weather: weather_data[:current_weather],
        forecast: five_hours_forecast,
        greeting: determine_greeting(current_time),
        highest_temp: highest_temp,
        lowest_temp: lowest_temp
      }
    else
      @weather = { 
        current_weather: weather_data[:current_weather], 
        forecast: [], 
        greeting: determine_greeting(current_time),
        highest_temp: nil,
        lowest_temp: nil
      }
    end

    # render json: @weather
  end

  def autocomplete
    api = WeatherApi.new
    @location = params[:q]
    @suggestions = api.get_suggested_locations(@location)
    render json: @suggestions.parsed_response
  end

  private

  def determine_greeting(time)
    case time.hour
    when 0..11
      "Good morning!"
    when 12..16
      "Good afternoon!"
    else
      "Good evening!"
    end
  end
end
