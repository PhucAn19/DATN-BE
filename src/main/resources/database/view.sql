CREATE OR ALTER VIEW VIEW_SAN_PHAM_XEP_HANG AS
SELECT 
    sp.id,
    sp.tensanpham,
    sp.dongia,
    sp.anhgoc,
    COUNT(DISTINCT yt.id) AS so_luot_yeu_thich,
    AVG(CAST(dg.diemso AS FLOAT)) AS diem_danh_gia_tb
FROM SAN_PHAM sp
LEFT JOIN YEU_THICH yt ON yt.sanpham = sp.id
LEFT JOIN DANH_GIA dg ON dg.sanpham = sp.id
GROUP BY sp.id, sp.tensanpham, sp.dongia, sp.anhgoc;
