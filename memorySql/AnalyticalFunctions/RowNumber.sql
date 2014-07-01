
/*	-------------------------------------------------------------------
	Row_number()
	
	
	Sql Server		2008, Oracle			
	
	--------------------------------------------------------------------------------------------------------------------------------------------------------- */

	-- drop table #object
	create table #object
	(
		[Id]				int				NOT NULL identity PRIMARY KEY	, 
		[Name]				varchar(1000)	NOT NULL						, 
		[Created]			datetime NULL	DEFAULT getdate()				,
		[Modified]			datetime NULL	DEFAULT getdate()				,
		type				varchar(10)		not null						,
		description			varchar(100)	not null
	)
	--	create records
		insert into #object(Name, Created, Modified, type, description)
		select	o.Name, create_date created, modify_date modified, o.type, o.type_desc
		from	sys.objects	o

	--	get a numbering for the rows and rows per partition
		select	ID, Name, description,
				ROW_NUMBER() over (order by name)								TableRowNumber		,			
				ROW_NUMBER() over (partition by description order by name)		PartitionRowNumber	
		from	#object
		order	by
				Name

	
	