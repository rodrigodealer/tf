## Terraform

# Requirements:

1. Create a key pair in your AWS account and assign it to the deployment on the key: `key_name`

2. Have terraform installed (I used v0.12.24)

3. Have golang installed in your environment

# How to run

Inside `deployments/httpbin` run:

```
$ terraform plan
```
and then
```
$ terraform apply
```

It will printout the load balancer and ip addresses which you can access the application.

# How to run tests

Inside `test/src` run:

```
$ go test ./... -v
```