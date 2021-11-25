# InstallAppForHelpDesk

Batch script CMD 
- Hỗ trợ Font Unicode
- Ứng dụng dành cho HĐH W10 x64
- Offline file installer cần được tạo và đặt chung folder với file CMD
- Folder đặt file CMD khuyến khích viết tiếng Anh hoặc tiếng Việt không dấu
- Các ứng dụng cần đặt tên theo format định sẵn. Danh sách ứng dụng theo danh sách bên dưới:
  + 7zx64.exe
  + unikey43RC5-200929-win64.zip
  + ChromeStandaloneSetup64.exe
  + FirefoxSetup.exe
  + npp.Installer.x64.exe
  + AcroRdrDC.exe
  + BCUninstaller.exe
  + SlackSetup.msi
======================================================================
- Lưu ý: Chức năng [Main] > 6. Update bộ ứng dụng có thể download luôn các offline cần thiết. File sẽ download về cùng thư mục với file CMD. Sau khi update thì bỏ vào chung 1 thư mục hoặc USB để tiện cho việc sử dụng
- Nếu không muốn cài ứng dụng nào thì thêm REM trước dòng (từ dòng 80-87) trong installAPP.cmd
- Ví dụ: REM MsiExec.exe /i SlackSetup.msi /qn /norestart
========================================================================
Menu chức năng
1. Cài Minisoft
=> Các ứng dụng offline, dành cho văn phòng
2. Cài Office 2019
=> Đang phát triển, dự kiến kết hợp 3rd App để download và cài đặt theo ngữ cảnh yêu cầu
3. Active Windows+Office
=> Đang phát triển, dự kiến kết hợp batch script CMD để kích hoạt các bản Windows, Office. Yêu cầu có key Retail hoặc VL. Không sử dụng KMS
4. Đổi tên hostname
=> Đổi tên máy tính. Đọc lưu ý trên màn hình thao tác để thực hiện
5. Cài đặt Support Assistant
=> Bộ công cụ Assistant của hãng HP, DELL. Giúp update bios, driver,..etc
6. Update bộ ứng dụng
=> Download bộ ứng dụng offline install. Tiện cho việc bỏ vào USB, update thường xuyên dựa trên source trang chủ hoặc sourforget (latest)
7. Winget
=> Bộ công cụ quản lí gói cài đặt, hỗ trợ trên Windows 10, 1809 trở đi. Phát triển bởi Microsoft. Hỗ trợ việc cài đặt, gỡ, update online bằng câu lệnh
========================================================================
- Mục tiêu hỗ trợ cho công việc Helpdesk, kĩ thuật viên hàng ngày.
- Các gói ứng dụng được lấy URL từ trang chủ hoặc SourceForget. Vui lòng kiểm tra xem gói ứng dụng là commercial hay noncommercial để có nhu cầu sử dụng phù hợp với đối tượng cá nhân hoặc doanh nghiệp
