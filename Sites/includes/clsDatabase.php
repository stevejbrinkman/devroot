<?php

class clsSampleQuery{
  
  public function demoQuery(){
    // PHP constant DIRECTORY_SEPARATOR will resolve correct form of / or \
    // depending on whether unix or windows web server.
    //if (include '.' . DIRECTORY_SEPARATOR . 'config.php'){
    if (require 'config.php'){
    $con = new mysqli($dbSettings['host'], $dbSettings['username'], $dbSettings['pwd'], $dbSettings['dbName']);
    $message = $con->query("SELECT message FROM myTable")->fetch_object()->message;
    $con->close();
    echo "Hello From Sites Folder!";
    return $message;
    }
  }
  public $demoString2 = "mydbClassString";
}

class sakila{
  public function connect(){
    mysqli_report(MYSQLI_REPORT_STRICT);
      if (require 'config.php'){
        try{
          return new mysqli($dbSettings['host'], $dbSettings['WebUserName'], $dbSettings['WebUserPwd'], $dbSettings['sakilaDbName']);
          
        }
        catch (Exception $e) {
          echo $e->getMessage();
          return;
        }
    }

  }

  /** Use stored proc to get films and actors join */
  public function actorsFilms($pTitle){
      $con = $this->connect();
      if (!$con){return;}

      $sql = "CALL Actors_Films('".$pTitle."')";
      $query = $con->multi_query($sql);
      if ($result = $con->store_result()){
        $con->close();
        return $result;
      }
      else{
        echo "no results in Actors_Films";
        $con->close();
        return;
      }

  }
  /** Get all movie titles */
  public function getMovies($title=""){
    $con = $this->connect();
      if (!$con){return;}

      $sql = "SELECT title FROM film".$where;
      if ($con->multi_query($sql)){
        if ($result = $con->store_result()){
          $con->close();
          return $result;
        }
        else{
          echo "no results in movies";
          $con->close();
          return;
        }
      } else echo $con->error;
    }
}

class Sales{

  public function getAllProductNames(){
    if (require 'config.php'){
      $con = new mysqli($dbSettings['host'], $dbSettings['WebUserName'], $dbSettings['WebUserPwd'], $dbSettings['dbName']);
      $sql = "CALL p_productsList()";
      $query = $con->multi_query($sql);
      while ($con->more_results()){
          if ($result = $con->store_result()) {
              while ($row = mysqli_fetch_assoc($result)) {
                /*foreach(array_keys($row) as $paramName)
                        echo $paramName . "<br>";*/
                  echo "row = ".$row["ProdName"]."<br />";
                }
                mysqli_free_result($result);
          }else{echo "no results";}
          mysqli_next_result($con);
      }
    }
  }
}
