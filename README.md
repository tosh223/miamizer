# miamizer

Miamizer retrieves AWS IAM resources from AWS CloudFormation Stack and outputs as DSL files for [codenize-tools/miam](https://github.com/codenize-tools/miam).

## Usage

```sh
$ bundle exec ruby ./miamizer.rb your-aws-stack-name
```

## Options

```sh
$ bundle exec ruby ./miamizer.rb --help
Usage: miamizer [options]
    -s, --stack_name=[stack_name]
    -p, --profile=[profile]
```

## Output files

```sh
$ ls ./*.iam
./IAMfile  ./policies.iam  ./roles.iam
```
