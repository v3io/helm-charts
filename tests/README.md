# Helm Charts Test Framework

Generic test framework for Helm charts in this repository.

## Prerequisites

- Helm 3.x
- Chart dependencies installed (`helm dependency update` in chart directory)


## Structure

```
tests/
├── test_runner.sh           # Top-level runner (discovers all chart tests)
├── lib/
│   └── common.sh            # Shared test utilities
└── <chart-name>/            # Chart-specific tests
    └── test_<name>.sh       # Individual test cases
```

## Usage

```bash
# Run all chart tests
make test-charts

# Run a specific test
./tests/<chart-name>/test_<name>.sh
```

## Adding Tests for a New Chart

1. Create chart test directory: `tests/<chart-name>/`
2. Create test cases: `cp tests/mlrun/test_mysql_tag.sh tests/<chart-name>/test_<name>.sh`
