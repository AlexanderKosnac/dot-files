source scripts/shared.sh

ln_params=""
verbose_param=""
unused_arguments=""

for arg in "$@"
do
    case $arg in
        -f)
        ln_params="-f"
        shift
        ;;
        -v)
        verbose_param="-v"
        shift
        ;;
        *)
        unused_arguments+=("$1")
        shift
        ;;
    esac
done

# directories should be actually created instead of linked
for d in $DIRS; do
    mkdir -p ${verbose_param} "${HOME}/${d}"
done

# link the files
for f in $FILES; do
    source="$(realpath "${DOT_FILES_DIRECTORY}/${f}")"
    target="${HOME}/${f}"

    md5_source=($(md5sum $source))
    md5_target="none"
    if test -f "$target"; then
        md5_target=($(md5sum $target))
    fi


    if [ "$md5_source" != "$md5_target" ]; then
        ln -si ${ln_params} ${verbose_param} "$source" "$target"
        echo "$source -> $target"
    else
        echo "already installed: '$(basename $source)'"
    fi
done

echo "installation done"
