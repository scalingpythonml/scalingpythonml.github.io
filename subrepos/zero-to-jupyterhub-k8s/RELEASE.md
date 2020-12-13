# Release process

Start by making a release issue using the template below. The issue checklist
can be followed to release a new version of the Helm chart and help everybody
coordinate. Do some copy pasting!

## Issue title: Release x.y.z

This issue will be used to coordinate the next release of the Helm chart according to the instructions in `RELEASE.md`. Below is a checklist for this release.

## Look through dependencies

The JupyterHub Helm chart relies on many dependent projects, and when we make a release we should note major updates for these projects as well as the version that is specified in the Helm chart. Below are the more important dependencies. Put a check on those that reach a state good enough for a z2jh release to be cut.

### Dependent Python packages

Update JupyterHub's Python dependencies in `images/hub/requirements.txt` by going to the folder and running `./dependencies freeze --upgrade`.

Also consider nudging dependent projects in the JupyterHub GitHub organization for a release.

- [ ] [jupyterhub](https://github.com/jupyterhub/jupyterhub)
- [ ] [kubespawner](https://github.com/jupyterhub/kubespawner)
- [ ] [oauthenticator](https://github.com/jupyterhub/oauthenticator)

### Dependent docker images

These images version/tags are set in [values.yaml](jupyterhub/values.yaml), consider bumping the version of these as well.

- [ ] [configurable-http-proxy](https://github.com/jupyterhub/configurable-http-proxy)
  - [Available image tags](https://hub.docker.com/r/jupyterhub/configurable-http-proxy/tags)
  - values.yaml entry: `proxy.chp.image`
- [ ] [traefik/traefik](https://github.com/traefik/traefik)
  - [Available image tags](https://hub.docker.com/_/traefik?tab=tags)
  - values.yaml entry: `proxy.traefik.image`
- [ ] [kube-scheduler](https://github.com/kubernetes/kube-scheduler)
  - [Available image tags](https://gcr.io/google_containers/kube-scheduler-amd64)
  - values.yaml entry: `scheduling.userScheduler.image`
- [ ] [kubernetes/pause](https://github.com/kubernetes/kubernetes/tree/master/build/pause)
  - values.yaml entry: `prePuller.pause.image`

Also the images we build are based on some image specified in the `FROM` statement, consider if we want to bump those versions as well.

- [ ] [hub](images/hub/Dockerfile)
- [ ] [image-awaiter](images/image-awaiter/Dockerfile)
- [ ] [network-tools](images/network-tools/Dockerfile)
- [ ] [singleuser-sample](images/singleuser-sample/Dockerfile)


## Pre-release iteration

- Update `CHANGELOG.md`
  - [ ] Generate a list of PRs using [executablebooks/github-activity](https://github.com/executablebooks/github-activity)
    ```bash
    github-activity --output github-activity-output.md --since <last tag> jupyterhub/zero-to-jupyterhub-k8s
    ```
  - [ ] Visit and label all uncategorized PRs appropriately with: `maintenance`, `enhancement`, `breaking`, `bug`, or `documentation`.
  - [ ] Generate a list of PRs again and add it to the changelog
  - [ ] Highlight breaking changes
  - [ ] Summarize the release changes

- Tag a x.y.z-beta.1 release
  - [ ] Create and push a git tag
    ```bash
    git checkout master
    git reset --hard <upstream>/master
    git tag -a x.y.z-beta.1 -m x.y.z-beta.1 <commit on master>
    git push --follow-tags <upstream> master
    ```

- Announce the x.y.z-beta.1 release
  - [ ] Write a discourse post

## Final release

- Update `CHANGELOG.md`
  - [ ] Generate a list of merged PRs and a list of contributors and update the changelog.
    ```bash
    github-activity --output github-activity-output.md --since <last tag> jupyterhub/zero-to-jupyterhub-k8s
    ```
  - [ ] Link out to the downstream projects within the JupyterHub org to celebrate work done there as well.

- Release
  - [ ] Create and push a git tag.
    ```bash
    git checkout master
    git reset --hard <upstream>/master
    git tag -a x.y.z -m x.y.z HEAD
    git push --follow-tags <upstream> master
    ```

  - [ ] Create a GitHub release.
    Visit the [release page](https://github.com/jupyterhub/zero-to-jupyterhub-k8s/releases) and create a new release referencing the recent tag. Add a brief text like the one below.

- Communicate
  - [ ] Update the beta release's discourse post.
