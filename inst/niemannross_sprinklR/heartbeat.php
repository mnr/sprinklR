<?php

  // Takes raw data from the request
  $json = file_get_contents('php://input');

  // save to a local file
  $fp = fopen("heartbeat_data.json", "w") ;
  fwrite($fp, $json) ;
  fclose($fp);

  exit();
?>

