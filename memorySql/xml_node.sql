
/*	Node Information

*/

DECLARE @xml XML


Node.js
	Callback function
	Modules
		fs Filesystem
		nodejs.org/api
	Code Organization
		Modules 
			Export
			Import
	Express.js


SET @xml = '
<Root>
    <Info Name="Node.js">
		
		 <Info Name="Express.js" />
		 
        
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
