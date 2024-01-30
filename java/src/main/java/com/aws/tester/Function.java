import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.google.gson.Gson;
import java.io.ByteArrayInputStream;
import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.HashMap;
import java.util.Map;

public class Function implements RequestHandler<Object, String> {
    private static final Instant coldStart = Instant.now();

    public String handleRequest(Object input, Context context) {
        int N = Integer.parseInt(System.getenv("N"));
        
        String bucketName = System.getenv("BUCKET_NAME");
        Instant startTime = Instant.now();
        
        isPrime(N);
        Instant endTime = Instant.now();

        Map<String, Object> result = new HashMap<>();
        result.put("language", "Java");
        result.put("cold_started_at", coldStart.toString());
        result.put("warm_started_at", startTime.toString());
        result.put("finished_at", endTime.toString());
        result.put("cold_elapsed_time", java.time.Duration.between(coldStart, endTime).toString());
        result.put("warm_elapsed_time", java.time.Duration.between(startTime, endTime).toString());
        result.put("n", N);

        String jsonResult = new Gson().toJson(result);
        ByteArrayInputStream inputStream = new ByteArrayInputStream(jsonResult.getBytes(StandardCharsets.UTF_8));
        ObjectMetadata metadata = new ObjectMetadata();
        metadata.setContentLength(jsonResult.length());
        AmazonS3 s3Client = AmazonS3ClientBuilder.standard().build();
        s3Client.putObject(new PutObjectRequest(bucketName, "result_java.json", inputStream, metadata));

        return "Dados salvos no S3: " + jsonResult;
    }

    private static boolean isPrime(int n) {
        if (n <= 1) return false;
        
        for (int i = 2; i <= Math.sqrt(n); i++) {
            if (n % i == 0) return false;
        }

        return true;
    }
}
