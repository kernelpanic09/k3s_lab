resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1" # GitHub's trusted root CA
  ]
}

data "aws_iam_policy_document" "github_oidc_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:kernelpanic09/k3s_lab:ref:refs/heads/main"]
    }
  }
}

resource "aws_iam_role" "github_actions_k3s_lab" {
  name = "github-actions-ecr-role"

  assume_role_policy = data.aws_iam_policy_document.github_oidc_assume_role.json
}

data "aws_iam_policy_document" "ecr_push_policy" {
  statement {
    sid    = "ECRPushPull"
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:GetDownloadUrlForLayer",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "github_actions_ecr_policy" {
  name   = "github-actions-ecr"
  role   = aws_iam_role.github_actions_k3s_lab.id
  policy = data.aws_iam_policy_document.ecr_push_policy.json
}


resource "aws_iam_user" "k3s_ecr_pull" {
  name = "k3s-ecr-pull"
}

resource "aws_iam_user_policy" "ecr_pull" {
  name = "ecr-pull-policy"
  user = aws_iam_user.k3s_ecr_pull.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ],
        Resource = "*"
      }
    ]
  })
}