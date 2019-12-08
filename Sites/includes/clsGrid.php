<?php
require "config.php";

require_once "clsDatabase.php";
class dbGrid{
    public $con;
    public $headerBorderWidth;
    public $cellBorderWidth;
    public $colWidth = array();
    public $rowHeight = array();
    public $sql;
    public $filter;
    
    /*public $dataSourceType = dsType::Sql;*/
    
    public function doGrid($pTitle){
        
        echo "<div class='grid-container'>";
        $hdrBgStyle = "style='background-color: rgba(184, 201, 92, 0.596)";
        $rowCount = 0;
        $maxRows = 25;
        $sakila = new sakila(); 
        if ($results = $sakila->actorsFilms($pTitle)){
            echo "<div class='grid-item'".$hdrBgStyle.";'><h2>"."Movie title"."<h2/></div>";
            echo "<div class='grid-item'".$hdrBgStyle.";'><h2>"." Star first name"."<h2/></div>";
            echo "<div class='grid-col-hdr-item'".$hdrBgStyle.";'><h2>"."last name"."<h2/></div>";
        
            while  (($rowCount < $maxRows) && ($row = mysqli_fetch_assoc($results))) {
                
                    echo "<div>".$row["title"]."</div>";
                    echo "<div>".$row["first_name"]."</div>";
                    echo "<div>".$row["last_name"]."</div>";
                    $rowCount++;
            
          }
        }
        
       
    }
            
}