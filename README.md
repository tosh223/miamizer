# miamizer

Miamizer retrieves AWS IAM resources from AWS CloudFormation Stack and outputs as DSL files for [codenize-tools/miam](https://github.com/codenize-tools/miam).

## Usage

```sh
$ bundle exec ruby ./miamizer.rb your-aws-stack-name
```

## Output

```sh
$ ls ./*.iam
./policies.iam  ./roles.iam
``
