

# example: python create_prometheus_config.py --client 234:200 234:000 --server 235:555
import argparse
import re

NETDATA_SERVER_KEY: str = 'netdata-server'
NETDATA_CLIENT_KEY: str = 'netdata-client'
NETDATA_PORT:str = '19999'
netdata_pattern: str = "\'{your.netdata.ip}:19999\'"


arg_parser = argparse.ArgumentParser()
arg_parser.add_argument('-s', '--server', nargs='+',
                        help='the public server IP', type=str)
arg_parser.add_argument('-c', '--client', nargs='+',
                        help='the public client IPs', type=str)

arguments = arg_parser.parse_args()


def read_file(file_path: str) -> str:
    with open(file_path, 'r') as f:
        contents = f.read()
        return contents


def write_file(file_path: str, content: str) -> None:
    with open(file_path, 'w') as f:
        f.write(content)


def create_target_string(targets: list[str]) -> str:
    return ", ".join(f"'{t}:{NETDATA_PORT}'" for t in targets)


def get_ips(target_key: str) -> str:
    target = arguments.client if target_key == NETDATA_CLIENT_KEY else arguments.server
    return create_target_string(target)


def main():
    yaml_file = read_file('prometheus_skeleton.yml')

    client_str = get_ips(NETDATA_CLIENT_KEY)
    server_str = get_ips(NETDATA_SERVER_KEY)

    # substitute default string with IPs of clients and server
    yaml_file = re.sub(netdata_pattern, client_str, yaml_file, 1)
    yaml_file = re.sub(netdata_pattern, server_str, yaml_file, 1)

    # write to config file
    write_file('prometheus.yml', yaml_file)


if __name__ == '__main__':
    main()
