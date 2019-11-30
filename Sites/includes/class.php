<?php
class curseFilter{
    function clean($str){
        $this->origStr = $str;
        $curswords = array("jerk", "buttface", "idiot");
        $replacers = array("j**k", "cuteface", "id**t");
        $cleanStr = str_ireplace($curswords, $replacers, $str);
        return $cleanStr;
    }
    public $origStr = "orig";
}

?>