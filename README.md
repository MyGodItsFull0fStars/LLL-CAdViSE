# LLL-CAdViSE

[![Client Docker Image CI](https://github.com/cd-athena/LLL-CAdViSE/actions/workflows/clientDockerImage.yml/badge.svg)](https://github.com/cd-athena/LLL-CAdViSE/actions/workflows/clientDockerImage.yml)

- [LLL-CAdViSE](#lll-cadvise)
  - [Live Low Latency Cloud-based Adaptive Video Streaming Evaluation (LLL-CAdViSE) framework](#live-low-latency-cloud-based-adaptive-video-streaming-evaluation-lll-cadvise-framework)
  - [Setup](#setup)
    - [AWS Credentials](#aws-credentials)
    - [Run Script Variable](#run-script-variable)
      - [AWS Key](#aws-key)
      - [Placement Group](#placement-group)
      - [Security Group](#security-group)
      - [IAM Role](#iam-role)
  - [Running on AWS Cloud](#running-on-aws-cloud)
    - [Script Flags](#script-flags)
      - [`--players`](#--players)
      - [`--shaper`](#--shaper)
      - [`--awsKey`](#--awskey)
      - [`--withQoE`](#--withqoe)
  - [Troubleshoot](#troubleshoot)
    - [Placement Group Unknown](#placement-group-unknown)
    - [Value `groupId` is invalid](#value-groupid-is-invalid)
    - [Invalid IAM Instance Profile name](#invalid-iam-instance-profile-name)
  - [Acknowledgement](#acknowledgement)

## Live Low Latency Cloud-based Adaptive Video Streaming Evaluation (LLL-CAdViSE) framework

This testbed is based on [CAdViSE](https://github.com/cd-athena/CAdViSE).

- Evaluates both MPEG-DASH and HLS
- Video and audio content generator (no dataset is required)
- Configurable live media encoder (with different codecs)
- Configurable bitrate ladder for each experiment
- Configurable live media packager
- Emulates CMAF chunks delivery with CTE
- Evaluates multiple instances of the same or different players (e.g. 120xdashjs)
- Realistic network profiles (LTE or 3G traces)
- Low Latency parameters in encoder/packager (LHLS is experimental)
- Evaluates Low Latency ABR algorithms
- Lightweight mode (up and running in ~55 seconds)
- QoE calculation using ITU-T P.1203 (mode 1)
- Evaluates various significant metrics (stallsDuration, startUpDelay, seekedDuration, qualitySwitches, Bitrate, Latency, PlaybackRate)

## Setup

This section contains setup steps that are to be done before executing the run-script on the AWS Cloud.

### AWS Credentials

As a first step, it is required that the AWS credentials are configured on the EC2 instance.
The steps to configure the AWS credentials can be found in [Configuration and Credential File Settings](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html).

### Run Script Variable

Some variables are hard-coded at the beginning of the `run.sh` script and need to be changed according to the AWS configuration.

#### AWS Key

The AWS key corresponds to the name of a generated and registered `ssh` key.
The authorised keys are found in an AWS instance in the file `authorized_keys` at `$HOME/.ssh/`.

#### Placement Group

The variable `placementGroup` has to be set according to the AWS configuration.
For this either a placement group with the name `lll-cadvice-cluster` has to be created inside of AWS, or the name of an existing placement group has to be set as the variable value.

#### Security Group

The variable `awsSecurityGroup` has to be set to an available security group.
In case no security group exists, instructions can be found at [Security groups link](https://docs.aws.amazon.com/vpc/latest/userguide/security-groups.html).

#### IAM Role

The value for the variable `awsIAMRole` has to be set.
The value must be an AWS IAM role that has permissions to access the EC2 service.
The value to provide in the script is the name of the role that should be used.

How to set up a IAM role can be found at [IAM roles for Amazon EC2](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html#ec2-instance-profile).

## Running on AWS Cloud

```bash
./run.sh --players 5xdashjs 2xhlsjs 3xdashjsl2a --shaper network/network0.json --awsKey [YOUR-KEY] --withQoE
```

### Script Flags

#### `--players`

#### `--shaper`

#### `--awsKey`

The `--awsKey` variable corresponds to the generated ssh key name found in `$HOME/.ssh/authorized_keys` that has the pattern `ssh-<key-gen-algorithm>` `<aws-key>` `<key-name>`. As a flag, the `<key-name>` part has to be provided.

#### `--withQoE`

## Troubleshoot

### Placement Group Unknown

If the error `An error occurred (InvalidPlacementGroup.Unknown) when calling the RunInstances operation: The placement group 'lll-cadvise-cluster' is unknown.` is encountered, the value for the variable `placementGroup` needs to be changed according to one of the defined placement groups configured for AWS.

Another solution is to create a placement group with the name `lll-cadvice-cluster` inside of AWS.

### Value `groupId` is invalid

```bash
An error occurred (InvalidParameterValue) when calling the RunInstances operation: Value () for parameter groupId is invalid. The value cannot be empty
```

This error corresponds to AWS not being able to find the security group stored as the value in `awsSecurityGroup`.

A possible solution can be found at [StackOverFlow](https://stackoverflow.com/questions/46604759/an-error-occurred-invalidparametervalue-when-calling-the-runinstances-operatio).

### Invalid IAM Instance Profile name

This error most likely refers to the `awsIAMRole` variable not being set properly.

```bash
An error occurred (InvalidParameterValue) when calling the RunInstances operation: Value (<role-name>) for parameter iamInstanceProfile.name is invalid. Invalid IAM Instance Profile name
```

1. Ensure that the role that is set as the value for `awsIAMRole` exists,
2. Check if the role has permissions to execute on EC2 instances.

How to set up an IAM role can be found at [source](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html#ec2-instance-profile).

## Acknowledgement

1. Please, include the link to this repository
2. And cite the following publication:

_B. Taraghi, H. Hellwagner and C. Timmerer, "LLL-CAdViSE: Live Low-Latency Cloud-Based Adaptive Video Streaming Evaluation Framework," in IEEE Access, vol. 11, pp. 25723-25734, 2023, doi: 10.1109/ACCESS.2023.3257099._

```bibtex
@ARTICLE{10068530,
  author={Taraghi, Babak and Hellwagner, Hermann and Timmerer, Christian},
  journal={IEEE Access}, 
  title={LLL-CAdViSE: Live Low-Latency Cloud-Based Adaptive Video Streaming Evaluation Framework}, 
  year={2023},
  volume={11},
  number={},
  pages={25723-25734},
  url={https://doi.org/10.1109/ACCESS.2023.3257099},
  doi={10.1109/ACCESS.2023.3257099}
}
```
