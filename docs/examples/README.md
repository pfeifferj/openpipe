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
