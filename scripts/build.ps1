# Check Node.js version
$REQUIRED_NODE_VERSION = 22
$CURRENT_NODE_VERSION = [int](node -v).Substring(1).Split('.')[0]

if ($CURRENT_NODE_VERSION -lt $REQUIRED_NODE_VERSION) {
    Write-Host "Error: Node.js version must be $REQUIRED_NODE_VERSION or higher. Current version is $CURRENT_NODE_VERSION."
    exit 1
}

# Navigate to the script's directory
Set-Location (Split-Path $MyInvocation.MyCommand.Path)
Set-Location ..

# Check if the packages directory exists
if (-not (Test-Path "packages")) {
    Write-Host "Error: 'packages' directory not found."
    exit 1
}

# Define packages to build in order
$PACKAGES = @(
    "core",
    "plugin-trustdb",
    "plugin-solana",
    "plugin-starknet",
    "adapter-postgres",
    "adapter-sqlite",
    "adapter-sqljs",
    "adapter-supabase",
    "client-auto",
    "client-direct",
    "client-discord",
    "client-telegram",
    "client-twitter",
    "plugin-node",
    "plugin-bootstrap",
    "plugin-image-generation"
)

# Build packages in specified order
foreach ($package in $PACKAGES) {
    $package_path = "packages\$package"

    if (-not (Test-Path $package_path)) {
        Write-Host "Package directory '$package' not found, skipping..." -ForegroundColor Yellow
        continue
    }

    Write-Host "Building package: $package" -ForegroundColor Cyan
    Push-Location $package_path

    if (Test-Path "package.json") {
        if (npm run build) {
            Write-Host "Successfully built $package" -ForegroundColor Green
        }
        else {
            Write-Host "Failed to build $package" -ForegroundColor Red
            exit 1
        }
    }
    else {
        Write-Host "No package.json found in $package, skipping..."
    }

    Pop-Location
}

Write-Host "Build process completed.😎" -ForegroundColor Cyan