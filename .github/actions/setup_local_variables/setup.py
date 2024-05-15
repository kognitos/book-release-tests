import os
import sys
import yaml
import toml
import json


def interpolate_values(data):
    def interpolate(value, context):
        if isinstance(value, str):
            return value.format(**context)
        elif isinstance(value, dict):
            return {k: interpolate(v, context) for k, v in value.items()}
        elif isinstance(value, list):
            return [interpolate(v, context) for v in value]
        else:
            return value
    context = {}
    for section in data.values():
        if isinstance(section, dict):
            context.update(section)
    return interpolate(data, context)


def read_file(path):
    if path.endswith(".toml"):
        interpreter = toml.load
    elif path.endswith(".json"):
        interpreter = json.load
    else:
        interpreter = yaml.safe_load

    try:
        with open(path, 'r') as file:
            return interpreter(file)
    except FileNotFoundError:
        print(f"File not found: {path}")
    except yaml.YAMLError as e:
        print(f"Error decoding YAML file: {e}")


def output(data):
    flat = {}
    for _, val in data.items():
        if not isinstance(val, dict):
            raise ValueError("Can't have data outside a section")
        flat.update(val)

    output_file = os.getenv('GITHUB_OUTPUT')
    print(f"output file: {output_file}")
    with open(output_file, "a") as out:
        for k, v in flat:
            if not isinstance(k, str):
                raise ValueError("Keys must be strings")
            line = f"{k}={v}"
            #out.write(f"{line}\n")
            print(line)


print(f"argv: {sys.argv}")
output(interpolate_values(read_file('config.yaml')))
