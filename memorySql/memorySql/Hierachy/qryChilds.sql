
/*	-------------------------------------------------------------------
	Sql Server 20008	HierarchyID Data Type

						Hierarchy Queries
	
	
	Resources			http://blogs.msdn.com/b/manisblog/archive/2007/08/17/sql-server-2008-hierarchyid.aspx
	
						Moving Nodes and Subnodes 
						http://sqlblogcasts.com/blogs/simons/archive/2008/03/31/SQL-Server-2008---HierarchyId---How-do-you-move-nodes-subtrees-around.aspx
	--------------------------------------------------------------------------------------------------------------------------------------------------------- */

	-- select * from #tblInfo where Text = 'Europe'
	drop table #tblInfo
	create table #tblInfo
	(
		[Id]		INT				NOT NULL identity PRIMARY KEY, 
		[Text]		VARCHAR(1000)	NOT NULL, 
		[iDate]		DATETIME NULL	DEFAULT getdate(), 
		[hid]		hierarchyid
	)
	--	create records
		insert into #tblInfo(hid, text)
		values
		('/1/', 'Europe'),
		('/2/', 'South America'),
		('/1/1/', 'France'),
		('/1/1/1/', 'Paris'),
		('/1/2/1/', 'Madrid'),
		('/1/2/', 'Spain'),
		('/3/', 'Antarctica'),
		('/2/1/', 'Brazil'),
		('/2/1/1/', 'Brasilia'),
		('/2/1/2/', 'Bahia'),
		('/2/1/2/1/', 'Salvador'),
		('/3/1/', 'McMurdo Station')


				select	c.*
				from	#tblInfo	c
				 join	#tblInfo	p
				   on	p.Text = 'South America'
				where	c.hid.IsDescendantOf(p.hid)	= 1

		-- find all child of South America		
			--	first level
				select	c.*
				from	#tblInfo	c
				 join	#tblInfo	p
				   on	p.Text = 'South America'
				where	p.hid = c.hid.GetAncestor(1)	
			 
			--	second level
				select	c.*
				from	#tblInfo	c
				 join	#tblInfo	p
				   on	p.Text = 'South America'
				where	p.hid = c.hid.GetAncestor(2)	



				select	c.*
				from	#tblInfo	c
				 join	#tblInfo	p
				   on	p.Text = 'South America'
				where	p.hid = c.hid.GetAncestor(3)


				select	c.*
				from	#tblInfo	c
				 join	#tblInfo	p
				   on	p.Text = 'South America'
				where	p.hid = c.hid.GetAncestor(4)


