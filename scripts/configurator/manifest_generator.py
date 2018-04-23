import argparse
import io
import _jsonnet
import yaml


def main():
    parser = argparse.ArgumentParser(description="Convert benchmark configs.")
    parser.add_argument("--config-file", help="config file")
    parser.add_argument("--output-file", help="output file")
    args = parser.parse_args()

    with io.open(args.config_file, "r") as stream:
        params = yaml.load(stream, Loader=yaml.BaseLoader)
    job_type = params["jobType"]
    jsonnet_file = job_type + ".jsonnet"

    json_string = _jsonnet.evaluate_file(
            jsonnet_file, ext_vars=params["jobParams"])
    
    with io.open(args.output_file, "w") as f:
        f.write(json_string)


if __name__ == "__main__":
    main()
