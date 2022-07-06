resource "aws_iam_role" "rdsstopstart-role" {
  name = "rdsstopstart-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
    }
  )
}

resource "aws_iam_role_policy" "rdsstopstart-policy" {
  name = "rdsstopstart-policy"
  role = aws_iam_role.rdsstopstart-role.id


  # This policy is exclusively available by my-role.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "rds:DescribeDBClusterParameters",
          "rds:StartDBCluster",
          "rds:StopDBCluster",
          "rds:DescribeDBEngineVersions",
          "rds:DescribeGlobalClusters",
          "rds:DescribePendingMaintenanceActions",
          "rds:DescribeDBLogFiles",
          "rds:StopDBInstance",
          "rds:StartDBInstance",
          "rds:DescribeReservedDBInstancesOfferings",
          "rds:DescribeReservedDBInstances",
          "rds:ListTagsForResource",
          "rds:DescribeValidDBInstanceModifications",
          "rds:DescribeDBInstances",
          "rds:DescribeSourceRegions",
          "rds:DescribeDBClusterEndpoints",
          "rds:DescribeDBClusters",
          "rds:DescribeDBClusterParameterGroups",
          "rds:DescribeOptionGroups"
        ],
        "Resource" : "*"
      }
    ],
    }
  )
}