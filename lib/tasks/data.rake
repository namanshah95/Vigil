require 'open-uri'
require 'zip'
require 'roo'

namespace :data do
  desc "TODO"
  task import: :environment do
    url = 'http://www.atlantapd.org/files/crimedata/COBRA091216.zip'
    path_to_zip = '/tmp/crime_data.zip'
    path_to_excel = '/tmp/crime_data.xlsx'
    
    # Download zip file from APD website
    open(path_to_zip, 'wb') do |file|
      file << open(url).read
    end
    # Unzip and extract COBRAXXXXXX.xls (raw crime data)
    Zip::File.open(path_to_zip) do |zip_file|
      excel = zip_file.glob('COBRA*.xlsx').first
    puts 'yo'
      open(path_to_excel, 'wb') do |excel_file|
        excel_file << excel.get_input_stream.read
      end
    end
    # Open excel file
    excel_file = Roo::Spreadsheet.open(path_to_excel) 
    puts excel_file.info

  end

end
