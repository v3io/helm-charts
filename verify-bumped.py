# cli tool that verify if for each Chart.yaml file in stable directory,
# the version is greater than the one in a specific git branch

import subprocess
import argparse
import semver
import os
from ruamel.yaml import YAML


def parse_args():
    parser = argparse.ArgumentParser(
        description="Verify if the version in Chart.yaml is greater than the one in a specific git branch"
    )
    parser.add_argument(
        "-lb", "--latest-branch", help="git branch to compare with", required=True
    )
    parser.add_argument(
        "-ab", "--against-branch", help="git branch to compare with", required=True
    )
    parser.add_argument(
        "-af", "--autofix", help="bump the version", action="store_true"
    )
    return parser.parse_args()


# get all charts from "stable" directory
def get_chart_name_to_paths(dir):
    charts = {}
    for root, _, files in os.walk(dir):
        for file in files:
            if file == "Chart.yaml":
                chart_name = os.path.basename(root)
                chart_path = os.path.join(root, file)
                charts[chart_name] = chart_path
                break
    return charts


# get version from git branch
def git_checkout(branch):
    subprocess.check_output(["git", "checkout", branch])

# get git branch name
def get_current_git_branch_name():
    return subprocess.check_output(["git", "rev-parse", "--abbrev-ref", "HEAD"]).strip()


def get_charts():
    chart_versions = {}
    charts = get_chart_name_to_paths(os.path.abspath("stable"))
    for chart_name, chart_path in charts.items():
        with open(chart_path) as f:
            chart = YAML().load(f)
        if chart.get("deprecated"):
            print("Chart {} is deprecated, continuing".format(chart_name))
            continue
        chart_versions[chart_name] = chart
    return chart_versions


def align_versions(latest_chart, against_chart, autofix):

    # compare charts versions
    aligned = False
    for chart in against_chart:
        latest_version = semver.VersionInfo.parse(latest_chart[chart]["version"])
        against_version = semver.VersionInfo.parse(against_chart[chart]["version"])
        if not latest_version.compare(against_version):
            print(
                "Chart {} is not bumped - {} >= {}".format(
                    chart, latest_version, against_version
                )
            )
            if autofix:
                aligned = True
                print(
                    subprocess.getoutput(
                        " ".join(["/bin/sh", f"{os.getcwd()}/bump.sh {chart}"])
                    )
                )
    return aligned


def run():
    args = parse_args()

    try:
        current_git_branch = get_current_git_branch_name()

        # target branch charts (e.g.: integ_3.5)
        git_checkout(args.against_branch)
        against_charts = get_charts()

        # development charts
        git_checkout(args.latest_branch)
        latest_charts = get_charts()
    finally:
        git_checkout(current_git_branch)

    if align_versions(against_charts, latest_charts, args.autofix):

        # sanity. get versions again, make sure all are bumped
        latest_charts = get_charts()
        if align_versions(against_charts, latest_charts, args.autofix):
            print("Failed to align versions")
            exit(1)

        print("Please commit and push the changes")


def main():
    run()


if __name__ == "__main__":
    main()
