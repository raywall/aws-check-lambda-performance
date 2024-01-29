require 'json'
require 'aws-sdk-s3'
require 'time'

cold_start = Time.now.utc

def is_prime(n)
    return false if n <= 1
    (2..Math.sqrt(n)).none? { |i| n % i == 0 }
end

def lambda_handler(event:, context:)
    N = ENV['N'].to_i
    
    bucket_name = ENV['BUCKET_NAME']
    start_time = Time.now.utc
    
    is_prime(N)
    end_time = Time.now.utc

    result = {
        language: "Ruby",
        cold_started_at: cold_start.iso8601,
        warm_started_at: start_time.iso8601,
        finished_at: end_time.iso8601,
        cold_elapsed_time: (end_time - cold_start).to_s,
        warm_elapsed_time: (end_time - start_time).to_s,
        n: N
    }

    s3 = Aws::S3::Client.new
    s3.put_object(bucket: bucket_name, key: 'result_ruby.json', body: result.to_json)

    { message: "Dados salvos no S3", result: result }
end
