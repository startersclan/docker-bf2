
$VARIANTS = @(
    @{
        # Metadata object
        _metadata = @{
            platforms = 'linux/386,linux/amd64'
            components = @()
            installer_version = '1.5.3153.0'
            installer_sha1sum = 'f9f55b7c1cf9c8dcbffaa46ea1b0067146e047af'
        }
        # Docker image tag
        tag = 'v1.5.3153.0'
        tag_as_latest = $true
    }
)

# Docker image variants' definitions (shared)
$VARIANTS_SHARED = @{
    buildContextFiles = @{
        templates = @{
            'Dockerfile' = @{
                common = $true
                includeHeader = $false
                includeFooter = $false
                passes = @(
                    @{
                        variables = @{}
                    }
                )
            }
        }
    }
}
