const AWS = require('aws-sdk');
const s3 = new AWS.S3();
const { performance } = require('perf_hooks');

const coldStart = new Date();

function isPrime(n) {
    if (n <= 1) return false;
    for (let i = 2; i * i <= n; i++) {
        if (n % i === 0) return false;
    }
    return true;
}

exports.handler = async (event) => {
    const N = process.env.N;

    const bucketName = process.env.BUCKET_NAME;
    const startTime = performance.now();

    isPrime(N);
    const endTime = performance.now();

    const result = {
        language: "Node.js",
        cold_started_at: new Date(coldStart).toISOString(),
        warm_started_at: new Date(startTime).toISOString(),
        finished_at: new Date(endTime).toISOString(),
        cold_elapsed_time: (endTime - coldStart) + "ms",
        warm_elapsed_time: (endTime - startTime) + "ms",
        n: N
    };

    const params = {
        Bucket: bucketName,
        Key: 'result_node.json',
        Body: JSON.stringify(result)
    };

    await s3.putObject(params).promise();

    return `Dados salvos no S3: ${JSON.stringify(result)}`;
};
