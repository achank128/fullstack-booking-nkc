CREATE DATABASE BookingManagement
GO

USE BookingManagement
GO

CREATE TABLE T_DiaDiem(
	MaDiaDiem int identity(1,1) not null,
	TenDiaDiem nvarchar(50) not null,
	Anh varchar(255),
	LoaiDiaDiem nvarchar(50),

	CONSTRAINT PK_DiaDiem PRIMARY KEY (MaDiaDiem),
)

CREATE TABLE T_Loai(
	MaLoai nvarchar(10) not null,
	TenLoai nvarchar(50) not null,
	Anh varchar(255),

	CONSTRAINT PK_Loai PRIMARY KEY (MaLoai),
)

CREATE TABLE T_DichVu(
	MaDichVu int identity(1,1) not null,
	TenDichVu nvarchar(255) not null,

	CONSTRAINT PK_DichVu PRIMARY KEY (MaDichVu),
)

CREATE TABLE T_KhachSan(
	MaKhachSan int identity(1,1) not null,
	TenKhachSan nvarchar(100) not null,
	ChatLuong tinyint,
	DanhGia float,
	SoDanhGia int,
	DiaChi nvarchar(255),
	Anh varchar(255),
	MaLoai nvarchar(10),
	MoTa nvarchar(500),
	MaDiaDiem int,

	CONSTRAINT PK_KhachSan PRIMARY KEY (MaKhachSan),
	CONSTRAINT FK_KhachSanDiaDiem FOREIGN KEY (MaDiaDiem) REFERENCES T_DiaDiem(MaDiaDiem), 
	CONSTRAINT FK_KhachSanLoai FOREIGN KEY (MaLoai) REFERENCES T_Loai(MaLoai), 
	CONSTRAINT CHK_DanhGiaKS CHECK (DanhGia >= 0 AND DanhGia <= 10),
	CONSTRAINT CHK_ChatLuongKS CHECK (ChatLuong > 0 AND ChatLuong <= 5),
)

CREATE TABLE T_DSDichVu(
	MaDS int identity(1,1) not null,
	MaDichVu int,
	MaKhachSan int,

	CONSTRAINT PK_DSDichVuKS PRIMARY KEY (MaDS),
	CONSTRAINT FK_DSDichVuKS FOREIGN KEY (MaDichVu) REFERENCES T_DichVu(MaDichVu), 
	CONSTRAINT FK_DSDVKhachSan FOREIGN KEY (MaKhachSan) REFERENCES T_KhachSan(MaKhachSan), 
)

CREATE TABLE T_LoaiPhong(
	MaLoaiPhong int identity(1,1) not null,
	TenLoaiPhong nvarchar(255) not null,
	MoTa nvarchar(500),
	SoGiuong nvarchar(50),
	SoNguoi tinyint,
	SoPhong int,
	GiaPhong money,
	MaKhachSan int,

	CONSTRAINT PK_LoaiPhong PRIMARY KEY (MaLoaiPhong),
	CONSTRAINT FK_PhongKhachSan FOREIGN KEY (MaKhachSan) REFERENCES T_KhachSan(MaKhachSan),
)

CREATE TABLE T_Phong(
	MaPhong int identity(1,1) not null,
	TenPhong nvarchar(50) not null,
	TrangThai nvarchar(20) default(N'Sẵn sàng'), 
	MaLoaiPhong int

	CONSTRAINT PK_Phong PRIMARY KEY (MaPhong),
	CONSTRAINT FK_PhongLoai FOREIGN KEY (MaLoaiPhong) REFERENCES T_LoaiPhong(MaLoaiPhong),
)

CREATE TABLE T_TaiKhoan(
	MaTaiKhoan int identity(1,1) not null,
	TenDangNhap varchar(50) not null unique,
	MatKhau varchar(50) not null,
	Email varchar(50) unique,
	HoTen nvarchar(50),
	SDT nvarchar(50),

	CONSTRAINT PK_TaiKhoan PRIMARY KEY (MaTaiKhoan),
	CONSTRAINT CHK_MatKhauTK CHECK (LEN(MatKhau) >= 6),
)

CREATE TABLE T_DonDatPhong(
	MaDat int identity(1000,1) not null,
	MaTaiKhoan int not null,
	MaPhong int not null,
	NgayCheckin date not null,
	NgayCheckout date not null,
	NgayDat date default(getdate()),
	GhiChu nvarchar(255),
	TongTien money not null,

	CONSTRAINT PK_DonDatPhong PRIMARY KEY (MaDat),
	CONSTRAINT FK_DonDatPhong FOREIGN KEY (MaPhong) REFERENCES T_Phong(MaPhong), 
	CONSTRAINT FK_DonDatTaiKhoan FOREIGN KEY (MaTaiKhoan) REFERENCES T_TaiKhoan(MaTaiKhoan),
	CONSTRAINT CHK_NgayDDP CHECK (NgayCheckin < NgayCheckout),
)

--------------------------------DU LIEU---------------------------------

--DIA DIEM//////////////////////////////////////////////////////////////
INSERT INTO T_DiaDiem(TenDiaDiem, LoaiDiaDiem, Anh) VALUES 
(N'Hà Nội', N'Thành phố', 'https://cf.bstatic.com/xdata/images/xphoto/300x240/140009654.jpg?k=a3325530ab89dc0e4af224d61d4cd084a386a089ff08076053437562b117745d&o='),
(N'TP Hồ Chí Minh', N'Thành phố', 'https://cf.bstatic.com/xdata/images/xphoto/300x240/140009627.jpg?k=523e6e214e213e868befa01d37c57e1becaa09b829eb08a8804c0bc0273ea67c&o='),
(N'TP Đà Nẵng', N'Bãi biển', 'https://cf.bstatic.com/xdata/images/xphoto/300x240/140009662.jpg?k=72b776fd2f897de1ff6bc4df7c9d45fb191b8d23593fa1f845c7341b5062e8ad&o='),
(N'Thanh Hóa', N'Bãi biển', 'https://cf.bstatic.com/xdata/images/city/square250/973719.webp?k=3a1327078c50be64f333ac1e22d5c0ee2c811967e509ce6869f22cadfb739296&o='),
(N'Huế', N'Địa danh', 'https://cf.bstatic.com/xdata/images/xphoto/300x240/140009650.jpg?k=badb8b649b3ed4c1733cabba7f694533a9c84900acdeb0181b773c137529c1c1&o='),
(N'Hải Phòng', N'Thành phố', 'https://cf.bstatic.com/xdata/images/city/540x270/943194.webp?k=5966e47f057f44c84a0cce017fd8c8a4cd5bee797f811f30658d67eb341efe70&o='),
(N'Hạ Long', N'Bãi biển', 'https://cf.bstatic.com/xdata/images/city/square250/688867.webp?k=15584889423b53b870736327a2ed9ba74280161e1567b20e5788ef8c03ac0a06&o='),
(N'Nha Trang', N'Bãi biển', 'https://cf.bstatic.com/xdata/images/xphoto/300x240/140009643.jpg?k=aade5cdbe83df5b05f12d1f266713187677331ddbc46e2f0d66e7e3ecb2aec8b&o='),
(N'Hội An', N'Địa danh', 'https://cf.bstatic.com/xdata/images/xphoto/300x240/140009652.jpg?k=362912454175551abcb0dc3ae419875b11628fccf6d95ed699a8063173c8f5a6&o='),
(N'Vũng Tàu', N'Bãi biển', 'https://r-xx.bstatic.com/xdata/images/city/250x250/688956.jpg?k=fc88c6ab5434042ebe73d94991e011866b18ee486476e475a9ac596c79dce818&o='),
(N'Đà Lạt', N'Thiên nhiên', 'https://q-xx.bstatic.com/xdata/images/city/250x250/688831.jpg?k=7b999c7babe3487598fc4dd89365db2c4778827eac8cb2a47d48505c97959a78&o='),
(N'Phú Quốc', N'Bãi biển', 'https://r-xx.bstatic.com/xdata/images/city/250x250/688879.jpg?k=82ca0089828054a1a9c46b14ea7f1625d73d42505ae58761e8bcc067f9e72475&o='),
(N'Hà Giang', N'Thiên nhiên', 'https://cf.bstatic.com/xdata/images/xphoto/300x240/140009658.jpg?k=857cc7150acbe5b9d00492f8fceb3bbc2d68d178f744d1bfd0c5854d930972dc&o=')


--LOAI////////////////////////////////////////////////////////////////
INSERT INTO T_Loai(MaLoai, TenLoai, Anh) VALUES 
('KS', N'Khách Sạn', 'https://cf.bstatic.com/xdata/images/xphoto/square300/57584488.webp?k=bf724e4e9b9b75480bbe7fc675460a089ba6414fe4693b83ea3fdd8e938832a6&o='),
('CH', N'Căn Hộ', 'https://cf.bstatic.com/static/img/theme-index/carousel_320x240/card-image-apartments_300/9f60235dc09a3ac3f0a93adbc901c61ecd1ce72e.jpg'),
('BT', N'Biệt Thự', 'https://cf.bstatic.com/static/img/theme-index/carousel_320x240/card-image-villas_300/dd0d7f8202676306a661aa4f0cf1ffab31286211.jpg'),
('HS', N'Homestay', 'https://cf.bstatic.com/xdata/images/hotel/square600/356163265.webp?k=d10670d7858ae1d58372b0d99660372ac7f249e00884775720b47d85019b40a9&o=&s=1')


--DICH VU///////////////////////////////////////////////////////////
INSERT INTO T_DichVu(TenDichVu) VALUES 
(N'Chỗ đỗ xe miễn phí'), 
(N'Bữa sáng'), 
(N'Phòng không hút thuốc'), 
(N'Nhà hàng'), 
(N'Trung tâm Spa & chăm sóc sức khoẻ'), 
(N'Xe đưa đón sân bay'), 
(N'Giáp biển'), 
(N'Trung tâm thể dục'),
(N'Hồ bơi'), 
(N'Quầy bar'), 
(N'Lễ tân 24 giờ'), 
(N'Tiện nghi cho khách khuyết tật'), 
(N'Chỗ đậu xe riêng'), 
(N'WiFi có ở mọi khu vực'), 
(N'Dịch vụ phòng'), 
(N'Máy pha trà/cà phê trong tất cả các phòng') 


--KHACH SAN, LOAI PHONG, DS DICH VU/////////////////////////////////////////////////////

---HN
-------------1--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (1, N'Beryl Palace Hotel and Spa', 4, 9.0, 446, 'KS',
N'173 Hang Bong Street, Quận Hoàn Kiếm, Hà Nội, Việt Nam', 
N'Lối trang trí kiểu cổ điển của Pháp và kiến trúc Châu Âu là nét đặc trưng của Beryl Palace Hotel and Spa, một chỗ nghỉ boutique nằm trên Phố Cổ Hàng Bông nhộn nhịp. Chỉ nằm cách Nhà Hát Lớn Hà Nội nổi tiếng 15 phút đi bộ, chỗ nghỉ này cung cấp các liệu pháp mát-xa thư giãn và WiFi miễn phí.',
'https://cf.bstatic.com/xdata/images/hotel/max1024x768/285771256.jpg?k=0abed749d3d4d1e6ef2c2f5ea41229ea91ac5a622ed59f20f56bbc0b60bac698&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(1, N'Phòng Superior Giường Đôi/2 Giường Đơn', N'1 giường đôi cực lớn/2 giường đơn', 2, 1210000, 6,
N'22 m²-Điều hòa không khí-Phòng tắm riêng trong phòng-TV màn hình phẳng-Hệ thống cách âm-WiFi miễn phí'),

(1, N'Phòng Deluxe Giường Đôi/2 Giường Đơn', N'1 giường đôi cực lớn/2 giường đơn', 2, 1378000, 4,
N'25 m²-Điều hòa không khí-Phòng tắm riêng trong phòng-TV màn hình phẳng-Hệ thống cách âm-WiFi miễn phí'),

(1, N'Phòng Executive Giường Đôi/2 Giường Đơn Với Tầm Nhìn Ra Thành Phố', N'1 giường đôi cực lớn/2 giường đơn', 2, 1440000, 4,
N'30 m²-Điều hòa không khí-Phòng tắm riêng trong phòng-TV màn hình phẳng-Hệ thống cách âm-WiFi miễn phí'),

(1, N'Suite Junior Nhìn Ra Thành Phố', N'1 giường đôi cực lớn', 2, 1720000, 2,
N'22 m²-Điều hòa không khí-Phòng tắm riêng trong phòng-TV màn hình phẳng-Hệ thống cách âm-WiFi miễn phí')

--dvks
INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES 
(1, 6), 
(1, 3), 
(1, 5), 
(1, 15), 
(1, 14), 
(1, 10), 
(1, 2)


-------------2--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (1, N'L"Heritage Hotel Hanoi', 4, 9.3, 431, 'KS',
N'39-41 Hang Ga Street, Quận Hoàn Kiếm, Hà Nội, Việt Nam ', 
N'Nằm ở vị trí trung tâm tại Khu Phố Cổ quyến rũ, L"Heritage Hotel Hanoi cách Hồ Hoàn Kiếm và Văn Miếu 5 phút đi bộ. Các phòng máy lạnh hiện đại tại đây được trang bị Wi-Fi miễn phí. Khách sạn còn có phòng xông hơi khô và phòng tập thể dục.',
'https://cf.bstatic.com/xdata/images/hotel/max1024x768/6048343.jpg?k=51a94b82e3fd0cb70dd78ce8cc5945d911c263d7d4e50e06c4ee691b76bf16be&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(2, N'Phòng Deluxe Giường Đôi/2 Giường Đơn', N'1 giường đôi lớn/2 giường đơn', 2, 1575000, 12,
N'25 m²-Ban công-Nhìn ra thành phố-Điều hòa không khí-Phòng tắm riêng trong phòng-TV màn hình phẳng-Hệ thống cách âm-WiFi miễn phí'),

(2, N'Suite Executive', N'1 giường đôi cực lớn', 2, 2230000, 4,
N'41 m²-Ban công-Nhìn ra thành phố-Điều hòa không khí-Phòng tắm riêng trong phòng-TV màn hình phẳng-Hệ thống cách âm-WiFi miễn phí')


--dvks
INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES 
(2, 6), 
(2, 3), 
(2, 5), 
(2, 16), 
(2, 15), 
(2, 14), 
(2, 10), 
(2, 2)

-------------3--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (1, N'Riverside Hanoi Hotel', 4, 8.3, 185, 'KS',
N'118 Nguyen Dinh Hoan, Bo Song Road, Nghia Do, Cau Giay, Cau Giay, Hà Nội, Việt Nam', 
N'Riverside Hanoi Hotel tọa lạc ở trung tâm thành phố Hà Nội, chỉ cách Cầu Thê Húc và Hồ Hoàn Kiếm 5,5 km. Quý khách có thể rèn luyện sức khỏe cho sảng khoái tại trung tâm thể dục và truy cập Wi-Fi miễn phí trong tất cả các khu vực.',
'https://cf.bstatic.com/xdata/images/hotel/max1280x900/356203907.jpg?k=ccfe760b0808f31ed22e640eb17722058ddce2251bc48936e4ff46ead7a2726a&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(3, N'Phòng Superior Giường Đôi', N'1 giường đôi cực lớn', 2, 594000, 4,
N'25 m²-Nhìn ra hồ-Nhìn ra vườn-Nhìn ra địa danh nổi tiếng-Nhìn ra thành phố-Điều hòa không khí-Máy rửa bát-Phòng tắm riêng trong phòng-TV màn hình phẳng-Hệ thống cách âm-WiFi miễn phí'),

(3, N'Phòng Deluxe Giường Đôi', N'1 giường đôi cực lớn', 2, 675000, 3,
N'30 m²-Nhìn ra hồ-Nhìn ra vườn-Nhìn ra địa danh nổi tiếng-Nhìn ra thành phố-Điều hòa không khí-Máy rửa bát-Phòng tắm riêng trong phòng-TV màn hình phẳng-Hệ thống cách âm-WiFi miễn phí'),

(3, N'Suite Gia Đình', N'2 giường đôi cực lớn', 4, 1480000, 2,
N'60 m²-Bếp riêng-Phòng tắm riêng-Ban công-Nhìn ra hồ-Nhìn ra vườn-Nhìn ra địa danh nổi tiếng-Nhìn ra thành phố-Nhìn ra sông-Điều hòa không khí-Bồn tắm spa-Máy rửa bát-TV màn hình phẳng-Hệ thống cách âm-Sân hiên-Phòng xông hơi-Minibar-WiFi miễn phí')


--dvks
INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES 
(3, 6), 
(3, 3), 
(3, 8), 
(3, 16), 
(3, 1), 
(3, 14), 
(3, 10), 
(3, 2)


-------------4--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (1, N'Moon West Lake Hotel & Residence', 3, 8.3, 209, 'CH',
N'185 Trích Sài, Quận Tây Hồ, Hà Nội, Việt Nam', 
N'Tọa lạc tại thành phố Hà Nội, cách Bảo tàng Dân tộc học Việt Nam 3,1 km và Lăng Chủ tịch Hồ Chí Minh 3,5 km, Moon West Lake Hotel & Residence có tầm nhìn ra quang cảnh hồ nước cũng như WiFi miễn phí. Chỗ nghỉ này có máy điều hòa và bồn nước nóng.',
'https://cf.bstatic.com/xdata/images/hotel/max1024x768/304355783.jpg?k=5f595afc780e1ad01b3f05bed6108fd956431ade248260dd2dc728cf4253e413&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(4, N'Căn Hộ Studio', N'1 giường đôi', 2, 760000, 1,
N'20 m²-Căn hộ nguyên căn-Bếp riêng-Phòng tắm riêng-Điều hòa không khí-TV màn hình phẳng-WiFi miễn phí')

--dvks
INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES 
(4, 6), 
(4, 3), 
(4, 14), 
(4, 11), 
(4, 12)

-------------5--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (1, N'Hanoi Sky Hotel', 4, 8.5, 275, 'KS',
N'27 Tong Duy Tan, Quận Hoàn Kiếm, Hà Nội, Việt Nam', 
N'Nằm trong Khu Phố cổ Hà Nội, Hanoi Sky Hotel cách Chợ Đồng Xuân và chợ đêm cuối tuần 10 phút đi bộ. Khách sạn có Wi-Fi miễn phí, bàn đặt tour và nhà hàng.',
'https://cf.bstatic.com/xdata/images/hotel/max1024x768/328677843.jpg?k=888139ea786d5ae073c35db20fb249f48a6bfe7f21ae1ef04a94fab82e6c3833&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(5, N'Phòng Deluxe Giường Đôi', N'1 giường đôi', 2, 768000, 4,
N'25 m²-Nhìn ra thành phố-Điều hòa không khí-Phòng tắm riêng trong phòng-TV màn hình phẳng-Hệ thống cách âm-Minibar-WiFi miễn phí')

--dvks
INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES 
(5, 6), 
(5, 3), 
(5, 14), 
(5, 15), 
(5, 11), 
(5, 12)

-------------6--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (1, N'22Land Residence Hotel & Spa', 4, 9.0, 870, 'KS',
N' 02 Nguyen Dinh Hoan, Cau Giay, Hà Nội, Việt Nam', 
N'Tọa lạc tại thành phố Hà Nội, 22Land Residence Hotel & Spa có nhà hàng, xe đạp cho khách sử dụng miễn phí, hồ bơi ngoài trời và trung tâm thể dục. Khách sạn 4 sao này có WiFi miễn phí, quán bar và sảnh khách chung. Chỗ nghỉ cung cấp dịch vụ lễ tân 24 giờ, dịch vụ phòng và dịch vụ thu đổi ngoại tệ cho khách.',
'https://cf.bstatic.com/xdata/images/hotel/max1024x768/402196656.jpg?k=623037fdaf826752dae0abf6a6a64d98b1ff40c38d5020cae7eeb6c0856667e1&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(6, N'Phòng Superior Giường Đôi', N'1 giường đôi', 2, 900000, 7,
N'25 m²-Tầm nhìn ra khung cảnh-Điều hòa không khí-Phòng tắm riêng-TV màn hình phẳng-Hệ thống cách âm-Minibar-WiFi miễn phí'),

(6, N'Phòng Gia Đình Tiêu Chuẩn', N'2 giường đôi', 4, 1600000, 2,
N'58 m²-Tầm nhìn ra khung cảnh-Điều hòa không khí-Phòng tắm riêng-TV màn hình phẳng-Hệ thống cách âm-Minibar-WiFi miễn phí')

--dvks
INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES 
(6, 9), 
(6, 6), 
(6, 3), 
(6, 5), 
(6, 14), 
(6, 15), 
(6, 11)


-------------7--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (1, N'Hanoi Little Town Hotel', 3, 8.6, 276, 'KS',
N'77 Hang Luoc Street, Quận Hoàn Kiếm, Hà Nội, Việt Nam', 
N'Hanoi Little Town Hotel nằm dọc theo con phố yên tĩnh, trong bán kính 50 m từ Chợ Đồng Xuân. Khách sạn có nhà hàng và cung cấp Wi-Fi miễn phí.',
'https://cf.bstatic.com/xdata/images/hotel/max1024x768/208247911.jpg?k=68d13433dcb37335c47bbece88a43dc0c36e791ffbc3b4f9f30038dc00a082da&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(7, N'Phòng Superior Giường Đôi', N'1 giường đôi', 2, 789000, 7,
N'25 m²-Điều hòa không khí-Phòng tắm riêng-TV màn hình phẳng-Hệ thống cách âm-Sân hiên')

--dvks
INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES 
(7, 9), 
(7, 6), 
(7, 3), 
(7, 5), 
(7, 14), 
(7, 16), 
(7, 11)

-------------8--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (1, N'Hanoi Posh Boutique Hotel', 3, 7.7, 533, 'KS',
N'4A Hàng Giấy, Đồng Xuân, Quận Hoàn Kiếm, Hà Nội, Việt Nam', 
N'Hanoi Posh Boutique Hotel nằm ở vị trí thuận tiện, cách Chợ Đồng Xuân nổi tiếng và Cầu Long Biên 50 m. Khách sạn có lễ tân 24 giờ này cung cấp miễn phí cả Wi-Fi toàn bộ khuôn viên lẫn chỗ đỗ xe.',
'https://cf.bstatic.com/xdata/images/hotel/max1024x768/86499289.jpg?k=d5b4d46581cfaeafeb4b8b0588121dddc4bb98204b662a44d27ac9e740cda861&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(8, N'Phòng Superior Giường Đôi', N'1 giường đôi', 2, 650000, 5,
N'24 m²-Điều hòa không khí-Phòng tắm riêng-TV màn hình phẳng-Hệ thống cách âm-WiFi miễn phí'),

(8, N'Phòng Gia Đình', N'1 giường đơn và 1 giường đôi', 3, 885000, 2,
N'35 m²-Điều hòa không khí-Phòng tắm riêng-TV màn hình phẳng-Hệ thống cách âm-WiFi miễn phí')

--dvks
INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES 
(8, 9), 
(8, 6), 
(8, 3), 
(8, 5), 
(8, 14), 
(8, 10)

-------------9--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (1, N'Elegant Suites Westlake', 5, 8.9, 209, 'CH',
N'10B Dang Thai Mai Street, Quận Tây Hồ, Hà Nội, Việt Nam', 
N'Elegant Suites Westlake là tập hợp các căn hộ và studio rộng rãi với các tiện nghi tự phục vụ và Wi-Fi miễn phí. Khách sạn có chỗ đậu xe riêng miễn phí.',
'https://cf.bstatic.com/xdata/images/hotel/max1024x768/69670114.jpg?k=735f8af283a1a070cae324f770079722cd1ba08455c60295152460530c31ee99&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(9, N'Căn Hộ 1 Phòng Ngủ Có Ban Công', N'1 giường đôi lớn', 2, 2410000, 1,
N'86 m²-Bếp riêng-Phòng tắm riêng-Ban công-Nhìn ra vườn-Nhìn ra hồ bơi-Nhìn ra địa danh nổi tiếng-Nhìn ra thành phố-Điều hòa không khí-TV màn hình phẳng-Máy pha Cà phê-Minibar-WiFi miễn phí')

--dvks
INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES 
(9, 9), 
(9, 6), 
(9, 3), 
(9, 5), 
(9, 14), 
(9, 8), 
(9, 16)


-------------10--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (1, N'The Lapis Hotel', 4, 8.9, 354, 'KS',
N'21 Tran Hung Dao St, Hoan Kiem Dist, Quận Hoàn Kiếm, Hà Nội, Việt Nam', 
N'The Lapis Hotel cung cấp các phòng nghỉ tại thành phố Hà Nội và chỉ cách Nhà hát Lớn Hà Nội 500 m. Khách sạn có WiFi miễn phí ở các khu vực chung, hồ bơi ngoài trời, quán bar và nhà hàng trong khuôn viên.',
'https://cf.bstatic.com/xdata/images/hotel/max1024x768/143359957.jpg?k=4ed93f6307320e0ae8187415af0150efb54df1dc6efdf0c3137b43295588bd90&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(10, N'Phòng Tiêu Chuẩn', N'1 giường đôi', 2, 1400000, 6,
N'25 m²-Bồn tắm-Điều hòa không khí-Phòng tắm riêng-TV màn hình phẳng-Hệ thống cách âm-Minibar'),

(10, N'Suite Executive', N'1 giường đôi', 2, 2600000, 3,
N'45 m²-Nhìn ra thành phố-Bồn tắm-Điều hòa không khí-Phòng tắm riêng-TV màn hình phẳng-Hệ thống cách âm-Minibar')

--dvks
INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES 
(10, 9), 
(10, 6), 
(10, 3), 
(10, 5), 
(10, 14), 
(10, 8), 
(10, 16)


---HCM
-------------11--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (2, N'Cochin Zen Hotel', 4, 8.2, 1027, 'KS',
N'46 Thu Khoa Huan, Quận 1, TP. Hồ Chí Minh, Việt Nam', 
N'Cochin Zen Hotel tọa lạc tại vị trí thuận tiện ở Quận 1, được biết đến là trung tâm của Thành phố Hồ Chí Minh. Nằm trên tầng 11, du khách có thể xả hơi và nạp lại năng lượng ở 3 bồn tắm jacuzzi onsen, thư giãn với cocktail giải khát tại quán bar trên sân thượng hoặc rèn luyện sức khỏe ở phòng tập thể dục ngoài trời. Khách sạn cũng có phòng xông hơi khô và phòng xông hơi ướt cho khách tùy nghi sử dụng, đồng thời cung cấp WiFi.',
'https://cf.bstatic.com/xdata/images/hotel/max1024x768/385981973.jpg?k=2acc14b3cb8100a1f73e9dc9c1a3c5eabe896a1c27c40b294d1b5c92df7d44a0&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(11, N'Phòng Deluxe Giường Đôi', N'1 giường đôi', 2, 1610000 , 2,
N'25 m²-Điều hòa không khí-Phòng tắm riêng-TV màn hình phẳng-Hệ thống cách âm-Minibar'),

(11, N'Phòng Gia Đình', N'1 giường đơn  và 1 giường đôi lớn', 3, 2100000 , 1,
N'32 m²-Nhìn ra thành phố-Bồn tắm-Điều hòa không khí-Phòng tắm riêng-TV màn hình phẳng-Hệ thống cách âm-Minibar')

--dvks
INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES 
(11, 9), 
(11, 6), 
(11, 3), 
(11, 5), 
(11, 14), 
(11, 8), 
(11, 16)

-------------12--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (2, N'Valentine Hotel Saigon - Bùi Viện Street', 3, 7.4, 786, 'KS',
N'27-29 Bui Vien, Quận 1, TP. Hồ Chí Minh, Việt Nam', 
N'Valentine Hotel Saigon- Bùi Viện Street tọa lạc tại vị trí trung tâm ở quận 1, thành phố Hồ Chí Minh. Khách sạn cách chợ Bến Thành chưa đến 8 phút đi bộ. Các phòng hiện đại có WiFi miễn phí.',
'https://cf.bstatic.com/xdata/images/hotel/max1024x768/197234486.jpg?k=3dc732e2529ccf17c33ba8867fc8deddcbbab8dc6173182c146f7a81e5b7ff31&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(12, N'Phòng Superior Giường Đôi', N'1 giường đôi', 2, 517000 , 4,
N'20 m²-Tầm nhìn ra khung cảnh-Điều hòa không khí-Phòng tắm riêng-TV màn hình phẳng'),

(12, N'Phòng Deluxe Giường Đôi', N'1 giường đôi', 2, 590000 , 2,
N'24 m²-Tầm nhìn ra khung cảnh-Điều hòa không khí-Phòng tắm riêng-TV màn hình phẳng')

--dvks
INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES  
(12, 6), 
(12, 3), 
(12, 5), 
(12, 14), 
(12, 8), 
(12, 16)

-------------13--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (2, N'Sunshine Antique Hotel Saigon', 4, 8.1, 128, 'KS',
N'549 Tran Hung Dao Street, District 1, Quận 1, TP. Hồ Chí Minh, Việt Nam', 
N'Tọa lạc tại một vị trí lý tưởng tại Quận 1 thuộc Thành phố Hồ Chí Minh, Sunshine Antique Hotel Saigon nằm cách Bảo tàng Mỹ thuật 2 km, Công viên Tao Đàn 2 km và Chợ Bến Thành 2,1 km.',
'https://cf.bstatic.com/xdata/images/hotel/max1024x768/260331854.jpg?k=8c488f06dc7a5eb7fc368124a3b665b9e67b393eb0eac5020045f310f6db8253&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(13, N'Phòng Executive Giường Đôi', N'1 giường đôi', 2, 1080000 , 2,
N'35 m²-Ban công-Nhìn ra thành phố-Nhìn ra sông-Điều hòa không khí-Sân trong-Phòng tắm riêng-TV màn hình phẳng-Hệ thống cách âm-Sân hiên-Minibar-WiFi miễn phí')

--dvks
INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES  
(13, 9), 
(13, 6), 
(13, 3), 
(13, 5), 
(13, 14), 
(13, 8), 
(13, 16)

-------------14--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (2, N'Me Gustas Central Hotel', 3, 8.3, 428, 'KS',
N'19-21 Dong Du Street, Ben Nghe Ward, Quận 1, TP. Hồ Chí Minh, Việt Nam', 
N'Megustas Suite Central Hotel tọa lạc tại trung tâm thành phố Sài Gòn nhộn nhịp, chỉ cách Nhà Hát Lớn 3 phút đi bộ. Khách sạn này cung cấp Wi-Fi miễn phí trong tất cả các khu vực và phòng nghỉ được trang bị đầy đủ tiện nghi',
'https://cf.bstatic.com/xdata/images/hotel/max1024x768/238543849.jpg?k=01ff531ccf2b13f7a08a4095162b9f8d4028f0be7176e452576e41c42504e727&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(14, N'Phòng Premier Giường đôi', N'1 giường đôi', 2, 1260000 , 3,
N'24 m²-Nhìn ra thành phố-Điều hòa không khí-Phòng tắm riêng trong phòng-TV màn hình phẳng-Minibar-WiFi miễn phí'),

(14, N'Phòng Executive', N'1 giường đôi', 2, 1710000 , 1,
N'32 m²-Nhìn ra thành phố-Điều hòa không khí-Phòng tắm riêng trong phòng-TV màn hình phẳng-Minibar-WiFi miễn phí')

--dvks
INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES  
(14, 6), 
(14, 3), 
(14, 11), 
(14, 8), 
(14, 16)

-------------15--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (2, N'Indochine Ben Thanh Hotel & Apartments', 3, 7.8, 626, 'KS',
N'30 Lưu Văn Lang, Quận 1, Quận 1, 700000 TP. Hồ Chí Minh, Việt Nam', 
N'Nằm ở thành phố Hồ Chí Minh, Indochine Ben Thanh Hotel & Apartments có sân hiên và quầy bar. Khách sạn tọa lạc gần một số điểm tham quan nổi tiếng, trong bán kính 200 m từ trung tâm thương mại Takashimaya Việt Nam và khoảng 200 m từ Chợ Bến Thành. Tất cả phòng nghỉ tại đây đều có TV truyền hình vệ tinh màn hình phẳng.',
'https://cf.bstatic.com/xdata/images/hotel/max1024x768/270277714.jpg?k=ac386cdd59ffde9d58a1fed787e292b6ecde7416f53b11ff5b29050fc8987a67&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(15, N'Phòng Deluxe Gia đình', N'2 giường đôi', 4, 1030000 , 2,
N'38 m²-Nhìn ra thành phố-Điều hòa không khí-Phòng tắm riêng-TV màn hình phẳng-Minibar-WiFi miễn phí')

--dvks
INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES   
(15, 6), 
(15, 3), 
(15, 11), 
(15, 8), 
(15, 16)

-------------16--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (2, N'Ngan Ha Hotel', 2, 7.9, 420, 'KS',
N'190 Le Thanh Ton, Quận 1, TP. Hồ Chí Minh, Việt Nam', 
N'Có vị trí thuận tiện ở Quận 1, Ngan Ha Hotel cung cấp các phòng nghỉ trang nhã và thoải mái với Wi-Fi miễn phí tại các khu vực chung. Nơi nghỉ này có lễ tân 24 giờ và chỗ đỗ xe máy miễn phí.',
'https://cf.bstatic.com/xdata/images/hotel/max1024x768/378828506.jpg?k=ea7d10effc56e6e3ded34794423b9a97f43d25c303867e6051d422a08b023480&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(16, N'Phòng Superior Giường Đôi', N'1 giường đôi', 2, 610000 , 4,
N'18 m²-Điều hòa không khí-Sân trong-Phòng tắm riêng trong phòng-TV màn hình phẳng-Hệ thống cách âm-Minibar')

--dvks
INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES  
(16, 6), 
(16, 3), 
(16, 11), 
(16, 8), 
(16, 16)

-------------17--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (2, N'Au Lac Charner Hotel', 4, 8.6, 1183, 'KS',
N'87-89-91 Ho Tung Mau Street, Ben Nghe Ward, Quận 1, TP. Hồ Chí Minh, Việt Nam ', 
N'Tọa lạc tại trung tâm Thành phố Hồ Chí Minh, Au Lac Charner Hotel là khách sạn đầy phong cách lấy cảm hứng từ các phòng trà của thời kỳ thuộc địa Pháp.',
'https://cf.bstatic.com/xdata/images/hotel/max1024x768/155737068.jpg?k=5715f7418801bed814f7580e93fd6a5540b1b01a29166c97a4632b164c712417&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong,  SoPhong, MoTa) VALUES 
(17, N'Phòng Hamelin Executive Giường Đôi', N'1 giường đôi', 2, 2900000 , 4,
N'35 m²-Nhìn ra thành phố-Hồ bơi trên sân thượng-Điều hòa không khí-Sân trong-Phòng tắm riêng trong phòng-TV màn hình phẳng'),

(17, N'Phòng Gia Đình De La Somme ', N'1 giường đôi', 2, 3500000 , 1,
N'40 m²-Nhìn ra thành phố-Hồ bơi trên sân thượng-Điều hòa không khí-Sân trong-Phòng tắm riêng trong phòng-TV màn hình phẳng')

--dvks
INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES  
(17, 9), 
(17, 6), 
(17, 3), 
(17, 11), 
(17, 8), 
(17, 15), 
(17, 16)

-------------18--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (2, N'Sedona Suites Ho Chi Minh City', 5, 9.0, 97, 'CH',
N'67 Le Loi Boulevard, Quận 1, TP. Hồ Chí Minh, Việt Nam', 
N'Tọa lạc tại một địa danh ở trung tâm Thành phố Hồ Chí Minh, Saigon Centre, Sedona Suites Ho Chi Minh City cung cấp chỗ nghỉ với thiết kế nội thất hiện đại. Chỗ nghỉ này có hồ bơi ngoài trời và sân chơi cho trẻ em. Du khách có thể thưởng thức bữa sáng hàng ngày.',
'https://cf.bstatic.com/xdata/images/hotel/max1024x768/150134231.jpg?k=36366b841db401834d2c64fdb7c7c90cde9c90b1b97d515a40ee3bc6b71fabba&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(18, N'Grand Studio', N'1 giường đôi cực lớn', 2, 3630000, 1,
N'35 m²-Nhìn ra thành phố-Điều hòa không khí-Phòng tắm riêng trong phòng-TV màn hình phẳng-WiFi miễn phí')

--dvks
INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES  
(18, 9), 
(18, 6), 
(18, 3), 
(18, 11), 
(18, 8), 
(18, 15), 
(18, 16)

-------------19--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (2, N'Silverland Jolie Hotel', 4, 7.7, 584, 'KS',
N'4D Thi Sach Street, Ben Nghe Ward, Quận 1, TP. Hồ Chí Minh, Việt Nam', 
N'Nằm ở một góc yên tĩnh của Thành phố Hồ Chí Minh, Silverland Jolie Hotelcó tầm nhìn ra quang cảnh Sông Sài Gòn và Bến Bạch Đằng. Khách sạn này có bể sục ngoài trời, quán bar trên sân thượng cũng như nhà hàng và trung tâm spa.',
'https://cf.bstatic.com/xdata/images/hotel/max1024x768/238499128.jpg?k=96cbce3273ba52501bf0958519cb5954ab1a739f6539853f4685ef594a5108f7&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(19, N'Phòng Deluxe 2 Giường Đơn', N'2 giường đơn', 2, 1290000, 5,
N'22 m²-Điều hòa không khí-Phòng tắm riêng trong phòng-TV màn hình phẳng-Minibar-WiFi miễn phí'),

(19, N'Phòng Executive Giường Đôi', N'1 giường đôi', 2, 1615000, 3,
N'32 m²-Nhìn ra thành phố-Điều hòa không khí-Phòng tắm riêng trong phòng-TV màn hình phẳng-Minibar-WiFi miễn phí'),

(19, N'Suite Junior', N'1 giường đôi cực lớn', 2, 2010000, 1,
N'35 m²-Nhìn ra thành phố-Điều hòa không khí-Phòng tắm riêng trong phòng-TV màn hình phẳng-Minibar-WiFi miễn phí')

--dvks
INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES  
(19, 9), 
(19, 6), 
(19, 3), 
(19, 11), 
(19, 8), 
(19, 15), 
(19, 10)

-------------20--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (2, N'Aurora Serviced Apartments', 3, 9.1, 95, 'CH',
N'103 Vo Van Tan, Quận 3, TP. Hồ Chí Minh, Việt Nam', 
N'Tọa lạc tại Thành phố Hồ Chí Minh, cách Bảo tàng Chứng tích Chiến tranh 500 m, Aurora Serviced Apartments cung cấp chỗ nghỉ với xe đạp cho khách sử dụng miễn phí, chỗ đỗ xe riêng miễn phí và sảnh khách chung.',
'https://cf.bstatic.com/xdata/images/hotel/max1024x768/177368234.jpg?k=d2c4c32362d104c993cbb670da177853842253301e88e7c49edd34771e81393a&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(20, N'Studio Tiêu Chuẩn', N'1 giường đôi lớn', 2, 997000, 1,
N'35 m²-Bếp riêng-Phòng tắm riêng trong phòng-Điều hòa không khí-TV màn hình phẳng-Hệ thống cách âm-WiFi miễn phí'),

(20, N'Căn Hộ Studio', N'1 giường đôi lớn', 2, 1100000, 1,
N'35 m²-Bếp riêng-Phòng tắm riêng trong phòng-Điều hòa không khí-TV màn hình phẳng-Hệ thống cách âm-WiFi miễn phí')

--dvks
INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES  
(20, 6), 
(20, 3), 
(20, 11), 
(20, 8), 
(20, 15)

-------------21--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (2, N'Cochin Sang Hotel', 4, 8.6, 445, 'KS',
N'28-30 Nguyen An Ninh, Quận 1, TP. Hồ Chí Minh, Việt Nam', 
N'Tọa lạc tại vị trí chiến lược ở Quận 1 thuộc Thành phố Hồ Chí Minh, Cochin Sang Hotel nằm trong bán kính chỉ 1 km đến hầu hết các điểm tham quan chính, bao gồm Chợ Bến Thành, Bảo tàng Mỹ Thuật, trung tâm thương mại Takashimaya Việt Nam, Bưu điện Trung tâm Sài Gòn và Dinh Thống Nhất.',
'https://cf.bstatic.com/xdata/images/hotel/max1024x768/370944871.jpg?k=da11bc7bf6989bf2b688ddae7341d32406e4cc0f1caf77cff9776be79add9002&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(21, N'Phòng Vienot Giường Đôi, Không Có Cửa Sổ', N'1 giường đôi lớn', 2, 1580000, 1,
N'20 m²-Hồ bơi trên sân thượng-Điều hòa không khí-Phòng tắm riêng trong phòng-TV màn hình phẳng-Phòng xông hơi-Minibar-WiFi miễn phí')

--dvks
INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES  
(21, 9), 
(21, 6), 
(21, 3), 
(21, 11), 
(21, 8), 
(21, 15),
(21, 10)


---DN
-------------22--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (3, N'Sofiana My Khe Hotel & Spa', 4, 9.2, 1101, 'KS',
N'54-56 Tran Bach Dang , Đà Nẵng, Việt Nam', 
N'Nằm tại thành phố Đà Nẵng, cách Bãi biển Mỹ Khê 150 m, Sofiana My Khe Hotel & Spa có hồ bơi ngoài trời, quán bar và tầm nhìn ra biển. Các tiện nghi của chỗ nghỉ bao gồm nhà hàng, dịch vụ lễ tân 24 giờ, dịch vụ phòng và WiFi miễn phí. Khách sạn cung cấp phòng gia đình.',
'https://cf.bstatic.com/xdata/images/hotel/max1024x768/227549266.jpg?k=4630fc0751afd105d277bd6f916222350d7cef916a001a4e0f6fa90fdee4389c&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(22, N'Phòng Deluxe Giường Đôi Nhìn Ra Thành Phố', N'1 giường đôi lớn', 2, 770000, 5,
N'25 m²-Nhìn ra thành phố-Hồ bơi trên sân thượng-Điều hòa không khí-Phòng tắm riêng trong phòng-TV màn hình phẳng-Minibar')

--dvks
INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES  
(22, 9), 
(22, 6), 
(22, 3), 
(22, 11), 
(22, 8), 
(22, 15),
(22, 2)


-------------23--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (3, N'M92 Boutique Da Nang Beach Hotel', 4, 9.4, 128, 'KS',
N'01 Nguyen Cao Luyen, Đà Nẵng, Việt Nam', 
N'Tọa lạc tại thành phố Đà Nẵng, cách Bãi biển Mỹ Khê 500 m, M92 Boutique Da Nang Beach Hotel có dịch vụ nhận phòng/trả phòng cấp tốc, phòng nghỉ không gây dị ứng, nhà hàng, WiFi miễn phí trong toàn bộ khuôn viên và hồ bơi ngoài trời. ',
'https://cf.bstatic.com/xdata/images/hotel/max1024x768/344692963.jpg?k=a0f76f1838aa069023df97b43c70146442555e7f813ec5cf6f059259817c1d9f&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(23, N'Phòng Deluxe Giường Đôi Có Ban Công', N'1 giường đôi cực lớn', 2, 560000, 4,
N'30 m²-Ban công-Nhìn ra thành phố-Điều hòa không khí-Phòng tắm riêng-TV màn hình phẳng-Hệ thống cách âm-Tiện nghi BBQ-Sân hiên-Minibar-WiFi miễn phí'),

(23, N'Suite Gia Đình Có Ban Công', N'2 giường đôi', 4, 774000, 1,
N'33 m²-Ban công-Nhìn ra thành phố-Điều hòa không khí-Phòng tắm riêng-TV màn hình phẳng-Hệ thống cách âm-Tiện nghi BBQ-Sân hiên-Minibar-WiFi miễn phí')


--dvks
INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES  
(23, 9), 
(23, 6), 
(23, 3), 
(23, 11), 
(23, 8), 
(23, 1), 
(23, 15),
(23, 10),
(23, 2)


-------------24--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (3, N'Hotel Del Luna', 4, 9.0, 220, 'KS',
N'138 Ho Nghinh, Đà Nẵng, Việt Nam', 
N'Tọa lạc tại thành phố Đà Nẵng, cách Bãi biển Mỹ Khê 500 m, Hotel Del Luna cung cấp chỗ nghỉ với nhà hàng, chỗ đỗ xe riêng miễn phí, quầy bar và sân hiên. Chỗ nghỉ này có bồn nước nóng, dịch vụ cho thuê xe đạp, hồ bơi trong nhà, WiFi miễn phí và lễ tân 24 giờ.',
'https://cf.bstatic.com/xdata/images/hotel/max1024x768/301213976.jpg?k=69a9798273f71bd09abedb3b993ef40bab0ce2a2b45111c88f1980ac019de1f2&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(24, N'Phòng Có Giường Cỡ King Với Ban Công', N'1 giường đôi cực lớn', 2, 540000, 3,
N'25 m²-Ban công-Nhìn ra biển-Nhìn ra thành phố-Điều hòa không khí-Phòng tắm riêng-TV màn hình phẳng-Hệ thống cách âm-Minibar-WiFi miễn phí'),

(24, N'Phòng Deluxe Giường Đôi Có Ban Công', N'1 giường đôi cực lớn', 2, 880000, 3,
N'35 m²-Ban công-Nhìn ra biển-Nhìn ra thành phố-Điều hòa không khí-Phòng tắm riêng-TV màn hình phẳng-Hệ thống cách âm-Minibar-WiFi miễn phí'),

(24, N'Suite Junior Có Ban Công', N'1 giường đôi cực lớn', 2, 920000, 1,
N'35 m²-Ban công-Nhìn ra biển-Nhìn ra thành phố-Điều hòa không khí-Phòng tắm riêng-TV màn hình phẳng-Hệ thống cách âm-Minibar-WiFi miễn phí')

--dvks
INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES  
(24, 9), 
(24, 6), 
(24, 3), 
(24, 8), 
(24, 1), 
(24, 15),
(24, 2)

-------------25--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (3, N'Tan Phuong Nam Hotel & Apartment', 3, 9.0, 111, 'CH',
N'494 Duong 2 Thang 9, Hoa Cuong Nam, Hai Chau, Đà Nẵng, Việt Nam', 
N'Tọa lạc tại thành phố Đà Nẵng, cách Công viên Châu Á 700 m, Tan Phuong Nam Hotel & Apartment cung cấp chỗ nghỉ với nhà hàng, chỗ đỗ xe riêng miễn phí, hồ bơi ngoài trời và quầy bar.',
'https://cf.bstatic.com/xdata/images/hotel/max200/292290057.jpg?k=dde2f5dd6636407735d48b4a3c1050e0a5889ceaa90a687ce4a1bf6edf598c4f&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(25, N'Căn hộ Deluxe', N'1 giường đôi', 2, 590000, 1,
N'32 m²-Bếp riêng-Phòng tắm riêng trong phòng-Nhìn ra địa danh nổi tiếng-Nhìn ra thành phố-Hướng nhìn sân trong-Điều hòa không khí-TV màn hình phẳng-Hệ thống cách âm-Minibar'),

(25, N'Căn Hộ Studio', N'1 giường đôi lớn', 2, 640000, 1,
N'32 m²-Bếp riêng-Phòng tắm riêng trong phòng-Nhìn ra địa danh nổi tiếng-Nhìn ra thành phố-Hướng nhìn sân trong-Điều hòa không khí-TV màn hình phẳng-Hệ thống cách âm-Minibar')
--dvks
INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES  
(25, 9), 
(25, 6), 
(25, 3), 
(25, 8), 
(25, 15),
(25, 2)

-------------26--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (3, N'Vernal Home Boutique Villa', 4, 9.6, 117, 'BT',
N'27 Lưu Quang Thuận, Đà Nẵng, Việt Nam', 
N'Tọa lạc tại thành phố Đà Nẵng, cách Bãi biển Bắc Mỹ An 650 m, Vernal Home Boutique Villa cung cấp chỗ nghỉ với nhà hàng, chỗ đỗ xe riêng miễn phí, quầy bar và khu vườn.',
'https://cf.bstatic.com/xdata/images/hotel/max1024x768/329779924.jpg?k=c0acc5eab408a0c261299cfc7de4c275084e99d69592c93d6107e9b73a32a915&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(26, N'Studio Deluxe Có Giường Cỡ King', N'1 giường đôi cực lớn', 2, 1080000, 1,
N'36 m²-Bếp riêng-Phòng tắm riêng trong phòng-Nhìn ra địa danh nổi tiếng-Nhìn ra thành phố-Hướng nhìn sân trong-Điều hòa không khí-TV màn hình phẳng-Hệ thống cách âm-Minibar')

INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES  
(26, 9), 
(26, 6), 
(26, 3), 
(26, 8), 
(26, 15),
(26, 10),
(26, 2)

-------------27--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (3, N'Davue Hotel', 3, 8.9, 402, 'KS',
N'57-59 Đỗ Bí, phường Mỹ An, quận Ngũ Hành Sơn, Đà Nẵng, Việt Nam', 
N'Tọa lạc tại thành phố Đà Nẵng, cách Bãi biển Mỹ Khê 400 m, Davue Hotel cung cấp chỗ nghỉ bên bờ biển với nhiều tiện nghi như sảnh khách chung.',
'https://cf.bstatic.com/xdata/images/hotel/max200/371542191.jpg?k=9a2098d7a4087c811fc58bba502fd310f5c73e8543c8a56e567fee7efa1e8463&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(27, N'Phòng Superior Giường Đôi', N'1 giường đôi', 2, 350000, 3,
N'23 m²-Điều hòa không khí-Phòng tắm riêng trong phòng-TV màn hình phẳng-Hệ thống cách âm-Minibar-WiFi miễn phí'),

(27, N'Phòng Gia Đình', N'2 giường đôi', 4, 650000, 1,
N'27 m²-Điều hòa không khí-Phòng tắm riêng trong phòng-TV màn hình phẳng-Hệ thống cách âm-Minibar-WiFi miễn phí')

INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES  
(27, 6), 
(27, 3), 
(27, 8), 
(27, 15),
(27, 7)

-------------28--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (3, N'Mangala Zen Garden & Luxury Apartments', 5, 8.7, 108, 'BT',
N'J.02 The Ocean Villas, Truong Sa Road, Ward Ngu Hanh Son, Da Nang, Đà Nẵng, Việt Nam', 
N'Tọa lạc trong khu phức hợp CLB chơi golf Đà Nẵng thuộc thành phố ven biển Đà Nẵng, Mangala Zen Garden & Luxury Apartments có 2 hồ bơi ngoài trời và 2 nhà hàng phục vụ chế độ ăn ayurvedic (ăn kiêng theo kiểu Ấn Độ) cũng như một loạt món ăn Á-Âu. ',
'https://cf.bstatic.com/xdata/images/hotel/max1024x768/112527624.jpg?k=2e292152ad3655bef7f2561ead3bcfb08318064982eb29b462a3149261d1a99e&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(28, N'Căn hộ 2 Phòng ngủ có Sân hiên', N'2 giường đôi cực lớn', 4, 5130000, 1,
N'110 m²-Bếp riêng-Phòng tắm riêng trong phòng-Ban công-Nhìn ra vườn-Nhìn ra hồ bơi-Hồ bơi có tầm nhìn-Điều hòa không khí-TV màn hình phẳng-Hệ thống cách âm-Tiện nghi BBQ-Sân hiên-Minibar-WiFi miễn phí')


INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES  
(28, 9), 
(28, 6), 
(28, 3), 
(28, 11), 
(28, 8), 
(28, 1), 
(28, 15),
(28, 10),
(28, 2)

---TH
-------------29--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (4, N'Melia Vinpearl Thanh Hoa', 5, 8.7, 318, 'KS',
N'27 Tran Phu Street, Dien Bien Ward, Thanh Hóa, Việt Nam', 
N'Melia Vinpearl Thanh Hoa tọa lạc tại thành phố Thanh Hóa thuộc tỉnh Thanh Hóa, cách trung tâm thành phố 600 m và Tinh Xa 1,6 km. Trong số các tiện nghi của chỗ nghỉ này có quầy bar, nhà hàng, lễ tân 24 giờ, dịch vụ phòng và WiFi miễn phí. Du khách có thể sử dụng hồ bơi trong nhà và trung tâm thể dục hoặc ngắm cảnh thành phố.',
'https://cf.bstatic.com/xdata/images/hotel/max1024x768/196761440.jpg?k=9c0ec227c8f3d73ec9a8b4a3f8ddf9ec70d13e182fa7835bffc4cd64e98174c3&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(29, N'Phòng Deluxe', N'1 giường đôi', 2, 1590000, 5,
N'32 m²-Nhìn ra thành phố-Bồn tắm-Điều hòa không khí-Phòng tắm riêng-TV màn hình phẳng-Hệ thống cách âm-Minibar'),

(29, N'Phòng Suite', N'1 giường đôi lớn', 2, 2560000, 2,
N'39 m²-Nhìn ra thành phố-Bồn tắm-Điều hòa không khí-Phòng tắm riêng-TV màn hình phẳng-Hệ thống cách âm-Minibar'),

(29, N'Suite Hạng Tổng Thống', N'2 giường đôi cực lớn', 4, 10810000, 1,
N'70 m²-Nhìn ra thành phố-Bồn tắm-Điều hòa không khí-Phòng tắm riêng-TV màn hình phẳng-Hệ thống cách âm-Minibar')


INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES  
(29, 9), 
(29, 6), 
(29, 3), 
(29, 11), 
(29, 8), 
(29, 1), 
(29, 15),
(29, 10),
(29, 2)

-------------30--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (4, N'The Marron Hotel', 3, 7.2, 31, 'KS',
N'117 Hồ Xuân Hương Phường Trung Sơn, Thành Phố Sầm Sơn, Thanh Hóa, Việt Nam', 
N'Tọa lạc ở tỉnh Thanh Hóa, The Marron Hotel có nhà hàng, hồ bơi ngoài trời, quán bar và sảnh khách chung. Chỗ nghỉ này có các phòng gia đình và sân hiên. Chỗ nghỉ cung cấp dịch vụ lễ tân 24 giờ, dịch vụ đưa đón sân bay, dịch vụ phòng và WiFi miễn phí.',
'https://cf.bstatic.com/xdata/images/hotel/max1024x768/205049415.jpg?k=6dad04194f175370f1b7d160eabaece92b359f12ea9a128356d5f1269156ee3c&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(30, N'Phòng Deluxe', N'1 giường đôi', 2, 675000, 6,
N'32 m²-Nhìn ra thành phố-Hồ bơi trên sân thượng-Bồn tắm-Điều hòa không khí-Phòng tắm riêng-TV màn hình phẳng-Hệ thống cách âm-Minibar')

INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES  
(30, 9), 
(30, 6), 
(30, 3), 
(30, 2)

-------------31--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (4, N'Dai Viet Hotel', 3, 8.5, 276, 'KS',
N'19 Phan Chu Trinh, Dien Bien Ward, Thanh Hoa, , Thanh Hóa, Việt Nam', 
N'Tọa lạc ở thành phố Thanh Hóa, Dai Viet Hotel có nhà hàng, trung tâm thể dục, sảnh khách chung và vườn. Chỗ nghỉ này có các phòng gia đình và sân hiên tắm nắng. Chỗ nghỉ cung cấp dịch vụ lễ tân 24 giờ, dịch vụ phòng và dịch vụ thu đổi ngoại tệ cho khách.',
'https://cf.bstatic.com/xdata/images/hotel/max1024x768/187883311.jpg?k=51ea9510f5cb6e6639dee14a57a13208d82af378446f5fbc50e47f9933ed9d8c&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(31, N'Phòng Superior Giường Đôi', N'1 giường đôi', 2, 615000, 5,
N'38 m²-Nhìn ra núi-Nhìn ra địa danh nổi tiếng-Nhìn ra thành phố-Điều hòa không khí-Phòng tắm riêng trong phòng-TV màn hình phẳng-Hệ thống cách âm-Minibar-WiFi miễn phí'),

(31, N'Phòng Deluxe Giường Đôi', N'1 giường đôi', 2, 990000, 2,
N'40 m²-Nhìn ra núi-Nhìn ra địa danh nổi tiếng-Nhìn ra thành phố-Điều hòa không khí-Phòng tắm riêng trong phòng-TV màn hình phẳng-Hệ thống cách âm-Minibar-WiFi miễn phí')


INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES  
(31, 6), 
(31, 3), 
(31, 2)

-------------32--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (4, N'Dragon Sea Hotel', 4, 7.9, 18, 'KS',
N'43 Ho Xuan Huong Street, Sầm Sơn, Việt Nam', 
N'Tọa lạc tại thành phố Sầm Sơn, cách Bãi biển Sầm Sơn vài bước chân, Dragon Sea Hotel cung cấp chỗ nghỉ với nhà hàng, chỗ đỗ xe riêng miễn phí, hồ bơi ngoài trời và quầy bar. ',
'https://cf.bstatic.com/xdata/images/hotel/max1024x768/158845961.jpg?k=df9a61a8a960185e4b39994a601d1bd5df64f7acd3418779bb9395075a4b5a1c&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(32, N'Phòng Deluxe 2 Giường đơn Nhìn ra cảnh Biển', N'2 giường đơn', 2, 1610000, 3,
N'35 m²-Nhìn ra biển-Nhìn ra thành phố-Điều hòa không khí-TV màn hình phẳng-Hệ thống cách âm-Minibar-WiFi miễn phí'),

(32, N'Phòng dạng Studio Giường Đôi Nhìn ra Biển', N'1 giường đôi lớn', 2, 1980000, 2,
N'40 m²-Nhìn ra biển-Nhìn ra thành phố-Điều hòa không khí-TV màn hình phẳng-Hệ thống cách âm-Minibar-WiFi miễn phí'),

(32, N'Suite Senior', N'1 giường đôi cực lớn', 2, 2340000, 1,
N'40 m²-Nhìn ra biển-Nhìn ra thành phố-Điều hòa không khí-TV màn hình phẳng-Hệ thống cách âm-Minibar-WiFi miễn phí')

INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES  
(32, 9), 
(32, 6), 
(32, 3), 
(32, 2)

---HUE
-------------33--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (5, N'The Scarlett Boutique Hotel', 3, 9.3, 516, 'KS',
N'17/1 Ben Nghe Street, Hue, Huế, Việt Nam', 
N'The Scarlett Boutique Hotel cung cấp chỗ nghỉ 3 sao tại thành phố Huế, cách Bảo tàng Cổ vật Cung đình Huế 2,3 km và Chợ Đông Ba 2,3 km. Trong số các tiện nghi của khách sạn này có nhà hàng, lễ tân 24 giờ, dịch vụ phòng và WiFi miễn phí. Chỗ nghỉ không gây dị ứng và nằm trong bán kính 2 km từ Cầu Tràng Tiền.',
'https://cf.bstatic.com/xdata/images/hotel/max1024x768/80608490.jpg?k=de41a6f10867db630bcbf6c969770833957a35c62476109f81945ce82b9e6d39&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(33, N'Phòng Passion', N'1 giường đôi lớn', 2, 720000, 5,
N'20 m²-Điều hòa không khí-Phòng tắm riêng-TV màn hình phẳng-Hệ thống cách âm-Minibar-WiFi miễn phí'),

(33, N'Phòng Rhett', N'1 giường đôi lớn', 2, 905000, 2,
N'25 m²-Điều hòa không khí-Phòng tắm riêng-TV màn hình phẳng-Hệ thống cách âm-Minibar-WiFi miễn phí'),

(33, N'Suite Scarlett', N'1 giường đôi cực lớn', 2, 1100000, 1,
N'30 m²-Điều hòa không khí-Phòng tắm riêng-TV màn hình phẳng-Hệ thống cách âm-Minibar-WiFi miễn phí')

INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES  
(33, 6), 
(33, 3), 
(33, 5), 
(33, 10),
(33, 14)

-------------34--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (5, N'Full House Homestay', 1, 9.6, 26, 'HS',
N'43/4 kiet 42 Nguyễn Công Trứ,phường Phú hội, Huế, Việt Nam ', 
N'Full House Homestay has city views, free WiFi and free private parking, situated in Hue, 1.3 km from Trang Tien Bridge.',
'https://cf.bstatic.com/xdata/images/hotel/max1024x768/398885667.jpg?k=907c122e0bcc30f0ccb5c420200885b34e40255d94ec14ec80708e3d01b4483a&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(34, N'Phòng Có Giường Cỡ King Với Ban Công', N'1 giường đôi', 2, 350000, 2,
N'25 m²-Ban công-Nhìn ra thành phố-Điều hòa không khí-Phòng tắm riêng-TV màn hình phẳng-Sân hiên')


INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES  
(34, 6), 
(34, 3), 
(34, 5), 
(34, 10),
(34, 14)

-------------35--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (5, N'Hue Nino Hotel', 3, 9.0, 825, 'KS',
N'14 Nguyen Cong Tru Street, Huế, Việt Nam', 
N'Hue Nino Hotel nằm ở Trung tâm Thành phố Huế, có kết nối dễ dàng tới các khu vực mua sắm và giải trí. Chỗ ở này có nhà hàng, lễ tân 24 giờ và các phòng được trang trí theo phong cách truyền thống của Huế.',
'https://cf.bstatic.com/xdata/images/hotel/max1024x768/175580863.jpg?k=97d9e9b045e24ddb5f15db05eca2ec32bb07b4d8e941e251b874dbe400df02c0&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(35, N'Phòng Tiêu Chuẩn Giường Đôi', N'1 giường đôi', 2, 340000, 4,
N'20 m²-Nhìn ra thành phố-Điều hòa không khí-Phòng tắm riêng trong phòng-TV màn hình phẳng-Hệ thống cách âm-Minibar-WiFi miễn phí'),

(35, N'Phòng Deluxe', N'1 giường đôi', 2, 480000, 3,
N'25 m²-Nhìn ra thành phố-Điều hòa không khí-Phòng tắm riêng trong phòng-TV màn hình phẳng-Hệ thống cách âm-Minibar-WiFi miễn phí'),


(35, N'Phòng Deluxe Gia đình', N'2 giường đôi', 4, 700000, 1,
N'35 m²-Nhìn ra thành phố-Điều hòa không khí-Phòng tắm riêng trong phòng-TV màn hình phẳng-Hệ thống cách âm-Minibar-WiFi miễn phí')


INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES  
(35, 6), 
(35, 3), 
(35, 5), 
(35, 10),
(35, 14)


---HP
-------------36--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (6, N'Manoir Des Arts Hotel', 4, 8.6, 174, 'KS',
N'64 Dien Bien Phu street, Hong Bang district, Thành phố Hải Phòng, Việt Nam', 
N'Tọa lạc tại thành phố Hải Phòng, cách Nhà Hát Lớn 600 m, Manoir Des Arts Hotel cung cấp chỗ nghỉ với nhà hàng, chỗ đỗ xe riêng miễn phí, hồ bơi ngoài trời và quầy bar. Nằm trong bán kính 1,2 km từ trung tâm thương mại Vincom Plaza Hạ Long và 43 km từ Cảng Tuần Châu, chỗ nghỉ này có khu vườn cũng như sân hiên.',
'https://cf.bstatic.com/xdata/images/hotel/max1024x768/149984904.jpg?k=aacca58561574298f8bc1320fbe8a2b5e9dd5a27efb17e59ed1f139c164e8bab&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(36, N'Phòng Deluxe Giường Đôi', N'1 giường đôi', 2, 1340000, 4,
N'24 m²-Nhìn ra thành phố-Điều hòa không khí-Phòng tắm riêng trong phòng-TV màn hình phẳng-Hệ thống cách âm-Minibar')

INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES  
(36, 9), 
(36, 6), 
(36, 3), 
(36, 5), 
(36, 10),
(36, 2)

-------------37--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (6, N'Novatel Hotel & Apartment', 3, 8.9, 134, 'CH',
N'Thế Thiện 135, Thành phố Hải Phòng, Việt Nam', 
N'Nằm cách trung tâm mua sắm Vincom Plaza Ngô Quyền 3,3 km, Novatel Hotel & Apartment có chỗ nghỉ với xe đạp cho khách sử dụng miễn phí, sòng bạc và lễ tân 24 giờ để tạo thuận tiện cho du khách. Khách sạn căn hộ này cung cấp miễn phí cả WiFi lẫn chỗ đỗ xe riêng.',
'https://cf.bstatic.com/xdata/images/hotel/max1024x768/399706384.jpg?k=8626d4e4dfb9f50d8bd9436abf1f0eb3d00ca1db4ef63e86cad35c4f8b8eada2&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(37, N'Căn Hộ 1 Phòng Ngủ', N'1 giường đôi', 2, 570000, 1,
N'20 m²-Điều hòa không khí-Phòng tắm riêng-TV màn hình phẳng-Minibar-WiFi miễn phí')

INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES  
(37, 9), 
(37, 6), 
(37, 3), 
(37, 5)

-------------38--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (6, N'SEOUL 2 Apartment & Hotel', 4, 7.5, 13, 'KS',
N'76 Tùng Dinh, Cát Bà , Cát Hải, Hải Phòng., Đảo Cát Bà, Việt Nam', 
N'Set in Cat Ba and with Tung Thu Beach reachable within 200 metres, SEOUL 2 Apartment & Hotel offers express check-in and check-out, allergy-free rooms, a restaurant, free WiFi and a shared lounge. ',
'https://cf.bstatic.com/xdata/images/hotel/max1280x900/384257829.jpg?k=d792b210671475e5cdc77bbb4623efc66c28d6f92b8bc98240a2cbed624ddcef&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(38, N'Studio Có Ban Công', N'1 giường đôi', 2, 720000, 2,
N'30 m²-Ban công-Nhìn ra biển-Nhìn ra hồ-Nhìn ra nú-iNhìn ra thành phố-Điều hòa không khí-Sân trong-Phòng tắm riêng-TV màn hình phẳng-Hệ thống cách âm-Tiện nghi BBQ-Sân hiên-WiFi miễn phí')

INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES  
(38, 9), 
(38, 6), 
(38, 3), 
(38, 2), 
(38, 5)

---HL
-------------39--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (7, N'Paradise Suites Hotel', 4, 8.7, 212, 'KS',
N'Tuan Chau, Hạ Long, Việt Nam', 
N'Paradise Suites Hotel cung cấp chỗ nghỉ với các tiện nghi hiện đại trên Đảo Tuần Châu xinh đẹp, cách Bến thuyền Tuần Châu, cửa ngõ Vịnh Hạ Long, một quãng ngắn. ',
'https://cf.bstatic.com/xdata/images/hotel/max1024x768/158600286.jpg?k=d0615a0769f21b43d42be25eda6311d7c972dd95fd0cb5dcdd0816f75b49e5bd&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(39, N'Suite Cổ Điển', N'1 giường đôi', 2, 1211000, 1,
N'32 m²-Nhìn ra thành phố-Điều hòa không khí-Phòng tắm riêng-TV màn hình phẳng-Minibar')

INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES  
(39, 9), 
(39, 6), 
(39, 3), 
(39, 2), 
(39, 2), 
(39, 5)

-------------40--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (7, N'Citadines Marina Halong', 5, 8.7, 118, 'KS',
N'Peninsula 3, Marina Ha Long, Hoang Quoc Viet Street,, Hạ Long, Việt Nam', 
N'Nằm ở thành phố Hạ Long, Citadines Marina Halong có nhà hàng, xe đạp cho khách sử dụng miễn phí, hồ bơi ngoài trời và trung tâm thể dục. Khách sạn 5 sao này cung cấp dịch vụ lễ tân 24 giờ, dịch vụ phòng và WiFi miễn phí. Khách sạn có hồ bơi trong nhà và CLB trẻ em.',
'https://cf.bstatic.com/xdata/images/hotel/max1024x768/382785598.jpg?k=936ef9ec30fcb8f45bb8ce8fb4447ed7fd7e4fbc774eb2541ab629f2c2a04229&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(40, N'Phòng Giường Đôi Có Ban Công', N'1 giường đôi lớn', 2, 1430000, 5,
N'24 m²-Ban công-Nhìn ra vườn-Nhìn ra thành phố-Hồ bơi trên sân thượng-Điều hòa không khí-Phòng tắm riêng trong phòng-TV màn hình phẳng-Minibar-WiFi miễn phí'),

(40, N'Studio Deluxe Có Giường Cỡ King', N'1 giường đôi lớn', 2, 1560000, 3,
N'31 m²-Ban công-Nhìn ra vườn-Nhìn ra thành phố-Hồ bơi trên sân thượng-Điều hòa không khí-Phòng tắm riêng trong phòng-TV màn hình phẳng-Minibar-WiFi miễn phí'),

(40, N'Căn Hộ 1 Phòng Ngủ', N'1 giường đôi lớn', 2, 1970000,1,
N'52 m²-Ban công-Nhìn ra vườn-Nhìn ra thành phố-Hồ bơi trên sân thượng-Điều hòa không khí-Phòng tắm riêng trong phòng-TV màn hình phẳng-Minibar-WiFi miễn phí')

INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES  
(40, 9), 
(40, 6), 
(40, 3), 
(40, 2), 
(40, 2), 
(40, 5)

-------------41--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (7, N'Halong Lotus Cruise', 4, 8.3, 9, 'KS',
N'Bên cảng Tuần Châu, Hạ Long, Việt Nam', 
N'Located in Ha Long, 300 metres from Tuan Chau Beach and 600 metres from Bikini Island Beach, Halong Lotus Cruise provides accommodation with free WiFi, air conditioning, a restaurant and a bar.',
'https://cf.bstatic.com/xdata/images/hotel/max1024x768/393677973.jpg?k=64bada8c7a56bbe39addc3bf6417fdee180565ba497fb6451ed88f997c8228fc&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(41, N'Phòng Deluxe Giường Đôi Nhìn Ra Biển', N'1 giường đôi lớn', 2, 4930000, 2,
N'25 m²-Nhìn ra biển-Điều hòa không khí-Phòng tắm riêng'),

(41, N'Phòng Suite Junior Có Sân Hiên', N'1 giường đôi lớn', 2, 7530000, 1,
N'25 m²-Nhìn ra biển-Điều hòa không khí-Phòng tắm riêng-Sân hiên')

INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES  
(41, 6), 
(41, 3), 
(41, 2), 
(41, 2), 
(41, 5)

-------------42--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (7, N'Bãi Cháy Panda Hotel', 3, 8.9, 22, 'KS',
N'62 Anh Đào tổ 8, khu 2, phường Bãi Cháy, Hạ Long, Việt Nam', 
N'Tọa lạc tại vị trí đắc địa ở phường Bãi Cháy thuộc thành phố Hạ Long, Bãi Cháy Panda Hotel nằm cách Cáp treo Nữ hoàng 400 m, trung tâm thương mại Vincom Plaza Hạ Long 3,6 km và Bảo tàng Quảng Ninh 5 km. ',
'https://cf.bstatic.com/xdata/images/hotel/max1024x768/400488394.jpg?k=435089f98efd99034b0b435fa9913f675168111d746e89552bfd1b912958110f&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(42, N'Phòng Deluxe Gia đình', N'2 giường đôi lớn', 4, 1088000, 2,
N'33 m²-Nhìn ra vườn-Hướng nhìn sân trong-Điều hòa không khí-Sân trong-Phòng tắm riêng trong phòng-TV màn hình phẳng-Hệ thống cách âm-Minibar-WiFi miễn phí')


INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES  
(42, 6), 
(42, 3), 
(42, 2), 
(42, 2), 
(42, 5)


---NT
-------------43--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (8, N'DTX Hotel Nha Trang', 4, 9.1, 997, 'KS',
N' Quân Trấn 3A Quân Trấn, đường Hùng Vương, Nha Trang, Việt Nam', 
N'Tọa lạc tại thành phố Nha Trang, cách Bãi biển Nha Trang 300 m, DTX Hotel Nha Trang cung cấp chỗ nghỉ với nhà hàng, chỗ đỗ xe riêng miễn phí, hồ bơi ngoài trời và trung tâm thể dục. Khách sạn 4 sao này có WiFi miễn phí, quán bar và sảnh khách chung.',
'https://cf.bstatic.com/xdata/images/hotel/max1024x768/195732671.jpg?k=cc8dae014999bb941a87ef2d085972d8b54c5a47a20aecafeeb0a875de54235a&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(43, N'Phòng Superior Giường Đôi', N'1 giường đôi', 2, 580000, 4,
N'25 m²-Nhìn ra núi-Nhìn ra thành phố-Hồ bơi trên sân thượng-Điều hòa không khí-Phòng tắm riêng-TV màn hình phẳng-Hệ thống cách âm-Minibar-WiFi miễn phí'),

(43, N'Phòng Deluxe Giường Đôi', N'1 giường đôi', 2, 710000, 2,
N'30 m²-Nhìn ra núi-Nhìn ra thành phố-Hồ bơi trên sân thượng-Điều hòa không khí-Phòng tắm riêng-TV màn hình phẳng-Hệ thống cách âm-Minibar-WiFi miễn phí'),

(43, N'Phòng Deluxe Gia đình', N'2 giường đôi', 4, 1260000, 1,
N'50 m²-Nhìn ra núi-Nhìn ra thành phố-Hồ bơi trên sân thượng-Điều hòa không khí-Phòng tắm riêng-TV màn hình phẳng-Hệ thống cách âm-Minibar-WiFi miễn phí')


INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES  
(43, 9), 
(43, 6), 
(43, 3), 
(43, 5), 
(43, 2), 
(43, 10),
(43, 8)

-------------44--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (8, N'Volga Nha Trang Hotel', 4, 8.6, 260, 'KS',
N'Bãi Dương 6B, Nha Trang, Việt Nam', 
N'Nằm ở thành phố Nha Trang, Volga Nha Trang Hotel có nhà hàng, hồ bơi ngoài trời, quầy bar và sảnh khách chung. Chỗ nghỉ này cũng có dịch vụ phòng và sân hiên tắm nắng. Nơi đây cung cấp dịch vụ lễ tân 24 giờ, bếp chung và dịch vụ thu đổi ngoại tệ cho khách.',
'https://cf.bstatic.com/xdata/images/hotel/max1024x768/372757151.jpg?k=07742b0233f46e1599d8532586790e8f7f99a3a56dfb581571294b36515d64f2&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(44, N'Phòng Superior Có Giường Cỡ King', N'1 giường đôi lớn', 2, 780000, 4,
N'22 m²-Hồ bơi trên sân thượng-Điều hòa không khí-Phòng tắm riêng trong phòng-TV màn hình phẳng-Hệ thống cách âm-Minibar-WiFi miễn phí'),

(44, N'Phòng Deluxe Giường Đôi Với Ban Công và Tầm Nhìn Ra Biển', N'1 giường đôi lớn', 2, 940000, 3,
N'27 m²-Ban công-Hồ bơi trên sân thượng-Điều hòa không khí-Phòng tắm riêng trong phòng-TV màn hình phẳng-Hệ thống cách âm-Minibar-WiFi miễn phí')


INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES  
(44, 9), 
(44, 6), 
(44, 3), 
(44, 5), 
(44, 2), 
(44, 10),
(44, 8)

-------------45--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (8, N'Vinpearl Resort & Spa Nha Trang Bay', 4, 8.5, 229, 'KS',
N'Hon Tre Island, Nha Trang, Việt Nam', 
N'Vinpearl Resort & Spa Nha Trang Bay là resort 5 sao cung cấp phòng nghỉ gắn máy điều hòa rộng rãi với WiFi miễn phí. Nằm trong khu vườn riêng tươi tốt, resort này có hồ bơi vô cực nhìn ra bãi biển, các lựa chọn ăn uống cao cấp cũng như spa.',
'https://cf.bstatic.com/xdata/images/hotel/max1024x768/56426000.jpg?k=7d68f04918ad4854864f38a8f6859dd5dab1e3906628ef8359a68110702f8505&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(45, N'Phòng Deluxe Có Giường Cỡ King', N'1 giường đôi lớn', 2, 2750000, 2,
N'45 m²-Ban côngTầm nhìn ra khung cảnh-Điều hòa không khí-Bồn tắm spa-Phòng tắm riêng-TV màn hình phẳng-Minibar-WiFi miễn phí'),

(45, N'Phòng Deluxe Có Giường Cỡ King Nhìn Ra Biển Với Vé Vào Công Viên VinWonders', N'1 giường đôi lớn', 2, 3610000, 1,
N'45 m²-Ban côngTầm nhìn ra khung cảnh-Điều hòa không khí-Bồn tắm spa-Phòng tắm riêng-TV màn hình phẳng-Minibar-WiFi miễn phí')

INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES  
(45, 9), 
(45, 6), 
(45, 3), 
(45, 5), 
(45, 2), 
(45, 10),
(45, 15),
(45, 8)

---HA
-------------46--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (9, N'Eco Lux Riverside Hotel & Spa', 4, 9.2, 285, 'KS',
N'316 Hung Vuong street, Thanh Ha, Hoian, Thanh Hà, Hội An, Việt Nam', 
N'Nằm ở thành phố Hội An, cách Làng Thanh Hà 700 m, HANZ Eco Lux Riverside Hotel & Spa cung cấp chỗ nghỉ với nhà hàng, chỗ đỗ xe riêng miễn phí, hồ bơi ngoài trời và trung tâm thể dục.',
'https://cf.bstatic.com/xdata/images/hotel/max1024x768/234141857.jpg?k=b3d24e34f9ff8f1e30057fa02196ef36c9b223e91a3361f554377170866701c5&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(46, N'Phòng Superior Giường Đôi', N'1 giường đôi', 2, 690000, 5,
N'28 m²-Nhìn ra vườn-Nhìn ra hồ bơi-Nhìn ra địa danh nổi tiếng-Nhìn ra thành phố-Hồ bơi có tầm nhìn-Hướng nhìn sân trong-Điều hòa không khí-Phòng tắm riêng trong phòng-TV màn hình phẳng-Hệ thống cách âm-Tiện nghi BBQ-Minibar-WiFi miễn phí'),

(46, N'Phòng Executive Có Ban Công Nhìn Ra Sông', N'1 giường đôi', 2, 880000, 2,
N'35 m²-Nhìn ra vườn-Nhìn ra hồ bơi-Nhìn ra địa danh nổi tiếng-Nhìn ra thành phố-Hồ bơi có tầm nhìn-Hướng nhìn sân trong-Điều hòa không khí-Phòng tắm riêng trong phòng-TV màn hình phẳng-Hệ thống cách âm-Tiện nghi BBQ-Minibar-WiFi miễn phí')

INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES  
(46, 9), 
(46, 6), 
(46, 3), 
(46, 5), 
(46, 2), 
(46, 10),
(46, 15),
(46, 8)

---VT
-------------47--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (10, N'3H Grand Hotel', 2, 9.5, 84, 'KS',
N'274 Phan Chu Trinh, Phường 2, Thành Phố Vũng Tàu, Vũng Tàu, Việt Nam', 
N'Tọa lạc tại thành phố Vũng Tàu, cách Bãi Sau 400 m và Bãi Dứa 1,9 km, 3H Grand Hotel cung cấp chỗ nghỉ với sân hiên cũng như chỗ đỗ xe riêng miễn phí. Khách sạn 2 sao này có Wi-Fi miễn phí, lễ tân 24 giờ và bếp chung. Khách sạn cung cấp các phòng gia đình.',
'https://cf.bstatic.com/xdata/images/hotel/max1024x768/395223651.jpg?k=f9a1eda1076c78ad7db309544df729b04cab1308c8f28b65034ef098d9690b50&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(47, N'Phòng Có Giường Cỡ Queen', N'1 giường đôi', 2, 650000, 2,
N'16 m²-Nhìn ra biển-Nhìn ra núi-Nhìn ra thành phố-Điều hòa không khí-TV màn hình phẳng-WiFi miễn phí'),

(47, N'Phòng Gia đình nhìn ra Núi', N'2 giường đôi', 2, 1000000, 1,
N'25 m²-Nhìn ra biển-Nhìn ra núi-Nhìn ra thành phố-Điều hòa không khí-TV màn hình phẳng-WiFi miễn phí')

INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES  
(47, 3), 
(47, 2), 
(47, 15)

---DL
-------------48--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (11, N'Minh Chien Hotel', 3, 8.8, 276, 'KS',
N'31 Thien My, Ward 4, Đà Lạt, Việt Nam', 
N'Tọa lạc tại thành phố Đà Lạt, cách Quảng trường Lâm Viên 2,7 km, Minh Chien Hotel cung cấp chỗ nghỉ với nhà hàng, chỗ đỗ xe riêng miễn phí, quầy bar và sảnh khách chung. ',
'https://cf.bstatic.com/xdata/images/hotel/max200/225373011.jpg?k=12e3e8d3d1330a010cbe82378b5a2552f74ae77a14f67fa0a3c6ac848efdd6e6&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(48, N'Phòng Premium', N'1 giường đôi', 2, 790000, 2,
N'20 m²-Nhìn ra núi-Nhìn ra thành phố-Điều hòa không khí-TV màn hình phẳng-WiFi miễn phí')

INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES  
(48, 6), 
(48, 3), 
(48, 2), 
(48, 10), 
(48, 15)

---PQ
-------------49--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (12, N'AVS Hotel Phu Quoc', 4, 8.9, 142, 'KS',
N'Đường Trần Hưng Đạo, Duong Dong, Phú Quốc, Việt Nam', 
N'Nằm trên đảo Phú Quốc, cách Bãi Dài 200 m, AVS Hotel Phu Quoc cung cấp chỗ nghỉ với nhà hàng, chỗ đỗ xe riêng miễn phí và quán bar. Chỗ nghỉ này có các phòng gia đình và sân hiên tắm nắng. Nơi đây cung cấp dịch vụ lễ tân 24 giờ, dịch vụ phòng và dịch vụ thu đổi ngoại tệ cho khách.',
'https://cf.bstatic.com/xdata/images/hotel/max1024x768/265998280.jpg?k=d36a050eae65a5bd7abb0823d0b559c4a70b6417a866d8eb556331bb85c8325e&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(49, N'Phòng Deluxe Nhìn Ra Thành Phố', N'1 giường đôi lớn', 2, 1420000, 3,
N'33 m²-Nhìn ra vườn-Nhìn ra thành phố-Hồ bơi trên sân thượng-Điều hòa không khí-Phòng tắm riêng trong phòng-TV màn hình phẳng-Hệ thống cách âm-Minibar-WiFi miễn phí'),

(49, N'Phòng Gia Đình Nhìn Ra Thành Phố', N'1 giường đơn  và 1 giường đôi lớn ', 3, 2430000, 1,
N'46 m²-Nhìn ra vườn-Nhìn ra thành phố-Hồ bơi trên sân thượng-Điều hòa không khí-Phòng tắm riêng trong phòng-TV màn hình phẳng-Hệ thống cách âm-Minibar-WiFi miễn phí')

INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES  
(49, 9), 
(49, 6), 
(49, 3), 
(49, 5), 
(49, 2), 
(49, 10),
(49, 15),
(49, 8)

-------------50--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (12, N'Best Western Premier Sonasea Phu Quoc', 5, 8.1, 348, 'KS',
N'Duong Bao, Duong To, Duong To, Phú Quốc, Việt Nam', 
N'Tọa lạc tại đảo Phú Quốc, Best Western Premier Sonasea Phu Quoc có nhà hàng, hồ bơi ngoài trời, trung tâm thể dục và quán bar. Cách 1,3 km từ Bãi Dài, khách sạn còn có khu vườn và sân hiên. Tại đây cũng cung cấp dịch vụ lễ tân 24 giờ, dịch vụ đưa đón sân bay, dịch vụ phòng và WiFi miễn phí trong toàn bộ khuôn viên.',
'https://cf.bstatic.com/xdata/images/hotel/max1024x768/334505420.jpg?k=6e944fd806fb297ec515cb6bfbb55c9594931dd059d81d90eb684507a1cc480e&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(50, N'Phòng Deluxe Có Giường Cỡ King ', N'1 giường đôi cực lớn', 2, 2170000, 5,
N'33 m²-Ban công-Điều hòa không khí-Phòng tắm riêng trong phòng-TV màn hình phẳng-Hệ thống cách âm-Minibar-WiFi miễn phí'),

(50, N'Phòng Premier Có Giường Cỡ King', N'1 giường đôi cực lớn', 2, 2530000, 2, 
N'40 m²-Ban công-Nhìn ra biển-Điều hòa không khí-Phòng tắm riêng trong phòng-TV màn hình phẳng-Hệ thống cách âm-Minibar-WiFi miễn phí'),

(50, N'Phòng Suite Executive 2 Phòng Ngủ Có 2 Giường Cỡ Queen', N'2 giường đôi lớn', 2, 4010000, 1, 
N'60 m²-Ban công-Nhìn ra biển-Điều hòa không khí-Phòng tắm riêng trong phòng-TV màn hình phẳng-Hệ thống cách âm-Minibar-WiFi miễn phí')

INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES  
(50, 9), 
(50, 6), 
(50, 3), 
(50, 5), 
(50, 2), 
(50, 10),
(50, 15),
(50, 8)

---HG
-------------51--------------
--ks
INSERT INTO T_KhachSan(MaDiaDiem, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, MaLoai, DiaChi, MoTa, Anh) 
VALUES (13, N'Lam Giang Homestay Dong Van', 1, 8.9, 66, 'HS',
N'153 Tran Phu, Group 7, Dong Van, Ha Giang, Hà Giang, Việt Nam', 
N'Tọa lạc tại tỉnh Hà Giang, trong một tòa nhà được xây dựng từ năm 2017, Lam Giang Homestay Dong Van có sảnh khách chung và phòng nghỉ với WiFi miễn phí. Chỗ nghỉ này cũng có lễ tân 24 giờ và bếp chung cho khách sử dụng.',
'https://cf.bstatic.com/xdata/images/hotel/max1280x900/400254982.jpg?k=03f15ade93258ea0b222a2de0469142002badcb1c2ea5f0abfd38de7b3c5bf9b&o=&hp=1')

--phong
INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) VALUES 
(51, N'Phòng Tiêu Chuẩn', N'1 giường đôi', 2, 250000, 2,
N'10 m²-Nhìn ra núi-Điều hòa không khí-Phòng tắm riêng-TV màn hình phẳng-Hệ thống cách âm-WiFi miễn phí'),

(51, N'Phòng Deluxe Giường Đôi', N'1 giường đôi', 2, 325000, 1,
N'15 m²-Nhìn ra núi-Điều hòa không khí-Phòng tắm riêng-TV màn hình phẳng-Hệ thống cách âm-WiFi miễn phí')

INSERT INTO T_DSDichVu(MaKhachSan, MaDichVu) VALUES  
(51, 1), 
(51, 14) 


--PHONG KS/////////////////////////////////////////////////////////////////
INSERT INTO T_Phong(MaLoaiPhong, TenPhong) VALUES 
(1, '1-1-001'),
(1, '1-1-002'),
(1, '1-1-003'),
(1, '1-1-004'),
(1, '1-1-005'),
(1, '1-1-006'),
(2, '1-2-001'),
(2, '1-2-002'),
(2, '1-2-003'),
(2, '1-2-004'),
(3, '1-3-001'),
(3, '1-3-002'),
(3, '1-3-003'),
(3, '1-3-004'),
(4, '1-4-001'),
(4, '1-4-002'),
(5, '2-5-001'),
(5, '2-5-002'),
(5, '2-5-003'),
(5, '2-5-004'),
(5, '2-5-005'),
(5, '2-5-006'),
(5, '2-5-007'),
(5, '2-5-008'),
(5, '2-5-009'),
(5, '2-5-0010'),
(5, '2-5-0011'),
(5, '2-5-0012'),
(6, '2-6-001'),
(6, '2-6-002'),
(6, '2-6-003'),
(6, '2-6-004'),
(7, '3-7-001'),
(7, '3-7-002'),
(7, '3-7-003'),
(7, '3-7-004'),
(8, '3-8-001'),
(8, '3-8-002'),
(8, '3-8-003'),
(9, '3-9-001'),
(9, '3-9-002'),
(10, '4-10-001'),
(11, '5-11-001'),
(11, '5-11-002'),
(11, '5-11-003'),
(11, '5-11-004'),
(12, '6-12-001'),
(12, '6-12-002'),
(12, '6-12-003'),
(12, '6-12-004'),
(12, '6-12-005'),
(12, '6-12-006'),
(12, '6-12-007'),
(13, '6-13-001'),
(13, '6-13-002'),
(14, '7-14-001'),
(14, '7-14-002'),
(14, '7-14-003'),
(14, '7-14-004'),
(14, '7-14-005'),
(14, '7-14-006'),
(14, '7-14-007'),
(15, '8-15-001'),
(15, '8-15-002'),
(15, '8-15-003'),
(15, '8-15-004'),
(15, '8-15-005'),
(16, '8-16-001'),
(16, '8-16-002'),
(17, '9-17-001'),
(18, '10-18-001'),
(18, '10-18-002'),
(18, '10-18-003'),
(18, '10-18-004'),
(18, '10-18-005'),
(18, '10-18-006'),
(19, '10-19-001'),
(19, '10-19-002'),
(19, '10-19-003'),
(20, '11-20-001'),
(20, '11-20-002'),
(21, '11-21-001'),
(22, '12-22-001'),
(22, '12-22-002'),
(22, '12-22-003'),
(22, '12-22-004'),
(23, '12-23-001'),
(23, '12-23-002'),
(24, '13-24-001'),
(24, '13-24-002'),
(25, '14-25-001'),
(25, '14-25-002'),
(25, '14-25-003'),
(26, '14-26-001'),
(27, '15-27-001'),
(27, '15-27-002'),
(28, '16-28-001'),
(28, '16-28-002'),
(28, '16-28-003'),
(28, '16-28-004'),
(29, '17-29-001'),
(29, '17-29-002'),
(29, '17-29-003'),
(29, '17-29-004'),
(30, '17-30-001'),
(31, '18-31-001'),
(32, '19-32-001'),
(32, '19-32-002'),
(32, '19-32-003'),
(32, '19-32-004'),
(32, '19-32-005'),
(33, '19-33-001'),
(33, '19-33-002'),
(33, '19-33-003'),
(34, '19-34-001'),
(35, '20-35-001'),
(36, '20-36-001'),
(37, '21-37-001'),
(38, '22-38-001'),
(38, '22-38-002'),
(38, '22-38-003'),
(38, '22-38-004'),
(38, '22-38-005'),
(39, '23-39-001'),
(39, '23-39-002'),
(39, '23-39-003'),
(39, '23-39-004'),
(40, '23-40-001'),
(41, '24-41-001'),
(41, '24-41-002'),
(41, '24-41-003'),
(42, '24-42-001'),
(42, '24-42-002'),
(42, '24-42-003'),
(43, '24-43-001'),
(44, '25-44-001'),
(45, '25-45-001'),
(46, '26-46-001'),
(47, '27-47-001'),
(47, '27-47-002'),
(47, '27-47-003'),
(48, '27-48-001'),
(49, '28-49-001'),
(50, '29-50-001'),
(50, '29-50-002'),
(50, '29-50-003'),
(50, '29-50-004'),
(50, '29-50-005'),
(51, '29-51-001'),
(51, '29-51-002'),
(52, '29-52-001'),
(53, '30-53-001'),
(53, '30-53-002'),
(53, '30-53-003'),
(53, '30-53-004'),
(53, '30-53-005'),
(53, '30-53-006'),
(54, '31-54-001'),
(54, '31-54-002'),
(54, '31-54-003'),
(54, '31-54-004'),
(54, '31-54-005'),
(55, '31-55-001'),
(55, '31-55-002'),
(56, '32-56-001'),
(56, '32-56-002'),
(56, '32-56-003'),
(57, '32-57-001'),
(57, '32-57-002'),
(58, '32-58-001'),
(59, '33-59-001'),
(59, '33-59-002'),
(59, '33-59-003'),
(59, '33-59-004'),
(59, '33-59-005'),
(60, '33-60-001'),
(60, '33-60-002'),
(61, '33-61-001'),
(62, '34-62-001'),
(62, '34-62-002'),
(63, '35-63-001'),
(63, '35-63-002'),
(63, '35-63-003'),
(63, '35-63-004'),
(64, '35-64-001'),
(64, '35-64-002'),
(64, '35-64-003'),
(65, '35-65-001'),
(66, '36-66-001'),
(66, '36-66-002'),
(66, '36-66-003'),
(66, '36-66-004'),
(67, '37-67-001'),
(68, '38-68-001'),
(68, '38-68-002'),
(69, '39-69-002'),
(70, '40-70-001'),
(70, '40-70-002'),
(70, '40-70-003'),
(70, '40-70-004'),
(70, '40-70-005'),
(71, '40-71-001'),
(71, '40-71-002'),
(71, '40-71-003'),
(72, '40-72-001'),
(73, '41-73-001'),
(73, '41-73-002'),
(74, '41-74-001'),
(75, '42-75-001'),
(75, '42-75-002'),
(76, '43-76-001'),
(76, '43-76-002'),
(76, '43-76-003'),
(76, '43-76-004'),
(77, '43-77-001'),
(77, '43-77-002'),
(78, '43-78-001'),
(79, '44-79-001'),
(79, '44-79-002'),
(79, '44-79-003'),
(79, '44-79-004'),
(80, '44-80-001'),
(80, '44-80-002'),
(80, '44-80-003'),
(81, '45-81-001'),
(81, '45-81-002'),
(82, '45-82-001'),
(83, '46-83-001'),
(83, '46-83-002'),
(83, '46-83-003'),
(83, '46-83-004'),
(83, '46-83-005'),
(84, '46-84-001'),
(84, '46-84-002'),
(85, '47-85-001'),
(85, '47-85-002'),
(86, '47-86-001'),
(87, '48-87-001'),
(87, '48-87-002'),
(88, '49-88-001'),
(88, '49-88-002'),
(88, '49-88-003'),
(89, '49-89-001'),
(90, '50-90-001'),
(90, '50-90-002'),
(90, '50-90-003'),
(90, '50-90-004'),
(90, '50-90-005'),
(91, '50-91-001'),
(91, '50-91-002'),
(92, '50-92-001'),
(93, '51-93-001'),
(93, '51-93-002'),
(94, '51-94-001')


--TAI KHOAN/////////////////////////////////////////////////////////
INSERT INTO T_TaiKhoan(TenDangNhap, MatKhau, Email, HoTen, SDT) VALUES
('chang128', '123456', 'chang@mail.com', N'Nguyễn Khắc Cháng', '0938373483'),
('tuan04', '123456', 'tuan@mail.com', N'Lê Anh Tuấn', '0843273388'),
('ngoc66', '123456', 'ngoc@mail.com', N'Mai Hồng Ngọc', '0392228372'),
('viet06', '123456', 'viet@mail.com', N'Lê Tiến Việt', '0398388883'),
('anhduong24', '123456', 'duong@mail.com', N'Nguyễn Ánh Dương', '0969333827'),
('duc33', '123456', 'duc@mail.com', N'Nguyễn Minh Đức', '0864445288'),
('toan38', '123456', 'toan@mail.com', N'Nguyễn Đăng Toàn', '0944000382'),
('trang87', '123456', 'trang@mail.com', N'Trần Thị Minh Trang', '0937303998'),
('huong56', '123456', 'huong@mail.com', N'Đào Mai Hương', '0366727882'),
('dat09', '123456', 'dat@mail.com', N'Hoàng Thành Đạt', '0903828737'),
('long25', '123456', 'long@mail.com', N'Bùi Quang Long', '0853883729')


