require 'nokogiri'
require 'open-uri'
require 'htmlentities'

class WebScraper
  def self.get_page url
    @@pages ||= {}
    @@pages[Date.today.to_time.to_i] ||= {}
    @@pages[Date.today.to_time.to_i][url] ||= Nokogiri::HTML(open(url))
  end

  def self.process params, extras = {}
    url = params[:url]
    page = self.get_page url

    # Get datapoint
    case params[:datapoint][:type]
    when :string
      datapoint = params[:datapoint][:value]
    when :xpath
      datapoint = page.xpath(params[:datapoint][:lookup])[0] || page.xpath(params[:datapoint][:lookup])
    end

    # Get data
    case params[:data][:type]
    when :xpath
      if params[:data][:lookup].kind_of?(Array)
        data = params[:data][:lookup].map do |xpath|
          if params[:data][:return_type] == :array
            page.xpath(xpath)
          else
            page.xpath(xpath)[0].to_s || page.xpath(xpath).to_s
          end
        end
      else
        data = page.xpath(params[:data][:lookup])[0].to_s || page.xpath(params[:data][:lookup].to_s)
      end
    end

    # Post Process
    processed = PostProcessor.process(params[:post_processing], datapoint: datapoint, data: data)

    # Nil check
    nil_checked = NilChecker.process(params[:nil], processed)

    return nil_checked
  end
end
