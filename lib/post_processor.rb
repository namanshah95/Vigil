class PostProcessor
  include ActionView::Helpers::NumberHelper
  def self.process rules, returned
    return returned if rules.nil?

    preprocessed_data = returned[:data]
    preprocessed_datapoint = returned[:datapoint]

    returned[:data] = eval(rules[:data]) if rules[:data]
    returned[:datapoint] = eval(rules[:datapoint]) if rules[:datapoint]

    return returned
  end

  # Lets us process the danger_ratings in a seperate action
  def self.process_danger_ratings preprocessed_data
    banks = preprocessed_data[0].map{|e| e.to_s}.first(9)
    danger_ratings = preprocessed_data[1].map{|e| e.to_s}.first(9)
    dates = preprocessed_data[2].map{|e| e.to_s}.first(9)

    danger_ratings.reject!{|r| r == "Not Rated"}

    danger_ratings = danger_ratings.map do |r|
      r.include?("&rarr\;") ? r.split("&rarr\;").last.strip : r
    end

    danger_ratings = danger_ratings.map do |r|
      if ["High"]
      elsif ["Medium"]
      elsif ["Low"]
      end
    end

    danger_ratings = danger_ratings
    data = banks.zip(danger_ratings, dates)
  end

  def self.process_prices preprocessed_data
    banks = preprocessed_data[0].map{|e| e.to_s}.first(9)
    prices = preprocessed_data[1].map{|e| e.to_s.split('$').last}.first(9)
    dates = preprocessed_data[2].map{|e| e.to_s}.first(9)

    data = banks.zip(prices, dates)
  end
end