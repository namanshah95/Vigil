require 'csv'
require 'rest_client'

class CSVParser

  def self.get_csv url
    @@pages ||= {}
    @@pages[Date.today.to_time.to_i] ||= {}
    begin
      @@pages[Date.today.to_time.to_i][url] ||= RestClient.get(url)
    rescue
      @@pages[Date.today.to_time.to_i][url] ||= RestClient.get(url)
    end
  end
  
  def self.process params
    # Get datapoint
    case params[:datapoint][:type]
    when :string
      datapoint = params[:datapoint][:value]
    end

    # Get data
    response = self.get_csv params[:url]

    data = CSV.parse(response)
    data.shift

    case params[:data][:type]
    when :full
      # No change to data, we already have the full csv
    end

    # Post Process
    processed = PostProcessor.process(params[:post_processing], datapoint: datapoint, data: data)

    # Nil check
    nil_checked = NilChecker.process(params[:nil], processed)

    return nil_checked
  end
end