require 'tesseract'
require 'RMagick'

class PanatransOCR
  def self.convert(filename, in_format, out_format)
    input_file = "#{filename}.#{in_format}"
    output_file = "#{filename}.#{out_format}"

    image = Magick::ImageList.new(input_file) { self.density = 300 } # fair enough

    image.write(output_file)

    img = Magick::Image::read(output_file)[0]
    img = img.threshold(1600) # magic value, blackest image!!!

    img.write(output_file)
    output_file
  end
end

name = "test"
input_format = "pdf"
output_format = "jpg"

output_file = PanatransOCR.convert(name, input_format, output_format)

e = Tesseract::Engine.new {|e|
  e.language  = :spa
}

unless output_file

  e.lines_for(output_file).each do |l|
    puts l.to_s.gsub(/[^0-9a-z ]/i, '')
  end

end
