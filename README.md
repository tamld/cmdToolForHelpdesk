# I. Giới thiệu

- Mục tiêu hỗ trợ cho công việc Helpdesk, kĩ thuật viên hàng ngày
- Cải thiện hiệu quả và năng suất lao động bằng cách sử dụng các scripts hỗ trợ tự động cài đặt các ứng dụng, gói ứng dụng
- Fix một số lỗi liên quan đến Office, Windows
- Các phần mềm cài đặt sẽ sử dụng Package Management là [Chocolately](https://github.com/chocolatey/choco) và [Winget](https://github.com/microsoft/winget-cli)
- Các file cần thiết cho scripts chạy sẽ đặt ở %temp%, khi thoát app sẽ được tự động delete
- Ứng dụng hỗ trợ Windows 10 1809 trở đi

:warning::warning::warning:
**Lưu ý**

- Một số chức năng vẫn đang trong giai đoạn phát triển hoặc không hoạt động như mong muốn. Mọi người có thể tạo issues tại [đây](https://github.com/tamld/cmdToolForHelpdesk/issues)
- Các ứng dụng, tính năng, thiết lập có thể tắt bằng cách thên REM hoặc :: vào phía trước câu lệnh đó
- Function List trong Notepad++ giúp quản lý các function trong CMD tiện lợi hơn
- Các scripts trong file CMD được cá nhân hóa theo cá nhân người viết. Mọi người có thể tự do clone / fork / edit lại file này mà không cần yêu cầu bất cứ quyền gì từ tác giả
- Hãy test trong môi trường máy ảo trước khi thực hiện ở thực tế

# II. Hướng dẫn

## 1. Menu chức năng

### **1.1. Cài đặt tất cả app, bằng scripts (Install All In One Online)**

Cho phép cài đặt, cấu hình tự động các chức năng cơ bản như: múi giờ GMT+7, cài đặt các gói ứng dụng miễn phí, cơ bản như 7zip, Unikey, Chrome, Firefox, Foxit PDF Reader, Ultraview, Teamviewer...v..v..
Cài theo các option:

- Cài đặt software cho máy mới, không kèm office (Fresh Install without Office)
- Cài đặt software cho máy mới, không kèm office 2019 (Fresh Install with Office 2019)
- Cài đặt software cho máy mới, không kèm office 2021 (Fresh Install with Office 2021)

### **1.2. Cài đặt và xử lý lỗi liên quan đến Office - Windows (Windows Office Utilities)**

- Tạo bộ cài đăt office online 2019 - 2021 - 365 (Install Office Online)
- Gỡ cài đặt Office (Uninstall Office)
- Gỡ key Office đã cài đặt - thường dùng để nạp key mới, đổi phiên bản Office (Remove Office Key)
- Chuyển đổi các version từ Retail sang Volume lincense và ngược lại (Convert Office Retail <==> Volume License)
- Fix tình trạng Noncore khi nhập Key Windows (Fix Noncore Windows)
- Nạp SKUS giúp Windows chuyển sang các eddition khác nhau - Home - Pro - Enterprise - LTSB - LTSC... (Load SKUS Windows)
  
### **1.3. Hỗ trợ kích hoạt Windows / Office online (Active Licenses)**

- Kích hoạt Windows - Office online - Key Online (Online)
- Kích hoạt Windows - Office by phone - Key Error code 08 (By Phone)
- Kiểm tra tình trạng kích hoạt Windows - Office (Check Licenses)
- Sao lưu License Windows - Office (Backup Licenses)
- Khôi phục License Windows - Office từ folder Backup (Restore License)
- Kích hoạt Windows / Office bằng MAS - Microsoft Activation Scripts (MAS)
  
:dollar::dollar::dollar:
**Lưu ý**
- File scripts chỉ hỗ trợ các bước kích hoạt Windows băng CMD
- Key active cần tự chuẩn bị trước
- Nguồn key miễn phí, mọi người có thể đăng kí tài khoản hoặc mua subscription nếu có điều kiện:
  - Reg account Office 365 Online: [PITVN Community](https://pitvncommunity.com/)
  - Forum: [VNZ](https://vn-z.vn/threads/tong-hop-key-windows-va-office.10945/)
  - FB: [PITVN](https://www.facebook.com/groups/pitvn2023), [3S-Team](https://www.facebook.com/ad.3s.team)
  - Get IID, CID: [GetCID](https://getcid.info/), [kichhoat24h](https://kichhoat24h.com/), [khoatoantin](https://khoatoantin.com/pidms)

### **1.4. Các tiện ích nhỏ (Utilities)**

- Thiết lập High perfomance - Power plan (Set High Performance)
- Đổi hostname máy tính (Change hostname)
- Dọn dẹp rác hệ thống bằng Cleanmgr (Clean up system)
- Thêm user vào admin group (Add user to Admin group)
- Thêm user vào user group (Add user to Users group)
- Cài đặt phần mềm Support Assistance các hãng như DELL, HP, Lenovo ... (Install Support Assistance)
- Hỗ trợ join domain từ CMD (Install Support Assistance)

### **1.5. Cài đặt phần mềm tự động (Package Management)**

- Cài đặt Winget, Chocolately (Install Package Management)
- Cài đặt các phần mềm cơ bản cho End Users (Install End Users applications)
- Cài đặt các ứng dụng hỗ trợ remote từ xa như Teamviewer, Ultraview (Install Remote applications)
- Cài đặt các ứng dụng văn phòng (Install Desk jobs applications)
- Cài đặt các ứng dụng Network (Install Network applications)
- Cài đặt các ứng dụng Chat, communicate (Install Chat applications)
- Tự động cập nhật các ứng dụng trên máy
  
### **1.6. Cập nhật file CMD online, từ trang chủ (Update CMD)**

Tự động download file InstallAPP.cmd trực tiếp từ github. Giúp cập nhật latest version cho file

### **1.7. Đóng và dọn dẹp file tạm (Exit)**
