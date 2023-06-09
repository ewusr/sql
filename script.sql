
CREATE PROCEDURE [dbo].[AllCustomerBalanceActivity]
	@Date date,
	@Date1 date
AS
BEGIN
	SELECT 
   DateAdd(DAY,-1,@Date1) as Date,ca.Party as Customer ,'0' as Invoice ,
 N'بقایا جات' as Description
, (Select  Sum(Debit) from Party_account where   Date < @Date1 and ca.Party=Party  )as  Debit,(Select   sum(Credit)+SUM(Sales_Return) from Party_account where   Date < @Date1 and ca.Party=Party  )as Credit 
from Party_account ca 

 WHERE  ca.Date = @Date1
 group by ca.Party




 union all
 --customer account


 SELECT 
   cast(Date as date)   as Date ,ca.Party as Customer,Invoice as Invoice ,
 Description as Description
, Debit as  Debit, 0 as Credit 
from Party_account ca 

 WHERE  ca.Date between @Date and @Date1 and  Debit >0 









  union all
 --Party_account


 SELECT 
   cast(Date as date)    as Date,ca.Party as Customer ,Invoice as Invoice ,
 Description as Description
, 0  Debit, Credit as Credit 
from Party_account ca 

 WHERE  ca.Date between @Date and @Date1  and Credit >0 

  order by Date ASC
END



GO
/****** Object:  StoredProcedure [dbo].[AllCustomerLadger]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AllCustomerLadger] 

	@Date date,
	@Date1 date
AS
BEGIN
	SELECT 
   DateAdd(DAY,-1,@Date1) as Date,ca.Party as Customer ,'0' as Invoice ,
 N'بقایا جات' as Description
, (Select  Sum(Debit) from Party_account where   Date < @Date1 and ca.Party=Party  )as  Debit,(Select   sum(Credit)+SUM(Sales_Return) from Party_account where   Date < @Date1 and ca.Party=Party  )as Credit 
from Party_account ca 

 WHERE  ca.Date = @Date1
 group by ca.Party

 union all

 SELECT 
cast(cp.Date as date) as Date,cp.Party as Customer ,cp.Invoice_Total as Invoice,
   (SELECT    '  ' +cast(Qty as nvarchar)+Unit++'   '+ '   '+Long_Name+'  '+Qty2+'   '+ +'('+cast(RateInBill as nvarchar)+ ' )'+ +''+'  = ' + cast(Total2 as nvarchar) +''++ char(10)
  
    FROM Invoice_Master 

  --  WHERE Date=Date and Customer_ID=Customer_ID and Product_ID=Product_ID and Product_ID > '115' and cp.Bill_NO=Bill_NO 
   WHERE Date=Date and cp.Party_ID=Party_ID and Bar_Code=Bar_Code  and cp.Invoice_Total=Invoice_Total and cp.Invoice_Total >0
	order by Bar_Code DESC
    FOR XML PATH('')) [Description],
 
 
sum(Total2) as Debit,0 as Credit 
 from Invoice_Master cp 
WHERE cp.Date between @Date and @Date1 and  Table_Type='Invoice'  and cp.Invoice_Total >0
GROUP BY cp.Date,cp.Invoice_Total,cp.Party_ID,cp.Party 

union all


 --rent


 SELECT 
   cast(Date as date)  as Date,ca.Party as Customer  ,Invoice_Total as Invoice ,
 N'انوائس کرایہ' as Description
, max(Bulti_Expense2)  Debit, 0 as Credit 
from Invoice_Master ca 

 WHERE  ca.Date between @Date and @Date1  and Bulti_Expense2 >0 
 group by Date,Invoice_Total,Party







 union all
 --customer account


 SELECT 
   cast(Date as date)   as Date ,ca.Party as Customer,Invoice as Invoice ,
 Description as Description
, Debit as  Debit, 0 as Credit 
from Party_account ca 

 WHERE  ca.Date between @Date and @Date1 and  Debit >0 and Table_Type !='Invoice'









  union all
 --Party_account


 SELECT 
   cast(Date as date)    as Date,ca.Party as Customer ,Invoice as Invoice ,
 Description as Description
, 0  Debit, Credit as Credit 
from Party_account ca 

 WHERE  ca.Date between @Date and @Date1  and Credit >0 and Table_Type='Journal_General'

  order by Date ASC
END



GO
/****** Object:  StoredProcedure [dbo].[CashClosing]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CashClosing]
@Date date,
 @Date1 date
	
AS
BEGIN
	
	SELECT 
   DateAdd(DAY,-1,@Date) as Date    ,0 as Invoice ,'---' as Name ,
 N'بقایا بیلنس' as Description
, Sum(Debit) as   Debit, Sum(Credit) as Credit 
from Journal_Gernal ca 

 WHERE  ca.Date < @Date  and  Transaction_Type='1'

 union all 
 SELECT 
   cast(Date as date)    as Date ,ca.Invoice as Invoice,ca.Account_Name1 as Name ,
 Description1 as Description
, 0 as   Debit, Credit as Credit 
from Journal_Gernal ca 

 WHERE  ca.Date between @Date and @Date1  and Credit > 0 and Transaction_Type='1'

 union all 
 select
  cast(Date as date)    as Date ,ca.Invoice as Invoice,ca.Account_Name as Name ,
 Description as Description
, Debit as   Debit, 0 as Credit 
from Journal_Gernal ca 

 WHERE  ca.Date between @Date and @Date1  and Debit > 0 and Transaction_Type='1'


  order by Date, Invoice ASC
END
	


GO
/****** Object:  StoredProcedure [dbo].[CustomerLadger]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CustomerLadger]
	

	@Date date,
	@Date1 date,
	@Code int
AS
BEGIN
	
SELECT 
   DateAdd(DAY,-1,@Date) as Date ,'0' as Invoice ,
 N'اکاونٹ بیلنس' as Description
, sum(Debit)  Debit, sum(Credit)+SUM(Sales_Return) as Credit 
from Party_account ca 

 WHERE  ca.Date < @Date and ca.Party_ID =@Code
 having Sum(Debit) > 0 
 union all
 --customeraaccount

-- SELECT 
 --  cast(Date as date) as Date ,Invoice as Invoice ,
-- Description as Description
--, Debit  Debit, Credit as Credit 
--from customer_account ca 

-- WHERE  ca.Date between @Date and @Date1 and ca.Customer_ID =@Code and Debit >0 and Table_Type='Customer_Account'

 
 


 SELECT 
cast(cp.Date as date) as Date,cp.Invoice_Total as Invoice,
   (SELECT    '  ' +cast(Qty as nvarchar)+Unit++'   '+ '   '+Long_Name+'  '+Qty2+'   '+ +'('+cast(RateInBill as nvarchar)+ ' )'+ +''+'  = ' + cast(Total2 as nvarchar) +''++ char(10)
  
    FROM Invoice_Master 

  --  WHERE Date=Date and Customer_ID=Customer_ID and Product_ID=Product_ID and Product_ID > '115' and cp.Bill_NO=Bill_NO 
   WHERE Date=Date and cp.Party_ID=Party_ID and Bar_Code=Bar_Code  and cp.Invoice_Total=Invoice_Total and cp.Invoice_Total >0
	order by Bar_Code DESC
    FOR XML PATH('')) [Description],
 
 
sum(Total2) as Debit,0 as Credit 
 from Invoice_Master cp 
WHERE cp.Date between @Date and @Date1 and cp .Party_ID=@Code and Table_Type='Invoice'  and cp.Invoice_Total >0
GROUP BY cp.Date,cp.Invoice_Total,cp.Party_ID



union all
 --discount


 SELECT 
   cast(ca.Date as date)  as Date ,Invoice as Invoice ,
 N'رعایت' as Description
, 0  Debit, Fix_Dis+Amount as Credit 
from Discount ca 

 WHERE  ca.Date between @Date and @Date1 and ca.Party_ID =@Code and Description1 >0 and Table_Type='Invoice'



union all
 --rent


 SELECT 
   cast(Date as date)  as Date ,Invoice_Total as Invoice ,
 N'انوائس کرایہ' as Description
, max(Bulti_Expense2)  Debit, 0 as Credit 
from Invoice_Master ca 

 WHERE  ca.Date between @Date and @Date1 and ca.Party_ID =@Code and Bulti_Expense2 >0 and Table_Type='Invoice'
 group by Date,Invoice_Total


 union all
--return
 
 


 SELECT 
cast(cp.Date as date) as Date,cp.Return_Total as Invoice,
   (SELECT    '  ' +cast(Qty as nvarchar)+Unit++'   '+ '   '+Long_Name+'  '+Qty2+'   '+ +'('+cast(RateInBill as nvarchar)+ ' )'+ +''+'  = ' + cast(Total2 as nvarchar) +''++ char(10)
  
    FROM Invoice_Master 

  --  WHERE Date=Date and Customer_ID=Customer_ID and Product_ID=Product_ID and Product_ID > '115' and cp.Bill_NO=Bill_NO 
   WHERE Date=Date and cp.Party_ID=Party_ID and Bar_Code=Bar_Code  and cp.Return_Total=Return_Total and cp.Return_Total >0
	order by Bar_Code DESC
    FOR XML PATH('')) [Description],
 
 
0 as Debit,sum(Total2) as Credit 
 from Invoice_Master cp 
WHERE cp.Date between @Date and @Date1 and cp .Party_ID=@Code and Table_Type='Invoice_Return'  and cp.Return_Total >0
GROUP BY cp.Date,cp.Return_Total,cp.Party_ID



union all
 --discount

 -- return
 SELECT 
   cast(ca.Date as date)  as Date ,Return_Total as Invoice ,
 N'رعایت' as Description
, 0  Debit, Fix_Dis+Amount as Credit 
from Discount ca 

 WHERE  ca.Date between @Date and @Date1 and ca.Party_ID =@Code and Description1 >0 and Table_Type='Invoice_Return'



union all
 --rent return


 SELECT 
   cast(Date as date)  as Date ,Return_Total as Invoice ,
 N'انوائس کرایہ واپسی' as Description
,0 as   Debit,  max(Bulti_Expense2) as Credit 
from Invoice_Master ca 

 WHERE  ca.Date between @Date and @Date1 and ca.Party_ID =@Code and Bulti_Expense2 >0 and Table_Type='Invoice_Return'
 group by Date,Return_Total






union all
 



 SELECT 
   cast(Date as date)    as Date ,Invoice_Total as Invoice ,
 Description as Description
, 0  Debit, Credit as Credit 
from Party_account ca 

 WHERE  ca.Date between @Date and @Date1 and ca.Party_ID =@Code and Credit >0 and Table_Type='Invoice'


  union all
 --customer account


 SELECT 
   cast(Date as date)   as Date ,Invoice as Invoice ,
 Description as Description
, Debit as  Debit, 0 as Credit 
from Party_account ca 

 WHERE  ca.Date between @Date and @Date1 and ca.Party_ID =@Code and Debit >0 and Table_Type !='Invoice'









  union all
 --Party_account


 SELECT 
   cast(Date as date)    as Date ,Invoice as Invoice ,
 Description as Description
, 0  Debit, Credit as Credit 
from Party_account ca 

 WHERE  ca.Date between @Date and @Date1 and ca.Party_ID =@Code and Credit >0 and Table_Type='Journal_General'

  order by Date ASC
END


GO
/****** Object:  StoredProcedure [dbo].[DayClosing]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[DayClosing]

@Date date,
 @Date1 date
	
AS
BEGIN
	
SELECT  cast(cp.Date as date) as Date,cp.Invoice_Total as Invoice,Party as Name,N'سپلائیر خرید' as Description1,'1' as Description2,
   
 
   (SELECT    '  ' +cast(Qty as nvarchar)+Unit++'   '+ '   '+Long_Name+'  '+cast(QtyK as nvarchar)+'   '+ +'('+cast(Price as nvarchar)+ ' )'+ +''+'  = ' + cast(Amount as nvarchar) +''++ char(10)
  
    FROM PurchaseTb 

  --  WHERE Date=Date and Customer_ID=Customer_ID and Product_ID=Product_ID and Product_ID > '115' and cp.Bill_NO=Bill_NO 
   WHERE Date=Date and cp.Party_ID=Party_ID and Bar_Code=Bar_Code  and cp.Invoice_Total=Invoice_Total and cp.Invoice_Total >0
	order by Bar_Code DESC
    FOR XML PATH('')) [Description],
 
 
0 as Debit,sum(Amount)  as Credit 
 from PurchaseTb cp 
WHERE cp.Date between @Date and @Date1  and Table_Type='Purchase'  and cp.Invoice_Total >0
GROUP BY cp.Date,cp.Invoice_Total,cp.Party_ID,cp.Party

union all 

 SELECT 
   cast(Date as date)    as Date ,Invoice as Invoice,Party as Name ,N'سپلائیر ادائیگی' as Description1,'2' as Description2,
 Description as Description
, Debit as   Debit, 0 as Credit 
from Party_account2 ca 

 WHERE  ca.Date between @Date and @Date1  and Debit >0 and Table_Type='Journal_General'







 union all 

SELECT 
cast(cp.Date as date) as Date,cp.Invoice_Total as Invoice,cp.Party as Name ,N'کسٹمر خرید ' as Description1,'3' as Description2,
   (SELECT    '  ' +cast(Qty as nvarchar)+Unit++'   '+ '   '+Long_Name+'  '+Qty2+'   '+ +'('+cast(RateInBill as nvarchar)+ ' )'+ +''+'  = ' + cast(Total2 as nvarchar) +''++ char(10)
  
    FROM Invoice_Master 

  --  WHERE Date=Date and Customer_ID=Customer_ID and Product_ID=Product_ID and Product_ID > '115' and cp.Bill_NO=Bill_NO 
   WHERE Date=Date and cp.Party_ID=Party_ID and Bar_Code=Bar_Code  and cp.Invoice_Total=Invoice_Total and cp.Invoice_Total >0
	order by Bar_Code DESC
    FOR XML PATH('')) [Description],
 
 
sum(Total2) as Debit,0 as Credit 
 from Invoice_Master cp 
WHERE cp.Date between @Date and @Date1 and  Table_Type='Invoice'  and cp.Invoice_Total >0
GROUP BY cp.Date,cp.Invoice_Total,cp.Party_ID,cp.Party 








union all
	

 SELECT 
   cast(Date as date)    as Date,Invoice as Invoice,ca.Party as Name  ,N'کسٹمر ادائیگی ' as Description1,'4' as Description2,
 Description as Description
, 0  Debit, Credit as Credit 
from Party_account ca 

 WHERE  ca.Date between @Date and @Date1  and Credit >0 and Table_Type='Journal_General'




 union all
	
 SELECT 
   cast(Date as date)  as Date,Invoice as Invoice,Expense as Name ,N'خرچہ' as Description1,'5' as Description2,
 Description as Description
, Sum(Debit) as Debit, (0) as Credit 
from Expense_account ca 

 WHERE  ca.Date between @Date and @Date1 and  Debit >0 
 Group by Date,Expense,Description,Invoice

 union all
	
 SELECT 
   cast(Date as date)  as Date,Invoice as Invoice,Bank as Name ,N'بینک بنام' as Description1,'6' as Description2,
 Description as Description
, Sum(Debit) as Debit, (0) as Credit 
from Bank_account ca 

 WHERE  ca.Date between @Date and @Date1 and  Debit >0 
 Group by Date,Bank,Description,Invoice

 union all
	
 SELECT 
   cast(Date as date)  as Date,Invoice as Invoice,Bank as Name ,N'بینک جمع' as Description1,'7' as Description2,
 Description as Description
, (0) as Debit, Sum(Credit) as Credit 
from Bank_account ca 

 WHERE  ca.Date between @Date and @Date1 and  Credit >0 
 Group by Date,Bank,Description,Invoice


  order by Date, Description2 ASC
END


GO
/****** Object:  StoredProcedure [dbo].[ProductSerial]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ProductSerial]
	

AS
BEGIN
DECLARE  @id numeric 
SET @id = 0;
WITH PTable AS

(
    SELECT  Product_ID,Serial,
            RANK() OVER (ORDER BY Product_ID ASC ) AS Colu
                         
    FROM Product

)




		UPDATE PTable
SET @id = Serial = @id + 1 where PTable.Colu > 0




END



GO
/****** Object:  StoredProcedure [dbo].[SalesLadger]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SalesLadger]
	@Date1 date,
	@Date2  date
AS
BEGIN
	
	
select Date as Date,ca.Category,ca.Bar_Code,ca.Long_Name,
ca.Price as Price,sum(Qty) as Sales,
COALESCE((select sum(0) from SalesReturnPOS where Bar_Code=ca.Bar_Code ),'0') as SalesReturn,
sum(Amount) as SalesAmount,COALESCE((select sum(0) from SalesReturnPOS where Bar_Code=ca.Bar_Code ),'0') as ReturnAmount,
0 as SalesDis,0 as ReturnDis,0 as Expe,0 as Serv From SalesPOS ca where Date between @Date1 and @Date2 group by Date,Category,Bar_Code,Long_Name,Price

union all
--Return
select Date as Date,ca.Category,ca.Bar_Code,ca.Long_Name,
ca.Price as Price,sum(0) as Sales,
COALESCE((select sum(Qty) from SalesReturnPOS where Bar_Code=ca.Bar_Code ),'0') as SalesReturn,
sum(0) as SalesAmount,COALESCE((select sum(Amount) from SalesReturnPOS where Bar_Code=ca.Bar_Code ),'0') as ReturnAmount,
0 as SalesDis,0 as ReturnDis,0 as Expe,0 as Serv From SalesReturnPOS ca where Date between @Date1 and @Date2 group by Date,Category,Bar_Code,Long_Name,Price



union all
--Discount
select Date as Date,'' as Category,'Z' as Bar_Code,'Discount Total' Long_Name,
0 as  Price,sum(0) as Sales,
0 as SalesReturn,
(0) as SalesAmount,
0 as ReturnAmount,
COALESCE((select (Sum(Fix_Dis)+sum(Amount)) from DiscountPOS where Date=ca.Date and Invoice>0 ),'0') as SalesDis,
-COALESCE((select (Sum(Fix_Dis)+sum(Amount)) from DiscountPOS where Date=ca.Date and Invoice_Return>0 ),'0') as ReturnDis,0 as Expe,
0 as Serv
 From DiscountPOS ca 
 where Invoice>0 and Date between @Date1 and @Date2  group by Date having (Sum(Fix_Dis)+sum(Amount))>0 

 union all
--Ser
select Date as Date,'' as Category,'Z' as Bar_Code,'Services Total' Long_Name,
0 as  Price,sum(0) as Sales,
0 as SalesReturn,
-(0) as SalesAmount,
0 as ReturnAmount,
0 as SalesDis,
0 as ReturnDis,0 as Expe,
sum(Service_Charges) as Serv
 From DiscountPOS ca 
 where Invoice>0 and Date between @Date1 and @Date2  group by Date having (sum(Service_Charges))>0 



















 union all 
 --expense

 select Date as Date,'' as Category,'Z' as Bar_Code,'Expenses Total' Long_Name,
0 as  Price,sum(0) as Sales,
0 as SalesReturn,
Sum(0) as SalesAmount,
0 as ReturnAmount,
0 as SalesDis,
0 as ReturnDis,Sum(Debit) as Expe,0 as Serv From Expense_account  
 where Invoice>0 and Date between @Date1 and @Date2 group by Date having (sum(Debit))>0
 order by Date,Bar_Code ASC


END
















GO
/****** Object:  StoredProcedure [dbo].[SupplierLadger]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SupplierLadger]
	
	@Date date,
	@Date1 date,
	@Code int
AS
BEGIN
	
SELECT 
   DateAdd(DAY,-1,@Date) as Date ,'0' as Invoice ,
 N'اکاونٹ بیلنس' as Description
, sum(Debit)  Debit, sum(Credit)+SUM(Sales_Return) as Credit 
from Party_account2 ca 

 WHERE  ca.Date < @Date and ca.Party_ID =@Code
 having Sum(Credit)>0
 union all
 --customeraaccount

-- SELECT 
 --  cast(Date as date) as Date ,Invoice as Invoice ,
-- Description as Description
--, Debit  Debit, Credit as Credit 
--from customer_account ca 

-- WHERE  ca.Date between @Date and @Date1 and ca.Customer_ID =@Code and Debit >0 and Table_Type='Customer_Account'

 
 


 SELECT 
cast(cp.Date as date) as Date,cp.Invoice_Total as Invoice,
   (SELECT    '  ' +cast(Qty as nvarchar)+Unit++'   '+ '   '+Long_Name+'  '+cast(QtyK as nvarchar)+'   '+ +'('+cast(Price as nvarchar)+ ' )'+ +''+'  = ' + cast(Amount as nvarchar) +''++ char(10)
  
    FROM PurchaseTb 

  --  WHERE Date=Date and Customer_ID=Customer_ID and Product_ID=Product_ID and Product_ID > '115' and cp.Bill_NO=Bill_NO 
   WHERE Date=Date and cp.Party_ID=Party_ID and Bar_Code=Bar_Code  and cp.Invoice_Total=Invoice_Total and cp.Invoice_Total >0
	order by Bar_Code DESC
    FOR XML PATH('')) [Description],
 
 
0 as Debit,sum(Amount)  as Credit 
 from PurchaseTb cp 
WHERE cp.Date between @Date and @Date1 and cp .Party_ID=@Code and Table_Type='Purchase'  and cp.Invoice_Total >0
GROUP BY cp.Date,cp.Invoice_Total,cp.Party_ID





















union all




 SELECT 
   cast(Date as date)    as Date ,Invoice_Total as Invoice ,
 Description as Description
, 0  Debit, Credit as Credit 
from Party_account2 ca 

 WHERE  ca.Date between @Date and @Date1 and ca.Party_ID =@Code and Credit >0 and Table_Type='Purchase' and Description3 !=''


  union all
 --Supplier account


 SELECT 
   cast(Date as date)  as Date ,Invoice as Invoice ,
 Description as Description
, 0 as  Debit, Credit as Credit 
from Party_account2 ca 

 WHERE  ca.Date between @Date and @Date1 and ca.Party_ID =@Code and Credit >0 and Table_Type !='Purchase'









  union all
 --Party_account


 SELECT 
   cast(Date as date)    as Date ,Invoice as Invoice ,
 Description as Description
, Debit as   Debit, 0 as Credit 
from Party_account2 ca 

 WHERE  ca.Date between @Date and @Date1 and ca.Party_ID =@Code and Debit >0 and Table_Type='Journal_General'

  order by Date ASC
END



GO
/****** Object:  Table [dbo].[Advance_cheque]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Advance_cheque](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Acc_ID] [nvarchar](5) NULL,
	[Account] [nvarchar](100) NULL,
	[Account_NO] [nvarchar](max) NULL,
	[Address] [nvarchar](max) NULL,
	[Contact] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[Cheque_NO] [nvarchar](100) NULL,
	[Cheque_status] [nvarchar](50) NULL,
	[Cheque_Date] [date] NULL,
	[Debit] [numeric](18, 2) NULL,
	[Credit] [numeric](18, 2) NULL,
	[Transaction_ID] [nvarchar](5) NULL,
	[Transaction_From] [nvarchar](100) NULL,
	[TransactionAccount_NO] [nvarchar](max) NULL,
	[Transaction_Address] [nvarchar](max) NULL,
	[Contact1] [nvarchar](max) NULL,
	[Ref_NO] [nvarchar](max) NULL,
	[Table_Type] [nvarchar](max) NULL,
	[Account_Type] [nvarchar](max) NULL,
	[Currency] [nvarchar](50) NULL,
	[Exchange_Rate] [numeric](18, 2) NULL,
	[Currency_Amount] [numeric](18, 2) NULL,
	[InvoiceReceive_Amount] [numeric](18, 2) NULL,
	[InvoiceReceiveNum] [numeric](18, 0) NULL,
	[Checkbox] [nvarchar](max) NULL,
	[Description1] [nvarchar](max) NULL,
	[Description2] [nvarchar](max) NULL,
	[Description3] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Advance_chequenew]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Advance_chequenew](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[BankID] [nvarchar](8) NULL,
	[Bank] [nvarchar](100) NULL,
	[Acc_NO] [nvarchar](50) NULL,
	[Address] [nvarchar](50) NULL,
	[Description] [nvarchar](max) NULL,
	[Cheque_NO] [nvarchar](100) NULL,
	[Cheque_Date] [date] NULL,
	[Cheque_Type] [nvarchar](50) NULL,
	[ChequeStatus] [nvarchar](50) NULL,
	[Debit] [numeric](18, 2) NULL,
	[Credit] [numeric](18, 2) NULL,
	[Transaction_ID] [nvarchar](5) NULL,
	[Transaction_From] [nvarchar](100) NULL,
	[TransactionAccount_NO] [nvarchar](max) NULL,
	[Transaction_Address] [nvarchar](max) NULL,
	[Ref_NO] [nvarchar](max) NULL,
	[Table_Type] [nvarchar](max) NULL,
	[Description1] [nvarchar](max) NULL,
	[Description2] [nvarchar](max) NULL,
	[Description3] [nvarchar](max) NULL,
	[AccountChecked] [numeric](18, 2) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Advancecheque]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Advancecheque](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[BankID] [nvarchar](8) NULL,
	[Bank] [nvarchar](100) NULL,
	[Acc_NO] [nvarchar](50) NULL,
	[Address] [nvarchar](50) NULL,
	[Description] [nvarchar](max) NULL,
	[Cheque_NO] [nvarchar](100) NULL,
	[Cheque_Date] [date] NULL,
	[Cheque_Type] [nvarchar](50) NULL,
	[ChequeStatus] [nvarchar](50) NULL,
	[Debit] [numeric](18, 2) NULL,
	[Credit] [numeric](18, 2) NULL,
	[Transaction_ID] [nvarchar](5) NULL,
	[Transaction_From] [nvarchar](100) NULL,
	[TransactionAccount_NO] [nvarchar](max) NULL,
	[Transaction_Address] [nvarchar](max) NULL,
	[Ref_NO] [nvarchar](max) NULL,
	[Table_Type] [nvarchar](max) NULL,
	[Description1] [nvarchar](max) NULL,
	[Description2] [nvarchar](max) NULL,
	[Description3] [nvarchar](max) NULL,
	[AccountChecked] [numeric](18, 2) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AutoAdd]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AutoAdd](
	[AutoAdd] [nvarchar](50) NULL,
	[PC] [nvarchar](50) NULL,
	[Branch] [nvarchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Bank_account]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bank_account](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Voc_Num] [numeric](18, 0) NULL,
	[Bank_ID] [nvarchar](5) NULL,
	[Bank] [nvarchar](50) NULL,
	[Address] [nvarchar](100) NULL,
	[Cell_Number] [nvarchar](15) NULL,
	[Account_Num] [nvarchar](20) NULL,
	[Description] [nvarchar](max) NULL,
	[Transaction_ID] [nvarchar](5) NULL,
	[Transaction_From] [nvarchar](max) NULL,
	[Branch1] [nvarchar](max) NULL,
	[Account_NO] [nvarchar](max) NULL,
	[Cheque] [nvarchar](max) NULL,
	[Cheque_Amount] [numeric](18, 2) NULL,
	[Cheque_Category] [nvarchar](50) NULL,
	[Cheque_Date] [date] NULL,
	[Cheque_Status] [nvarchar](50) NULL,
	[Debit] [numeric](18, 2) NULL,
	[Credit] [numeric](18, 2) NULL,
	[Currency] [nvarchar](50) NULL,
	[Exchange_Rate] [numeric](18, 2) NULL,
	[Currency_Amount] [numeric](18, 2) NULL,
	[Page1] [nvarchar](50) NULL,
	[Page2] [nvarchar](50) NULL,
	[Ref_NO] [nvarchar](max) NULL,
	[Table_Type] [nvarchar](max) NULL,
	[Description1] [nvarchar](max) NULL,
	[Description2] [nvarchar](max) NULL,
	[Description3] [nvarchar](max) NULL,
	[AccountChecked] [numeric](18, 2) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Bank_AccountImage]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bank_AccountImage](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Voc_Num] [numeric](18, 0) NULL,
	[Bank_ID] [nvarchar](5) NULL,
	[Bank] [nvarchar](50) NULL,
	[Address] [nvarchar](100) NULL,
	[AccountNo] [nvarchar](15) NULL,
	[Image] [image] NULL,
	[Table_Type] [nvarchar](max) NULL,
	[Des1] [numeric](18, 0) NULL,
	[Des2] [nvarchar](max) NULL,
	[Des3] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Bank_Info]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bank_Info](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Active] [nvarchar](max) NULL,
	[Bank_ID] [nvarchar](5) NULL,
	[Bank] [nvarchar](60) NULL,
	[Account_No] [nvarchar](50) NULL,
	[Address] [nvarchar](100) NULL,
	[Phone] [nvarchar](20) NULL,
	[Email] [nvarchar](max) NULL,
	[Opening_Balance] [numeric](18, 2) NULL,
	[Balance_Type] [nvarchar](max) NULL,
	[Description1] [nvarchar](max) NULL,
	[Description2] [nvarchar](max) NULL,
	[Description3] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Branches]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Branches](
	[Branch] [nvarchar](max) NULL,
	[Current_Branch] [nvarchar](max) NULL,
	[Login_Name] [nvarchar](max) NULL,
	[Invoice_Form] [nvarchar](max) NULL,
	[Invoice_From2] [nvarchar](max) NULL,
	[Reports] [nvarchar](max) NULL,
	[Address] [nvarchar](max) NULL,
	[Mobile] [nvarchar](max) NULL,
	[Mobile2] [nvarchar](max) NULL,
	[Phone] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Code] [numeric](18, 0) NULL,
	[Code2] [nvarchar](max) NULL,
	[Description1] [nvarchar](max) NULL,
	[Description2] [nvarchar](max) NULL,
	[Description3] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Broker_account]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Broker_account](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Voc_Num] [numeric](18, 0) NULL,
	[Type_Name] [nvarchar](50) NULL,
	[Account_ID] [nvarchar](5) NULL,
	[Account] [nvarchar](50) NULL,
	[Description] [nvarchar](max) NULL,
	[Transaction_ID] [nvarchar](5) NULL,
	[Transaction_From] [nvarchar](max) NULL,
	[Branch1] [nvarchar](max) NULL,
	[Account_NO] [nvarchar](max) NULL,
	[Cheque] [nvarchar](max) NULL,
	[Cheque_Amount] [numeric](18, 2) NULL,
	[Cheque_Category] [nvarchar](50) NULL,
	[Cheque_Date] [date] NULL,
	[Cheque_Status] [nvarchar](50) NULL,
	[Debit] [numeric](18, 2) NULL,
	[Credit] [numeric](18, 2) NULL,
	[Currency] [nvarchar](50) NULL,
	[Exchange_Rate] [numeric](18, 2) NULL,
	[Currency_Amount] [numeric](18, 2) NULL,
	[Page1] [nvarchar](50) NULL,
	[Page2] [nvarchar](50) NULL,
	[Ref_NO] [nvarchar](max) NULL,
	[Table_Type] [nvarchar](max) NULL,
	[Description1] [nvarchar](max) NULL,
	[Description2] [nvarchar](max) NULL,
	[Description3] [nvarchar](max) NULL,
	[AccountChecked] [numeric](18, 2) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Broker_Info]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Broker_Info](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Active] [nvarchar](max) NULL,
	[Account_ID] [nvarchar](5) NULL,
	[Account] [nvarchar](60) NULL,
	[Opening_Balance] [numeric](18, 2) NULL,
	[Balance_Type] [nvarchar](max) NULL,
	[Description1] [nvarchar](max) NULL,
	[Description2] [nvarchar](max) NULL,
	[Description3] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Category]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Category](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Category_ID] [nvarchar](4) NOT NULL,
	[Category] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Company]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Company](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Company_ID] [nvarchar](4) NOT NULL,
	[Company] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Counter_account]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Counter_account](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Invoice2] [numeric](18, 0) NULL,
	[Voc_Num] [numeric](18, 0) NULL,
	[Counter_ID] [nvarchar](5) NULL,
	[Counter] [nvarchar](50) NULL,
	[Party_ID] [nvarchar](5) NULL,
	[Party] [nvarchar](max) NULL,
	[Address] [nvarchar](100) NULL,
	[Description] [nvarchar](max) NULL,
	[Transaction_ID] [nvarchar](5) NULL,
	[Transaction_From] [nvarchar](max) NULL,
	[Branch1] [nvarchar](max) NULL,
	[Account_NO] [nvarchar](max) NULL,
	[Cheque] [nvarchar](max) NULL,
	[Cheque_Amount] [numeric](18, 2) NULL,
	[Cheque_Category] [nvarchar](50) NULL,
	[Cheque_Date] [date] NULL,
	[Cheque_Status] [nvarchar](50) NULL,
	[Debit] [numeric](18, 2) NULL,
	[Credit] [numeric](18, 2) NULL,
	[Sales_Return] [numeric](18, 2) NULL,
	[Cash_Received] [numeric](18, 2) NULL,
	[Cash_Charged] [numeric](18, 2) NULL,
	[Cash_Back] [numeric](18, 2) NULL,
	[Currency] [nvarchar](50) NULL,
	[Exchange_Rate] [numeric](18, 2) NULL,
	[Currency_Amount] [numeric](18, 2) NULL,
	[InvoiceReceive_Amount] [numeric](18, 2) NULL,
	[InvoiceReceiveNum] [numeric](18, 0) NULL,
	[Customer_Status] [nvarchar](max) NULL,
	[Ref_NO] [nvarchar](max) NULL,
	[Table_Type] [nvarchar](max) NULL,
	[Invoice_Total] [numeric](18, 0) NULL,
	[Return_Total] [numeric](18, 0) NULL,
	[Description3] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Counter_AccountImage]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Counter_AccountImage](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Voc_Num] [numeric](18, 0) NULL,
	[Counter_ID] [nvarchar](5) NULL,
	[Counter] [nvarchar](50) NULL,
	[Image] [image] NULL,
	[Table_Type] [nvarchar](max) NULL,
	[Des1] [numeric](18, 0) NULL,
	[Des2] [nvarchar](max) NULL,
	[Des3] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Counter_Info]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Counter_Info](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Active] [nvarchar](max) NULL,
	[Counter_ID] [nvarchar](5) NULL,
	[Counter] [nvarchar](60) NULL,
	[Opening_Balance] [numeric](18, 2) NULL,
	[Balance_Type] [nvarchar](max) NULL,
	[Description1] [nvarchar](max) NULL,
	[Description2] [nvarchar](max) NULL,
	[Description3] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Currency]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Currency](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Active] [nvarchar](max) NULL,
	[Currency_ID] [numeric](18, 0) NULL,
	[CurrencyName] [nvarchar](60) NULL,
	[CurrencyShortName] [nvarchar](60) NULL,
	[Country] [nvarchar](60) NULL,
	[Rate] [numeric](18, 2) NULL,
	[Description1] [nvarchar](max) NULL,
	[Description2] [nvarchar](max) NULL,
	[Description3] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Customer_Purchase]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer_Purchase](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Party_ID] [nvarchar](5) NULL,
	[Party] [nvarchar](50) NULL,
	[Address] [nvarchar](100) NULL,
	[Cell_Number] [nvarchar](15) NULL,
	[ID] [nvarchar](5) NULL,
	[Bar_Code2] [nvarchar](20) NULL,
	[QR_Code] [nvarchar](20) NULL,
	[Bar_Code] [nvarchar](20) NULL,
	[Long_Name] [nvarchar](50) NULL,
	[Colour] [nvarchar](max) NULL,
	[Size] [nvarchar](max) NULL,
	[Packing] [nvarchar](max) NULL,
	[Quantity] [nvarchar](max) NULL,
	[Unit] [nvarchar](max) NULL,
	[Price] [numeric](18, 2) NULL,
	[Qty] [nvarchar](max) NULL,
	[Amount] [numeric](18, 2) NULL,
	[Discount] [numeric](18, 2) NULL,
	[Net_Total] [numeric](18, 2) NULL,
	[Supplier_ID] [nvarchar](max) NULL,
	[Supplier] [nvarchar](max) NULL,
	[ProductType] [nvarchar](max) NULL,
	[TransportCompany] [nvarchar](max) NULL,
	[Truck_Num] [nvarchar](max) NULL,
	[Driver_Num] [nvarchar](max) NULL,
	[Sales_PersonID] [nvarchar](5) NULL,
	[Sales_Person] [nvarchar](50) NULL,
	[Table_Type] [nvarchar](max) NULL,
	[Invoice_Total] [numeric](18, 0) NULL,
	[Description2] [numeric](18, 0) NULL,
	[Description3] [nvarchar](max) NULL,
	[Description4] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Customer_PurchasePOS]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer_PurchasePOS](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Party_ID] [nvarchar](5) NULL,
	[Party] [nvarchar](50) NULL,
	[Address] [nvarchar](100) NULL,
	[Cell_Number] [nvarchar](15) NULL,
	[ID] [nvarchar](5) NULL,
	[Bar_Code2] [nvarchar](20) NULL,
	[QR_Code] [nvarchar](20) NULL,
	[Bar_Code] [nvarchar](20) NULL,
	[Long_Name] [nvarchar](50) NULL,
	[Colour] [nvarchar](max) NULL,
	[Size] [nvarchar](max) NULL,
	[Packing] [nvarchar](max) NULL,
	[Quantity] [nvarchar](max) NULL,
	[Unit] [nvarchar](max) NULL,
	[Price] [numeric](18, 2) NULL,
	[Qty] [nvarchar](max) NULL,
	[Amount] [numeric](18, 2) NULL,
	[Discount] [numeric](18, 2) NULL,
	[Net_Total] [numeric](18, 2) NULL,
	[Supplier_ID] [nvarchar](max) NULL,
	[Supplier] [nvarchar](max) NULL,
	[ProductType] [nvarchar](max) NULL,
	[TransportCompany] [nvarchar](max) NULL,
	[Truck_Num] [nvarchar](max) NULL,
	[Driver_Num] [nvarchar](max) NULL,
	[Sales_PersonID] [nvarchar](5) NULL,
	[Sales_Person] [nvarchar](50) NULL,
	[Table_Type] [nvarchar](max) NULL,
	[Invoice_Total] [numeric](18, 0) NULL,
	[Description2] [numeric](18, 0) NULL,
	[Description3] [nvarchar](max) NULL,
	[Description4] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Customer_Return]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer_Return](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Party_ID] [nvarchar](5) NULL,
	[Party] [nvarchar](50) NULL,
	[Address] [nvarchar](100) NULL,
	[Cell_Number] [nvarchar](15) NULL,
	[CNIC] [nvarchar](20) NULL,
	[ID] [nvarchar](5) NULL,
	[Bar_Code2] [nvarchar](20) NULL,
	[QR_Code] [nvarchar](20) NULL,
	[Bar_Code] [nvarchar](20) NULL,
	[Long_Name] [nvarchar](50) NULL,
	[Colour] [nvarchar](max) NULL,
	[Size] [nvarchar](max) NULL,
	[Packing] [nvarchar](max) NULL,
	[Quantity] [nvarchar](max) NULL,
	[Unit] [nvarchar](max) NULL,
	[Price] [numeric](18, 2) NULL,
	[Qty] [nvarchar](max) NULL,
	[Amount] [numeric](18, 2) NULL,
	[Discount] [numeric](18, 2) NULL,
	[Net_Total] [numeric](18, 2) NULL,
	[Supplier] [nvarchar](max) NULL,
	[Supplier_ID] [nvarchar](max) NULL,
	[Table_Type] [nvarchar](max) NULL,
	[Description1] [numeric](18, 0) NULL,
	[Description2] [numeric](18, 0) NULL,
	[Description3] [nvarchar](max) NULL,
	[Description4] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Customer_ReturnPOS]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer_ReturnPOS](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Party_ID] [nvarchar](5) NULL,
	[Party] [nvarchar](50) NULL,
	[Address] [nvarchar](100) NULL,
	[Cell_Number] [nvarchar](15) NULL,
	[ID] [nvarchar](5) NULL,
	[Bar_Code2] [nvarchar](20) NULL,
	[QR_Code] [nvarchar](20) NULL,
	[Bar_Code] [nvarchar](20) NULL,
	[Long_Name] [nvarchar](50) NULL,
	[Colour] [nvarchar](max) NULL,
	[Size] [nvarchar](max) NULL,
	[Packing] [nvarchar](max) NULL,
	[Quantity] [nvarchar](max) NULL,
	[Unit] [nvarchar](max) NULL,
	[Price] [numeric](18, 2) NULL,
	[Qty] [nvarchar](max) NULL,
	[Amount] [numeric](18, 2) NULL,
	[Discount] [numeric](18, 2) NULL,
	[Net_Total] [numeric](18, 2) NULL,
	[Supplier_ID] [nvarchar](max) NULL,
	[Supplier] [nvarchar](max) NULL,
	[ProductType] [nvarchar](max) NULL,
	[TransportCompany] [nvarchar](max) NULL,
	[Truck_Num] [nvarchar](max) NULL,
	[Driver_Num] [nvarchar](max) NULL,
	[Sales_PersonID] [nvarchar](5) NULL,
	[Sales_Person] [nvarchar](50) NULL,
	[Table_Type] [nvarchar](max) NULL,
	[Invoice_Total] [numeric](18, 0) NULL,
	[Description2] [numeric](18, 0) NULL,
	[SalesDate] [date] NULL,
	[SalesInvoice] [numeric](18, 0) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CustomerInvPayment]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomerInvPayment](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](50) NULL,
	[PC] [nvarchar](max) NULL,
	[Voc] [numeric](18, 0) NULL,
	[Voc_Total] [numeric](18, 0) NULL,
	[PartyID] [nvarchar](10) NULL,
	[Party] [nvarchar](50) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Debit] [numeric](18, 2) NULL,
	[Credit] [numeric](18, 2) NULL,
	[LastPayment] [numeric](18, 2) NULL,
	[Table_Type] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CustomerList_checkbox]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomerList_checkbox](
	[AdvSearch] [nvarchar](max) NULL,
	[SearchBy] [nvarchar](max) NULL,
	[ActiveOnly] [nvarchar](max) NULL,
	[ModuleType] [nvarchar](max) NULL,
	[Frm] [nvarchar](max) NULL,
	[Pc] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DataBackup]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DataBackup](
	[DataBackup] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Dateupdate]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dateupdate](
	[Date] [date] NULL,
	[Branch] [nvarchar](max) NULL,
	[Pc] [nvarchar](50) NULL,
	[Updatetype] [nvarchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Discount]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Discount](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Invoice_Return] [numeric](18, 0) NULL,
	[Invoice_Total] [numeric](18, 0) NULL,
	[Return_Total] [numeric](18, 0) NULL,
	[Party_ID] [nvarchar](5) NULL,
	[Party] [nvarchar](50) NULL,
	[Address] [nvarchar](100) NULL,
	[Cell_Number] [nvarchar](15) NULL,
	[Type_Name] [nvarchar](20) NULL,
	[Waiter_ID] [nvarchar](5) NULL,
	[Waiter] [nvarchar](50) NULL,
	[TableID] [nvarchar](5) NULL,
	[Table_Name] [nvarchar](50) NULL,
	[Fix_Dis] [numeric](18, 2) NULL,
	[Diswithper] [numeric](18, 2) NULL,
	[Amount] [numeric](18, 2) NULL,
	[Service_Charges] [numeric](18, 2) NULL,
	[Tax_Total] [numeric](18, 2) NULL,
	[Tax_Per] [numeric](18, 2) NULL,
	[Per_Amount] [numeric](18, 2) NULL,
	[Rents] [numeric](18, 2) NULL,
	[Bulti_Expense] [numeric](18, 2) NULL,
	[Bulti_Expense2] [numeric](18, 2) NULL,
	[Loding_Expense] [numeric](18, 2) NULL,
	[Unload_Expense] [numeric](18, 2) NULL,
	[Other_Expense] [numeric](18, 2) NULL,
	[Other_Expense2] [numeric](18, 2) NULL,
	[Sales_PersonID] [nvarchar](5) NULL,
	[Sales_Person] [nvarchar](50) NULL,
	[Table_Type] [nvarchar](max) NULL,
	[Invoice_Type] [nvarchar](max) NULL,
	[Description1] [numeric](18, 0) NULL,
	[SalesDate] [date] NULL,
	[SalesInvoice] [numeric](18, 0) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DiscountPOS]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DiscountPOS](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Invoice_Return] [numeric](18, 0) NULL,
	[Invoice_Total] [numeric](18, 0) NULL,
	[Return_Total] [numeric](18, 0) NULL,
	[Party_ID] [nvarchar](5) NULL,
	[Party] [nvarchar](50) NULL,
	[Address] [nvarchar](100) NULL,
	[Cell_Number] [nvarchar](15) NULL,
	[Type_Name] [nvarchar](20) NULL,
	[Waiter_ID] [nvarchar](5) NULL,
	[Waiter] [nvarchar](50) NULL,
	[TableID] [nvarchar](5) NULL,
	[Table_Name] [nvarchar](50) NULL,
	[Fix_Dis] [numeric](18, 2) NULL,
	[Diswithper] [numeric](18, 2) NULL,
	[Amount] [numeric](18, 2) NULL,
	[Service_Charges] [numeric](18, 2) NULL,
	[Tax_Total] [numeric](18, 2) NULL,
	[Tax_Per] [numeric](18, 2) NULL,
	[Per_Amount] [numeric](18, 2) NULL,
	[Rents] [numeric](18, 2) NULL,
	[Bulti_Expense] [numeric](18, 2) NULL,
	[Bulti_Expense2] [numeric](18, 2) NULL,
	[Loding_Expense] [numeric](18, 2) NULL,
	[Unload_Expense] [numeric](18, 2) NULL,
	[Other_Expense] [numeric](18, 2) NULL,
	[Other_Expense2] [numeric](18, 2) NULL,
	[Sales_PersonID] [nvarchar](5) NULL,
	[Sales_Person] [nvarchar](50) NULL,
	[Table_Type] [nvarchar](max) NULL,
	[Invoice_Type] [nvarchar](max) NULL,
	[Description1] [numeric](18, 0) NULL,
	[SalesDate] [date] NULL,
	[SalesInvoice] [numeric](18, 0) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DistributorTaxTb]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DistributorTaxTb](
	[Date] [date] NULL,
	[Time] [nvarchar](max) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Sales_Tax] [numeric](18, 2) NULL,
	[Further_SalesTax] [numeric](18, 2) NULL,
	[FED] [numeric](18, 2) NULL,
	[TradeOffer] [numeric](18, 2) NULL,
	[Whole_SaleDiscount] [numeric](18, 2) NULL,
	[Load_Unload] [numeric](18, 2) NULL,
	[Fix_Replacement] [numeric](18, 2) NULL,
	[Handling_Charges] [numeric](18, 2) NULL,
	[Checkbox1] [nvarchar](max) NULL,
	[Checkbox2] [nvarchar](max) NULL,
	[Checkbox3] [nvarchar](max) NULL,
	[Checkbox4] [nvarchar](max) NULL,
	[Checkbox5] [nvarchar](max) NULL,
	[Checkbox6] [nvarchar](max) NULL,
	[ExColumn1] [nvarchar](max) NULL,
	[ExColumn2] [nvarchar](max) NULL,
	[ExColumn3] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Employee_account]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee_account](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Voc_Num] [numeric](18, 0) NULL,
	[Employee_Type] [nvarchar](max) NULL,
	[Employee_ID] [nvarchar](5) NULL,
	[Employee] [nvarchar](50) NULL,
	[Address] [nvarchar](100) NULL,
	[Cell_Number] [nvarchar](15) NULL,
	[CNIC] [nvarchar](20) NULL,
	[Description] [nvarchar](max) NULL,
	[Transaction_ID] [nvarchar](5) NULL,
	[Transaction_From] [nvarchar](max) NULL,
	[Branch1] [nvarchar](max) NULL,
	[Account_NO] [nvarchar](max) NULL,
	[Cheque] [nvarchar](max) NULL,
	[Cheque_Amount] [numeric](18, 2) NULL,
	[Cheque_Category] [nvarchar](50) NULL,
	[Cheque_Date] [date] NULL,
	[Cheque_Status] [nvarchar](50) NULL,
	[Debit] [numeric](18, 2) NULL,
	[Credit] [numeric](18, 2) NULL,
	[Sallary] [numeric](18, 2) NULL,
	[Page1] [nvarchar](50) NULL,
	[Page2] [nvarchar](50) NULL,
	[Ref_NO] [nvarchar](max) NULL,
	[Table_Type] [nvarchar](max) NULL,
	[Description1] [nvarchar](max) NULL,
	[Description2] [nvarchar](max) NULL,
	[Description3] [nvarchar](max) NULL,
	[AccountChecked] [numeric](18, 2) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Employee_Info]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employee_Info](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Image] [image] NULL,
	[Active] [nvarchar](max) NULL,
	[Employee_ID] [nvarchar](5) NULL,
	[Employee] [nvarchar](50) NULL,
	[Address] [nvarchar](100) NULL,
	[Cell_Number] [nvarchar](15) NULL,
	[CNIC] [nvarchar](20) NULL,
	[Email] [nvarchar](max) NULL,
	[Sallary] [nvarchar](20) NULL,
	[Holidays] [nvarchar](20) NULL,
	[Category] [nvarchar](max) NULL,
	[Opening_Balance] [numeric](18, 2) NULL,
	[Balance_Type] [nvarchar](max) NULL,
	[Description1] [nvarchar](max) NULL,
	[Description2] [nvarchar](max) NULL,
	[Description3] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Expense_account]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Expense_account](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Voc_Num] [numeric](18, 0) NULL,
	[Expense_Type] [nvarchar](max) NULL,
	[Expense_ID] [nvarchar](5) NULL,
	[Expense] [nvarchar](50) NULL,
	[Description] [nvarchar](max) NULL,
	[Transaction_ID] [nvarchar](5) NULL,
	[Transaction_From] [nvarchar](max) NULL,
	[Branch1] [nvarchar](max) NULL,
	[Account_NO] [nvarchar](max) NULL,
	[Cheque] [nvarchar](max) NULL,
	[Cheque_Amount] [numeric](18, 2) NULL,
	[Cheque_Category] [nvarchar](50) NULL,
	[Cheque_Date] [date] NULL,
	[Cheque_Status] [nvarchar](50) NULL,
	[Debit] [numeric](18, 2) NULL,
	[Credit] [numeric](18, 2) NULL,
	[Currency] [nvarchar](50) NULL,
	[Exchange_Rate] [numeric](18, 2) NULL,
	[Currency_Amount] [numeric](18, 2) NULL,
	[Page1] [nvarchar](50) NULL,
	[Page2] [nvarchar](50) NULL,
	[Ref_NO] [nvarchar](max) NULL,
	[Table_Type] [nvarchar](max) NULL,
	[Description1] [nvarchar](max) NULL,
	[Description2] [nvarchar](max) NULL,
	[Description3] [nvarchar](max) NULL,
	[AccountChecked] [numeric](18, 2) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Expense_AccountImage]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Expense_AccountImage](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Voc_Num] [numeric](18, 0) NULL,
	[Type_Name] [nvarchar](50) NULL,
	[Expense_ID] [nvarchar](5) NULL,
	[Expense] [nvarchar](50) NULL,
	[Image] [image] NULL,
	[Table_Type] [nvarchar](max) NULL,
	[Des1] [numeric](18, 0) NULL,
	[Des2] [nvarchar](max) NULL,
	[Des3] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Expense_Info]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Expense_Info](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Active] [nvarchar](max) NULL,
	[Expense_ID] [nvarchar](5) NULL,
	[Expense] [nvarchar](60) NULL,
	[Account_Type] [nvarchar](50) NULL,
	[Opening_Balance] [numeric](18, 2) NULL,
	[Balance_Type] [nvarchar](max) NULL,
	[Description1] [nvarchar](max) NULL,
	[Description2] [nvarchar](max) NULL,
	[Description3] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Hold_Invoice]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Hold_Invoice](
	[Date] [date] NULL,
	[Time] [nvarchar](max) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Invoice_Return] [numeric](18, 0) NULL,
	[Invoice_Total] [numeric](18, 0) NULL,
	[Return_Total] [numeric](18, 0) NULL,
	[Waiter_ID] [nvarchar](5) NULL,
	[Waiter] [nvarchar](60) NULL,
	[Table_ID] [nvarchar](5) NULL,
	[Table_N] [nvarchar](60) NULL,
	[Party_Voc] [numeric](18, 0) NULL,
	[Party_ID] [nvarchar](5) NULL,
	[Party] [nvarchar](50) NULL,
	[Address] [nvarchar](100) NULL,
	[Cell_Number] [nvarchar](15) NULL,
	[Type_Name] [nvarchar](20) NULL,
	[Pre_Balance] [numeric](18, 2) NULL,
	[New_Balance] [numeric](18, 2) NULL,
	[Description1] [nvarchar](max) NULL,
	[Description2] [nvarchar](max) NULL,
	[ID] [nvarchar](5) NULL,
	[Bar_Code2] [nvarchar](20) NULL,
	[QR_Code] [nvarchar](20) NULL,
	[Bar_Code] [nvarchar](20) NULL,
	[Short_Name] [nvarchar](50) NULL,
	[Long_Name] [nvarchar](50) NULL,
	[Colour] [nvarchar](20) NULL,
	[Size] [nvarchar](20) NULL,
	[Packing] [nvarchar](max) NULL,
	[Quantity] [nvarchar](max) NULL,
	[Unit] [nvarchar](max) NULL,
	[Price] [numeric](18, 2) NULL,
	[Qty] [nvarchar](max) NULL,
	[Amount] [numeric](18, 2) NULL,
	[Discount] [numeric](18, 2) NULL,
	[Discountper] [numeric](18, 2) NULL,
	[GiftDis] [numeric](18, 2) NULL,
	[T_Dis] [numeric](18, 2) NULL,
	[Net_Total] [numeric](18, 2) NULL,
	[Price2] [numeric](18, 2) NULL,
	[Qty2] [nvarchar](max) NULL,
	[Unit2] [nvarchar](max) NULL,
	[Amount2] [numeric](18, 2) NULL,
	[Dis2] [numeric](18, 2) NULL,
	[Per_Pcs] [numeric](18, 2) NULL,
	[DisPer] [numeric](18, 2) NULL,
	[GiftDis2] [numeric](18, 2) NULL,
	[Total2] [numeric](18, 2) NULL,
	[Purchase] [numeric](18, 2) NULL,
	[Avg_Price] [numeric](18, 2) NULL,
	[Profit] [numeric](18, 2) NULL,
	[Low_Stock] [numeric](18, 2) NULL,
	[Category_ID] [nvarchar](4) NULL,
	[Category] [nvarchar](max) NULL,
	[Company_ID] [nvarchar](4) NULL,
	[Company] [nvarchar](max) NULL,
	[Supplier_ID] [nvarchar](5) NULL,
	[Supplier] [nvarchar](max) NULL,
	[Difference] [numeric](18, 2) NULL,
	[Sales_Type] [nchar](10) NULL,
	[Des1] [numeric](18, 0) NULL,
	[Des2] [numeric](18, 0) NULL,
	[Warehouse_ID] [numeric](18, 0) NULL,
	[WareHouse] [nvarchar](50) NULL,
	[Ware_Address] [nvarchar](max) NULL,
	[Gross_Total] [numeric](18, 2) NULL,
	[FlatDis] [numeric](18, 2) NULL,
	[PerDis] [numeric](18, 2) NULL,
	[PerDisAmt] [numeric](18, 2) NULL,
	[Net_Gross] [numeric](18, 2) NULL,
	[Service_Charges] [numeric](18, 2) NULL,
	[Delivery_Charges] [numeric](18, 2) NULL,
	[Tax_Total] [numeric](18, 2) NULL,
	[Tax_Per] [numeric](18, 2) NULL,
	[Sub_Total] [numeric](18, 2) NULL,
	[Cash_Recived] [numeric](18, 2) NULL,
	[Cash_Charged] [numeric](18, 2) NULL,
	[Cash_Back] [numeric](18, 2) NULL,
	[Cash_back2] [numeric](18, 2) NULL,
	[Comments] [nvarchar](100) NULL,
	[Printer] [nvarchar](max) NULL,
	[PaymentMode] [nvarchar](max) NULL,
	[PaymentDate] [date] NULL,
	[Counter_ID] [nvarchar](5) NULL,
	[Counter] [nvarchar](60) NULL,
	[Counter_Voc] [numeric](18, 0) NULL,
	[Stock_Voc] [numeric](18, 0) NULL,
	[Table_Type] [nvarchar](max) NULL,
	[Invoice_Type] [nvarchar](max) NULL,
	[Ref_No] [nvarchar](max) NULL,
	[Description4] [numeric](18, 0) NULL,
	[Description5] [nvarchar](max) NULL,
	[Area] [nvarchar](60) NULL,
	[Description7] [nvarchar](max) NULL,
	[TransportCompany] [nvarchar](max) NULL,
	[Truck_Num] [nvarchar](max) NULL,
	[Driver_Num] [nvarchar](max) NULL,
	[Bulti_Expense] [numeric](18, 2) NULL,
	[Bulti_Expense2] [numeric](18, 2) NULL,
	[Loding_Expense] [numeric](18, 2) NULL,
	[Unload_Expense] [numeric](18, 2) NULL,
	[Other_Expense] [numeric](18, 2) NULL,
	[Other_Expense2] [numeric](18, 2) NULL,
	[Sales_PersonID] [nvarchar](5) NULL,
	[Sales_Person] [nvarchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[images]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[images](
	[Branch] [nvarchar](max) NULL,
	[Current_Branch] [nvarchar](max) NULL,
	[Code] [numeric](18, 0) NULL,
	[Image] [image] NULL,
	[Image2] [image] NULL,
	[Image3] [image] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Invoice_Account]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Invoice_Account](
	[Account_Code] [nvarchar](5) NULL,
	[Invoice_Account] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Invoice_Discount]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Invoice_Discount](
	[DiscountType] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Invoice_Master]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Invoice_Master](
	[Date] [date] NULL,
	[Time] [nvarchar](max) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Invoice_Return] [numeric](18, 0) NULL,
	[Invoice_Total] [numeric](18, 0) NULL,
	[Return_Total] [numeric](18, 0) NULL,
	[Waiter_ID] [nvarchar](5) NULL,
	[Waiter] [nvarchar](60) NULL,
	[Table_ID] [nvarchar](5) NULL,
	[Table_N] [nvarchar](60) NULL,
	[Party_Voc] [numeric](18, 0) NULL,
	[Party_ID] [nvarchar](5) NULL,
	[Party] [nvarchar](50) NULL,
	[Address] [nvarchar](100) NULL,
	[Cell_Number] [nvarchar](15) NULL,
	[Type_Name] [nvarchar](20) NULL,
	[Pre_Balance] [numeric](18, 2) NULL,
	[New_Balance] [numeric](18, 2) NULL,
	[Description1] [nvarchar](max) NULL,
	[Description2] [nvarchar](max) NULL,
	[ID] [nvarchar](5) NULL,
	[Bar_Code2] [nvarchar](20) NULL,
	[QR_Code] [nvarchar](20) NULL,
	[Bar_Code] [nvarchar](20) NULL,
	[Short_Name] [nvarchar](50) NULL,
	[Long_Name] [nvarchar](50) NULL,
	[Colour] [nvarchar](20) NULL,
	[Size] [nvarchar](20) NULL,
	[Packing] [nvarchar](max) NULL,
	[Quantity] [nvarchar](max) NULL,
	[Unit] [nvarchar](max) NULL,
	[Price] [numeric](18, 2) NULL,
	[Qty] [nvarchar](max) NULL,
	[Amount] [numeric](18, 2) NULL,
	[Discount] [numeric](18, 2) NULL,
	[Discountper] [numeric](18, 2) NULL,
	[GiftDis] [numeric](18, 2) NULL,
	[T_Dis] [numeric](18, 2) NULL,
	[Net_Total] [numeric](18, 2) NULL,
	[Price2] [numeric](18, 2) NULL,
	[Qty2] [nvarchar](max) NULL,
	[Unit2] [nvarchar](max) NULL,
	[Amount2] [numeric](18, 2) NULL,
	[Dis2] [numeric](18, 2) NULL,
	[Per_Pcs] [numeric](18, 2) NULL,
	[DisPer] [numeric](18, 2) NULL,
	[GiftDis2] [numeric](18, 2) NULL,
	[Total2] [numeric](18, 2) NULL,
	[Purchase] [numeric](18, 2) NULL,
	[Avg_Price] [numeric](18, 2) NULL,
	[Profit] [numeric](18, 2) NULL,
	[Low_Stock] [numeric](18, 2) NULL,
	[Category_ID] [nvarchar](4) NULL,
	[Category] [nvarchar](max) NULL,
	[Company_ID] [nvarchar](4) NULL,
	[Company] [nvarchar](max) NULL,
	[Supplier_ID] [nvarchar](5) NULL,
	[Supplier] [nvarchar](max) NULL,
	[Difference] [numeric](18, 2) NULL,
	[Sales_Type] [nchar](10) NULL,
	[Des1] [numeric](18, 0) NULL,
	[Des2] [numeric](18, 0) NULL,
	[Warehouse_ID] [numeric](18, 0) NULL,
	[WareHouse] [nvarchar](50) NULL,
	[Ware_Address] [nvarchar](max) NULL,
	[Gross_Total] [numeric](18, 2) NULL,
	[FlatDis] [numeric](18, 2) NULL,
	[PerDis] [numeric](18, 2) NULL,
	[PerDisAmt] [numeric](18, 2) NULL,
	[Net_Gross] [numeric](18, 2) NULL,
	[Service_Charges] [numeric](18, 2) NULL,
	[Delivery_Charges] [numeric](18, 2) NULL,
	[Tax_Total] [numeric](18, 2) NULL,
	[Tax_Per] [numeric](18, 2) NULL,
	[Sub_Total] [numeric](18, 2) NULL,
	[Cash_Recived] [numeric](18, 2) NULL,
	[Cash_Charged] [numeric](18, 2) NULL,
	[Cash_Back] [numeric](18, 2) NULL,
	[Cash_back2] [numeric](18, 2) NULL,
	[Comments] [nvarchar](100) NULL,
	[Printer] [nvarchar](max) NULL,
	[PaymentMode] [nvarchar](max) NULL,
	[PaymentDate] [date] NULL,
	[Counter_ID] [nvarchar](5) NULL,
	[Counter] [nvarchar](60) NULL,
	[Counter_Voc] [numeric](18, 0) NULL,
	[Stock_Voc] [numeric](18, 0) NULL,
	[Table_Type] [nvarchar](max) NULL,
	[Invoice_Type] [nvarchar](max) NULL,
	[Ref_No] [nvarchar](max) NULL,
	[Description4] [numeric](18, 0) NULL,
	[Description5] [nvarchar](max) NULL,
	[Area] [nvarchar](60) NULL,
	[Description7] [nvarchar](max) NULL,
	[TransportCompany] [nvarchar](max) NULL,
	[Truck_Num] [nvarchar](max) NULL,
	[Driver_Num] [nvarchar](max) NULL,
	[Bulti_Expense] [numeric](18, 2) NULL,
	[Bulti_Expense2] [numeric](18, 2) NULL,
	[Loding_Expense] [numeric](18, 2) NULL,
	[Unload_Expense] [numeric](18, 2) NULL,
	[Other_Expense] [numeric](18, 2) NULL,
	[Other_Expense2] [numeric](18, 2) NULL,
	[Sales_PersonID] [nvarchar](5) NULL,
	[Sales_Person] [nvarchar](50) NULL,
	[Qty_W] [numeric](18, 2) NULL,
	[Unit_W] [nvarchar](50) NULL,
	[RateInBill] [numeric](18, 2) NULL,
	[RateType] [nvarchar](10) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Invoice_MasterDeletePOS]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Invoice_MasterDeletePOS](
	[Date] [date] NULL,
	[Time] [nvarchar](max) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Invoice_Return] [numeric](18, 0) NULL,
	[Invoice_Total] [numeric](18, 0) NULL,
	[Return_Total] [numeric](18, 0) NULL,
	[Waiter_ID] [nvarchar](5) NULL,
	[Waiter] [nvarchar](60) NULL,
	[Table_ID] [nvarchar](5) NULL,
	[Table_N] [nvarchar](60) NULL,
	[Party_Voc] [numeric](18, 0) NULL,
	[Party_ID] [nvarchar](5) NULL,
	[Party] [nvarchar](50) NULL,
	[Address] [nvarchar](100) NULL,
	[Cell_Number] [nvarchar](15) NULL,
	[Type_Name] [nvarchar](20) NULL,
	[Pre_Balance] [numeric](18, 2) NULL,
	[New_Balance] [numeric](18, 2) NULL,
	[Description1] [nvarchar](max) NULL,
	[Description2] [nvarchar](max) NULL,
	[ID] [nvarchar](5) NULL,
	[Bar_Code2] [nvarchar](20) NULL,
	[QR_Code] [nvarchar](20) NULL,
	[Bar_Code] [nvarchar](20) NULL,
	[Short_Name] [nvarchar](50) NULL,
	[Long_Name] [nvarchar](50) NULL,
	[Colour] [nvarchar](max) NULL,
	[Size] [nvarchar](max) NULL,
	[Packing] [nvarchar](max) NULL,
	[Quantity] [nvarchar](max) NULL,
	[Unit] [nvarchar](max) NULL,
	[Price] [numeric](18, 2) NULL,
	[Qty] [nvarchar](max) NULL,
	[Amount] [numeric](18, 2) NULL,
	[Discount] [numeric](18, 2) NULL,
	[Discountper] [numeric](18, 2) NULL,
	[GiftDis] [numeric](18, 2) NULL,
	[T_Dis] [numeric](18, 2) NULL,
	[Net_Total] [numeric](18, 2) NULL,
	[Price2] [numeric](18, 2) NULL,
	[Qty2] [nvarchar](max) NULL,
	[Unit2] [nvarchar](max) NULL,
	[Amount2] [numeric](18, 2) NULL,
	[Dis2] [numeric](18, 2) NULL,
	[Per_Pcs] [numeric](18, 2) NULL,
	[DisPer] [nvarchar](max) NULL,
	[GiftDis2] [numeric](18, 2) NULL,
	[Total2] [numeric](18, 2) NULL,
	[Purchase] [numeric](18, 2) NULL,
	[Avg_Price] [numeric](18, 2) NULL,
	[Profit] [numeric](18, 2) NULL,
	[Low_Stock] [numeric](18, 2) NULL,
	[Category_ID] [nvarchar](4) NULL,
	[Category] [nvarchar](max) NULL,
	[Company_ID] [nvarchar](4) NULL,
	[Company] [nvarchar](max) NULL,
	[Supplier_ID] [nvarchar](5) NULL,
	[Supplier] [nvarchar](max) NULL,
	[Difference] [numeric](18, 2) NULL,
	[Sales_Type] [nchar](10) NULL,
	[Des1] [numeric](18, 0) NULL,
	[Des2] [numeric](18, 0) NULL,
	[Warehouse_ID] [numeric](18, 0) NULL,
	[WareHouse] [nvarchar](50) NULL,
	[Ware_Address] [nvarchar](max) NULL,
	[Gross_Total] [numeric](18, 2) NULL,
	[FlatDis] [numeric](18, 2) NULL,
	[PerDis] [numeric](18, 2) NULL,
	[PerDisAmt] [numeric](18, 2) NULL,
	[Net_Gross] [numeric](18, 2) NULL,
	[Service_Charges] [numeric](18, 2) NULL,
	[Delivery_Charges] [numeric](18, 2) NULL,
	[Tax_Total] [numeric](18, 2) NULL,
	[Tax_Per] [numeric](18, 2) NULL,
	[Sub_Total] [numeric](18, 2) NULL,
	[Cash_Recived] [numeric](18, 2) NULL,
	[Cash_Charged] [numeric](18, 2) NULL,
	[Cash_Back] [numeric](18, 2) NULL,
	[Cash_back2] [numeric](18, 2) NULL,
	[Comments] [nvarchar](100) NULL,
	[Printer] [nvarchar](max) NULL,
	[PaymentMode] [nvarchar](max) NULL,
	[PaymentDate] [date] NULL,
	[Counter_ID] [nvarchar](5) NULL,
	[Counter] [nvarchar](60) NULL,
	[Counter_Voc] [numeric](18, 0) NULL,
	[Stock_Voc] [numeric](18, 0) NULL,
	[Table_Type] [nvarchar](max) NULL,
	[Invoice_Type] [nvarchar](max) NULL,
	[Ref_No] [nvarchar](max) NULL,
	[Description4] [numeric](18, 0) NULL,
	[Description5] [nvarchar](max) NULL,
	[Area] [nvarchar](60) NULL,
	[Description7] [nvarchar](max) NULL,
	[TransportCompany] [nvarchar](max) NULL,
	[Truck_Num] [nvarchar](max) NULL,
	[Driver_Num] [nvarchar](max) NULL,
	[Bulti_Expense] [numeric](18, 2) NULL,
	[Bulti_Expense2] [numeric](18, 2) NULL,
	[Loding_Expense] [numeric](18, 2) NULL,
	[Unload_Expense] [numeric](18, 2) NULL,
	[Other_Expense] [numeric](18, 2) NULL,
	[Other_Expense2] [numeric](18, 2) NULL,
	[Sales_PersonID] [nvarchar](5) NULL,
	[Sales_Person] [nvarchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Invoice_Master-New]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Invoice_Master-New](
	[Time] [nvarchar](15) NULL,
	[User_Name] [nvarchar](50) NULL,
	[Branch] [nvarchar](60) NULL,
	[PC] [nvarchar](60) NULL,
	[Date] [date] NULL,
	[OrderDate] [date] NULL,
	[PaymentDate] [date] NULL,
	[SalesPersonID] [int] NULL,
	[SalesPerson] [nvarchar](50) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[InvoiceTotal] [numeric](18, 0) NULL,
	[CheckBox] [nchar](10) NULL,
	[PartyID] [int] NULL,
	[Party] [nvarchar](50) NULL,
	[PreBalance] [numeric](18, 2) NULL,
	[ID] [numeric](18, 0) NULL,
	[Barcode] [nvarchar](22) NULL,
	[Product] [nvarchar](80) NULL,
	[QtyNum] [nvarchar](50) NULL,
	[UnitNum] [nvarchar](15) NULL,
	[QtyKg] [nvarchar](15) NULL,
	[UnitKg] [nvarchar](10) NULL,
	[Price] [numeric](18, 2) NULL,
	[PriceKg] [numeric](18, 2) NULL,
	[Amount] [numeric](18, 2) NULL,
	[Discount] [numeric](18, 2) NULL,
	[DisAmt] [numeric](18, 2) NULL,
	[GrossAmt] [numeric](18, 2) NULL,
	[SalesTax] [numeric](18, 2) NULL,
	[SaleTax_Amt] [numeric](18, 2) NULL,
	[FurtherTax] [numeric](18, 2) NULL,
	[FurtherTax_Amt] [numeric](18, 2) NULL,
	[Fed] [numeric](18, 2) NULL,
	[Fed_Amt] [numeric](18, 2) NULL,
	[TotalWithTax] [numeric](18, 2) NULL,
	[TradeOffer] [numeric](18, 2) NULL,
	[Trade_Amt] [numeric](18, 2) NULL,
	[WholeSale] [numeric](18, 2) NULL,
	[WholeSale_Amt] [numeric](18, 2) NULL,
	[LoadValue] [numeric](18, 2) NULL,
	[Load_Amt] [numeric](18, 2) NULL,
	[FixRep] [numeric](18, 2) NULL,
	[FixRep_Amt] [numeric](18, 2) NULL,
	[Handling] [numeric](18, 2) NULL,
	[Handling_Amt] [numeric](18, 2) NULL,
	[Net_Amt] [numeric](18, 2) NULL,
	[Price2] [numeric](18, 2) NULL,
	[Qty2] [numeric](18, 2) NULL,
	[Unit2] [nvarchar](15) NULL,
	[Purchase] [numeric](18, 2) NULL,
	[Profit] [numeric](18, 2) NULL,
	[PurchaseKg] [numeric](18, 2) NULL,
	[LowStock] [numeric](18, 2) NULL,
	[CategoryID] [nvarchar](50) NULL,
	[Category] [nvarchar](50) NULL,
	[CompanyID] [nvarchar](50) NULL,
	[Company] [nvarchar](50) NULL,
	[SupplierID] [nvarchar](50) NULL,
	[Supplier] [nvarchar](50) NULL,
	[Size] [nvarchar](20) NULL,
	[Color] [nvarchar](20) NULL,
	[ProductType] [nvarchar](20) NULL,
	[Packing] [nvarchar](15) NULL,
	[QtyNumber] [numeric](18, 2) NULL,
	[UnitNumber] [nvarchar](50) NULL,
	[QtyWeight] [numeric](18, 2) NULL,
	[UnitWeight] [nvarchar](50) NULL,
	[Difference] [numeric](18, 2) NULL,
	[WareHouseID] [nvarchar](50) NULL,
	[WareHouse] [nvarchar](50) NULL,
	[Address] [nvarchar](50) NULL,
	[Breakage] [numeric](18, 2) NULL,
	[B_Unit] [nvarchar](15) NULL,
	[B_Amt] [numeric](18, 2) NULL,
	[PartnerShipCode] [nvarchar](100) NULL,
	[Partner] [nvarchar](50) NULL,
	[partnerID] [nvarchar](50) NULL,
	[Avgprice] [numeric](18, 2) NULL,
	[Remarks] [nvarchar](50) NULL,
	[Cash_Paid] [numeric](18, 2) NULL,
	[Des1] [nchar](10) NULL,
	[Des2] [nchar](10) NULL,
	[Des3] [nchar](10) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Invoice_MasterPOS]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Invoice_MasterPOS](
	[Date] [date] NULL,
	[Time] [nvarchar](max) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Invoice_Return] [numeric](18, 0) NULL,
	[Invoice_Total] [numeric](18, 0) NULL,
	[Return_Total] [numeric](18, 0) NULL,
	[Waiter_ID] [nvarchar](5) NULL,
	[Waiter] [nvarchar](60) NULL,
	[Table_ID] [nvarchar](5) NULL,
	[Table_N] [nvarchar](60) NULL,
	[Party_Voc] [numeric](18, 0) NULL,
	[Party_ID] [nvarchar](5) NULL,
	[Party] [nvarchar](50) NULL,
	[Address] [nvarchar](100) NULL,
	[Cell_Number] [nvarchar](15) NULL,
	[Type_Name] [nvarchar](20) NULL,
	[Pre_Balance] [numeric](18, 2) NULL,
	[New_Balance] [numeric](18, 2) NULL,
	[Description1] [nvarchar](max) NULL,
	[Description2] [nvarchar](max) NULL,
	[ID] [nvarchar](5) NULL,
	[Bar_Code2] [nvarchar](20) NULL,
	[QR_Code] [nvarchar](20) NULL,
	[Bar_Code] [nvarchar](20) NULL,
	[Short_Name] [nvarchar](50) NULL,
	[Long_Name] [nvarchar](50) NULL,
	[Colour] [nvarchar](max) NULL,
	[Size] [nvarchar](max) NULL,
	[Packing] [nvarchar](max) NULL,
	[Quantity] [nvarchar](max) NULL,
	[Unit] [nvarchar](max) NULL,
	[Price] [numeric](18, 2) NULL,
	[Qty] [nvarchar](max) NULL,
	[Amount] [numeric](18, 2) NULL,
	[Discount] [numeric](18, 2) NULL,
	[Discountper] [numeric](18, 2) NULL,
	[GiftDis] [numeric](18, 2) NULL,
	[T_Dis] [numeric](18, 2) NULL,
	[Net_Total] [numeric](18, 2) NULL,
	[Price2] [numeric](18, 2) NULL,
	[Qty2] [nvarchar](max) NULL,
	[Unit2] [nvarchar](max) NULL,
	[Amount2] [numeric](18, 2) NULL,
	[Dis2] [numeric](18, 2) NULL,
	[Per_Pcs] [numeric](18, 2) NULL,
	[DisPer] [nvarchar](max) NULL,
	[GiftDis2] [numeric](18, 2) NULL,
	[Total2] [numeric](18, 2) NULL,
	[Purchase] [numeric](18, 2) NULL,
	[Avg_Price] [numeric](18, 2) NULL,
	[Profit] [numeric](18, 2) NULL,
	[Low_Stock] [numeric](18, 2) NULL,
	[Category_ID] [nvarchar](4) NULL,
	[Category] [nvarchar](max) NULL,
	[Company_ID] [nvarchar](4) NULL,
	[Company] [nvarchar](max) NULL,
	[Supplier_ID] [nvarchar](5) NULL,
	[Supplier] [nvarchar](max) NULL,
	[Difference] [numeric](18, 2) NULL,
	[Sales_Type] [nchar](10) NULL,
	[Des1] [numeric](18, 0) NULL,
	[Des2] [numeric](18, 0) NULL,
	[Warehouse_ID] [numeric](18, 0) NULL,
	[WareHouse] [nvarchar](50) NULL,
	[Ware_Address] [nvarchar](max) NULL,
	[Gross_Total] [numeric](18, 2) NULL,
	[FlatDis] [numeric](18, 2) NULL,
	[PerDis] [numeric](18, 2) NULL,
	[PerDisAmt] [numeric](18, 2) NULL,
	[Net_Gross] [numeric](18, 2) NULL,
	[Service_Charges] [numeric](18, 2) NULL,
	[Delivery_Charges] [numeric](18, 2) NULL,
	[Tax_Total] [numeric](18, 2) NULL,
	[Tax_Per] [numeric](18, 2) NULL,
	[Sub_Total] [numeric](18, 2) NULL,
	[Cash_Recived] [numeric](18, 2) NULL,
	[Cash_Charged] [numeric](18, 2) NULL,
	[Cash_Back] [numeric](18, 2) NULL,
	[Cash_back2] [numeric](18, 2) NULL,
	[Comments] [nvarchar](100) NULL,
	[Printer] [nvarchar](max) NULL,
	[PaymentMode] [nvarchar](max) NULL,
	[PaymentDate] [date] NULL,
	[Counter_ID] [nvarchar](5) NULL,
	[Counter] [nvarchar](60) NULL,
	[Counter_Voc] [numeric](18, 0) NULL,
	[Stock_Voc] [numeric](18, 0) NULL,
	[Table_Type] [nvarchar](max) NULL,
	[Invoice_Type] [nvarchar](max) NULL,
	[Ref_No] [nvarchar](max) NULL,
	[Description4] [numeric](18, 0) NULL,
	[Description5] [nvarchar](max) NULL,
	[Area] [nvarchar](60) NULL,
	[Description7] [nvarchar](max) NULL,
	[TransportCompany] [nvarchar](max) NULL,
	[Truck_Num] [nvarchar](max) NULL,
	[Driver_Num] [nvarchar](max) NULL,
	[Bulti_Expense] [numeric](18, 2) NULL,
	[Bulti_Expense2] [numeric](18, 2) NULL,
	[Loding_Expense] [numeric](18, 2) NULL,
	[Unload_Expense] [numeric](18, 2) NULL,
	[Other_Expense] [numeric](18, 2) NULL,
	[Other_Expense2] [numeric](18, 2) NULL,
	[Sales_PersonID] [nvarchar](5) NULL,
	[Sales_Person] [nvarchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Invoice_Num]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Invoice_Num](
	[Date] [date] NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Invoice_Return] [numeric](18, 0) NULL,
	[Total_Invoice] [numeric](18, 0) NULL,
	[Total_Return] [numeric](18, 0) NULL,
	[Hold] [numeric](18, 0) NULL,
	[Hold_Return] [numeric](18, 0) NULL,
	[Description] [nvarchar](50) NULL,
	[Invoice_Type] [nvarchar](50) NULL,
	[Branch] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Invoice_NumNew]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Invoice_NumNew](
	[Date] [date] NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Invoice_Return] [numeric](18, 0) NULL,
	[Total_Invoice] [numeric](18, 0) NULL,
	[Total_Return] [numeric](18, 0) NULL,
	[Hold] [numeric](18, 0) NULL,
	[Hold_Return] [numeric](18, 0) NULL,
	[Order_Num] [numeric](18, 0) NULL,
	[Order_Total] [numeric](18, 0) NULL,
	[Description] [nvarchar](50) NULL,
	[Invoice_Type] [nvarchar](50) NULL,
	[Branch] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[InvoiceCheckbox]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InvoiceCheckbox](
	[Checkbox] [nvarchar](50) NULL,
	[Branch] [nvarchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[InvoiceDis]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InvoiceDis](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Invoice_Return] [numeric](18, 0) NULL,
	[Invoice_Total] [numeric](18, 0) NULL,
	[Return_Total] [numeric](18, 0) NULL,
	[Party_ID] [nvarchar](5) NULL,
	[Party] [nvarchar](50) NULL,
	[FlatDis] [numeric](18, 2) NULL,
	[Dis] [numeric](18, 2) NULL,
	[DisAmount] [numeric](18, 2) NULL,
	[Rent] [nchar](10) NULL,
	[OtherExp] [nchar](10) NULL,
	[Tax] [nchar](10) NULL,
	[TaxValue] [nchar](10) NULL,
	[Commission] [nchar](10) NULL,
	[CommValue] [nchar](10) NULL,
	[TransportCom] [nvarchar](50) NULL,
	[Bilty] [nvarchar](20) NULL,
	[Driver] [nvarchar](50) NULL,
	[DriverCell] [nvarchar](15) NULL,
	[Vechile] [nvarchar](10) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Journal_Gernal]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Journal_Gernal](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Debit_Type] [nvarchar](max) NULL,
	[Account_Name] [nvarchar](max) NULL,
	[Account_ID] [nvarchar](5) NULL,
	[Account_Contact] [nvarchar](max) NULL,
	[Account_Address] [nvarchar](max) NULL,
	[Account_CNIC] [nvarchar](max) NULL,
	[Account_Type] [nvarchar](max) NULL,
	[Type_Name] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[Debit] [numeric](18, 2) NULL,
	[Credit_Type] [nvarchar](max) NULL,
	[Account_Name1] [nvarchar](max) NULL,
	[Account_ID1] [nvarchar](5) NULL,
	[Account_Contact1] [nvarchar](max) NULL,
	[Account_Address1] [nvarchar](max) NULL,
	[Account_CNIC1] [nvarchar](max) NULL,
	[Account_Type1] [nvarchar](max) NULL,
	[Type_Name1] [nvarchar](max) NULL,
	[Description1] [nvarchar](max) NULL,
	[Credit] [numeric](18, 2) NULL,
	[Voc_Debit] [numeric](18, 0) NULL,
	[Voc_Credit] [numeric](18, 0) NULL,
	[Cheque_Num] [nvarchar](max) NULL,
	[Cheque_Date] [date] NULL,
	[Cheque_Category] [nvarchar](max) NULL,
	[Cheque_Status] [nvarchar](max) NULL,
	[Cheque_Account] [nvarchar](max) NULL,
	[Print_Debit] [nvarchar](max) NULL,
	[Print_Credit] [nvarchar](max) NULL,
	[Transaction_Type] [nvarchar](max) NULL,
	[Currency] [nvarchar](50) NULL,
	[Exchange_Rate] [numeric](18, 2) NULL,
	[Currency_Amount] [numeric](18, 2) NULL,
	[InvoiceReceive_Amount] [numeric](18, 2) NULL,
	[InvoiceReceiveNum] [numeric](18, 0) NULL,
	[Sales_PersonID] [nvarchar](5) NULL,
	[Sales_Person] [nvarchar](50) NULL,
	[Description2] [nvarchar](max) NULL,
	[Description3] [nvarchar](max) NULL,
	[Description4] [nvarchar](max) NULL,
	[Page1] [nvarchar](max) NULL,
	[Page2] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[JournalEntry]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JournalEntry](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](50) NULL,
	[PC] [nvarchar](max) NULL,
	[SelectedTab] [nvarchar](20) NULL,
	[SelectedTab2] [nvarchar](20) NULL,
	[DC] [nvarchar](10) NULL,
	[Voc] [numeric](18, 0) NULL,
	[Voc_Total] [numeric](18, 0) NULL,
	[Currency] [nvarchar](20) NULL,
	[CurrencyRate] [numeric](18, 2) NULL,
	[Country] [nvarchar](20) NULL,
	[CurrencyID] [nvarchar](10) NULL,
	[PartyID] [nvarchar](10) NULL,
	[Party] [nvarchar](50) NULL,
	[Contact] [nchar](15) NULL,
	[Address] [nvarchar](50) NULL,
	[Cnic] [nchar](20) NULL,
	[Type] [nvarchar](10) NULL,
	[TypeName] [nvarchar](15) NULL,
	[PreBalance] [numeric](18, 2) NULL,
	[Details] [nvarchar](max) NULL,
	[PaymentMode] [nvarchar](10) NULL,
	[Page1] [nvarchar](10) NULL,
	[Page2] [nvarchar](10) NULL,
	[Amount] [numeric](18, 2) NULL,
	[DebitPkr] [numeric](18, 2) NULL,
	[CreditPkr] [numeric](18, 2) NULL,
	[Bank] [nvarchar](50) NULL,
	[ID] [nvarchar](10) NULL,
	[Acc] [nvarchar](20) NULL,
	[BankAddress] [nvarchar](50) NULL,
	[Cheque] [nvarchar](50) NULL,
	[CheqeDate] [date] NULL,
	[ChequeType] [nvarchar](10) NULL,
	[ChequeStatus] [nvarchar](10) NULL,
	[Sales_PersonID] [nvarchar](5) NULL,
	[Sales_Person] [nvarchar](50) NULL,
	[Serail] [numeric](18, 0) NULL,
	[Des] [numeric](18, 0) NULL,
	[Des2] [numeric](18, 0) NULL,
	[Des3] [nvarchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Login]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Login](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Image] [image] NULL,
	[AccountNum] [numeric](18, 0) NULL,
	[Account_Type] [nvarchar](max) NULL,
	[UserName] [nvarchar](max) NULL,
	[User_ID] [nvarchar](max) NULL,
	[Password] [nvarchar](max) NULL,
	[Address] [nvarchar](max) NULL,
	[Mobile] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[login_Time]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[login_Time](
	[Date] [date] NULL,
	[Time] [time](7) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[User_ID] [nvarchar](50) NULL,
	[User_Name] [nvarchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MultiBar_checkbox]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MultiBar_checkbox](
	[MultiBarCode] [nvarchar](max) NULL,
	[Frm] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[order_Details]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[order_Details](
	[Date] [date] NULL,
	[Time] [nvarchar](max) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[OrderNum] [numeric](18, 0) NULL,
	[TotalOrderNum] [numeric](18, 0) NULL,
	[Waiter_ID] [nvarchar](5) NULL,
	[Waiter] [nvarchar](50) NULL,
	[ID] [nvarchar](5) NULL,
	[Bar_Code2] [nvarchar](20) NULL,
	[QR_Code] [nvarchar](20) NULL,
	[Bar_Code] [nvarchar](20) NULL,
	[Short_Name] [nvarchar](50) NULL,
	[Long_Name] [nvarchar](50) NULL,
	[Colour] [nvarchar](max) NULL,
	[Size] [nvarchar](max) NULL,
	[Packing] [nvarchar](max) NULL,
	[Quantity] [nvarchar](max) NULL,
	[Unit] [nvarchar](max) NULL,
	[Price] [numeric](18, 2) NULL,
	[Qty] [nvarchar](max) NULL,
	[Amount] [numeric](18, 2) NULL,
	[T_Dis] [numeric](18, 2) NULL,
	[Net_Total] [numeric](18, 2) NULL,
	[Price2] [numeric](18, 2) NULL,
	[Qty2] [nvarchar](max) NULL,
	[Unit2] [nvarchar](max) NULL,
	[Per_Pcs] [numeric](18, 2) NULL,
	[Purchase] [numeric](18, 2) NULL,
	[Avg_Price] [numeric](18, 2) NULL,
	[Profit] [numeric](18, 2) NULL,
	[Category_ID] [nvarchar](4) NULL,
	[Category] [nvarchar](max) NULL,
	[Company_ID] [nvarchar](4) NULL,
	[Company] [nvarchar](max) NULL,
	[SupplierID] [nvarchar](5) NULL,
	[Supplier] [nvarchar](50) NULL,
	[ProductType] [nvarchar](max) NULL,
	[TableID] [nvarchar](5) NULL,
	[Table_Name] [nvarchar](50) NULL,
	[Area] [nvarchar](60) NULL,
	[Table_Type] [nvarchar](max) NULL,
	[SalesBillNo] [numeric](18, 0) NULL,
	[Invoice_Type] [nvarchar](50) NULL,
	[Des1] [nvarchar](max) NULL,
	[Des2] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Order_MasterTB]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Order_MasterTB](
	[Date] [date] NULL,
	[Time] [nvarchar](max) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[OrderNum] [numeric](18, 0) NULL,
	[Order_Return] [numeric](18, 0) NULL,
	[TotalOrderNum] [numeric](18, 0) NULL,
	[Order_ReturnTotal] [numeric](18, 0) NULL,
	[Waiter_ID] [nvarchar](5) NULL,
	[Waiter] [nvarchar](60) NULL,
	[Table_ID] [nvarchar](5) NULL,
	[Table_N] [nvarchar](60) NULL,
	[Party_Voc] [numeric](18, 0) NULL,
	[Party_ID] [nvarchar](5) NULL,
	[Party] [nvarchar](50) NULL,
	[Address] [nvarchar](100) NULL,
	[Cell_Number] [nvarchar](15) NULL,
	[Type_Name] [nvarchar](20) NULL,
	[Pre_Balance] [numeric](18, 2) NULL,
	[New_Balance] [numeric](18, 2) NULL,
	[Description1] [nvarchar](max) NULL,
	[Area] [nvarchar](max) NULL,
	[ID] [nvarchar](5) NULL,
	[Bar_Code2] [nvarchar](20) NULL,
	[QR_Code] [nvarchar](20) NULL,
	[Bar_Code] [nvarchar](20) NULL,
	[Short_Name] [nvarchar](50) NULL,
	[Long_Name] [nvarchar](50) NULL,
	[Colour] [nvarchar](max) NULL,
	[Size] [nvarchar](max) NULL,
	[Packing] [nvarchar](max) NULL,
	[Quantity] [nvarchar](max) NULL,
	[Unit] [nvarchar](max) NULL,
	[Price] [numeric](18, 2) NULL,
	[Qty] [nvarchar](max) NULL,
	[Amount] [numeric](18, 2) NULL,
	[Discount] [numeric](18, 2) NULL,
	[Discountper] [numeric](18, 2) NULL,
	[GiftDis] [numeric](18, 2) NULL,
	[T_Dis] [numeric](18, 2) NULL,
	[Net_Total] [numeric](18, 2) NULL,
	[Price2] [numeric](18, 2) NULL,
	[Qty2] [nvarchar](max) NULL,
	[Unit2] [nvarchar](max) NULL,
	[Amount2] [numeric](18, 2) NULL,
	[Dis2] [numeric](18, 2) NULL,
	[Per_Pcs] [numeric](18, 2) NULL,
	[DisPer] [numeric](18, 2) NULL,
	[GiftDis2] [numeric](18, 2) NULL,
	[Total2] [numeric](18, 2) NULL,
	[Purchase] [numeric](18, 2) NULL,
	[Avg_Price] [numeric](18, 2) NULL,
	[Profit] [numeric](18, 2) NULL,
	[Low_Stock] [numeric](18, 2) NULL,
	[Category_ID] [nvarchar](4) NULL,
	[Category] [nvarchar](max) NULL,
	[Company_ID] [nvarchar](4) NULL,
	[Company] [nvarchar](max) NULL,
	[Supplier_ID] [nvarchar](5) NULL,
	[Supplier] [nvarchar](max) NULL,
	[Difference] [numeric](18, 2) NULL,
	[Sales_Type] [nchar](10) NULL,
	[Des1] [numeric](18, 0) NULL,
	[Des2] [numeric](18, 0) NULL,
	[Des3] [numeric](18, 0) NULL,
	[Des4] [nvarchar](max) NULL,
	[Des5] [nvarchar](max) NULL,
	[Gross_Total] [numeric](18, 2) NULL,
	[Table_Type] [nvarchar](max) NULL,
	[Invoice_Type] [nvarchar](max) NULL,
	[Ref_No] [nvarchar](max) NULL,
	[SalesBillNo] [numeric](18, 0) NULL,
	[Description5] [nvarchar](max) NULL,
	[Description6] [nvarchar](max) NULL,
	[Description7] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Order_Num]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Order_Num](
	[Date] [date] NULL,
	[OrderNum] [numeric](18, 0) NULL,
	[Order_Return] [numeric](18, 0) NULL,
	[Total_Order] [numeric](18, 0) NULL,
	[Total_Order_Return] [numeric](18, 0) NULL,
	[Hold] [numeric](18, 0) NULL,
	[Hold_Return] [numeric](18, 0) NULL,
	[Description] [nvarchar](50) NULL,
	[Invoice_Type] [nvarchar](50) NULL,
	[Branch] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Orderinprogress]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orderinprogress](
	[Date] [date] NULL,
	[Time] [nvarchar](max) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[OrderNum] [numeric](18, 0) NULL,
	[OrderNum_Return] [numeric](18, 0) NULL,
	[OrderNum_Total] [numeric](18, 0) NULL,
	[OrderNumTotal_Return] [numeric](18, 0) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Waiter_ID] [nvarchar](5) NULL,
	[Waiter] [nvarchar](60) NULL,
	[Table_ID] [nvarchar](5) NULL,
	[Table_N] [nvarchar](60) NULL,
	[Area] [nvarchar](60) NULL,
	[Amount] [numeric](18, 2) NULL,
	[OrderType] [nvarchar](50) NULL,
	[Table_Type] [nvarchar](max) NULL,
	[Invoice_Type] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Other_account]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Other_account](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Voc_Num] [numeric](18, 0) NULL,
	[Type_Name] [nvarchar](50) NULL,
	[Account_ID] [nvarchar](5) NULL,
	[Account] [nvarchar](50) NULL,
	[Description] [nvarchar](max) NULL,
	[Transaction_ID] [nvarchar](5) NULL,
	[Transaction_From] [nvarchar](max) NULL,
	[Branch1] [nvarchar](max) NULL,
	[Account_NO] [nvarchar](max) NULL,
	[Cheque] [nvarchar](max) NULL,
	[Cheque_Amount] [numeric](18, 2) NULL,
	[Cheque_Category] [nvarchar](50) NULL,
	[Cheque_Date] [date] NULL,
	[Cheque_Status] [nvarchar](50) NULL,
	[Debit] [numeric](18, 2) NULL,
	[Credit] [numeric](18, 2) NULL,
	[Currency] [nvarchar](50) NULL,
	[Exchange_Rate] [numeric](18, 2) NULL,
	[Currency_Amount] [numeric](18, 2) NULL,
	[Page1] [nvarchar](50) NULL,
	[Page2] [nvarchar](50) NULL,
	[Ref_NO] [nvarchar](max) NULL,
	[Table_Type] [nvarchar](max) NULL,
	[Description1] [nvarchar](max) NULL,
	[Description2] [nvarchar](max) NULL,
	[Description3] [nvarchar](max) NULL,
	[AccountChecked] [numeric](18, 2) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Other_AccountImage]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Other_AccountImage](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Voc_Num] [numeric](18, 0) NULL,
	[Type_Name] [nvarchar](50) NULL,
	[Account_ID] [nvarchar](5) NULL,
	[Account] [nvarchar](50) NULL,
	[Image] [image] NULL,
	[Table_Type] [nvarchar](max) NULL,
	[Des1] [numeric](18, 0) NULL,
	[Des2] [nvarchar](max) NULL,
	[Des3] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Other_Info]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Other_Info](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Active] [nvarchar](max) NULL,
	[Account_ID] [nvarchar](5) NULL,
	[Account] [nvarchar](60) NULL,
	[Opening_Balance] [numeric](18, 2) NULL,
	[Balance_Type] [nvarchar](max) NULL,
	[Description1] [nvarchar](max) NULL,
	[Description2] [nvarchar](max) NULL,
	[Description3] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PackingShort]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PackingShort](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Acc_ID] [nvarchar](4) NOT NULL,
	[Account] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Parking_Invoicemaster]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Parking_Invoicemaster](
	[Date] [date] NULL,
	[Time] [nvarchar](max) NULL,
	[DateExit] [date] NULL,
	[TimeExit] [nvarchar](max) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Token] [numeric](18, 0) NULL,
	[TotalToken] [numeric](18, 0) NULL,
	[Party_ID] [nvarchar](50) NULL,
	[Party] [nvarchar](50) NULL,
	[Barcode] [nvarchar](20) NULL,
	[CatID] [nvarchar](20) NULL,
	[Catgory] [nvarchar](20) NULL,
	[ID] [nvarchar](20) NULL,
	[Barocde] [nvarchar](20) NULL,
	[Name] [nvarchar](100) NULL,
	[Month] [numeric](18, 2) NULL,
	[Day] [numeric](18, 2) NULL,
	[Hour] [numeric](18, 2) NULL,
	[UnitM] [nvarchar](20) NULL,
	[UnitD] [nvarchar](20) NULL,
	[UnitH] [nvarchar](20) NULL,
	[TimeDuration] [nvarchar](20) NULL,
	[EntryAmt] [numeric](18, 2) NULL,
	[TimeDuration2] [nvarchar](20) NULL,
	[ExitAmt] [numeric](18, 2) NULL,
	[VecName] [nvarchar](200) NULL,
	[In_Out] [nvarchar](20) NULL,
	[VechileType] [nvarchar](30) NULL,
	[Location] [nvarchar](100) NULL,
	[Section] [nvarchar](100) NULL,
	[Remarks] [nvarchar](200) NULL,
	[Des1] [numeric](18, 0) NULL,
	[Des2] [nvarchar](200) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ParkingToken_Num]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ParkingToken_Num](
	[Date] [date] NULL,
	[TOKEN] [numeric](18, 0) NULL,
	[TOTALTOKEN] [numeric](18, 0) NULL,
	[Branch] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Partner_account]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Partner_account](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Invoice2] [numeric](18, 0) NULL,
	[Voc_Num] [numeric](18, 0) NULL,
	[PartnerCode] [numeric](18, 0) NULL,
	[PartnerCodeName] [nvarchar](50) NULL,
	[Party_ID] [nvarchar](5) NULL,
	[Party] [nvarchar](50) NULL,
	[Address] [nvarchar](100) NULL,
	[Cell_Number] [nvarchar](15) NULL,
	[CNIC] [nvarchar](20) NULL,
	[Description] [nvarchar](max) NULL,
	[Transaction_ID] [nvarchar](5) NULL,
	[Transaction_From] [nvarchar](max) NULL,
	[Branch1] [nvarchar](max) NULL,
	[Account_NO] [nvarchar](max) NULL,
	[Cheque] [nvarchar](max) NULL,
	[Cheque_Amount] [numeric](18, 2) NULL,
	[Cheque_Category] [nvarchar](50) NULL,
	[Cheque_Date] [date] NULL,
	[Cheque_Status] [nvarchar](50) NULL,
	[Debit] [numeric](18, 2) NULL,
	[Credit] [numeric](18, 2) NULL,
	[Sales_Return] [numeric](18, 2) NULL,
	[Currency] [nvarchar](50) NULL,
	[Exchange_Rate] [numeric](18, 2) NULL,
	[Currency_Amount] [numeric](18, 2) NULL,
	[InvoiceReceive_Amount] [numeric](18, 2) NULL,
	[InvoiceReceiveNum] [numeric](18, 0) NULL,
	[Sales_PersonID] [nvarchar](5) NULL,
	[Sales_Person] [nvarchar](50) NULL,
	[Page1] [nvarchar](max) NULL,
	[Page2] [nvarchar](max) NULL,
	[Ref_NO] [nvarchar](max) NULL,
	[Table_Type] [nvarchar](max) NULL,
	[Description1] [numeric](18, 0) NULL,
	[Description2] [nvarchar](max) NULL,
	[Description3] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[partner_Info]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[partner_Info](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Image] [image] NULL,
	[Active] [nvarchar](max) NULL,
	[PartnerCode] [numeric](18, 0) NULL,
	[PartnerCodeName] [nvarchar](100) NULL,
	[Party_ID] [nvarchar](5) NULL,
	[Party] [nvarchar](50) NULL,
	[Address] [nvarchar](100) NULL,
	[Tele_Phone] [nvarchar](max) NULL,
	[Cell_Number] [nvarchar](15) NULL,
	[CNIC] [nvarchar](20) NULL,
	[Email] [nvarchar](max) NULL,
	[Message_Alert] [nvarchar](max) NULL,
	[Opening_Balance] [numeric](18, 2) NULL,
	[Balance_Type] [nvarchar](max) NULL,
	[Loan] [numeric](18, 2) NULL,
	[Description1] [nvarchar](max) NULL,
	[Description2] [nvarchar](max) NULL,
	[Description3] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Party_account]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Party_account](
	[Date] [date] NULL,
	[Time] [nvarchar](20) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Invoice2] [numeric](18, 0) NULL,
	[Voc_Num] [numeric](18, 0) NULL,
	[Party_Type] [nvarchar](max) NULL,
	[Type_Name] [nvarchar](max) NULL,
	[Party_ID] [nvarchar](5) NULL,
	[Party] [nvarchar](50) NULL,
	[Address] [nvarchar](100) NULL,
	[Cell_Number] [nvarchar](15) NULL,
	[CNIC] [nvarchar](20) NULL,
	[Description] [nvarchar](max) NULL,
	[Transaction_ID] [nvarchar](5) NULL,
	[Transaction_From] [nvarchar](max) NULL,
	[Branch1] [nvarchar](max) NULL,
	[Account_NO] [nvarchar](max) NULL,
	[Cheque] [nvarchar](max) NULL,
	[Cheque_Amount] [numeric](18, 2) NULL,
	[Cheque_Category] [nvarchar](50) NULL,
	[Cheque_Date] [date] NULL,
	[Cheque_Status] [nvarchar](50) NULL,
	[Debit] [numeric](18, 2) NULL,
	[Credit] [numeric](18, 2) NULL,
	[Sales_Return] [numeric](18, 2) NULL,
	[Currency] [nvarchar](50) NULL,
	[Exchange_Rate] [numeric](18, 2) NULL,
	[Currency_Amount] [numeric](18, 2) NULL,
	[InvoiceReceive_Amount] [numeric](18, 2) NULL,
	[InvoiceReceiveNum] [numeric](18, 0) NULL,
	[Sales_PersonID] [nvarchar](5) NULL,
	[Sales_Person] [nvarchar](50) NULL,
	[Page1] [nvarchar](max) NULL,
	[Page2] [nvarchar](max) NULL,
	[Ref_NO] [nvarchar](max) NULL,
	[Table_Type] [nvarchar](max) NULL,
	[Invoice_Total] [numeric](18, 0) NULL,
	[Description2] [nvarchar](max) NULL,
	[Description3] [nvarchar](max) NULL,
	[AccountChecked] [numeric](18, 2) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Party_account2]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Party_account2](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Invoice2] [numeric](18, 0) NULL,
	[Voc_Num] [numeric](18, 0) NULL,
	[Party_Type] [nvarchar](max) NULL,
	[Type_Name] [nvarchar](max) NULL,
	[Party_ID] [nvarchar](5) NULL,
	[Party] [nvarchar](50) NULL,
	[Address] [nvarchar](100) NULL,
	[Cell_Number] [nvarchar](15) NULL,
	[CNIC] [nvarchar](20) NULL,
	[Description] [nvarchar](max) NULL,
	[Transaction_ID] [nvarchar](5) NULL,
	[Transaction_From] [nvarchar](max) NULL,
	[Branch1] [nvarchar](max) NULL,
	[Account_NO] [nvarchar](max) NULL,
	[Cheque] [nvarchar](max) NULL,
	[Cheque_Amount] [numeric](18, 2) NULL,
	[Cheque_Category] [nvarchar](50) NULL,
	[Cheque_Date] [date] NULL,
	[Cheque_Status] [nvarchar](50) NULL,
	[Debit] [numeric](18, 2) NULL,
	[Credit] [numeric](18, 2) NULL,
	[Sales_Return] [numeric](18, 2) NULL,
	[Currency] [nvarchar](50) NULL,
	[Exchange_Rate] [numeric](18, 2) NULL,
	[Currency_Amount] [numeric](18, 2) NULL,
	[InvoiceReceive_Amount] [numeric](18, 2) NULL,
	[InvoiceReceiveNum] [numeric](18, 0) NULL,
	[Sales_PersonID] [nvarchar](5) NULL,
	[Sales_Person] [nvarchar](50) NULL,
	[Page1] [nvarchar](max) NULL,
	[Page2] [nvarchar](max) NULL,
	[Ref_NO] [nvarchar](max) NULL,
	[Table_Type] [nvarchar](max) NULL,
	[Invoice_Total] [numeric](18, 0) NULL,
	[Description2] [nvarchar](max) NULL,
	[Description3] [nvarchar](max) NULL,
	[AccountChecked] [numeric](18, 2) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Party_Account2Image]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Party_Account2Image](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Invoice2] [numeric](18, 0) NULL,
	[Voc_Num] [numeric](18, 0) NULL,
	[Party_Type] [nvarchar](max) NULL,
	[Type_Name] [nvarchar](max) NULL,
	[Party_ID] [nvarchar](5) NULL,
	[Party] [nvarchar](50) NULL,
	[Address] [nvarchar](100) NULL,
	[Cell_Number] [nvarchar](15) NULL,
	[CNIC] [nvarchar](20) NULL,
	[Image] [image] NULL,
	[Table_Type] [nvarchar](max) NULL,
	[Des1] [numeric](18, 0) NULL,
	[Des2] [nvarchar](max) NULL,
	[Des3] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Party_AccountImage]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Party_AccountImage](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Invoice2] [numeric](18, 0) NULL,
	[Voc_Num] [numeric](18, 0) NULL,
	[Party_Type] [nvarchar](max) NULL,
	[Type_Name] [nvarchar](max) NULL,
	[Party_ID] [nvarchar](5) NULL,
	[Party] [nvarchar](50) NULL,
	[Address] [nvarchar](100) NULL,
	[Cell_Number] [nvarchar](15) NULL,
	[CNIC] [nvarchar](20) NULL,
	[Image] [image] NULL,
	[Table_Type] [nvarchar](max) NULL,
	[Des1] [numeric](18, 0) NULL,
	[Des2] [nvarchar](max) NULL,
	[Des3] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Party_CheckBox]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Party_CheckBox](
	[Form] [nvarchar](max) NULL,
	[DateFocusCheckbox] [nvarchar](max) NULL,
	[ReceiptPrint] [nvarchar](max) NULL,
	[PaymentMode] [nvarchar](max) NULL,
	[AccountID] [nvarchar](max) NULL,
	[Account] [nvarchar](max) NULL,
	[Address] [nvarchar](max) NULL,
	[AccountNum] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[Des] [nvarchar](max) NULL,
	[Des1] [nvarchar](max) NULL,
	[Des2] [nvarchar](max) NULL,
	[Des3] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[party_Info]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[party_Info](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Image] [image] NULL,
	[Active] [nvarchar](max) NULL,
	[Party_Type] [nvarchar](max) NULL,
	[Type_Name] [nvarchar](max) NULL,
	[Party_ID] [nvarchar](5) NULL,
	[Party] [nvarchar](50) NULL,
	[Address] [nvarchar](100) NULL,
	[Tele_Phone] [nvarchar](max) NULL,
	[Cell_Number] [nvarchar](15) NULL,
	[CNIC] [nvarchar](20) NULL,
	[Email] [nvarchar](max) NULL,
	[Message_Alert] [nvarchar](max) NULL,
	[Opening_Balance] [numeric](18, 2) NULL,
	[Balance_Type] [nvarchar](max) NULL,
	[Loan] [numeric](18, 2) NULL,
	[SalesTaxReg] [nvarchar](50) NULL,
	[NationalTaxNo] [nvarchar](50) NULL,
	[SalesMen] [nvarchar](max) NULL,
	[SalesMenID] [nvarchar](10) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[payment_Mode]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[payment_Mode](
	[Payment] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[printer]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[printer](
	[Print_Invoice] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PrinterSelection]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PrinterSelection](
	[Branch] [nvarchar](100) NULL,
	[PC] [nvarchar](100) NULL,
	[Printer] [nvarchar](100) NULL,
	[Form] [nvarchar](100) NULL,
	[PrintType] [nvarchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Product]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Category_ID] [nvarchar](4) NOT NULL,
	[Category] [nvarchar](50) NULL,
	[Product_ID] [numeric](18, 0) NOT NULL,
	[Bar_Code] [nvarchar](22) NULL,
	[Bar_Code2] [nvarchar](22) NULL,
	[Bar_Code3] [nvarchar](max) NULL,
	[Long_Name] [nvarchar](50) NULL,
	[Company_ID] [nvarchar](4) NOT NULL,
	[Company] [nvarchar](max) NULL,
	[Supplier_ID] [nvarchar](5) NULL,
	[Supplier] [nvarchar](100) NULL,
	[Packing] [nvarchar](max) NULL,
	[Quantitynum] [numeric](18, 2) NULL,
	[Packing_Unitnum] [nvarchar](50) NULL,
	[Quantityweight] [numeric](18, 2) NULL,
	[Packing_Unitweight] [nvarchar](max) NULL,
	[Size] [nvarchar](20) NULL,
	[Colour] [nvarchar](20) NULL,
	[Type] [nvarchar](20) NULL,
	[Purchase] [numeric](18, 2) NULL,
	[Hole_Sale] [numeric](18, 2) NULL,
	[Retail] [numeric](18, 2) NULL,
	[Avg_Price] [numeric](18, 2) NULL,
	[Low_Stock] [numeric](18, 2) NULL,
	[Stock] [numeric](18, 2) NULL,
	[Stock_value] [numeric](18, 2) NULL,
	[Image] [image] NULL,
	[Active] [nvarchar](2) NULL,
	[Serial] [numeric](18, 0) NULL,
	[Last_Purchase] [numeric](18, 2) NULL,
	[PriceType] [nvarchar](50) NULL,
	[GrossPurchase] [numeric](18, 2) NULL,
	[DiscountType] [nvarchar](20) NULL,
	[Discount] [numeric](18, 2) NULL,
	[DiscountTotal] [numeric](18, 2) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[product_checkbox]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[product_checkbox](
	[D5] [nvarchar](max) NULL,
	[Cat_MaxID] [nvarchar](max) NULL,
	[Copy_ItemID] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Product1]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product1](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Category_ID] [nvarchar](4) NOT NULL,
	[Category] [nvarchar](50) NULL,
	[Product_ID] [numeric](18, 0) NOT NULL,
	[Bar_Code] [nvarchar](22) NULL,
	[Long_Name] [nvarchar](50) NULL,
	[Company_ID] [nvarchar](4) NOT NULL,
	[Company] [nvarchar](max) NULL,
	[Packing] [nvarchar](max) NULL,
	[Quantity] [nvarchar](max) NULL,
	[Packing_Unit] [nvarchar](max) NULL,
	[Purchase] [numeric](18, 2) NULL,
	[SalePrice1] [numeric](18, 2) NULL,
	[SalePrice2] [numeric](18, 2) NULL,
	[SalePrice3] [numeric](18, 2) NULL,
	[Unit1] [nvarchar](max) NULL,
	[Unit2] [nvarchar](max) NULL,
	[Unit3] [nvarchar](max) NULL,
	[Image] [image] NULL,
	[Active] [nvarchar](2) NULL,
	[Low_Stock] [numeric](18, 2) NULL,
	[Stock] [numeric](18, 2) NULL,
	[Stock_value] [numeric](18, 2) NULL,
	[Supplier_ID] [nvarchar](5) NULL,
	[Supplier] [nvarchar](100) NULL,
	[Serial] [numeric](18, 0) NULL,
	[Des1] [nvarchar](100) NULL,
	[Des2] [nvarchar](100) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProductBarocdPriceHide]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductBarocdPriceHide](
	[Branch] [nvarchar](100) NULL,
	[PC] [nvarchar](100) NULL,
	[PriceHide] [nvarchar](100) NULL,
	[Tag] [nvarchar](100) NULL,
	[Form] [nvarchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Productpricing]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Productpricing](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Product_ID] [nvarchar](22) NOT NULL,
	[Bar_Code] [nvarchar](22) NULL,
	[Long_Name] [nvarchar](50) NULL,
	[Warehouse_ID] [nvarchar](5) NULL,
	[WareHouse] [nvarchar](50) NULL,
	[Auto_Selection] [nvarchar](10) NULL,
	[Purchase] [numeric](18, 2) NULL,
	[Last_Purchase] [numeric](18, 2) NULL,
	[Avg_Price] [numeric](18, 2) NULL,
	[Last_Avg] [numeric](18, 2) NULL,
	[Sales] [numeric](18, 2) NULL,
	[LastSales] [numeric](18, 2) NULL,
	[WholeSale] [numeric](18, 2) NULL,
	[LastWholeSale] [numeric](18, 2) NULL,
	[Packing] [nvarchar](15) NULL,
	[PackingQty] [numeric](18, 2) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[TableType] [nvarchar](15) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Purchase_InvNum]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Purchase_InvNum](
	[Date] [date] NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Invoice_Return] [numeric](18, 0) NULL,
	[Hold] [numeric](18, 0) NULL,
	[Description] [nvarchar](50) NULL,
	[Invoice_Type] [nvarchar](50) NULL,
	[Branch] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Purchase_Master]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Purchase_Master](
	[Date] [date] NULL,
	[Time] [nvarchar](max) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Invoice_Return] [numeric](18, 0) NULL,
	[Invoice_Total] [numeric](18, 0) NULL,
	[Return_Total] [numeric](18, 0) NULL,
	[Waiter_ID] [nvarchar](5) NULL,
	[Waiter] [nvarchar](60) NULL,
	[Table_ID] [nvarchar](5) NULL,
	[Table_N] [nvarchar](60) NULL,
	[Party_Voc] [numeric](18, 0) NULL,
	[Party_ID] [nvarchar](5) NULL,
	[Party] [nvarchar](50) NULL,
	[Address] [nvarchar](100) NULL,
	[Cell_Number] [nvarchar](15) NULL,
	[Type_Name] [nvarchar](20) NULL,
	[Pre_Balance] [numeric](18, 2) NULL,
	[New_Balance] [numeric](18, 2) NULL,
	[Description1] [nvarchar](max) NULL,
	[Description2] [nvarchar](max) NULL,
	[ID] [nvarchar](5) NULL,
	[Bar_Code2] [nvarchar](20) NULL,
	[QR_Code] [nvarchar](20) NULL,
	[Bar_Code] [nvarchar](20) NULL,
	[Short_Name] [nvarchar](50) NULL,
	[Long_Name] [nvarchar](50) NULL,
	[Colour] [nvarchar](20) NULL,
	[Size] [nvarchar](20) NULL,
	[Packing] [nvarchar](max) NULL,
	[Quantity] [nvarchar](max) NULL,
	[Unit] [nvarchar](max) NULL,
	[Price] [numeric](18, 2) NULL,
	[Qty] [nvarchar](max) NULL,
	[Amount] [numeric](18, 2) NULL,
	[Discount] [numeric](18, 2) NULL,
	[Discountper] [numeric](18, 2) NULL,
	[GiftDis] [numeric](18, 2) NULL,
	[T_Dis] [numeric](18, 2) NULL,
	[Net_Total] [numeric](18, 2) NULL,
	[Price2] [numeric](18, 2) NULL,
	[Qty2] [nvarchar](max) NULL,
	[Unit2] [nvarchar](max) NULL,
	[Amount2] [numeric](18, 2) NULL,
	[Dis2] [numeric](18, 2) NULL,
	[Per_Pcs] [numeric](18, 2) NULL,
	[DisPer] [numeric](18, 2) NULL,
	[GiftDis2] [numeric](18, 2) NULL,
	[Total2] [numeric](18, 2) NULL,
	[Purchase] [numeric](18, 2) NULL,
	[Avg_Price] [numeric](18, 2) NULL,
	[Stock] [numeric](18, 2) NULL,
	[Low_Stock] [numeric](18, 2) NULL,
	[Category_ID] [nvarchar](4) NULL,
	[Category] [nvarchar](max) NULL,
	[Company_ID] [nvarchar](4) NULL,
	[Company] [nvarchar](max) NULL,
	[Supplier_ID] [nvarchar](5) NULL,
	[Supplier] [nvarchar](max) NULL,
	[WareHouseAuto] [nvarchar](max) NULL,
	[Sales_Type] [nchar](10) NULL,
	[Des1] [numeric](18, 0) NULL,
	[Des2] [nvarchar](50) NULL,
	[Warehouse_ID] [numeric](18, 0) NULL,
	[WareHouse] [nvarchar](50) NULL,
	[Ware_Address] [nvarchar](max) NULL,
	[Gross_Total] [numeric](18, 2) NULL,
	[FlatDis] [numeric](18, 2) NULL,
	[PerDis] [numeric](18, 2) NULL,
	[PerDisAmt] [numeric](18, 2) NULL,
	[Net_Gross] [numeric](18, 2) NULL,
	[Service_Charges] [numeric](18, 2) NULL,
	[Delivery_Charges] [numeric](18, 2) NULL,
	[Tax_Total] [numeric](18, 2) NULL,
	[Tax_Per] [numeric](18, 2) NULL,
	[Sub_Total] [numeric](18, 2) NULL,
	[Cash_Recived] [numeric](18, 2) NULL,
	[Cash_Charged] [numeric](18, 2) NULL,
	[Cash_Back] [numeric](18, 2) NULL,
	[Cash_back2] [numeric](18, 2) NULL,
	[Comments] [nvarchar](100) NULL,
	[Printer] [nvarchar](max) NULL,
	[PaymentMode] [nvarchar](max) NULL,
	[PaymentDate] [date] NULL,
	[Counter_ID] [nvarchar](5) NULL,
	[Counter] [nvarchar](60) NULL,
	[Counter_Voc] [numeric](18, 0) NULL,
	[Stock_Voc] [numeric](18, 0) NULL,
	[Table_Type] [nvarchar](max) NULL,
	[Invoice_Type] [nvarchar](max) NULL,
	[CommissionType] [nvarchar](50) NULL,
	[BardanaFrom] [nvarchar](50) NULL,
	[Description5] [nvarchar](max) NULL,
	[Bulti] [nvarchar](60) NULL,
	[DriverName] [nvarchar](max) NULL,
	[TransportCompany] [nvarchar](max) NULL,
	[Truck_Num] [nvarchar](max) NULL,
	[Driver_Num] [nvarchar](max) NULL,
	[Bulti_Expense] [numeric](18, 2) NULL,
	[Bardana] [numeric](18, 2) NULL,
	[Loding_Expense] [numeric](18, 2) NULL,
	[Unload_Expense] [numeric](18, 2) NULL,
	[Commission] [numeric](18, 2) NULL,
	[CommissionTotal] [numeric](18, 2) NULL,
	[Sales_PersonID] [nvarchar](5) NULL,
	[Sales_Person] [nvarchar](50) NULL,
	[Qty_W] [numeric](18, 2) NULL,
	[Unit_W] [nvarchar](50) NULL,
	[RateInBill] [numeric](18, 2) NULL,
	[RateType] [nvarchar](10) NULL,
	[RateNew] [numeric](18, 2) NULL,
	[AvgNew] [numeric](18, 2) NULL,
	[sales] [numeric](18, 2) NULL,
	[Margin] [numeric](18, 2) NULL,
	[salesupdate] [numeric](18, 2) NULL,
	[Holesales] [numeric](18, 2) NULL,
	[Margin2] [numeric](18, 2) NULL,
	[Holesalesupdate] [numeric](18, 2) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PurchaseExpense]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PurchaseExpense](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Invoice_Return] [numeric](18, 0) NULL,
	[Invoice_Total] [numeric](18, 0) NULL,
	[Return_Total] [numeric](18, 0) NULL,
	[Party_ID] [nvarchar](5) NULL,
	[Party] [nvarchar](50) NULL,
	[Address] [nvarchar](100) NULL,
	[Cell_Number] [nvarchar](15) NULL,
	[Type_Name] [nvarchar](20) NULL,
	[Rents] [numeric](18, 2) NULL,
	[BardanaExp] [numeric](18, 0) NULL,
	[Loding_Expense] [numeric](18, 2) NULL,
	[Unload_Expense] [numeric](18, 2) NULL,
	[Commission] [numeric](18, 2) NULL,
	[CommissionTotal] [numeric](18, 2) NULL,
	[OtherExp] [numeric](18, 2) NULL,
	[Sales_PersonID] [nvarchar](5) NULL,
	[Sales_Person] [nvarchar](50) NULL,
	[Table_Type] [nvarchar](max) NULL,
	[Invoice_Type] [nvarchar](max) NULL,
	[Description1] [numeric](18, 0) NULL,
	[SalesDate] [date] NULL,
	[SalesInvoice] [numeric](18, 0) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PurchaseTb]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PurchaseTb](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Party_ID] [nvarchar](5) NULL,
	[Party] [nvarchar](50) NULL,
	[Address] [nvarchar](100) NULL,
	[Cell_Number] [nvarchar](15) NULL,
	[ID] [nvarchar](5) NULL,
	[Bar_Code] [nvarchar](20) NULL,
	[Long_Name] [nvarchar](50) NULL,
	[Colour] [nvarchar](max) NULL,
	[Size] [nvarchar](max) NULL,
	[Packing] [nvarchar](max) NULL,
	[Quantity] [nvarchar](max) NULL,
	[Unit] [nvarchar](max) NULL,
	[Price] [numeric](18, 2) NULL,
	[Qty] [numeric](18, 2) NULL,
	[QtyK] [numeric](18, 2) NULL,
	[Amount] [numeric](18, 2) NULL,
	[TransportCompany] [nvarchar](max) NULL,
	[Truck_Num] [nvarchar](max) NULL,
	[Driver_Num] [nvarchar](max) NULL,
	[Sales_PersonID] [nvarchar](5) NULL,
	[Sales_Person] [nvarchar](50) NULL,
	[Table_Type] [nvarchar](max) NULL,
	[Invoice_Total] [numeric](18, 0) NULL,
	[Description2] [numeric](18, 0) NULL,
	[PriceType] [nvarchar](20) NULL,
	[Description4] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RENT_WearHouse]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RENT_WearHouse](
	[Account_Code] [nvarchar](5) NULL,
	[Account] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RentStock_Master]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RentStock_Master](
	[Date] [date] NULL,
	[Time] [nvarchar](max) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Invoice_Return] [numeric](18, 0) NULL,
	[Invoice_Total] [numeric](18, 0) NULL,
	[Return_Total] [numeric](18, 0) NULL,
	[Waiter_ID] [nvarchar](5) NULL,
	[Waiter] [nvarchar](60) NULL,
	[Table_ID] [nvarchar](5) NULL,
	[Table_N] [nvarchar](60) NULL,
	[Party_Voc] [numeric](18, 0) NULL,
	[Party_ID] [nvarchar](5) NULL,
	[Party] [nvarchar](50) NULL,
	[Address] [nvarchar](100) NULL,
	[Cell_Number] [nvarchar](15) NULL,
	[Type_Name] [nvarchar](20) NULL,
	[Pre_Balance] [numeric](18, 2) NULL,
	[New_Balance] [numeric](18, 2) NULL,
	[Description1] [nvarchar](max) NULL,
	[Description2] [nvarchar](max) NULL,
	[ID] [nvarchar](5) NULL,
	[Bar_Code2] [nvarchar](20) NULL,
	[QR_Code] [nvarchar](20) NULL,
	[Bar_Code] [nvarchar](20) NULL,
	[Short_Name] [nvarchar](50) NULL,
	[Long_Name] [nvarchar](50) NULL,
	[Colour] [nvarchar](20) NULL,
	[Size] [nvarchar](20) NULL,
	[Packing] [nvarchar](max) NULL,
	[Quantity] [nvarchar](max) NULL,
	[Unit] [nvarchar](max) NULL,
	[Price] [numeric](18, 2) NULL,
	[Qty] [nvarchar](max) NULL,
	[Amount] [numeric](18, 2) NULL,
	[Discount] [numeric](18, 2) NULL,
	[Discountper] [numeric](18, 2) NULL,
	[GiftDis] [numeric](18, 2) NULL,
	[T_Dis] [numeric](18, 2) NULL,
	[Net_Total] [numeric](18, 2) NULL,
	[Price2] [numeric](18, 2) NULL,
	[Qty2] [nvarchar](max) NULL,
	[Unit2] [nvarchar](max) NULL,
	[Amount2] [numeric](18, 2) NULL,
	[Dis2] [numeric](18, 2) NULL,
	[Per_Pcs] [numeric](18, 2) NULL,
	[DisPer] [numeric](18, 2) NULL,
	[GiftDis2] [numeric](18, 2) NULL,
	[Total2] [numeric](18, 2) NULL,
	[Purchase] [numeric](18, 2) NULL,
	[Avg_Price] [numeric](18, 2) NULL,
	[Stock] [numeric](18, 2) NULL,
	[Low_Stock] [numeric](18, 2) NULL,
	[Category_ID] [nvarchar](4) NULL,
	[Category] [nvarchar](max) NULL,
	[Company_ID] [nvarchar](4) NULL,
	[Company] [nvarchar](max) NULL,
	[Supplier_ID] [nvarchar](5) NULL,
	[Supplier] [nvarchar](max) NULL,
	[WareHouseAuto] [nvarchar](max) NULL,
	[Sales_Type] [nchar](10) NULL,
	[Des1] [numeric](18, 0) NULL,
	[Des2] [nvarchar](50) NULL,
	[Warehouse_ID] [numeric](18, 0) NULL,
	[WareHouse] [nvarchar](50) NULL,
	[Ware_Address] [nvarchar](max) NULL,
	[Gross_Total] [numeric](18, 2) NULL,
	[FlatDis] [numeric](18, 2) NULL,
	[PerDis] [numeric](18, 2) NULL,
	[PerDisAmt] [numeric](18, 2) NULL,
	[Net_Gross] [numeric](18, 2) NULL,
	[Service_Charges] [numeric](18, 2) NULL,
	[Delivery_Charges] [numeric](18, 2) NULL,
	[Tax_Total] [numeric](18, 2) NULL,
	[Tax_Per] [numeric](18, 2) NULL,
	[Sub_Total] [numeric](18, 2) NULL,
	[Cash_Recived] [numeric](18, 2) NULL,
	[Cash_Charged] [numeric](18, 2) NULL,
	[Cash_Back] [numeric](18, 2) NULL,
	[Cash_back2] [numeric](18, 2) NULL,
	[Comments] [nvarchar](100) NULL,
	[Printer] [nvarchar](max) NULL,
	[PaymentMode] [nvarchar](max) NULL,
	[PaymentDate] [date] NULL,
	[Counter_ID] [nvarchar](5) NULL,
	[Counter] [nvarchar](60) NULL,
	[Counter_Voc] [numeric](18, 0) NULL,
	[Stock_Voc] [numeric](18, 0) NULL,
	[Table_Type] [nvarchar](max) NULL,
	[Invoice_Type] [nvarchar](max) NULL,
	[CommissionType] [nvarchar](50) NULL,
	[BardanaFrom] [nvarchar](50) NULL,
	[Description5] [nvarchar](max) NULL,
	[Bulti] [nvarchar](60) NULL,
	[DriverName] [nvarchar](max) NULL,
	[TransportCompany] [nvarchar](max) NULL,
	[Truck_Num] [nvarchar](max) NULL,
	[Driver_Num] [nvarchar](max) NULL,
	[Bulti_Expense] [numeric](18, 2) NULL,
	[Bardana] [numeric](18, 2) NULL,
	[Loding_Expense] [numeric](18, 2) NULL,
	[Unload_Expense] [numeric](18, 2) NULL,
	[Commission] [numeric](18, 2) NULL,
	[CommissionTotal] [numeric](18, 2) NULL,
	[Sales_PersonID] [nvarchar](5) NULL,
	[Sales_Person] [nvarchar](50) NULL,
	[Qty_W] [numeric](18, 2) NULL,
	[Unit_W] [nvarchar](50) NULL,
	[RateInBill] [numeric](18, 2) NULL,
	[RateType] [nvarchar](10) NULL,
	[RateNew] [numeric](18, 2) NULL,
	[AvgNew] [numeric](18, 2) NULL,
	[sales] [numeric](18, 2) NULL,
	[Margin] [numeric](18, 2) NULL,
	[salesupdate] [numeric](18, 2) NULL,
	[Holesales] [numeric](18, 2) NULL,
	[Margin2] [numeric](18, 2) NULL,
	[Holesalesupdate] [numeric](18, 2) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RentStockExp]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RentStockExp](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Invoice_Return] [numeric](18, 0) NULL,
	[Invoice_Total] [numeric](18, 0) NULL,
	[Return_Total] [numeric](18, 0) NULL,
	[Party_ID] [nvarchar](5) NULL,
	[Party] [nvarchar](50) NULL,
	[Address] [nvarchar](100) NULL,
	[Cell_Number] [nvarchar](15) NULL,
	[Type_Name] [nvarchar](20) NULL,
	[Rents] [numeric](18, 2) NULL,
	[BardanaExp] [numeric](18, 0) NULL,
	[Loding_Expense] [numeric](18, 2) NULL,
	[Unload_Expense] [numeric](18, 2) NULL,
	[Commission] [numeric](18, 2) NULL,
	[CommissionTotal] [numeric](18, 2) NULL,
	[OtherExp] [numeric](18, 2) NULL,
	[Sales_PersonID] [nvarchar](5) NULL,
	[Sales_Person] [nvarchar](50) NULL,
	[Table_Type] [nvarchar](max) NULL,
	[Invoice_Type] [nvarchar](max) NULL,
	[Description1] [numeric](18, 0) NULL,
	[SalesDate] [date] NULL,
	[SalesInvoice] [numeric](18, 0) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RentStockInvNum]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RentStockInvNum](
	[Date] [date] NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Invoice_Return] [numeric](18, 0) NULL,
	[Hold] [numeric](18, 0) NULL,
	[Description] [nvarchar](50) NULL,
	[Invoice_Type] [nvarchar](50) NULL,
	[Branch] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RentStockLadger]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RentStockLadger](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Purchase_In] [numeric](18, 0) NULL,
	[Purchase_Out] [numeric](18, 0) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Invoice_Return] [numeric](18, 0) NULL,
	[Audit_Serial] [numeric](18, 0) NULL,
	[Party] [nvarchar](80) NULL,
	[Godedown] [nvarchar](80) NULL,
	[Category] [nvarchar](50) NULL,
	[Company] [nvarchar](50) NULL,
	[Supplier] [nvarchar](50) NULL,
	[Product_ID] [nvarchar](22) NOT NULL,
	[Bar_Code] [nvarchar](22) NULL,
	[Product] [nvarchar](50) NULL,
	[Packing] [nvarchar](50) NULL,
	[Quantitynum] [numeric](18, 2) NULL,
	[Packing_Unitnum] [nvarchar](50) NULL,
	[Quantityweight] [numeric](18, 2) NULL,
	[Packing_Unitweight] [nvarchar](max) NULL,
	[Size] [nvarchar](20) NULL,
	[Colour] [nvarchar](20) NULL,
	[Type] [nvarchar](20) NULL,
	[Purchase] [numeric](18, 2) NULL,
	[Avg_Purchase] [numeric](18, 2) NULL,
	[Stock_In] [numeric](18, 2) NULL,
	[Purchase_Return] [numeric](18, 2) NULL,
	[Stock_Out] [numeric](18, 2) NULL,
	[Stock_Return] [numeric](18, 2) NULL,
	[Bonus_Damage] [numeric](18, 2) NULL,
	[Amount_In] [numeric](18, 2) NULL,
	[Amount_PReturn] [numeric](18, 2) NULL,
	[Amount_Out] [numeric](18, 2) NULL,
	[Amount_Return] [numeric](18, 2) NULL,
	[Amount_BD] [numeric](18, 2) NULL,
	[Sales_Amount] [numeric](18, 2) NULL,
	[Sales_Return] [numeric](18, 2) NULL,
	[Low_Stock] [numeric](18, 2) NULL,
	[Expiry_Date] [date] NULL,
	[PartnerCode] [nvarchar](100) NULL,
	[PartnerNum] [nvarchar](10) NULL,
	[Sales_Person] [nvarchar](50) NULL,
	[StockRS] [nvarchar](50) NULL,
	[LotID] [numeric](18, 0) NULL,
	[PkQty] [numeric](18, 2) NULL,
	[Pk] [nvarchar](10) NULL,
	[Remarks] [nvarchar](max) NULL,
	[Table_Type] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[RentStockTb]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RentStockTb](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Party_ID] [nvarchar](5) NULL,
	[Party] [nvarchar](50) NULL,
	[Address] [nvarchar](100) NULL,
	[Cell_Number] [nvarchar](15) NULL,
	[ID] [nvarchar](5) NULL,
	[Bar_Code] [nvarchar](20) NULL,
	[Long_Name] [nvarchar](50) NULL,
	[Colour] [nvarchar](max) NULL,
	[Size] [nvarchar](max) NULL,
	[Packing] [nvarchar](max) NULL,
	[Quantity] [nvarchar](max) NULL,
	[Unit] [nvarchar](max) NULL,
	[Price] [numeric](18, 2) NULL,
	[Qty] [numeric](18, 2) NULL,
	[QtyK] [numeric](18, 2) NULL,
	[Amount] [numeric](18, 2) NULL,
	[TransportCompany] [nvarchar](max) NULL,
	[Truck_Num] [nvarchar](max) NULL,
	[Driver_Num] [nvarchar](max) NULL,
	[Sales_PersonID] [nvarchar](5) NULL,
	[Sales_Person] [nvarchar](50) NULL,
	[Table_Type] [nvarchar](max) NULL,
	[Invoice_Total] [numeric](18, 0) NULL,
	[Description2] [nvarchar](max) NULL,
	[PriceType] [nvarchar](20) NULL,
	[Description4] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Sales]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sales](
	[Date] [date] NULL,
	[Time] [nvarchar](max) NULL,
	[User_Name] [nvarchar](150) NULL,
	[Branch] [nvarchar](200) NULL,
	[PC] [nvarchar](50) NULL,
	[Record] [nvarchar](max) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Invoice_Total] [numeric](18, 0) NULL,
	[Party_ID] [nvarchar](5) NULL,
	[Party] [nvarchar](50) NULL,
	[ID] [nvarchar](5) NULL,
	[Bar_Code2] [nvarchar](20) NULL,
	[QR_Code] [nvarchar](20) NULL,
	[Bar_Code] [nvarchar](20) NULL,
	[Short_Name] [nvarchar](50) NULL,
	[Long_Name] [nvarchar](50) NULL,
	[Colour] [nvarchar](20) NULL,
	[Size] [nvarchar](20) NULL,
	[Packing] [nvarchar](20) NULL,
	[Quantity] [nvarchar](max) NULL,
	[Unit] [nvarchar](max) NULL,
	[Price] [numeric](18, 2) NULL,
	[Qty] [numeric](18, 2) NULL,
	[Amount] [numeric](18, 2) NULL,
	[T_Dis] [numeric](18, 2) NULL,
	[Net_Total] [numeric](18, 2) NULL,
	[Price2] [numeric](18, 2) NULL,
	[Qty2] [nvarchar](max) NULL,
	[Unit2] [nvarchar](max) NULL,
	[Per_Pcs] [numeric](18, 2) NULL,
	[Purchase] [numeric](18, 2) NULL,
	[Avg_Price] [numeric](18, 2) NULL,
	[Profit] [numeric](18, 2) NULL,
	[Category_ID] [nvarchar](4) NULL,
	[Category] [nvarchar](80) NULL,
	[Company_ID] [nvarchar](4) NULL,
	[Company] [nvarchar](80) NULL,
	[SupplierID] [nvarchar](5) NULL,
	[Supplier] [nvarchar](50) NULL,
	[ProductType] [nvarchar](max) NULL,
	[Sales_PersonID] [nvarchar](5) NULL,
	[Sales_Person] [nvarchar](50) NULL,
	[Warehouse_ID] [numeric](18, 0) NULL,
	[WareHouse] [nvarchar](50) NULL,
	[Table_Type] [nvarchar](max) NULL,
	[CashAmt] [numeric](18, 2) NULL,
	[Ser_Per] [numeric](18, 2) NULL,
	[Ser_Amout] [numeric](18, 2) NULL,
	[Description1] [numeric](18, 0) NULL,
	[Description2] [numeric](18, 0) NULL,
	[Qty_W] [numeric](18, 2) NULL,
	[Unit_W] [nvarchar](50) NULL,
	[RateInBill] [numeric](18, 2) NULL,
	[RateType] [nvarchar](10) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Sales_New]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sales_New](
	[Date] [date] NULL,
	[Time] [nvarchar](max) NULL,
	[User_Name] [nvarchar](150) NULL,
	[Branch] [nvarchar](200) NULL,
	[PC] [nvarchar](50) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Invoice_Total] [numeric](18, 0) NULL,
	[Party_ID] [nvarchar](5) NULL,
	[Party] [nvarchar](50) NULL,
	[Sales_Person] [nvarchar](50) NULL,
	[WareHouse] [nvarchar](50) NULL,
	[PartnerShipCode] [nchar](10) NULL,
	[Partner] [nchar](10) NULL,
	[ID] [nvarchar](5) NULL,
	[Bar_Code] [nvarchar](20) NULL,
	[Product] [nvarchar](80) NULL,
	[Colour] [nvarchar](20) NULL,
	[Size] [nvarchar](20) NULL,
	[ProductType] [nvarchar](max) NULL,
	[Packing] [nvarchar](15) NULL,
	[QtyNum] [numeric](18, 2) NULL,
	[UnitNum] [nchar](10) NULL,
	[QtyK] [numeric](18, 2) NULL,
	[UnitK] [nchar](10) NULL,
	[PriceN] [numeric](18, 2) NULL,
	[PriceK] [numeric](18, 2) NULL,
	[Qty] [numeric](18, 2) NULL,
	[Unit] [nchar](10) NULL,
	[Qtyinkg] [numeric](18, 2) NULL,
	[UnitinKg] [nchar](10) NULL,
	[Amount] [numeric](18, 2) NULL,
	[T_Dis] [numeric](18, 2) NULL,
	[Net_Total] [numeric](18, 2) NULL,
	[Purchase] [numeric](18, 2) NULL,
	[Avg] [numeric](18, 2) NULL,
	[Profit] [numeric](18, 2) NULL,
	[CashRec] [numeric](18, 2) NULL,
	[CatID] [nvarchar](10) NULL,
	[Category] [nvarchar](80) NULL,
	[ComID] [nvarchar](50) NULL,
	[Company] [nvarchar](80) NULL,
	[SupplerID] [nvarchar](50) NULL,
	[Supplier] [nvarchar](50) NULL,
	[Table_Type] [nvarchar](max) NULL,
	[Des1] [nchar](10) NULL,
	[Des2] [nchar](10) NULL,
	[Des3] [nchar](10) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Sales_Tab]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sales_Tab](
	[Date] [date] NULL,
	[Time] [nvarchar](max) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Invoice_Rest] [numeric](18, 0) NULL,
	[Party_ID] [nvarchar](5) NULL,
	[Party] [nvarchar](50) NULL,
	[ID] [nvarchar](5) NULL,
	[Bar_Code2] [nvarchar](20) NULL,
	[QR_Code] [nvarchar](20) NULL,
	[Bar_Code] [nvarchar](20) NULL,
	[Short_Name] [nvarchar](50) NULL,
	[Long_Name] [nvarchar](50) NULL,
	[Colour] [nvarchar](max) NULL,
	[Size] [nvarchar](max) NULL,
	[Packing] [nvarchar](max) NULL,
	[Quantity] [nvarchar](max) NULL,
	[Unit] [nvarchar](max) NULL,
	[Price] [numeric](18, 2) NULL,
	[Qty] [nvarchar](max) NULL,
	[Amount] [numeric](18, 2) NULL,
	[T_Dis] [numeric](18, 2) NULL,
	[Net_Total] [numeric](18, 2) NULL,
	[Price2] [numeric](18, 2) NULL,
	[Qty2] [nvarchar](max) NULL,
	[Unit2] [nvarchar](max) NULL,
	[Per_Pcs] [numeric](18, 2) NULL,
	[Purchase] [numeric](18, 2) NULL,
	[Avg_Price] [numeric](18, 2) NULL,
	[Profit] [numeric](18, 2) NULL,
	[Category_ID] [nvarchar](4) NULL,
	[Category] [nvarchar](max) NULL,
	[Company_ID] [nvarchar](4) NULL,
	[Company] [nvarchar](max) NULL,
	[Table_Type] [nvarchar](max) NULL,
	[Description1] [numeric](18, 0) NULL,
	[Description2] [numeric](18, 0) NULL,
	[Description3] [nvarchar](max) NULL,
	[Description4] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Sales2]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sales2](
	[Date] [date] NULL,
	[Time] [nvarchar](max) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Invoice_Total] [numeric](18, 0) NULL,
	[Waiter_ID] [nvarchar](5) NULL,
	[Waiter] [nvarchar](50) NULL,
	[ID] [nvarchar](5) NULL,
	[Bar_Code2] [nvarchar](20) NULL,
	[QR_Code] [nvarchar](20) NULL,
	[Bar_Code] [nvarchar](20) NULL,
	[Short_Name] [nvarchar](50) NULL,
	[Long_Name] [nvarchar](50) NULL,
	[Colour] [nvarchar](max) NULL,
	[Size] [nvarchar](max) NULL,
	[Packing] [nvarchar](max) NULL,
	[Quantity] [nvarchar](max) NULL,
	[Unit] [nvarchar](max) NULL,
	[Price] [numeric](18, 2) NULL,
	[Qty] [numeric](18, 2) NULL,
	[Amount] [numeric](18, 2) NULL,
	[T_Dis] [numeric](18, 2) NULL,
	[Net_Total] [numeric](18, 2) NULL,
	[Price2] [numeric](18, 2) NULL,
	[Qty2] [nvarchar](max) NULL,
	[Unit2] [nvarchar](max) NULL,
	[Per_Pcs] [numeric](18, 2) NULL,
	[Purchase] [numeric](18, 2) NULL,
	[Avg_Price] [numeric](18, 2) NULL,
	[Profit] [numeric](18, 2) NULL,
	[Category_ID] [nvarchar](4) NULL,
	[Category] [nvarchar](80) NULL,
	[Company_ID] [nvarchar](4) NULL,
	[Company] [nvarchar](80) NULL,
	[SupplierID] [nvarchar](5) NULL,
	[Supplier] [nvarchar](50) NULL,
	[ProductType] [nvarchar](max) NULL,
	[TableID] [nvarchar](5) NULL,
	[Table_Name] [nvarchar](50) NULL,
	[Area] [nvarchar](60) NULL,
	[Table_Type] [nvarchar](max) NULL,
	[Description4] [numeric](18, 0) NULL,
	[Description5] [numeric](18, 0) NULL,
	[Description6] [nvarchar](50) NULL,
	[Description7] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SalesPOS]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SalesPOS](
	[Date] [date] NULL,
	[Time] [nvarchar](20) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Invoice_Total] [numeric](18, 0) NULL,
	[Party_ID] [nvarchar](5) NULL,
	[Party] [nvarchar](50) NULL,
	[ID] [nvarchar](5) NULL,
	[Bar_Code2] [nvarchar](20) NULL,
	[QR_Code] [nvarchar](20) NULL,
	[Bar_Code] [nvarchar](20) NULL,
	[Short_Name] [nvarchar](50) NULL,
	[Long_Name] [nvarchar](50) NULL,
	[Colour] [nvarchar](max) NULL,
	[Size] [nvarchar](max) NULL,
	[Packing] [nvarchar](max) NULL,
	[Quantity] [numeric](18, 2) NULL,
	[Unit] [nvarchar](max) NULL,
	[Price] [numeric](18, 2) NULL,
	[Qty] [numeric](18, 2) NULL,
	[Amount] [numeric](18, 2) NULL,
	[T_Dis] [numeric](18, 2) NULL,
	[Net_Total] [numeric](18, 2) NULL,
	[Price2] [numeric](18, 2) NULL,
	[Qty2] [numeric](18, 2) NULL,
	[Unit2] [nvarchar](max) NULL,
	[Per_Pcs] [numeric](18, 2) NULL,
	[Purchase] [numeric](18, 2) NULL,
	[Avg_Price] [numeric](18, 2) NULL,
	[Profit] [numeric](18, 2) NULL,
	[Category_ID] [nvarchar](4) NULL,
	[Category] [nvarchar](50) NULL,
	[Company_ID] [nvarchar](4) NULL,
	[Company] [nvarchar](max) NULL,
	[SupplierID] [nvarchar](5) NULL,
	[Supplier] [nvarchar](50) NULL,
	[ProductType] [nvarchar](max) NULL,
	[Sales_PersonID] [nvarchar](5) NULL,
	[Sales_Person] [nvarchar](50) NULL,
	[Warehouse_ID] [numeric](18, 0) NULL,
	[WareHouse] [nvarchar](50) NULL,
	[Table_Type] [nvarchar](max) NULL,
	[CashAmt] [numeric](18, 2) NULL,
	[Ser_Per] [numeric](18, 2) NULL,
	[Ser_Amout] [numeric](18, 2) NULL,
	[Description1] [numeric](18, 0) NULL,
	[Description2] [numeric](18, 0) NULL,
	[Description3] [nvarchar](max) NULL,
	[Description4] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SalesR]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SalesR](
	[Date] [date] NULL,
	[Time] [nvarchar](max) NULL,
	[User_Name] [nvarchar](150) NULL,
	[Branch] [nvarchar](200) NULL,
	[PC] [nvarchar](50) NULL,
	[Record] [nvarchar](max) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Invoice_Total] [numeric](18, 0) NULL,
	[Party_ID] [nvarchar](5) NULL,
	[Party] [nvarchar](50) NULL,
	[ID] [nvarchar](5) NULL,
	[Bar_Code2] [nvarchar](20) NULL,
	[QR_Code] [nvarchar](20) NULL,
	[Bar_Code] [nvarchar](20) NULL,
	[Short_Name] [nvarchar](50) NULL,
	[Long_Name] [nvarchar](50) NULL,
	[Colour] [nvarchar](20) NULL,
	[Size] [nvarchar](20) NULL,
	[Packing] [nvarchar](20) NULL,
	[Quantity] [nvarchar](max) NULL,
	[Unit] [nvarchar](max) NULL,
	[Price] [numeric](18, 2) NULL,
	[Qty] [numeric](18, 2) NULL,
	[Amount] [numeric](18, 2) NULL,
	[T_Dis] [numeric](18, 2) NULL,
	[Net_Total] [numeric](18, 2) NULL,
	[Price2] [numeric](18, 2) NULL,
	[Qty2] [nvarchar](max) NULL,
	[Unit2] [nvarchar](max) NULL,
	[Per_Pcs] [numeric](18, 2) NULL,
	[Purchase] [numeric](18, 2) NULL,
	[Avg_Price] [numeric](18, 2) NULL,
	[Profit] [numeric](18, 2) NULL,
	[Category_ID] [nvarchar](4) NULL,
	[Category] [nvarchar](80) NULL,
	[Company_ID] [nvarchar](4) NULL,
	[Company] [nvarchar](80) NULL,
	[SupplierID] [nvarchar](5) NULL,
	[Supplier] [nvarchar](50) NULL,
	[ProductType] [nvarchar](max) NULL,
	[Sales_PersonID] [nvarchar](5) NULL,
	[Sales_Person] [nvarchar](50) NULL,
	[Warehouse_ID] [numeric](18, 0) NULL,
	[WareHouse] [nvarchar](50) NULL,
	[Table_Type] [nvarchar](max) NULL,
	[CashAmt] [numeric](18, 2) NULL,
	[Ser_Per] [numeric](18, 2) NULL,
	[Ser_Amout] [numeric](18, 2) NULL,
	[Description1] [numeric](18, 0) NULL,
	[Description2] [numeric](18, 0) NULL,
	[Qty_W] [numeric](18, 2) NULL,
	[Unit_W] [nvarchar](50) NULL,
	[RateInBill] [numeric](18, 2) NULL,
	[RateType] [nvarchar](10) NULL,
	[SalesDate] [date] NULL,
	[SalesInvoice] [numeric](18, 0) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SalesReturnPOS]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SalesReturnPOS](
	[Date] [date] NULL,
	[Time] [nvarchar](20) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Invoice_Total] [numeric](18, 0) NULL,
	[Party_ID] [nvarchar](5) NULL,
	[Party] [nvarchar](50) NULL,
	[ID] [nvarchar](5) NULL,
	[Bar_Code2] [nvarchar](20) NULL,
	[QR_Code] [nvarchar](20) NULL,
	[Bar_Code] [nvarchar](20) NULL,
	[Short_Name] [nvarchar](50) NULL,
	[Long_Name] [nvarchar](50) NULL,
	[Colour] [nvarchar](max) NULL,
	[Size] [nvarchar](max) NULL,
	[Packing] [nvarchar](max) NULL,
	[Quantity] [numeric](18, 2) NULL,
	[Unit] [nvarchar](max) NULL,
	[Price] [numeric](18, 2) NULL,
	[Qty] [numeric](18, 2) NULL,
	[Amount] [numeric](18, 2) NULL,
	[T_Dis] [numeric](18, 2) NULL,
	[Net_Total] [numeric](18, 2) NULL,
	[Price2] [numeric](18, 2) NULL,
	[Qty2] [numeric](18, 2) NULL,
	[Unit2] [nvarchar](max) NULL,
	[Per_Pcs] [numeric](18, 2) NULL,
	[Purchase] [numeric](18, 2) NULL,
	[Avg_Price] [numeric](18, 2) NULL,
	[Profit] [numeric](18, 2) NULL,
	[Category_ID] [nvarchar](4) NULL,
	[Category] [nvarchar](50) NULL,
	[Company_ID] [nvarchar](4) NULL,
	[Company] [nvarchar](max) NULL,
	[SupplierID] [nvarchar](5) NULL,
	[Supplier] [nvarchar](50) NULL,
	[ProductType] [nvarchar](max) NULL,
	[Sales_PersonID] [nvarchar](5) NULL,
	[Sales_Person] [nvarchar](50) NULL,
	[Warehouse_ID] [numeric](18, 0) NULL,
	[WareHouse] [nvarchar](50) NULL,
	[Table_Type] [nvarchar](max) NULL,
	[CashAmt] [numeric](18, 2) NULL,
	[Ser_Per] [numeric](18, 2) NULL,
	[Ser_Amout] [numeric](18, 2) NULL,
	[Description1] [numeric](18, 0) NULL,
	[Description2] [numeric](18, 0) NULL,
	[Description3] [nvarchar](max) NULL,
	[Description4] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Stock_Ladger]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Stock_Ladger](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Purchase_In] [numeric](18, 0) NULL,
	[Purchase_Out] [numeric](18, 0) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Invoice_Return] [numeric](18, 0) NULL,
	[Audit_Serial] [numeric](18, 0) NULL,
	[Party] [nvarchar](80) NULL,
	[Godedown] [nvarchar](80) NULL,
	[Category] [nvarchar](50) NULL,
	[Company] [nvarchar](50) NULL,
	[Supplier] [nvarchar](50) NULL,
	[Product_ID] [nvarchar](22) NOT NULL,
	[Bar_Code] [nvarchar](22) NULL,
	[Product] [nvarchar](50) NULL,
	[Packing] [nvarchar](50) NULL,
	[Quantitynum] [numeric](18, 2) NULL,
	[Packing_Unitnum] [nvarchar](50) NULL,
	[Quantityweight] [numeric](18, 2) NULL,
	[Packing_Unitweight] [nvarchar](max) NULL,
	[Size] [nvarchar](20) NULL,
	[Colour] [nvarchar](20) NULL,
	[Type] [nvarchar](20) NULL,
	[Purchase] [numeric](18, 2) NULL,
	[Avg_Purchase] [numeric](18, 2) NULL,
	[Stock_In] [numeric](18, 2) NULL,
	[Purchase_Return] [numeric](18, 2) NULL,
	[Stock_Out] [numeric](18, 2) NULL,
	[Stock_Return] [numeric](18, 2) NULL,
	[Bonus_Damage] [numeric](18, 2) NULL,
	[Amount_In] [numeric](18, 2) NULL,
	[Amount_PReturn] [numeric](18, 2) NULL,
	[Amount_Out] [numeric](18, 2) NULL,
	[Amount_Return] [numeric](18, 2) NULL,
	[Amount_BD] [numeric](18, 2) NULL,
	[Sales_Amount] [numeric](18, 2) NULL,
	[Sales_Return] [numeric](18, 2) NULL,
	[Low_Stock] [numeric](18, 2) NULL,
	[Expiry_Date] [date] NULL,
	[PartnerCode] [nvarchar](100) NULL,
	[PartnerNum] [nvarchar](10) NULL,
	[Sales_Person] [nvarchar](50) NULL,
	[StockRS] [nvarchar](50) NULL,
	[LotID] [numeric](18, 0) NULL,
	[PkQty] [numeric](18, 2) NULL,
	[Pk] [nvarchar](10) NULL,
	[Remarks] [nvarchar](max) NULL,
	[Table_Type] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[StockAudit]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StockAudit](
	[Date] [date] NULL,
	[Branch] [nvarchar](50) NULL,
	[Audit_Serial] [numeric](18, 0) NULL,
	[OldPurchase] [numeric](18, 2) NULL,
	[NewPurchase] [numeric](18, 2) NULL,
	[CheckBox] [nchar](10) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[StockTransferTb1]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StockTransferTb1](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[RecNum] [numeric](18, 0) NULL,
	[StockSetting] [nvarchar](50) NULL,
	[StockType] [nvarchar](50) NULL,
	[ID] [numeric](18, 0) NULL,
	[Barcode] [nvarchar](20) NULL,
	[Name] [nvarchar](50) NULL,
	[Qty] [numeric](18, 2) NULL,
	[Unit] [nvarchar](20) NULL,
	[Qty2] [numeric](18, 2) NULL,
	[Price] [numeric](18, 2) NULL,
	[RateB] [numeric](18, 2) NULL,
	[NewPurchase] [numeric](18, 2) NULL,
	[Amount] [numeric](18, 2) NULL,
	[Wasted] [numeric](18, 2) NULL,
	[WastedAmt] [numeric](18, 2) NULL,
	[Expense] [numeric](18, 2) NULL,
	[ExpenseTotal] [numeric](18, 2) NULL,
	[NetAmt] [numeric](18, 2) NULL,
	[Price2] [numeric](18, 2) NULL,
	[Unit2] [nvarchar](20) NULL,
	[LowStock] [nvarchar](20) NULL,
	[CategoryID] [nvarchar](10) NULL,
	[Category] [nvarchar](50) NULL,
	[CompanyID] [nvarchar](10) NULL,
	[Company] [nvarchar](50) NULL,
	[Difference] [nvarchar](20) NULL,
	[AvePrice] [numeric](18, 2) NULL,
	[Des1] [nchar](10) NULL,
	[Des2] [nchar](10) NULL,
	[WareHouseID] [nvarchar](10) NULL,
	[WareHouse] [nvarchar](50) NULL,
	[Address] [nvarchar](50) NULL,
	[SupplierID] [nvarchar](10) NULL,
	[Supplier] [nvarchar](50) NULL,
	[Colour] [nvarchar](20) NULL,
	[Size] [nvarchar](20) NULL,
	[ProductType] [nvarchar](20) NULL,
	[QtyWeight] [nvarchar](20) NULL,
	[PackingWeight] [nvarchar](20) NULL,
	[RateType] [nvarchar](20) NULL,
	[OtherExp] [numeric](18, 2) NULL,
	[Remarks] [nvarchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[StockTransferTB2]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StockTransferTB2](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[RecNum] [numeric](18, 0) NULL,
	[StockSetting] [nvarchar](50) NULL,
	[AccountFrom] [nvarchar](50) NULL,
	[Account] [nvarchar](50) NULL,
	[Amount] [numeric](18, 2) NULL,
	[ID] [nvarchar](10) NULL,
	[Address] [nvarchar](50) NULL,
	[Mobile] [nvarchar](20) NULL,
	[Cnic] [nvarchar](20) NULL,
	[AccType] [nvarchar](20) NULL,
	[TypeID] [nvarchar](20) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Table_Info]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Table_Info](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Active] [nvarchar](max) NULL,
	[Account_ID] [numeric](18, 0) NULL,
	[Account] [nvarchar](60) NULL,
	[Area] [nvarchar](60) NULL,
	[Opening_Balance] [numeric](18, 2) NULL,
	[Balance_Type] [nvarchar](max) NULL,
	[Description1] [nvarchar](max) NULL,
	[Description2] [nvarchar](max) NULL,
	[Description3] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Table_Return]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Table_Return](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Voc] [numeric](18, 0) NULL,
	[Table_ID] [nvarchar](5) NULL,
	[Table_N] [nvarchar](60) NULL,
	[Bar_Code2] [nvarchar](20) NULL,
	[QR_Code] [nvarchar](20) NULL,
	[Bar_Code] [nvarchar](20) NULL,
	[Long_Name] [nvarchar](50) NULL,
	[Colour] [nvarchar](max) NULL,
	[Size] [nvarchar](max) NULL,
	[Packing] [nvarchar](max) NULL,
	[Quantity] [nvarchar](max) NULL,
	[Unit] [nvarchar](max) NULL,
	[Price] [numeric](18, 2) NULL,
	[Qty] [nvarchar](max) NULL,
	[Amount] [numeric](18, 2) NULL,
	[Description1] [numeric](18, 0) NULL,
	[Description2] [numeric](18, 0) NULL,
	[Description3] [nvarchar](max) NULL,
	[Description4] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Table_Sales]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Table_Sales](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Voc] [numeric](18, 0) NULL,
	[Table_ID] [nvarchar](5) NULL,
	[Table_N] [nvarchar](60) NULL,
	[Bar_Code2] [nvarchar](20) NULL,
	[QR_Code] [nvarchar](20) NULL,
	[Bar_Code] [nvarchar](20) NULL,
	[Long_Name] [nvarchar](50) NULL,
	[Colour] [nvarchar](max) NULL,
	[Size] [nvarchar](max) NULL,
	[Packing] [nvarchar](max) NULL,
	[Quantity] [nvarchar](max) NULL,
	[Unit] [nvarchar](max) NULL,
	[Price] [numeric](18, 2) NULL,
	[Qty] [nvarchar](max) NULL,
	[Amount] [numeric](18, 2) NULL,
	[Description1] [numeric](18, 0) NULL,
	[Description2] [numeric](18, 0) NULL,
	[Description3] [nvarchar](max) NULL,
	[Description4] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[theme]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[theme](
	[Checkbox] [nvarchar](50) NULL,
	[PC] [nvarchar](50) NULL,
	[Branch] [nvarchar](50) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Waiter_Info]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Waiter_Info](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Image] [image] NULL,
	[Active] [nvarchar](max) NULL,
	[Waiter_ID] [nvarchar](max) NULL,
	[Waiter] [nvarchar](50) NULL,
	[Address] [nvarchar](100) NULL,
	[Cell_Number] [nvarchar](15) NULL,
	[CNIC] [nvarchar](20) NULL,
	[Email] [nvarchar](max) NULL,
	[Sallary] [nvarchar](20) NULL,
	[Category] [nvarchar](max) NULL,
	[Opening_Balance] [numeric](18, 2) NULL,
	[Balance_Type] [nvarchar](max) NULL,
	[Description1] [nvarchar](max) NULL,
	[Description2] [nvarchar](max) NULL,
	[Description3] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[waiter_Return]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[waiter_Return](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Voc] [numeric](18, 0) NULL,
	[Waiter_ID] [nvarchar](5) NULL,
	[Waiter] [nvarchar](60) NULL,
	[Bar_Code2] [nvarchar](20) NULL,
	[QR_Code] [nvarchar](20) NULL,
	[Bar_Code] [nvarchar](20) NULL,
	[Long_Name] [nvarchar](50) NULL,
	[Colour] [nvarchar](max) NULL,
	[Size] [nvarchar](max) NULL,
	[Packing] [nvarchar](max) NULL,
	[Quantity] [nvarchar](max) NULL,
	[Unit] [nvarchar](max) NULL,
	[Price] [numeric](18, 2) NULL,
	[Qty] [nvarchar](max) NULL,
	[Amount] [numeric](18, 2) NULL,
	[Description1] [numeric](18, 0) NULL,
	[Description2] [numeric](18, 0) NULL,
	[Description3] [nvarchar](max) NULL,
	[Description4] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[waiter_Sales]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[waiter_Sales](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Invoice] [numeric](18, 0) NULL,
	[Voc] [numeric](18, 0) NULL,
	[Waiter_ID] [nvarchar](5) NULL,
	[Waiter] [nvarchar](60) NULL,
	[Bar_Code2] [nvarchar](20) NULL,
	[QR_Code] [nvarchar](20) NULL,
	[Bar_Code] [nvarchar](20) NULL,
	[Long_Name] [nvarchar](50) NULL,
	[Colour] [nvarchar](max) NULL,
	[Size] [nvarchar](max) NULL,
	[Packing] [nvarchar](max) NULL,
	[Quantity] [nvarchar](max) NULL,
	[Unit] [nvarchar](max) NULL,
	[Price] [numeric](18, 2) NULL,
	[Qty] [numeric](18, 2) NULL,
	[Amount] [numeric](18, 2) NULL,
	[Description1] [numeric](18, 0) NULL,
	[Description2] [numeric](18, 0) NULL,
	[Description3] [nvarchar](max) NULL,
	[Description4] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Warehouse_Info]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Warehouse_Info](
	[Date] [date] NULL,
	[Time] [nvarchar](50) NULL,
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Record] [nvarchar](max) NULL,
	[Active] [nvarchar](max) NULL,
	[Warehouse_ID] [nvarchar](5) NULL,
	[WareHouse] [nvarchar](50) NULL,
	[Address] [nvarchar](max) NULL,
	[City] [nvarchar](max) NULL,
	[Contact] [nvarchar](max) NULL,
	[Auto_Selection] [nvarchar](max) NULL,
	[Description1] [nvarchar](max) NULL,
	[Description2] [nvarchar](max) NULL,
	[Description3] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Warehouse_RS]    Script Date: 4/6/2023 12:07:49 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Warehouse_RS](
	[User_Name] [nvarchar](max) NULL,
	[Branch] [nvarchar](max) NULL,
	[PC] [nvarchar](max) NULL,
	[Location] [nvarchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
USE [master]
GO
ALTER DATABASE [TSC_DB] SET  READ_WRITE 
GO
