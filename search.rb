# -*- coding:utf-8 -*-

require 'net/http'
require 'uri'
require 'json'


######### main ################
class Main
	def initialize
		filer = Filer.new
		req = Request.new

		filer.open
		word_ary = filer.ary

		print_str = ""
		word_ary.each do |word|
			uri = req.make_uri(word)
			p obj = req.get(uri)
			print_str << obj.to_s + ",\n"
			
		end

		filer.save(print_str)
	end
end


#######################
class Filer
	attr_accessor :ary

	def open
		@ary = []
		path = gets.chomp
		File.open(path) do |f|
			f.each_line do |line|
				tmp_ary = line.split
				tmp_ary.each{|word|@ary << word}
			end
		end
	end

	def save(str)
		file_name = "hit_results_log.txt"
		File.open(file_name, 'w') {|file|
 			file.write(str)
		}
	end
end

##############################
class Request

	def make_uri(search_word)
		api_key = "AIzaSyDhbDsRTKO4DsxH4pduODW-T67n04X5GGE"
		cse_id = "016740589553930948442:ctzdhmv4mma"
		uri_string = "https://www.googleapis.com/customsearch/v1?key="+api_key+"&cx="+cse_id+"&q="+search_word

		#encoding to formated URI
		uri = URI.escape(uri_string)
		uri = URI.parse(uri)
	end

	def get(uri)
		https = Net::HTTP.new(uri.host, uri.port)
		https.use_ssl = true
		res = https.start {
		  https.get(uri.request_uri)
		}

		if res.code == '200'
			result = JSON.parse(res.body)
		  	parsing(result)
		else
			puts "OMG!! #{res.code} #{res.message}"
			return false
		end
	end

	def parsing(result)
		query = result["queries"]
		request = query["request"]

		obj = {}
		obj["searchTerms"]= request[0]["searchTerms"]
		obj["totalResults"] = request[0]["totalResults"]
		return obj
	end

end
######### main ################
m = Main.new
