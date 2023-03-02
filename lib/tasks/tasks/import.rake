require "zip"

def extract_zip(file, destination)
  FileUtils.mkdir_p(destination)

  Zip::File.open(file) do |zip_file|
    csv_file_name = File.basename(file,".zip")
    unzipped_files = []
    zip_file.each do |f|
      fpath = File.join(destination, f.name)
      next unless f.name.starts_with? csv_file_name.split("-feeds-")[0]
      unzipped_files << fpath
      zip_file.extract(f, fpath) unless File.exist?(fpath)
    end
    unzipped_files
  end
end

namespace :import do

  desc "Import data from all CSV files in db/data folder"
  task :all => :environment do
    data_dir = Rails.root.join('db','data')
    Rails.logger.info "Import data from all csv files in #{data_dir} folder"
    tmp_dir =  Rails.root.join('tmp')
    zipped_files = Dir["#{data_dir}/*.csv.zip"]

    Parallel.map(zipped_files, in_processes: 10) do |zipped_csv_file|
      extract_zip(zipped_csv_file,tmp_dir).each do |csv_file_path|
        channel_id = File.basename(csv_file_path, ".").split("-feeds-")[0].to_i
        Rails.logger.info "[#{channel_id}]: import #{csv_file_path}"
        src_doc = CSV.read(csv_file_path, headers: true, col_sep: ",")
        headers = []
        src_doc.headers.each { |h| headers << h if h.start_with? "field" and h[/\(.*?\)/] != "()" }
        channel = Channel.find(channel_id)
        # puts "Importing data to channel #{channel.name}"
        Rails.logger.debug "Importing data to channel #{channel.name}"
        src_doc.each do |row|
          created_at = row[0]
          headers.each do |header|
            if row[header]
              metric = header[/\(.*?\)/].tr('()', '').strip
              if channel.measurements.find_by(created_at: created_at, metric: metric)
                Rails.logger.debug "found: [#{created_at}] #{metric} #{row[header]}"
              else
                channel.measurements.create({created_at: created_at.to_datetime, metric: metric, value: row[header]})
                Rails.logger.info "[#{channel.id}]: add [#{created_at}] #{metric} #{row[header]}"
              end
            end
          end
        end
      end
    end

    # zipped_files.each do |zipped_csv_file|
    #   extract_zip(zipped_csv_file,tmp_dir).each do |csv_file_path|
    #     channel_id = File.basename(csv_file_path, ".").split("-feeds-")[0].to_i
    #     Rails.logger.info "[#{channel_id}]: import #{csv_file_path}"
    #     src_doc = CSV.read(csv_file_path, headers: true, col_sep: ",")
    #     headers = []
    #     src_doc.headers.each { |h| headers << h if h.start_with? "field" and h[/\(.*?\)/] != "()" }
    #     channel = Channel.find(channel_id)
    #     # puts "Importing data to channel #{channel.name}"
    #     Rails.logger.debug "Importing data to channel #{channel.name}"
    #     src_doc.each do |row|
    #       created_at = row[0]
    #       headers.each do |header|
    #         if row[header]
    #           metric = header[/\(.*?\)/].tr('()', '').strip
    #           if channel.measurements.find_by(created_at: created_at, metric: metric)
    #             Rails.logger.debug "found: [#{created_at}] #{metric} #{row[header]}"
    #           else
    #             channel.measurements.create({created_at: created_at.to_datetime, metric: metric, value: row[header]})
    #             Rails.logger.info "adding: [#{created_at}] #{metric} #{row[header]}"
    #           end
    #         end
    #       end
    #     end
    #   end
    # end

  end
end