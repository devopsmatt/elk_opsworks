resource_name :get_stack_nodes
property :stack_id, kind_of: String
property :region, kind_of: String
property :layer_id, kind_of: String
property :label, kind_of: String

action :run do
  require 'json'

  found_nodes = Hash.new
  qualified_status_codes = %w[ online ]

  unless [ nil ].include?(stack_id)
    cli_params = "--stack-id #{stack_id}"
  end
  unless [ nil ].include?(layer_id)
    cli_params = "--layer-id #{layer_id}"
  end

  cmd = "aws opsworks describe-instances #{cli_params}"
  resp = `#{cmd}`
  parsed = JSON.parse(resp)
  Chef::Log.info(parsed.inspect)

  parsed["Instances"].each do |i|
    node_status = i["Status"]
    if qualified_status_codes.include?(node_status)
      ip = i["PrivateIp"]
      hostname = i["Hostname"]
      Chef::Log.info("Injecting: #{hostname} => #{ip}")
      found_nodes["#{hostname}"] = "#{ip}"
    end
  end

  node.set['vel']['nodes'][new_resource.label] = found_nodes
  `echo #{found_nodes} >> /tmp/found_nodes`
end
