#!/bin/bash
app_login_url_local=$(cat /mnt/secrets-store/app-login-url)
api_login_url_local=$(cat /mnt/secrets-store/api-login-url)
app_common_url_local=$(cat /mnt/secrets-store/app-common-url)
api_common_url_local=$(cat /mnt/secrets-store/api-common-url)
app_admin_url_local=$(cat /mnt/secrets-store/app-admin-url)
api_admin_url_local=$(cat /mnt/secrets-store/api-admin-url)
app_programming_url_local=$(cat /mnt/secrets-store/app-programming-url)
api_programming_url_local=$(cat /mnt/secrets-store/api-programming-url)
app_scheduling_url_local=$(cat /mnt/secrets-store/app-scheduling-url)
api_scheduling_url_local=$(cat /mnt/secrets-store/api-scheduling-url)
app_client_id_local=$(cat /mnt/secrets-store/app-client-id)
app_tenant_id_local=$(cat /mnt/secrets-store/app-tenant-id)
app_salesco_url_local=$(cat /mnt/secrets-store/app-salesco-url)
api_salesco_url_local=$(cat /mnt/secrets-store/api-salesco-url)
app_insrtumentation_key_local=$(cat /mnt/secrets-store/app-insrtumentation-key)
api_insrtumentation_key_local=$(cat /mnt/secrets-store/api-insrtumentation-key)

sed -i "s#\"app-login-url\": \"\"#\"app-login-url\": \"$app_login_url_local\"#" /app/public-flutter/assets/assets/AppConfig.json
sed -i "s#\"api-login-url\": \"\"#\"api-login-url\": \"$api_login_url_local\"#" /app/public-flutter/assets/assets/AppConfig.json
sed -i "s#\"app-common-url\": \"\"#\"app-common-url\": \"$app_common_url_local\"#" /app/public-flutter/assets/assets/AppConfig.json
sed -i "s#\"api-common-url\": \"\"#\"api-common-url\": \"$api_common_url_local\"#" /app/public-flutter/assets/assets/AppConfig.json
sed -i "s#\"app-admin-url\": \"\"#\"app-admin-url\": \"$app_admin_url_local\"#" /app/public-flutter/assets/assets/AppConfig.json
sed -i "s#\"api-admin-url\": \"\"#\"api-admin-url\": \"$api_admin_url_local\"#" /app/public-flutter/assets/assets/AppConfig.json
sed -i "s#\"app-programming-url\": \"\"#\"app-programming-url\": \"$app_programming_url_local\"#" /app/public-flutter/assets/assets/AppConfig.json
sed -i "s#\"api-programming-url\": \"\"#\"api-programming-url\": \"$api_programming_url_local\"#" /app/public-flutter/assets/assets/AppConfig.json
sed -i "s#\"app-scheduling-url\": \"\"#\"app-scheduling-url\": \"$app_scheduling_url_local\"#" /app/public-flutter/assets/assets/AppConfig.json
sed -i "s#\"api-scheduling-url\": \"\"#\"api-scheduling-url\": \"$api_scheduling_url_local\"#" /app/public-flutter/assets/assets/AppConfig.json
sed -i "s#\"app-client-id\": \"\"#\"app-client-id\": \"$app_client_id_local\"#" /app/public-flutter/assets/assets/AppConfig.json
sed -i "s#\"app-tenant-id\": \"\"#\"app-tenant-id\": \"$app_tenant_id_local\"#" /app/public-flutter/assets/assets/AppConfig.json
sed -i "s#\"app-salesco-url\": \"\"#\"app-salesco-url\": \"$app_salesco_url_local\"#" /app/public-flutter/assets/assets/AppConfig.json
sed -i "s#\"api-salesco-url\": \"\"#\"api-salesco-url\": \"$api_salesco_url_local\"#" /app/public-flutter/assets/assets/AppConfig.json
sed -i "s#\"app-insrtumentation-key\": \"\"#\"app-insrtumentation-key\": \"$app_insrtumentation_key_local\"#" /app/public-flutter/assets/assets/AppConfig.json
sed -i "s#\"api-insrtumentation-key\": \"\"#\"api-insrtumentation-key\": \"$api_insrtumentation_key_local\"#" /app/public-flutter/assets/assets/AppConfig.json
