require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  describe 'GET #search' do
    let(:location) { 'San Francisco' }
    let(:current_time) { Time.now }

    context 'when forecast data is available' do
      let(:weather_data) do
        {
          current_weather: { 'temp_c' => 15 },
          forecast: {
            'forecastday' => [
              {
                'hour' => [
                  { 'time' => (current_time + 1.hour).strftime('%Y-%m-%d %H:%M'), 'temp_c' => 16 },
                  { 'time' => (current_time + 2.hours).strftime('%Y-%m-%d %H:%M'), 'temp_c' => 18 },
                  { 'time' => (current_time + 3.hours).strftime('%Y-%m-%d %H:%M'), 'temp_c' => 20 },
                  { 'time' => (current_time + 4.hours).strftime('%Y-%m-%d %H:%M'), 'temp_c' => 22 },
                  { 'time' => (current_time + 5.hours).strftime('%Y-%m-%d %H:%M'), 'temp_c' => 21 },
                  { 'time' => (current_time + 6.hours).strftime('%Y-%m-%d %H:%M'), 'temp_c' => 19 }
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
          lowest_temp: 16,
        )
      end

   
      it 'assigns a greeting' do
        greeting = case current_time.hour
                   when 0..11 then "Good morning!"
                   when 12..16 then "Good afternoon!"
                   else "Good evening!"
                   end
        expect(assigns(:weather)[:greeting]).to eq(greeting)
      end
    end

    context 'when forecast data is not available' do
      let(:weather_data) do
        {
          current_weather: { 'temp_c' => 15 },
          forecast: nil
        }
      end

      before do
        allow_any_instance_of(WeatherApi).to receive(:get_weather_by_location).and_return(weather_data)
        get :search, params: { location: location }
      end

      it 'assigns @weather with nil forecast' do
        expect(assigns(:weather)).to include(
          current_weather: weather_data[:current_weather],
          highest_temp: nil,
          lowest_temp: nil,
          forecast: []
        )
      end
    end
  end

  describe 'GET #autocomplete' do
    let(:location) { 'San' }
    let(:suggestions) do
      [
        {
          "id": 1715013,
          "name": "Abuja",
          "region": "Federal Capital Territory",
          "country": "Nigeria",
          "lat": 9.18,
          "lon": 7.18,
          "url": "abuja-federal-capital-territory-nigeria"
        },
        {
          "id": 1234567,
          "name": "San Francisco",
          "region": "California",
          "country": "USA",
          "lat": 37.77,
          "lon": -122.42,
          "url": "san-francisco-california-usa"
        }
      ]
    end

    before do
      allow_any_instance_of(WeatherApi).to receive(:get_suggested_locations).and_return(suggestions)
      get :autocomplete, params: { q: location }
    end

    it 'assigns @location' do
      expect(assigns(:location)).to eq(location)
    end

    
  end
end
