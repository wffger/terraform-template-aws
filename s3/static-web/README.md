# S3配置静态网站
## 说明
1. 在terraform.tfvars中配置密钥
2. `terraform init`
3. `terraform plan`
4. `terraform apply`
5. 在cloudflare中配置代理


## 参考
[cloudflare static website](https://developer.hashicorp.com/terraform/tutorials/applications/cloudflare-static-website)

## 错误说明
> Error: error configuring S3 Backend: error validating provider credentials: error calling sts:GetCallerIdentity: InvalidClientTokenId: The security token included in the request is invalid.
解决：使用不带特殊符号的api访问密钥

> Error: uploading S3 Object (index.html) to Bucket (test.wffger.fun): operation error S3: PutObject, https response error StatusCode: 400
解决：国内网络问题，可以尝试使用VPN或者其他地区的服务器操作。

## 检查
访问[test.wffger.fun](http://test.wffger.fun/)
![look](docs/static-website.png)