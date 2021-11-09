# Model Project Structure

Template repository with my baseline project directory structure and
a simple helper script for encrypting secrets.

## Directories

* `bin`: Useful scripts for working with the project. There's one
  script common to all projects  to simplify encrypting and 
  decryting project secrets. The `direnv` configuration in the
  template `.envrc` file add this to `PATH` for ease of use.
* `secrets`: Directory for storing project secrets. They should only
  be added to git when encrypted. The `secrets` script allows for 
  easy encrypt/decrypt using GPG.
* `work`: For working files that should not be added the repo. Any
  script in the project can depend on this directory being there 
  for working storage.


