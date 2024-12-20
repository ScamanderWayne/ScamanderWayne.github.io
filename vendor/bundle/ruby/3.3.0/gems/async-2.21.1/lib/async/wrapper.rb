# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2017-2024, by Samuel Williams.
# Copyright, 2017, by Kent Gruber.

warn "Async::Wrapper is deprecated and will be removed on 2025-03-31. Please use native interfaces instead.", uplevel: 1, category: :deprecated

module Async
	# Represents an asynchronous IO within a reactor.
	# @deprecated With no replacement. Prefer native interfaces.
	class Wrapper
		# An exception that occurs when the asynchronous operation was cancelled.
		class Cancelled < StandardError
		end
		
		# @parameter io the native object to wrap.
		# @parameter reactor [Reactor] the reactor that is managing this wrapper, or not specified, it's looked up by way of {Task.current}.
		def initialize(io, reactor = nil)
			@io = io
			@reactor = reactor
			
			@timeout = nil
		end
		
		attr_accessor :reactor
		
		# Dup the underlying IO.
		def dup
			self.class.new(@io.dup)
		end
		
		# The underlying native `io`.
		attr :io
		
		# Wait for the io to become readable.
		def wait_readable(timeout = @timeout)
			@io.to_io.wait_readable(timeout) or raise TimeoutError
		end
		
		# Wait for the io to become writable.
		def wait_priority(timeout = @timeout)
			@io.to_io.wait_priority(timeout) or raise TimeoutError
		end
		
		# Wait for the io to become writable.
		def wait_writable(timeout = @timeout)
			@io.to_io.wait_writable(timeout) or raise TimeoutError
		end
		
		# Wait fo the io to become either readable or writable.
		# @parameter duration [Float] timeout after the given duration if not `nil`.
		def wait_any(timeout = @timeout)
			@io.to_io.wait(::IO::READABLE|::IO::WRITABLE|::IO::PRIORITY, timeout) or raise TimeoutError
		end
		
		# Close the underlying IO.
		def close
			@io.close
		end
		
		# Whether the underlying IO is closed.
		def closed?
			@io.closed?
		end
	end
end
