note
	description: "[
			SSL enabled server
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	HTTP_SERVER

inherit
	HTTP_SERVER_I
		redefine
			new_listening_socket,
			process_incoming_connection
		end

create
	make

feature {NONE} -- Factory

	new_listening_socket (a_addr: detachable INET_ADDRESS; a_http_port: INTEGER): HTTP_STREAM_SOCKET
		do
			if configuration.is_secure then
				if a_addr /= Void then
					create {HTTP_STREAM_SSL_SOCKET} Result.make_ssl_server_by_address_and_port (a_addr, a_http_port, configuration.ssl_protocol, configuration.ca_crt, configuration.ca_key)
				else
					create {HTTP_STREAM_SSL_SOCKET} Result.make_ssl_server_by_port (a_http_port, configuration.ssl_protocol, configuration.ca_crt, configuration.ca_key)
				end
			else
				Result := Precursor (a_addr, a_http_port)
			end
		end


	process_incoming_connection (a_socket: HTTP_STREAM_SOCKET; a_connection_handler: HTTP_CONNECTION_HANDLER)
		do
			if attached {HTTP_STREAM_SSL_SOCKET} a_socket as a_ssl_socket then
				a_connection_handler.process_incoming_connection (a_ssl_socket)
			end
		end


end