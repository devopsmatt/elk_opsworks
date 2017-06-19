source "https://supermarket.chef.io"

cookbook 'aws', '~> 6.1.0'
cookbook 'cloudcli', '~> 1.2.0'

Dir.glob(File.join(File.dirname(__FILE__), './*')).each do |cb|
	if File.directory?(cb) && File.exists?(File.join(cb, 'metadata.rb'))
		cookbook File.basename(cb), path: cb
	end
end
