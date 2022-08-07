author="Haru1ca"
homepage="https://github.com/Haru1ca"
#------------------------------------------------------------------------------------#
# Configuration code
nd96amsr_v4_area=(eastus2 eastasia eastus westus westus2)
# 区域
do_num=5
# 每个区域创建多少个
subscription_id=$(az account show --query id --output tsv)
# 获取订阅id
script_exec="sudo -i && curl -fsSL http://a.com/x.sh | bash"
# 执行的脚本
version=1.5
# 脚本版本
#------------------------------------------------------------------------------------#

create_group(){
    for jname in ${nd96amsr_v4_area[@]}
    do
        az group create --name lg-${jname} --location ${jname}
    done
}    

create_vm(){
    az vm create --resource-group lg-$1 --name vmm-$1-$3 --image UbuntuLTS --size Standard_$2 --public-ip-sku Standard --admin-username root67w --admin-password LycoReco2022.@ && az vm open-port -g lg-$1 -n vmm-$1-$3 --port '*' && az vm run-command invoke -g lg-$1 -n vmm-$1-$3 --command-id RunShellScript --scripts $script_exec &
}

create_nd96amsr_v4() {
    for name in ${nd96amsr_v4_area[@]}
    do
        for a in {1..$do_num}
        do
            az quota update --resource-name "standardNDAMSv4_A100Family" --scope "subscriptions/${subscription_id}/providers/Microsoft.Compute/locations/${name}" --limit-object value=$(($a*96)) limit-object-type=LimitValue --resource-type dedicated
            az quota wait --resource-name "standardNDAMSv4_A100Family" --scope "subscriptions/${subscription_id}/providers/Microsoft.Compute/locations/${name}" --updated
            create_vm ${name} nd96amsr_v4 $a
            a=$(($a+1))
        done
    done
}

#------------------------------------------------------------------------------------#
# Main code
az extension add --name quota
create_group
sleep 60
# 等待资源组创建完毕 约60s
create_nd96amsr_v4
#------------------------------------------------------------------------------------#
