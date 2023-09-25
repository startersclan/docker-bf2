# Docker image variants' definitions
$local:VARIANTS_MATRIX = @(
    @{
        package_version = '1.5.3153.0'
        package_sha256sum = '4d849218c1725e7bd6a7e7f164e27b036248f8ded2e30340dd0722c1dfffbab6'
        subvariants = @(
            @{ components = @(); tag_as_latest = $true }
            @{ components = @( 'aix2' ) }
            @{ components = @( 'bf2all64' ) }
            @{ components = @( 'bf2all64', 'bf2stats-2.2.0' ) }
            @{ components = @( 'bf2all64', 'bf2stats-2.3.8' ) }
            @{ components = @( 'bf2all64', 'bf2stats-2.4.6' ) }
            @{ components = @( 'bf2all64', 'bf2stats-2.5.1' ) }
            @{ components = @( 'bf2all64', 'bf2stats-3.1.0' ) }
            @{ components = @( 'bf2all64', 'bf2stats-3.1.2' ) }
            @{ components = @( 'bf2all64', 'bf2stats-3.2.0' ) }
            @{ components = @( 'bf2hub' ) }
            @{ components = @( 'bf2stats-2.2.0' ) }
            @{ components = @( 'bf2stats-2.3.8' ) }
            @{ components = @( 'bf2stats-2.4.6' ) }
            @{ components = @( 'bf2stats-2.5.1' ) }
            @{ components = @( 'bf2stats-3.1.0' ) }
            @{ components = @( 'bf2stats-3.1.2' ) }
            @{ components = @( 'bf2stats-3.2.0' ) }
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
                    job_group_key = $variant['package_version']
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
af34261aec86749a65b358b5325639f724ae84f52c97f8cdddba6e867836e8eb  2.3.6.zip
89a0f56becd310c02cc7a8200c3a235bde7a7edf0b8b221c42aa60de02ae2d9a  2.3.7.zip
6de7a0e381163f056cc7da8aba5b29a2d9245e8b0319f8d78e0588c4ff1f3473  2.3.8.zip
adb1c8d60b9cafc6f27d6722aa084b0bfefe828653abe8845c8858607cb7e3e0  2.4.0.zip
f1126f700eabf0164e389bfbf62d74cefe891fe2a888811c1da57a071a35f89f  2.4.1.zip
f7c47b22e30548737b05ddb9f8ef8e33a108b9184b4b2818759a318bd621f374  2.4.2.zip
8dc15a5398c070f1ceb236c2e78b5d6095338f6e075e4e7ca4345a50f0091cee  2.4.3.zip
e9b6fe8ae1f2306b50d60a4ca05a39d02036b40e741884d3860959aa70b2500a  2.4.4.zip
b0a8b23841c5d3fac51650a6da8ff0e77c1d143a7aaf37c40c498077d71a2a2f  2.4.5.zip
59614e3afe781bef7d5e40ea306b3b9b9a700e2e4bf16c548a40916cf42ce882  2.4.6.zip
8dc705319c03fc9083f41f2b988e8dba1d54f43d3dd518fae1e5cb6c9b38a110  2.5.0.zip
3d736d1990d452e5da3f24d7d0eb1091a85a286239b5667fab98518cb1c115c9  2.5.1.zip
"@
                                        bf2stats_3_statspython_sha256sum = @"
ab6d0f2dc3c90223524a6d97dd3100796fdf266444b5cd2f066116b977d3551c  3.1.0.zip
fb739d900ea59e82147a6da9d7e72b329425b315bd8a08749a90fefc15365798  3.1.1.zip
21958c614ce880f63cd4c5a9db366ccacf68674cd89f50bbf95d9aa2d9bca878  3.1.2.zip
c43db3c1efbf437838af639b6f6151af5b5d88d2016bf49c765240524d199038  3.2.0.zip
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
                        '/vendor/aibehaviours-fixlookatwrapper.ai'
                        '/vendor/ESAI-Standard-v4.2.zip'
                        '/vendor/esai-helper'
                        '/vendor/esai-optimized-strategies-bf2.txt'
                        if ($subVariant['components'] -match 'bf2all64') {
                            '/vendor/esai-optimized-strategies-bf2all64.txt'
                        }
                        '/vendor/esai-optimized-strategies-xpack.txt'
                        '/vendor/healthcheck'
                        '/vendor/lowercase-helper'
                    )
                }
            }
        }
    }
)

# Docker image variants' definitions (shared)
$VARIANTS_SHARED = @{
}
