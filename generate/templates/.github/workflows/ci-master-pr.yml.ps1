@'
name: ci-master-pr

on:
  push:
    branches:
    - master
    tags:
    - '**'
  pull_request:
    branches:
    - master
jobs:
'@

$local:WORKFLOW_JOB_NAMES = $VARIANTS | % { "build-$( $_['tag'].Replace('.', '-') )" }
$VARIANTS | % {
@"


  build-$( $_['tag'].Replace('.', '-') ):
    runs-on: ubuntu-latest
    env:
      VARIANT_TAG: $( $_['tag'] )
      VARIANT_BUILD_DIR: $( $_['build_dir_rel'] )
"@
@'

    steps:
    - name: Checkout
      uses: actions/checkout@v3

    - name: Display system info (linux)
      run: |
        set -e
        hostname
        whoami
        cat /etc/*release
        lscpu
        free
        df -h
        pwd
        docker info
        docker version

    # See: https://github.com/docker/build-push-action/blob/v2.6.1/docs/advanced/cache.md#github-cache
    - name: Set up QEMU
      uses: docker/setup-qemu-action@v2

    - name: Set up Docker Buildx
      id: buildx
      uses: docker/setup-buildx-action@master

    - name: Cache Docker layers
      uses: actions/cache@v3
      with:
        path: /tmp/.buildx-cache
        key: ${{ runner.os }}-buildx-${{ env.VARIANT_TAG }}-${{ github.sha }}
        restore-keys: |
          ${{ runner.os }}-buildx-${{ env.VARIANT_TAG }}-
          ${{ runner.os }}-buildx-

    - name: Prepare
      id: prep
      run: |
        set -e

        # Get 'namespace' and 'project-name' from 'namespace/project-name'
        # CI_PROJECT_NAMESPACE=$( echo "${{ github.repository }}" | cut -d '/' -f 1 )
        # CI_PROJECT_NAME=$( echo "${{ github.repository }}" | cut -d '/' -f 2 )

        # Get ref, i.e. <branch_name> from refs/heads/<branch_name>, or <tag-name> from refs/tags/<tag_name>. E.g. 'master' or 'v1.2.3'
        REF=$( echo "${GITHUB_REF}" | rev | cut -d '/' -f 1 | rev )

        # Get commit hash E.g. 'b29758a'
        SHA_SHORT=$( echo "${GITHUB_SHA}" | cut -c1-7 )

        # Generate the final tags. E.g. 'master-mytag' and 'master-b29758a-mytag'
        VARIANT_TAG_WITH_REF="${REF}-${VARIANT_TAG}"
        VARIANT_TAG_WITH_REF_AND_SHA_SHORT="${REF}-${SHA_SHORT}-${VARIANT_TAG}"

        # Pass variables to next step
        # echo "CI_PROJECT_NAMESPACE=$CI_PROJECT_NAMESPACE" >> $GITHUB_ENV
        # echo "CI_PROJECT_NAME=$CI_PROJECT_NAME" >> $GITHUB_ENV
        # echo "REF=$REF" >> $GITHUB_ENV
        # echo "SHA_SHORT=$SHA_SHORT" >> $GITHUB_ENV
        # echo "REF_AND_SHA_SHORT=$REF_AND_SHA_SHORT" >> $GITHUB_ENV
        echo "VARIANT_BUILD_DIR=$VARIANT_BUILD_DIR" >> $GITHUB_ENV
        echo "VARIANT_TAG=$VARIANT_TAG" >> $GITHUB_ENV
        echo "VARIANT_TAG_WITH_REF=$VARIANT_TAG_WITH_REF" >> $GITHUB_ENV
        echo "VARIANT_TAG_WITH_REF_AND_SHA_SHORT=$VARIANT_TAG_WITH_REF_AND_SHA_SHORT" >> $GITHUB_ENV

    - name: Login to docker registry
      if: github.ref == 'refs/heads/master' || startsWith(github.ref, 'refs/tags/')
      run: echo "${DOCKERHUB_REGISTRY_PASSWORD}" | docker login -u "${DOCKERHUB_REGISTRY_USER}" --password-stdin
      env:
        DOCKERHUB_REGISTRY_USER: ${{ secrets.DOCKERHUB_REGISTRY_USER }}
        DOCKERHUB_REGISTRY_PASSWORD: ${{ secrets.DOCKERHUB_REGISTRY_PASSWORD }}


'@
@"
    - name: Build (PRs)
      id: docker_build_pr
      # Run only on pull requests
      if: github.event_name == 'pull_request'
      uses: docker/build-push-action@v3
      with:
        context: `${{ env.VARIANT_BUILD_DIR }}
        platforms: $( $_['_metadata']['platforms'] -join ',' )
        push: false
        tags: |
          `${{ github.repository }}:`${{ env.VARIANT_TAG_WITH_REF }}
          `${{ github.repository }}:`${{ env.VARIANT_TAG_WITH_REF_AND_SHA_SHORT }}
        cache-from: type=local,src=/tmp/.buildx-cache
        cache-to: type=local,dest=/tmp/.buildx-cache-new,mode=max

    - name: Build and push (master)
      id: docker_build_master
      # Run only on master
      if: github.ref == 'refs/heads/master'
      uses: docker/build-push-action@v3
      with:
        context: `${{ env.VARIANT_BUILD_DIR }}
        platforms: $( $_['_metadata']['platforms'] -join ',' )
        push: true
        tags: |
          `${{ github.repository }}:`${{ env.VARIANT_TAG_WITH_REF }}
          `${{ github.repository }}:`${{ env.VARIANT_TAG_WITH_REF_AND_SHA_SHORT }}
        cache-from: type=local,src=/tmp/.buildx-cache
        cache-to: type=local,dest=/tmp/.buildx-cache-new,mode=max

    - name: Build and push (release)
      id: docker_build_release
      if: startsWith(github.ref, 'refs/tags/')
      uses: docker/build-push-action@v3
      with:
        context: `${{ env.VARIANT_BUILD_DIR }}
        platforms: $( $_['_metadata']['platforms'] -join ',' )
        push: true
        tags: |
          `${{ github.repository }}:`${{ env.VARIANT_TAG }}
          `${{ github.repository }}:`${{ env.VARIANT_TAG_WITH_REF }}
          `${{ github.repository }}:`${{ env.VARIANT_TAG_WITH_REF_AND_SHA_SHORT }}

"@

if ( $_['tag_as_latest'] ) {
@'
          ${{ github.repository }}:latest

'@
}
@'
        cache-from: type=local,src=/tmp/.buildx-cache
        cache-to: type=local,dest=/tmp/.buildx-cache-new,mode=max

    # Temp fix
    # https://github.com/docker/build-push-action/issues/252
    # https://github.com/moby/buildkit/issues/1896
    - name: Move cache
      run: |
        rm -rf /tmp/.buildx-cache
        mv /tmp/.buildx-cache-new /tmp/.buildx-cache

    - name: List docker images
      run: docker images

    - name: Clean-up
      run: docker logout
      if: always()
'@
}

@"


  update-draft-release:
    needs: [$( $local:WORKFLOW_JOB_NAMES -join ', ' )]
"@
@'

    if: github.ref == 'refs/heads/master'
    runs-on: ubuntu-latest
    steps:
      # Drafts your next Release notes as Pull Requests are merged into "master"
      - uses: release-drafter/release-drafter@v5
        with:
          config-name: release-drafter.yml
          publish: false
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
'@

@"


  publish-draft-release:
    needs: [$( $local:WORKFLOW_JOB_NAMES -join ', ' )]
"@
@'

    if: startsWith(github.ref, 'refs/tags/')
    runs-on: ubuntu-latest
    steps:
      # Drafts your next Release notes as Pull Requests are merged into "master"
      - uses: release-drafter/release-drafter@v5
        with:
          config-name: release-drafter.yml
          publish: true
          name: ${{ github.ref_name }} # E.g. 'master' or 'v1.2.3'
          tag: ${{ github.ref_name }} # E.g. 'master' or 'v1.2.3'
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

'@
