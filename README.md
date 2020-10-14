# Dot Files

A collection of dotfiles. Easy to install and to update.

It creates/links the structure in the `dot-files` directory into the home
directory. Directories are created, files are only linked. This way the
directories can still easily contain other files, which are not part of the
repository, while files always redirect to repository.


## Usage

Simply execute the script `install.sh` from anywhere.

Available parameters are:

* `-f` force:
  * force the creation of links via `ln`

* `-v` verbose:
  * use the verbose flag for `ln` and `mkdir`

