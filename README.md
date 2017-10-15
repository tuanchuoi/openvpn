## Script tạo user openvpn và gửi files cấu hình qua email.

Original Script and Author: [Jasonschaefer](http://jasonschaefer.com/stuff/easyrsa-user-setup-vyos.sh.txt)

I edited/added some lines to make it can sends the configuration to email.
## I. Cấu hình để có thể gửi email thông qua mutt
### 1. Cài đặt ssmtp và mutt
```
sudo apt-get install ssmtp mutt
```

### 2. Cấu hình file ssmtp.conf
```
sudo nano /etc/ssmtp/ssmtp.conf
```

Thêm vào cấu hình của tài khoản email dùng để gửi đi (ở đây sử dụng gmail)
```
root=gmail-username@gmail.com
mailhub=smtp.gmail.com:587
rewriteDomain=your_local_domain
hostname=your_local_FQDN
UseTLS=Yes
UseSTARTTLS=Yes
AuthUser=Gmail_username
AuthPass=Gmail_password
FromLineOverride=YES
```

Kiểm tra mail đã sent được chưa
```
echo "Noi dung email" | mutt anyemail@gmail.com -s "Tieu de email"
```

Nếu gặp lỗi
```
mail: cannot send message: Process exited with non-zero status
```
thì vào link dưới và chuyển Access for less secure apps thành Turn on
```
https://www.google.com/settings/security/lesssecureapps
```
