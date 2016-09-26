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

  # Lets us process the ratings in a seperate action
  def self.process_ratings preprocessed_data
    banks = preprocessed_data[0].map{|e| e.to_s}.first(9)
    ratings = preprocessed_data[1].map{|e| e.to_s}.first(9)
    dates = preprocessed_data[2].map{|e| e.to_s}.first(9)
    
    ratings.reject!{|r| r == "Not Rated"}

    ratings = ratings.map do |r|
      r.include?("&rarr\;") ? r.split("&rarr\;").last.strip : r
    end

    ratings = ratings.map do |r| 
      if ["Positive", "Outperform", "Overweight", "Buy", "Sector Outperform", "Market Outperform", "Mkt Outperform", "Sector Overperform", "Market Overperform", "Mkt Overperform"].include? r
        "Buy"
      elsif ["Perform", "Equal Weight", "Hold", "Sector Perform", "Market Perform", "Mkt Perform", "Neutral", "Fair Value"].include? r
        "Hold"
      elsif ["Negative", "Underperform", "Underweight", "Sell", "Sector Underperform", "Market Underperform", "Mkt Underperform"].include? r
        "Sell"
      end
    end
    
    ratings = ratings
    data = banks.zip(ratings, dates)
  end

  def self.process_prices preprocessed_data
    banks = preprocessed_data[0].map{|e| e.to_s}.first(9)
    prices = preprocessed_data[1].map{|e| e.to_s.split('$').last}.first(9)
    dates = preprocessed_data[2].map{|e| e.to_s}.first(9)

    data = banks.zip(prices, dates)
  end
end