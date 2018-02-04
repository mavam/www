class GzipFilter < Nanoc::Filter
  require 'zlib'

  identifier :gzip
  type :text => :binary

  def run(content, params = {})
    level = params[:level] || Zlib::BEST_COMPRESSION
    Zlib::GzipWriter.open(output_filename, level, params[:strategy]) do |gz|
      gz.write(content)
    end
  end
end


