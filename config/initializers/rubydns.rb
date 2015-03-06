unless $0.include?('/rake') || !$0.include?('unicorn')
	require 'embedDNS'
	EmbedDNS.instance.start
end