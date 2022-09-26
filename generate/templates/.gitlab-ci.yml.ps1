@'
image: docker:latest
services:
  - docker:dind
variables:
  DOCKER_DRIVER: overlay2

stages:
  - build

.build_template: &build_definition
  stage: build
  only:
    refs:
      - branches
      - /^v(?:\d+\.)+\d+$/
    variables:
      - $VARIANT_TAG
      - $VARIANT_TAG_WITH_VERSION
      - $VARIANT_BUILD_DIR
  except:
      refs:
        - master
  before_script:
  - date '+%Y-%m-%d %H:%M:%S %z'

  # Login to Docker Hub registry
  - echo "${DOCKERHUB_REGISTRY_PASSWORD}" | docker login -u "${DOCKERHUB_REGISTRY_USER}" --password-stdin

  # Login to GitLab registry
  - echo "${CI_REGISTRY_PASSWORD}" | docker login -u "${CI_REGISTRY_USER}" --password-stdin "${CI_REGISTRY}"

  script:
  - date '+%Y-%m-%d %H:%M:%S %z'

  - docker build
    -t "${DOCKERHUB_REGISTRY_USER}/${CI_PROJECT_NAME}:${VARIANT_TAG}"
    -t "${DOCKERHUB_REGISTRY_USER}/${CI_PROJECT_NAME}:${VARIANT_TAG_WITH_VERSION}"
    -t "${DOCKERHUB_REGISTRY_USER}/${CI_PROJECT_NAME}:latest"
    -t "${CI_REGISTRY_IMAGE}:${VARIANT_TAG}"
    -t "${CI_REGISTRY_IMAGE}:${VARIANT_TAG_WITH_VERSION}"
    -t "${CI_REGISTRY_IMAGE}:latest"
    "${VARIANT_BUILD_DIR}"

  - date '+%Y-%m-%d %H:%M:%S %z'

  # Push to Docker Hub registry. E.g. 'namespace/my-project:tag'
  - docker push "${DOCKERHUB_REGISTRY_USER}/${CI_PROJECT_NAME}:${VARIANT_TAG}"
  - docker push "${DOCKERHUB_REGISTRY_USER}/${CI_PROJECT_NAME}:${VARIANT_TAG_WITH_VERSION}"
  - docker push "${DOCKERHUB_REGISTRY_USER}/${CI_PROJECT_NAME}:latest"

  # Push to GitLab registry. E.g. 'registry.gitlab.com/namespace/my-project:tag
  - docker push "${CI_REGISTRY_IMAGE}:${VARIANT_TAG}"
  - docker push "${CI_REGISTRY_IMAGE}:${VARIANT_TAG_WITH_VERSION}"
  - docker push "${CI_REGISTRY_IMAGE}:latest"

  after_script:
  - date '+%Y-%m-%d %H:%M:%S %z'

  # Log out of Docker Hub registry
  - docker logout

  # Log out of GitLab registry
  - docker logout "${CI_REGISTRY}"

'@

$( $VARIANTS | % {
@"

build-$( $_['tag'] ):
  <<: *build_definition
  variables:
    VARIANT_TAG: $( $_['tag'] )
    VARIANT_TAG_WITH_VERSION: $( $_['tag'] )-`$CI_COMMIT_REF_NAME
    VARIANT_BUILD_DIR: $( $_['build_dir_rel'] )

"@
})
