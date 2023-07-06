# I. Giới thiệu

- Mục tiêu hỗ trợ cho công việc Helpdesk, kĩ thuật viên hàng ngày.
- Cải thiện hiệu quả và năng suất lao động bằng cách sử dụng các scripts hỗ trợ tự động cài đặt các ứng dụng, gói ứng dụng.
- Fix một số lỗi liên quan đến Office, Windows.
- Các phần mềm cài đặt sẽ sử dụng Package Management là Chocolately và Winget
Link tham khảo:
<https://github.com/chocolatey/choco>
<https://github.com/microsoft/winget-cli>
- Ứng dụng hỗ trợ Windows 10 1809 trở đi
- Test trên Windows Sanbox 11 Enterprise
- Một số chức năng, không hoạt động như mong muốn. Mong mọi người có thể tạo issues giúp mình tại URL:
<https://github.com/tamld/cmdToolForHelpdesk/issues>
để mình hoàn thiện thêm bộ tool này.
- Một số tính năng vẫn đang trong giai đoạn phát triển.
- Add thêm mô tả về tính năng của các function để tường minh hơn.
- Các ứng dụng, tính năng, thiết lập có thể tắt bằng cách thên REM hoặc :: vào phía trước câu lệnh đó.
========================================================================

# II. Hướng dẫn

## 1. Menu chức năng

### **1.1. Cài đặt tất cả app, bằng scripts (Install All In One Online)**

Cho phép cài đặt, cấu hình tự động các chức năng cơ bản như: múi giờ GMT+7, cài đặt các gói ứng dụng miễn phí, cơ bản như 7zip, Unikey, Chrome, Firefox, Foxit PDF Reader, Ultraview, Teamviewer...v..v..
Cài theo các option:

- Cài đặt software cho máy mới, không kèm office
- Cài đặt software cho máy mới, không kèm office 2019
- Cài đặt software cho máy mới, không kèm office 2021

### **1.2. Cài đặt và xử lý lỗi liên quan đến Office - Windows (Windows Office Utilities)**

- Tạo bộ cài đăt office online 2019 - 2021 - 365 (Install Office Online)
- Gỡ cài đặt Office (Uninstall Office)
- Gỡ key Office đã cài đặt - thường dùng để nạp key mới, đổi phiên bản Office (Remove Office Key)
- Chuyển đổi các version từ Retail sang Volume lincense và ngược lại (Convert Office Retail <==> Volume License)
- Fix tình trạng Noncore khi nhập Key Windows (Fix Noncore Windows)
- Nạp SKUS giúp Windows chuyển sang các eddition khác nhau - Home - Pro - Enterprise - LTSB - LTSC... (Load SKUS Windows)
  
### **1.3. Active Windows+Office**

Hỗ trợ các bước kích hoạt Windows băng CMD. Key active các bạn cần tự chuẩn bị
Hỗ trợ redirect link tới trang web kích hoạt Windows bằng commandline
Thêm MAS để lấy BQS 1 số eddition như LTSB, LTSC
*4. Utilities
Các chức năng set High perfomance
Đổi hostname máy tính
Dọn dẹp các thành phần rác hệ thống bằng cleanmgr
Thêm user vào admin group
Thêm user vào user group
Cài đặt phần mềm Support Assistance các hãng như DELL, HP, Lenovo ...
Join domain
*5. Winget
Bộ công cụ quản lí gói cài đặt, hỗ trợ trên Windows 10, 1809 trở đi. Phát triển bởi Microsoft. Hỗ trợ việc cài đặt, gỡ, update online bằng câu lệnh
Cài đặt các ứng dụng Utilities bằng Winget như: slack, zalo, 7zip, google chrome, firefox, bcuninstaller
Cài đặt các ứng dụng hỗ trợ remote từ xa như teamviewer, ultraview
Cập nhật các ứng dụng trên máy bằng Winget

1. Update CMD
Tính năng tự động download file InstallAPP.cmd trực tiếp từ github. Giúp cập nhật latest version cho file

========================================================================
