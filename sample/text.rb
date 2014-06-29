class SampleConfig < Sebastian::DSL
  display do
    text "Hello Sebastian"
    text "How are you?"
    text "Calc = #{var :calc}"
    text "Battery: #{var :battery_status}"
  end

  var :calc do
    3 + 9
  end

  var :battery_status, 5, "Unknown" do
    "Charging"
  end
end
