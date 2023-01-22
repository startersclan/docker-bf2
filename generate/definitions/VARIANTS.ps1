# Docker image variants' definitions
$local:VARIANTS_MATRIX = @(
    @{
        package_version = '1.5.3153.0'
        subvariants = @(
            @{ components = @(); tag_as_latest = $true }
            @{ components = @( 'bf2all64' ) }
            @{ components = @( 'bf2all64', 'bf2stats-2.2.0' ) }
            @{ components = @( 'bf2all64', 'bf2stats-2.3.4' ) }
            @{ components = @( 'bf2all64', 'bf2stats-2.4.2' ) }
            @{ components = @( 'bf2all64', 'bf2stats-3.1.0' ) }
            @{ components = @( 'bf2all64', 'bf2stats-3.1.2' ) }
            @{ components = @( 'bf2hub' ) }
            @{ components = @( 'bf2stats-2.2.0' ) }
            @{ components = @( 'bf2stats-2.3.4' ) }
            @{ components = @( 'bf2stats-2.4.2' ) }
            @{ components = @( 'bf2stats-3.1.0' ) }
            @{ components = @( 'bf2stats-3.1.2' ) }
            @{ components = @( 'fh2-4.6.304' ) }

        )
    }
)
$VARIANTS = @(
    foreach ($variant in $VARIANTS_MATRIX){
        foreach ($subVariant in $variant['subvariants']) {
            @{
                # Metadata object
                _metadata = @{
                    package_version = $variant['package_version']
                    package_sha256sum = '4d849218c1725e7bd6a7e7f164e27b036248f8ded2e30340dd0722c1dfffbab6'
                    platforms = if ($subVariant['components'] -match 'fh2') { 'linux/amd64' } else { 'linux/386,linux/amd64' }
                    components = $subVariant['components']
                }
                # Docker image tag. E.g. '1.5.3153.0', '1.5.3153.0-bf2stats-2.x.x', '1.5.3153.0-bf2all64-3.x.x'
                tag = @(
                        "v$( $variant['package_version'] )"
                        $subVariant['components'] | ? { $_ }
                ) -join '-'
                tag_as_latest = if ( $subVariant.Contains('tag_as_latest') ) {
                    $subVariant['tag_as_latest']
                } else {
                    $false
                }
            }
        }
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
        copies = @(
            '/vendor/ESAI-Standard-v4.2.zip'
            '/vendor/esai-helper'
            '/vendor/esai-optimized-strategies-bf2.txt'
            '/vendor/esai-optimized-strategies-bf2all64.txt'
            '/vendor/esai-optimized-strategies-xpack.txt'
            '/vendor/healthcheck'
            '/vendor/lowercase-helper'
        )
    }
}
