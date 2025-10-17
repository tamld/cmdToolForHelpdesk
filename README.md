
<h1 align="center">🚀 Helpdesk Tool - Công cụ hỗ trợ IT</h1>
<p align="center">
  <a href="https://github.com/tamld/cmdToolForHelpdesk/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue" alt="License"></a>
  <a href="https://github.com/tamld/cmdToolForHelpdesk/issues"><img src="https://img.shields.io/github/issues/tamld/cmdToolForHelpdesk" alt="Issues"></a>
  <a href="https://github.com/tamld/cmdToolForHelpdesk/stargazers"><img src="https://img.shields.io/github/stars/tamld/cmdToolForHelpdesk" alt="Stars"></a>
</p>

[View in English](README.en.md)

---

## 📖 Mục lục
- [📖 Mục lục](#-mục-lục)
- [🔹 Giới thiệu](#-giới-thiệu)
- [⚙ Chức năng chính](#-chức-năng-chính)
- [📌 Giao diện](#-giao-diện)
- [📌 Hướng dẫn sử dụng](#-hướng-dẫn-sử-dụng)
  - [1. **Chạy offline file hoặc chạy từ CMD**](#1-chạy-offline-file-hoặc-chạy-từ-cmd)
  - [2. **Chọn chức năng cần thực hiện:**](#2-chọn-chức-năng-cần-thực-hiện)
  - [3. **Cập nhật script (nếu cần)**](#3-cập-nhật-script-nếu-cần)
  - [4. **Cài đặt phần mềm tự động**](#4-cài-đặt-phần-mềm-tự-động)
- [📜 Giấy phép](#-giấy-phép)
- [💡 Đóng góp \& Phát triển](#-đóng-góp--phát-triển)
- [🔗 Nguồn tài nguyên tham khảo](#-nguồn-tài-nguyên-tham-khảo)

---

## 🔹 Giới thiệu

**Helpdesk Tool** là công cụ hỗ trợ IT, giúp tự động hóa cài đặt phần mềm, xử lý lỗi hệ thống và tối ưu Windows.  
**Mục tiêu chính**:
- Giảm thời gian xử lý lỗi cho kỹ thuật viên IT.  
- Cài đặt phần mềm tự động qua **Chocolatey & Winget**.  
- Khắc phục lỗi Windows, Office, kích hoạt bản quyền.  

📌 **Lưu ý quan trọng**:
- Một số chức năng vẫn đang phát triển. Nếu gặp lỗi, hãy báo cáo tại [GitHub Issues](https://github.com/tamld/cmdToolForHelpdesk/issues).
- Trước khi chạy, nên thử trên **máy ảo** để tránh lỗi hệ thống.

---

## ⚙ Chức năng chính

| Chức năng | Mô tả |
|-----------|-------|
| **📦 Cài đặt phần mềm** | Tự động cài đặt Chrome, Unikey, TeamViewer... |
| **🔄 Sửa lỗi Windows** | Khắc phục lỗi update, xóa cache, tối ưu registry |
| **🖥️ Quản lý Office** | Gỡ cài đặt, chuyển đổi phiên bản, sửa lỗi kích hoạt |
| **🔑 Kích hoạt Windows & Office** | Kiểm tra, sao lưu, phục hồi key bản quyền |
| **💾 Dọn dẹp hệ thống** | Xóa file rác, tối ưu hiệu suất |
| **🔌 Tùy chỉnh Windows** | Chỉnh Power Plan, đổi hostname, disable service thừa |
| **📂 Quản lý package** | Hỗ trợ cài đặt & cập nhật phần mềm bằng `Chocolatey` & `Winget` |

---
## 📌 Giao diện

Dưới đây là giao diện chính và một số tính năng quan trọng:

- **Menu chính của Helpdesk Tool**
  ![Main menu](pictures/1.png)

- **Tùy chọn cài đặt phần mềm AIO (All-in-One)**
  ![AIO](pictures/1-1.png)

- **Công cụ quản lý Windows & Office**
  ![Office](pictures/1-2.png)

- **Kích hoạt Windows & Office**
  ![License](pictures/1-3.png)

- **Các tiện ích hệ thống**
  ![Utilities](pictures/1-4.png)

- **Quản lý Package (Winget & Chocolatey)**
  ![Package Management](pictures/1-5.png)


## 📌 Hướng dẫn sử dụng


### 1. **Chạy offline file hoặc chạy từ CMD**  

**Cách 1: Tải xuống Repo và chạy file CMD offline**
![Download](pictures/0.png)
**Cách 2 Chạy trực tiếp bằng command line**

```cmd
cd /d %temp% && curl -fsSL -o helpdesk-tools.cmd https://tinyurl.com/tamld-cmd && start helpdesk-tools.cmd
```

### 2. **Chọn chức năng cần thực hiện:**
+ Nhập số tương ứng với chức năng (1, 2, 3...).
+ Làm theo hướng dẫn hiển thị trên màn hình.

### 3. **Cập nhật script (nếu cần)**

### 4. **Cài đặt phần mềm tự động**
Có thể chọn cài đặt theo từng nhóm phần mềm hoặc tất cả cùng lúc:


|**Chế độ**|Ứng dụng được cài|Menu|
|-----------|-------|-------|
|**📦 Tất cả**|Cài toàn bộ phần mềm tự động|**1**|
|**🌐 Cơ bản**|Chrome, 7-Zip, Unikey, Foxit PDF|**5-2**|
|**🛠 Hỗ trợ IT**|Zalo, Facebook Messenger, Telegram|**5-3**|
|**🖥 Tools Network**|Xpipe, Rclone, OpenSSH, mobaxterm,Putty|**5-4**|
|**💬 Công cụ chat**|Microsoft Office, Teams, Zoom|**5-5**|
|**🔄 Upgrade all**| Tự động cập nhật danh sách quản lí bằng Winget hoặc chocolatey |**5-6**|

---

## 📜 Giấy phép
Dự án này được cấp phép theo **MIT License** - xem chi tiết tại [LICENSE](LICENSE).

## 💡 Đóng góp & Phát triển
Chúng tôi hoan nghênh mọi đóng góp từ cộng đồng! 🚀  

Bạn có thể:
- 📌 **Fork dự án** và phát triển thêm tính năng mới.
- 🔧 **Chỉnh sửa và tối ưu mã nguồn** để cải thiện hiệu suất.
- 🛠 **Gửi Pull Request (PR) trên GitHub** nếu bạn có cải tiến.
- 🐞 **Báo lỗi & đề xuất tính năng mới** trong [GitHub Issues](https://github.com/tamld/cmdToolForHelpdesk/issues).

📌 **Cách tham gia**:
1. **Fork repo này** bằng cách nhấn nút "Fork" trên GitHub.
2. **Clone repo về máy**:
```cmd
git clone https://github.com/tamld/cmdToolForHelpdesk.git
```

## 🔗 Nguồn tài nguyên tham khảo

- [📦 Chocolatey - Package Manager](https://chocolatey.org/)
- [🛠 Winget CLI - Microsoft Official](https://github.com/microsoft/winget-cli)
- [📖 Microsoft Docs - Windows Administration](https://docs.microsoft.com/en-us/windows/)