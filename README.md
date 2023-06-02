# OpenShift Local Cluster Integration Test Runner

[![GitHub Super-Linter](https://github.com/pfeifferj/openpipe/actions/workflows/linter.yml/badge.svg)](https://github.com/marketplace/actions/super-linter)

This is an open source project that enables users to run integration tests against an OpenShift local cluster in their GitLab CI pipelines. The integration tests are written in any language and framework, and this tool provides an easy way to set up and tear down a local cluster for testing.

OpenPipe aims to shift left integration tests by eliminating the operational overhead a full-on dev cluster brings with it.

If you're looking for a more lightweight, but less production-like solution that mocks the OpenShift API, check out [static KAS](https://github.com/alvaroaleman/static-kas).

## Minimal requirements

- image registry credentials
- gitlab runner with connectivity to your image registry
- gitlab runner with virutalization enabled in host system BIOS
- gitlab runner with [privileged mode enabled](https://docs.gitlab.com/runner/executors/docker.html#privileged-mode) (sandboxed containers recommended for workload isolation for runners on Kubernetes clusters)
- gitlab runner with at least 9216MiB of free memory, 35GiB disk, 4 CPU cores (this is the minimum for the base cluster to run. extensve custom configuration, and resource intensive deployments will require more resources)
- if your gitlab runner host system uses SELinux and you want to run containers with systemd you have set the container_manage_cgroup boolean variable: `setsebool -P container_manage_cgroup 1`
- a pull secret from the [Red Hat console](https://console.redhat.com/openshift/create/local)

## Optional

- gitlab runner with connectivity to [developers.redhat.com](https://developers.redhat.com) (to build openshift local containter images from source)

## Quickstart example

Create a `.gitlab-ci.yml` file in the root of your project.
Add the following job to your pipeline:

```yaml
include: "https://raw.githubusercontent.com/pfeifferj/openpipe/main/.gitlab-ci.yml"

integration_test:
  extends: setup_openshift_local
  script:
    - ./run-tests.sh
```

The pipeline should end up looking something like this:

![pipeline](/docs/images/pipeline.png)

Add any necessary environment variables or configuration files to the integration_test job.

### Minimal required variables

- `PULL_SECRET` # set this variable in your repository variables, mask, and protect it. the variable value is the contnet of the pull secret file you downloaded
- `REGISTRY_PASSWORD` # token to pull from quay.io or your own registry

### Optional variables

- `REGISTRY_URL` # to use your image registry
- `REGISTRY_USER` # robot username
- `REGISTRY_PASSWORD` # robot user password
- `RUNNER_TAG` # gitlab runner tag

Create a `run-tests.sh` script in the root of your project that runs your integration tests against the OpenShift cluster.

Push your changes to GitLab and watch the pipeline run the integration tests against the OpenShift local cluster.

<!-- ## Available variables -->

<!-- OpenShift credentials -->

## Configuration

[openpipe container images](https://quay.io/repository/openpipe/oc-local-runner?tab=tags)

<!-- The following environment variables can be used to configure the integration test runner: -->

## Limitations & pitfalls

### Cluster

- The cluster uses the 172 address range. This can cause issues when, for example, a proxy is run in the same address space.
- The cluster runs in a virtual machine which may behave differently, particularly with external networking.
- The cluster uses a single node which behaves as both a control plane and worker node.
- Troubleshooting resources for OpenShift Local can be found [in the documentation](https://crc.dev/crc/#troubleshooting_gsg).

### GitLab runners

- Shared runners don't meet the resource requirements. Therefore, it is recommended to deploy dedicated runners with the appropriate resource requests. Cf. [gitlab docs](https://docs.gitlab.com/runner/executors/kubernetes.html#cpu-requests-and-limits)

## Contributing

Contributions are welcome! Please fork this repository and submit a pull request with your changes.

## License

This project is licensed under the MIT License.
