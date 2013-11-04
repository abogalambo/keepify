require 'net/http'  
require 'uri'

module Keepify
	REQUEST_URL = 'http://analytics.keepify.com/kpy.png'
	MANDATORY_PARAMS = [:kpuid, :kpusr, :kpet]

	class Tracker

		def initialize(client_id)
			raise "client_id must be supplied" if(client_id.nil? || client_id.empty?)
			@options = {}
			@options[:kpusr] = client_id
		end

		def trackEvent(event_type, user_id, options = {})
			# merge with static params
			options.merge!(@options)

			# check for mandatory params
			if(event_type.nil? || event_type.empty?)
				raise "event_type should be supplied"
			elsif (user_id.nil? || user_id.empty?)
				raise "A user identifier (user email) should be supplied"
			else
				options[:kpuid] = user_id
				options[:kpet] = event_type
			end
       		
			uri = URI(REQUEST_URL)
			uri.query = URI.encode_www_form(options)
			res = Net::HTTP.get_response(uri)
			puts res.body if res.is_a?(Net::HTTPSuccess)
		end
	end
end