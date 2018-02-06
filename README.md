# atlas-wrapper
A wrapper to run ATLAS within a Docker container

Copyright Jackson M. Tsuji, 2017


This script is still in progress - early development only.

### Running via Docker
1. Build the container
```
docker build -t pnnl/atlas:1.0.22 github.com/jmtsuji/atlas-wrapper.git
```

2. Run the container
```
docker run -it pnnl/atlas:1.0.22 /bin/bash
atlas -h # Can see ATLAS options once inside the container.
```

Note that step 2 is just a basic example. You'll need to mount your database and metagenome files in the container to actually run ATLAS. This will be handled by the wrapper script still in development.

Also note that database download is done separately from the Docker install. Will also be handled by the wrapper in development...

