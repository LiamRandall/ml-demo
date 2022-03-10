# MlInference

This repository provides a [wasmCloud](https://wasmcloud.dev/) capability provider and corresponding interface being designed to do __inference__ based on a given AI model.

## Prerequisites

### Bindle

For development and/or in case you want to avoid security issues, use [bindle v0.7.1](https://github.com/deislabs/bindle/tags). Use the latest version otherwise.

### Docker Compose

Make sure your Docker install has [Compose v2](https://docs.docker.com/compose/cli-command/#installing-compose-v2). See also [Install wasmCloud with Docker](https://wasmcloud.dev/overview/installation/install-with-docker/).

## Build

From the top-level **directory** build with `make`.

## Deployment

General build artifacts are located in `/deploy`. Bindle specific build artifacts are located in `/bindle/models`. The script `/deploy/run.sh` drives the application. The application comprises a startup and shutdown of the following entities:

* nats
* registry
* bindle-server
* wasmCloud host

Type `./deploy/run.sh` for more information.

The script tries to launch __nats__ and __registry__ via `docker compose`. Following a recommendation from wasmCloud core-team the wasmCloud host is *not* started in a container. 

### Configuration

Depending on the respective [link definition](https://wasmcloud.dev/reference/host-runtime/links/), the capability provider tries to download artifacts from the bindle-server. You have to upload these artifacts first in order to make them downloadable by the capability provider. The following command uploads a pre-configured bindle. You have to call it only once.

`./deploy/run.sh create-bindle`

The definition of the bindle, `invoice_w_groups.toml`, and its two parcels, `identity_input_output.json` and `identity_input_output.onnx` are located in `/bindle/models`.

### Launch

Except the bindle-server, all entities are considered and started by using option `all`. Start the bindle-server first, then the other entities:

```bash
cd deploy
# the leading dot will execute the script in the context of the calling shell
# there are a few variable exports in that script which would be missed otherwise
. ./run.sh bindle-start

./run.sh all

# execute next line to stop the application (except bindle server)
# ./run.sh wipe

# execute next line to stop bindle server
# ./run.sh bindle-stop
```

After a successful startup the *washboard* should look similar to the following screenshot:

<div style="width: 80%; height: 50%">

![washboard after successful launch](images/washboard.png "washboard after successful launch")

</div>

Once the application is up and running, issue requests of the following kind:

```bash
curl -v -X POST 0.0.0.0:8078/model/challenger/index/0 -d '{"tensorType":{"ttype":0},"dimensions":[1,4],"data":[0,0,128,63,0,0,0,64,0,0,64,64,0,0,128,64]}'
```

The response should comprise `HTTP/1.1 200 OK` as well as `{"result":{"hasError":false},"tensor":{"tensorType":{"ttype":0},"dimensions":[1,4],"data":[0,0,128,63,0,0,0,64,0,0,64,64,0,0,128,64]}}`

The following happens:

1. The http __*POST*__ sends a request for a model with name *"challenger"*, index `0` and some data.
2. A response is computed. The result is sent back.
3. The `data` in the request equals `data` in the response because the pre-loaded model "*challenger*" is one that yields as output what it got as input.

## Creation of new bindles

The capability provider assumes a bindle to comprise two parcels where each parcel is assigned one of the following two groups:

* __*model*__
* __*metadata*__

The first, `model`, is assumed to comprise model data, e.g. an ONNX model. The second, `metadata`, is currently assumed to be json containing the metadata of the model. In case you create new bindles, make sure to assign these two groups.

## Status Quo

- [x] contract between Inference Engine capability provider (IE) and Inference actor (I)
- [x] dummy version of Inference Engine capability provider (IE) able to receive parameters via LinkDefinition
- [x] basic unittests
- [x] dummy version of Inference Engine capability provider (IE) able to download things from a bindle server
- [x] modification and integration of former WASI NN *like* functionality
- [x] API Actor (inferenceapi)
- [ ] tests
- [x] build and deployment scripts


## Further requirements (roadmap)

- [ ] The contract should be ready to process an array of Tensors.
- [ ] The `engine` in `MlinferenceProvider` shall be a *union* of concrete inference engines
