def logger_info(msg: str):
    # use normal print for now
    print(f'[*] {msg}')


def logger_success(msg: str):
    # change to green color
    print(f'[+] \033[92m{msg}\033[0m')


def logger_error(msg: str):
    # change to red color
    print(f'[-] \033[91m{msg}\033[0m')
