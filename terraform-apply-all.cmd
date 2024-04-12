set IAC_TF_LIVE_CODE=%CD%\code
set IAC_TF_LIVE_CONFIG=%CD%\config\euw\dev

cd %IAC_TF_LIVE_CODE%\01_stage-shared
del tf.plan
terraform init -backend-config=%IAC_TF_LIVE_CONFIG%\terraform.tfbackend
terraform plan -out tf.plan -var-file=%IAC_TF_LIVE_CONFIG%\terraform.tfvars -compact-warnings -input=false
terraform apply -compact-warnings tf.plan

cd %IAC_TF_LIVE_CODE%\02_platform-foundation
del tf.plan
terraform init -backend-config=%IAC_TF_LIVE_CONFIG%\terraform.tfbackend
terraform plan -out tf.plan -var-file=%IAC_TF_LIVE_CONFIG%\terraform.tfvars -compact-warnings -input=false
terraform apply -compact-warnings tf.plan

cd %IAC_TF_LIVE_CODE%\03_platform-bootstrap
del tf.plan
terraform init -backend-config=%IAC_TF_LIVE_CONFIG%\terraform.tfbackend
terraform plan -out tf.plan -var-file=%IAC_TF_LIVE_CONFIG%\terraform.tfvars -compact-warnings -input=false
terraform apply -compact-warnings tf.plan
