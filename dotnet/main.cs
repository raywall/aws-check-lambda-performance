public class Function
{
    private static readonly DateTime coldStart = DateTime.UtcNow;

    public string FunctionHandler(ILambdaContext context)
    {
        int N = int.Parse(Environment.GetEnvironmentVariable("N"));
        
        string bucketName = Environment.GetEnvironmentVariable("BUCKET_NAME");
        var startTime = DateTime.UtcNow;
        
        IsPrime(N)
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
        s3Client.PutObjectAsync(new PutObjectRequest {
            BucketName = bucketName,
            Key = "result_dotnet.json",
            InputStream = stream
        }).Wait();

        return $"Dados salvos no S3: {jsonResult}";
    }

    private bool IsPrime(int n) {
        if (n <= 1) return false;

        for (int i = 2; i * i <= n; i++) {
            if (n % i == 0) return false;
        }

        return true;
    }
}