/**	-----------------------------------------------------------------------------
		Hierarchical Structure without an Explicit Single Root

		Instead having multiple Roots as the root level

	---------------------------------------------------------------------------**/

--	create a table for storing hierarchical folder structure
	drop table folders

	create table [folders]	(
		[ID]		[int]			IDENTITY(1,1) NOT NULL	,
		[Name]		[varchar](50)	NOT NULL				,
		[Hierarchy] [hierarchyid]	NOT NULL				
	) ON [PRIMARY] 

	--	create root folders
	insert into dbo.folders	 (Name,  Hierarchy)
    values  (
		'Pictures'
    	   ,hierarchyid::GetRoot().GetDescendant(
				(select MAX(hierarchy) from folders where hierarchy.GetAncestor(1) = hierarchyid::GetRoot()),
				NULL)
	)

	insert into dbo.folders	 (Name,  Hierarchy)
	values  (
		'Documents'
    	   ,hierarchyid::GetRoot().GetDescendant(
				(select MAX(hierarchy) from folders where hierarchy.GetAncestor(1) = hierarchyid::GetRoot()),
				NULL)
	)

	insert into dbo.folders	 (Name,  Hierarchy)
	values  (
		'Media'
    	   ,hierarchyid::GetRoot().GetDescendant(
				(select MAX(hierarchy) from folders where hierarchy.GetAncestor(1) = hierarchyid::GetRoot()),
				NULL)
	)
	--	get the result
		select	* ,
				hierarchy.GetLevel(), 
				hierarchy.ToString()
		from	folders




