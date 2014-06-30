class SampleConfig < Sebastian::DSL
  display do
    # Static text
    text "Hello Sebastian"

    # Can also contain newlines
    text "How are you?\nFine, thank you."

    # Unicode is fine
    text "Félix Saparelli. ⵃ ⇎ λ … 百姓 ZA̡͊͠͝LGΌ ISͮ̂҉̯͈͕̹̘̱ TO͇̹̺ͅƝ̴ȳ̳ TH̘Ë͖́̉ ͠P̯͍̭O̚​N̐Y̡ H̸̡̪̯ͨ͊̽̅̾̎Ȩ̬̩̾͛ͪ̈́̀́͘ ̶̧̨̱̹̭̯ͧ̾ͬC̷̙̲̝͖ͭ̏ͥͮ͟Oͮ͏̮̪̝͍M̲̖͊̒ͪͩͬ̚̚͜Ȇ̴̟̟͙̞ͩ͌͝S̨̥̫͎̭ͯ̿̔̀ͅ"

    # Synchronous variable (refreshed at every update cycle)
    text "2 + 2 = #{2 + 2}"

    # Asynchronous variable (refreshed independently of update cycles)
    text "Hourly dice: #{var :dice}"
  end

  # Asynchronous variable used above. (501: Work in progress.) Synopsis:
  #
  #     var :name, refresh interval in seconds = 1, default value = nil, do
  #       # code that returns a value
  #     end
  #
  # The default value will be shown:
  # - before the variable had been computed
  # - if the code block raises an exception
  var :dice, 60 * 60, "warming up…" do
    "#{Random.rand(6) + 1} and #{Random.rand(6) + 1}"
  end
end
