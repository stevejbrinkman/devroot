<!DOCTYPE html>
<html>
    <head>
        <link href="grid.css" rel="stylesheet" type="text/css" />
    </head>
    <body>

        <h1>Grid Elements</h1>

        <p>A Grid Layout must have a parent element with the <em>display</em> property set to <em>grid</em> or <em>inline-grid</em>.</p>

        <p>Direct child element(s) of the grid container automatically becomes grid items.</p>
        
        <?php
            include "includes/clsGrid.php";

            if($gridClass = new dbGrid()){
                $gridClass->doGrid();
            }else {echo "gridClass is nil";}
            
          
        ?>
        

    </body>
</html>