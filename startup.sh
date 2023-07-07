#!/bin/bash
app-login-url_local=$(cat /mnt/secrets-store/app-login-url)
api-login-url_local=$(cat /mnt/secrets-store/api-login-url)
app-common-url_local=$(cat /mnt/secrets-store/app-common-url)
api-common-url_local=$(cat /mnt/secrets-store/api-common-url)
app-admin-url_local=$(cat /mnt/secrets-store/app-admin-url)
api-admin-url_local=$(cat /mnt/secrets-store/api-admin-url)
app-programming-url_local=$(cat /mnt/secrets-store/app-programming-url)
api-programming-url_local=$(cat /mnt/secrets-store/api-programming-url)
app-scheduling-url_local=$(cat /mnt/secrets-store/app-scheduling-url)
api-scheduling-url_local=$(cat /mnt/secrets-store/api-scheduling-url)
app-client-id_local=$(cat /mnt/secrets-store/app-client-id)
app-tenant-id_local=$(cat /mnt/secrets-store/app-tenant-id)
app-insrtumentation-key_local=$(cat /mnt/secrets-store/app-insrtumentation-key)
sed -i "s/\"app-login-url\": \"\",/\"app-login-url\": \"$app-login-url_local\",/g" /app/public-flutter/assets/assets/AppConfig.json
sed -i "s/\"api-login-url\": \"\",/\"api-login-url\": \"$api-login-url_local\",/g" /app/public-flutter/assets/assets/AppConfig.json
sed -i "s/\"app-common-url\": \"\",/\"app-common-url\": \"$app-common-url_local\",/g" /app/public-flutter/assets/assets/AppConfig.json
sed -i "s/\"api-common-url\": \"\",/\"api-common-url\": \"$api-common-url_local\",/g" /app/public-flutter/assets/assets/AppConfig.json
sed -i "s/\"app-admin-url\": \"\",/\"app-admin-url\": \"$app-admin-url_local\",/g" /app/public-flutter/assets/assets/AppConfig.json
sed -i "s/\"api-admin-url\": \"\",/\"api-admin-url\": \"$api-admin-url_local\",/g" /app/public-flutter/assets/assets/AppConfig.json
sed -i "s/\"app-programming-url\": \"\",/\"app-programming-url\": \"$app-programming-url_local\",/g" /app/public-flutter/assets/assets/AppConfig.json
sed -i "s/\"api-programming-url\": \"\",/\"api-programming-url\": \"$api-programming-url_local\",/g" /app/public-flutter/assets/assets/AppConfig.json
sed -i "s/\"app-scheduling-url\": \"\",/\"app-scheduling-url\": \"$app-scheduling-url_local\",/g" /app/public-flutter/assets/assets/AppConfig.json
sed -i "s/\"api-scheduling-url\": \"\",/\"api-scheduling-url\": \"$api-scheduling-url_local\",/g" /app/public-flutter/assets/assets/AppConfig.json
sed -i "s/\"app-client-id\": \"\",/\"app-client-id\": \"$app-client-id_local\",/g" /app/public-flutter/assets/assets/AppConfig.json
sed -i "s/\"app-tenant-id\": \"\",/\"app-tenant-id\": \"$app-tenant-id_local\",/g" /app/public-flutter/assets/assets/AppConfig.json
sed -i "s/\"app-insrtumentation-key\": \"\",/\"app-insrtumentation-key\": \"$app-insrtumentation-key_local\",/g" /app/public-flutter/assets/assets/AppConfig.json

