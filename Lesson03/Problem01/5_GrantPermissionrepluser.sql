:setvar Publisher "Neptune\SQL2016"
:setvar DatabaseName "AdventureWorks"
:setvar PublicationName "AdventureWorks-Tran_Pub"
:setvar Login "repluser"

:CONNECT $(Publisher)


USE [master]
GO
CREATE LOGIN [repluser] WITH PASSWORD=N'repl@User123', 
DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

USE $(DatabaseName)

CREATE USER [repluser] FOR LOGIN [repluser]
GO
-- add user to publication access list (PAL)
EXECUTE sp_grant_publication_access 
	@publication = "$(PublicationName)", 
	@login= "$(Login)"
