# LLL-CAdViSE

[![Client Docker Image CI](https://github.com/cd-athena/LLL-CAdViSE/actions/workflows/clientDockerImage.yml/badge.svg)](https://github.com/cd-athena/LLL-CAdViSE/actions/workflows/clientDockerImage.yml)

- [LLL-CAdViSE](#lll-cadvise)
  - [Live Low Latency Cloud-based Adaptive Video Streaming Evaluation (LLL-CAdViSE) framework](#live-low-latency-cloud-based-adaptive-video-streaming-evaluation-lll-cadvise-framework)
  - [CLI Setup](#cli-setup)
    - [Installing JQuery](#installing-jquery)
    - [Installing Netcat](#installing-netcat)
  - [AWS Setup](#aws-setup)
    - [AWS Credentials](#aws-credentials)
    - [Run Script Variable](#run-script-variable)
      - [AWS Key](#aws-key)
      - [Placement Group](#placement-group)
      - [Security Group](#security-group)
      - [IAM Role](#iam-role)
  - [Running on AWS Cloud](#running-on-aws-cloud)
    - [Run Script Flags](#run-script-flags)
  - [Troubleshoot](#troubleshoot)
    - [Placement Group Unknown](#placement-group-unknown)
    - [Value `groupId` is invalid](#value-groupid-is-invalid)
    - [Invalid IAM Instance Profile name](#invalid-iam-instance-profile-name)
    - [VcpuLimitExceeded](#vcpulimitexceeded)
    - [Cluster Placement Not Supported by Instance Type](#cluster-placement-not-supported-by-instance-type)
    - [Stuck in Instance Network Reachability Loop](#stuck-in-instance-network-reachability-loop)
    - [Injecting Scripts - Identity File Not Accessible](#injecting-scripts---identity-file-not-accessible)
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

## CLI Setup

This section contains setup steps that are to be done before executing the run-script on the AWS Cloud.

### Installing JQuery

The JQuery tool has to be installed to be able to use LLL-CAdViSE on an EC2 instance.

This can be done by executing the following command on the EC2 instance:

```bash
sudo yum install jq
```

### Installing Netcat

Netcat has to be installed in order to check if the client interfaces are reachable by the server in the experiment.

Netcat can be installed by executing the following command on the EC2 instance:

```bash
sudo yum install nc
```

## AWS Setup

This section contains steps that are required to be done before the experiments can be run with LLL-CAdViSE.

### AWS Credentials

In order for running the experiments with LLL-CAdViSE, it is required that the AWS credentials are configured on the EC2 instance.
The steps to configure the AWS credentials can be found in [Configuration and Credential File Settings](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html).

### Run Script Variable

Some variables are hard-coded at the beginning of the `run.sh` script and need to be changed according to the AWS configuration.

#### AWS Key

The AWS key corresponds to the name of a generated and registered `ssh` key.
The authorised keys are found in an AWS instance in the file `authorized_keys` at `$HOME/.ssh/`.

#### Placement Group

The variable `placementGroup` has to be set according to the AWS configuration.
For this either a placement group with the name `lll-cadvise-cluster` has to be created inside of AWS, or the name of an existing placement group has to be set as the variable value.

#### Security Group

The variable `awsSecurityGroup` has to be set to an available security group.
In case no security group exists, instructions can be found at [Security groups link](https://docs.aws.amazon.com/vpc/latest/userguide/security-groups.html).
The security group `default` that is predefined by AWS does have the necessary permission and can be used for the instances in the experiment.

#### IAM Role

The value for the variable `awsIAMRole` has to be set.
The value must be an AWS IAM role that has permission to access the EC2 service.
The value to provide in the script is the name of the role that should be used.

How to set up an IAM role can be found at [IAM roles for Amazon EC2](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html#ec2-instance-profile).

## Running on AWS Cloud

The following command executes the `run.sh` script with the given flags.

```bash
./run.sh --players 5xdashjs 2xhlsjs 3xdashjsl2a --shaper network/network0.json --awsKey [YOUR-KEY] --withQoE
```

### Run Script Flags

- `--shaper`

  - The value provided to `--shaper` defines the network behaviour over time. Numerous network shapes and scenarios can be found at `network/`.
  - The value `network/network0.json` loads a simple network shape for an initial spin-up of LLL-CAdViSE.
- `--withQoE`

  - This flag is a `boolean` type and if the flag is added in the CLI execution, it is set to true.
- `--cluster`

  - The flag `--cluster` defines the placement group used for the experiment.
  - For further information regarding placement groups see [Placement Group](#placement-group).
- `--awsProfile`

  - The flag `--awsProfile` defines the profile used for the experiment.
  - The default value is `"default"`.
- `--awsKey`

  - The `--awsKey` variable corresponds to the generated ssh key name found in `$HOME/.ssh/authorized_keys` that has the pattern `ssh-<key-gen-algorithm>` `<aws-key>` `<key-name>`. As a flag, the `<key-name>` part has to be provided.
  - The value for the flag has either to be set in the `run.sh` script or provided when executing it with the `awsKey` flag.
- `--awsIAMRole`

  - The `--awsIAMRole` flag defines the role used for the experiment.
  - For further information see [IAM Role](#iam-role).
- `--awsSecurityGroup`

  - The `--awsSecurityGroup` flag defines the security group used for the experiment (see [Security Group](#security-group)).
- `--players`

  - The `--players` flag defines the streaming media players that will be used for the experiment.
  - Currently supported streaming media players are:

    - `dashjs`
    - `hlsjs`
    - `dashjslolp`
    - `hlsjsl2a`
    - `hlsjslolp`
  - The number of times a player should be used in the experiment is defined by a prefix of $Nx$ before the player, where $N$ denotes the number of occurrences.
  - For example, `4xdashjs` will result in `dashjs` being executed 4 times in the experiment.

## Monitoring

In order to run monitoring, the following things have to be done.

### Netdata

The tool [Netdata](https://www.netdata.cloud/) is used for real-time monitoring of each instance 

### Install Docker

Since the monitoring tools Netdata and Prometheus are executed and run inside a Docker container, it is required to install Docker on the resource the experiment is started from in order to gather monitoring data.

### Create Docker Network

In order to use the monitoring, a docker network has to be defined. As default a docker network called `monitoring` is used.

To create this docker network the following command can be used inside a CLI:

`$ docker network create -d bridge monitoring`

If a pre-existing Docker network should be used, then then value of the variable `MONITORING_NETWORK` inside the script `start_monitoring.sh` has to be changed to the network that shall be used instead.

## Troubleshoot

This section covers common errors encountered when executing LLL-CAdViSE.

### Placement Group Unknown

If the error `An error occurred (InvalidPlacementGroup.Unknown) when calling the RunInstances operation: The placement group 'lll-cadvise-cluster' is unknown.` is encountered, the value for the variable `placementGroup` needs to be changed according to one of the defined placement groups configured for AWS.

Another solution is to create a placement group with the name `lll-cadvise-cluster` inside of AWS.

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
2. Check if the role has permission to execute on EC2 instances.

How to set up an IAM role can be found at [source](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html#ec2-instance-profile).

### VcpuLimitExceeded

A `VcpuLimitExceeded` error is likely to be encountered if the current client/server instances are exceeding the defined limits of your AWS plan.

```bash
An error occurred (VcpuLimitExceeded) when calling the RunInstances operation: You have requested more vCPU capacity than your current vCPU limit of <x> allows for the instance bucket that the specified instance type belongs to. Please visit http://aws.amazon.com/contact-us/ec2-request to request an adjustment to this limit.
```

A possible fix for this is either to request a higher vCPU capacity as is further explained in [Solve: You have requested more vCPU capacity than your current vCPU limit](https://towardsthecloud.com/amazon-ec2-requested-more-vcpu-capacity).

Another possible solution is to use smaller instance sizes as shown in the product detail section of [Amazon EC2 M5 Instances](https://aws.amazon.com/ec2/instance-types/m5/).

### Cluster Placement Not Supported by Instance Type

```bash
An error occurred (InvalidParameterCombination) when calling the RunInstances operation: Cluster placement groups are not supported by the 't2.micro' instance type. Specify a supported instance type or change the placement group strategy, and try again.
```

This error is due to the chosen instances for the script variables `clientInstanceType` or `serverInstanceType` not being supported.
Supported instance types can be found at [Amazon EC2 M5 Instances](https://aws.amazon.com/ec2/instance-types/m5/).

Other solutions to this problem can be found at [Troubleshoot Link](https://docs.aws.amazon.com/autoscaling/ec2/userguide/ts-as-instancelaunchfailure.html).

### Stuck in Instance Network Reachability Loop

If the script gets stuck when waiting for an EC2 instance network interface to be reachable, the cause is likely a misconfiguration in the AWS security group of inbound rules.
A possible solution can be found at [Fix Not Being Able to Ping EC2](https://arcadian.cloud/aws/2022/07/01/4-reasons-you-cannot-ping-your-aws-ec2-instance-and-how-to-fix-them/).

### Injecting Scripts - Identity File Not Accessible

If the error `Warning: Identity file <file-name>.pem not accessible: No such file or directory.` is encountered, this is due to the `.pem` private key being required to be included in the root directory of the LLL-CAdViSE repository.

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
