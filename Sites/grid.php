<!DOCTYPE html>
<html>
    <head>
    
        <link href="grid.css" rel="stylesheet" type="text/css" />
        <link href="genericstyles.css" rel="stylesheet" type="text/css" />
        
    </head>
    <body>

        <h1>CSS Grid</h1>

        <p>A Grid Layout must have a parent element with the <em>display</em> property set to <em>grid</em> or <em>inline-grid</em>.</p>

        <p>Direct child element(s) of the grid container automatically becomes grid items.</p>
        <form action='grid.php' method='post'>
            Select Movie: 
            <select name="title" id="title">
                <option value="select">select</option>
                <?php
                    require "includes/clsDatabase.php";
                    if($db = new sakila()){
                        $movies = $db->getMovies();
                        while  ($row = mysqli_fetch_assoc($movies)) {
                
                            echo "<option value='".$row['title']."'>".$row['title']."</option>";
                    
                  }
                    }else {echo "sakila object is nil";}
            
                ?>
                
            </select>
            <br/>
            <input id="mysubmit" type="submit" value="Submit"  /><br/>
           
        <form/>
        
        <?php
            $pTitle = $_POST["title"];
            
            require "includes/clsGrid.php";
            if($gridClass = new dbGrid()){
                $gridClass->doGrid($pTitle);
            }else {echo "gridClass is nil";}
            
        ?>
        

    </body>
</html>