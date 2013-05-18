require 'FileUtils'

class VideoSlicer 

	attr_reader :input_file_name, :output_file, :slices

	def initialize(input_file_name, output_file, slices)
		@input_file_name = input_file_name
		@output_file = output_file
		@slices = slices
		FileUtils.mkdir_p 'temp'
	end

	def slice_and_concat!
		slice!
		concat!
	end

	def slice!
		@slices.each_with_index do |slice, index|
			do_slice!(slice.first, slice.last - slioce.first, index)
		end
	end

	def do_slice!(start_time, slice_length, index)
		`ffmpeg -i #{@input_file_name} -ss #{start_time} -t #{slice_length} -y temp/#{index}#{@output_file}`
	end

	def concat!
		File.open('test.txt', 'w') do |file| 
			Dir.foreach("temp") do |file_name|
				next if file_name == '.' or file_name == '..'
				file.puts("file temp/#{file_name}")
			end
  		end
  		concat_string = `ffmpeg -f concat -i test.txt -y -c copy #{@output_file}`
	end

end

# FileUtils.rmdir 'temp'
# slices = [[1, 3], [20, 21], [12, 13]]
# x = VideoSlicer.new('Wildlife.wmv', 'slicedWildlife.wmv', slices)
# x.slice_and_concat!