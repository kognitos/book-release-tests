import subprocess


def run_cmd(cmd):
    subprocess.run(cmd, shell=True, check=True)

def run_tests():
    # generate coverage report
    run_cmd("poetry run pytest -vv")

def run_format():
    # format all files in-place
    run_cmd("poetry run black tests")
    # organize imports
    run_cmd("poetry run isort tests")

def run_lint():
    # lint source and test files
    run_cmd("poetry run pylint --output-format=colorized src tests")

def run_type_check():
    # type check source
    run_cmd("poetry run pyright")