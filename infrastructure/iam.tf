# --- Existing kestra IAM User and Access Key Definitions ---
resource "aws_iam_user" "kestra_instance" {
  name = "kestra"

  tags = {
    Environment = "Production"
    Owner       = "Data Platform Team"
    Service     = "Kestra"
  }
}

resource "aws_iam_access_key" "kestra_keys" {
  user = aws_iam_user.kestra_instance.name
}

resource "aws_ssm_parameter" "kestra_access_key" {
  name  = "/Production/kestra/aws_access_key"
  type  = "String"
  value = aws_iam_access_key.kestra_keys.id
}

resource "aws_ssm_parameter" "kestra_secret_access_key" {
  name  = "/Production/kestra/aws_secret_access_key"
  type  = "String"
  value = aws_iam_access_key.kestra_keys.secret
}


resource "aws_iam_policy" "kestra_user_policy" {
  name        = "kestra-user-policy"
  description = "Dedicated policy for kestra instance "

    policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "iam:PassRole",
          "iam:PassedToService",
          # "elasticmapreduce:RunJobFlow",
          # "elasticmapreduce:DescribeCluster",
          "elasticmapreduce:RunJobFlow",
          "elasticmapreduce:TerminateJobFlows",
          "elasticmapreduce:AddJobFlowSteps",
          "elasticmapreduce:DescribeStep",
          "elasticmapreduce:DescribeCluster",
          "elasticmapreduce:ListSteps",
          "elasticmapreduce:ListClusters",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "ssm:GetParameter",
          "ssm:StartSession",
          "s3:GetObject", #starts here
          "s3:PutObject",
          "s3:ListBucket",
          "s3:DeleteObject" 
        ]
        Resource = [
          "*"
        ]
      },
    ]
  })
}

resource "aws_iam_user_policy_attachment" "test-attach" {
  user       = aws_iam_user.kestra_instance.name
  policy_arn = aws_iam_policy.kestra_user_policy.arn
}

# Now, to policies

data "aws_iam_policy_document" "emr_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["elasticmapreduce.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}


resource "aws_iam_role" "emr_service_role" {
  name               = "emr-service-role"
  assume_role_policy = data.aws_iam_policy_document.emr_assume_role.json
}


data "aws_iam_policy_document" "emr_service_policy" {
  statement {
    effect = "Allow"

    actions = [
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CancelSpotInstanceRequests",
      "ec2:CreateNetworkInterface",
      "ec2:CreateSecurityGroup",
      "ec2:CreateTags",
      "ec2:DeleteNetworkInterface",
      "ec2:DeleteSecurityGroup",
      "ec2:DeleteTags",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeInstances",
      "ec2:DescribeKeyPairs",
      "ec2:DescribeNetworkAcls",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribePrefixLists",
      "ec2:DescribeRouteTables",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSpotInstanceRequests",
      "ec2:DescribeSpotPriceHistory",
      "ec2:DescribeSubnets",
      "ec2:DescribeVpcAttribute",
      "ec2:DescribeVpcEndpoints",
      "ec2:DescribeVpcEndpointServices",
      "ec2:DescribeVpcs",
      "ec2:DetachNetworkInterface",
      "ec2:ModifyImageAttribute",
      "ec2:ModifyInstanceAttribute",
      "ec2:RequestSpotInstances",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:RunInstances",
      "ec2:TerminateInstances",
      "ec2:DeleteVolume",
      "ec2:DescribeVolumeStatus",
      "ec2:DescribeVolumes",
      "ec2:DetachVolume",
      "iam:GetRole",
      "iam:GetRolePolicy",
      "iam:ListInstanceProfiles",
      "iam:ListRolePolicies",
      "iam:PassRole",
      "s3:CreateBucket",
      "s3:Get*",
      "s3:List*",
      "sdb:BatchPutAttributes",
      "sdb:Select",
      "sqs:CreateQueue",
      "sqs:Delete*",
      "sqs:GetQueue*",
      "sqs:PurgeQueue",
      "sqs:ReceiveMessage",
    ]

    resources = ["*"]
  }
}


resource "aws_iam_role_policy" "iam_emr_service_policy" {
  name   = "iam_emr_service_policy"
  role   = aws_iam_role.emr_service_role.id
  policy = data.aws_iam_policy_document.emr_service_policy.json
}


# IAM Role for EC2 Instance Profile
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}


resource "aws_iam_role" "emr_profile_role" {
  name               = "emr-instance-profile-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}


resource "aws_iam_instance_profile" "emr_profile" {
  name = "emr_instance_profile"
  role = aws_iam_role.emr_profile_role.name
}


data "aws_iam_policy_document" "emr_instance_profile_policy" {
  statement {
    effect = "Allow"

    actions = [
      "cloudwatch:*",
      "dynamodb:*",
      "ec2:Describe*",
      "elasticmapreduce:Describe*",
      "elasticmapreduce:ListBootstrapActions",
      "elasticmapreduce:ListClusters",
      "elasticmapreduce:ListInstanceGroups",
      "elasticmapreduce:ListInstances",
      "elasticmapreduce:ListSteps",
      "elasticmapreduce:RunJobFlow", # ADDED THIS
      "kinesis:CreateStream",
      "kinesis:DeleteStream",
      "kinesis:DescribeStream",
      "kinesis:GetRecords",
      "kinesis:GetShardIterator",
      "kinesis:MergeShards",
      "kinesis:PutRecord",
      "kinesis:SplitShard",
      "rds:Describe*",
      "s3:*",
      "sdb:*",
      "sns:*",
      "sqs:*",
    ]

    resources = ["*"]
  }
}


resource "aws_iam_role_policy" "emr_instance_profile_policy" {
  name   = "emr_instance_profile_policy"
  role   = aws_iam_role.emr_profile_role.id
  policy = data.aws_iam_policy_document.emr_instance_profile_policy.json
}











# # --- NEW/MODIFIED: Policies for the 'kestra' IAM user to manage EMR clusters ---

# # Policy Document for the 'kestra' user to allow EMR cluster management and PassRole
# data "aws_iam_policy_document" "kestra_emr_management_policy_document" {
#   statement {
#     effect = "Allow"
#     actions = [
#       "s3:*",
#       "elasticmapreduce:RunJobFlow",
#       "elasticmapreduce:DescribeCluster",
#       "elasticmapreduce:ListClusters",
#       "elasticmapreduce:TerminateJobFlows",
#       "elasticmapreduce:AddInstanceGroups",
#       "elasticmapreduce:ModifyInstanceGroups",
#       "elasticmapreduce:RemoveInstanceGroups",
#       "elasticmapreduce:SetTerminationProtection",
#       "elasticmapreduce:AddSteps",
#       "elasticmapreduce:CancelSteps",
#       "elasticmapreduce:ListSteps",
#       "elasticmapreduce:DescribeStep",
#       "elasticmapreduce:SetVisibleToAllUsers",
#       "elasticmapreduce:GetBlockPublicAccessConfiguration",
#       "elasticmapreduce:GetClusterSessionCredentials",
#       "elasticmapreduce:GetManagedScalingPolicy",
#       "elasticmapreduce:GetStudioSessionMapping",
#       "elasticmapreduce:ListBootstrapActions",
#       "elasticmapreduce:ListInstanceFleets",
#       "elasticmapreduce:ListInstanceGroups",
#       "elasticmapreduce:ListInstances",
#       "elasticmapreduce:ListSecurityConfigurations",
#       "elasticmapreduce:ListStudioSessionMappings",
#       "elasticmapreduce:ListStudios",
#       "elasticmapreduce:PutAutoScalingPolicy",
#       "elasticmapreduce:RemoveAutoScalingPolicy",
#       "elasticmapreduce:UpdateStudioSessionMapping",
#       # Add other EMR management actions as needed for Kestra's operations
#     ]
#     # Restrict to a specific region and account, matching your error message's resource ARN
#     # If Kestra needs to manage EMR in other regions, you might need to broaden this or add more ARNs.
#     resources = ["*"] # "arn:aws:elasticmapreduce:eu-central-1:340752803932:cluster/*"
#   }

#   # This statement grants the 'kestra' user permission to pass the EMR Service Role
#   # and the EMR Instance Profile Role when launching a cluster. This is CRUCIAL.
#   statement {
#     effect = "Allow"
#     actions = [
#       "iam:PassRole"
#     ]
#     resources = [
#       aws_iam_role.emr_service_role.arn,
#       aws_iam_role.emr_profile_role.arn,
#     ]
#     # Optionally, you can add a condition to restrict PassRole to only EMR actions if desired
#     # For example:
#     # condition {
#     #   test     = "StringLike"
#     #   variable = "iam:PassedToService"
#     #   values   = ["elasticmapreduce.amazonaws.com"]
#     # }
#   }
# }

# # Attach the defined policy to the 'kestra' IAM user
# resource "aws_iam_user_policy" "kestra_emr_access_policy" {
#   name   = "kestra-emr-management-policy" # More descriptive name
#   user   = aws_iam_user.kestra_instance.name
#   policy = data.aws_iam_policy_document.kestra_emr_management_policy_document.json
# }

# # --- Existing EMR Service Role Definitions (No changes needed here based on previous discussion) ---
# data "aws_iam_policy_document" "emr_assume_role" {
#   statement {
#     effect = "Allow"
#     principals {
#       type        = "Service"
#       identifiers = ["elasticmapreduce.amazonaws.com"]
#     }
#     actions = ["sts:AssumeRole"]
#   }
# }

# resource "aws_iam_role" "emr_service_role" {
#   name               = "emr-service-role"
#   assume_role_policy = data.aws_iam_policy_document.emr_assume_role.json
# }

# data "aws_iam_policy_document" "emr_service_policy" {
#   statement {
#     effect = "Allow"
#     actions = [
#       "ec2:AuthorizeSecurityGroupEgress",
#       "ec2:AuthorizeSecurityGroupIngress",
#       "ec2:CancelSpotInstanceRequests",
#       "ec2:CreateNetworkInterface",
#       "ec2:CreateSecurityGroup",
#       "ec2:CreateTags",
#       "ec2:DeleteNetworkInterface",
#       "ec2:DeleteSecurityGroup",
#       "ec2:DeleteTags",
#       "ec2:DescribeAvailabilityZones",
#       "ec2:DescribeAccountAttributes",
#       "ec2:DescribeDhcpOptions",
#       "ec2:DescribeInstanceStatus",
#       "ec2:DescribeInstances",
#       "ec2:DescribeKeyPairs",
#       "ec2:DescribeNetworkAcls",
#       "ec2:DescribeNetworkInterfaces",
#       "ec2:DescribePrefixLists",
#       "ec2:DescribeRouteTables",
#       "ec2:DescribeSecurityGroups",
#       "ec2:DescribeSpotInstanceRequests",
#       "ec2:DescribeSpotPriceHistory",
#       "ec2:DescribeSubnets",
#       "ec2:DescribeVpcAttribute",
#       "ec2:DescribeVpcEndpoints",
#       "ec2:DescribeVpcEndpointServices",
#       "ec2:DescribeVpcs",
#       "ec2:DetachNetworkInterface",
#       "ec2:ModifyImageAttribute",
#       "ec2:ModifyInstanceAttribute",
#       "ec2:RequestSpotInstances",
#       "ec2:RevokeSecurityGroupEgress",
#       "ec2:RunInstances",
#       "ec2:TerminateInstances",
#       "ec2:DeleteVolume",
#       "ec2:DescribeVolumeStatus",
#       "ec2:DescribeVolumes",
#       "ec2:DetachVolume",
#       "iam:GetRole",
#       "iam:GetRolePolicy",
#       "iam:ListInstanceProfiles",
#       "iam:ListRolePolicies",
#       "iam:PassRole", # While this is here, remember the *user* needs PassRole for this role.
#       "s3:*",
#       "sdb:BatchPutAttributes",
#       "sdb:Select",
#       "sqs:CreateQueue",
#       "sqs:Delete*",
#       "sqs:GetQueue*",
#       "sqs:PurgeQueue",
#       "sqs:ReceiveMessage",
#     ]
#     resources = ["*"]
#   }
# }

# resource "aws_iam_role_policy" "iam_emr_service_policy" {
#   name   = "iam_emr_service_policy"
#   role   = aws_iam_role.emr_service_role.id
#   policy = data.aws_iam_policy_document.emr_service_policy.json
# }

# # --- Existing EC2 Instance Profile Role Definitions (No changes needed here based on previous discussion) ---
# # IAM Trusted Policy  for EC2 Instance Profile
# data "aws_iam_policy_document" "ec2_assume_role" {
#   statement {
#     effect = "Allow"
#     principals {
#       type        = "Service"
#       identifiers = ["ec2.amazonaws.com"]
#     }
#     actions = ["sts:AssumeRole"]
#   }
# }

# resource "aws_iam_role" "emr_profile_role" {
#   name               = "emr-instance-profile-role"
#   assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
# }

# resource "aws_iam_instance_profile" "emr_profile" {
#   name = "kestra_emr_instance_profile"
#   role = aws_iam_role.emr_profile_role.name
# }

# # EC2 (under EMR) in-line policy
# data "aws_iam_policy_document" "emr_instance_profile_policy" {
#   statement {
#     effect = "Allow"
#     actions = [
#       "cloudwatch:*",
#       "dynamodb:*",
#       "ec2:Describe*",
#       "elasticmapreduce:Describe*",
#       "elasticmapreduce:ListBootstrapActions",
#       "elasticmapreduce:ListClusters",
#       "elasticmapreduce:ListInstanceGroups",
#       "elasticmapreduce:ListInstances",
#       "elasticmapreduce:ListSteps",
#       # "elasticmapreduce:RunJobFlow", # This permission is usually for the *initiating user/role*, not the EMR instances.
#                                       # While it doesn't hurt here, if instances launch nested EMR, it's specific.
#                                       # For typical EMR operations, the cluster instances don't initiate new job flows.
#                                       # I'll keep it as you had it, but note its primary placement is on the 'kestra' user.
#       "kinesis:CreateStream",
#       "kinesis:DeleteStream",
#       "kinesis:DescribeStream",
#       "kinesis:GetRecords",
#       "kinesis:GetShardIterator",
#       "kinesis:MergeShards",
#       "kinesis:PutRecord",
#       "kinesis:SplitShard",
#       "rds:Describe*",
#       "s3:*",
#       "sdb:*",
#       "sns:*",
#       "sqs:*",
#     ]
#     resources = ["*"]
#   }
# }

# resource "aws_iam_role_policy" "emr_instance_profile_policy" {
#   name   = "emr_instance_profile_policy"
#   role   = aws_iam_role.emr_profile_role.id
#   policy = data.aws_iam_policy_document.emr_instance_profile_policy.json
# }

 
    