# '{
#   "mon_1_open": "09:00",
#   "mon_1_close": "13:00",
#   "tue_1_open": "09:00",
#   "tue_1_close": "13:00",
#   "wed_1_open": "16:00",
#   "wed_1_close": "20:00",
#   "thu_1_open": "09:00",
#   "thu_1_close": "13:00",
#   "fri_1_open": "09:00",
#   "fri_1_close": "13:00",
#   "sat_1_open": "09:00",
#   "sat_1_close": "14:00",
#   "mon_2_open": "16:00",
#   "mon_2_close": "20:00",
#   "thu_2_open": "16:00",
#   "thu_2_close": "20:00"
# }'
#
# Mon, Thu: 09:00-13:00, 16:00-20:00
# Wed: 16:00-20:00
# Tue, Fri: 09:00-13:00
# Sat: 09:00-14:00

require 'json'
require 'date'

class WorkingHours
  attr_reader :hours_hash

  def initialize(user_json)
    @hours_hash = JSON.parse(user_json)

    present
  end

  private

  def present
    convert_to_weekdays
    group_weekdays_by_time
    return_output
  end

  def convert_to_weekdays
    @hours_hash = Date::ABBR_DAYNAMES.inject({}) do |result, day_name|
      # {"mon_1_open"=>"09:00"}
      day_hours = hours_hash.select { |k, _| k.start_with?(day_name.downcase) }

      # {"Mon" => ["9:00-13:00", "16:00-20:00"]}
      result[day_name] = []

      (day_hours.length / 2).times do |i|
        inter = "#{day_name.downcase}_#{i + 1}"
        result[day_name] << [
          day_hours["#{inter}_open"],
          day_hours["#{inter}_close"]
        ].join("-")
      end

      # {"Mon" => "9:00-13:00, 16:00-20:00"}
      result[day_name] = result[day_name].join(", ")

      result
    end
  end

  def group_weekdays_by_time
    @hours_hash = hours_hash.keys
      .group_by { |k| hours_hash[k] }
      .map { |k, v| [v.join(", "), k] }
  end

  def return_output
    hours_hash.each { |k, v| puts "#{k}: #{v}" }
  end
end

WorkingHours.new(
  '{
    "mon_1_open": "09:00",
    "mon_1_close": "13:00",
    "tue_1_open": "09:00",
    "tue_1_close": "13:00",
    "wed_1_open": "16:00",
    "wed_1_close": "20:00",
    "thu_1_open": "09:00",
    "thu_1_close": "13:00",
    "fri_1_open": "09:00",
    "fri_1_close": "13:00",
    "sat_1_open": "09:00",
    "sat_1_close": "14:00",
    "mon_2_open": "16:00",
    "mon_2_close": "20:00",
    "thu_2_open": "16:00",
    "thu_2_close": "20:00"
  }'
)
