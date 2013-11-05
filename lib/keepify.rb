require 'net/http'  
require 'uri'
require 'logger'

module Keepify
	REQUEST_URL = 'http://analytics.keepify.com/kpy.png'
	MANDATORY_PARAMS = [:kpuid, :kpusr, :kpet]

	class Tracker

		def initialize(client_id, async = false)
			raise "client_id must be supplied" if(client_id.nil? || client_id.empty?)
			if async
				require 'thread'
				@async = true
			end
			@options = {}
			@options[:kpusr] = client_id
			@logger = Logger.new(STDOUT)
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

			if(@async)
				Thread.new {
					send_request(uri)
				}
			else
				send_request(uri)
			end
			
		end

		private
		def send_request(uri)
			res = Net::HTTP.get_response(uri)
			@logger.error res.message unless res.is_a?(Net::HTTPSuccess)
		end
	end
end