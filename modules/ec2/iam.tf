data "aws_iam_policy_document" "default" {
  statement {
    sid = ""

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    effect = "Allow"
  }
}

resource "aws_iam_instance_profile" "default" {
  count = local.instance_count
  name  = module.label.id
  role  = join("", aws_iam_role.default.*.name)
}

resource "aws_iam_role" "default" {
  count                = local.instance_count
  name                 = module.label.id
  path                 = "/"
  assume_role_policy   = data.aws_iam_policy_document.default.json
  permissions_boundary = var.permissions_boundary_arn
}

