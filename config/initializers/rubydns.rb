unless $0.include?('/rake')
	require 'embedDNS'
	EmbedDNS.instance.start
end