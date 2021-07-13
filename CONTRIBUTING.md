# Developing

[Developers workflow](docs/contributing/workflow.md).

## Build site

For build site use [Docker][Docker]:

```
make build
```

Run this command every first start of project.

## Run site

For run serving of the site use [Docker][Docker]:

```
make run
```

## Build docker image:

For build docker image with specified tag:

```
make docker.build TAG=tag_name IMAGE=image_name
```

Default tag name is `dev`.

Default image name is `registry.gitlab.com/karamba-project/karma-info.io`


## Login in Gitlab docker registry.

For login on [GitLab docker registry][Gitlab docker registry]


```
make docker.auth user=[username] 
```

## Push docker image 

For push docker image into [GitLab docker registry][Gitlab docker registry]

```
make docker.push TAG=[tag_name] IMAGE= [image_name]
```

Default tagname is `dev` 

Default image_name is  `registry.gitlab.com/karamba-project/karma-info.io`

## Pull docker image 

For pull docker image from [GitLab docker registry][Gitlab docker registry]

```
make docker.pull TAG=[tag_name]
```

Default tag_name is `dev`

Default image_name is  `registry.gitlab.com/karamba-project/karma-info.io`


For more info about make tasks see [Makefile](Makefile)




[Docker]: https://www.docker.com/
[Gitlab docker registry]: https://docs.gitlab.com/ee/user/project/container_registry.html
