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
            @{ components = @( 'bf2all64', 'bf2stats-2.6.0' ) }
            @{ components = @( 'bf2all64', 'bf2stats-2.7.2' ) }
            @{ components = @( 'bf2all64', 'bf2stats-2.8.1' ) }
            @{ components = @( 'bf2all64', 'bf2stats-2.9.4' ) }
            @{ components = @( 'bf2all64', 'bf2stats-3.1.0' ) }
            @{ components = @( 'bf2all64', 'bf2stats-3.1.2' ) }
            @{ components = @( 'bf2all64', 'bf2stats-3.2.0' ) }
            @{ components = @( 'bf2all64', 'bf2stats-3.3.0' ) }
            @{ components = @( 'bf2hub' ) }
            @{ components = @( 'bf2stats-2.2.0' ) }
            @{ components = @( 'bf2stats-2.3.8' ) }
            @{ components = @( 'bf2stats-2.4.6' ) }
            @{ components = @( 'bf2stats-2.5.1' ) }
            @{ components = @( 'bf2stats-2.6.0' ) }
            @{ components = @( 'bf2stats-2.7.2' ) }
            @{ components = @( 'bf2stats-2.8.1' ) }
            @{ components = @( 'bf2stats-2.9.4' ) }
            @{ components = @( 'bf2stats-3.1.0' ) }
            @{ components = @( 'bf2stats-3.1.2' ) }
            @{ components = @( 'bf2stats-3.2.0' ) }
            @{ components = @( 'bf2stats-3.3.0' ) }
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
                                        # Since bf2stats 2 python files
                                        # E.g. https://github.com/startersclan/bf2stats/archive/refs/tags/2.7.2.tar.gz
                                        bf2stats_2_sha256sum = @"
29a25c6e78062f34b05d7086aad530b598b4c9ed3f32164ffcf3b1c52b33f553  2.3.0.tar.gz
9a5e0544ba1474feb5ca0194449f6d6dee521abf59cba96dbc94387490d660b0  2.3.1.tar.gz
3949e8edfa35929816ac0756ff205e9bef9644f7da1aeb6b87a56048faf0f24a  2.3.2.tar.gz
99c7587a4f407a8f209e46f08985130d8da1931bc91b7bcfdce7b130c566d8ad  2.3.3.tar.gz
107153f0b063e8dc5974575861a5a75d2562322ee51eb9f7909452b1f9fc4e4a  2.3.4.tar.gz
b9395be32a76a226ce59a29ee44142d2bc20ca4dd254298ce37a973ae83e496a  2.3.5.tar.gz
9ed346672d049cc30a8f6c8f02ffe03bf424ba423ba39ba5221ba81451a31d6c  2.3.6.tar.gz
7a08582592f230a80f28e548b606cbdc16aca2488a97f8e1768c5857de63b6e6  2.3.7.tar.gz
4e334a262fdd3e04ac691005149e44a6fb4d4a4e1e31394cd1cdfa333a1a8801  2.3.8.tar.gz
8bddbbc4ddff99c769b368d58d6b562c342480695f0adc0d01867fc1adc3254a  2.4.0.tar.gz
e68f2a867eac0c234e4d02c01f4777d8b5135099ecb171476f5361e828ea581f  2.4.1.tar.gz
f9df9561ab49ff83608f1dba8c386fb1f79f115d11cdef47e5dc99bbf6c9366b  2.4.2.tar.gz
c4ef17a55854e8bf174729b281050468b0b6881d3c516233d30350c6adc1981d  2.4.3.tar.gz
0d320a5354d21c081bd94e98fc26a315d10989b62f36e34d21e4211535b20374  2.4.4.tar.gz
0e438634c5d371838522a67761dc67b9d9c4dd3530678aa3b1a93183352319cd  2.4.5.tar.gz
bf490e3c5d035872f248c15fd32deaf21c84bc254c9e9fd71ec17bb814543e09  2.4.6.tar.gz
de0468b62a510b1b074e6be41b79027edb4f3198940b65d01aa4947cafc27bf8  2.5.0.tar.gz
e07f46f0078fc0dcdbeb0dd86e1e9add4b502b0d7b263711dcad957ec4a6de61  2.5.1.tar.gz
7a75b58fec1b1d105c1a495e543eff6f2ee0fd0bf4ab010078539ef95e55f6e7  2.6.0.tar.gz
daeb57232cd1725bea3cf45c197fba13d99251864347ffff44552aae585b273a  2.7.0.tar.gz
96a9cd2c1283668e417f45ee14dec6307cbad9f310a81e2e8b5af95a871fef4f  2.7.1.tar.gz
bee8933873b42fff26aff34de964d54f4f470e256be43de7ab30ad122788d605  2.7.2.tar.gz
53927a41279cf904cc8d480fdee6f408a7ab68648a13ee5a313c60b44f58a92c  2.8.0.tar.gz
79083dfba50a3da954ef44a28c4eb07ba01237f305cd5fc6091ae6b6cd628b70  2.8.1.tar.gz
3bfc13168b5005aead6247021a3233a6d6037698e12451a545bfa25d1d2d6e69  2.9.4.tar.gz
"@
                                        # Since bf2stats 3 python files
                                        # E.g. https://github.com/startersclan/statspython/archive/refs/tags/3.2.0.tar.gz
                                        bf2stats_3_statspython_sha256sum = @"
de7080d9ecd0af9d547d434c83ec9826d8639a3ab05b10dc07f6ae5bb603149b  3.1.0.tar.gz
7bfd73109eb5edd686a05f421ec5a3542cf403b228412fc823e702f76c63848e  3.1.1.tar.gz
3a6478e92f3ce62bfd9f00c8dd1405ce9d97b03f6e1dcdcc83b1628fea3eb8f4  3.1.2.tar.gz
782dda8f985e35ad40cdc3bd72fb336aa87846a518b4157b6e1647faa3e8ddb4  3.2.0.tar.gz
"@
                                        # Since bf2stats 3 python files. Since 3.3.0, python files are in the same repo
                                        # E.g. https://github.com/startersclan/asp/archive/refs/tags/3.3.0.tar.gz
                                        bf2stats_3_sha256sum = @"
1da26288ad11e15b6838b73678ceab54b0f088e758e430dc636ad791d641f930  3.3.0.tar.gz
"@
                                        # Forgotten Hope 2
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
