use lambda_runtime::{handler_fn, Context, Error};
use serde_json::json;
use std::env;
use std::time::Instant;
use rusoto_core::Region;
use rusoto_s3::{S3Client, S3, PutObjectRequest};
use std::str::FromStr;

static COLD_START: OnceCell<Instant> = OnceCell::new();

async fn func(_: serde_json::Value, _: Context) -> Result<String, Error> {
    let n: i32 = env::var("N").unwrap().parse().unwrap();
    
    let bucket_name = env::var("BUCKET_NAME").unwrap();
    let start_time = Instant::now();
    
    is_prime(n);
    let end_time = Instant::now();

    let result = json!({
        "language": "Rust",
        "cold_started_at": format!("{:?}", COLD_START),
        "warm_started_at": format!("{:?}", start_time),
        "finished_at": format!("{:?}", end_time),
        "cold_elapsed_time": format!("{:?}", end_time.duration_since(COLD_START)),
        "warm_elapsed_time": format!("{:?}", end_time.duration_since(start_time)),
        "n": n
    });

    let client = S3Client::new(Region::from_str(&env::var("AWS_REGION").unwrap()).unwrap());
    let put_request = PutObjectRequest {
        bucket: bucket_name,
        key: "result_rust.json".to_string(),
        body: Some(result.to_string().into_bytes().into()),
        ..Default::default()
    };

    client.put_object(put_request).await?;

    Ok(format!("Dados salvos no S3: {}", result))
}

fn is_prime(n: i32) -> bool {
    if n <= 1 {
        return false;
    }
    for i in 2..=((n as f64).sqrt() as i32) {
        if n % i == 0 {
            return false;
        }
    }
    true
}

#[tokio::main]
async fn main() -> Result<(), Error> {
    let _ = COLD_START.set(Instant::now());
    
    let func = handler_fn(func);
    lambda_runtime::run(func).await?;
    Ok(())
}