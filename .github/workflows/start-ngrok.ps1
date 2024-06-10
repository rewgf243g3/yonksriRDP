# start-ngrok.ps1

# Start ngrok process
$ngrokProcess = Start-Process .\ngrok.exe -ArgumentList "tcp 3389" -PassThru

# Give ngrok some time to start
Start-Sleep -Seconds 10

# Initialize ngrok URL
$ngrokUrl = ""

# Try to fetch the ngrok public URL
while ($true) {
    try {
        $tunnels = Invoke-RestMethod -Uri http://127.0.0.1:4040/api/tunnels
        if ($tunnels.tunnels) {
            $ngrokUrl = $tunnels.tunnels[0].public_url
            Write-Output "ngrok tunnel is available at: $ngrokUrl"
            break
        }
    } catch {
        Write-Output "Waiting for ngrok to initialize..."
        Start-Sleep -Seconds 5
    }
}

if (-not $ngrokUrl) {
    Stop-Process -Id $ngrokProcess.Id
    throw "Failed to create ngrok tunnel"
}

# Loop to keep the script running
while ($true) {
    Start-Sleep -Seconds 300
}
