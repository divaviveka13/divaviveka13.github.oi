ALTER PROCEDURE usp_sales_by_seller_rian (
@staff_name VARCHAR(MAX)
)

AS BEGIN 
	SET NOCOUNT ON;
	DECLARE @id_staff INT;
	SET @id_staff =
	(SELECT staff_id FROM sales.staffs WHERE (first_name + ' ' + last_name) = @staff_name)
	
	SELECT 'SALES AS BEGIN' [Project Minggu Ke-2] FROM sales.staffs WHERE staff_id = @id_staff

	SELECT 
		stf.first_name + ' ' + stf.last_name [Staff's Name], 
		sts.store_name AS [Store Name], 
		stf.email [Staff's Email], 
		stf.phone [Staff's Phone],
		so.order_date [Order Date], 
		so.order_id [Order ID], 
		SUM( (soi.list_price * soi.quantity) - ((soi.list_price * soi.quantity)* soi.discount) ) [Value]
	FROM sales.orders so 
		JOIN sales.staffs stf
		ON so.staff_id = stf.staff_id
			JOIN sales.order_items soi
			ON so.order_id = soi.order_id
				JOIN sales.stores sts
				ON so.store_id = sts.store_id
	WHERE order_status = 4  
	AND stf.staff_id = @id_staff
	GROUP BY stf.first_name + ' ' + stf.last_name , 
		sts.store_name, 
		stf.email, 
		stf.phone,
		so.order_date,
		so.order_id
	UNION ALL

	SELECT 
		'', '', '', 'Total Value', '', '', SUM( (soi.list_price * soi.quantity) - ((soi.list_price * soi.quantity)* soi.discount) ) [Total Value]
	FROM sales.orders so 
		JOIN sales.staffs stf
		ON so.staff_id = stf.staff_id
			JOIN sales.order_items soi
			ON so.order_id = soi.order_id
	WHERE order_status = 4
	AND stf.staff_id = @id_staff
	GROUP BY so.staff_id


END;

EXEC usp_sales_by_seller_rian 'Kali Vargas';