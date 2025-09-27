exports.handler = async () => {
  const message = process.env.MESSAGE || "Hello from AWS CI/CD via Terraform!";
  return {
    statusCode: 200,
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ ok: true, message, timestamp: new Date().toISOString() })
  };
};