##
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
##
VERSION := $(shell ./gradlew -q --console=plain :version)
HDFS_VERSION := 3.3.6
IMAGE_NAME := arenadata/kafka-with-ts-plugin
IMAGE_VERSION := latest
IMAGE_TAG := $(IMAGE_NAME):$(IMAGE_VERSION)

.PHONY: all clean checkstyle build test integration_test e2e_test docker_image docker_push

all: clean build test

clean:
	./gradlew clean

checkstyle:
	./gradlew checkstyleMain checkstyleTest checkstyleIntegrationTest

build:
	./gradlew build shadowJar -x test -x integrationTest -x e2e:test -PhadoopVersion=$(HDFS_VERSION)

test: build
	./gradlew test -x e2e:test -PhadoopVersion=$(HDFS_VERSION)

integration_test: build
	./gradlew :storage-backend:integrationTest -PhadoopVersion=$(HDFS_VERSION)

E2E_TEST=Hdfs

e2e_test: build
	./gradlew e2e:test --tests $(E2E_TEST)* -PhadoopVersion=$(HDFS_VERSION)

.PHONY: docker_image
docker_image: build
	docker build . \
		-f docker/Dockerfile \
		--build-arg _VERSION=$(VERSION) \
		-t $(IMAGE_TAG)

.PHONY: docker_push
docker_push:
	docker push $(IMAGE_TAG)
