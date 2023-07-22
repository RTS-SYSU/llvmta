print_info() {
	echo -e "\033[33m$*\033[0m"
}

print_info_n() {
	echo -e -n "\033[33m$*\033[0m"
}

print_error() {
	echo -e "\033[31m$*\033[0m"
}

print_error_n() {
	echo -e -n "\033[31m$*\033[0m"
}
print_success() {
	echo -e "\033[32m$*\033[0m"
}

print_success_n() {
	echo -e -n "\033[32m$*\033[0m"
}

print_warn() {
	echo -e "\033[35m$*\033[0m"
}

print_warn_n() {
	echo -e -n "\033[35m$*\033[0m"
}

# print_info "info"
# print_error "error"
# print_success "success"
# print_warn "warn"
