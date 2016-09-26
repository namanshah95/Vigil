class QueryDispatcher
  include DispatchDefinitions
  include DispatchHelpers
  include DispatchTable

  # Super hacky solution to rerouting
  def reroute params
    @reroute_rules ||= []
    @reroute_rules.push(params)
  end

  # Takes into account the reroute_rules and either returns the original option, or the rerouted option
  def rerouted_option option, datapoint, ticker, index
    if @reroute_rules.map{|r| r[:from]}.include? ticker
      rules = @reroute_rules.select { |rule| rule[:from] == ticker }
      rules.each do |rule|
        rule[:for].each do |partial_option|
          if option.merge(partial_option) == option
            return query_options = dispatch_table(rule[:to], datapoint)[datapoint][index]
          end
        end
      end
    end
    return option
  end

  def dispatch ticker, datapoint

    to_return = {datapoint: nil, data: nil}
    query_options = dispatch_table(ticker, datapoint)[datapoint]
    i = 0

    # Keep looping until either one of the entries in the dispatch table
    # succeeds, or until we run out of options
    while (to_return[:datapoint].nil? or to_return[:data].nil?) and i < query_options.length
      begin
        current_option = rerouted_option(query_options[i], datapoint, ticker, i)
        case current_option[:type]
        when :page
          to_return = WebScraper.process(current_option)
        when :database
          to_return = DatabaseQuerier.process(current_option)
        when :csv
          to_return = CSVParser.process(current_option)
        end
      rescue Exception
        to_return = {datapoint: nil, data: nil}
      end
      i += 1
    end 

    return to_return
  end
end
