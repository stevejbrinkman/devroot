<html lang="en">

<head>

  <title>Document</title>
  <script type="text/javascript" src="Index.js"></script>
  <?php require 'includes/config.php' ?>
</head>

<body>
  <H1>hello Steve</H1><br />
  <div>
    <?php
        require 'includes/clsDatabase.php';

        $demoDB = new clsSampleQuery;
        if ($demoDB){
          echo "<br/>";
          $dbMessage = $demoDB->demoQuery();
          echo "<br/>".$dbMessage;
        } else{
          echo "demoDB is null";
        }
        $salesClass = new Sales;
        if ($salesClass){
          echo "<br/>";
          $salesClass->getAllProductNames();
        } else {
            echo "salesClass is null";
        }


       ?>
  </div>
  <script>
    //demo function declared early in HTML that must be called after the elements have been read by DOM
    function go() {
      //document.write(square(4)) --creates new page with only this element
      document.getElementById('tst1').innerHTML = greet("steve", "brinkman");
      document.getElementById('tst2').innerHTML = square(4);
    }
  </script>
  <br />
  <div id="tst2"></div>
  <input type="button" onclick="go()" value="run external javascript" />
  <br>
  <input type="button" onclick="getfilenames()" value="run getfiles" />
  <br/>
  <a href="grid.php"> Grid Page<a/>
  <div id="tst1"></div>

  <p id="countdown">timer</p>
  <div id="tstImage"></div>
  <div> "try php"
    <br />
    <?php
        include_once 'includes/class.php';
        $newClass = new curseFilter();

        echo $newClass->clean("what a jerk!");
        echo "<br/>";
        echo $newClass->origStr;
        echo "<br/>";
        echo "this is php"
        ?>
  </div><br />

  <div id="keypress"></div><br />

  <div id="fileList">
    <?php
        include_once 'includes/fileList.php';
    ?>
  </div>



  <script>
    document.onkeyup = function(e) {
      //if (e.keyCode==90 && e.ctrlKey)
      document.getElementById("keypress").innerHTML = e.keyCode;
    };
  </script>

  <script>
    //  ** timer using setInterval(func, checkEvery) function
    var intervalSecs = 4
    var countDownDate = new Date().getTime() + (1000 * intervalSecs);
    var imgNum = 1

    var x = setInterval(function() {
        // Get today's date and time
        var now = new Date().getTime();
        // Find the distance between now and the count down date
        var timeTill = countDownDate - now;
        var seconds = Math.floor((timeTill % (1000 * 60)) / 1000);
        var imgTag = '<img src="images/img' + imgNum + '.jpg" style="height: 360px; width: 760px"/>';

        document.getElementById("countdown").innerHTML = seconds + " seconds ";
        document.getElementById("tstImage").innerHTML = imgTag;
        if (timeTill < 0) {
          //clearInterval(x);
          //Change picture at expiration of timer.
          imgNum < 5 ? imgNum += 1 : imgNum = 1
          imgTag = '<img src="images/img' + String(imgNum) + '.jpg" style="height: 360px; width: 760px"/>';
          document.getElementById("tstImage").innerHTML = imgTag;

          countDownDate = new Date().getTime() + (1000 * intervalSecs);
          now = new Date().getTime();
          timeTill = countDownDate - now;
          // Or just start over when end it reached by reloading page
          //location.reload(true);
        }
      },
      1000); //check every 1000 ms
  </script>

</body>

</html>
