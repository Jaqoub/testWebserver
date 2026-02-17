// Helper function to generate instance name from pod name
function generateInstanceName(podName: string): string {
  if (podName === "unknown") {
    return "instance-unknown";
  }
  
  // Hash pod navn for at få konsistent nummer
  let hash = 0;
  for (let i = 0; i < podName.length; i++) {
    const char = podName.charCodeAt(i);
    hash = ((hash << 5) - hash) + char;
    hash = hash & hash; // Convert to 32bit integer
  }
  
  // Get instance number (1-999) based on hash
  const instanceNum = (Math.abs(hash) % 999) + 1;
  return `instance-${instanceNum}`;
}

// API endpoint loader - returns JSON
export async function loader() {
  // Hent pod navn
  const podName = process.env.HOSTNAME || "unknown";
  
  // Generer instance navn
  const instanceName = generateInstanceName(podName);
  
  // Return JSON response using Response object
  return new Response(
    JSON.stringify({
      instance: instanceName,
      podName: podName,
      timestamp: new Date().toISOString(),
    }),
    {
      status: 200,
      headers: {
        "Content-Type": "application/json",
      },
    }
  );
}

