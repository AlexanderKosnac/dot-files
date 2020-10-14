root_directory="$(git -C "$(dirname "$0")" rev-parse --show-toplevel)"

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

dot_files_directory="${root_directory}/dot-files/"

# directories should be actually created instead of linked
dirs="$(cd "${dot_files_directory}"; find . -type d)"
for d in $dirs; do
    mkdir -p ${verbose_param} "${HOME}/${d}"
done

# link the files
files="$(find "${dot_files_directory}" -type f)"
for f in $files; do
    ln -si ${ln_params} ${verbose_param} "$(realpath "$f")" "${HOME}"
done

echo "installation done"
