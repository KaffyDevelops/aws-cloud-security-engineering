resource "aws_security_group" "web" {
  name        = "${local.name_prefix}-web-sg"
  description = "Internet-facing HTTPS boundary for a future web tier"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${local.name_prefix}-web-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "web_https_ipv4" {
  security_group_id = aws_security_group.web.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
  description       = "HTTPS ingress only"
}

resource "aws_vpc_security_group_ingress_rule" "web_https_ipv6" {
  security_group_id = aws_security_group.web.id
  cidr_ipv6         = "::/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
  description       = "HTTPS ingress only over IPv6"
}

resource "aws_security_group" "app" {
  name        = "${local.name_prefix}-app-sg"
  description = "Application tier reachable only from the web security group"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${local.name_prefix}-app-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "app_from_web" {
  security_group_id            = aws_security_group.app.id
  referenced_security_group_id = aws_security_group.web.id
  from_port                    = 8443
  ip_protocol                  = "tcp"
  to_port                      = 8443
  description                  = "Application traffic from web tier only"
}

resource "aws_security_group" "database" {
  name        = "${local.name_prefix}-db-sg"
  description = "Database tier reachable only from the application security group"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "${local.name_prefix}-db-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "database_from_app" {
  security_group_id            = aws_security_group.database.id
  referenced_security_group_id = aws_security_group.app.id
  from_port                    = 5432
  ip_protocol                  = "tcp"
  to_port                      = 5432
  description                  = "PostgreSQL traffic from application tier only"
}

resource "aws_vpc_security_group_egress_rule" "web_to_app" {
  security_group_id            = aws_security_group.web.id
  referenced_security_group_id = aws_security_group.app.id
  from_port                    = 8443
  ip_protocol                  = "tcp"
  to_port                      = 8443
  description                  = "Web tier egress to application tier"
}

resource "aws_vpc_security_group_egress_rule" "app_to_database" {
  security_group_id            = aws_security_group.app.id
  referenced_security_group_id = aws_security_group.database.id
  from_port                    = 5432
  ip_protocol                  = "tcp"
  to_port                      = 5432
  description                  = "Application tier egress to database tier"
}
