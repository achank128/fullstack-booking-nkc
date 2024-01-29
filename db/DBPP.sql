USE BookingManagement
GO

----TRUY VẤN
--SELECT MaKhachSan, TenKhachSan, ChatLuong, DanhGia, SoDanhGia, DiaChi, 
--T_KhachSan.Anh AS Anh, MaLoai, MoTa, T_KhachSan.MaDiaDiem AS MaDiaDiem
--FROM T_KhachSan, T_DiaDiem 
--WHERE T_KhachSan.MaDiaDiem = T_DiaDiem.MaDiaDiem 
--AND (TenKhachSan LIKE N'%Nha trang%'
--OR TenDiaDiem LIKE N'%Nha trang')

--SELECT T_DichVu.MaDichVu AS MaDichVu, TenDichVu 
--FROM T_DichVu, T_DSDichVu 
--WHERE T_DichVu.MaDichVu = T_DSDichVu.MaDichVu 
--AND MaKhachSan = 33
--GO

--VIEW
--Xem loai phong
CREATE or ALTER VIEW V_LoaiPhongKS AS
SELECT T_LoaiPhong.MaLoaiPhong AS MaLoaiPhong, 
T_KhachSan.MaKhachSan AS MaKhachSan, 
TenKhachSan, ChatLuong, DanhGia, SoDanhGia, DiaChi, Anh, 
TenLoaiPhong, T_LoaiPhong.MoTa AS MoTa,
SoGiuong, SoNguoi, SoPhong, GiaPhong
FROM T_LoaiPhong, T_KhachSan 
WHERE T_LoaiPhong.MaKhachSan = T_KhachSan.MaKhachSan
GO
--SELECT * FROM V_LoaiPhongKS WHERE MaLoaiPhong=7
--GO

--Xem don dat phong
CREATE or ALTER VIEW V_DonDatPhongKS AS
SELECT MaDat, T_TaiKhoan.MaTaiKhoan AS MaTaiKhoan, 
NgayCheckin, NgayCheckout, NgayDat, GhiChu,
DATEDIFF(DAY, NgayCheckin, NgayCheckout) AS SoDem, TongTien,
T_Phong.MaPhong AS MaPhong, TenPhong, 
T_LoaiPhong.MaLoaiPhong AS MaLoaiPhong, 
TenLoaiPhong, T_LoaiPhong.MoTa AS MoTa, SoGiuong, SoNguoi, SoPhong, GiaPhong,
T_KhachSan.MaKhachSan AS MaKhachSan,
TenKhachSan, ChatLuong, DanhGia, SoDanhGia, DiaChi, Anh,
Email, HoTen, SDT
FROM T_DonDatPhong, T_Phong, T_LoaiPhong, T_KhachSan, T_TaiKhoan 
WHERE T_DonDatPhong.MaPhong = T_Phong.MaPhong
AND T_Phong.MaLoaiPhong = T_LoaiPhong.MaLoaiPhong
AND T_LoaiPhong.MaKhachSan = T_KhachSan.MaKhachSan
AND T_TaiKhoan.MaTaiKhoan = T_DonDatPhong.MaTaiKhoan
GO
--SELECT * FROM V_DonDatPhongKS WHERE MaTaiKhoan=1 ORDER BY MaDat DESC
--GO

--STORE PRODUCE
--Lấy danh sách phòng trống theo từng loại phòng trong khoảng ngày checkin -> ngày checkout
CREATE or ALTER PROCEDURE S_PhongTrong (@maLoai int, @checkin date, @checkout date)
AS
BEGIN
	SELECT * FROM T_Phong 
	WHERE MaLoaiPhong = @maLoai AND MaPhong NOT IN 
	(SELECT T_Phong.MaPhong FROM T_DonDatPhong, T_Phong
	WHERE T_Phong.MaPhong = T_DonDatPhong.MaPhong AND
	(@checkin BETWEEN NgayCheckin AND NgayCheckout 
	OR @checkout BETWEEN NgayCheckin AND NgayCheckout))
END
--EXECUTE S_PhongTrong @maLoai=22, @checkin='03-24-2023', @checkout='03-26-2023'
--GO


--Lấy danh dách phòng đã được đặt trong khoảng ngày checkin -> ngày checkout
CREATE or ALTER PROCEDURE S_PhongDaDat (@checkin date, @checkout date) 
AS 
	SELECT * FROM T_Phong WHERE MaPhong IN 
	(SELECT MaPhong FROM T_DonDatPhong
	WHERE @checkin BETWEEN NgayCheckin AND NgayCheckout 
	OR @checkout BETWEEN NgayCheckin AND NgayCheckout) 
GO
--EXECUTE S_PhongDaDat @checkin='03-24-2023', @checkout='03-27-2023'
--GO

CREATE or ALTER PROCEDURE S_DatPhong (@maLoai int, @maTaiKhoan int, @checkin date, @checkout date)
AS
BEGIN
	DECLARE @maPhong int

	SELECT TOP 1 @maPhong = MaPhong FROM T_Phong 
	WHERE MaLoaiPhong = @maLoai AND MaPhong NOT IN 
	(SELECT T_Phong.MaPhong FROM T_DonDatPhong, T_Phong
	WHERE T_Phong.MaPhong = T_DonDatPhong.MaPhong AND
	(@checkin BETWEEN NgayCheckin AND NgayCheckout 
	OR @checkout BETWEEN NgayCheckin AND NgayCheckout))

	INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) 
	VALUES (@maPhong, @maTaiKhoan, @checkin, @checkout)
END
--EXECUTE S_DatPhong @maLoai=22, @maTaiKhoan=4, @checkin='12-24-2022', @checkout='12-26-2022'
--GO

--TRIGGER
-- Khi thêm loại phòng tự động thêm phòng theo đúng số lượng phòng 
CREATE or ALTER TRIGGER TG_ThemPhong ON T_LoaiPhong 
AFTER INSERT AS
BEGIN
	DECLARE @maLoaiPhong int
	DECLARE @soPhong int
	DECLARE @maKhachSan int
	SELECT 
	@maLoaiPhong = MaLoaiPhong, 
	@soPhong = SoPhong, 
	@maKhachSan = MaKhachSan FROM inserted
	--Insert du lieu vao bang T_Phong
	DECLARE @i INT = 0;
	WHILE @i < @soPhong 
		BEGIN 
			INSERT INTO T_Phong(MaLoaiPhong, TenPhong) VALUES 
			(@maLoaiPhong, CONVERT(varchar, @maKhachSan) + 
			'-' + CONVERT(varchar, @maLoaiPhong) + 
			'-00' + CONVERT(varchar, @i + 1))
			SET @i = @i + 1;
		END;
END
GO
--INSERT INTO T_LoaiPhong(MaKhachSan, TenLoaiPhong, SoGiuong, SoNguoi, GiaPhong, SoPhong, MoTa) 
--VALUES (51, N'Test insert Loai phong', N'1 giường đôi', 2, 1210000, 3, N'22 m²')
--SELECT * FROM T_Phong WHERE MaLoaiPhong = 95
--GO

--Kiểm tra phòng đã được đặt hay chưa, nếu đã đặt thì hủy đặt phòng
GO
CREATE or ALTER TRIGGER TG_DatPhong ON T_DonDatPhong 
INSTEAD OF INSERT AS
BEGIN
	DECLARE @maPhong int
	DECLARE @maTaiKhoan int
	DECLARE @checkin date
	DECLARE @checkout date
	DECLARE @sodem int
	DECLARE @tong money
	SELECT 
	@maPhong = MaPhong, 
	@maTaiKhoan = MaTaiKhoan, 
	@checkin = NgayCheckin, 
	@checkout = NgayCheckout 
	FROM inserted
	IF(@maPhong IN (SELECT T_DonDatPhong.MaPhong FROM T_DonDatPhong
					WHERE @checkin BETWEEN NgayCheckin AND NgayCheckout 
					OR @checkout BETWEEN NgayCheckin AND NgayCheckout))
		BEGIN
			PRINT 'Phong da duoc dat!'
			ROLLBACK TRAN;
		END
	ELSE
		BEGIN
			PRINT 'Phong con trong tien hanh dat phong...'

			SELECT @sodem = DATEDIFF(DAY, @checkin, @checkout)
			SELECT @tong = @sodem*GiaPhong FROM T_LoaiPhong, T_Phong 
			WHERE T_LoaiPhong.MaLoaiPhong = T_Phong.MaLoaiPhong AND @maPhong = MaPhong

			INSERT T_DonDatPhong (MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout, TongTien)
			VALUES (@maPhong, @maTaiKhoan, @checkin, @checkout, @tong)
		END
END
GO
--INSERT T_DonDatPhong (MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout)
--VALUES (76, 1,'12-24-2022', '12-27-2022')
--GO

----Xoa Dich Vu
--CREATE or ALTER TRIGGER TG_XoaDichVu ON T_DichVu 
--INSTEAD OF DELETE AS
--BEGIN
--	DECLARE @maDichVu int
--	SELECT @maDichVu = MaDichVu FROM deleted
--	--Delete cac Dich vu trong DS DV
--	DELETE FROM T_DSDichVu WHERE MaDichVu = @maDichVu
--	--Delete Dich vu
--	DELETE FROM T_DichVu WHERE MaDichVu = @maDichVu
--END
--GO

--DELETE T_DichVu WHERE MaDichVu = 16
--SELECT * FROM T_DichVu



--DON DAT PHONG//////////////////////////////////////////////////////
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (1,    1, '03/25/2023', '03/27/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (2,    3, '03/24/2023', '03/25/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (2,    2, '03/26/2023', '03/29/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (3,    8, '03/25/2023', '03/26/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (4,    10, '03/24/2023', '03/27/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (7,    11, '03/27/2023', '03/31/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (8,    9, '03/25/2023', '03/28/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (10,   6, '03/24/2023', '03/25/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (11,   3, '03/24/2023', '03/26/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (11,   7, '03/28/2023', '03/30/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (12,   2, '03/27/2023', '03/29/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (13,   6, '03/27/2023', '03/29/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (15,   7, '03/24/2023', '03/27/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (17,   9, '03/24/2023', '03/25/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (17,   2, '03/28/2023', '03/31/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (18,   4, '03/24/2023', '03/29/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (19,   6, '03/26/2023', '03/27/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (20,   8, '03/27/2023', '03/30/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (21,   1, '03/26/2022', '03/28/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (21,   10, '03/29/2023', '03/31/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (22,   11, '03/25/2023', '03/31/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (26,   3, '03/24/2023', '03/26/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (27,   5, '03/24/2023', '03/26/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (28,   9, '03/24/2023', '03/26/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (28,   4, '03/27/2023', '03/31/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (29,   6, '03/24/2023', '03/27/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (33,   6, '03/25/2023', '03/28/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (36,   8, '03/28/2023', '03/30/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (38,   3, '03/26/2023', '03/29/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (44,   5, '03/25/2023', '03/29/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (48,   3, '03/28/2023', '03/29/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (49,   5, '03/30/2023', '03/31/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (52,   3, '03/26/2023', '03/27/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (53,   2, '03/28/2023', '03/30/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (54,   1, '03/24/2023', '03/29/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (55,   10, '03/28/2023', '03/30/2023') 
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (56,   8, '03/24/2023', '03/26/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (59,   1, '03/25/2023', '03/27/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (60,   11, '03/28/2023', '03/30/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (65,   10, '03/29/2023', '03/31/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (70,   9, '03/27/2023', '03/30/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (71,   10, '03/26/2023', '03/30/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (72,   2, '03/24/2023', '03/31/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (77,   6, '03/25/2023', '03/29/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (81,   7, '03/27/2023', '03/29/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (82,   8, '03/29/2023', '03/31/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (88,   3, '03/30/2023', '03/31/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (89,   4, '03/28/2023', '03/31/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (90,   1, '03/28/2023', '03/30/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (93,   11, '03/24/2023', '03/27/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (99,   8, '03/28/2023', '03/29/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (100,  2, '03/24/2023', '03/29/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (101,  1, '03/25/2023', '03/27/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (102,  3, '03/24/2023', '03/25/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (102,  2, '03/27/2023', '03/29/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (103,  8, '03/25/2023', '03/26/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (104,  10, '03/24/2023', '03/27/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (107,  11, '03/27/2023', '03/31/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (108,  9, '03/25/2023', '03/28/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (110,  6, '03/24/2023', '03/25/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (111,  3, '03/24/2023', '03/26/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (111,  7, '03/28/2023', '03/30/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (112,  2, '03/27/2023', '03/29/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (113,  6, '03/27/2023', '03/29/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (115,  7, '03/24/2023', '03/27/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (117,  9, '03/24/2023', '03/25/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (117,  2, '03/28/2023', '03/31/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (118,  4, '03/24/2023', '03/29/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (119,  6, '03/26/2023', '03/27/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (120,  8, '03/27/2023', '03/30/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (121,  1, '03/26/2023', '03/28/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (121,  10, '03/29/2023', '03/31/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (122,  11, '03/25/2023', '03/31/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (126,  3, '03/24/2023', '03/26/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (127,  5, '03/24/2023', '03/26/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (128,  9, '03/24/2023', '03/26/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (128,  4, '03/27/2023', '03/31/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (129,  6, '03/24/2023', '03/27/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (133,  6, '03/25/2023', '03/28/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (134,  7, '03/26/2023', '03/31/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (136,  8, '03/28/2023', '03/30/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (137,  9, '03/27/2023', '03/28/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (138,  3, '03/26/2023', '03/29/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (139,  2, '03/24/2023', '03/28/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (144,  5, '03/25/2023', '03/29/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (148,  3, '03/28/2023', '03/29/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (149,  5, '03/30/2023', '03/31/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (152,  3, '03/26/2023', '03/27/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (153,  2, '03/28/2023', '03/30/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (154,  1, '03/24/2023', '03/29/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (154,  10, '03/28/2022', '03/30/2022')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (156,  8, '03/24/2023', '03/26/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (157,  1, '03/24/2023', '03/27/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (159,  1, '03/25/2023', '03/27/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (160,  11, '03/28/2023', '03/30/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (163,  10, '03/29/2023', '03/31/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (167,  9, '03/27/2023', '03/30/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (168,  10, '03/26/2023', '03/30/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (171,  2, '03/24/2023', '03/31/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (175,  6, '03/25/2023', '03/29/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (178,  3, '03/30/2023', '03/31/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (181,  7, '03/27/2023', '03/29/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (186,  8, '03/29/2023', '03/31/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (189,  4, '03/28/2023', '03/31/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (191,  1, '03/28/2023', '03/30/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (192,  11, '03/24/2023', '03/27/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (195,  10, '03/24/2023', '03/26/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES(196,  9, '03/27/2023', '03/29/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES(198,  8, '03/28/2023', '03/29/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES(200,  2, '03/24/2023', '03/29/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES(201,  1, '03/25/2023', '03/27/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES(202,  3, '03/24/2023', '03/25/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES(202,  2, '03/26/2023', '03/29/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES(203,  8, '03/25/2023', '03/26/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (204,  10, '03/24/2023', '03/27/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (205,  11, '03/27/2023', '03/31/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (207,  9, '03/25/2023', '03/28/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (208,  6, '03/24/2023', '03/25/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (210,  3, '03/24/2023', '03/26/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (211,  7, '03/28/2023', '03/30/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (212,  2, '03/27/2023', '03/29/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (214,  6, '03/27/2023', '03/29/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (215,  7, '03/24/2023', '03/27/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (216,  9, '03/24/2023', '03/25/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (217,  2, '03/28/2023', '03/31/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (218,  4, '03/24/2023', '03/29/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (219,  6, '03/26/2023', '03/27/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (220,  8, '03/27/2023', '03/30/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (221,  1, '03/26/2023', '03/28/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (222,  11, '03/25/2023', '03/31/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (226,  3, '03/24/2023', '03/26/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (227,  5, '03/24/2023', '03/26/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (228,  9, '03/24/2023', '03/26/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (229,  6, '03/24/2023', '03/27/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (233,  6, '03/25/2023', '03/28/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (236,  8, '03/28/2023', '03/30/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (238,  3, '03/26/2023', '03/29/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (239,  2, '03/24/2023', '03/28/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (244,  5, '03/25/2023', '03/29/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (248,  3, '03/28/2023', '03/29/2023')
INSERT INTO T_DonDatPhong(MaPhong, MaTaiKhoan, NgayCheckin, NgayCheckout) VALUES (251,  5, '03/30/2023', '03/31/2023')
