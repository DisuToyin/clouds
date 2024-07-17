require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  describe 'GET #search' do
    let(:location) { 'San Francisco' }
    let(:weather_data) do
      {
        current_weather: { 'temp_c' => 15 },
        forecast: {
          'forecastday' => [
            {
              'hour' => [
                { 'time' => (Time.now + 1.hour).strftime('%Y-%m-%d %H:%M'), 'temp_c' => 16 },
                { 'time' => (Time.now + 2.hours).strftime('%Y-%m-%d %H:%M'), 'temp_c' => 18 },
                { 'time' => (Time.now + 3.hours).strftime('%Y-%m-%d %H:%M'), 'temp_c' => 20 },
                { 'time' => (Time.now + 4.hours).strftime('%Y-%m-%d %H:%M'), 'temp_c' => 22 },
                { 'time' => (Time.now + 5.hours).strftime('%Y-%m-%d %H:%M'), 'temp_c' => 21 },
                { 'time' => (Time.now + 6.hours).strftime('%Y-%m-%d %H:%M'), 'temp_c' => 19 }
              ]
            }
          ]
        }
      }
    end

    before do
      allow_any_instance_of(WeatherApi).to receive(:get_weather_by_location).and_return(weather_data)
      get :search, params: { location: location }
    end

    it 'assigns @location' do
      expect(assigns(:location)).to eq(location)
    end

    it 'assigns @weather' do
      expect(assigns(:weather)).to include(
        current_weather: weather_data[:current_weather],
        highest_temp: 22,
        lowest_temp: 16
      )
    end

    it 'assigns a greeting' do
      current_time = Time.now
      greeting = case current_time.hour
                 when 0..11 then "Good morning!"
                 when 12..16 then "Good afternoon!"
                 else "Good evening!"
                 end
      expect(assigns(:weather)[:greeting]).to eq(greeting)
    end
  end

  describe 'GET #autocomplete' do
    let(:location) { 'San' }
    let(:suggestions) { ['San Francisco', 'San Jose', 'San Diego'] }

    before do
      allow_any_instance_of(WeatherApi).to receive(:get_suggested_locations).and_return(suggestions)
      get :autocomplete, params: { q: location }
    end

    it 'assigns @location' do
      expect(assigns(:location)).to eq(location)
    end

    it 'returns suggestions as JSON' do
      parsed_response = JSON.parse(response.body)
      expect(parsed_response).to eq(suggestions)
    end
  end
end
