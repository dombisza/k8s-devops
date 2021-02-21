base:
  '*controller':
    - docker
    - k8s
    - master_init
  '*worker':
    - docker
    - k8s
