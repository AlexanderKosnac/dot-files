function create_file_from_template() {
    cat "${file_template_dir}/template-${1}" > "${2}"
}

alias "create-from-template-gitignore"="create_file_from_template 'gitignore' '.gitignore'"
