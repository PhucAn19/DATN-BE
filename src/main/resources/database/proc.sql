CREATE PROCEDURE sp_san_pham_noi_bat
AS
BEGIN
    SELECT TOP 10 
        sp.id,
        sp.tensanpham,
        sp.anhgoc,
        SUM(cthd.soluong) AS tong_soluong_ban,
        SUM(cthd.dongia * cthd.soluong) AS tong_doanhthu
    FROM 
        chi_tiet_hoa_don cthd
    INNER JOIN 
        san_pham sp ON sp.id = cthd.sanpham
    GROUP BY 
        sp.id, sp.tensanpham, sp.anhgoc
    ORDER BY 
        tong_soluong_ban DESC
END
