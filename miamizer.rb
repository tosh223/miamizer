require 'aws-sdk-cloudformation'
require 'open3'
require 'optparse'

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

  def export(stack_name, profile)
    Aws.config[:credentials] = Aws::SharedCredentials.new(profile_name: profile)
    client = Aws::CloudFormation::Client.new
    resp = client.list_stack_resources({ stack_name: stack_name })

    resources = []
    resp.stack_resource_summaries.select { |x| x.resource_type.start_with?('AWS::IAM') }.each do |resource|
      resources.push(%(--target "#{resource.physical_resource_id}"))
    end

    cmd = if profile.nil?
            "bundle exec miam -e --split --no-progress #{resources.join(' ')}"
          else
            "bundle exec miam -e -p #{profile} --split --no-progress #{resources.join(' ')}"
          end

    run_cmd!(cmd)
  end
end

if __FILE__ == $PROGRAM_NAME
  stack_name = nil
  profile = nil

  opt = OptionParser.new
  opt.on('-s', '--stack_name=[stack_name]') { |val| stack_name = val }
  opt.on('-p', '--profile=[profile]') { |val| profile = val }
  opt.parse!(ARGV)

  if stack_name.nil?
    if ARGV[0].nil?
      puts 'Please set a AWS stack name.'
      exit(1)
    else
      stack_name = ARGV[0]
    end
  end

  status = Miamizer.export(stack_name, profile)
  exit(status)
end
