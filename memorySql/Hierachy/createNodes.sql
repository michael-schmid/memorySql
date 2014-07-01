
/*	-------------------------------------------------------------------
	Sql Server 20008	HierarchyID Data Type

						add new nedes to existing hierarchy	
	
	
	Resources			http://blogs.msdn.com/b/manisblog/archive/2007/08/17/sql-server-2008-hierarchyid.aspx
	
						Moving Nodes and Subnodes 
						http://sqlblogcasts.com/blogs/simons/archive/2008/03/31/SQL-Server-2008---HierarchyId---How-do-you-move-nodes-subtrees-around.aspx
	--------------------------------------------------------------------------------------------------------------------------------------------------------- */

create table #tblInfo
(
	[Id]		INT				NOT NULL identity PRIMARY KEY, 
    [Text]		VARCHAR(1000)	NOT NULL, 
    [iDate]		DATETIME NULL	DEFAULT getdate(), 
    [hid]		hierarchyid
)

--	select	* from	#tblInfo		; truncate table #tblInfo

--	add a root object		: there can be multiple
	insert into dbo.#tblInfo (
			hid, text
	)
	values	(HIERARCHYID::GetRoot(), 'Root1' );
		
--	add child
	-- get the parent node hid
		declare  @parent hierarchyid = (select hid from #tblInfo where text = 'Root1')	

	--	get
		declare @lastChild hierarchyid = (
			select	max(hid) 
			from	#tblInfo
			where	hid.GetAncestor(1) = @parent
		);
	--	
		declare @newChild hierarchyid = @parent.GetDescendant(@lastChild, NULL);
		
		insert into #tblInfo(text, hId) 
		--- output inserted.Id					--	into @newID
		values ('new child node',   @newChild)

	--	reuturn created id
		print SCOPE_IDENTITY()

	--	Result
		select * from #tblInfo

