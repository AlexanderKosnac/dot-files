# Dot Files

A collection of dotfiles. Easy to install and update.

It creates/links the structure in the `dot-files` directory into the home
directory. Directories are created, files are only linked. This way the
directories can still easily contain other files, which are not part of the
repository, while files always redirect to the repository.


## Usage

Clone the repository into any directory and execute `make install`. Done.


## Makefile

### `install`

Installs the files into the home directory.

### `clean`

Removes all links in the home repository pointing to files in this repository.

### `all` (default)

First executes `clean` and then `install`.

