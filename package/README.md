
## AIR Package build for AppsFlyer

This build script assembles the airpackage and deploys it to the github repository using `apm` and the github cli (`gh`).




### Setup

- Run `ant bootstrap` to install the ant contrib libs.
- Install `apm` (https://airsdk.dev/docs/basics/install-apm)
- Install github cli (https://cli.github.com/)

Setup your configuration by copying the `example.build.config` file to `build.config` and update anything. If you have installed the above and they are available on your path, you will likely just need to set the version of the package.

### Build

To build the package:

```
ant build
```


### Deploy

To deploy the package to the repository and publish to apm

```
ant deploy
```


> Note: this will require you have released the matching version "release" in the github repository and that you have write access to the repository. The release should be named `vX.Y.Z`



