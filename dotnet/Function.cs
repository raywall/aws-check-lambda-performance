using Amazon.Lambda.Core;
using Amazon.S3;
using System.Text;
using System.Text.Json;

// Assembly attribute to enable the Lambda function's JSON input to be converted into a .NET class.
[assembly: LambdaSerializer(typeof(Amazon.Lambda.Serialization.SystemTextJson.DefaultLambdaJsonSerializer))]

namespace dotnet_lambda;

public class Function
{
    private static readonly DateTime coldStart = DateTime.UtcNow;
        
    /// <summary>
    /// A simple function that takes a string and does a ToUpper
    /// </summary>
    /// <param name="input"></param>
    /// <param name="context"></param>
    /// <returns></returns>
    public string FunctionHandler(string input, ILambdaContext context)
    {
        int 
            N = int.Parse(Environment.GetEnvironmentVariable("N")),
            count = 0;
        
        string bucketName = Environment.GetEnvironmentVariable("BUCKET_NAME");
        var startTime = DateTime.UtcNow;
        
        for (int i = 0; i < N; i++)
            if (IsPrime(i))
                count++;

        var endTime = DateTime.UtcNow;

        var result = new {
            language = ".NET",
            cold_started_at = coldStart.ToString("o"),
            warm_started_at = startTime.ToString("o"),
            finished_at = endTime.ToString("o"),
            cold_elapsed_time = (endTime - coldStart).ToString(),
            warm_elapsed_time = (endTime - startTime).ToString(),
            n = N
        };

        var jsonResult = JsonSerializer.Serialize(result);
        var byteArray = Encoding.UTF8.GetBytes(jsonResult);
        using var stream = new MemoryStream(byteArray);

        AmazonS3Client s3Client = new AmazonS3Client();
        s3Client.PutObjectAsync(new Amazon.S3.Model.PutObjectRequest
        {
            BucketName = bucketName,
            Key = "result_dotnet.json",
            InputStream = stream
        }).Wait();

        return $"Dados salvos no S3: {jsonResult}";
        // return input.ToUpper();
    }

    private static bool IsPrime(int n) {
            if (n <= 1) return false;

            for (int i = 2; i * i <= n; i++) {
                if (n % i == 0) return false;
            }

            return true;
        }
}