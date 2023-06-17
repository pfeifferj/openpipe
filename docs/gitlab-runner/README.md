# GitLab runner

- [Shell Executor](#shell-executor)
- [Kubernetes/Docker in Docker](#kubernetesdocker-in-docker)

## Shell Executor

## Kubernetes/Docker in Docker
Run privileged dind builds using the host systemd units required (libvirt, NetworkManager...)

- https://forum.gitlab.com/t/gitlab-runner-docker-systemd/9325
- https://developers.redhat.com/blog/2014/05/05/running-systemd-within-docker-container
- https://docs.gitlab.com/runner/configuration/advanced-configuration.html
- https://github.com/RobinR1/containers-libvirtd
- https://access.redhat.com/solutions/5558771
- https://developers.redhat.com/blog/2019/04/24/how-to-run-systemd-in-a-container#enter_podman

```toml
concurrent = 1
check_interval = 0
shutdown_timeout = 0

[session_server]
  session_timeout = 1800

[[runners]]
  name = "openpipe-example"
  url = "https://gitlab.com"
  id = 1234567890
  token = "foo"
  token_obtained_at = 2023-05-26T12:09:04Z
  token_expires_at = 0001-01-01T00:00:00Z
  executor = "docker"
  [runners.cache]
    MaxUploadedArchiveSize = 0
  [runners.docker]
    tls_verify = false
    image = "fedora"
    privileged = true
    disable_entrypoint_overwrite = false
    oom_kill_disable = false
    disable_cache = false
    volumes = ["/sys/fs/cgroup:/sys/fs/cgroup:ro","/cache"]
    shm_size = 0
```
