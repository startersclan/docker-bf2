# Docker image variants' definitions
$local:VARIANTS_MATRIX = @(
    @{
        package_version = '1.5.3153.0'
        package_sha256sum = '4d849218c1725e7bd6a7e7f164e27b036248f8ded2e30340dd0722c1dfffbab6'
        subvariants = @(
            @{ components = @(); tag_as_latest = $true }
            @{ components = @( 'bf2all64' ) }
            @{ components = @( 'bf2all64', 'bf2stats-2.2.0' ) }
            @{ components = @( 'bf2all64', 'bf2stats-2.3.4' ) }
            @{ components = @( 'bf2all64', 'bf2stats-2.4.3' ) }
            @{ components = @( 'bf2all64', 'bf2stats-3.1.0' ) }
            @{ components = @( 'bf2all64', 'bf2stats-3.1.2' ) }
            @{ components = @( 'bf2hub' ) }
            @{ components = @( 'bf2stats-2.2.0' ) }
            @{ components = @( 'bf2stats-2.3.5' ) }
            @{ components = @( 'bf2stats-2.4.3' ) }
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
                    package_sha256sum = $variant['package_sha256sum']
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
                        variables = @{
                            bf2stats_2_sha256sum = @"
4e91c5cdda63aaff1e2ccc20f40befcb603000eac25221be4cefbdebfdee6aec  2.3.0.zip
b9569819f7c58b70ff3e66d9219aed78ad6433d5cbba58f46b7bc0bf9eeb6d89  2.3.1.zip
448bc8a9d5adbad509f6d79e53ae030d4a5e0948bb301aaafe42c5442c1ffeef  2.3.2.zip
21c2a7cdd3acfa7365af39085b2a514212dd18821c1ec2817af40b4fca00c8a6  2.3.3.zip
37b6c6f08d5ac146185db8f3b2eb41add5f3dfb30ec79dda1b3c86ae7cac17e0  2.3.4.zip
81d37e150a44261dbac82b0f2590268ec8a9dc4a311bec0f0bf3a45d2969fb8d  2.3.5.zip
adb1c8d60b9cafc6f27d6722aa084b0bfefe828653abe8845c8858607cb7e3e0  2.4.0.zip
f1126f700eabf0164e389bfbf62d74cefe891fe2a888811c1da57a071a35f89f  2.4.1.zip
f7c47b22e30548737b05ddb9f8ef8e33a108b9184b4b2818759a318bd621f374  2.4.2.zip
8dc15a5398c070f1ceb236c2e78b5d6095338f6e075e4e7ca4345a50f0091cee  2.4.3.zip
"@
                            bf2stats_3_statspython_sha256sum = @"
ab6d0f2dc3c90223524a6d97dd3100796fdf266444b5cd2f066116b977d3551c  3.1.0.zip
fb739d900ea59e82147a6da9d7e72b329425b315bd8a08749a90fefc15365798  3.1.1.zip
21958c614ce880f63cd4c5a9db366ccacf68674cd89f50bbf95d9aa2d9bca878  3.1.2.zip
"@
                            fh2_sha256sum = @"
bb933052ad20928b5a4bc6c1eeff647d62b0f3b38de46d063101719a9f0cf488  fh2-server-4.6.304.tar
"@
                        }
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
