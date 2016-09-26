class DatabaseQuerier

  def self.get_stock ticker
    @@pages ||= {}
    @@pages[Date.today. to_time.to_i] ||= {}
    @@pages[Date.today.to_time.to_i][ticker] ||= Stock.find_by_ticker(ticker)
  end
  
  def self.process params
    # Get datapoint
    stock = self.get_stock params[:ticker]

    return {datapoint: nil, data: nil} if stock.nil?

    case params[:datapoint][:type]
    when :string
      datapoint = params[:datapoint][:value]
    end

    data = stock.properties[params[:key]]

    # Post Process
    processed = PostProcessor.process(params[:post_processing], datapoint: datapoint, data: data)

    # Nil check
    nil_checked = NilChecker.process(params[:nil], processed)

    return nil_checked
  end
end
