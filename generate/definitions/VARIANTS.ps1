
$VARIANTS = @(
    @{
        # Metadata object
        _metadata = @{
            platforms = 'linux/386,linux/amd64'
            components = @()
            installer_version = '1.5.3153.0'
            installer_sha256sum = 'b5afe6602280b99797b46389f3cd582bbfe212e7402c8b009b72e6ae41e8d435'
        }
        # Docker image tag
        tag = 'v1.5.3153.0'
        tag_as_latest = $true
    }
    @{
        # Metadata object
        _metadata = @{
            platforms = 'linux/386,linux/amd64'
            components = @( 'bf2hub' )
            installer_version = '1.5.3153.0'
            installer_sha256sum = 'b5afe6602280b99797b46389f3cd582bbfe212e7402c8b009b72e6ae41e8d435'
        }
        # Docker image tag
        tag = 'v1.5.3153.0-bf2hub'
        tag_as_latest = $false
    }
    @{
        # Metadata object
        _metadata = @{
            platforms = 'linux/386,linux/amd64'
            components = @( 'bf2stats' )
            installer_version = '1.5.3153.0'
            installer_sha256sum = 'b5afe6602280b99797b46389f3cd582bbfe212e7402c8b009b72e6ae41e8d435'
        }
        # Docker image tag
        tag = 'v1.5.3153.0-bf2stats'
        tag_as_latest = $false
    }
    @{
        # Metadata object
        _metadata = @{
            platforms = 'linux/amd64' # fh2 can't get c++6 dependencies for linux/386, so we only build linux/amd64
            components = @( 'fh2' )
            installer_version = '1.5.3153.0'
            installer_sha256sum = 'b5afe6602280b99797b46389f3cd582bbfe212e7402c8b009b72e6ae41e8d435'
            mod_installer_version = '4.6.304'
            mod_installer_sha256sum = 'bb933052ad20928b5a4bc6c1eeff647d62b0f3b38de46d063101719a9f0cf488'
        }
        # Docker image tag
        tag = 'v1.5.3153.0-fh2-4.6.304'
        tag_as_latest = $false
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
            '/vendor/esai-optimized-strategies-xpack.txt'
        )
    }
}
