<?php


class clsDemo{
  public $demoString = "myDemoString";
}

class clsSampleQuery{

  public function demoQuery(){
    // PHP constant DIRECTORY_SEPARATOR will resolve correct form of / or \
    // depending on whether unix or windows web server.
    //if (include '.' . DIRECTORY_SEPARATOR . 'config.php'){
    if (include 'config.php'){
    $con = new mysqli($dbSettings['host'], $dbSettings['username'], $dbSettings['pwd'], $dbSettings['dbName']);
    $message = $con->query("SELECT message FROM myTable")->fetch_object()->message;
    $con->close();
    echo "Hello From Sites Folder!";
    return $message;
    }
  }
  public $demoString2 = "mydbClassString";
}

class Sales{

  public function getAllProductNames(){
    if (include 'config.php'){
      $con = new mysqli($dbSettings['host'], $dbSettings['WebUserName'], $dbSettings['WebUserPwd'], $dbSettings['dbName']);
      $sql = "CALL p_productsList()";
      $query = $con->multi_query($sql);
      while ($con->more_results()){
          if ($result = $con->store_result()) {
              while ($row = mysqli_fetch_assoc($result)) {
                  echo "row = ".$row["ProdName"]."<br />";
                }
                mysqli_free_result($result);
          }else{echo "no results";}
          mysqli_next_result($con);
      }
    }
  }
}
