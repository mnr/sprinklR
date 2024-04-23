<?php

  // Takes raw data from the request
  $json = file_get_contents('php://input');

  // check for valid json input
  if (isset($json['wbz_rainfall'])) {

    // add dateTime to json
    $json_tmp = json_decode($json, true) ;
    $json_tmp['modified'] = date("Y-m-d H:i:s") ;
    $json = json_encode($json_tmp) ;

    // save to a local file
    $fp = fopen("heartbeat_data.json", "w") ;
    fwrite($fp, $json) ;
    fclose($fp);
  }

  exit();
?>

