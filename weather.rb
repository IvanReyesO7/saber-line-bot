require 'geocoder'
require 'date'
require 'json'
require 'open-uri'

def fetch_weather(location)
  # Accepted message:
  # ~~~~~ weather in XXXXX
  #  ^anything          ^will become the location

  # Coordinates from keyword
  coord = Geocoder.search(location).first.coordinates
  api_key = 'f5191f73c320e67df9461049016befe3'
  url = "https://api.openweathermap.org/data/2.5/onecall?lat=#{coord[0]}&lon=#{coord[1]}&exclude=current,minutely,hourly&appid=#{api_key}"
  begin
    data_serialized = open(url).read
  rescue OpenURI::HTTPError => e
    return { mostly: '', temps: '', report: 'No weather forecast for this city...' }
  end
  data = JSON.parse(data_serialized)['daily'][0..3]


  days = ['today', 'tomorrow', (Date.today + 2).strftime('%A'), (Date.today + 3).strftime('%A')]
  weather_forcast = data.map.with_index { |day, index| [days[index], day['weather'][0]['main'], day['temp']['day'] - 272.15] }
  report = "#{weather_forcast[0][2].round}°C en #{location}"
  # Return the string from fore_cast data
  return report
end
