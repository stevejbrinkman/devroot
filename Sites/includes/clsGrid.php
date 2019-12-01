<?php
include "config.php";
class dbGrid{
    public $con;
    public $headerBorderWidth;
    public $cellBorderWidth;
    public $colWidth = array();
    public $rowHeight = array();


    public function connect($host, $usr, $pwd, $db){
        $con = new mysqli($dbSettings['host'], $dbSettings['username'], $dbSettings['pwd'], $dbSettings['dbName']);
    }
    public function doGrid(){
        echo "<div class='grid-container'>";
        echo "<div class='grid-item'>1</div>";
        echo "<div class='grid-item'>22</div>";
        echo "<div class='grid-item'>333</div>";
        echo "<div/>";
    }
            

}