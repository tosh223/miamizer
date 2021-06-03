require 'aws-sdk-cloudformation'
require 'open3'

module Miamizer
  module_function
  def run_cmd!(cmd)
    _, err, status = Open3.capture3(cmd)
    unless err.empty?
      puts err
      exit(status.exitstatus)
    end
    status.exitstatus
  end

  def export(stack_name)
    client = Aws::CloudFormation::Client.new
    resp = client.list_stack_resources({ stack_name: stack_name })

    resources = []
    resp.stack_resource_summaries.select { |x| x.resource_type.start_with?('AWS::IAM') }.each do |resource|
      resources.push(%(--target "#{resource.physical_resource_id}"))
    end

    cmd = "bundle exec miam -e -o IAMfile --no-progress #{resources.join(' ')}"
    run_cmd!(cmd)
  end
end

if __FILE__ == $PROGRAM_NAME
  if ARGV[0].nil?
    puts 'Please set a stack_name.'
    exit(1)
  else
    status = Miamizer.export(ARGV[0])
    exit(status)
  end
end
