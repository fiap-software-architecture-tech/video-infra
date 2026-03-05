# ===========================
# DATA SOURCES
# ===========================

# Data sources para recursos existentes
data "aws_vpc" "existing" {
  default = true
}

# Subnets específicas para o RDS
data "aws_subnet" "fiapx_subnet_1a" {
  id = "subnet-061380504e1a0f7af"  # us-east-1a
}

data "aws_subnet" "fiapx_subnet_1b" {
  id = "subnet-0c000b7130b9b792c"  # us-east-1b
}

# IAM Role do AWS Academy
data "aws_iam_role" "lab_role" {
  name = "LabRole"
}