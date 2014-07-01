
/*	Hierarchical Data
	-------------------------------------------------------------------
	http://blogs.msdn.com/b/manisblog/archive/2007/08/17/sql-server-2008-hierarchyid.aspx
	
Moving Nodes and Subnodes 
	http://sqlblogcasts.com/blogs/simons/archive/2008/03/31/SQL-Server-2008---HierarchyId---How-do-you-move-nodes-subtrees-around.aspx

*/

DECLARE @xml XML

SET @xml = '
<Root>
    <Info Name="Sql Server">
		 <Info Name="XML Support" />
		 <Info Name="Output clause" />
		 <Info Name="Output clause" />
        <Info Name="How To">
            <Info Name="Move HirarchyID" />
        </Info>
        <Info Name="Rowset Constructor">
			<Info Name="insert into table(id, name) values (''id1'', ''id2'')" />
			<Info Name="Process multiple in one transaction" />
		</Info>
    </Info>
</Root>';


	WITH CTE_ITEMS ([HId], [Infos], [Name], [Path]) 
AS 
( 
    SELECT  
        hierarchyid::GetRoot() as [HId], 
        VIRT.node.query('./*') as [Infos], 
        VIRT.node.value('@Name', 'nvarchar(500)') as [Name], 
        CAST('/' as nvarchar(max)) as [Path] 
        FROM @xml.nodes('/Root/*') as VIRT(node) 
    UNION ALL 
    SELECT  
        hierarchyid::Parse([HId].ToString() + VIRT.node.value('1+count(for $a in . return $a/../*[. << $a])', 'varchar(10)') + '/'), 
        VIRT.node.query('./*'),  
        VIRT.node.value('@Name', 'nvarchar(500)'), 
        [Path] +  
            CASE [Path] WHEN '/' THEN '' ELSE + '/' END +  
            VIRT.node.value('@Name', 'nvarchar(max)') 
    FROM  
    CTE_ITEMS CROSS APPLY Infos.nodes('./*') as VIRT(node) 
) 
SELECT [HId].ToString(),[Name],[Path],[HId].GetLevel() FROM CTE_ITEMS 
ORDER BY [HId] 
